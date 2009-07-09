Return-Path: <linux-kernel-owner+w=401wt.eu-S1753816AbZGISFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbZGISFV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 14:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752829AbZGISFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 14:05:07 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:38162 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbZGISFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 14:05:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=jPKui3wkWuCgiXJphCQaTzv3G76E/+pJP7tBdXUVJWMCReK/7e5js5yfEHJdJZQFi9
         y0CshR65j7VOBWE1t2mGIOhpuLvbCc58xpStD1sr04Cs66O0+Qeds/6U7DcU5UtmgAzX
         MXE8/7WK9g3qgPPcPxScB9rIPoMh1sqhVfkW8=
Message-ID: <4A56313D.1020304@gmail.com>
Date: Thu, 09 Jul 2009 22:04:45 +0400
From: Eugene Kapun <abacabadabacaba@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090616)
MIME-Version: 1.0
To: reiserfs-devel@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] reiserfs: make extended attributes support more configurable
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eugene Kapun <abacabadabacaba@gmail.com>

Adds configuration options which control how reiserfs supports extended
attributes. This makes support for POSIX ACLs and security labels
independent on support for normal xattrs. This also makes possible to
compile reiserfs without any xattrs support.
Signed-off-by: Eugene Kapun <abacabadabacaba@gmail.com>
---
This patch applies to linux-2.6.31-rc2-git4.
This patch may be useful since there are currently no means to fix some
problems which prevent reiserfs from being mounted and therefore can't
be solved by expose_privroot.

 fs/reiserfs/Kconfig            |   14 ++++++--
 fs/reiserfs/Makefile           |    6 ++-
 fs/reiserfs/dir.c              |    4 ++
 fs/reiserfs/super.c            |    8 ++++
 fs/reiserfs/xattr.c            |   48 +++++++++++++++-------------
 include/linux/reiserfs_fs_i.h  |    8 ++++
 include/linux/reiserfs_fs_sb.h |   20 ++++++++++-
 include/linux/reiserfs_xattr.h |   53 ++++++++++++++++++++++---------
 8 files changed, 118 insertions(+), 43 deletions(-)

diff -uprN linux-2.6.31-rc2-git3.0/fs/reiserfs/dir.c linux-2.6.31-rc2-git3.1/fs/reiserfs/dir.c
--- linux-2.6.31-rc2-git3.0/fs/reiserfs/dir.c	2009-07-09 13:52:44.000000000 +0400
+++ linux-2.6.31-rc2-git3.1/fs/reiserfs/dir.c	2009-07-09 14:04:37.000000000 +0400
@@ -44,11 +44,15 @@ static int reiserfs_dir_fsync(struct fil
 static inline bool is_privroot_deh(struct dentry *dir,
 				   struct reiserfs_de_head *deh)
 {
+#ifdef CONFIG_REISERFS_FS_EXTENDED
 	struct dentry *privroot = REISERFS_SB(dir->d_sb)->priv_root;
 	if (reiserfs_expose_privroot(dir->d_sb))
 		return 0;
 	return (dir == dir->d_parent && privroot->d_inode &&
 	        deh->deh_objectid == INODE_PKEY(privroot->d_inode)->k_objectid);
+#else
+	return 0;
+#endif
 }
 
 int reiserfs_readdir_dentry(struct dentry *dentry, void *dirent,
diff -uprN linux-2.6.31-rc2-git3.0/fs/reiserfs/Kconfig linux-2.6.31-rc2-git3.1/fs/reiserfs/Kconfig
--- linux-2.6.31-rc2-git3.0/fs/reiserfs/Kconfig	2009-06-10 07:05:27.000000000 +0400
+++ linux-2.6.31-rc2-git3.1/fs/reiserfs/Kconfig	2009-07-09 14:05:37.000000000 +0400
@@ -50,9 +50,17 @@ config REISERFS_PROC_INFO
 	  Almost everyone but ReiserFS developers and people fine-tuning
 	  reiserfs or tracing problems should say N.
 
+config REISERFS_FS_EXTENDED
+	bool "ReiserFS extended metadata"
+	depends on REISERFS_FS
+	help
+	  Allows ReiserFS to reserve a special directory for storage of
+	  extended attributes, POSIX ACLs and/or security labels. If you
+	  don't need any of these, say N.
+
 config REISERFS_FS_XATTR
 	bool "ReiserFS extended attributes"
-	depends on REISERFS_FS
+	depends on REISERFS_FS_EXTENDED
 	help
 	  Extended attributes are name:value pairs associated with inodes by
 	  the kernel or by users (see the attr(5) manual page, or visit
@@ -62,7 +70,7 @@ config REISERFS_FS_XATTR
 
 config REISERFS_FS_POSIX_ACL
 	bool "ReiserFS POSIX Access Control Lists"
-	depends on REISERFS_FS_XATTR
+	depends on REISERFS_FS_EXTENDED
 	select FS_POSIX_ACL
 	help
 	  Posix Access Control Lists (ACLs) support permissions for users and
@@ -75,7 +83,7 @@ config REISERFS_FS_POSIX_ACL
 
 config REISERFS_FS_SECURITY
 	bool "ReiserFS Security Labels"
-	depends on REISERFS_FS_XATTR
+	depends on REISERFS_FS_EXTENDED
 	help
 	  Security labels support alternative access control models
 	  implemented by security modules like SELinux.  This option
diff -uprN linux-2.6.31-rc2-git3.0/fs/reiserfs/Makefile linux-2.6.31-rc2-git3.1/fs/reiserfs/Makefile
--- linux-2.6.31-rc2-git3.0/fs/reiserfs/Makefile	2009-06-10 07:05:27.000000000 +0400
+++ linux-2.6.31-rc2-git3.1/fs/reiserfs/Makefile	2009-07-09 14:06:14.000000000 +0400
@@ -7,7 +7,11 @@ obj-$(CONFIG_REISERFS_FS) += reiserfs.o
 reiserfs-objs := bitmap.o do_balan.o namei.o inode.o file.o dir.o fix_node.o \
 		 super.o prints.o objectid.o lbalance.o ibalance.o stree.o \
 		 hashes.o tail_conversion.o journal.o resize.o \
-		 item_ops.o ioctl.o procfs.o xattr.o
+		 item_ops.o ioctl.o procfs.o
+
+ifeq ($(CONFIG_REISERFS_FS_EXTENDED),y)
+reiserfs-objs += xattr.o
+endif
 
 ifeq ($(CONFIG_REISERFS_FS_XATTR),y)
 reiserfs-objs += xattr_user.o xattr_trusted.o
diff -uprN linux-2.6.31-rc2-git3.0/fs/reiserfs/super.c linux-2.6.31-rc2-git3.1/fs/reiserfs/super.c
--- linux-2.6.31-rc2-git3.0/fs/reiserfs/super.c	2009-07-09 13:53:09.000000000 +0400
+++ linux-2.6.31-rc2-git3.1/fs/reiserfs/super.c	2009-07-09 14:34:03.000000000 +0400
@@ -444,6 +444,7 @@ int remove_save_link(struct inode *inode
 
 static void reiserfs_kill_sb(struct super_block *s)
 {
+#ifdef CONFIG_REISERFS_FS_EXTENDED
 	if (REISERFS_SB(s)) {
 		if (REISERFS_SB(s)->xattr_root) {
 			d_invalidate(REISERFS_SB(s)->xattr_root);
@@ -456,6 +457,7 @@ static void reiserfs_kill_sb(struct supe
 			REISERFS_SB(s)->priv_root = NULL;
 		}
 	}
+#endif
 
 	kill_block_super(s);
 }
@@ -876,7 +878,9 @@ static int reiserfs_parse_options(struct
 		{"conv",.setmask = 1 << REISERFS_CONVERT},
 		{"attrs",.setmask = 1 << REISERFS_ATTRS},
 		{"noattrs",.clrmask = 1 << REISERFS_ATTRS},
+#ifdef CONFIG_REISERFS_FS_EXTENDED
 		{"expose_privroot", .setmask = 1 << REISERFS_EXPOSE_PRIVROOT},
+#endif
 #ifdef CONFIG_REISERFS_FS_XATTR
 		{"user_xattr",.setmask = 1 << REISERFS_XATTRS_USER},
 		{"nouser_xattr",.clrmask = 1 << REISERFS_XATTRS_USER},
@@ -1200,8 +1204,12 @@ static int reiserfs_remount(struct super
 	safe_mask |= 1 << REISERFS_HASHED_RELOCATION;
 	safe_mask |= 1 << REISERFS_TEST4;
 	safe_mask |= 1 << REISERFS_ATTRS;
+#ifdef CONFIG_REISERFS_FS_XATTR
 	safe_mask |= 1 << REISERFS_XATTRS_USER;
+#endif
+#ifdef CONFIG_REISERFS_FS_POSIX_ACL
 	safe_mask |= 1 << REISERFS_POSIXACL;
+#endif
 	safe_mask |= 1 << REISERFS_BARRIER_FLUSH;
 	safe_mask |= 1 << REISERFS_BARRIER_NONE;
 	safe_mask |= 1 << REISERFS_ERROR_RO;
diff -uprN linux-2.6.31-rc2-git3.0/fs/reiserfs/xattr.c linux-2.6.31-rc2-git3.1/fs/reiserfs/xattr.c
--- linux-2.6.31-rc2-git3.0/fs/reiserfs/xattr.c	2009-07-09 13:52:44.000000000 +0400
+++ linux-2.6.31-rc2-git3.1/fs/reiserfs/xattr.c	2009-07-09 14:15:03.000000000 +0400
@@ -57,7 +57,7 @@
 /* Helpers for inode ops. We do this so that we don't have all the VFS
  * overhead and also for proper i_mutex annotation.
  * dir->i_mutex must be held for all of them. */
-#ifdef CONFIG_REISERFS_FS_XATTR
+#ifdef CONFIG_REISERFS_FS_ANY_XATTR
 static int xattr_create(struct inode *dir, struct dentry *dentry, int mode)
 {
 	BUG_ON(!mutex_is_locked(&dir->i_mutex));
@@ -337,7 +337,7 @@ int reiserfs_chown_xattrs(struct inode *
 	return err;
 }
 
-#ifdef CONFIG_REISERFS_FS_XATTR
+#ifdef CONFIG_REISERFS_FS_ANY_XATTR
 /* Returns a dentry corresponding to a specific extended attribute file
  * for the inode. If flags allow, the file is created. Otherwise, a
  * valid or negative dentry, or an error is returned. */
@@ -853,24 +853,6 @@ out:
 	return err;
 }
 
-static int reiserfs_check_acl(struct inode *inode, int mask)
-{
-	struct posix_acl *acl;
-	int error = -EAGAIN; /* do regular unix permission checks by default */
-
-	acl = reiserfs_get_acl(inode, ACL_TYPE_ACCESS);
-
-	if (acl) {
-		if (!IS_ERR(acl)) {
-			error = posix_acl_permission(inode, acl, mask);
-			posix_acl_release(acl);
-		} else if (PTR_ERR(acl) != -ENODATA)
-			error = PTR_ERR(acl);
-	}
-
-	return error;
-}
-
 static int create_privroot(struct dentry *dentry)
 {
 	int err;
@@ -899,6 +881,26 @@ void reiserfs_xattr_unregister_handlers(
 static int create_privroot(struct dentry *dentry) { return 0; }
 #endif
 
+#ifdef CONFIG_REISERFS_FS_POSIX_ACL
+static int reiserfs_check_acl(struct inode *inode, int mask)
+{
+	struct posix_acl *acl;
+	int error = -EAGAIN; /* do regular unix permission checks by default */
+
+	acl = reiserfs_get_acl(inode, ACL_TYPE_ACCESS);
+
+	if (acl) {
+		if (!IS_ERR(acl)) {
+			error = posix_acl_permission(inode, acl, mask);
+			posix_acl_release(acl);
+		} else if (PTR_ERR(acl) != -ENODATA)
+			error = PTR_ERR(acl);
+	}
+
+	return error;
+}
+#endif
+
 /* Actual operations that are exported to VFS-land */
 struct xattr_handler *reiserfs_xattr_handlers[] = {
 #ifdef CONFIG_REISERFS_FS_XATTR
@@ -943,7 +945,7 @@ int reiserfs_permission(struct inode *in
 	if (IS_PRIVATE(inode))
 		return 0;
 
-#ifdef CONFIG_REISERFS_FS_XATTR
+#ifdef CONFIG_REISERFS_FS_POSIX_ACL
 	/*
 	 * Stat data v1 doesn't support ACLs.
 	 */
@@ -1027,8 +1029,12 @@ int reiserfs_xattr_init(struct super_blo
 
 error:
 	if (err) {
+#ifdef CONFIG_REISERFS_FS_XATTR
 		clear_bit(REISERFS_XATTRS_USER, &(REISERFS_SB(s)->s_mount_opt));
+#endif
+#ifdef CONFIG_REISERFS_FS_POSIX_ACL
 		clear_bit(REISERFS_POSIXACL, &(REISERFS_SB(s)->s_mount_opt));
+#endif
 	}
 
 	/* The super_block MS_POSIXACL must mirror the (no)acl mount option. */
diff -uprN linux-2.6.31-rc2-git3.0/include/linux/reiserfs_fs_i.h linux-2.6.31-rc2-git3.1/include/linux/reiserfs_fs_i.h
--- linux-2.6.31-rc2-git3.0/include/linux/reiserfs_fs_i.h	2009-07-09 13:52:47.000000000 +0400
+++ linux-2.6.31-rc2-git3.1/include/linux/reiserfs_fs_i.h	2009-07-09 14:16:05.000000000 +0400
@@ -3,6 +3,12 @@
 
 #include <linux/list.h>
 
+#if defined(CONFIG_REISERFS_FS_XATTR) || \
+	defined(CONFIG_REISERFS_FS_POSIX_ACL) || \
+	defined(CONFIG_REISERFS_FS_SECURITY)
+#define CONFIG_REISERFS_FS_ANY_XATTR
+#endif
+
 struct reiserfs_journal_list;
 
 /** bitmasks for i_flags field in reiserfs-specific part of inode */
@@ -54,7 +60,7 @@ struct reiserfs_inode_info {
 	unsigned int i_trans_id;
 	struct reiserfs_journal_list *i_jl;
 	struct mutex i_mmap;
-#ifdef CONFIG_REISERFS_FS_XATTR
+#ifdef CONFIG_REISERFS_FS_ANY_XATTR
 	struct rw_semaphore i_xattr_sem;
 #endif
 	struct inode vfs_inode;
diff -uprN linux-2.6.31-rc2-git3.0/include/linux/reiserfs_fs_sb.h linux-2.6.31-rc2-git3.1/include/linux/reiserfs_fs_sb.h
--- linux-2.6.31-rc2-git3.0/include/linux/reiserfs_fs_sb.h	2009-07-09 13:52:47.000000000 +0400
+++ linux-2.6.31-rc2-git3.1/include/linux/reiserfs_fs_sb.h	2009-07-09 14:18:49.000000000 +0400
@@ -401,8 +401,10 @@ struct reiserfs_sb_info {
 	struct proc_dir_entry *procdir;
 	int reserved_blocks;	/* amount of blocks reserved for further allocations */
 	spinlock_t bitmap_lock;	/* this lock on now only used to protect reserved_blocks variable */
+#ifdef CONFIG_REISERFS_FS_EXTENDED
 	struct dentry *priv_root;	/* root of /.reiserfs_priv */
 	struct dentry *xattr_root;	/* root of /.reiserfs_priv/xattrs */
+#endif
 	int j_errno;
 #ifdef CONFIG_QUOTA
 	char *s_qf_names[MAXQUOTAS];
@@ -451,9 +453,15 @@ enum reiserfs_mount_options {
 	REISERFS_NO_UNHASHED_RELOCATION,
 	REISERFS_HASHED_RELOCATION,
 	REISERFS_ATTRS,
+#ifdef CONFIG_REISERFS_FS_EXTENDED
+	REISERFS_EXPOSE_PRIVROOT,
+#endif
+#ifdef CONFIG_REISERFS_FS_XATTR
 	REISERFS_XATTRS_USER,
+#endif
+#ifdef CONFIG_REISERFS_FS_POSIX_ACL
 	REISERFS_POSIXACL,
-	REISERFS_EXPOSE_PRIVROOT,
+#endif
 	REISERFS_BARRIER_NONE,
 	REISERFS_BARRIER_FLUSH,
 
@@ -489,9 +497,17 @@ enum reiserfs_mount_options {
 #define reiserfs_data_log(s) (REISERFS_SB(s)->s_mount_opt & (1 << REISERFS_DATA_LOG))
 #define reiserfs_data_ordered(s) (REISERFS_SB(s)->s_mount_opt & (1 << REISERFS_DATA_ORDERED))
 #define reiserfs_data_writeback(s) (REISERFS_SB(s)->s_mount_opt & (1 << REISERFS_DATA_WRITEBACK))
+#define reiserfs_expose_privroot(s) (REISERFS_SB(s)->s_mount_opt & (1 << REISERFS_EXPOSE_PRIVROOT))
+#ifdef CONFIG_REISERFS_FS_XATTR
 #define reiserfs_xattrs_user(s) (REISERFS_SB(s)->s_mount_opt & (1 << REISERFS_XATTRS_USER))
+#else
+#define reiserfs_xattrs_user(s) 0
+#endif
+#ifdef CONFIG_REISERFS_FS_POSIX_ACL
 #define reiserfs_posixacl(s) (REISERFS_SB(s)->s_mount_opt & (1 << REISERFS_POSIXACL))
-#define reiserfs_expose_privroot(s) (REISERFS_SB(s)->s_mount_opt & (1 << REISERFS_EXPOSE_PRIVROOT))
+#else
+#define reiserfs_posixacl(s) 0
+#endif
 #define reiserfs_xattrs_optional(s) (reiserfs_xattrs_user(s) || reiserfs_posixacl(s))
 #define reiserfs_barrier_none(s) (REISERFS_SB(s)->s_mount_opt & (1 << REISERFS_BARRIER_NONE))
 #define reiserfs_barrier_flush(s) (REISERFS_SB(s)->s_mount_opt & (1 << REISERFS_BARRIER_FLUSH))
diff -uprN linux-2.6.31-rc2-git3.0/include/linux/reiserfs_xattr.h linux-2.6.31-rc2-git3.1/include/linux/reiserfs_xattr.h
--- linux-2.6.31-rc2-git3.0/include/linux/reiserfs_xattr.h	2009-06-10 07:05:27.000000000 +0400
+++ linux-2.6.31-rc2-git3.1/include/linux/reiserfs_xattr.h	2009-07-09 14:39:36.000000000 +0400
@@ -35,6 +35,7 @@ struct iattr;
 struct super_block;
 struct nameidata;
 
+#ifdef CONFIG_REISERFS_FS_EXTENDED
 int reiserfs_xattr_register_handlers(void) __init;
 void reiserfs_xattr_unregister_handlers(void);
 int reiserfs_xattr_init(struct super_block *sb, int mount_flags);
@@ -42,8 +43,28 @@ int reiserfs_lookup_privroot(struct supe
 int reiserfs_delete_xattrs(struct inode *inode);
 int reiserfs_chown_xattrs(struct inode *inode, struct iattr *attrs);
 int reiserfs_permission(struct inode *inode, int mask);
+#else
+static inline int reiserfs_xattr_init(struct super_block *sb, int mount_flags)
+{
+	return 0;
+}
+static inline int reiserfs_lookup_privroot(struct super_block *sb)
+{
+	return 0;
+}
+static inline int reiserfs_delete_xattrs(struct inode *inode)
+{
+	return 0;
+}
+static inline int reiserfs_chown_xattrs(struct inode *inode,
+	struct iattr *attrs)
+{
+	return 0;
+}
+#define reiserfs_permission NULL
+#endif
 
-#ifdef CONFIG_REISERFS_FS_XATTR
+#ifdef CONFIG_REISERFS_FS_ANY_XATTR
 #define has_xattr_dir(inode) (REISERFS_I(inode)->i_flags & i_has_xattr_dir)
 ssize_t reiserfs_getxattr(struct dentry *dentry, const char *name,
 			  void *buffer, size_t size);
@@ -58,18 +79,6 @@ int reiserfs_xattr_set_handle(struct rei
 			      struct inode *, const char *, const void *,
 			      size_t, int);
 
-extern struct xattr_handler reiserfs_xattr_user_handler;
-extern struct xattr_handler reiserfs_xattr_trusted_handler;
-extern struct xattr_handler reiserfs_xattr_security_handler;
-#ifdef CONFIG_REISERFS_FS_SECURITY
-int reiserfs_security_init(struct inode *dir, struct inode *inode,
-			   struct reiserfs_security_handle *sec);
-int reiserfs_security_write(struct reiserfs_transaction_handle *th,
-			    struct inode *inode,
-			    struct reiserfs_security_handle *sec);
-void reiserfs_security_free(struct reiserfs_security_handle *sec);
-#endif
-
 #define xattr_size(size) ((size) + sizeof(struct reiserfs_xattr_header))
 static inline loff_t reiserfs_xattr_nblocks(struct inode *inode, loff_t size)
 {
@@ -120,9 +129,23 @@ static inline void reiserfs_init_xattr_r
 static inline void reiserfs_init_xattr_rwsem(struct inode *inode)
 {
 }
-#endif  /*  CONFIG_REISERFS_FS_XATTR  */
 
-#ifndef CONFIG_REISERFS_FS_SECURITY
+#endif
+
+#ifdef CONFIG_REISERFS_FS_XATTR
+extern struct xattr_handler reiserfs_xattr_user_handler;
+extern struct xattr_handler reiserfs_xattr_trusted_handler;
+#endif
+
+#ifdef CONFIG_REISERFS_FS_SECURITY
+int reiserfs_security_init(struct inode *dir, struct inode *inode,
+			   struct reiserfs_security_handle *sec);
+int reiserfs_security_write(struct reiserfs_transaction_handle *th,
+			    struct inode *inode,
+			    struct reiserfs_security_handle *sec);
+void reiserfs_security_free(struct reiserfs_security_handle *sec);
+extern struct xattr_handler reiserfs_xattr_security_handler;
+#else
 static inline int reiserfs_security_init(struct inode *dir,
 					 struct inode *inode,
 					 struct reiserfs_security_handle *sec)



