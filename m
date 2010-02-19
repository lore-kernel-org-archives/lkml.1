Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab0BSTrs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 14:47:48 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:49065 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab0BSTrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 14:47:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=ljZ9re5bbJIJgv7BkSSCveYcIrn0YAlVDInSjQG57OQJLQGsigTKXtlwdyI/8HapJj
         mw633iqunnfqqHl6Bgm/6i7sJd3NqG6sTKWjXu6Wx9IHn4Yc6sPIRMQIcrC+CXc2gvUe
         oHlaVjCavQhWHfXBIveXz4M4qBkrY+o1DEfBs=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/7] vfs: inode_change_ok have to perform all necessery checks
Date: Fri, 19 Feb 2010 22:47:20 +0300
Message-Id: <1266608845-13212-3-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1266608845-13212-2-git-send-email-dmonakhov@openvz.org>
References: <1266608845-13212-1-git-send-email-dmonakhov@openvz.org>
 <1266608845-13212-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Usually this is the only function which called before inode
attributes manipulation. In fact inode_change_ok() performs only
posix checks. But it new_size check is also important. Otherwise
we mail fail in very late stage.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/attr.c          |   19 +++++++++++++++++--
 include/linux/fs.h |    3 ++-
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index b1cc391..cc2a801 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -18,7 +18,7 @@
 /* Taken over from the old code... */
 
 /* POSIX UID/GID verification for setting inode attributes. */
-int inode_change_ok(const struct inode *inode, struct iattr *attr)
+int inode_change_posix_ok(const struct inode *inode, struct iattr *attr)
 {
 	int retval = -EPERM;
 	unsigned int ia_valid = attr->ia_valid;
@@ -60,7 +60,7 @@ fine:
 error:
 	return retval;
 }
-EXPORT_SYMBOL(inode_change_ok);
+EXPORT_SYMBOL(inode_change_posix_ok);
 
 /**
  * inode_newsize_ok - may this inode be truncated to a given size
@@ -105,6 +105,21 @@ out_big:
 }
 EXPORT_SYMBOL(inode_newsize_ok);
 
+/*
+ * General verification for setting inode attributes.
+ */
+int inode_change_ok(const struct inode *inode, struct iattr *attr)
+{
+	int ret;
+	ret = inode_change_posix_ok(inode, attr);
+	if (ret)
+		return ret;
+	if (attr->ia_valid & ATTR_SIZE)
+		ret = inode_newsize_ok(inode, attr->ia_size);
+	return ret;
+}
+EXPORT_SYMBOL(inode_change_ok);
+
 void __inode_setattr(struct inode * inode, struct iattr * attr)
 {
 	unsigned int ia_valid = attr->ia_valid;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 18b7be8..eee26ea 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2371,8 +2371,9 @@ extern int buffer_migrate_page(struct address_space *,
 #define buffer_migrate_page NULL
 #endif
 
-extern int inode_change_ok(const struct inode *, struct iattr *);
+extern int inode_change_posix_ok(const struct inode *, struct iattr *);
 extern int inode_newsize_ok(const struct inode *, loff_t offset);
+extern int inode_change_ok(const struct inode *, struct iattr *);
 extern void __inode_setattr(struct inode *, struct iattr *);
 extern int __must_check inode_setattr(struct inode *, struct iattr *);
 
-- 
1.6.6

