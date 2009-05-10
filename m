Return-Path: <linux-kernel-owner+w=401wt.eu-S1755202AbZEJUJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbZEJUJG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 16:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbZEJUIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 16:08:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54588 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531AbZEJUIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 16:08:49 -0400
Message-Id: <20090510200650.028382548@suse.com>
User-Agent: quilt/0.47-14.9
Date: Sun, 10 May 2009 16:05:39 -0400
From: Jeff Mahoney <jeffm@suse.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
       stefanr@s5r6.in-berlin.de
Subject: [patch 4/4] reiserfs: allow exposing privroot w/ xattrs enabled
References: <20090510200535.893737918@suse.com>
Content-Disposition: inline; filename=reiserfs-expose-privroot
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an -oexpose_privroot option to allow access to the privroot.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---

 fs/reiserfs/dir.c              |   10 ++++------
 fs/reiserfs/super.c            |    1 +
 fs/reiserfs/xattr.c            |    3 ++-
 include/linux/reiserfs_fs_sb.h |    2 ++
 4 files changed, 9 insertions(+), 7 deletions(-)

--- a/fs/reiserfs/dir.c
+++ b/fs/reiserfs/dir.c
@@ -44,13 +44,11 @@ static int reiserfs_dir_fsync(struct fil
 static inline bool is_privroot_deh(struct dentry *dir,
 				   struct reiserfs_de_head *deh)
 {
-	int ret = 0;
-#ifdef CONFIG_REISERFS_FS_XATTR
 	struct dentry *privroot = REISERFS_SB(dir->d_sb)->priv_root;
-	ret = (dir == dir->d_parent && privroot->d_inode &&
-	       deh->deh_objectid == INODE_PKEY(privroot->d_inode)->k_objectid);
-#endif
-	return ret;
+	if (reiserfs_expose_privroot(dir->d_sb))
+		return 0;
+	return (dir == dir->d_parent && privroot->d_inode &&
+	        deh->deh_objectid == INODE_PKEY(privroot->d_inode)->k_objectid);
 }
 
 int reiserfs_readdir_dentry(struct dentry *dentry, void *dirent,
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -898,6 +898,7 @@ static int reiserfs_parse_options(struct
 		{"conv",.setmask = 1 << REISERFS_CONVERT},
 		{"attrs",.setmask = 1 << REISERFS_ATTRS},
 		{"noattrs",.clrmask = 1 << REISERFS_ATTRS},
+		{"expose_privroot", .setmask = 1 << REISERFS_EXPOSE_PRIVROOT},
 #ifdef CONFIG_REISERFS_FS_XATTR
 		{"user_xattr",.setmask = 1 << REISERFS_XATTRS_USER},
 		{"nouser_xattr",.clrmask = 1 << REISERFS_XATTRS_USER},
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -982,7 +982,8 @@ int reiserfs_lookup_privroot(struct supe
 				strlen(PRIVROOT_NAME));
 	if (!IS_ERR(dentry)) {
 		REISERFS_SB(s)->priv_root = dentry;
-		s->s_root->d_op = &xattr_lookup_poison_ops;
+		if (!reiserfs_expose_privroot(s))
+			s->s_root->d_op = &xattr_lookup_poison_ops;
 		if (dentry->d_inode)
 			dentry->d_inode->i_flags |= S_PRIVATE;
 	} else
--- a/include/linux/reiserfs_fs_sb.h
+++ b/include/linux/reiserfs_fs_sb.h
@@ -453,6 +453,7 @@ enum reiserfs_mount_options {
 	REISERFS_ATTRS,
 	REISERFS_XATTRS_USER,
 	REISERFS_POSIXACL,
+	REISERFS_EXPOSE_PRIVROOT,
 	REISERFS_BARRIER_NONE,
 	REISERFS_BARRIER_FLUSH,
 
@@ -490,6 +491,7 @@ enum reiserfs_mount_options {
 #define reiserfs_data_writeback(s) (REISERFS_SB(s)->s_mount_opt & (1 << REISERFS_DATA_WRITEBACK))
 #define reiserfs_xattrs_user(s) (REISERFS_SB(s)->s_mount_opt & (1 << REISERFS_XATTRS_USER))
 #define reiserfs_posixacl(s) (REISERFS_SB(s)->s_mount_opt & (1 << REISERFS_POSIXACL))
+#define reiserfs_expose_privroot(s) (REISERFS_SB(s)->s_mount_opt & (1 << REISERFS_EXPOSE_PRIVROOT))
 #define reiserfs_xattrs_optional(s) (reiserfs_xattrs_user(s) || reiserfs_posixacl(s))
 #define reiserfs_barrier_none(s) (REISERFS_SB(s)->s_mount_opt & (1 << REISERFS_BARRIER_NONE))
 #define reiserfs_barrier_flush(s) (REISERFS_SB(s)->s_mount_opt & (1 << REISERFS_BARRIER_FLUSH))


