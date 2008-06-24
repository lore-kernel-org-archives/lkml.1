Return-Path: <linux-kernel-owner+w=401wt.eu-S1757030AbYFZAvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030AbYFZAvw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 20:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754616AbYFZAvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 20:51:45 -0400
Received: from cpe-70-113-98-152.austin.res.rr.com ([70.113.98.152]:44577 "EHLO
	opteron.9grid.us" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199AbYFZAvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 20:51:44 -0400
X-Greylist: delayed 4198 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Jun 2008 20:51:44 EDT
From: ericvh@gmail.com
To: v9fs-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Eric Van Hensbergen <ericvh@gmail.com>
Subject: [PATCH] 9p: fix O_APPEND in legacy mode
Date: Tue, 24 Jun 2008 17:41:49 -0500
Message-Id: <1214347309-8863-1-git-send-email-ericvh@gmail.com>
X-Mailer: git-send-email 1.5.4.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Van Hensbergen <ericvh@gmail.com>

The legacy protocol's open operation doesn't handle an append operation
(it is expected that the client take care of it).  We were incorrectly
passing the extended protocol's flag through even in legacy mode.  This
was reported in bugzilla report #10689.  This patch fixes the problem
by disallowing extended protocol open modes from being passed in legacy
mode and implemented append functionality on the client side by adding
a seek after the open.

Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
---
 fs/9p/v9fs_vfs.h  |    2 +-
 fs/9p/vfs_file.c  |    4 +++-
 fs/9p/vfs_inode.c |   18 ++++++++++--------
 3 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/fs/9p/v9fs_vfs.h b/fs/9p/v9fs_vfs.h
index fd01d90..57997fa 100644
--- a/fs/9p/v9fs_vfs.h
+++ b/fs/9p/v9fs_vfs.h
@@ -51,4 +51,4 @@ int v9fs_dir_release(struct inode *inode, struct file *filp);
 int v9fs_file_open(struct inode *inode, struct file *file);
 void v9fs_inode2stat(struct inode *inode, struct p9_stat *stat);
 void v9fs_dentry_release(struct dentry *);
-int v9fs_uflags2omode(int uflags);
+int v9fs_uflags2omode(int uflags, int extended);
diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index 0d55aff..52944d2 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -59,7 +59,7 @@ int v9fs_file_open(struct inode *inode, struct file *file)
 
 	P9_DPRINTK(P9_DEBUG_VFS, "inode: %p file: %p \n", inode, file);
 	v9ses = v9fs_inode2v9ses(inode);
-	omode = v9fs_uflags2omode(file->f_flags);
+	omode = v9fs_uflags2omode(file->f_flags, v9fs_extended(v9ses));
 	fid = file->private_data;
 	if (!fid) {
 		fid = v9fs_fid_clone(file->f_path.dentry);
@@ -75,6 +75,8 @@ int v9fs_file_open(struct inode *inode, struct file *file)
 			inode->i_size = 0;
 			inode->i_blocks = 0;
 		}
+		if ((file->f_flags & O_APPEND) && (!v9fs_extended(v9ses)))
+			generic_file_llseek(file, 0, SEEK_END);
 	}
 
 	file->private_data = fid;
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 40fa807..c95295c 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -132,10 +132,10 @@ static int p9mode2unixmode(struct v9fs_session_info *v9ses, int mode)
 /**
  * v9fs_uflags2omode- convert posix open flags to plan 9 mode bits
  * @uflags: flags to convert
- *
+ * @extended: if .u extensions are active
  */
 
-int v9fs_uflags2omode(int uflags)
+int v9fs_uflags2omode(int uflags, int extended)
 {
 	int ret;
 
@@ -155,14 +155,16 @@ int v9fs_uflags2omode(int uflags)
 		break;
 	}
 
-	if (uflags & O_EXCL)
-		ret |= P9_OEXCL;
-
 	if (uflags & O_TRUNC)
 		ret |= P9_OTRUNC;
 
-	if (uflags & O_APPEND)
-		ret |= P9_OAPPEND;
+	if (extended) {
+		if (uflags & O_EXCL)
+			ret |= P9_OEXCL;
+
+		if (uflags & O_APPEND)
+			ret |= P9_OAPPEND;
+	}
 
 	return ret;
 }
@@ -506,7 +508,7 @@ v9fs_vfs_create(struct inode *dir, struct dentry *dentry, int mode,
 		flags = O_RDWR;
 
 	fid = v9fs_create(v9ses, dir, dentry, NULL, perm,
-						v9fs_uflags2omode(flags));
+				v9fs_uflags2omode(flags, v9fs_extended(v9ses)));
 	if (IS_ERR(fid)) {
 		err = PTR_ERR(fid);
 		fid = NULL;
-- 
1.5.4.3

