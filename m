Return-Path: <linux-kernel-owner+w=401wt.eu-S936430AbXHIQfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936430AbXHIQfR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 12:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755550AbXHIQe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 12:34:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755245AbXHIQe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 12:34:57 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 11/14] CacheFiles: Permit an inode's security ID to be
	obtained [try #2]
To: torvalds@osdl.org, akpm@osdl.org, steved@redhat.com,
       trond.myklebust@fys.uio.no
Cc: linux-fsdevel@vger.kernel.org, linux-cachefs@redhat.com,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org
Date: Thu, 09 Aug 2007 17:05:35 +0100
Message-ID: <20070809160535.17906.59852.stgit@warthog.cambridge.redhat.com>
In-Reply-To: <20070809160438.17906.76348.stgit@warthog.cambridge.redhat.com>
References: <20070809160438.17906.76348.stgit@warthog.cambridge.redhat.com>
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

 include/linux/security.h |   13 +++++++++++++
 security/dummy.c         |    6 ++++++
 security/selinux/hooks.c |    8 ++++++++
 3 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 422015d..21cadea 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1252,6 +1252,7 @@ struct security_operations {
   	int (*inode_getsecurity)(const struct inode *inode, const char *name, void *buffer, size_t size, int err);
   	int (*inode_setsecurity)(struct inode *inode, const char *name, const void *value, size_t size, int flags);
   	int (*inode_listsecurity)(struct inode *inode, char *buffer, size_t buffer_size);
+	u32 (*inode_get_secid)(struct inode *inode);
 
 	int (*file_permission) (struct file * file, int mask);
 	int (*file_alloc_security) (struct file * file);
@@ -1814,6 +1815,13 @@ static inline int security_inode_listsecurity(struct inode *inode, char *buffer,
 	return security_ops->inode_listsecurity(inode, buffer, buffer_size);
 }
 
+static inline u32 security_inode_get_secid(struct inode *inode)
+{
+	if (unlikely(IS_PRIVATE(inode)))
+		return 0;
+	return security_ops->inode_get_secid(inode);
+}
+
 static inline int security_file_permission (struct file *file, int mask)
 {
 	return security_ops->file_permission (file, mask);
@@ -2514,6 +2522,11 @@ static inline int security_inode_listsecurity(struct inode *inode, char *buffer,
 	return 0;
 }
 
+static inline u32 security_inode_get_secid(struct inode *inode)
+{
+	return 0;
+}
+
 static inline int security_file_permission (struct file *file, int mask)
 {
 	return 0;
diff --git a/security/dummy.c b/security/dummy.c
index 77ec75d..6a7a317 100644
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -392,6 +392,11 @@ static int dummy_inode_listsecurity(struct inode *inode, char *buffer, size_t bu
 	return 0;
 }
 
+static u32 dummy_inode_get_secid(struct inode *inode)
+{
+	return 0;
+}
+
 static const char *dummy_inode_xattr_getsuffix(void)
 {
 	return NULL;
@@ -1042,6 +1047,7 @@ void security_fixup_ops (struct security_operations *ops)
 	set_to_dummy_if_null(ops, inode_getsecurity);
 	set_to_dummy_if_null(ops, inode_setsecurity);
 	set_to_dummy_if_null(ops, inode_listsecurity);
+	set_to_dummy_if_null(ops, inode_get_secid);
 	set_to_dummy_if_null(ops, file_permission);
 	set_to_dummy_if_null(ops, file_alloc_security);
 	set_to_dummy_if_null(ops, file_free_security);
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 66af819..c05d662 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2464,6 +2464,13 @@ static int selinux_inode_listsecurity(struct inode *inode, char *buffer, size_t
 	return len;
 }
 
+static u32 selinux_inode_get_secid(struct inode *inode)
+{
+	struct inode_security_struct *isec = inode->i_security;
+
+	return isec->sid;
+}
+
 /* file security operations */
 
 static int selinux_file_permission(struct file *file, int mask)
@@ -4822,6 +4829,7 @@ static struct security_operations selinux_ops = {
 	.inode_getsecurity =            selinux_inode_getsecurity,
 	.inode_setsecurity =            selinux_inode_setsecurity,
 	.inode_listsecurity =           selinux_inode_listsecurity,
+	.inode_get_secid =		selinux_inode_get_secid,
 
 	.file_permission =		selinux_file_permission,
 	.file_alloc_security =		selinux_file_alloc_security,

