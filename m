Return-Path: <linux-kernel-owner+w=401wt.eu-S1755476AbZDNCHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476AbZDNCHv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 22:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755368AbZDNCHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 22:07:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:34498 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755343AbZDNCHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 22:07:02 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       miklos@szeredi.hu, akpm@linux-foundation.org, npiggin@suse.de
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/5] FUSE: make request_wait_answer() wait for ->end() completion
Date: Tue, 14 Apr 2009 11:04:20 +0900
Message-Id: <1239674662-31318-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1239674662-31318-1-git-send-email-tj@kernel.org>
References: <1239674662-31318-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 14 Apr 2009 02:04:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, a request was marked FINISHED before ->end() is executed
and thus request_wait_answer() can return before it's done.  This
patch makes request_wait_answer() wait for ->end() to finish before
returning.

Note that no current ->end() user waits for request completion, so
this change doesn't cause any behavior difference.

While at it, beef up the comment above ->end() hook and clarify when
and where it's called.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/fuse/dev.c    |   41 +++++++++++++++++++++++++----------------
 fs/fuse/fuse_i.h |    5 ++++-
 2 files changed, 29 insertions(+), 17 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 2a17249..2e1c43d 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -278,7 +278,6 @@ __releases(&fc->lock)
 	req->end = NULL;
 	list_del(&req->list);
 	list_del(&req->intr_entry);
-	req->state = FUSE_REQ_FINISHED;
 	if (req->background) {
 		if (fc->num_background == FUSE_MAX_BACKGROUND) {
 			fc->blocked = 0;
@@ -293,10 +292,21 @@ __releases(&fc->lock)
 		fc->active_background--;
 		flush_bg_queue(fc);
 	}
+
 	spin_unlock(&fc->lock);
-	wake_up(&req->waitq);
-	if (end)
+
+	if (end) {
 		end(fc, req);
+		smp_wmb();
+	}
+
+	/*
+	 * We own this request and wake_up() has enough memory
+	 * barrier, no need to grab spin lock to set state.
+	 */
+	req->state = FUSE_REQ_FINISHED;
+
+	wake_up(&req->waitq);
 	fuse_put_request(fc, req);
 }
 
@@ -372,17 +382,16 @@ __acquires(&fc->lock)
 		return;
 
  aborted:
-	BUG_ON(req->state != FUSE_REQ_FINISHED);
-	if (req->locked) {
-		/* This is uninterruptible sleep, because data is
-		   being copied to/from the buffers of req.  During
-		   locked state, there mustn't be any filesystem
-		   operation (e.g. page fault), since that could lead
-		   to deadlock */
-		spin_unlock(&fc->lock);
-		wait_event(req->waitq, !req->locked);
-		spin_lock(&fc->lock);
-	}
+	spin_unlock(&fc->lock);
+	wait_event(req->waitq, req->state == FUSE_REQ_FINISHED);
+	/*
+	 * This is uninterruptible sleep, because data is being copied
+	 * to/from the buffers of req.  During locked state, there
+	 * mustn't be any filesystem operation (e.g. page fault),
+	 * since that could lead to deadlock
+	 */
+	wait_event(req->waitq, !req->locked);
+	spin_lock(&fc->lock);
 }
 
 void fuse_request_send(struct fuse_conn *fc, struct fuse_req *req)
@@ -1060,9 +1069,7 @@ __acquires(&fc->lock)
 
 		req->aborted = 1;
 		req->out.h.error = -ECONNABORTED;
-		req->state = FUSE_REQ_FINISHED;
 		list_del_init(&req->list);
-		wake_up(&req->waitq);
 		if (end) {
 			req->end = NULL;
 			__fuse_get_request(req);
@@ -1072,6 +1079,8 @@ __acquires(&fc->lock)
 			fuse_put_request(fc, req);
 			spin_lock(&fc->lock);
 		}
+		req->state = FUSE_REQ_FINISHED;
+		wake_up(&req->waitq);
 	}
 }
 
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index cdab92d..4da979c 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -291,7 +291,10 @@ struct fuse_req {
 	/** Link on fi->writepages */
 	struct list_head writepages_entry;
 
-	/** Request completion callback */
+	/** Request completion callback.  This function is called from
+	    the kernel context of the FUSE server if the request isn't
+	    being aborted.  If the request is being aborted, it's
+	    called from the kernel context of the aborting process. */
 	void (*end)(struct fuse_conn *, struct fuse_req *);
 
 	/** Request is stolen from fuse_file->reserved_req */
-- 
1.6.0.2

