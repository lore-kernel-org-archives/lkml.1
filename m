Return-Path: <linux-kernel-owner+w=401wt.eu-S1756588AbXIYXol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588AbXIYXol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 19:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754594AbXIYXm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 19:42:57 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36403 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751832AbXIYXmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 19:42:50 -0400
Message-Id: <20070925234250.122102556@sgi.com>
References: <20070925234204.546836393@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 25 Sep 2007 16:42:08 -0700
From: Christoph Lameter <clameter@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [04/17] is_vmalloc_addr(): Check if an address is within the vmalloc boundaries
Content-Disposition: inline; filename=vcompound_is_vmalloc_addr
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

is_vmalloc_addr() is used in a couple of places. Add a version to vmalloc.h
and replace the other checks.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 drivers/net/cxgb3/cxgb3_offload.c |    4 +---
 fs/ntfs/malloc.h                  |    3 +--
 fs/proc/kcore.c                   |    2 +-
 fs/xfs/linux-2.6/kmem.c           |    3 +--
 fs/xfs/linux-2.6/xfs_buf.c        |    3 +--
 include/linux/mm.h                |    8 ++++++++
 mm/sparse.c                       |   10 +---------
 7 files changed, 14 insertions(+), 19 deletions(-)

Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h	2007-09-24 18:32:35.000000000 -0700
+++ linux-2.6/include/linux/mm.h	2007-09-24 18:33:03.000000000 -0700
@@ -297,6 +297,14 @@ static inline int get_page_unless_zero(s
 struct page *vmalloc_to_page(const void *addr);
 unsigned long vmalloc_to_pfn(const void *addr);
 
+/* Determine if an address is within the vmalloc range */
+static inline int is_vmalloc_addr(const void *x)
+{
+	unsigned long addr = (unsigned long)x;
+
+	return addr >= VMALLOC_START && addr < VMALLOC_END;
+}
+
 static inline struct page *compound_head(struct page *page)
 {
 	if (unlikely(PageTail(page)))
Index: linux-2.6/mm/sparse.c
===================================================================
--- linux-2.6.orig/mm/sparse.c	2007-09-24 18:30:46.000000000 -0700
+++ linux-2.6/mm/sparse.c	2007-09-24 18:33:03.000000000 -0700
@@ -289,17 +289,9 @@ got_map_ptr:
 	return ret;
 }
 
-static int vaddr_in_vmalloc_area(void *addr)
-{
-	if (addr >= (void *)VMALLOC_START &&
-	    addr < (void *)VMALLOC_END)
-		return 1;
-	return 0;
-}
-
 static void __kfree_section_memmap(struct page *memmap, unsigned long nr_pages)
 {
-	if (vaddr_in_vmalloc_area(memmap))
+	if (is_vmalloc_addr(memmap))
 		vfree(memmap);
 	else
 		free_pages((unsigned long)memmap,
Index: linux-2.6/drivers/net/cxgb3/cxgb3_offload.c
===================================================================
--- linux-2.6.orig/drivers/net/cxgb3/cxgb3_offload.c	2007-09-24 18:30:46.000000000 -0700
+++ linux-2.6/drivers/net/cxgb3/cxgb3_offload.c	2007-09-24 18:33:03.000000000 -0700
@@ -1035,9 +1035,7 @@ void *cxgb_alloc_mem(unsigned long size)
  */
 void cxgb_free_mem(void *addr)
 {
-	unsigned long p = (unsigned long)addr;
-
-	if (p >= VMALLOC_START && p < VMALLOC_END)
+	if (is_vmalloc_addr(addr))
 		vfree(addr);
 	else
 		kfree(addr);
Index: linux-2.6/fs/ntfs/malloc.h
===================================================================
--- linux-2.6.orig/fs/ntfs/malloc.h	2007-09-24 18:30:46.000000000 -0700
+++ linux-2.6/fs/ntfs/malloc.h	2007-09-24 18:33:03.000000000 -0700
@@ -85,8 +85,7 @@ static inline void *ntfs_malloc_nofs_nof
 
 static inline void ntfs_free(void *addr)
 {
-	if (likely(((unsigned long)addr < VMALLOC_START) ||
-			((unsigned long)addr >= VMALLOC_END ))) {
+	if (!is_vmalloc_addr(addr)) {
 		kfree(addr);
 		/* free_page((unsigned long)addr); */
 		return;
Index: linux-2.6/fs/proc/kcore.c
===================================================================
--- linux-2.6.orig/fs/proc/kcore.c	2007-09-24 18:30:46.000000000 -0700
+++ linux-2.6/fs/proc/kcore.c	2007-09-24 18:33:03.000000000 -0700
@@ -325,7 +325,7 @@ read_kcore(struct file *file, char __use
 		if (m == NULL) {
 			if (clear_user(buffer, tsz))
 				return -EFAULT;
-		} else if ((start >= VMALLOC_START) && (start < VMALLOC_END)) {
+		} else if (is_vmalloc_addr((void *)start)) {
 			char * elf_buf;
 			struct vm_struct *m;
 			unsigned long curstart = start;
Index: linux-2.6/fs/xfs/linux-2.6/kmem.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/kmem.c	2007-09-24 18:30:46.000000000 -0700
+++ linux-2.6/fs/xfs/linux-2.6/kmem.c	2007-09-24 18:33:03.000000000 -0700
@@ -92,8 +92,7 @@ kmem_zalloc_greedy(size_t *size, size_t 
 void
 kmem_free(void *ptr, size_t size)
 {
-	if (((unsigned long)ptr < VMALLOC_START) ||
-	    ((unsigned long)ptr >= VMALLOC_END)) {
+	if (!is_vmalloc_addr(ptr)) {
 		kfree(ptr);
 	} else {
 		vfree(ptr);
Index: linux-2.6/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_buf.c	2007-09-24 18:30:46.000000000 -0700
+++ linux-2.6/fs/xfs/linux-2.6/xfs_buf.c	2007-09-24 18:33:03.000000000 -0700
@@ -696,8 +696,7 @@ static inline struct page *
 mem_to_page(
 	void			*addr)
 {
-	if (((unsigned long)addr < VMALLOC_START) ||
-	    ((unsigned long)addr >= VMALLOC_END)) {
+	if ((!is_vmalloc_addr(addr))) {
 		return virt_to_page(addr);
 	} else {
 		return vmalloc_to_page(addr);

-- 
