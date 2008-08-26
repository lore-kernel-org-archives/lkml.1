Return-Path: <linux-kernel-owner+w=401wt.eu-S1757990AbYHZIwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990AbYHZIwo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 04:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753908AbYHZIwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 04:52:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:46721 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753005AbYHZIwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 04:52:20 -0400
From: Tejun Heo <tj@kernel.org>
To: ericvh@gmail.com, rminnich@sandia.gov,
       v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/6] 9p-trans_fd: fix trans_fd::p9_conn_destroy()
Date: Tue, 26 Aug 2008 17:50:52 +0900
Message-Id: <1219740656-26458-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1219740656-26458-1-git-send-email-tj@kernel.org>
References: <1219740656-26458-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 26 Aug 2008 08:52:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

p9_conn_destroy() first kills all current requests by calling
p9_conn_cancel(), then waits for the request list to be cleared by
waiting on p9_conn->equeue.  After that, polling is stopped and the
trans is destroyed.  This sequence has a few problems.

* Read and write works were never cancelled and the p9_conn can be
  destroyed while the works are running as r/w works remove requests
  from the list and dereference the p9_conn from them.

* The list emptiness wait using p9_conn->equeue wouldn't trigger
  because p9_conn_cancel() always clears all the lists and the only
  way the wait can be triggered is to have another task to issue a
  request between the slim window between p9_conn_cancel() and the
  wait, which isn't safe under the current implementation with or
  without the wait.

This patch fixes the problem by first stopping poll, which can
schedule r/w works, first and cancle r/w works which guarantees that
r/w works are not and will not run from that point and then calling
p9_conn_cancel() and do the rest of destruction.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 net/9p/trans_fd.c |   24 +++++-------------------
 1 files changed, 5 insertions(+), 19 deletions(-)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 6a32ffd..ee0d151 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -151,7 +151,6 @@ struct p9_mux_poll_task {
  * @trans: reference to transport instance for this connection
  * @tagpool: id accounting for transactions
  * @err: error state
- * @equeue: event wait_q (?)
  * @req_list: accounting for requests which have been sent
  * @unsent_req_list: accounting for requests that haven't been sent
  * @rcall: current response &p9_fcall structure
@@ -178,7 +177,6 @@ struct p9_conn {
 	struct p9_trans *trans;
 	struct p9_idpool *tagpool;
 	int err;
-	wait_queue_head_t equeue;
 	struct list_head req_list;
 	struct list_head unsent_req_list;
 	struct p9_fcall *rcall;
@@ -430,7 +428,6 @@ static struct p9_conn *p9_conn_create(struct p9_trans *trans)
 	}
 
 	m->err = 0;
-	init_waitqueue_head(&m->equeue);
 	INIT_LIST_HEAD(&m->req_list);
 	INIT_LIST_HEAD(&m->unsent_req_list);
 	m->rcall = NULL;
@@ -483,18 +480,13 @@ static void p9_conn_destroy(struct p9_conn *m)
 {
 	P9_DPRINTK(P9_DEBUG_MUX, "mux %p prev %p next %p\n", m,
 		m->mux_list.prev, m->mux_list.next);
-	p9_conn_cancel(m, -ECONNRESET);
-
-	if (!list_empty(&m->req_list)) {
-		/* wait until all processes waiting on this session exit */
-		P9_DPRINTK(P9_DEBUG_MUX,
-			"mux %p waiting for empty request queue\n", m);
-		wait_event_timeout(m->equeue, (list_empty(&m->req_list)), 5000);
-		P9_DPRINTK(P9_DEBUG_MUX, "mux %p request queue empty: %d\n", m,
-			list_empty(&m->req_list));
-	}
 
 	p9_mux_poll_stop(m);
+	cancel_work_sync(&m->rq);
+	cancel_work_sync(&m->wq);
+
+	p9_conn_cancel(m, -ECONNRESET);
+
 	m->trans = NULL;
 	p9_idpool_destroy(m->tagpool);
 	kfree(m);
@@ -840,8 +832,6 @@ static void p9_read_work(struct work_struct *work)
 					(*req->cb) (req, req->cba);
 				else
 					kfree(req->rcall);
-
-				wake_up(&m->equeue);
 			}
 		} else {
 			if (err >= 0 && rcall->id != P9_RFLUSH)
@@ -984,8 +974,6 @@ static void p9_mux_flush_cb(struct p9_req *freq, void *a)
 			(*req->cb) (req, req->cba);
 		else
 			kfree(req->rcall);
-
-		wake_up(&m->equeue);
 	}
 
 	kfree(freq->tcall);
@@ -1191,8 +1179,6 @@ void p9_conn_cancel(struct p9_conn *m, int err)
 		else
 			kfree(req->rcall);
 	}
-
-	wake_up(&m->equeue);
 }
 
 /**
-- 
1.5.4.5

