Return-Path: <linux-kernel-owner+w=401wt.eu-S1764020AbYEOR5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764020AbYEOR5u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 13:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763261AbYEOR4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 13:56:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763251AbYEOR4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 13:56:14 -0400
Message-Id: <20080515175431.000301639@redhat.com>
References: <20080515175357.636334082@redhat.com>
User-Agent: quilt/0.46-1
Date: Thu, 15 May 2008 13:53:58 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, ajackson@redhat.com, airlied@redhat.com,
       benh@kernel.crashing.org
Subject: [patch 1/5] access_process_vm device memory infrastructure
Content-Disposition: inline; filename=01-access_process_vm-device-memory.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the generic_access_phys access function and put the hooks in place
to allow access_process_vm to access device or PPC Cell SPU memory.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Benjamin Herrensmidt <benh@kernel.crashing.org>

--- 

 arch/x86/mm/ioremap.c   |    8 ++
 include/asm-x86/io_32.h |    3 +
 include/asm-x86/io_64.h |    3 +
 include/linux/mm.h      |    6 ++
 mm/memory.c             |  134 +++++++++++++++++++++++++++++++++++++++++-------
 5 files changed, 136 insertions(+), 18 deletions(-)

Index: ptrace-2.6.26-rc2-mm1/mm/memory.c
===================================================================
--- ptrace-2.6.26-rc2-mm1.orig/mm/memory.c	2008-05-15 13:50:13.000000000 -0400
+++ ptrace-2.6.26-rc2-mm1/mm/memory.c	2008-05-15 13:50:15.000000000 -0400
@@ -2668,6 +2668,86 @@ int in_gate_area_no_task(unsigned long a
 
 #endif	/* __HAVE_ARCH_GATE_AREA */
 
+#ifdef CONFIG_HAVE_IOREMAP_PROT
+static resource_size_t follow_phys(struct vm_area_struct *vma,
+			unsigned long address, unsigned int flags,
+			unsigned long *prot)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *ptep, pte;
+	spinlock_t *ptl;
+	resource_size_t phys_addr = 0;
+	struct mm_struct *mm = vma->vm_mm;
+
+	VM_BUG_ON(!(vma->vm_flags & (VM_IO | VM_PFNMAP)));
+
+	pgd = pgd_offset(mm, address);
+	if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
+		goto no_page_table;
+
+	pud = pud_offset(pgd, address);
+	if (pud_none(*pud) || unlikely(pud_bad(*pud)))
+		goto no_page_table;
+
+	pmd = pmd_offset(pud, address);
+	if (pmd_none(*pmd) || unlikely(pmd_bad(*pmd)))
+		goto no_page_table;
+
+	/* We cannot handle huge page PFN maps. Luckily they don't exist. */
+	if (pmd_huge(*pmd))
+		goto no_page_table;
+
+	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
+	if (!ptep)
+		goto out;
+
+	pte = *ptep;
+	if (!pte_present(pte))
+		goto unlock;
+	if ((flags & FOLL_WRITE) && !pte_write(pte))
+		goto unlock;
+	phys_addr = pte_pfn(pte);
+	phys_addr <<= PAGE_SHIFT; /* Shift here to avoid overflow on PAE */
+
+	*prot = pgprot_val(pte_pgprot(pte));
+
+unlock:
+	pte_unmap_unlock(ptep, ptl);
+out:
+	return phys_addr;
+no_page_table:
+	return 0;
+}
+
+int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
+			void *buf, int len, int write)
+{
+	resource_size_t phys_addr;
+	unsigned long prot = 0;
+	void *maddr;
+	int offset = addr & (PAGE_SIZE-1);
+
+	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
+		return -EINVAL;
+
+	phys_addr = follow_phys(vma, addr, write, &prot);
+
+	if (!phys_addr)
+		return -EINVAL;
+
+	maddr = ioremap_prot(phys_addr, PAGE_SIZE, prot);
+	if (write)
+		memcpy_toio(maddr + offset, buf, len);
+	else
+		memcpy_fromio(buf, maddr + offset, len);
+	iounmap(maddr);
+
+	return len;
+}
+#endif
+
 /*
  * Access another process' address space.
  * Source/target buffer must be kernel space,
@@ -2677,7 +2757,6 @@ int access_process_vm(struct task_struct
 {
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
-	struct page *page;
 	void *old_buf = buf;
 
 	mm = get_task_mm(tsk);
@@ -2689,28 +2768,44 @@ int access_process_vm(struct task_struct
 	while (len) {
 		int bytes, ret, offset;
 		void *maddr;
+		struct page *page = NULL;
 
 		ret = get_user_pages(tsk, mm, addr, 1,
 				write, 1, &page, &vma);
-		if (ret <= 0)
-			break;
-
-		bytes = len;
-		offset = addr & (PAGE_SIZE-1);
-		if (bytes > PAGE_SIZE-offset)
-			bytes = PAGE_SIZE-offset;
-
-		maddr = kmap(page);
-		if (write) {
-			copy_to_user_page(vma, page, addr,
-					  maddr + offset, buf, bytes);
-			set_page_dirty_lock(page);
+		if (ret <= 0) {
+			/*
+			 * Check if this is a VM_IO | VM_PFNMAP VMA, which
+			 * we can access using slightly different code.
+			 */
+#ifdef CONFIG_HAVE_IOREMAP_PROT
+			vma = find_vma(mm, addr);
+			if (!vma)
+				break;
+			if (vma->vm_ops && vma->vm_ops->access)
+				ret = vma->vm_ops->access(vma, addr, buf,
+							  len, write);
+			if (ret <= 0)
+#endif
+				break;
+			bytes = ret;
 		} else {
-			copy_from_user_page(vma, page, addr,
-					    buf, maddr + offset, bytes);
+			bytes = len;
+			offset = addr & (PAGE_SIZE-1);
+			if (bytes > PAGE_SIZE-offset)
+				bytes = PAGE_SIZE-offset;
+
+			maddr = kmap(page);
+			if (write) {
+				copy_to_user_page(vma, page, addr,
+						  maddr + offset, buf, bytes);
+				set_page_dirty_lock(page);
+			} else {
+				copy_from_user_page(vma, page, addr,
+						    buf, maddr + offset, bytes);
+			}
+			kunmap(page);
+			page_cache_release(page);
 		}
-		kunmap(page);
-		page_cache_release(page);
 		len -= bytes;
 		buf += bytes;
 		addr += bytes;
Index: ptrace-2.6.26-rc2-mm1/arch/x86/mm/ioremap.c
===================================================================
--- ptrace-2.6.26-rc2-mm1.orig/arch/x86/mm/ioremap.c	2008-05-15 13:50:13.000000000 -0400
+++ ptrace-2.6.26-rc2-mm1/arch/x86/mm/ioremap.c	2008-05-15 13:50:15.000000000 -0400
@@ -307,6 +307,14 @@ void __iomem *ioremap_cache(resource_siz
 }
 EXPORT_SYMBOL(ioremap_cache);
 
+void __iomem *ioremap_prot(resource_size_t phys_addr, unsigned long size,
+				unsigned long prot_val)
+{
+	return __ioremap_caller(phys_addr, size, (prot_val & _PAGE_CACHE_MASK),
+				__builtin_return_address(0));
+}
+EXPORT_SYMBOL(ioremap_prot);
+
 /**
  * iounmap - Free a IO remapping
  * @addr: virtual address from ioremap_*
Index: ptrace-2.6.26-rc2-mm1/include/asm-x86/io_32.h
===================================================================
--- ptrace-2.6.26-rc2-mm1.orig/include/asm-x86/io_32.h	2008-05-15 13:50:13.000000000 -0400
+++ ptrace-2.6.26-rc2-mm1/include/asm-x86/io_32.h	2008-05-15 13:50:15.000000000 -0400
@@ -110,6 +110,8 @@ static inline void *phys_to_virt(unsigne
  */
 extern void __iomem *ioremap_nocache(resource_size_t offset, unsigned long size);
 extern void __iomem *ioremap_cache(resource_size_t offset, unsigned long size);
+extern void __iomem *ioremap_prot(resource_size_t offset, unsigned long size,
+				unsigned long prot_val);
 
 /*
  * The default ioremap() behavior is non-cached:
Index: ptrace-2.6.26-rc2-mm1/include/asm-x86/io_64.h
===================================================================
--- ptrace-2.6.26-rc2-mm1.orig/include/asm-x86/io_64.h	2008-05-15 13:50:13.000000000 -0400
+++ ptrace-2.6.26-rc2-mm1/include/asm-x86/io_64.h	2008-05-15 13:50:15.000000000 -0400
@@ -175,6 +175,8 @@ extern void early_iounmap(void *addr, un
  */
 extern void __iomem *ioremap_nocache(resource_size_t offset, unsigned long size);
 extern void __iomem *ioremap_cache(resource_size_t offset, unsigned long size);
+extern void __iomem *ioremap_prot(resource_size_t offset, unsigned long size,
+				unsigned long prot_val);
 
 /*
  * The default ioremap() behavior is non-cached:
Index: ptrace-2.6.26-rc2-mm1/include/linux/mm.h
===================================================================
--- ptrace-2.6.26-rc2-mm1.orig/include/linux/mm.h	2008-05-15 13:50:13.000000000 -0400
+++ ptrace-2.6.26-rc2-mm1/include/linux/mm.h	2008-05-15 13:50:18.000000000 -0400
@@ -169,6 +169,12 @@ struct vm_operations_struct {
 	/* notification that a previously read-only page is about to become
 	 * writable, if an error is returned it will cause a SIGBUS */
 	int (*page_mkwrite)(struct vm_area_struct *vma, struct page *page);
+
+	/* called by access_process_vm when get_user_pages() fails, typically
+	 * for use by special VMAs that can switch between memory and hardware
+	 */
+	int (*access)(struct vm_area_struct *vma, unsigned long addr,
+		      void *buf, int len, int write);
 #ifdef CONFIG_NUMA
 	/*
 	 * set_policy() op must add a reference to any non-NULL @new mempolicy
@@ -769,6 +775,8 @@ int copy_page_range(struct mm_struct *ds
 			struct vm_area_struct *vma);
 void unmap_mapping_range(struct address_space *mapping,
 		loff_t const holebegin, loff_t const holelen, int even_cows);
+int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
+			void *buf, int len, int write);
 
 static inline void unmap_shared_mapping_range(struct address_space *mapping,
 		loff_t const holebegin, loff_t const holelen)
Index: ptrace-2.6.26-rc2-mm1/arch/Kconfig
===================================================================
--- ptrace-2.6.26-rc2-mm1.orig/arch/Kconfig	2008-05-15 13:50:13.000000000 -0400
+++ ptrace-2.6.26-rc2-mm1/arch/Kconfig	2008-05-15 13:50:15.000000000 -0400
@@ -40,6 +40,9 @@ config HAVE_KRETPROBES
 config HAVE_DMA_ATTRS
 	def_bool n
 
+config HAVE_IOREMAP_PROT
+	def_bool n
+
 config HAVE_EFFICIENT_UNALIGNED_ACCESS
 	def_bool n
 	help
Index: ptrace-2.6.26-rc2-mm1/arch/x86/Kconfig
===================================================================
--- ptrace-2.6.26-rc2-mm1.orig/arch/x86/Kconfig	2008-05-15 13:50:13.000000000 -0400
+++ ptrace-2.6.26-rc2-mm1/arch/x86/Kconfig	2008-05-15 13:50:15.000000000 -0400
@@ -27,6 +27,7 @@ config X86
 	select HAVE_KVM if ((X86_32 && !X86_VOYAGER && !X86_VISWS && !X86_NUMAQ) || X86_64)
 	select HAVE_ARCH_KGDB if !X86_VOYAGER
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
+	select HAVE_IOREMAP_PROT
 
 config DEFCONFIG_LIST
 	string

-- 
All Rights Reversed

