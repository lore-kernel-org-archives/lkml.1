Return-Path: <linux-kernel-owner+w=401wt.eu-S1757485AbZAMSR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485AbZAMSR6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 13:17:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753721AbZAMSRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 13:17:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37421 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753353AbZAMSRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 13:17:48 -0500
Date: Tue, 13 Jan 2009 19:17:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: [git pull] x86 PAT fixes
Message-ID: <20090113181727.GA29913@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-pat-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-pat-for-linus

This is the PAT lineup that solves a range of 3D problems under X. It has 
two commits excluded [the 1MB legacy one and the resource_size_t 
ioremap_wc() one]- in the hope of fixing the crash Torsten Kaiser 
reported.

Torsten, could you please try this tree too, is it stable and does it 
solve the 3D problems?

out-of-topic modifications in x86-pat-for-linus:
------------------------------------------------
include/asm-generic/pgtable.h      # e4b866e: x86 PAT: change track_pfn_vma_new
mm/memory.c                        # e4b866e: x86 PAT: change track_pfn_vma_new
                                   # a367061: x86 PAT: remove PFNMAP type on tr

 Thanks,

	Ingo

------------------>
venkatesh.pallipadi@intel.com (5):
      x86 PAT: remove PFNMAP type on track_pfn_vma_new() error
      x86 PAT: consolidate old memtype new memtype check into a function
      x86 PAT: change track_pfn_vma_new to take pgprot_t pointer param
      x86 PAT: return compatible mapping to remap_pfn_range callers
      x86 PAT: remove CPA WARN_ON for zero pte


 arch/x86/include/asm/pgtable.h |   19 ++++++++
 arch/x86/mm/pageattr.c         |   10 +++--
 arch/x86/mm/pat.c              |   90 +++++++++++++++++++++++++++-------------
 arch/x86/pci/i386.c            |   12 +-----
 include/asm-generic/pgtable.h  |    4 +-
 mm/memory.c                    |   15 +++++--
 6 files changed, 100 insertions(+), 50 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 83e69f4..06bbcbd 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -341,6 +341,25 @@ static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
 
 #define canon_pgprot(p) __pgprot(pgprot_val(p) & __supported_pte_mask)
 
+static inline int is_new_memtype_allowed(unsigned long flags,
+						unsigned long new_flags)
+{
+	/*
+	 * Certain new memtypes are not allowed with certain
+	 * requested memtype:
+	 * - request is uncached, return cannot be write-back
+	 * - request is write-combine, return cannot be write-back
+	 */
+	if ((flags == _PAGE_CACHE_UC_MINUS &&
+	     new_flags == _PAGE_CACHE_WB) ||
+	    (flags == _PAGE_CACHE_WC &&
+	     new_flags == _PAGE_CACHE_WB)) {
+		return 0;
+	}
+
+	return 1;
+}
+
 #ifndef __ASSEMBLY__
 /* Indicate that x86 has its own track and untrack pfn vma functions */
 #define __HAVE_PFNMAP_TRACKING
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index e89d248..4cf30de 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -555,10 +555,12 @@ repeat:
 	if (!pte_val(old_pte)) {
 		if (!primary)
 			return 0;
-		WARN(1, KERN_WARNING "CPA: called for zero pte. "
-		       "vaddr = %lx cpa->vaddr = %lx\n", address,
-		       *cpa->vaddr);
-		return -EINVAL;
+
+		/*
+		 *  Special error value returned, indicating that the mapping
+		 * did not exist at this address.
+		 */
+		return -EFAULT;
 	}
 
 	if (level == PG_LEVEL_4K) {
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 85cbd3c..160c42d 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -505,6 +505,35 @@ static inline int range_is_allowed(unsigned long pfn, unsigned long size)
 }
 #endif /* CONFIG_STRICT_DEVMEM */
 
+/*
+ * Change the memory type for the physial address range in kernel identity
+ * mapping space if that range is a part of identity map.
+ */
+static int kernel_map_sync_memtype(u64 base, unsigned long size,
+					unsigned long flags)
+{
+	unsigned long id_sz;
+	int ret;
+
+	if (!pat_enabled || base >= __pa(high_memory))
+		return 0;
+
+	id_sz = (__pa(high_memory) < base + size) ?
+						__pa(high_memory) - base :
+						size;
+
+	ret = ioremap_change_attr((unsigned long)__va(base), id_sz, flags);
+	/*
+	 * -EFAULT return means that the addr was not valid and did not have
+	 * any identity mapping. That case is a success for
+	 * kernel_map_sync_memtype.
+	 */
+	if (ret == -EFAULT)
+		ret = 0;
+
+	return ret;
+}
+
 int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
 				unsigned long size, pgprot_t *vma_prot)
 {
@@ -555,9 +584,7 @@ int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
 	if (retval < 0)
 		return 0;
 
-	if (((pfn < max_low_pfn_mapped) ||
-	     (pfn >= (1UL<<(32 - PAGE_SHIFT)) && pfn < max_pfn_mapped)) &&
-	    ioremap_change_attr((unsigned long)__va(offset), size, flags) < 0) {
+	if (kernel_map_sync_memtype(offset, size, flags)) {
 		free_memtype(offset, offset + size);
 		printk(KERN_INFO
 		"%s:%d /dev/mem ioremap_change_attr failed %s for %Lx-%Lx\n",
@@ -601,12 +628,13 @@ void unmap_devmem(unsigned long pfn, unsigned long size, pgprot_t vma_prot)
  * Reserved non RAM regions only and after successful reserve_memtype,
  * this func also keeps identity mapping (if any) in sync with this new prot.
  */
-static int reserve_pfn_range(u64 paddr, unsigned long size, pgprot_t vma_prot)
+static int reserve_pfn_range(u64 paddr, unsigned long size, pgprot_t *vma_prot,
+				int strict_prot)
 {
 	int is_ram = 0;
-	int id_sz, ret;
+	int ret;
 	unsigned long flags;
-	unsigned long want_flags = (pgprot_val(vma_prot) & _PAGE_CACHE_MASK);
+	unsigned long want_flags = (pgprot_val(*vma_prot) & _PAGE_CACHE_MASK);
 
 	is_ram = pagerange_is_ram(paddr, paddr + size);
 
@@ -625,26 +653,27 @@ static int reserve_pfn_range(u64 paddr, unsigned long size, pgprot_t vma_prot)
 		return ret;
 
 	if (flags != want_flags) {
-		free_memtype(paddr, paddr + size);
-		printk(KERN_ERR
-		"%s:%d map pfn expected mapping type %s for %Lx-%Lx, got %s\n",
-			current->comm, current->pid,
-			cattr_name(want_flags),
-			(unsigned long long)paddr,
-			(unsigned long long)(paddr + size),
-			cattr_name(flags));
-		return -EINVAL;
+		if (strict_prot || !is_new_memtype_allowed(want_flags, flags)) {
+			free_memtype(paddr, paddr + size);
+			printk(KERN_ERR "%s:%d map pfn expected mapping type %s"
+				" for %Lx-%Lx, got %s\n",
+				current->comm, current->pid,
+				cattr_name(want_flags),
+				(unsigned long long)paddr,
+				(unsigned long long)(paddr + size),
+				cattr_name(flags));
+			return -EINVAL;
+		}
+		/*
+		 * We allow returning different type than the one requested in
+		 * non strict case.
+		 */
+		*vma_prot = __pgprot((pgprot_val(*vma_prot) &
+				      (~_PAGE_CACHE_MASK)) |
+				     flags);
 	}
 
-	/* Need to keep identity mapping in sync */
-	if (paddr >= __pa(high_memory))
-		return 0;
-
-	id_sz = (__pa(high_memory) < paddr + size) ?
-				__pa(high_memory) - paddr :
-				size;
-
-	if (ioremap_change_attr((unsigned long)__va(paddr), id_sz, flags) < 0) {
+	if (kernel_map_sync_memtype(paddr, size, flags)) {
 		free_memtype(paddr, paddr + size);
 		printk(KERN_ERR
 			"%s:%d reserve_pfn_range ioremap_change_attr failed %s "
@@ -689,6 +718,7 @@ int track_pfn_vma_copy(struct vm_area_struct *vma)
 	unsigned long vma_start = vma->vm_start;
 	unsigned long vma_end = vma->vm_end;
 	unsigned long vma_size = vma_end - vma_start;
+	pgprot_t pgprot;
 
 	if (!pat_enabled)
 		return 0;
@@ -702,7 +732,8 @@ int track_pfn_vma_copy(struct vm_area_struct *vma)
 			WARN_ON_ONCE(1);
 			return -EINVAL;
 		}
-		return reserve_pfn_range(paddr, vma_size, __pgprot(prot));
+		pgprot = __pgprot(prot);
+		return reserve_pfn_range(paddr, vma_size, &pgprot, 1);
 	}
 
 	/* reserve entire vma page by page, using pfn and prot from pte */
@@ -710,7 +741,8 @@ int track_pfn_vma_copy(struct vm_area_struct *vma)
 		if (follow_phys(vma, vma_start + i, 0, &prot, &paddr))
 			continue;
 
-		retval = reserve_pfn_range(paddr, PAGE_SIZE, __pgprot(prot));
+		pgprot = __pgprot(prot);
+		retval = reserve_pfn_range(paddr, PAGE_SIZE, &pgprot, 1);
 		if (retval)
 			goto cleanup_ret;
 	}
@@ -741,7 +773,7 @@ cleanup_ret:
  * Note that this function can be called with caller trying to map only a
  * subrange/page inside the vma.
  */
-int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t prot,
+int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t *prot,
 			unsigned long pfn, unsigned long size)
 {
 	int retval = 0;
@@ -758,14 +790,14 @@ int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t prot,
 	if (is_linear_pfn_mapping(vma)) {
 		/* reserve the whole chunk starting from vm_pgoff */
 		paddr = (resource_size_t)vma->vm_pgoff << PAGE_SHIFT;
-		return reserve_pfn_range(paddr, vma_size, prot);
+		return reserve_pfn_range(paddr, vma_size, prot, 0);
 	}
 
 	/* reserve page by page using pfn and size */
 	base_paddr = (resource_size_t)pfn << PAGE_SHIFT;
 	for (i = 0; i < size; i += PAGE_SIZE) {
 		paddr = base_paddr + i;
-		retval = reserve_pfn_range(paddr, PAGE_SIZE, prot);
+		retval = reserve_pfn_range(paddr, PAGE_SIZE, prot, 0);
 		if (retval)
 			goto cleanup_ret;
 	}
diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index f884740..5ead808 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -314,17 +314,7 @@ int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
 		return retval;
 
 	if (flags != new_flags) {
-		/*
-		 * Do not fallback to certain memory types with certain
-		 * requested type:
-		 * - request is uncached, return cannot be write-back
-		 * - request is uncached, return cannot be write-combine
-		 * - request is write-combine, return cannot be write-back
-		 */
-		if ((flags == _PAGE_CACHE_UC_MINUS &&
-		     (new_flags == _PAGE_CACHE_WB)) ||
-		    (flags == _PAGE_CACHE_WC &&
-		     new_flags == _PAGE_CACHE_WB)) {
+		if (!is_new_memtype_allowed(flags, new_flags)) {
 			free_memtype(addr, addr+len);
 			return -EINVAL;
 		}
diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index 72ebe91..8e6d0ca 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -301,7 +301,7 @@ static inline void ptep_modify_prot_commit(struct mm_struct *mm,
  * track_pfn_vma_new is called when a _new_ pfn mapping is being established
  * for physical range indicated by pfn and size.
  */
-static inline int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t prot,
+static inline int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t *prot,
 					unsigned long pfn, unsigned long size)
 {
 	return 0;
@@ -332,7 +332,7 @@ static inline void untrack_pfn_vma(struct vm_area_struct *vma,
 {
 }
 #else
-extern int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t prot,
+extern int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t *prot,
 				unsigned long pfn, unsigned long size);
 extern int track_pfn_vma_copy(struct vm_area_struct *vma);
 extern void untrack_pfn_vma(struct vm_area_struct *vma, unsigned long pfn,
diff --git a/mm/memory.c b/mm/memory.c
index c2d4c47..22bfa7a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1511,6 +1511,7 @@ int vm_insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 			unsigned long pfn)
 {
 	int ret;
+	pgprot_t pgprot = vma->vm_page_prot;
 	/*
 	 * Technically, architectures with pte_special can avoid all these
 	 * restrictions (same for remap_pfn_range).  However we would like
@@ -1525,10 +1526,10 @@ int vm_insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 
 	if (addr < vma->vm_start || addr >= vma->vm_end)
 		return -EFAULT;
-	if (track_pfn_vma_new(vma, vma->vm_page_prot, pfn, PAGE_SIZE))
+	if (track_pfn_vma_new(vma, &pgprot, pfn, PAGE_SIZE))
 		return -EINVAL;
 
-	ret = insert_pfn(vma, addr, pfn, vma->vm_page_prot);
+	ret = insert_pfn(vma, addr, pfn, pgprot);
 
 	if (ret)
 		untrack_pfn_vma(vma, pfn, PAGE_SIZE);
@@ -1671,9 +1672,15 @@ int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
 
 	vma->vm_flags |= VM_IO | VM_RESERVED | VM_PFNMAP;
 
-	err = track_pfn_vma_new(vma, prot, pfn, PAGE_ALIGN(size));
-	if (err)
+	err = track_pfn_vma_new(vma, &prot, pfn, PAGE_ALIGN(size));
+	if (err) {
+		/*
+		 * To indicate that track_pfn related cleanup is not
+		 * needed from higher level routine calling unmap_vmas
+		 */
+		vma->vm_flags &= ~(VM_IO | VM_RESERVED | VM_PFNMAP);
 		return -EINVAL;
+	}
 
 	BUG_ON(addr >= end);
 	pfn -= addr >> PAGE_SHIFT;
