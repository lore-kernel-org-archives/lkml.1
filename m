Return-Path: <linux-kernel-owner+w=401wt.eu-S932162AbYB0XNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162AbYB0XNH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 18:13:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761454AbYB0XI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 18:08:56 -0500
Received: from zombie.ncsc.mil ([144.51.88.131]:44358 "EHLO zombie.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757982AbYB0XI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 18:08:29 -0500
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: hch@infradead.org, viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no,
       bfields@fieldses.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>
Subject: [PATCH 03/11] VFS: Add security label support to *notify
Date: Wed, 27 Feb 2008 17:11:26 -0500
Message-Id: <1204150294-4678-4-git-send-email-dpquigl@tycho.nsa.gov>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1204150294-4678-1-git-send-email-dpquigl@tycho.nsa.gov>
References: <1204150294-4678-1-git-send-email-dpquigl@tycho.nsa.gov>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds two new fields to the iattr structure. The first field holds a
security label while the second contains the length of this label. In addition
the patch adds a new helper function inode_setsecurity which calls the LSM to
set the security label on the inode. Finally the patch modifies the necessary
functions such that fsnotify_change can handle notification requests for
dnotify and inotify.

Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>
---
 fs/attr.c                |   43 +++++++++++++++++++++++++++++++++++++++++++
 fs/xattr.c               |   33 +++++++++++++++++++++++++++------
 include/linux/fcntl.h    |    1 +
 include/linux/fs.h       |   11 +++++++++++
 include/linux/fsnotify.h |    6 ++++++
 include/linux/inotify.h  |    3 ++-
 include/linux/xattr.h    |    1 +
 7 files changed, 91 insertions(+), 7 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index 966b73e..1df6603 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -5,6 +5,7 @@
  *  changes by Thomas Schoebel-Theuer
  */
 
+#include <linux/fs.h>
 #include <linux/module.h>
 #include <linux/time.h>
 #include <linux/mm.h>
@@ -14,9 +15,35 @@
 #include <linux/fcntl.h>
 #include <linux/quotaops.h>
 #include <linux/security.h>
+#include <linux/xattr.h>
 
 /* Taken over from the old code... */
 
+#ifdef CONFIG_SECURITY
+/*
+ * Update the in core label.
+ */
+int inode_setsecurity(struct inode *inode, struct iattr *attr)
+{
+	const char *suffix = security_maclabel_getname() 
+				+ XATTR_SECURITY_PREFIX_LEN;
+	int error;
+
+	if (!attr->ia_valid & ATTR_SECURITY_LABEL)
+		return -EINVAL;
+
+	error = security_inode_setsecurity(inode, suffix, attr->ia_label,
+					   attr->ia_label_len, 0);
+	if (error)
+		printk(KERN_ERR "%s() %s %d security_inode_setsecurity() %d\n"
+			, __func__, (char *)attr->ia_label, attr->ia_label_len
+			, error);
+
+	return error;
+}
+EXPORT_SYMBOL(inode_setsecurity);
+#endif
+
 /* POSIX UID/GID verification for setting inode attributes. */
 int inode_change_ok(struct inode *inode, struct iattr *attr)
 {
@@ -94,6 +121,10 @@ int inode_setattr(struct inode * inode, struct iattr * attr)
 			mode &= ~S_ISGID;
 		inode->i_mode = mode;
 	}
+#ifdef CONFIG_SECURITY
+	if (ia_valid & ATTR_SECURITY_LABEL)
+		inode_setsecurity(inode, attr);
+#endif
 	mark_inode_dirty(inode);
 
 	return 0;
@@ -157,6 +188,18 @@ int notify_change(struct dentry * dentry, struct iattr * attr)
 	if (ia_valid & ATTR_SIZE)
 		down_write(&dentry->d_inode->i_alloc_sem);
 
+#ifdef CONFIG_SECURITY
+	if (ia_valid & ATTR_SECURITY_LABEL) {
+		char *key = (char *)security_maclabel_getname();
+		vfs_setxattr_locked(dentry, key,
+			attr->ia_label, attr->ia_label_len, 0);
+		/* Avoid calling inode_setsecurity()
+		 * via inode_setattr() below
+		 */
+		attr->ia_valid &= ~ATTR_SECURITY_LABEL;
+	}
+#endif
+
 	if (inode->i_op && inode->i_op->setattr) {
 		error = security_inode_setattr(dentry, attr);
 		if (!error)
diff --git a/fs/xattr.c b/fs/xattr.c
index 3acab16..b5a91e1 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -67,9 +67,9 @@ xattr_permission(struct inode *inode, const char *name, int mask)
 	return permission(inode, mask, NULL);
 }
 
-int
-vfs_setxattr(struct dentry *dentry, char *name, void *value,
-		size_t size, int flags)
+static int
+_vfs_setxattr(struct dentry *dentry, char *name, void *value,
+		size_t size, int flags, int lock)
 {
 	struct inode *inode = dentry->d_inode;
 	int error;
@@ -78,7 +78,8 @@ vfs_setxattr(struct dentry *dentry, char *name, void *value,
 	if (error)
 		return error;
 
-	mutex_lock(&inode->i_mutex);
+	if (lock)
+		mutex_lock(&inode->i_mutex);
 	error = security_inode_setxattr(dentry, name, value, size, flags);
 	if (error)
 		goto out;
@@ -95,15 +96,35 @@ vfs_setxattr(struct dentry *dentry, char *name, void *value,
 		const char *suffix = name + XATTR_SECURITY_PREFIX_LEN;
 		error = security_inode_setsecurity(inode, suffix, value,
 						   size, flags);
-		if (!error)
+		if (!error) {
+#ifdef CONFIG_SECURITY
+			fsnotify_change(dentry, ATTR_SECURITY_LABEL);
+#endif
 			fsnotify_xattr(dentry);
+		}
 	}
 out:
-	mutex_unlock(&inode->i_mutex);
+	if (lock)
+		mutex_unlock(&inode->i_mutex);
 	return error;
 }
+
+int
+vfs_setxattr(struct dentry *dentry, char *name, void *value,
+		size_t size, int flags)
+{
+	return _vfs_setxattr(dentry, name, value, size, flags, 1);
+}
 EXPORT_SYMBOL_GPL(vfs_setxattr);
 
+int
+vfs_setxattr_locked(struct dentry *dentry, char *name, void *value,
+			size_t size, int flags)
+{
+	return _vfs_setxattr(dentry, name, value, size, flags, 0);
+}
+EXPORT_SYMBOL_GPL(vfs_setxattr_locked);
+
 ssize_t
 xattr_getsecurity(struct inode *inode, const char *name, void *value,
 			size_t size)
diff --git a/include/linux/fcntl.h b/include/linux/fcntl.h
index 8603740..fae1e59 100644
--- a/include/linux/fcntl.h
+++ b/include/linux/fcntl.h
@@ -30,6 +30,7 @@
 #define DN_DELETE	0x00000008	/* File removed */
 #define DN_RENAME	0x00000010	/* File renamed */
 #define DN_ATTRIB	0x00000020	/* File changed attibutes */
+#define DN_LABEL        0x00000040      /* File (re)labeled */
 #define DN_MULTISHOT	0x80000000	/* Don't remove notifier */
 
 #define AT_FDCWD		-100    /* Special value used to indicate
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b84b848..757add6 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -335,6 +335,10 @@ typedef void (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 #define ATTR_KILL_PRIV	16384
 #define ATTR_OPEN	32768	/* Truncating from open(O_TRUNC) */
 
+#ifdef CONFIG_SECURITY
+#define ATTR_SECURITY_LABEL  65536
+#endif
+
 /*
  * This is the Inode Attributes structure, used for notify_change().  It
  * uses the above definitions as flags, to know which values have changed.
@@ -360,6 +364,10 @@ struct iattr {
 	 * check for (ia_valid & ATTR_FILE), and not for (ia_file != NULL).
 	 */
 	struct file	*ia_file;
+#ifdef CONFIG_SECURITY
+	void		*ia_label;
+	u32		 ia_label_len;
+#endif
 };
 
 /*
@@ -1971,6 +1979,9 @@ extern int buffer_migrate_page(struct address_space *,
 #define buffer_migrate_page NULL
 #endif
 
+#ifdef CONFIG_SECURITY
+extern int inode_setsecurity(struct inode *inode, struct iattr *attr);
+#endif
 extern int inode_change_ok(struct inode *, struct iattr *);
 extern int __must_check inode_setattr(struct inode *, struct iattr *);
 
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index d4b7c4a..b54a3cb 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -253,6 +253,12 @@ static inline void fsnotify_change(struct dentry *dentry, unsigned int ia_valid)
 		in_mask |= IN_ATTRIB;
 		dn_mask |= DN_ATTRIB;
 	}
+#ifdef CONFIG_SECURITY
+	if (ia_valid & ATTR_SECURITY_LABEL) {
+		in_mask |= IN_LABEL;
+		dn_mask |= DN_LABEL;
+	}
+#endif
 
 	if (dn_mask)
 		dnotify_parent(dentry, dn_mask);
diff --git a/include/linux/inotify.h b/include/linux/inotify.h
index 742b917..10f3ace 100644
--- a/include/linux/inotify.h
+++ b/include/linux/inotify.h
@@ -36,6 +36,7 @@ struct inotify_event {
 #define IN_DELETE		0x00000200	/* Subfile was deleted */
 #define IN_DELETE_SELF		0x00000400	/* Self was deleted */
 #define IN_MOVE_SELF		0x00000800	/* Self was moved */
+#define IN_LABEL		0x00001000	/* Self was (re)labeled */
 
 /* the following are legal events.  they are sent as needed to any watch */
 #define IN_UNMOUNT		0x00002000	/* Backing fs was unmounted */
@@ -61,7 +62,7 @@ struct inotify_event {
 #define IN_ALL_EVENTS	(IN_ACCESS | IN_MODIFY | IN_ATTRIB | IN_CLOSE_WRITE | \
 			 IN_CLOSE_NOWRITE | IN_OPEN | IN_MOVED_FROM | \
 			 IN_MOVED_TO | IN_DELETE | IN_CREATE | IN_DELETE_SELF | \
-			 IN_MOVE_SELF)
+			 IN_MOVE_SELF | IN_LABEL)
 
 #ifdef __KERNEL__
 
diff --git a/include/linux/xattr.h b/include/linux/xattr.h
index df6b95d..1169963 100644
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -50,6 +50,7 @@ ssize_t xattr_getsecurity(struct inode *, const char *, void *, size_t);
 ssize_t vfs_getxattr(struct dentry *, char *, void *, size_t);
 ssize_t vfs_listxattr(struct dentry *d, char *list, size_t size);
 int vfs_setxattr(struct dentry *, char *, void *, size_t, int);
+int vfs_setxattr_locked(struct dentry *, char *, void *, size_t, int);
 int vfs_removexattr(struct dentry *, char *);
 
 ssize_t generic_getxattr(struct dentry *dentry, const char *name, void *buffer, size_t size);
-- 
1.5.3.8

