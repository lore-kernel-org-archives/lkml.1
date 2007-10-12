Return-Path: <linux-kernel-owner+w=401wt.eu-S1762015AbXJLQbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762015AbXJLQbU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932510AbXJLQJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:09:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44057 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932460AbXJLQJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:09:37 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 49/52] CRED: Pass credentials through the xattr list() handler
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:09:30 +0100
Message-ID: <20071012160929.15119.75839.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pass credentials through the xattr list() handler.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/ext3/acl.c            |    5 +++--
 fs/ext3/xattr.c          |   27 +++++++++++++++++----------
 fs/ext3/xattr.h          |    2 +-
 fs/ext3/xattr_security.c |    2 +-
 fs/ext3/xattr_trusted.c  |    2 +-
 fs/ext3/xattr_user.c     |    2 +-
 fs/xattr.c               |    6 ++++--
 include/linux/xattr.h    |    2 +-
 mm/shmem.c               |    2 +-
 mm/shmem_acl.c           |    4 ++--
 10 files changed, 32 insertions(+), 22 deletions(-)

diff --git a/fs/ext3/acl.c b/fs/ext3/acl.c
index 0ce1d87..b2d676e 100644
--- a/fs/ext3/acl.c
+++ b/fs/ext3/acl.c
@@ -420,7 +420,7 @@ out:
  */
 static size_t
 ext3_xattr_list_acl_access(struct inode *inode, char *list, size_t list_len,
-			   const char *name, size_t name_len)
+			   const char *name, size_t name_len, struct cred *cred)
 {
 	const size_t size = sizeof(POSIX_ACL_XATTR_ACCESS);
 
@@ -433,7 +433,8 @@ ext3_xattr_list_acl_access(struct inode *inode, char *list, size_t list_len,
 
 static size_t
 ext3_xattr_list_acl_default(struct inode *inode, char *list, size_t list_len,
-			    const char *name, size_t name_len)
+			    const char *name, size_t name_len,
+			    struct cred *cred)
 {
 	const size_t size = sizeof(POSIX_ACL_XATTR_DEFAULT);
 
diff --git a/fs/ext3/xattr.c b/fs/ext3/xattr.c
index 3b34cea..464395d 100644
--- a/fs/ext3/xattr.c
+++ b/fs/ext3/xattr.c
@@ -145,7 +145,8 @@ ext3_xattr_handler(int name_index)
 ssize_t
 ext3_listxattr(struct dentry *dentry, char *buffer, size_t size)
 {
-	return ext3_xattr_list(dentry->d_inode, buffer, size);
+	struct cred *cred = current->cred;
+	return ext3_xattr_list(dentry->d_inode, buffer, size, cred);
 }
 
 static int
@@ -331,7 +332,7 @@ ext3_xattr_get(struct inode *inode, int name_index, const char *name,
 
 static int
 ext3_xattr_list_entries(struct inode *inode, struct ext3_xattr_entry *entry,
-			char *buffer, size_t buffer_size)
+			char *buffer, size_t buffer_size, struct cred *cred)
 {
 	size_t rest = buffer_size;
 
@@ -342,7 +343,8 @@ ext3_xattr_list_entries(struct inode *inode, struct ext3_xattr_entry *entry,
 		if (handler) {
 			size_t size = handler->list(inode, buffer, rest,
 						    entry->e_name,
-						    entry->e_name_len);
+						    entry->e_name_len,
+						    cred);
 			if (buffer) {
 				if (size > rest)
 					return -ERANGE;
@@ -355,7 +357,8 @@ ext3_xattr_list_entries(struct inode *inode, struct ext3_xattr_entry *entry,
 }
 
 static int
-ext3_xattr_block_list(struct inode *inode, char *buffer, size_t buffer_size)
+ext3_xattr_block_list(struct inode *inode, char *buffer, size_t buffer_size,
+		      struct cred *cred)
 {
 	struct buffer_head *bh = NULL;
 	int error;
@@ -381,7 +384,8 @@ ext3_xattr_block_list(struct inode *inode, char *buffer, size_t buffer_size)
 		goto cleanup;
 	}
 	ext3_xattr_cache_insert(bh);
-	error = ext3_xattr_list_entries(inode, BFIRST(bh), buffer, buffer_size);
+	error = ext3_xattr_list_entries(inode, BFIRST(bh), buffer, buffer_size,
+					cred);
 
 cleanup:
 	brelse(bh);
@@ -390,7 +394,8 @@ cleanup:
 }
 
 static int
-ext3_xattr_ibody_list(struct inode *inode, char *buffer, size_t buffer_size)
+ext3_xattr_ibody_list(struct inode *inode, char *buffer, size_t buffer_size,
+		      struct cred *cred)
 {
 	struct ext3_xattr_ibody_header *header;
 	struct ext3_inode *raw_inode;
@@ -410,7 +415,7 @@ ext3_xattr_ibody_list(struct inode *inode, char *buffer, size_t buffer_size)
 	if (error)
 		goto cleanup;
 	error = ext3_xattr_list_entries(inode, IFIRST(header),
-					buffer, buffer_size);
+					buffer, buffer_size, cred);
 
 cleanup:
 	brelse(iloc.bh);
@@ -428,12 +433,13 @@ cleanup:
  * used / required on success.
  */
 int
-ext3_xattr_list(struct inode *inode, char *buffer, size_t buffer_size)
+ext3_xattr_list(struct inode *inode, char *buffer, size_t buffer_size,
+		struct cred *cred)
 {
 	int i_error, b_error;
 
 	down_read(&EXT3_I(inode)->xattr_sem);
-	i_error = ext3_xattr_ibody_list(inode, buffer, buffer_size);
+	i_error = ext3_xattr_ibody_list(inode, buffer, buffer_size, cred);
 	if (i_error < 0) {
 		b_error = 0;
 	} else {
@@ -441,7 +447,8 @@ ext3_xattr_list(struct inode *inode, char *buffer, size_t buffer_size)
 			buffer += i_error;
 			buffer_size -= i_error;
 		}
-		b_error = ext3_xattr_block_list(inode, buffer, buffer_size);
+		b_error = ext3_xattr_block_list(inode, buffer, buffer_size,
+						cred);
 		if (b_error < 0)
 			i_error = 0;
 	}
diff --git a/fs/ext3/xattr.h b/fs/ext3/xattr.h
index 8d00a18..9ed3328 100644
--- a/fs/ext3/xattr.h
+++ b/fs/ext3/xattr.h
@@ -67,7 +67,7 @@ extern struct xattr_handler ext3_xattr_security_handler;
 extern ssize_t ext3_listxattr(struct dentry *, char *, size_t);
 
 extern int ext3_xattr_get(struct inode *, int, const char *, void *, size_t);
-extern int ext3_xattr_list(struct inode *, char *, size_t);
+extern int ext3_xattr_list(struct inode *, char *, size_t, struct cred *);
 extern int ext3_xattr_set(struct inode *, int, const char *, const void *,
 			  size_t, int, struct cred *);
 extern int ext3_xattr_set_handle(handle_t *, struct inode *, int, const char *,
diff --git a/fs/ext3/xattr_security.c b/fs/ext3/xattr_security.c
index 7d01840..1680b7b 100644
--- a/fs/ext3/xattr_security.c
+++ b/fs/ext3/xattr_security.c
@@ -13,7 +13,7 @@
 
 static size_t
 ext3_xattr_security_list(struct inode *inode, char *list, size_t list_size,
-			 const char *name, size_t name_len)
+			 const char *name, size_t name_len, struct cred *cred)
 {
 	const size_t prefix_len = sizeof(XATTR_SECURITY_PREFIX)-1;
 	const size_t total_len = prefix_len + name_len + 1;
diff --git a/fs/ext3/xattr_trusted.c b/fs/ext3/xattr_trusted.c
index 6073729..049587b 100644
--- a/fs/ext3/xattr_trusted.c
+++ b/fs/ext3/xattr_trusted.c
@@ -17,7 +17,7 @@
 
 static size_t
 ext3_xattr_trusted_list(struct inode *inode, char *list, size_t list_size,
-			const char *name, size_t name_len)
+			const char *name, size_t name_len, struct cred *cred)
 {
 	const size_t prefix_len = sizeof(XATTR_TRUSTED_PREFIX)-1;
 	const size_t total_len = prefix_len + name_len + 1;
diff --git a/fs/ext3/xattr_user.c b/fs/ext3/xattr_user.c
index f8a7663..6012c7e 100644
--- a/fs/ext3/xattr_user.c
+++ b/fs/ext3/xattr_user.c
@@ -16,7 +16,7 @@
 
 static size_t
 ext3_xattr_user_list(struct inode *inode, char *list, size_t list_size,
-		     const char *name, size_t name_len)
+		     const char *name, size_t name_len, struct cred *cred)
 {
 	const size_t prefix_len = sizeof(XATTR_USER_PREFIX)-1;
 	const size_t total_len = prefix_len + name_len + 1;
diff --git a/fs/xattr.c b/fs/xattr.c
index 3c9bf2e..b1ee403 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -563,18 +563,20 @@ generic_getxattr(struct dentry *dentry, const char *name, void *buffer, size_t s
 ssize_t
 generic_listxattr(struct dentry *dentry, char *buffer, size_t buffer_size)
 {
+	struct cred *cred = current->cred;
 	struct inode *inode = dentry->d_inode;
 	struct xattr_handler *handler, **handlers = inode->i_sb->s_xattr;
 	unsigned int size = 0;
 
 	if (!buffer) {
 		for_each_xattr_handler(handlers, handler)
-			size += handler->list(inode, NULL, 0, NULL, 0);
+			size += handler->list(inode, NULL, 0, NULL, 0, cred);
 	} else {
 		char *buf = buffer;
 
 		for_each_xattr_handler(handlers, handler) {
-			size = handler->list(inode, buf, buffer_size, NULL, 0);
+			size = handler->list(inode, buf, buffer_size, NULL, 0,
+					     cred);
 			if (size > buffer_size)
 				return -ERANGE;
 			buf += size;
diff --git a/include/linux/xattr.h b/include/linux/xattr.h
index e702226..485d57c 100644
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -39,7 +39,7 @@ struct dentry;
 struct xattr_handler {
 	char *prefix;
 	size_t (*list)(struct inode *inode, char *list, size_t list_size,
-		       const char *name, size_t name_len);
+		       const char *name, size_t name_len, struct cred *cred);
 	int (*get)(struct inode *inode, const char *name, void *buffer,
 		   size_t size, struct cred *cred);
 	int (*set)(struct inode *inode, const char *name, const void *buffer,
diff --git a/mm/shmem.c b/mm/shmem.c
index 45cc69e..24d3237 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1961,7 +1961,7 @@ static const struct inode_operations shmem_symlink_inode_operations = {
 
 static size_t shmem_xattr_security_list(struct inode *inode, char *list,
 					size_t list_len, const char *name,
-					size_t name_len)
+					size_t name_len, struct cred *cred)
 {
 	return security_inode_listsecurity(inode, list, list_len);
 }
diff --git a/mm/shmem_acl.c b/mm/shmem_acl.c
index 7685a67..cda0a12 100644
--- a/mm/shmem_acl.c
+++ b/mm/shmem_acl.c
@@ -71,7 +71,7 @@ struct generic_acl_operations shmem_acl_ops = {
 
 static size_t
 shmem_list_acl_access(struct inode *inode, char *list, size_t list_size,
-		      const char *name, size_t name_len)
+		      const char *name, size_t name_len, struct cred *cred)
 {
 	return generic_acl_list(inode, &shmem_acl_ops, ACL_TYPE_ACCESS,
 				list, list_size);
@@ -112,7 +112,7 @@ struct xattr_handler shmem_xattr_acl_access_handler = {
 
 static size_t
 shmem_list_acl_default(struct inode *inode, char *list, size_t list_size,
-		       const char *name, size_t name_len)
+		       const char *name, size_t name_len, struct cred *cred)
 {
 	return generic_acl_list(inode, &shmem_acl_ops, ACL_TYPE_DEFAULT,
 				list, list_size);

