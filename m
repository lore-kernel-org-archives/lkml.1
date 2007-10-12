Return-Path: <linux-kernel-owner+w=401wt.eu-S1761146AbXJLQaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761146AbXJLQaR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932433AbXJLQJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:09:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760500AbXJLQJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:09:26 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 47/52] CRED: Pass credentials through the xattr get() handler
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:09:19 +0100
Message-ID: <20071012160919.15119.40974.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pass credentials through the xattr get() handler.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/ext3/acl.c            |    4 ++--
 fs/ext3/xattr_security.c |    2 +-
 fs/ext3/xattr_trusted.c  |    2 +-
 fs/ext3/xattr_user.c     |    2 +-
 fs/xattr.c               |    3 ++-
 include/linux/xattr.h    |    2 +-
 mm/shmem.c               |    3 ++-
 mm/shmem_acl.c           |    4 ++--
 8 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/ext3/acl.c b/fs/ext3/acl.c
index 0f7fd74..0ce1d87 100644
--- a/fs/ext3/acl.c
+++ b/fs/ext3/acl.c
@@ -466,7 +466,7 @@ ext3_xattr_get_acl(struct inode *inode, int type, void *buffer, size_t size)
 
 static int
 ext3_xattr_get_acl_access(struct inode *inode, const char *name,
-			  void *buffer, size_t size)
+			  void *buffer, size_t size, struct cred *cred)
 {
 	if (strcmp(name, "") != 0)
 		return -EINVAL;
@@ -475,7 +475,7 @@ ext3_xattr_get_acl_access(struct inode *inode, const char *name,
 
 static int
 ext3_xattr_get_acl_default(struct inode *inode, const char *name,
-			   void *buffer, size_t size)
+			   void *buffer, size_t size, struct cred *cred)
 {
 	if (strcmp(name, "") != 0)
 		return -EINVAL;
diff --git a/fs/ext3/xattr_security.c b/fs/ext3/xattr_security.c
index 351bbb8..7d01840 100644
--- a/fs/ext3/xattr_security.c
+++ b/fs/ext3/xattr_security.c
@@ -29,7 +29,7 @@ ext3_xattr_security_list(struct inode *inode, char *list, size_t list_size,
 
 static int
 ext3_xattr_security_get(struct inode *inode, const char *name,
-		       void *buffer, size_t size)
+			void *buffer, size_t size, struct cred *cred)
 {
 	if (strcmp(name, "") == 0)
 		return -EINVAL;
diff --git a/fs/ext3/xattr_trusted.c b/fs/ext3/xattr_trusted.c
index d086115..6073729 100644
--- a/fs/ext3/xattr_trusted.c
+++ b/fs/ext3/xattr_trusted.c
@@ -35,7 +35,7 @@ ext3_xattr_trusted_list(struct inode *inode, char *list, size_t list_size,
 
 static int
 ext3_xattr_trusted_get(struct inode *inode, const char *name,
-		       void *buffer, size_t size)
+		       void *buffer, size_t size, struct cred *cred)
 {
 	if (strcmp(name, "") == 0)
 		return -EINVAL;
diff --git a/fs/ext3/xattr_user.c b/fs/ext3/xattr_user.c
index afbfc4d..f8a7663 100644
--- a/fs/ext3/xattr_user.c
+++ b/fs/ext3/xattr_user.c
@@ -34,7 +34,7 @@ ext3_xattr_user_list(struct inode *inode, char *list, size_t list_size,
 
 static int
 ext3_xattr_user_get(struct inode *inode, const char *name,
-		    void *buffer, size_t size)
+		    void *buffer, size_t size, struct cred *cred)
 {
 	if (strcmp(name, "") == 0)
 		return -EINVAL;
diff --git a/fs/xattr.c b/fs/xattr.c
index 257305e..634f0b1 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -545,13 +545,14 @@ xattr_resolve_name(struct xattr_handler **handlers, const char **name)
 ssize_t
 generic_getxattr(struct dentry *dentry, const char *name, void *buffer, size_t size)
 {
+	struct cred *cred = current->cred;
 	struct xattr_handler *handler;
 	struct inode *inode = dentry->d_inode;
 
 	handler = xattr_resolve_name(inode->i_sb->s_xattr, &name);
 	if (!handler)
 		return -EOPNOTSUPP;
-	return handler->get(inode, name, buffer, size);
+	return handler->get(inode, name, buffer, size, cred);
 }
 
 /*
diff --git a/include/linux/xattr.h b/include/linux/xattr.h
index dd98be1..a5002eb 100644
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -41,7 +41,7 @@ struct xattr_handler {
 	size_t (*list)(struct inode *inode, char *list, size_t list_size,
 		       const char *name, size_t name_len);
 	int (*get)(struct inode *inode, const char *name, void *buffer,
-		   size_t size);
+		   size_t size, struct cred *cred);
 	int (*set)(struct inode *inode, const char *name, const void *buffer,
 		   size_t size, int flags, struct cred *cred);
 };
diff --git a/mm/shmem.c b/mm/shmem.c
index a3c2007..45cc69e 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1967,7 +1967,8 @@ static size_t shmem_xattr_security_list(struct inode *inode, char *list,
 }
 
 static int shmem_xattr_security_get(struct inode *inode, const char *name,
-				    void *buffer, size_t size)
+				    void *buffer, size_t size,
+				    struct cred *cred)
 {
 	if (strcmp(name, "") == 0)
 		return -EINVAL;
diff --git a/mm/shmem_acl.c b/mm/shmem_acl.c
index f78720f..7685a67 100644
--- a/mm/shmem_acl.c
+++ b/mm/shmem_acl.c
@@ -79,7 +79,7 @@ shmem_list_acl_access(struct inode *inode, char *list, size_t list_size,
 
 static int
 shmem_get_acl_access(struct inode *inode, const char *name, void *buffer,
-		     size_t size)
+		     size_t size, struct cred *cred)
 {
 	if (strcmp(name, "") != 0)
 		return -EINVAL;
@@ -120,7 +120,7 @@ shmem_list_acl_default(struct inode *inode, char *list, size_t list_size,
 
 static int
 shmem_get_acl_default(struct inode *inode, const char *name, void *buffer,
-		      size_t size)
+		      size_t size, struct cred *cred)
 {
 	if (strcmp(name, "") != 0)
 		return -EINVAL;

