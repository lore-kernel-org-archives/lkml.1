Return-Path: <linux-kernel-owner+w=401wt.eu-S1756565AbYKLXXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565AbYKLXXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 18:23:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755858AbYKLXUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 18:20:17 -0500
Received: from mga14.intel.com ([143.182.124.37]:55947 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755818AbYKLXUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 18:20:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,592,1220252400"; 
   d="scan'208";a="75121290"
Message-Id: <20081112212900.578371000@intel.com>
References: <20081112212647.259698000@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 12 Nov 2008 13:26:52 -0800
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       H Peter Anvin <hpa@zytor.com>, Nick Piggin <npiggin@suse.de>,
       Hugh Dickins <hugh@veritas.com>, Roland Dreier <rdreier@cisco.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 5/8] x86 PAT: Implement track/untrack of pfnmap regions for x86
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
 arch/x86/include/asm/pgtable.h |   10 ++
 arch/x86/mm/pat.c              |  201 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 211 insertions(+)

Index: tip/arch/x86/mm/pat.c
===================================================================
--- tip.orig/arch/x86/mm/pat.c	2008-11-12 09:55:55.000000000 -0800
+++ tip/arch/x86/mm/pat.c	2008-11-12 12:06:50.000000000 -0800
@@ -596,6 +596,207 @@ void unmap_devmem(unsigned long pfn, uns
 	free_memtype(addr, addr + size);
 }
 
+int reserve_pfn_range(u64 paddr, unsigned long size, pgprot_t vma_prot)
+{
+	unsigned long flags;
+	unsigned long want_flags = (pgprot_val(vma_prot) & _PAGE_CACHE_MASK);
+
+	int is_ram = 0;
+	int id_sz, ret;
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
+		printk(KERN_INFO
+		"%s:%d map pfn expected mapping type %s for %Lx-%Lx, got %s\n",
+			current->comm, current->pid,
+			cattr_name(want_flags),
+			paddr, (unsigned long long)(paddr + size),
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
+		printk(KERN_INFO
+			"%s:%d reserve_pfn_range ioremap_change_attr failed %s "
+			"for %Lx-%Lx\n",
+			current->comm, current->pid,
+			cattr_name(flags),
+			paddr, (unsigned long long)(paddr + size));
+		return -EINVAL;
+	}
+	return 0;
+}
+
+void free_pfn_range(u64 paddr, unsigned long size)
+{
+	int is_ram;
+
+	is_ram = pagerange_is_ram(paddr, paddr + size);
+	if (is_ram == 0)
+		free_memtype(paddr, paddr + size);
+}
+
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
+
+		paddr = (u64)pfn << PAGE_SHIFT;
+		for (i = 0; i < size; i += PAGE_SIZE) {
+			paddr = paddr + i;
+			free_pfn_range(paddr, PAGE_SIZE);
+		}
+	} else {
+		/* free entire vma, page by page, using the pfn from pte */
+
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
Index: tip/arch/x86/include/asm/pgtable.h
===================================================================
--- tip.orig/arch/x86/include/asm/pgtable.h	2008-11-12 09:55:55.000000000 -0800
+++ tip/arch/x86/include/asm/pgtable.h	2008-11-12 12:03:43.000000000 -0800
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

