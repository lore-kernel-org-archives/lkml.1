Return-Path: <linux-kernel-owner+w=401wt.eu-S932712AbXHCRyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932712AbXHCRyi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 13:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764680AbXHCRuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 13:50:35 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:34834 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764414AbXHCRud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 13:50:33 -0400
Message-Id: <20070803174957.061232088@szeredi.hu>
References: <20070803174425.998083527@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Fri, 03 Aug 2007 19:44:36 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 10/11] fuse: no abort on interrupt
Content-Disposition: inline; filename=fuse_kill_no_abort.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Don't set 'aborted' flag on a request if it's interrupted.  We have to
wait for the answer anyway, and this would only a very little time
while copying the reply.

This means, that write() on the fuse device will not return -ENOENT
during normal operation, only if the filesystem is aborted by a forced
umount or through the fusectl interface.

This could simplify userspace code somewhat when backward
compatibility with earlier kernel versions is not required.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fuse/dev.c
===================================================================
--- linux.orig/fs/fuse/dev.c	2007-08-03 18:37:24.000000000 +0200
+++ linux/fs/fuse/dev.c	2007-08-03 18:37:25.000000000 +0200
@@ -273,28 +273,41 @@ static void request_wait_answer(struct f
 			queue_interrupt(fc, req);
 	}
 
-	if (req->force) {
-		spin_unlock(&fc->lock);
-		wait_event(req->waitq, req->state == FUSE_REQ_FINISHED);
-		spin_lock(&fc->lock);
-	} else {
+	if (!req->force) {
 		sigset_t oldset;
 
 		/* Only fatal signals may interrupt this */
 		block_sigs(&oldset);
 		wait_answer_interruptible(fc, req);
 		restore_sigs(&oldset);
+
+		if (req->aborted)
+			goto aborted;
+		if (req->state == FUSE_REQ_FINISHED)
+			return;
+
+		/* Request is not yet in userspace, bail out */
+		if (req->state == FUSE_REQ_PENDING) {
+			list_del(&req->list);
+			__fuse_put_request(req);
+			req->out.h.error = -EINTR;
+			return;
+		}
 	}
 
-	if (req->aborted)
-		goto aborted;
-	if (req->state == FUSE_REQ_FINISHED)
- 		return;
+	/*
+	 * Either request is already in userspace, or it was forced.
+	 * Wait it out.
+	 */
+	spin_unlock(&fc->lock);
+	wait_event(req->waitq, req->state == FUSE_REQ_FINISHED);
+	spin_lock(&fc->lock);
 
-	req->out.h.error = -EINTR;
-	req->aborted = 1;
+	if (!req->aborted)
+		return;
 
  aborted:
+	BUG_ON(req->state != FUSE_REQ_FINISHED);
 	if (req->locked) {
 		/* This is uninterruptible sleep, because data is
 		   being copied to/from the buffers of req.  During
@@ -305,14 +318,6 @@ static void request_wait_answer(struct f
 		wait_event(req->waitq, !req->locked);
 		spin_lock(&fc->lock);
 	}
-	if (req->state == FUSE_REQ_PENDING) {
-		list_del(&req->list);
-		__fuse_put_request(req);
-	} else if (req->state == FUSE_REQ_SENT) {
-		spin_unlock(&fc->lock);
-		wait_event(req->waitq, req->state == FUSE_REQ_FINISHED);
-		spin_lock(&fc->lock);
-	}
 }
 
 static unsigned len_args(unsigned numargs, struct fuse_arg *args)

--
