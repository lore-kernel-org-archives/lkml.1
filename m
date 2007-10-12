Return-Path: <linux-kernel-owner+w=401wt.eu-S1762125AbXJLQbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762125AbXJLQbu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932530AbXJLQJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:09:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932522AbXJLQJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:09:41 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 50/52] CRED: Pass credentials through the listxattr() inode op
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:09:35 +0100
Message-ID: <20071012160935.15119.20105.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pass credentials through the listxattr() inode operation.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/bad_inode.c         |    2 +-
 fs/ext3/xattr.c        |    4 ++--
 fs/ext3/xattr.h        |    2 +-
 fs/nfs/nfs3acl.c       |    4 ++--
 fs/nfs/nfs4_fs.h       |    2 +-
 fs/nfs/nfs4proc.c      |    3 ++-
 fs/xattr.c             |    7 ++++---
 include/linux/fs.h     |    2 +-
 include/linux/nfs_fs.h |    2 +-
 include/linux/xattr.h  |    3 ++-
 10 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/fs/bad_inode.c b/fs/bad_inode.c
index b310af3..1b06a95 100644
--- a/fs/bad_inode.c
+++ b/fs/bad_inode.c
@@ -278,7 +278,7 @@ static ssize_t bad_inode_getxattr(struct dentry *dentry, const char *name,
 }
 
 static ssize_t bad_inode_listxattr(struct dentry *dentry, char *buffer,
-			size_t buffer_size)
+			size_t buffer_size, struct cred *cred)
 {
 	return -EIO;
 }
diff --git a/fs/ext3/xattr.c b/fs/ext3/xattr.c
index 464395d..a3ad1a5 100644
--- a/fs/ext3/xattr.c
+++ b/fs/ext3/xattr.c
@@ -143,9 +143,9 @@ ext3_xattr_handler(int name_index)
  * dentry->d_inode->i_mutex: don't care
  */
 ssize_t
-ext3_listxattr(struct dentry *dentry, char *buffer, size_t size)
+ext3_listxattr(struct dentry *dentry, char *buffer, size_t size,
+	       struct cred *cred)
 {
-	struct cred *cred = current->cred;
 	return ext3_xattr_list(dentry->d_inode, buffer, size, cred);
 }
 
diff --git a/fs/ext3/xattr.h b/fs/ext3/xattr.h
index 9ed3328..06f334f 100644
--- a/fs/ext3/xattr.h
+++ b/fs/ext3/xattr.h
@@ -64,7 +64,7 @@ extern struct xattr_handler ext3_xattr_acl_access_handler;
 extern struct xattr_handler ext3_xattr_acl_default_handler;
 extern struct xattr_handler ext3_xattr_security_handler;
 
-extern ssize_t ext3_listxattr(struct dentry *, char *, size_t);
+extern ssize_t ext3_listxattr(struct dentry *, char *, size_t, struct cred *);
 
 extern int ext3_xattr_get(struct inode *, int, const char *, void *, size_t);
 extern int ext3_xattr_list(struct inode *, char *, size_t, struct cred *);
diff --git a/fs/nfs/nfs3acl.c b/fs/nfs/nfs3acl.c
index 0d160be..6e318e2 100644
--- a/fs/nfs/nfs3acl.c
+++ b/fs/nfs/nfs3acl.c
@@ -7,9 +7,9 @@
 
 #define NFSDBG_FACILITY	NFSDBG_PROC
 
-ssize_t nfs3_listxattr(struct dentry *dentry, char *buffer, size_t size)
+ssize_t nfs3_listxattr(struct dentry *dentry, char *buffer, size_t size,
+		       struct cred *acred)
 {
-	struct cred *acred = current->cred;
 	struct inode *inode = dentry->d_inode;
 	struct posix_acl *acl;
 	int pos=0, len=0;
diff --git a/fs/nfs/nfs4_fs.h b/fs/nfs/nfs4_fs.h
index 3f3dc4e..ee76c2c 100644
--- a/fs/nfs/nfs4_fs.h
+++ b/fs/nfs/nfs4_fs.h
@@ -171,7 +171,7 @@ extern ssize_t nfs4_getxattr(struct dentry *, const char *, void *, size_t,
 			     struct cred *);
 extern int nfs4_setxattr(struct dentry *, const char *, const void *, size_t,
 			 int, struct cred *);
-extern ssize_t nfs4_listxattr(struct dentry *, char *, size_t);
+extern ssize_t nfs4_listxattr(struct dentry *, char *, size_t, struct cred *);
 
 
 /* nfs4proc.c */
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 8be911a..4287752 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3746,7 +3746,8 @@ ssize_t nfs4_getxattr(struct dentry *dentry, const char *key, void *buf,
 	return nfs4_proc_get_acl(inode, buf, buflen, acred);
 }
 
-ssize_t nfs4_listxattr(struct dentry *dentry, char *buf, size_t buflen)
+ssize_t nfs4_listxattr(struct dentry *dentry, char *buf, size_t buflen,
+		       struct cred *acred)
 {
 	size_t len = strlen(XATTR_NAME_NFSV4_ACL) + 1;
 
diff --git a/fs/xattr.c b/fs/xattr.c
index b1ee403..7b3bd56 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -146,6 +146,7 @@ EXPORT_SYMBOL_GPL(vfs_getxattr);
 ssize_t
 vfs_listxattr(struct dentry *d, char *list, size_t size)
 {
+	struct cred *cred = current->cred;
 	ssize_t error;
 
 	error = security_inode_listxattr(d);
@@ -153,7 +154,7 @@ vfs_listxattr(struct dentry *d, char *list, size_t size)
 		return error;
 	error = -EOPNOTSUPP;
 	if (d->d_inode->i_op && d->d_inode->i_op->listxattr) {
-		error = d->d_inode->i_op->listxattr(d, list, size);
+		error = d->d_inode->i_op->listxattr(d, list, size, cred);
 	} else {
 		error = security_inode_listsecurity(d->d_inode, list, size);
 		if (size && error > size)
@@ -561,9 +562,9 @@ generic_getxattr(struct dentry *dentry, const char *name, void *buffer, size_t s
  * list.
  */
 ssize_t
-generic_listxattr(struct dentry *dentry, char *buffer, size_t buffer_size)
+generic_listxattr(struct dentry *dentry, char *buffer, size_t buffer_size,
+		  struct cred *cred)
 {
-	struct cred *cred = current->cred;
 	struct inode *inode = dentry->d_inode;
 	struct xattr_handler *handler, **handlers = inode->i_sb->s_xattr;
 	unsigned int size = 0;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 28f0205..308b3a3 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1164,7 +1164,7 @@ struct inode_operations {
 			 int, struct cred *);
 	ssize_t (*getxattr) (struct dentry *, const char *, void *, size_t,
 			     struct cred *);
-	ssize_t (*listxattr) (struct dentry *, char *, size_t);
+	ssize_t (*listxattr) (struct dentry *, char *, size_t, struct cred *);
 	int (*removexattr) (struct dentry *, const char *);
 	void (*truncate_range)(struct inode *, loff_t, loff_t);
 	long (*fallocate)(struct inode *inode, int mode, loff_t offset,
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index d17ba8c..da642ac 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -353,7 +353,7 @@ static inline struct rpc_cred *nfs_file_cred(struct file *file)
  * linux/fs/nfs/xattr.c
  */
 #ifdef CONFIG_NFS_V3_ACL
-extern ssize_t nfs3_listxattr(struct dentry *, char *, size_t);
+extern ssize_t nfs3_listxattr(struct dentry *, char *, size_t, struct cred *);
 extern ssize_t nfs3_getxattr(struct dentry *, const char *, void *, size_t,
 			     struct cred *);
 extern int nfs3_setxattr(struct dentry *, const char *,
diff --git a/include/linux/xattr.h b/include/linux/xattr.h
index 485d57c..8b1237a 100644
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -53,7 +53,8 @@ int vfs_removexattr(struct dentry *, char *);
 
 ssize_t generic_getxattr(struct dentry *dentry, const char *name, void *buffer,
 			 size_t size, struct cred *cred);
-ssize_t generic_listxattr(struct dentry *dentry, char *buffer, size_t buffer_size);
+ssize_t generic_listxattr(struct dentry *dentry, char *buffer,
+			  size_t buffer_size, struct cred *cred);
 int generic_setxattr(struct dentry *dentry, const char *name, const void *value,
 		     size_t size, int flags, struct cred *cred);
 int generic_removexattr(struct dentry *dentry, const char *name);

