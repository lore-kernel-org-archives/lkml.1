Return-Path: <linux-kernel-owner+w=401wt.eu-S1755432AbYLSWCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbYLSWCf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 17:02:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754454AbYLSVyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 16:54:53 -0500
Received: from ns1.suse.de ([195.135.220.2]:58017 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755207AbYLSVyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 16:54:52 -0500
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Tiger Yang <tiger.yang@oracle.com>, Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 24/45] ocfs2: add security xattr API
Date: Fri, 19 Dec 2008 13:53:43 -0800
Message-Id: <1229723644-13630-25-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
References: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tiger Yang <tiger.yang@oracle.com>

This patch add security xattr set/get/list APIs to
support security attributes in Ocfs2.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/xattr.c |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/xattr.h |    1 +
 2 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 6480254..db03162 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -35,6 +35,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/string.h>
+#include <linux/security.h>
 
 #define MLOG_MASK_PREFIX ML_XATTR
 #include <cluster/masklog.h>
@@ -88,12 +89,14 @@ static struct ocfs2_xattr_def_value_root def_xv = {
 struct xattr_handler *ocfs2_xattr_handlers[] = {
 	&ocfs2_xattr_user_handler,
 	&ocfs2_xattr_trusted_handler,
+	&ocfs2_xattr_security_handler,
 	NULL
 };
 
 static struct xattr_handler *ocfs2_xattr_handler_map[OCFS2_XATTR_MAX] = {
 	[OCFS2_XATTR_INDEX_USER]	= &ocfs2_xattr_user_handler,
 	[OCFS2_XATTR_INDEX_TRUSTED]	= &ocfs2_xattr_trusted_handler,
+	[OCFS2_XATTR_INDEX_SECURITY]	= &ocfs2_xattr_security_handler,
 };
 
 struct ocfs2_xattr_info {
@@ -4977,6 +4980,50 @@ out:
 }
 
 /*
+ * 'security' attributes support
+ */
+static size_t ocfs2_xattr_security_list(struct inode *inode, char *list,
+					size_t list_size, const char *name,
+					size_t name_len)
+{
+	const size_t prefix_len = XATTR_SECURITY_PREFIX_LEN;
+	const size_t total_len = prefix_len + name_len + 1;
+
+	if (list && total_len <= list_size) {
+		memcpy(list, XATTR_SECURITY_PREFIX, prefix_len);
+		memcpy(list + prefix_len, name, name_len);
+		list[prefix_len + name_len] = '\0';
+	}
+	return total_len;
+}
+
+static int ocfs2_xattr_security_get(struct inode *inode, const char *name,
+				    void *buffer, size_t size)
+{
+	if (strcmp(name, "") == 0)
+		return -EINVAL;
+	return ocfs2_xattr_get(inode, OCFS2_XATTR_INDEX_SECURITY, name,
+			       buffer, size);
+}
+
+static int ocfs2_xattr_security_set(struct inode *inode, const char *name,
+				    const void *value, size_t size, int flags)
+{
+	if (strcmp(name, "") == 0)
+		return -EINVAL;
+
+	return ocfs2_xattr_set(inode, OCFS2_XATTR_INDEX_SECURITY, name, value,
+			       size, flags);
+}
+
+struct xattr_handler ocfs2_xattr_security_handler = {
+	.prefix	= XATTR_SECURITY_PREFIX,
+	.list	= ocfs2_xattr_security_list,
+	.get	= ocfs2_xattr_security_get,
+	.set	= ocfs2_xattr_security_set,
+};
+
+/*
  * 'trusted' attributes support
  */
 static size_t ocfs2_xattr_trusted_list(struct inode *inode, char *list,
diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
index 8fbdc16..55c5256 100644
--- a/fs/ocfs2/xattr.h
+++ b/fs/ocfs2/xattr.h
@@ -32,6 +32,7 @@ enum ocfs2_xattr_type {
 
 extern struct xattr_handler ocfs2_xattr_user_handler;
 extern struct xattr_handler ocfs2_xattr_trusted_handler;
+extern struct xattr_handler ocfs2_xattr_security_handler;
 extern struct xattr_handler *ocfs2_xattr_handlers[];
 
 ssize_t ocfs2_listxattr(struct dentry *, char *, size_t);
-- 
1.5.6

