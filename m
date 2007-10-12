Return-Path: <linux-kernel-owner+w=401wt.eu-S1761387AbXJLQ3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761387AbXJLQ3q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760308AbXJLQJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:09:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44036 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760599AbXJLQJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:09:21 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 46/52] CRED: Pass credentials through the setxattr() inode op
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:09:14 +0100
Message-ID: <20071012160914.15119.43637.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pass credentials through the setxattr() inode operation.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/bad_inode.c         |    2 +-
 fs/nfs/nfs3acl.c       |    3 +--
 fs/nfs/nfs4_fs.h       |    3 ++-
 fs/nfs/nfs4proc.c      |    3 +--
 fs/xattr.c             |    8 +++++---
 include/linux/fs.h     |    3 ++-
 include/linux/nfs_fs.h |    2 +-
 include/linux/xattr.h  |    3 ++-
 8 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/fs/bad_inode.c b/fs/bad_inode.c
index a891eaa..d82d101 100644
--- a/fs/bad_inode.c
+++ b/fs/bad_inode.c
@@ -266,7 +266,7 @@ static int bad_inode_setattr(struct dentry *direntry, struct iattr *attrs,
 }
 
 static int bad_inode_setxattr(struct dentry *dentry, const char *name,
-		const void *value, size_t size, int flags)
+		const void *value, size_t size, int flags, struct cred *cred)
 {
 	return -EIO;
 }
diff --git a/fs/nfs/nfs3acl.c b/fs/nfs/nfs3acl.c
index 0fefed1..c09da17 100644
--- a/fs/nfs/nfs3acl.c
+++ b/fs/nfs/nfs3acl.c
@@ -78,9 +78,8 @@ ssize_t nfs3_getxattr(struct dentry *dentry, const char *name,
 }
 
 int nfs3_setxattr(struct dentry *dentry, const char *name,
-	     const void *value, size_t size, int flags)
+	     const void *value, size_t size, int flags, struct cred *acred)
 {
-	struct cred *acred = current->cred;
 	struct inode *inode = dentry->d_inode;
 	struct posix_acl *acl;
 	int type, error;
diff --git a/fs/nfs/nfs4_fs.h b/fs/nfs/nfs4_fs.h
index 007329e..ac7c050 100644
--- a/fs/nfs/nfs4_fs.h
+++ b/fs/nfs/nfs4_fs.h
@@ -168,7 +168,8 @@ extern const struct inode_operations nfs4_dir_inode_operations;
 
 /* inode.c */
 extern ssize_t nfs4_getxattr(struct dentry *, const char *, void *, size_t);
-extern int nfs4_setxattr(struct dentry *, const char *, const void *, size_t, int);
+extern int nfs4_setxattr(struct dentry *, const char *, const void *, size_t,
+			 int, struct cred *);
 extern ssize_t nfs4_listxattr(struct dentry *, char *, size_t);
 
 
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index c10f3de..a9a88eb 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3717,9 +3717,8 @@ out:
 #define XATTR_NAME_NFSV4_ACL "system.nfs4_acl"
 
 int nfs4_setxattr(struct dentry *dentry, const char *key, const void *buf,
-		size_t buflen, int flags)
+		size_t buflen, int flags, struct cred *acred)
 {
-	struct cred *acred = current->cred;
 	struct inode *inode = dentry->d_inode;
 
 	if (strcmp(key, XATTR_NAME_NFSV4_ACL) != 0)
diff --git a/fs/xattr.c b/fs/xattr.c
index 7917579..257305e 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -71,6 +71,7 @@ int
 vfs_setxattr(struct dentry *dentry, char *name, void *value,
 		size_t size, int flags)
 {
+	struct cred *cred = current->cred;
 	struct inode *inode = dentry->d_inode;
 	int error;
 
@@ -84,7 +85,8 @@ vfs_setxattr(struct dentry *dentry, char *name, void *value,
 		goto out;
 	error = -EOPNOTSUPP;
 	if (inode->i_op->setxattr) {
-		error = inode->i_op->setxattr(dentry, name, value, size, flags);
+		error = inode->i_op->setxattr(dentry, name, value, size, flags,
+					      cred);
 		if (!error) {
 			fsnotify_xattr(dentry);
 			security_inode_post_setxattr(dentry, name, value,
@@ -585,9 +587,9 @@ generic_listxattr(struct dentry *dentry, char *buffer, size_t buffer_size)
  * Find the handler for the prefix and dispatch its set() operation.
  */
 int
-generic_setxattr(struct dentry *dentry, const char *name, const void *value, size_t size, int flags)
+generic_setxattr(struct dentry *dentry, const char *name, const void *value,
+		 size_t size, int flags, struct cred *cred)
 {
-	struct cred *cred = current->cred;
 	struct xattr_handler *handler;
 	struct inode *inode = dentry->d_inode;
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 395b272..598006c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1160,7 +1160,8 @@ struct inode_operations {
 	int (*setattr) (struct dentry *, struct iattr *, struct cred *);
 	int (*getattr) (struct vfsmount *, struct dentry *, struct kstat *,
 			struct cred *);
-	int (*setxattr) (struct dentry *, const char *,const void *,size_t,int);
+	int (*setxattr) (struct dentry *, const char *,const void *, size_t,
+			 int, struct cred *);
 	ssize_t (*getxattr) (struct dentry *, const char *, void *, size_t);
 	ssize_t (*listxattr) (struct dentry *, char *, size_t);
 	int (*removexattr) (struct dentry *, const char *);
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index d26fd56..fbd1af5 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -356,7 +356,7 @@ static inline struct rpc_cred *nfs_file_cred(struct file *file)
 extern ssize_t nfs3_listxattr(struct dentry *, char *, size_t);
 extern ssize_t nfs3_getxattr(struct dentry *, const char *, void *, size_t);
 extern int nfs3_setxattr(struct dentry *, const char *,
-			const void *, size_t, int);
+			const void *, size_t, int, struct cred *);
 extern int nfs3_removexattr (struct dentry *, const char *name);
 #else
 # define nfs3_listxattr NULL
diff --git a/include/linux/xattr.h b/include/linux/xattr.h
index 50c35d9..dd98be1 100644
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -53,7 +53,8 @@ int vfs_removexattr(struct dentry *, char *);
 
 ssize_t generic_getxattr(struct dentry *dentry, const char *name, void *buffer, size_t size);
 ssize_t generic_listxattr(struct dentry *dentry, char *buffer, size_t buffer_size);
-int generic_setxattr(struct dentry *dentry, const char *name, const void *value, size_t size, int flags);
+int generic_setxattr(struct dentry *dentry, const char *name, const void *value,
+		     size_t size, int flags, struct cred *cred);
 int generic_removexattr(struct dentry *dentry, const char *name);
 
 #endif  /*  __KERNEL__  */

