Return-Path: <linux-kernel-owner+w=401wt.eu-S1757721AbZALWOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757721AbZALWOc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 17:14:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbZALWOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 17:14:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38634 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753342AbZALWOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 17:14:09 -0500
Date: Mon, 12 Jan 2009 23:13:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 fixes
Message-ID: <20090112221352.GC12462@elte.hu>
References: <20090111143951.GA6666@elte.hu> <64bb37e0901110845o2561db4auf68b86d024d210a0@mail.gmail.com> <7E82351C108FA840AB1866AC776AEC4643BB73C5@orsmsx505.amr.corp.intel.com> <64bb37e0901121101y73c492fel38a70681f226b526@mail.gmail.com> <20090112191934.GA28851@linux-os.sc.intel.com> <20090112192912.GA31650@linux-os.sc.intel.com> <64bb37e0901121205u78195ac4j145fa922f9e99107@mail.gmail.com> <20090112204041.GB3329@elte.hu> <64bb37e0901121350l696b866k4216a36c36ff5785@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64bb37e0901121350l696b866k4216a36c36ff5785@mail.gmail.com>
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


* Torsten Kaiser <just.for.lkml@googlemail.com> wrote:

> On Mon, Jan 12, 2009 at 9:40 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Torsten Kaiser <just.for.lkml@googlemail.com> wrote:
> >
> >> On Mon, Jan 12, 2009 at 8:29 PM, Pallipadi, Venkatesh
> >> <venkatesh.pallipadi@intel.com> wrote:
> >> > oops. I missed out one file in the earlier test patch. Below is the
> >> > updated test patch that will go against 29-rc1.
> >> >
> >> > Thanks,
> >> > Venki
> >> >
> >> > Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipad@intel.com>
> >>
> >> Tested-by: Torsten Kaiser <just.for.lkml@googlemail.com>
> >>
> >> The system boots normal and glxgears is accelerated again.
> >
> > Could you try the tree below as well please?
> 
> Before I read this mail, I already tried the tree you send to Linus as a 
> pull request. That worked without a crash, but as expected the DRM 
> related error was still there.

Do you mean today's x86-fixes pull request to Linus? That would be the 
expected behavior: i separated out the PAT fixes from that tree to be able 
to progress with those other fixes - while the PAT angle is investigated. 

Neither your crash log nor the review of the PAT patches revealed a 
smoking gun (to me at least), but your crash obviously happened, and it 
happened right after you pulled the x86-fixes tree.

> pulled && build, here is the result:
> [   76.170171] BUG: unable to handle kernel NULL pointer dereference at (null)
> [   76.178376] IP: [<(null)>] (null)

thanks, that's really helpful!

Below is the delta from the minimal patch you tried earlier today, to the 
full clean patchset.

By all likelyhood, if you apply Venki's patch (which you tested earlier 
today, and which did not crash and gave back 3D performance to you), and 
then apply the patch below, you'll get the same crash again.

So the bug is in the diff below. My first guess would be:

-extern void __iomem *ioremap_wc(unsigned long offset, unsigned long size);
+extern void __iomem *ioremap_wc(resource_size_t offset, unsigned long size);

we extended 4G to 64-bits on 32-bit systems. If there's a width problem 
somewhere along the road we can mess the pagetables up real big.

the other possibility would be this hunk:

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

That is this patch's effect:

  4fa1489: x86, pat: fix reserve_memtype() for legacy 1MB range

if you have more testing capacity, could you please try tip/master again:

  http://people.redhat.com/mingo/tip.git/README

by all likelyhood it will crash for you (it has the PAT fixes included). 
Then type this:

  git revert 4fa1489

Does that solve the crash and give you good 3D performance again?

	Ingo

-------------->
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
index 472d8ef..ec8cd49 100644
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
@@ -605,7 +641,7 @@ static int reserve_pfn_range(u64 paddr, unsigned long size, pgprot_t *vma_prot,
 				int strict_prot)
 {
 	int is_ram = 0;
-	int id_sz, ret;
+	int ret;
 	unsigned long flags;
 	unsigned long want_flags = (pgprot_val(*vma_prot) & _PAGE_CACHE_MASK);
 
@@ -626,11 +662,7 @@ static int reserve_pfn_range(u64 paddr, unsigned long size, pgprot_t *vma_prot,
 		return ret;
 
 	if (flags != want_flags) {
-		if (strict_prot ||
-		    (want_flags == _PAGE_CACHE_UC_MINUS &&
-		     flags == _PAGE_CACHE_WB) ||
-		    (want_flags == _PAGE_CACHE_WC &&
-		     flags == _PAGE_CACHE_WB)) {
+		if (strict_prot || !is_new_memtype_allowed(want_flags, flags)) {
 			free_memtype(paddr, paddr + size);
 			printk(KERN_ERR "%s:%d map pfn expected mapping type %s"
 				" for %Lx-%Lx, got %s\n",
@@ -648,18 +680,9 @@ static int reserve_pfn_range(u64 paddr, unsigned long size, pgprot_t *vma_prot,
 		*vma_prot = __pgprot((pgprot_val(*vma_prot) &
 				      (~_PAGE_CACHE_MASK)) |
 				     flags);
-
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
