Return-Path: <linux-kernel-owner+w=401wt.eu-S1762098AbXJLQc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762098AbXJLQc1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759799AbXJLQJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:09:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932537AbXJLQJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:09:46 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 51/52] CRED: Pass credentials through the removexattr() inode
	op
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:09:40 +0100
Message-ID: <20071012160940.15119.8358.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pass credentials through the removexattr() inode operation.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/bad_inode.c         |    3 ++-
 fs/nfs/nfs3acl.c       |    4 ++--
 fs/xattr.c             |    7 ++++---
 include/linux/fs.h     |    2 +-
 include/linux/nfs_fs.h |    2 +-
 include/linux/xattr.h  |    3 ++-
 6 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/fs/bad_inode.c b/fs/bad_inode.c
index 1b06a95..5fde74f 100644
--- a/fs/bad_inode.c
+++ b/fs/bad_inode.c
@@ -283,7 +283,8 @@ static ssize_t bad_inode_listxattr(struct dentry *dentry, char *buffer,
 	return -EIO;
 }
 
-static int bad_inode_removexattr(struct dentry *dentry, const char *name)
+static int bad_inode_removexattr(struct dentry *dentry, const char *name,
+				 struct cred *cred)
 {
 	return -EIO;
 }
diff --git a/fs/nfs/nfs3acl.c b/fs/nfs/nfs3acl.c
index 6e318e2..143627c 100644
--- a/fs/nfs/nfs3acl.c
+++ b/fs/nfs/nfs3acl.c
@@ -99,9 +99,9 @@ int nfs3_setxattr(struct dentry *dentry, const char *name,
 	return error;
 }
 
-int nfs3_removexattr(struct dentry *dentry, const char *name)
+int nfs3_removexattr(struct dentry *dentry, const char *name,
+		     struct cred *acred)
 {
-	struct cred *acred = current->cred;
 	struct inode *inode = dentry->d_inode;
 	int type;
 
diff --git a/fs/xattr.c b/fs/xattr.c
index 7b3bd56..dee1ac4 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -167,6 +167,7 @@ EXPORT_SYMBOL_GPL(vfs_listxattr);
 int
 vfs_removexattr(struct dentry *dentry, char *name)
 {
+	struct cred *cred = current->cred;
 	struct inode *inode = dentry->d_inode;
 	int error;
 
@@ -182,7 +183,7 @@ vfs_removexattr(struct dentry *dentry, char *name)
 		return error;
 
 	mutex_lock(&inode->i_mutex);
-	error = inode->i_op->removexattr(dentry, name);
+	error = inode->i_op->removexattr(dentry, name, cred);
 	mutex_unlock(&inode->i_mutex);
 
 	if (!error)
@@ -611,9 +612,9 @@ generic_setxattr(struct dentry *dentry, const char *name, const void *value,
  * any associated extended attribute.
  */
 int
-generic_removexattr(struct dentry *dentry, const char *name)
+generic_removexattr(struct dentry *dentry, const char *name,
+		    struct cred *cred)
 {
-	struct cred *cred = current->cred;
 	struct xattr_handler *handler;
 	struct inode *inode = dentry->d_inode;
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 308b3a3..754e4ec 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1165,7 +1165,7 @@ struct inode_operations {
 	ssize_t (*getxattr) (struct dentry *, const char *, void *, size_t,
 			     struct cred *);
 	ssize_t (*listxattr) (struct dentry *, char *, size_t, struct cred *);
-	int (*removexattr) (struct dentry *, const char *);
+	int (*removexattr) (struct dentry *, const char *, struct cred *);
 	void (*truncate_range)(struct inode *, loff_t, loff_t);
 	long (*fallocate)(struct inode *inode, int mode, loff_t offset,
 			  loff_t len);
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index da642ac..4733c6c 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -358,7 +358,7 @@ extern ssize_t nfs3_getxattr(struct dentry *, const char *, void *, size_t,
 			     struct cred *);
 extern int nfs3_setxattr(struct dentry *, const char *,
 			const void *, size_t, int, struct cred *);
-extern int nfs3_removexattr (struct dentry *, const char *name);
+extern int nfs3_removexattr (struct dentry *, const char *, struct cred *);
 #else
 # define nfs3_listxattr NULL
 # define nfs3_getxattr NULL
diff --git a/include/linux/xattr.h b/include/linux/xattr.h
index 8b1237a..0e79b32 100644
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -57,7 +57,8 @@ ssize_t generic_listxattr(struct dentry *dentry, char *buffer,
 			  size_t buffer_size, struct cred *cred);
 int generic_setxattr(struct dentry *dentry, const char *name, const void *value,
 		     size_t size, int flags, struct cred *cred);
-int generic_removexattr(struct dentry *dentry, const char *name);
+int generic_removexattr(struct dentry *dentry, const char *name,
+			struct cred *cred);
 
 #endif  /*  __KERNEL__  */
 

