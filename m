Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753489AbYLRUCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbYLRUCg (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 15:02:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752239AbYLRUBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 15:01:47 -0500
Received: from mga01.intel.com ([192.55.52.88]:42973 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801AbYLRUBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 15:01:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,244,1228118400"; 
   d="scan'208";a="415657765"
Message-Id: <20081218194617.533039000@intel.com>
References: <20081218194126.963894000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 18 Dec 2008 11:41:30 -0800
From: venkatesh.pallipadi@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        akpm@linux-foundation.org, npiggin@suse.de, hugh@veritas.com
Cc: arjan@infradead.org, jbarnes@virtuousgeek.org, rdreier@cisco.com,
        jeremy@goop.org, linux-kernel@vger.kernel.org,
        Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 4/7] x86 PAT: Implement track/untrack of pfnmap regions for x86 - v3
Content-Disposition: inline; filename=x86_pfn_reservefree.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hookup remap_pfn_range and vm_insert_pfn and corresponding copy and free
routines with reserve and free tracking.

reserve and free here only takes care of non RAM region mapping. For RAM
region, driver should use set_memory_[uc|wc|wb] to set the cache type and
then setup the mapping for user pte. We can bypass below
reserve/free in that case.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

---
 arch/x86/include/asm/pgtable.h |   10 +
 arch/x86/mm/pat.c              |  236 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 246 insertions(+)

Index: linux-2.6/arch/x86/mm/pat.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/pat.c	2008-12-17 17:03:25.000000000 -0800
+++ linux-2.6/arch/x86/mm/pat.c	2008-12-17 17:22:59.000000000 -0800
@@ -596,6 +596,242 @@ void unmap_devmem(unsigned long pfn, uns
 	free_memtype(addr, addr + size);
 }
 
+/*
+ * Internal interface to reserve a range of physical memory with prot.
+ * Reserved non RAM regions only and after successful reserve_memtype,
+ * this func also keeps identity mapping (if any) in sync with this new prot.
+ */
+static int reserve_pfn_range(u64 paddr, unsigned long size, pgprot_t vma_prot)
+{
+	int is_ram = 0;
+	int id_sz, ret;
+	unsigned long flags;
+	unsigned long want_flags = (pgprot_val(vma_prot) & _PAGE_CACHE_MASK);
+
+	is_ram = pagerange_is_ram(paddr, paddr + size);
+
+	if (is_ram != 0) {
+		/*
+		 * For mapping RAM pages, drivers need to call
+		 * set_memory_[uc|wc|wb] directly, for reserve and free, before
+		 * setting up the PTE.
+		 */
+		WARN_ON_ONCE(1);
+		return 0;
+	}
+
+	ret = reserve_memtype(paddr, paddr + size, want_flags, &flags);
+	if (ret)
+		return ret;
+
+	if (flags != want_flags) {
+		free_memtype(paddr, paddr + size);
+		printk(KERN_ERR
+		"%s:%d map pfn expected mapping type %s for %Lx-%Lx, got %s\n",
+			current->comm, current->pid,
+			cattr_name(want_flags),
+			(unsigned long long)paddr,
+			(unsigned long long)(paddr + size),
+			cattr_name(flags));
+		return -EINVAL;
+	}
+
+	/* Need to keep identity mapping in sync */
+	if (paddr >= __pa(high_memory))
+		return 0;
+
+	id_sz = (__pa(high_memory) < paddr + size) ?
+				__pa(high_memory) - paddr :
+				size;
+
+	if (ioremap_change_attr((unsigned long)__va(paddr), id_sz, flags) < 0) {
+		free_memtype(paddr, paddr + size);
+		printk(KERN_ERR
+			"%s:%d reserve_pfn_range ioremap_change_attr failed %s "
+			"for %Lx-%Lx\n",
+			current->comm, current->pid,
+			cattr_name(flags),
+			(unsigned long long)paddr,
+			(unsigned long long)(paddr + size));
+		return -EINVAL;
+	}
+	return 0;
+}
+
+/*
+ * Internal interface to free a range of physical memory.
+ * Frees non RAM regions only.
+ */
+static void free_pfn_range(u64 paddr, unsigned long size)
+{
+	int is_ram;
+
+	is_ram = pagerange_is_ram(paddr, paddr + size);
+	if (is_ram == 0)
+		free_memtype(paddr, paddr + size);
+}
+
+/*
+ * track_pfn_vma_copy is called when vma that is covering the pfnmap gets
+ * copied through copy_page_range().
+ *
+ * If the vma has a linear pfn mapping for the entire range, we get the prot
+ * from pte and reserve the entire vma range with single reserve_pfn_range call.
+ * Otherwise, we reserve the entire vma range, my ging through the PTEs page
+ * by page to get physical address and protection.
+ */
+int track_pfn_vma_copy(struct vm_area_struct *vma)
+{
+	int retval = 0;
+	unsigned long i, j;
+	u64 paddr;
+	pgprot_t prot;
+	pte_t pte;
+	unsigned long vma_start = vma->vm_start;
+	unsigned long vma_end = vma->vm_end;
+	unsigned long vma_size = vma_end - vma_start;
+
+	if (!pat_enabled)
+		return 0;
+
+	if (is_linear_pfn_mapping(vma)) {
+		/*
+		 * reserve the whole chunk starting from vm_pgoff,
+		 * But, we have to get the protection from pte.
+		 */
+		if (follow_pfnmap_pte(vma, vma_start, &pte)) {
+			WARN_ON_ONCE(1);
+			return -1;
+		}
+		prot = pte_pgprot(pte);
+		paddr = (u64)vma->vm_pgoff << PAGE_SHIFT;
+		return reserve_pfn_range(paddr, vma_size, prot);
+	}
+
+	/* reserve entire vma page by page, using pfn and prot from pte */
+	for (i = 0; i < vma_size; i += PAGE_SIZE) {
+		if (follow_pfnmap_pte(vma, vma_start + i, &pte))
+			continue;
+
+		paddr = pte_pa(pte);
+		prot = pte_pgprot(pte);
+		retval = reserve_pfn_range(paddr, PAGE_SIZE, prot);
+		if (retval)
+			goto cleanup_ret;
+	}
+	return 0;
+
+cleanup_ret:
+	/* Reserve error: Cleanup partial reservation and return error */
+	for (j = 0; j < i; j += PAGE_SIZE) {
+		if (follow_pfnmap_pte(vma, vma_start + j, &pte))
+			continue;
+
+		paddr = pte_pa(pte);
+		free_pfn_range(paddr, PAGE_SIZE);
+	}
+
+	return retval;
+}
+
+/*
+ * track_pfn_vma_new is called when a _new_ pfn mapping is being established
+ * for physical range indicated by pfn and size.
+ *
+ * prot is passed in as a parameter for the new mapping. If the vma has a
+ * linear pfn mapping for the entire range reserve the entire vma range with
+ * single reserve_pfn_range call.
+ * Otherwise, we look t the pfn and size and reserve only the specified range
+ * page by page.
+ *
+ * Note that this function can be called with caller trying to map only a
+ * subrange/page inside the vma.
+ */
+int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t prot,
+			unsigned long pfn, unsigned long size)
+{
+	int retval = 0;
+	unsigned long i, j;
+	u64 base_paddr;
+	u64 paddr;
+	unsigned long vma_start = vma->vm_start;
+	unsigned long vma_end = vma->vm_end;
+	unsigned long vma_size = vma_end - vma_start;
+
+	if (!pat_enabled)
+		return 0;
+
+	if (is_linear_pfn_mapping(vma)) {
+		/* reserve the whole chunk starting from vm_pgoff */
+		paddr = (u64)vma->vm_pgoff << PAGE_SHIFT;
+		return reserve_pfn_range(paddr, vma_size, prot);
+	}
+
+	/* reserve page by page using pfn and size */
+	base_paddr = (u64)pfn << PAGE_SHIFT;
+	for (i = 0; i < size; i += PAGE_SIZE) {
+		paddr = base_paddr + i;
+		retval = reserve_pfn_range(paddr, PAGE_SIZE, prot);
+		if (retval)
+			goto cleanup_ret;
+	}
+	return 0;
+
+cleanup_ret:
+	/* Reserve error: Cleanup partial reservation and return error */
+	for (j = 0; j < i; j += PAGE_SIZE) {
+		paddr = base_paddr + j;
+		free_pfn_range(paddr, PAGE_SIZE);
+	}
+
+	return retval;
+}
+
+/*
+ * untrack_pfn_vma is called while unmapping a pfnmap for a region.
+ * untrack can be called for a specific region indicated by pfn and size or
+ * can be for the entire vma (in which case size can be zero).
+ */
+void untrack_pfn_vma(struct vm_area_struct *vma, unsigned long pfn,
+			unsigned long size)
+{
+	unsigned long i;
+	u64 paddr;
+	unsigned long vma_start = vma->vm_start;
+	unsigned long vma_end = vma->vm_end;
+	unsigned long vma_size = vma_end - vma_start;
+
+	if (!pat_enabled)
+		return;
+
+	if (is_linear_pfn_mapping(vma)) {
+		/* free the whole chunk starting from vm_pgoff */
+		paddr = (u64)vma->vm_pgoff << PAGE_SHIFT;
+		free_pfn_range(paddr, vma_size);
+		return;
+	}
+
+	if (size != 0 && size != vma_size) {
+		/* free page by page, using pfn and size */
+		paddr = (u64)pfn << PAGE_SHIFT;
+		for (i = 0; i < size; i += PAGE_SIZE) {
+			paddr = paddr + i;
+			free_pfn_range(paddr, PAGE_SIZE);
+		}
+	} else {
+		/* free entire vma, page by page, using the pfn from pte */
+		for (i = 0; i < vma_size; i += PAGE_SIZE) {
+			pte_t pte;
+
+			if (follow_pfnmap_pte(vma, vma_start + i, &pte))
+				continue;
+
+			paddr = pte_pa(pte);
+			free_pfn_range(paddr, PAGE_SIZE);
+		}
+	}
+}
+
 #if defined(CONFIG_DEBUG_FS) && defined(CONFIG_X86_PAT)
 
 /* get Nth element of the linked list */
Index: linux-2.6/arch/x86/include/asm/pgtable.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/pgtable.h	2008-12-17 17:03:25.000000000 -0800
+++ linux-2.6/arch/x86/include/asm/pgtable.h	2008-12-17 17:09:16.000000000 -0800
@@ -219,6 +219,11 @@ static inline unsigned long pte_pfn(pte_
 	return (pte_val(pte) & PTE_PFN_MASK) >> PAGE_SHIFT;
 }
 
+static inline u64 pte_pa(pte_t pte)
+{
+	return pte_val(pte) & PTE_PFN_MASK;
+}
+
 #define pte_page(pte)	pfn_to_page(pte_pfn(pte))
 
 static inline int pmd_large(pmd_t pte)
@@ -328,6 +333,11 @@ static inline pgprot_t pgprot_modify(pgp
 
 #define canon_pgprot(p) __pgprot(pgprot_val(p) & __supported_pte_mask)
 
+/* Indicate that x86 has its own track and untrack pfn vma functions */
+#define track_pfn_vma_new track_pfn_vma_new
+#define track_pfn_vma_copy track_pfn_vma_copy
+#define untrack_pfn_vma untrack_pfn_vma
+
 #ifndef __ASSEMBLY__
 #define __HAVE_PHYS_MEM_ACCESS_PROT
 struct file;

-- 

