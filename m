Return-Path: <linux-kernel-owner+w=401wt.eu-S1757581AbYHZIwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581AbYHZIwa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 04:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753401AbYHZIwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 04:52:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:46720 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752916AbYHZIwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 04:52:20 -0400
From: Tejun Heo <tj@kernel.org>
To: ericvh@gmail.com, rminnich@sandia.gov,
       v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/6] 9p-trans_fd: clean up p9_conn_create()
Date: Tue, 26 Aug 2008 17:50:53 +0900
Message-Id: <1219740656-26458-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1219740656-26458-1-git-send-email-tj@kernel.org>
References: <1219740656-26458-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 26 Aug 2008 08:52:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Use kzalloc() to allocate p9_conn and remove 0/NULL initializations.

* Clean up error return paths.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 net/9p/trans_fd.c |   20 ++++----------------
 1 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index ee0d151..6c88e89 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -407,11 +407,11 @@ static void p9_mux_poll_stop(struct p9_conn *m)
 static struct p9_conn *p9_conn_create(struct p9_trans *trans)
 {
 	int i, n;
-	struct p9_conn *m, *mtmp;
+	struct p9_conn *m;
 
 	P9_DPRINTK(P9_DEBUG_MUX, "transport %p msize %d\n", trans,
 								trans->msize);
-	m = kmalloc(sizeof(struct p9_conn), GFP_KERNEL);
+	m = kzalloc(sizeof(struct p9_conn), GFP_KERNEL);
 	if (!m)
 		return ERR_PTR(-ENOMEM);
 
@@ -422,24 +422,14 @@ static struct p9_conn *p9_conn_create(struct p9_trans *trans)
 	m->trans = trans;
 	m->tagpool = p9_idpool_create();
 	if (IS_ERR(m->tagpool)) {
-		mtmp = ERR_PTR(-ENOMEM);
 		kfree(m);
-		return mtmp;
+		return ERR_PTR(-ENOMEM);
 	}
 
-	m->err = 0;
 	INIT_LIST_HEAD(&m->req_list);
 	INIT_LIST_HEAD(&m->unsent_req_list);
-	m->rcall = NULL;
-	m->rpos = 0;
-	m->rbuf = NULL;
-	m->wpos = m->wsize = 0;
-	m->wbuf = NULL;
 	INIT_WORK(&m->rq, p9_read_work);
 	INIT_WORK(&m->wq, p9_write_work);
-	m->wsched = 0;
-	memset(&m->poll_waddr, 0, sizeof(m->poll_waddr));
-	m->poll_task = NULL;
 	n = p9_mux_poll_start(m);
 	if (n) {
 		kfree(m);
@@ -460,10 +450,8 @@ static struct p9_conn *p9_conn_create(struct p9_trans *trans)
 	for (i = 0; i < ARRAY_SIZE(m->poll_waddr); i++) {
 		if (IS_ERR(m->poll_waddr[i])) {
 			p9_mux_poll_stop(m);
-			mtmp = (void *)m->poll_waddr;	/* the error code */
 			kfree(m);
-			m = mtmp;
-			break;
+			return (void *)m->poll_waddr;	/* the error code */
 		}
 	}
 
-- 
1.5.4.5

