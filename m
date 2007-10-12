Return-Path: <linux-kernel-owner+w=401wt.eu-S1761687AbXJLQXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761687AbXJLQXu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932465AbXJLQIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:08:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932421AbXJLQI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:08:27 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 35/52] CRED: Make the ACL set() handler take a credentials
	pointer
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:08:18 +0100
Message-ID: <20071012160818.15119.28784.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make the ACL set() handler take a credentials pointer.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/ext3/acl.c            |    8 ++++----
 fs/ext3/xattr_security.c |    5 ++---
 fs/ext3/xattr_trusted.c  |    5 ++---
 fs/ext3/xattr_user.c     |    5 ++---
 fs/xattr.c               |    6 ++++--
 include/linux/xattr.h    |    2 +-
 mm/shmem.c               |    3 ++-
 mm/shmem_acl.c           |    4 ++--
 8 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/fs/ext3/acl.c b/fs/ext3/acl.c
index 239efa9..3122db9 100644
--- a/fs/ext3/acl.c
+++ b/fs/ext3/acl.c
@@ -523,9 +523,9 @@ release_and_out:
 
 static int
 ext3_xattr_set_acl_access(struct inode *inode, const char *name,
-			  const void *value, size_t size, int flags)
+			  const void *value, size_t size, int flags,
+			  struct cred *cred)
 {
-	struct cred *cred = current->cred;
 	if (strcmp(name, "") != 0)
 		return -EINVAL;
 	return ext3_xattr_set_acl(inode, ACL_TYPE_ACCESS, value, size, cred);
@@ -533,9 +533,9 @@ ext3_xattr_set_acl_access(struct inode *inode, const char *name,
 
 static int
 ext3_xattr_set_acl_default(struct inode *inode, const char *name,
-			   const void *value, size_t size, int flags)
+			   const void *value, size_t size, int flags,
+			   struct cred *cred)
 {
-	struct cred *cred = current->cred;
 	if (strcmp(name, "") != 0)
 		return -EINVAL;
 	return ext3_xattr_set_acl(inode, ACL_TYPE_DEFAULT, value, size, cred);
diff --git a/fs/ext3/xattr_security.c b/fs/ext3/xattr_security.c
index 9a949e3..351bbb8 100644
--- a/fs/ext3/xattr_security.c
+++ b/fs/ext3/xattr_security.c
@@ -39,10 +39,9 @@ ext3_xattr_security_get(struct inode *inode, const char *name,
 
 static int
 ext3_xattr_security_set(struct inode *inode, const char *name,
-		       const void *value, size_t size, int flags)
+			const void *value, size_t size, int flags,
+			struct cred *cred)
 {
-	struct cred *cred = current->cred;
-
 	if (strcmp(name, "") == 0)
 		return -EINVAL;
 	return ext3_xattr_set(inode, EXT3_XATTR_INDEX_SECURITY, name,
diff --git a/fs/ext3/xattr_trusted.c b/fs/ext3/xattr_trusted.c
index eead225..d086115 100644
--- a/fs/ext3/xattr_trusted.c
+++ b/fs/ext3/xattr_trusted.c
@@ -45,10 +45,9 @@ ext3_xattr_trusted_get(struct inode *inode, const char *name,
 
 static int
 ext3_xattr_trusted_set(struct inode *inode, const char *name,
-		       const void *value, size_t size, int flags)
+		       const void *value, size_t size, int flags,
+		       struct cred *cred)
 {
-	struct cred *cred = current->cred;
-
 	if (strcmp(name, "") == 0)
 		return -EINVAL;
 	return ext3_xattr_set(inode, EXT3_XATTR_INDEX_TRUSTED, name,
diff --git a/fs/ext3/xattr_user.c b/fs/ext3/xattr_user.c
index 1aa87ae..afbfc4d 100644
--- a/fs/ext3/xattr_user.c
+++ b/fs/ext3/xattr_user.c
@@ -45,10 +45,9 @@ ext3_xattr_user_get(struct inode *inode, const char *name,
 
 static int
 ext3_xattr_user_set(struct inode *inode, const char *name,
-		    const void *value, size_t size, int flags)
+		    const void *value, size_t size, int flags,
+		    struct cred *cred)
 {
-	struct cred *cred = current->cred;
-
 	if (strcmp(name, "") == 0)
 		return -EINVAL;
 	if (!test_opt(inode->i_sb, XATTR_USER))
diff --git a/fs/xattr.c b/fs/xattr.c
index a44fd92..7917579 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -587,6 +587,7 @@ generic_listxattr(struct dentry *dentry, char *buffer, size_t buffer_size)
 int
 generic_setxattr(struct dentry *dentry, const char *name, const void *value, size_t size, int flags)
 {
+	struct cred *cred = current->cred;
 	struct xattr_handler *handler;
 	struct inode *inode = dentry->d_inode;
 
@@ -595,7 +596,7 @@ generic_setxattr(struct dentry *dentry, const char *name, const void *value, siz
 	handler = xattr_resolve_name(inode->i_sb->s_xattr, &name);
 	if (!handler)
 		return -EOPNOTSUPP;
-	return handler->set(inode, name, value, size, flags);
+	return handler->set(inode, name, value, size, flags, cred);
 }
 
 /*
@@ -605,13 +606,14 @@ generic_setxattr(struct dentry *dentry, const char *name, const void *value, siz
 int
 generic_removexattr(struct dentry *dentry, const char *name)
 {
+	struct cred *cred = current->cred;
 	struct xattr_handler *handler;
 	struct inode *inode = dentry->d_inode;
 
 	handler = xattr_resolve_name(inode->i_sb->s_xattr, &name);
 	if (!handler)
 		return -EOPNOTSUPP;
-	return handler->set(inode, name, NULL, 0, XATTR_REPLACE);
+	return handler->set(inode, name, NULL, 0, XATTR_REPLACE, cred);
 }
 
 EXPORT_SYMBOL(generic_getxattr);
diff --git a/include/linux/xattr.h b/include/linux/xattr.h
index def131a..50c35d9 100644
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -43,7 +43,7 @@ struct xattr_handler {
 	int (*get)(struct inode *inode, const char *name, void *buffer,
 		   size_t size);
 	int (*set)(struct inode *inode, const char *name, const void *buffer,
-		   size_t size, int flags);
+		   size_t size, int flags, struct cred *cred);
 };
 
 ssize_t vfs_getxattr(struct dentry *, char *, void *, size_t);
diff --git a/mm/shmem.c b/mm/shmem.c
index ee0b20a..ab44c06 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1972,7 +1972,8 @@ static int shmem_xattr_security_get(struct inode *inode, const char *name,
 }
 
 static int shmem_xattr_security_set(struct inode *inode, const char *name,
-				    const void *value, size_t size, int flags)
+				    const void *value, size_t size, int flags,
+				    struct cred *cred)
 {
 	if (strcmp(name, "") == 0)
 		return -EINVAL;
diff --git a/mm/shmem_acl.c b/mm/shmem_acl.c
index f5664c5..0c7f1f2 100644
--- a/mm/shmem_acl.c
+++ b/mm/shmem_acl.c
@@ -89,7 +89,7 @@ shmem_get_acl_access(struct inode *inode, const char *name, void *buffer,
 
 static int
 shmem_set_acl_access(struct inode *inode, const char *name, const void *value,
-		     size_t size, int flags)
+		     size_t size, int flags, struct cred *cred)
 {
 	if (strcmp(name, "") != 0)
 		return -EINVAL;
@@ -130,7 +130,7 @@ shmem_get_acl_default(struct inode *inode, const char *name, void *buffer,
 
 static int
 shmem_set_acl_default(struct inode *inode, const char *name, const void *value,
-		      size_t size, int flags)
+		      size_t size, int flags, struct cred *cred)
 {
 	if (strcmp(name, "") != 0)
 		return -EINVAL;

