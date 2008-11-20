Return-Path: <linux-kernel-owner+w=401wt.eu-S1758180AbYKTPEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180AbYKTPEX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 10:04:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757999AbYKTOxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:53:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:58693 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757984AbYKTOxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:53:22 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       miklos@szeredi.hu, akpm@linux-foundation.org, npiggin@suse.de
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/6] FUSE: implement fuse_req->prep()
Date: Thu, 20 Nov 2008 23:52:19 +0900
Message-Id: <1227192740-10532-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1227192740-10532-1-git-send-email-tj@kernel.org>
References: <1227192740-10532-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 20 Nov 2008 14:52:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement ->prep() which is the opposite equivalent of ->end().  It's
called right before the request is passed to userland server in the
kernel context of the server.  ->prep() can fail the request without
disrupting the whole channel.

This will be used by direct mmap implementation.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/fuse/dev.c    |   29 ++++++++++++++++++++++++++---
 fs/fuse/fuse_i.h |    6 ++++++
 2 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index c83ff20..05414b8 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -747,6 +747,7 @@ static ssize_t fuse_dev_read(struct kiocb *iocb, const struct iovec *iov,
 			      unsigned long nr_segs, loff_t pos)
 {
 	int err;
+	bool restart;
 	struct fuse_req *req;
 	struct fuse_in *in;
 	struct fuse_copy_state cs;
@@ -793,12 +794,32 @@ static ssize_t fuse_dev_read(struct kiocb *iocb, const struct iovec *iov,
 		goto restart;
 	}
 	spin_unlock(&fc->lock);
+
+	restart = false;
 	fuse_copy_init(&cs, fc, 1, req, iov, nr_segs);
+
+	/*
+	 * Execute prep if available.  Failure from prep doesn't
+	 * indicate faulty channel.  On failure, fail the current
+	 * request and proceed to the next one.
+	 */
+	if (req->prep) {
+		err = req->prep(fc, req);
+		if (err) {
+			restart = true;
+			goto finish;
+		}
+	}
+
 	err = fuse_copy_one(&cs, &in->h, sizeof(in->h));
-	if (!err)
-		err = fuse_copy_args(&cs, in->numargs, in->argpages,
-				     (struct fuse_arg *) in->args, 0);
+	if (err)
+		goto finish;
+
+	err = fuse_copy_args(&cs, in->numargs, in->argpages,
+			     (struct fuse_arg *) in->args, 0);
+ finish:
 	fuse_copy_finish(&cs);
+
 	spin_lock(&fc->lock);
 	req->locked = 0;
 	if (req->aborted) {
@@ -808,6 +829,8 @@ static ssize_t fuse_dev_read(struct kiocb *iocb, const struct iovec *iov,
 	if (err) {
 		req->out.h.error = -EIO;
 		request_end(fc, req);
+		if (restart)
+			goto restart;
 		return err;
 	}
 	if (!req->isreply)
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 90eb42c..9d3becb 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -282,6 +282,12 @@ struct fuse_req {
 	/** Link on fi->writepages */
 	struct list_head writepages_entry;
 
+	/** Request preparation callback.  Called from the kernel
+	    context of the FUSE server before passing the request to
+	    the FUSE server.  Non-zero return from this function will
+	    fail the request. */
+	int (*prep)(struct fuse_conn *, struct fuse_req *);
+
 	/** Request completion callback.  This function is called from
 	    the kernel context of the FUSE server if the request isn't
 	    being aborted.  If the request is being aborted, it's
-- 
1.5.6

