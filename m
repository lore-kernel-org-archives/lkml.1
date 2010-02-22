Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab0BVUf4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 15:35:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753962Ab0BVUfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 15:35:55 -0500
Date: Mon, 22 Feb 2010 15:35:51 -0500
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [RFC PATCH] VFS: Simplify truncate logic in do_filp_open()
Message-ID: <20100222203551.GE972@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fact that may_open() could truncate a file gave me a lot of
heartburn when working on union mounts, so I was thrilled to see that
truncate handling has been moved out of may_open() in Al's for-next
tree.  However, it seems to me that the surrounding elaborate
mnt_want_write() dance is no longer needed?  If so, this also
simplifies Ogawa Hirofumi "Fix use-after-free of vfsmount by
mnt_drop_write()" patch.

Against Al's for-next branch.  Lightly tested, please review.

-VAL

Author: Valerie Aurora <vaurora@redhat.com>

Formerly, may_open() could truncate a file, necessitating an explicit
mnt_want_write() to avoid a nasty race.  Now truncation is done in
handle_truncate() after the nameidata_to_filp() call, which already
takes a mount write reference.  Remove unneeded extra mnt_want_write()
logic and rewrite the comment explaining the potential race in more
general terms.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
---
 fs/namei.c |   41 +++++++++++------------------------------
 1 files changed, 11 insertions(+), 30 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 2faaaeb..a38801d 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1630,7 +1630,6 @@ struct file *do_filp_open(int dfd, const char *pathname,
 	struct path path;
 	struct dentry *dir;
 	int count = 0;
-	int will_truncate;
 	int flag = open_to_namei_flags(open_flag);
 	int force_reval = 0;
 
@@ -1795,28 +1794,10 @@ do_last:
 	if (S_ISDIR(path.dentry->d_inode->i_mode))
 		goto exit;
 ok:
-	/*
-	 * Consider:
-	 * 1. may_open() truncates a file
-	 * 2. a rw->ro mount transition occurs
-	 * 3. nameidata_to_filp() fails due to
-	 *    the ro mount.
-	 * That would be inconsistent, and should
-	 * be avoided. Taking this mnt write here
-	 * ensures that (2) can not occur.
-	 */
-	will_truncate = open_will_truncate(flag, nd.path.dentry->d_inode);
-	if (will_truncate) {
-		error = mnt_want_write(nd.path.mnt);
-		if (error)
-			goto exit;
-	}
+	/* may_open() no longer truncates file, handle_truncate() does */
 	error = may_open(&nd.path, acc_mode, open_flag);
-	if (error) {
-		if (will_truncate)
-			mnt_drop_write(nd.path.mnt);
+	if (error)
 		goto exit;
-	}
 	filp = nameidata_to_filp(&nd);
 	if (!IS_ERR(filp)) {
 		error = ima_file_check(filp, acc_mode);
@@ -1828,8 +1809,15 @@ ok:
 	if (!IS_ERR(filp)) {
 		if (acc_mode & MAY_WRITE)
 			vfs_dq_init(nd.path.dentry->d_inode);
-
-		if (will_truncate) {
+		/*
+		 * Be sure to get a write reference to the mount
+		 * before truncating the file (nameidata_to_filp()
+		 * does this).  Otherwise, a rw -> ro transition
+		 * between the truncate and finishing the open could
+		 * result in successfully truncating file but failing
+		 * the open() with EROFS.
+		 */
+		if (open_will_truncate(flag, nd.path.dentry->d_inode)) {
 			error = handle_truncate(&nd.path);
 			if (error) {
 				fput(filp);
@@ -1837,13 +1825,6 @@ ok:
 			}
 		}
 	}
-	/*
-	 * It is now safe to drop the mnt write
-	 * because the filp has had a write taken
-	 * on its behalf.
-	 */
-	if (will_truncate)
-		mnt_drop_write(nd.path.mnt);
 	if (nd.root.mnt)
 		path_put(&nd.root);
 	return filp;
-- 
1.5.6.5

