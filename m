Return-Path: <linux-kernel-owner+w=401wt.eu-S1760358AbXFVSZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760358AbXFVSZk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 14:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759275AbXFVSZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 14:25:31 -0400
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:61075 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759126AbXFVSZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 14:25:30 -0400
From: Alexander Wuerstlein <arw@arw.name>
To: linux-kernel@vger.kernel.org
Cc: Johannes Schlumberger <spjsschl@stud.informatik.uni-erlangen.de>
Subject: [PATCH] export xattr_resolve_name_sns [1/4]
Date: Fri, 22 Jun 2007 20:25:26 +0200
Message-Id: <11825367292921-git-send-email-arw@arw.name>
X-Mailer: git-send-email 1.5.2.1
In-Reply-To: <20070621155516.GA6838@faui01.informatik.uni-erlangen.de>
References: <20070621155516.GA6838@faui01.informatik.uni-erlangen.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Schlumberger <spjsschl@cip.informatik.uni-erlangen.de>

Makes it possible to get extended attributes for a given inode.  We need this
for cases where we no longer have the corresponding direntry.

Signed-off-by: Johannes Schlumberger <spjsschl@cip.informatik.uni-erlangen.de>
---
 fs/xattr.c            |   18 ++++++++++++++++++
 include/linux/xattr.h |    1 +
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index 4523aca..467417f 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -538,6 +538,24 @@ xattr_resolve_name(struct xattr_handler **handlers, const char **name)
 	return handler;
 }
 
+struct xattr_handler *
+xattr_resolve_name_sns(struct xattr_handler **handlers, const char **name)
+{
+	struct xattr_handler *handler;
+
+	if (!*name)
+		return NULL;
+
+	for_each_xattr_handler(handlers, handler) {
+		const char *n = strcmp_prefix(*name, handler->prefix);
+		if (n) {
+			*name = n;
+			break;
+		}
+	}
+	return handler;
+}
+
 /*
  * Find the handler for the prefix and dispatch its get() operation.
  */
diff --git a/include/linux/xattr.h b/include/linux/xattr.h
index def131a..5653508 100644
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -46,6 +46,7 @@ struct xattr_handler {
 		   size_t size, int flags);
 };
 
+struct xattr_handler * xattr_resolve_name_sns(struct xattr_handler **, const char **);
 ssize_t vfs_getxattr(struct dentry *, char *, void *, size_t);
 ssize_t vfs_listxattr(struct dentry *d, char *list, size_t size);
 int vfs_setxattr(struct dentry *, char *, void *, size_t, int);
-- 
1.5.2.1

