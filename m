Return-Path: <linux-kernel-owner+w=401wt.eu-S1756006AbZIKStq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006AbZIKStq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 14:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755951AbZIKSso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 14:48:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54021 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901AbZIKSsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 14:48:39 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090911848.933193846@firstfloor.org>
In-Reply-To: <20090911848.933193846@firstfloor.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] [13/21] HWPOISON: Define a new error_remove_page address space op for async truncation
Message-Id: <20090911184842.2F5EFB1757@basil.firstfloor.org>
Date: Fri, 11 Sep 2009 20:48:42 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Truncating metadata pages is not safe right now before
we haven't audited all file systems.

To enable truncation only for data address space define
a new address_space callback error_remove_page.

This is used for memory_failure.c memory error handling.

This can be then set to truncate_inode_page()

This patch just defines the new operation and adds documentation.

Callers and users come in followon patches.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 Documentation/filesystems/vfs.txt |    7 +++++++
 include/linux/fs.h                |    1 +
 include/linux/mm.h                |    1 +
 mm/truncate.c                     |   17 +++++++++++++++++
 4 files changed, 26 insertions(+)

Index: linux/include/linux/fs.h
===================================================================
--- linux.orig/include/linux/fs.h
+++ linux/include/linux/fs.h
@@ -595,6 +595,7 @@ struct address_space_operations {
 	int (*launder_page) (struct page *);
 	int (*is_partially_uptodate) (struct page *, read_descriptor_t *,
 					unsigned long);
+	int (*error_remove_page)(struct address_space *, struct page *);
 };
 
 /*
Index: linux/Documentation/filesystems/vfs.txt
===================================================================
--- linux.orig/Documentation/filesystems/vfs.txt
+++ linux/Documentation/filesystems/vfs.txt
@@ -536,6 +536,7 @@ struct address_space_operations {
 	/* migrate the contents of a page to the specified target */
 	int (*migratepage) (struct page *, struct page *);
 	int (*launder_page) (struct page *);
+	int (*error_remove_page) (struct mapping *mapping, struct page *page);
 };
 
   writepage: called by the VM to write a dirty page to backing store.
@@ -694,6 +695,12 @@ struct address_space_operations {
   	prevent redirtying the page, it is kept locked during the whole
 	operation.
 
+  error_remove_page: normally set to generic_error_remove_page if truncation
+	is ok for this address space. Used for memory failure handling.
+	Setting this implies you deal with pages going away under you,
+	unless you have them locked or reference counts increased.
+
+
 The File Object
 ===============
 
Index: linux/mm/truncate.c
===================================================================
--- linux.orig/mm/truncate.c
+++ linux/mm/truncate.c
@@ -147,6 +147,23 @@ int truncate_inode_page(struct address_s
 }
 
 /*
+ * Used to get rid of pages on hardware memory corruption.
+ */
+int generic_error_remove_page(struct address_space *mapping, struct page *page)
+{
+	if (!mapping)
+		return -EINVAL;
+	/*
+	 * Only punch for normal data pages for now.
+	 * Handling other types like directories would need more auditing.
+	 */
+	if (!S_ISREG(mapping->host->i_mode))
+		return -EIO;
+	return truncate_inode_page(mapping, page);
+}
+EXPORT_SYMBOL(generic_error_remove_page);
+
+/*
  * Safely invalidate one page from its pagecache mapping.
  * It only drops clean, unused pages. The page must be locked.
  *
Index: linux/include/linux/mm.h
===================================================================
--- linux.orig/include/linux/mm.h
+++ linux/include/linux/mm.h
@@ -795,6 +795,7 @@ extern int vmtruncate(struct inode * ino
 extern int vmtruncate_range(struct inode * inode, loff_t offset, loff_t end);
 
 int truncate_inode_page(struct address_space *mapping, struct page *page);
+int generic_error_remove_page(struct address_space *mapping, struct page *page);
 
 int invalidate_inode_page(struct page *page);
 
