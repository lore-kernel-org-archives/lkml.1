Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab0BSTrz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 14:47:55 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:38652 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab0BSTri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 14:47:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=QZ9YXBlxeUw6n4XSzDIZ4w7byMbBKaNK/xVrJozY5WBZIMNuwak0vuKXih+eOkEudQ
         +3ge5HoxGTW6KDsvVpHdEYlwJLdHJrHO8yyuZclFPBIJN4lITMXYoj5/LJDGVKahka+4
         zCZj2U6hi8uoEj3A9sLrCz4jUj5UQOPo8a1z8=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/7] mm: add nofail version of vmtruncate() and inode_setattr()
Date: Fri, 19 Feb 2010 22:47:19 +0300
Message-Id: <1266608845-13212-2-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1266608845-13212-1-git-send-email-dmonakhov@openvz.org>
References: <1266608845-13212-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vmtrucate may fail due to IS_SWAPFILE flag or due to RLIMIT_FSIZE.
In some situations it is not acceptable behaviour. Off course
we can check IS_SWAPFILE before but what about RLIMIT_FSIZE?

Let's divide vmtruncate in two parts. One which perform necessery
checks and second(__vmtruncate) which can not fail. In this case
caller is responsible for necessery checks before calling
no_fail vmtruncate version.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/attr.c          |   22 ++++++++++++++++------
 include/linux/fs.h |    1 +
 include/linux/mm.h |    1 +
 mm/truncate.c      |   24 +++++++++++++++++-------
 4 files changed, 35 insertions(+), 13 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index 96d394b..b1cc391 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -105,16 +105,13 @@ out_big:
 }
 EXPORT_SYMBOL(inode_newsize_ok);
 
-int inode_setattr(struct inode * inode, struct iattr * attr)
+void __inode_setattr(struct inode * inode, struct iattr * attr)
 {
 	unsigned int ia_valid = attr->ia_valid;
 
 	if (ia_valid & ATTR_SIZE &&
-	    attr->ia_size != i_size_read(inode)) {
-		int error = vmtruncate(inode, attr->ia_size);
-		if (error)
-			return error;
-	}
+	    attr->ia_size != i_size_read(inode))
+		__vmtruncate(inode, attr->ia_size);
 
 	if (ia_valid & ATTR_UID)
 		inode->i_uid = attr->ia_uid;
@@ -138,6 +135,19 @@ int inode_setattr(struct inode * inode, struct iattr * attr)
 	}
 	mark_inode_dirty(inode);
 
+}
+EXPORT_SYMBOL(__inode_setattr);
+
+int inode_setattr(struct inode * inode, struct iattr * attr)
+{
+	int error;
+	if (attr->ia_valid & ATTR_SIZE &&
+		attr->ia_size != i_size_read(inode)) {
+		error = inode_newsize_ok(inode, attr->ia_size);
+		if (error)
+			return error;
+	}
+	__inode_setattr(inode, attr);
 	return 0;
 }
 EXPORT_SYMBOL(inode_setattr);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 9147ca8..18b7be8 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2373,6 +2373,7 @@ extern int buffer_migrate_page(struct address_space *,
 
 extern int inode_change_ok(const struct inode *, struct iattr *);
 extern int inode_newsize_ok(const struct inode *, loff_t offset);
+extern void __inode_setattr(struct inode *, struct iattr *);
 extern int __must_check inode_setattr(struct inode *, struct iattr *);
 
 extern void file_update_time(struct file *file);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 2265f28..d9fd667 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -808,6 +808,7 @@ static inline void unmap_shared_mapping_range(struct address_space *mapping,
 }
 
 extern void truncate_pagecache(struct inode *inode, loff_t old, loff_t new);
+extern void __vmtruncate(struct inode *inode, loff_t offset);
 extern int vmtruncate(struct inode *inode, loff_t offset);
 extern int vmtruncate_range(struct inode *inode, loff_t offset, loff_t end);
 
diff --git a/mm/truncate.c b/mm/truncate.c
index 342deee..9253a5c 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -542,7 +542,8 @@ void truncate_pagecache(struct inode *inode, loff_t old, loff_t new)
 EXPORT_SYMBOL(truncate_pagecache);
 
 /**
- * vmtruncate - unmap mappings "freed" by truncate() syscall
+ * __vmtruncate - unmap mappings "freed" by truncate() syscall
+ * Caller must perform necessary checks before.
  * @inode: inode of the file used
  * @offset: file offset to start truncating
  *
@@ -550,20 +551,29 @@ EXPORT_SYMBOL(truncate_pagecache);
  * between the file and the memory map for a potential last
  * incomplete page.  Ugly, but necessary.
  */
-int vmtruncate(struct inode *inode, loff_t offset)
+void __vmtruncate(struct inode *inode, loff_t offset)
 {
 	loff_t oldsize;
-	int error;
 
-	error = inode_newsize_ok(inode, offset);
-	if (error)
-		return error;
 	oldsize = inode->i_size;
 	i_size_write(inode, offset);
 	truncate_pagecache(inode, oldsize, offset);
 	if (inode->i_op->truncate)
 		inode->i_op->truncate(inode);
+}
+EXPORT_SYMBOL(__vmtruncate);
 
-	return error;
+/**
+ * vmtruncate - unmap mappings "freed" by truncate() syscall
+ * @inode: inode of the file used
+ * @offset: file offset to start truncating
+ */
+int vmtruncate(struct inode *inode, loff_t offset)
+{
+	int error = inode_newsize_ok(inode, offset);
+	if (error)
+		return error;
+	__vmtruncate(inode, offset);
+	return 0;
 }
 EXPORT_SYMBOL(vmtruncate);
-- 
1.6.6

