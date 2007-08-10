Return-Path: <linux-kernel-owner+w=401wt.eu-S941250AbXHJQOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941250AbXHJQOF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 12:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940407AbXHJQGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 12:06:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S940392AbXHJQGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 12:06:42 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 11/16] CacheFiles: Permit an inode's security ID to be
	obtained [try #3]
To: torvalds@osdl.org, akpm@osdl.org, steved@redhat.com,
       trond.myklebust@fys.uio.no
Cc: linux-fsdevel@vger.kernel.org, linux-cachefs@redhat.com,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov
Date: Fri, 10 Aug 2007 17:05:53 +0100
Message-ID: <20070810160553.24698.5628.stgit@warthog.cambridge.redhat.com>
In-Reply-To: <20070810160455.24698.30983.stgit@warthog.cambridge.redhat.com>
References: <20070810160455.24698.30983.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Permit an inode's security ID to be obtained by the CacheFiles module.  This is
then used as the SID with which files and directories will be created in the
cache.

Signed-Off-By: David Howells <dhowells@redhat.com>
---

 include/linux/security.h |   19 +++++++++++++++++++
 security/dummy.c         |    7 +++++++
 security/selinux/hooks.c |    9 +++++++++
 3 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 194ef49..a54958a 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -414,6 +414,11 @@ struct request_sock;
  *	the size of the buffer required.
  *	Returns number of bytes used/required on success.
  *
+ * @inode_get_secid:
+ *	Retrieve the security ID from an inode.
+ *	@inode refers to the inode to get the security ID from.
+ *	@secid points the location in which to return the security ID.
+ *
  * Security hooks for file operations
  *
  * @file_permission:
@@ -1256,6 +1261,7 @@ struct security_operations {
   	int (*inode_getsecurity)(const struct inode *inode, const char *name, void *buffer, size_t size, int err);
   	int (*inode_setsecurity)(struct inode *inode, const char *name, const void *value, size_t size, int flags);
   	int (*inode_listsecurity)(struct inode *inode, char *buffer, size_t buffer_size);
+	int (*inode_get_secid)(struct inode *inode, u32 *secid);
 
 	int (*file_permission) (struct file * file, int mask);
 	int (*file_alloc_security) (struct file * file);
@@ -1818,6 +1824,13 @@ static inline int security_inode_listsecurity(struct inode *inode, char *buffer,
 	return security_ops->inode_listsecurity(inode, buffer, buffer_size);
 }
 
+static inline int security_inode_get_secid(struct inode *inode, u32 *secid)
+{
+	if (unlikely(IS_PRIVATE(inode)))
+		return 0;
+	return security_ops->inode_get_secid(inode, secid);
+}
+
 static inline int security_file_permission (struct file *file, int mask)
 {
 	return security_ops->file_permission (file, mask);
@@ -2518,6 +2531,12 @@ static inline int security_inode_listsecurity(struct inode *inode, char *buffer,
 	return 0;
 }
 
+static inline int security_inode_get_secid(struct inode *inode, u32 *secid)
+{
+	*secid = 0;
+	return 0;
+}
+
 static inline int security_file_permission (struct file *file, int mask)
 {
 	return 0;
diff --git a/security/dummy.c b/security/dummy.c
index 1a0be85..6be18fe 100644
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -392,6 +392,12 @@ static int dummy_inode_listsecurity(struct inode *inode, char *buffer, size_t bu
 	return 0;
 }
 
+static int dummy_inode_get_secid(struct inode *inode, u32 *secid)
+{
+	*secid = 0;
+	return 0;
+}
+
 static const char *dummy_inode_xattr_getsuffix(void)
 {
 	return NULL;
@@ -1046,6 +1052,7 @@ void security_fixup_ops (struct security_operations *ops)
 	set_to_dummy_if_null(ops, inode_getsecurity);
 	set_to_dummy_if_null(ops, inode_setsecurity);
 	set_to_dummy_if_null(ops, inode_listsecurity);
+	set_to_dummy_if_null(ops, inode_get_secid);
 	set_to_dummy_if_null(ops, file_permission);
 	set_to_dummy_if_null(ops, file_alloc_security);
 	set_to_dummy_if_null(ops, file_free_security);
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 2c64ec8..34646f8 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2464,6 +2464,14 @@ static int selinux_inode_listsecurity(struct inode *inode, char *buffer, size_t
 	return len;
 }
 
+static int selinux_inode_get_secid(struct inode *inode, u32 *secid)
+{
+	struct inode_security_struct *isec = inode->i_security;
+
+	*secid = isec->sid;
+	return 0;
+}
+
 /* file security operations */
 
 static int selinux_file_permission(struct file *file, int mask)
@@ -4826,6 +4834,7 @@ static struct security_operations selinux_ops = {
 	.inode_getsecurity =            selinux_inode_getsecurity,
 	.inode_setsecurity =            selinux_inode_setsecurity,
 	.inode_listsecurity =           selinux_inode_listsecurity,
+	.inode_get_secid =		selinux_inode_get_secid,
 
 	.file_permission =		selinux_file_permission,
 	.file_alloc_security =		selinux_file_alloc_security,

