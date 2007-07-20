Return-Path: <linux-kernel-owner+w=401wt.eu-S932515AbXGTHxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515AbXGTHxw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 03:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757736AbXGTHxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 03:53:44 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:57377 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757490AbXGTHxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 03:53:43 -0400
Date: Fri, 20 Jul 2007 16:53:22 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Greg Ungerer <gerg@uclinux.org>, David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] nommu: vmalloc_32_user()/vm_insert_page() and symbol exports.
Message-ID: <20070720075322.GC26080@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Greg Ungerer <gerg@uclinux.org>,
	David Howells <dhowells@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trying to survive an allmodconfig on a nommu platform results in
many screen lengths of module unhappiness. Many of the mmap
related things that binfmt_flat hooks in to are never exported
despite being global, and there are also missing definitions for
vmalloc_32_user() and vm_insert_page().

I've implemented vmalloc_32_user() trying to stick as close to
the mm/vmalloc.c implementation as possible, though we don't
have any need for VM_USERMAP, so groveling for the VMA can be
skipped. vm_insert_page() has been stubbed for now in order to
keep the build happy.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

--

 mm/nommu.c |   45 +++++++++++++++++++++++++++++++++------------
 1 file changed, 33 insertions(+), 12 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index 1b105d2..9eef6a3 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -54,12 +54,6 @@ DECLARE_RWSEM(nommu_vma_sem);
 struct vm_operations_struct generic_file_vm_ops = {
 };
 
-EXPORT_SYMBOL(vfree);
-EXPORT_SYMBOL(vmalloc_to_page);
-EXPORT_SYMBOL(vmalloc_32);
-EXPORT_SYMBOL(vmap);
-EXPORT_SYMBOL(vunmap);
-
 /*
  * Handle all mappings that got truncated by a "truncate()"
  * system call.
@@ -168,7 +162,6 @@ int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 finish_or_fault:
 	return i ? : -EFAULT;
 }
-
 EXPORT_SYMBOL(get_user_pages);
 
 DEFINE_RWLOCK(vmlist_lock);
@@ -178,6 +171,7 @@ void vfree(void *addr)
 {
 	kfree(addr);
 }
+EXPORT_SYMBOL(vfree);
 
 void *__vmalloc(unsigned long size, gfp_t gfp_mask, pgprot_t prot)
 {
@@ -186,17 +180,19 @@ void *__vmalloc(unsigned long size, gfp_t gfp_mask, pgprot_t prot)
 	 */
 	return kmalloc(size, (gfp_mask | __GFP_COMP) & ~__GFP_HIGHMEM);
 }
+EXPORT_SYMBOL(__vmalloc);
 
 struct page * vmalloc_to_page(void *addr)
 {
 	return virt_to_page(addr);
 }
+EXPORT_SYMBOL(vmalloc_to_page);
 
 unsigned long vmalloc_to_pfn(void *addr)
 {
 	return page_to_pfn(virt_to_page(addr));
 }
-
+EXPORT_SYMBOL(vmalloc_to_pfn);
 
 long vread(char *buf, char *addr, unsigned long count)
 {
@@ -237,9 +233,8 @@ void *vmalloc_node(unsigned long size, int node)
 }
 EXPORT_SYMBOL(vmalloc_node);
 
-/*
- *	vmalloc_32  -  allocate virtually continguos memory (32bit addressable)
- *
+/**
+ * vmalloc_32  -  allocate virtually contiguous memory (32bit addressable)
  *	@size:		allocation size
  *
  *	Allocate enough 32bit PA addressable pages to cover @size from the
@@ -249,17 +244,33 @@ void *vmalloc_32(unsigned long size)
 {
 	return __vmalloc(size, GFP_KERNEL, PAGE_KERNEL);
 }
+EXPORT_SYMBOL(vmalloc_32);
+
+/**
+ * vmalloc_32_user - allocate zeroed virtually contiguous 32bit memory
+ *	@size:		allocation size
+ *
+ * The resulting memory area is 32bit addressable and zeroed so it can be
+ * mapped to userspace without leaking data.
+ */
+void *vmalloc_32_user(unsigned long size)
+{
+	return __vmalloc(size, GFP_KERNEL | __GFP_ZERO, PAGE_KERNEL);
+}
+EXPORT_SYMBOL(vmalloc_32_user);
 
 void *vmap(struct page **pages, unsigned int count, unsigned long flags, pgprot_t prot)
 {
 	BUG();
 	return NULL;
 }
+EXPORT_SYMBOL(vmap);
 
 void vunmap(void *addr)
 {
 	BUG();
 }
+EXPORT_SYMBOL(vunmap);
 
 /*
  * Implement a stub for vmalloc_sync_all() if the architecture chose not to
@@ -269,6 +280,13 @@ void  __attribute__((weak)) vmalloc_sync_all(void)
 {
 }
 
+int vm_insert_page(struct vm_area_struct *vma, unsigned long addr,
+		   struct page *page)
+{
+	return -EINVAL;
+}
+EXPORT_SYMBOL(vm_insert_page);
+
 /*
  *  sys_brk() for the most part doesn't need the global kernel
  *  lock, except when an application is doing something nasty
@@ -994,6 +1012,7 @@ unsigned long do_mmap_pgoff(struct file *file,
 	show_free_areas();
 	return -ENOMEM;
 }
+EXPORT_SYMBOL(do_mmap_pgoff);
 
 /*
  * handle mapping disposal for uClinux
@@ -1074,6 +1093,7 @@ int do_munmap(struct mm_struct *mm, unsigned long addr, size_t len)
 
 	return 0;
 }
+EXPORT_SYMBOL(do_munmap);
 
 asmlinkage long sys_munmap(unsigned long addr, size_t len)
 {
@@ -1164,6 +1184,7 @@ unsigned long do_mremap(unsigned long addr,
 
 	return vma->vm_start;
 }
+EXPORT_SYMBOL(do_mremap);
 
 asmlinkage unsigned long sys_mremap(unsigned long addr,
 	unsigned long old_len, unsigned long new_len,
@@ -1231,7 +1252,6 @@ unsigned long get_unmapped_area(struct file *file, unsigned long addr,
 
 	return get_area(file, addr, len, pgoff, flags);
 }
-
 EXPORT_SYMBOL(get_unmapped_area);
 
 /*
@@ -1346,6 +1366,7 @@ int filemap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	BUG();
 	return 0;
 }
+EXPORT_SYMBOL(filemap_fault);
 
 /*
  * Access another process' address space.
