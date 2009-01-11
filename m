Return-Path: <linux-kernel-owner+w=401wt.eu-S1753671AbZAKOk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671AbZAKOk1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 09:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395AbZAKOkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 09:40:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33480 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbZAKOkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 09:40:08 -0500
Date: Sun, 11 Jan 2009 15:39:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 fixes
Message-ID: <20090111143951.GA6666@elte.hu>
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

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

out-of-topic modifications in x86-fixes-for-linus:
--------------------------------------------------
include/asm-generic/pgtable.h      # e104ba3: x86 PAT: change track_pfn_vma_new
mm/memory.c                        # e104ba3: x86 PAT: change track_pfn_vma_new
                                   # e61304a: x86 PAT: remove PFNMAP type on tr

 Thanks,

	Ingo

------------------>
Andi Kleen (2):
      x86: hpet: allow force enable on ICH10 HPET
      x86: avoid theoretical vmalloc fault loop

Jaswinder Singh Rajput (1):
      x86: fix mpparse.c build error on latest git

Kyle McMartin (1):
      x86, mtrr: fix types used in userspace exported header

Suresh Siddha (1):
      x86, pat: fix reserve_memtype() for legacy 1MB range

venkatesh.pallipadi@intel.com (6):
      x86 PAT: remove PFNMAP type on track_pfn_vma_new() error
      x86 PAT: consolidate old memtype new memtype check into a function
      x86 PAT: change track_pfn_vma_new to take pgprot_t pointer param
      x86 PAT: return compatible mapping to remap_pfn_range callers
      x86 PAT: ioremap_wc should take resource_size_t parameter
      x86 PAT: remove CPA WARN_ON for zero pte


 arch/x86/include/asm/io.h      |    2 +-
 arch/x86/include/asm/mtrr.h    |   10 ++--
 arch/x86/include/asm/pgtable.h |   19 +++++++
 arch/x86/kernel/mpparse.c      |    1 +
 arch/x86/kernel/quirks.c       |    3 +-
 arch/x86/mm/fault.c            |    2 +-
 arch/x86/mm/ioremap.c          |    2 +-
 arch/x86/mm/pageattr.c         |   10 ++--
 arch/x86/mm/pat.c              |  109 +++++++++++++++++++++++++++------------
 arch/x86/pci/i386.c            |   12 +----
 include/asm-generic/pgtable.h  |    4 +-
 mm/memory.c                    |   15 ++++--
 12 files changed, 125 insertions(+), 64 deletions(-)

diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index 05cfed4..bdbb4b9 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -91,7 +91,7 @@ extern void unxlate_dev_mem_ptr(unsigned long phys, void *addr);
 
 extern int ioremap_change_attr(unsigned long vaddr, unsigned long size,
 				unsigned long prot_val);
-extern void __iomem *ioremap_wc(unsigned long offset, unsigned long size);
+extern void __iomem *ioremap_wc(resource_size_t offset, unsigned long size);
 
 /*
  * early_ioremap() and early_iounmap() are for temporary early boot-time
diff --git a/arch/x86/include/asm/mtrr.h b/arch/x86/include/asm/mtrr.h
index cb988aa..14080d2 100644
--- a/arch/x86/include/asm/mtrr.h
+++ b/arch/x86/include/asm/mtrr.h
@@ -58,15 +58,15 @@ struct mtrr_gentry {
 #endif /* !__i386__ */
 
 struct mtrr_var_range {
-	u32 base_lo;
-	u32 base_hi;
-	u32 mask_lo;
-	u32 mask_hi;
+	__u32 base_lo;
+	__u32 base_hi;
+	__u32 mask_lo;
+	__u32 mask_hi;
 };
 
 /* In the Intel processor's MTRR interface, the MTRR type is always held in
    an 8 bit field: */
-typedef u8 mtrr_type;
+typedef __u8 mtrr_type;
 
 #define MTRR_NUM_FIXED_RANGES 88
 #define MTRR_MAX_VAR_RANGES 256
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
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index c0601c2..a649a4c 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -27,6 +27,7 @@
 #include <asm/e820.h>
 #include <asm/trampoline.h>
 #include <asm/setup.h>
+#include <asm/smp.h>
 
 #include <mach_apic.h>
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index 309949e..697d1b7 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -172,7 +172,8 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH8_4,
 			 ich_force_enable_hpet);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH9_7,
 			 ich_force_enable_hpet);
-
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x3a16,	/* ICH10 */
+			 ich_force_enable_hpet);
 
 static struct pci_dev *cached_dev;
 
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 9e268b6..90dfae5 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -534,7 +534,7 @@ static int vmalloc_fault(unsigned long address)
 	   happen within a race in page table update. In the later
 	   case just flush. */
 
-	pgd = pgd_offset(current->mm ?: &init_mm, address);
+	pgd = pgd_offset(current->active_mm, address);
 	pgd_ref = pgd_offset_k(address);
 	if (pgd_none(*pgd_ref))
 		return -1;
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index bd85d42..2ddb1e7 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -367,7 +367,7 @@ EXPORT_SYMBOL(ioremap_nocache);
  *
  * Must be freed with iounmap.
  */
-void __iomem *ioremap_wc(unsigned long phys_addr, unsigned long size)
+void __iomem *ioremap_wc(resource_size_t phys_addr, unsigned long size)
 {
 	if (pat_enabled)
 		return __ioremap_caller(phys_addr, size, _PAGE_CACHE_WC,
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
index 85cbd3c..ec8cd49 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -333,11 +333,20 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 					      req_type & _PAGE_CACHE_MASK);
 	}
 
-	is_range_ram = pagerange_is_ram(start, end);
-	if (is_range_ram == 1)
-		return reserve_ram_pages_type(start, end, req_type, new_type);
-	else if (is_range_ram < 0)
-		return -EINVAL;
+	/*
+	 * For legacy reasons, some parts of the physical address range in the
+	 * legacy 1MB region is treated as non-RAM (even when listed as RAM in
+	 * the e820 tables).  So we will track the memory attributes of this
+	 * legacy 1MB region using the linear memtype_list always.
+	 */
+	if (end >= ISA_END_ADDRESS) {
+		is_range_ram = pagerange_is_ram(start, end);
+		if (is_range_ram == 1)
+			return reserve_ram_pages_type(start, end, req_type,
+						      new_type);
+		else if (is_range_ram < 0)
+			return -EINVAL;
+	}
 
 	new  = kmalloc(sizeof(struct memtype), GFP_KERNEL);
 	if (!new)
@@ -505,6 +514,35 @@ static inline int range_is_allowed(unsigned long pfn, unsigned long size)
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
@@ -555,9 +593,7 @@ int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
 	if (retval < 0)
 		return 0;
 
-	if (((pfn < max_low_pfn_mapped) ||
-	     (pfn >= (1UL<<(32 - PAGE_SHIFT)) && pfn < max_pfn_mapped)) &&
-	    ioremap_change_attr((unsigned long)__va(offset), size, flags) < 0) {
+	if (kernel_map_sync_memtype(offset, size, flags)) {
 		free_memtype(offset, offset + size);
 		printk(KERN_INFO
 		"%s:%d /dev/mem ioremap_change_attr failed %s for %Lx-%Lx\n",
@@ -601,12 +637,13 @@ void unmap_devmem(unsigned long pfn, unsigned long size, pgprot_t vma_prot)
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
 
@@ -625,26 +662,27 @@ static int reserve_pfn_range(u64 paddr, unsigned long size, pgprot_t vma_prot)
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
@@ -689,6 +727,7 @@ int track_pfn_vma_copy(struct vm_area_struct *vma)
 	unsigned long vma_start = vma->vm_start;
 	unsigned long vma_end = vma->vm_end;
 	unsigned long vma_size = vma_end - vma_start;
+	pgprot_t pgprot;
 
 	if (!pat_enabled)
 		return 0;
@@ -702,7 +741,8 @@ int track_pfn_vma_copy(struct vm_area_struct *vma)
 			WARN_ON_ONCE(1);
 			return -EINVAL;
 		}
-		return reserve_pfn_range(paddr, vma_size, __pgprot(prot));
+		pgprot = __pgprot(prot);
+		return reserve_pfn_range(paddr, vma_size, &pgprot, 1);
 	}
 
 	/* reserve entire vma page by page, using pfn and prot from pte */
@@ -710,7 +750,8 @@ int track_pfn_vma_copy(struct vm_area_struct *vma)
 		if (follow_phys(vma, vma_start + i, 0, &prot, &paddr))
 			continue;
 
-		retval = reserve_pfn_range(paddr, PAGE_SIZE, __pgprot(prot));
+		pgprot = __pgprot(prot);
+		retval = reserve_pfn_range(paddr, PAGE_SIZE, &pgprot, 1);
 		if (retval)
 			goto cleanup_ret;
 	}
@@ -741,7 +782,7 @@ cleanup_ret:
  * Note that this function can be called with caller trying to map only a
  * subrange/page inside the vma.
  */
-int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t prot,
+int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t *prot,
 			unsigned long pfn, unsigned long size)
 {
 	int retval = 0;
@@ -758,14 +799,14 @@ int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t prot,
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
index e009ce8..238fb8e 100644
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
