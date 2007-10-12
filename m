Return-Path: <linux-kernel-owner+w=401wt.eu-S1762035AbXJLQar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762035AbXJLQar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932453AbXJLQJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:09:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44049 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760440AbXJLQJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:09:31 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 48/52] CRED: Pass credentials through the getxattr() inode op
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:09:24 +0100
Message-ID: <20071012160924.15119.35777.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pass credentials through the getxattr() inode operation.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/bad_inode.c           |    2 +-
 fs/nfs/nfs3acl.c         |    3 +--
 fs/nfs/nfs4_fs.h         |    3 ++-
 fs/nfs/nfs4proc.c        |    3 +--
 fs/xattr.c               |    7 ++++---
 include/linux/fs.h       |    3 ++-
 include/linux/nfs_fs.h   |    3 ++-
 include/linux/xattr.h    |    3 ++-
 security/selinux/hooks.c |    9 +++++----
 9 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/fs/bad_inode.c b/fs/bad_inode.c
index d82d101..b310af3 100644
--- a/fs/bad_inode.c
+++ b/fs/bad_inode.c
@@ -272,7 +272,7 @@ static int bad_inode_setxattr(struct dentry *dentry, const char *name,
 }
 
 static ssize_t bad_inode_getxattr(struct dentry *dentry, const char *name,
-			void *buffer, size_t size)
+			void *buffer, size_t size, struct cred *cred)
 {
 	return -EIO;
 }
diff --git a/fs/nfs/nfs3acl.c b/fs/nfs/nfs3acl.c
index c09da17..0d160be 100644
--- a/fs/nfs/nfs3acl.c
+++ b/fs/nfs/nfs3acl.c
@@ -48,9 +48,8 @@ ssize_t nfs3_listxattr(struct dentry *dentry, char *buffer, size_t size)
 }
 
 ssize_t nfs3_getxattr(struct dentry *dentry, const char *name,
-		void *buffer, size_t size)
+		void *buffer, size_t size, struct cred *acred)
 {
-	struct cred *acred = current->cred;
 	struct inode *inode = dentry->d_inode;
 	struct posix_acl *acl;
 	int type, error = 0;
diff --git a/fs/nfs/nfs4_fs.h b/fs/nfs/nfs4_fs.h
index ac7c050..3f3dc4e 100644
--- a/fs/nfs/nfs4_fs.h
+++ b/fs/nfs/nfs4_fs.h
@@ -167,7 +167,8 @@ extern struct dentry_operations nfs4_dentry_operations;
 extern const struct inode_operations nfs4_dir_inode_operations;
 
 /* inode.c */
-extern ssize_t nfs4_getxattr(struct dentry *, const char *, void *, size_t);
+extern ssize_t nfs4_getxattr(struct dentry *, const char *, void *, size_t,
+			     struct cred *);
 extern int nfs4_setxattr(struct dentry *, const char *, const void *, size_t,
 			 int, struct cred *);
 extern ssize_t nfs4_listxattr(struct dentry *, char *, size_t);
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index a9a88eb..8be911a 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3736,9 +3736,8 @@ int nfs4_setxattr(struct dentry *dentry, const char *key, const void *buf,
  * But we'll follow ext2/ext3's lead by returning -EOPNOTSUPP for unsupported
  * attributes in kernel-managed attribute namespaces. */
 ssize_t nfs4_getxattr(struct dentry *dentry, const char *key, void *buf,
-		size_t buflen)
+		size_t buflen, struct cred *acred)
 {
-	struct cred *acred = current->cred;
 	struct inode *inode = dentry->d_inode;
 
 	if (strcmp(key, XATTR_NAME_NFSV4_ACL) != 0)
diff --git a/fs/xattr.c b/fs/xattr.c
index 634f0b1..3c9bf2e 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -109,6 +109,7 @@ EXPORT_SYMBOL_GPL(vfs_setxattr);
 ssize_t
 vfs_getxattr(struct dentry *dentry, char *name, void *value, size_t size)
 {
+	struct cred *cred = current->cred;
 	struct inode *inode = dentry->d_inode;
 	int error;
 
@@ -121,7 +122,7 @@ vfs_getxattr(struct dentry *dentry, char *name, void *value, size_t size)
 		return error;
 
 	if (inode->i_op->getxattr)
-		error = inode->i_op->getxattr(dentry, name, value, size);
+		error = inode->i_op->getxattr(dentry, name, value, size, cred);
 	else
 		error = -EOPNOTSUPP;
 
@@ -543,9 +544,9 @@ xattr_resolve_name(struct xattr_handler **handlers, const char **name)
  * Find the handler for the prefix and dispatch its get() operation.
  */
 ssize_t
-generic_getxattr(struct dentry *dentry, const char *name, void *buffer, size_t size)
+generic_getxattr(struct dentry *dentry, const char *name, void *buffer, size_t size,
+		 struct cred *cred)
 {
-	struct cred *cred = current->cred;
 	struct xattr_handler *handler;
 	struct inode *inode = dentry->d_inode;
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 598006c..28f0205 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1162,7 +1162,8 @@ struct inode_operations {
 			struct cred *);
 	int (*setxattr) (struct dentry *, const char *,const void *, size_t,
 			 int, struct cred *);
-	ssize_t (*getxattr) (struct dentry *, const char *, void *, size_t);
+	ssize_t (*getxattr) (struct dentry *, const char *, void *, size_t,
+			     struct cred *);
 	ssize_t (*listxattr) (struct dentry *, char *, size_t);
 	int (*removexattr) (struct dentry *, const char *);
 	void (*truncate_range)(struct inode *, loff_t, loff_t);
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index fbd1af5..d17ba8c 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -354,7 +354,8 @@ static inline struct rpc_cred *nfs_file_cred(struct file *file)
  */
 #ifdef CONFIG_NFS_V3_ACL
 extern ssize_t nfs3_listxattr(struct dentry *, char *, size_t);
-extern ssize_t nfs3_getxattr(struct dentry *, const char *, void *, size_t);
+extern ssize_t nfs3_getxattr(struct dentry *, const char *, void *, size_t,
+			     struct cred *);
 extern int nfs3_setxattr(struct dentry *, const char *,
 			const void *, size_t, int, struct cred *);
 extern int nfs3_removexattr (struct dentry *, const char *name);
diff --git a/include/linux/xattr.h b/include/linux/xattr.h
index a5002eb..e702226 100644
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -51,7 +51,8 @@ ssize_t vfs_listxattr(struct dentry *d, char *list, size_t size);
 int vfs_setxattr(struct dentry *, char *, void *, size_t, int);
 int vfs_removexattr(struct dentry *, char *);
 
-ssize_t generic_getxattr(struct dentry *dentry, const char *name, void *buffer, size_t size);
+ssize_t generic_getxattr(struct dentry *dentry, const char *name, void *buffer,
+			 size_t size, struct cred *cred);
 ssize_t generic_listxattr(struct dentry *dentry, char *buffer, size_t buffer_size);
 int generic_setxattr(struct dentry *dentry, const char *name, const void *value,
 		     size_t size, int flags, struct cred *cred);
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 3c3fff3..bcd71b9 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -634,7 +634,8 @@ static int superblock_doinit(struct super_block *sb, void *data)
 			rc = -EOPNOTSUPP;
 			goto out;
 		}
-		rc = inode->i_op->getxattr(root, XATTR_NAME_SELINUX, NULL, 0);
+		rc = inode->i_op->getxattr(root, XATTR_NAME_SELINUX, NULL, 0,
+					   &init_cred);
 		if (rc < 0 && rc != -ENODATA) {
 			if (rc == -EOPNOTSUPP)
 				printk(KERN_WARNING "SELinux: (dev %s, type "
@@ -897,11 +898,11 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
 			goto out_unlock;
 		}
 		rc = inode->i_op->getxattr(dentry, XATTR_NAME_SELINUX,
-					   context, len);
+					   context, len, &init_cred);
 		if (rc == -ERANGE) {
 			/* Need a larger buffer.  Query for the right size. */
 			rc = inode->i_op->getxattr(dentry, XATTR_NAME_SELINUX,
-						   NULL, 0);
+						   NULL, 0, &init_cred);
 			if (rc < 0) {
 				dput(dentry);
 				goto out_unlock;
@@ -916,7 +917,7 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
 			}
 			rc = inode->i_op->getxattr(dentry,
 						   XATTR_NAME_SELINUX,
-						   context, len);
+						   context, len, &init_cred);
 		}
 		dput(dentry);
 		if (rc < 0) {

