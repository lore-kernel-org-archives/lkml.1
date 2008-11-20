Return-Path: <linux-kernel-owner+w=401wt.eu-S1759317AbYKTPDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759317AbYKTPDj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 10:03:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757123AbYKTOxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:53:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:58690 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757957AbYKTOxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:53:19 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       miklos@szeredi.hu, akpm@linux-foundation.org, npiggin@suse.de
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/6] FUSE: don't let fuse_req->end() put the base reference
Date: Thu, 20 Nov 2008 23:52:17 +0900
Message-Id: <1227192740-10532-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1227192740-10532-1-git-send-email-tj@kernel.org>
References: <1227192740-10532-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 20 Nov 2008 14:52:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fuse_req->end() was supposed to be put the base reference but there's
no reason why it should.  It only makes things more complex.  Move it
out of ->end() and make it the responsibility of request_end().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/fuse/dev.c   |    5 +----
 fs/fuse/file.c  |    4 +---
 fs/fuse/inode.c |    1 -
 3 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index b8f70a0..25a134a 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -296,8 +296,7 @@ static void request_end(struct fuse_conn *fc, struct fuse_req *req)
 	wake_up(&req->waitq);
 	if (end)
 		end(fc, req);
-	else
-		fuse_put_request(fc, req);
+	fuse_put_request(fc, req);
 }
 
 static void wait_answer_interruptible(struct fuse_conn *fc,
@@ -1052,8 +1051,6 @@ static void end_io_requests(struct fuse_conn *fc)
 		wake_up(&req->waitq);
 		if (end) {
 			req->end = NULL;
-			/* The end function will consume this reference */
-			__fuse_get_request(req);
 			spin_unlock(&fc->lock);
 			wait_event(req->waitq, !req->locked);
 			end(fc, req);
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 4d535ae..128356b 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -85,7 +85,6 @@ static void fuse_release_end(struct fuse_conn *fc, struct fuse_req *req)
 {
 	dput(req->misc.release.dentry);
 	mntput(req->misc.release.vfsmount);
-	fuse_put_request(fc, req);
 }
 
 static void fuse_file_put(struct fuse_file *ff)
@@ -506,7 +505,6 @@ static void fuse_readpages_end(struct fuse_conn *fc, struct fuse_req *req)
 	}
 	if (req->ff)
 		fuse_file_put(req->ff);
-	fuse_put_request(fc, req);
 }
 
 static void fuse_send_readpages(struct fuse_req *req, struct file *file,
@@ -1056,7 +1054,6 @@ static void fuse_writepage_free(struct fuse_conn *fc, struct fuse_req *req)
 {
 	__free_page(req->pages[0]);
 	fuse_file_put(req->ff);
-	fuse_put_request(fc, req);
 }
 
 static void fuse_writepage_finish(struct fuse_conn *fc, struct fuse_req *req)
@@ -1100,6 +1097,7 @@ static void fuse_send_writepage(struct fuse_conn *fc, struct fuse_req *req)
 	fuse_writepage_finish(fc, req);
 	spin_unlock(&fc->lock);
 	fuse_writepage_free(fc, req);
+	fuse_put_request(fc, req);
 	spin_lock(&fc->lock);
 }
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index eae4ff9..75f0770 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -781,7 +781,6 @@ static void process_init_reply(struct fuse_conn *fc, struct fuse_req *req)
 		fc->max_write = max_t(unsigned, 4096, fc->max_write);
 		fc->conn_init = 1;
 	}
-	fuse_put_request(fc, req);
 	fc->blocked = 0;
 	wake_up_all(&fc->blocked_waitq);
 }
-- 
1.5.6

