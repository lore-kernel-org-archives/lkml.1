Return-Path: <linux-kernel-owner+w=401wt.eu-S1763280AbYBSEQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763280AbYBSEQB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 23:16:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760920AbYBSEMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 23:12:42 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:56462 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbYBSEMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 23:12:37 -0500
Message-Id: <20080219040829.967976708@arndb.de>
References: <20080219040435.825494460@arndb.de>
User-Agent: quilt/0.46-1
Date: Tue, 19 Feb 2008 05:04:46 +0100
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@lst.de>, Greg KH <gregkh@suse.de>,
       David Howells <dhowells@redhat.com>
Subject: [RFC 11/11] split out libfs/aops.c from libfs.c
Content-Disposition: inline; filename=libfs-aops.diff
X-Provags-ID: V01U2FsdGVkX1/PmGBsp1ODE9+4Sm1oyjFfmswTVcZqzLcVRdj
 GkMY2nUUxhwN+C+5CF/iIIQ3kD2+bSlo8M/WyVKF4gifePVQNa
 aYBjkD+rtVoSTM9NIcxHA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consolidate all address space manipulation code in libfs in a single
source file.

Signed-off-by: Arnd Bergman <arnd@arndb.de>


Index: linux-2.6/fs/libfs.c
===================================================================
--- linux-2.6.orig/fs/libfs.c
+++ /dev/null
@@ -1,116 +0,0 @@
-/*
- *	fs/libfs.c
- *	Library for filesystems writers.
- */
-
-#include <linux/module.h>
-#include <linux/pagemap.h>
-#include <linux/mount.h>
-#include <linux/vfs.h>
-#include <linux/mutex.h>
-#include <linux/exportfs.h>
-
-#include <asm/uaccess.h>
-
-int simple_readpage(struct file *file, struct page *page)
-{
-	clear_highpage(page);
-	flush_dcache_page(page);
-	SetPageUptodate(page);
-	unlock_page(page);
-	return 0;
-}
-
-int simple_prepare_write(struct file *file, struct page *page,
-			unsigned from, unsigned to)
-{
-	if (!PageUptodate(page)) {
-		if (to - from != PAGE_CACHE_SIZE)
-			zero_user_segments(page,
-				0, from,
-				to, PAGE_CACHE_SIZE);
-	}
-	return 0;
-}
-
-int simple_write_begin(struct file *file, struct address_space *mapping,
-			loff_t pos, unsigned len, unsigned flags,
-			struct page **pagep, void **fsdata)
-{
-	struct page *page;
-	pgoff_t index;
-	unsigned from;
-
-	index = pos >> PAGE_CACHE_SHIFT;
-	from = pos & (PAGE_CACHE_SIZE - 1);
-
-	page = __grab_cache_page(mapping, index);
-	if (!page)
-		return -ENOMEM;
-
-	*pagep = page;
-
-	return simple_prepare_write(file, page, from, from+len);
-}
-
-static int simple_commit_write(struct file *file, struct page *page,
-			       unsigned from, unsigned to)
-{
-	struct inode *inode = page->mapping->host;
-	loff_t pos = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
-
-	if (!PageUptodate(page))
-		SetPageUptodate(page);
-	/*
-	 * No need to use i_size_read() here, the i_size
-	 * cannot change under us because we hold the i_mutex.
-	 */
-	if (pos > inode->i_size)
-		i_size_write(inode, pos);
-	set_page_dirty(page);
-	return 0;
-}
-
-int simple_write_end(struct file *file, struct address_space *mapping,
-			loff_t pos, unsigned len, unsigned copied,
-			struct page *page, void *fsdata)
-{
-	unsigned from = pos & (PAGE_CACHE_SIZE - 1);
-
-	/* zero the stale part of the page if we did a short copy */
-	if (copied < len) {
-		void *kaddr = kmap_atomic(page, KM_USER0);
-		memset(kaddr + from + copied, 0, len - copied);
-		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
-	}
-
-	simple_commit_write(file, page, from, from+copied);
-
-	unlock_page(page);
-	page_cache_release(page);
-
-	return copied;
-}
-
-ssize_t simple_read_from_buffer(void __user *to, size_t count, loff_t *ppos,
-				const void *from, size_t available)
-{
-	loff_t pos = *ppos;
-	if (pos < 0)
-		return -EINVAL;
-	if (pos >= available)
-		return 0;
-	if (count > available - pos)
-		count = available - pos;
-	if (copy_to_user(to, from + pos, count))
-		return -EFAULT;
-	*ppos = pos + count;
-	return count;
-}
-
-EXPORT_SYMBOL(simple_write_begin);
-EXPORT_SYMBOL(simple_write_end);
-EXPORT_SYMBOL(simple_prepare_write);
-EXPORT_SYMBOL(simple_readpage);
-EXPORT_SYMBOL(simple_read_from_buffer);
Index: linux-2.6/fs/libfs/Makefile
===================================================================
--- linux-2.6.orig/fs/libfs/Makefile
+++ linux-2.6/fs/libfs/Makefile
@@ -1,3 +1,3 @@
 libfs-y += file.o
 
-obj-$(CONFIG_LIBFS) += libfs.o inode.o super.o dentry.o
+obj-$(CONFIG_LIBFS) += libfs.o inode.o super.o dentry.o aops.o
Index: linux-2.6/fs/libfs/aops.c
===================================================================
--- /dev/null
+++ linux-2.6/fs/libfs/aops.c
@@ -0,0 +1,113 @@
+/*
+ *	fs/libfs/aops.c
+ *	Library for filesystems writers -- address space operations
+ */
+
+#include <linux/module.h>
+#include <linux/pagemap.h>
+#include <linux/mount.h>
+#include <linux/vfs.h>
+
+#include <asm/uaccess.h>
+
+int simple_readpage(struct file *file, struct page *page)
+{
+	clear_highpage(page);
+	flush_dcache_page(page);
+	SetPageUptodate(page);
+	unlock_page(page);
+	return 0;
+}
+EXPORT_SYMBOL(simple_readpage);
+
+int simple_prepare_write(struct file *file, struct page *page,
+			unsigned from, unsigned to)
+{
+	if (!PageUptodate(page)) {
+		if (to - from != PAGE_CACHE_SIZE)
+			zero_user_segments(page,
+				0, from,
+				to, PAGE_CACHE_SIZE);
+	}
+	return 0;
+}
+EXPORT_SYMBOL(simple_prepare_write);
+
+int simple_write_begin(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned flags,
+			struct page **pagep, void **fsdata)
+{
+	struct page *page;
+	pgoff_t index;
+	unsigned from;
+
+	index = pos >> PAGE_CACHE_SHIFT;
+	from = pos & (PAGE_CACHE_SIZE - 1);
+
+	page = __grab_cache_page(mapping, index);
+	if (!page)
+		return -ENOMEM;
+
+	*pagep = page;
+
+	return simple_prepare_write(file, page, from, from+len);
+}
+EXPORT_SYMBOL(simple_write_begin);
+
+static int simple_commit_write(struct file *file, struct page *page,
+			       unsigned from, unsigned to)
+{
+	struct inode *inode = page->mapping->host;
+	loff_t pos = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
+
+	if (!PageUptodate(page))
+		SetPageUptodate(page);
+	/*
+	 * No need to use i_size_read() here, the i_size
+	 * cannot change under us because we hold the i_mutex.
+	 */
+	if (pos > inode->i_size)
+		i_size_write(inode, pos);
+	set_page_dirty(page);
+	return 0;
+}
+
+int simple_write_end(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned copied,
+			struct page *page, void *fsdata)
+{
+	unsigned from = pos & (PAGE_CACHE_SIZE - 1);
+
+	/* zero the stale part of the page if we did a short copy */
+	if (copied < len) {
+		void *kaddr = kmap_atomic(page, KM_USER0);
+		memset(kaddr + from + copied, 0, len - copied);
+		flush_dcache_page(page);
+		kunmap_atomic(kaddr, KM_USER0);
+	}
+
+	simple_commit_write(file, page, from, from+copied);
+
+	unlock_page(page);
+	page_cache_release(page);
+
+	return copied;
+}
+EXPORT_SYMBOL(simple_write_end);
+
+ssize_t simple_read_from_buffer(void __user *to, size_t count, loff_t *ppos,
+				const void *from, size_t available)
+{
+	loff_t pos = *ppos;
+	if (pos < 0)
+		return -EINVAL;
+	if (pos >= available)
+		return 0;
+	if (count > available - pos)
+		count = available - pos;
+	if (copy_to_user(to, from + pos, count))
+		return -EFAULT;
+	*ppos = pos + count;
+	return count;
+}
+EXPORT_SYMBOL(simple_read_from_buffer);

-- 

