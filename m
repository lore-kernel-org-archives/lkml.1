Return-Path: <linux-kernel-owner+w=401wt.eu-S1754669AbZALUjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbZALUjV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 15:39:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbZALUjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 15:39:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48314 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826AbZALUjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 15:39:08 -0500
Date: Mon, 12 Jan 2009 21:38:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 fixes
Message-ID: <20090112203852.GA3329@elte.hu>
References: <20090111143951.GA6666@elte.hu> <64bb37e0901110845o2561db4auf68b86d024d210a0@mail.gmail.com> <7E82351C108FA840AB1866AC776AEC4643BB73C5@orsmsx505.amr.corp.intel.com> <64bb37e0901121101y73c492fel38a70681f226b526@mail.gmail.com> <20090112191934.GA28851@linux-os.sc.intel.com> <20090112192912.GA31650@linux-os.sc.intel.com> <alpine.LFD.2.00.0901121145220.6528@localhost.localdomain> <20090112195438.GA4538@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112195438.GA4538@linux-os.sc.intel.com>
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


* Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com> wrote:

> On Mon, Jan 12, 2009 at 11:47:13AM -0800, Linus Torvalds wrote:
> > 
> > 
> > On Mon, 12 Jan 2009, Pallipadi, Venkatesh wrote:
> > > +		if (strict_prot ||
> > > +		    (want_flags == _PAGE_CACHE_UC_MINUS &&
> > > +		     flags == _PAGE_CACHE_WB) ||
> > > +		    (want_flags == _PAGE_CACHE_WC &&
> > > +		     flags == _PAGE_CACHE_WB)) {
> > 
> > Please don't write code like this.
> > 
> > Do it as an inline function that returns true/false and has comments on 
> > what the hell is going on.
> > 
> > If a conditional doesn't fit on one line, it should generally be 
> > abstracted away into a readable function where the name explains what it 
> > does conceptually.
> > 
> 
> Yes. The actual patch that is lined up in tip fixes indeed has this as a 
> macro sharing this code with 2 callers and comment about this 
> (is_new_memtype_allowed()). I wanted to keep the changes smaller in this 
> test patch, which is just to root cause this particular crash and ended 
> up with above code.

here are those 7 tip/x86/pat commits below, with changelogs.

	Ingo

----------------------->
commit 4fa1489d2a74c1e3c6231f449d73ce46131523ae
Author: Suresh Siddha <suresh.b.siddha@intel.com>
Date:   Fri Jan 9 14:35:20 2009 -0800

    x86, pat: fix reserve_memtype() for legacy 1MB range
    
    Thierry Vignaud reported:
    > http://bugzilla.kernel.org/show_bug.cgi?id=12372
    >
    > On P4 with an SiS motherboard (video card is a SiS 651)
    > X server fails to start with error:
    > xf86MapVidMem: Could not mmap framebuffer (0x00000000,0x2000) (Invalid
    > argument)
    
    Here X is trying to map first 8KB of memory using /dev/mem. Existing
    code treats first 0-4KB of memory as non-RAM and 4KB-8KB as RAM. Recent
    code changes don't allow to map memory with different attributes
    at the same time.
    
    Fix this by treating the first 1MB legacy region as special and always
    track the attribute requests with in this region using linear linked
    list (and don't bother if the range is RAM or non-RAM or mixed)
    
    Reported-and-tested-by: Thierry Vignaud <tvignaud@mandriva.com>
    Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 160c42d..ec8cd49 100644
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

commit 895252ccb3050383e1dcf2c2536065e346c2fa14
Author: venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com>
Date:   Fri Jan 9 16:13:14 2009 -0800

    x86 PAT: remove CPA WARN_ON for zero pte
    
    Impact: reduce scope of debug check - avoid warnings
    
    The logic to find whether identity map exists or not using
    high_memory or max_low_pfn_mapped/max_pfn_mapped are not complete
    as the memory withing the range may not be mapped if there is a
    unusable hole in e820.
    
    Specifically, on my test system I started seeing these warnings with
    tools like hwinfo, acpidump trying to map ACPI region.
    
    [   27.400018] ------------[ cut here ]------------
    [   27.400344] WARNING: at /home/venkip/src/linus/linux-2.6/arch/x86/mm/pageattr.c:560 __change_page_attr_set_clr+0xf3/0x8b8()
    [   27.400821] Hardware name: X7DB8
    [   27.401070] CPA: called for zero pte. vaddr = ffff8800cff6a000 cpa->vaddr = ffff8800cff6a000
    [   27.401569] Modules linked in:
    [   27.401882] Pid: 4913, comm: dmidecode Not tainted 2.6.28-05716-gfe0bdec #586
    [   27.402141] Call Trace:
    [   27.402488]  [<ffffffff80237c21>] warn_slowpath+0xd3/0x10f
    [   27.402749]  [<ffffffff80274ade>] ? find_get_page+0xb3/0xc9
    [   27.403028]  [<ffffffff80274a2b>] ? find_get_page+0x0/0xc9
    [   27.403333]  [<ffffffff80226425>] __change_page_attr_set_clr+0xf3/0x8b8
    [   27.403628]  [<ffffffff8028ec99>] ? __purge_vmap_area_lazy+0x192/0x1a1
    [   27.403883]  [<ffffffff8028eb52>] ? __purge_vmap_area_lazy+0x4b/0x1a1
    [   27.404172]  [<ffffffff80290268>] ? vm_unmap_aliases+0x1ab/0x1bb
    [   27.404512]  [<ffffffff80290105>] ? vm_unmap_aliases+0x48/0x1bb
    [   27.404766]  [<ffffffff80226d28>] change_page_attr_set_clr+0x13e/0x2e6
    [   27.405026]  [<ffffffff80698fa7>] ? _spin_unlock+0x26/0x2a
    [   27.405292]  [<ffffffff80227e6a>] ? reserve_memtype+0x19b/0x4e3
    [   27.405590]  [<ffffffff80226ffd>] _set_memory_wb+0x22/0x24
    [   27.405844]  [<ffffffff80225d28>] ioremap_change_attr+0x26/0x28
    [   27.406097]  [<ffffffff80228355>] reserve_pfn_range+0x1a3/0x235
    [   27.406427]  [<ffffffff80228430>] track_pfn_vma_new+0x49/0xb3
    [   27.406686]  [<ffffffff80286c46>] remap_pfn_range+0x94/0x32c
    [   27.406940]  [<ffffffff8022878d>] ? phys_mem_access_prot_allowed+0xb5/0x1a8
    [   27.407209]  [<ffffffff803e9bf4>] mmap_mem+0x75/0x9d
    [   27.407523]  [<ffffffff8028b3b4>] mmap_region+0x2cf/0x53e
    [   27.407776]  [<ffffffff8028b8cc>] do_mmap_pgoff+0x2a9/0x30d
    [   27.408034]  [<ffffffff8020f4a4>] sys_mmap+0x92/0xce
    [   27.408339]  [<ffffffff8020b65b>] system_call_fastpath+0x16/0x1b
    [   27.408614] ---[ end trace 4b16ad70c09a602d ]---
    [   27.408871] dmidecode:4913 reserve_pfn_range ioremap_change_attr failed write-back for cff6a000-cff6b000
    
    This is wih track_pfn_vma_new trying to keep identity map in sync.
    The address cff6a000 is the ACPI region according to e820.
    
    [    0.000000] BIOS-provided physical RAM map:
    [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009c000 (usable)
    [    0.000000]  BIOS-e820: 000000000009c000 - 00000000000a0000 (reserved)
    [    0.000000]  BIOS-e820: 00000000000cc000 - 00000000000d0000 (reserved)
    [    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
    [    0.000000]  BIOS-e820: 0000000000100000 - 00000000cff60000 (usable)
    [    0.000000]  BIOS-e820: 00000000cff60000 - 00000000cff69000 (ACPI data)
    [    0.000000]  BIOS-e820: 00000000cff69000 - 00000000cff80000 (ACPI NVS)
    [    0.000000]  BIOS-e820: 00000000cff80000 - 00000000d0000000 (reserved)
    [    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
    [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
    [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
    [    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
    [    0.000000]  BIOS-e820: 0000000100000000 - 0000000230000000 (usable)
    
    And is not mapped as per init_memory_mapping.
    
    [    0.000000] init_memory_mapping: 0000000000000000-00000000cff60000
    [    0.000000] init_memory_mapping: 0000000100000000-0000000230000000
    
    We can add logic to check for this. But, there can also be other holes in
    identity map when we have 1GB of aligned reserved space in e820.
    
    This patch handles it by removing the WARN_ON and returning a specific
    error value (EFAULT) to indicate that the address does not have any
    identity mapping.
    
    The code that tries to keep identity map in sync can ignore
    this error, with other callers of cpa still getting error here.
    
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

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
index 8b08fb9..160c42d 100644
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
@@ -605,7 +632,7 @@ static int reserve_pfn_range(u64 paddr, unsigned long size, pgprot_t *vma_prot,
 				int strict_prot)
 {
 	int is_ram = 0;
-	int id_sz, ret;
+	int ret;
 	unsigned long flags;
 	unsigned long want_flags = (pgprot_val(*vma_prot) & _PAGE_CACHE_MASK);
 
@@ -646,15 +673,7 @@ static int reserve_pfn_range(u64 paddr, unsigned long size, pgprot_t *vma_prot,
 				     flags);
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

commit 838b120c59b530ba58cc0197d208d08455733472
Author: venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com>
Date:   Fri Jan 9 16:13:13 2009 -0800

    x86 PAT: ioremap_wc should take resource_size_t parameter
    
    Impact: fix/extend ioremap_wc() beyond 4GB aperture on 32-bit
    
    ioremap_wc() was taking in unsigned long parameter, where as it should take
    64-bit resource_size_t parameter like other ioremap variants.
    
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

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

commit 283c81fe6568202db345649e874d2a0f29dc5a84
Author: venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com>
Date:   Fri Jan 9 16:13:12 2009 -0800

    x86 PAT: return compatible mapping to remap_pfn_range callers
    
    Impact: avoid warning message, potentially solve 3D performance regression
    
    Change x86 PAT code to return compatible memtype if the exact memtype that
    was requested in remap_pfn_rage and friends is not available due to some
    conflict.
    
    This is done by returning the compatible type in pgprot parameter of
    track_pfn_vma_new(), and the caller uses that memtype for page table.
    
    Note that track_pfn_vma_copy() which is basically called during fork gets the
    prot from existing page table and should not have any conflict. Hence we use
    strict memtype check there and do not allow compatible memtypes.
    
    This patch fixes the bug reported here:
    
      http://marc.info/?l=linux-kernel&m=123108883716357&w=2
    
    Specifically the error message:
    
      X:5010 map pfn expected mapping type write-back for d0000000-d0101000,
      got write-combining
    
    Should go away.
    
    Reported-and-bisected-by: Kevin Winchester <kjwinchester@gmail.com>
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index f88ac80..8b08fb9 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -601,12 +601,13 @@ void unmap_devmem(unsigned long pfn, unsigned long size, pgprot_t vma_prot)
  * Reserved non RAM regions only and after successful reserve_memtype,
  * this func also keeps identity mapping (if any) in sync with this new prot.
  */
-static int reserve_pfn_range(u64 paddr, unsigned long size, pgprot_t vma_prot)
+static int reserve_pfn_range(u64 paddr, unsigned long size, pgprot_t *vma_prot,
+				int strict_prot)
 {
 	int is_ram = 0;
 	int id_sz, ret;
 	unsigned long flags;
-	unsigned long want_flags = (pgprot_val(vma_prot) & _PAGE_CACHE_MASK);
+	unsigned long want_flags = (pgprot_val(*vma_prot) & _PAGE_CACHE_MASK);
 
 	is_ram = pagerange_is_ram(paddr, paddr + size);
 
@@ -625,15 +626,24 @@ static int reserve_pfn_range(u64 paddr, unsigned long size, pgprot_t vma_prot)
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
 
 	/* Need to keep identity mapping in sync */
@@ -689,6 +699,7 @@ int track_pfn_vma_copy(struct vm_area_struct *vma)
 	unsigned long vma_start = vma->vm_start;
 	unsigned long vma_end = vma->vm_end;
 	unsigned long vma_size = vma_end - vma_start;
+	pgprot_t pgprot;
 
 	if (!pat_enabled)
 		return 0;
@@ -702,7 +713,8 @@ int track_pfn_vma_copy(struct vm_area_struct *vma)
 			WARN_ON_ONCE(1);
 			return -EINVAL;
 		}
-		return reserve_pfn_range(paddr, vma_size, __pgprot(prot));
+		pgprot = __pgprot(prot);
+		return reserve_pfn_range(paddr, vma_size, &pgprot, 1);
 	}
 
 	/* reserve entire vma page by page, using pfn and prot from pte */
@@ -710,7 +722,8 @@ int track_pfn_vma_copy(struct vm_area_struct *vma)
 		if (follow_phys(vma, vma_start + i, 0, &prot, &paddr))
 			continue;
 
-		retval = reserve_pfn_range(paddr, PAGE_SIZE, __pgprot(prot));
+		pgprot = __pgprot(prot);
+		retval = reserve_pfn_range(paddr, PAGE_SIZE, &pgprot, 1);
 		if (retval)
 			goto cleanup_ret;
 	}
@@ -758,14 +771,14 @@ int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t *prot,
 	if (is_linear_pfn_mapping(vma)) {
 		/* reserve the whole chunk starting from vm_pgoff */
 		paddr = (resource_size_t)vma->vm_pgoff << PAGE_SHIFT;
-		return reserve_pfn_range(paddr, vma_size, *prot);
+		return reserve_pfn_range(paddr, vma_size, prot, 0);
 	}
 
 	/* reserve page by page using pfn and size */
 	base_paddr = (resource_size_t)pfn << PAGE_SHIFT;
 	for (i = 0; i < size; i += PAGE_SIZE) {
 		paddr = base_paddr + i;
-		retval = reserve_pfn_range(paddr, PAGE_SIZE, *prot);
+		retval = reserve_pfn_range(paddr, PAGE_SIZE, prot, 0);
 		if (retval)
 			goto cleanup_ret;
 	}

commit dfed11010f7b2d994444bcd83ec4cc7e80d7d030
Author: venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com>
Date:   Fri Jan 9 16:13:11 2009 -0800

    x86 PAT: change track_pfn_vma_new to take pgprot_t pointer param
    
    Impact: cleanup
    
    Change the protection parameter for track_pfn_vma_new() into a pgprot_t pointer.
    Subsequent patch changes the x86 PAT handling to return a compatible
    memtype in pgprot_t, if what was requested cannot be allowed due to conflicts.
    No fuctionality change in this patch.
    
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 85cbd3c..f88ac80 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -741,7 +741,7 @@ cleanup_ret:
  * Note that this function can be called with caller trying to map only a
  * subrange/page inside the vma.
  */
-int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t prot,
+int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t *prot,
 			unsigned long pfn, unsigned long size)
 {
 	int retval = 0;
@@ -758,14 +758,14 @@ int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t prot,
 	if (is_linear_pfn_mapping(vma)) {
 		/* reserve the whole chunk starting from vm_pgoff */
 		paddr = (resource_size_t)vma->vm_pgoff << PAGE_SHIFT;
-		return reserve_pfn_range(paddr, vma_size, prot);
+		return reserve_pfn_range(paddr, vma_size, *prot);
 	}
 
 	/* reserve page by page using pfn and size */
 	base_paddr = (resource_size_t)pfn << PAGE_SHIFT;
 	for (i = 0; i < size; i += PAGE_SIZE) {
 		paddr = base_paddr + i;
-		retval = reserve_pfn_range(paddr, PAGE_SIZE, prot);
+		retval = reserve_pfn_range(paddr, PAGE_SIZE, *prot);
 		if (retval)
 			goto cleanup_ret;
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
index 61c7e1e..238fb8e 100644
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
@@ -1671,7 +1672,7 @@ int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
 
 	vma->vm_flags |= VM_IO | VM_RESERVED | VM_PFNMAP;
 
-	err = track_pfn_vma_new(vma, prot, pfn, PAGE_ALIGN(size));
+	err = track_pfn_vma_new(vma, &prot, pfn, PAGE_ALIGN(size));
 	if (err) {
 		/*
 		 * To indicate that track_pfn related cleanup is not

commit a8eae3321ea94fe06c6a76b48cc6a082116b1784
Author: venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com>
Date:   Fri Jan 9 16:13:10 2009 -0800

    x86 PAT: consolidate old memtype new memtype check into a function
    
    Impact: cleanup
    
    Move the new memtype old memtype allowed check to header so that is can be
    shared by other users. Subsequent patch uses this in pat.c in remap_pfn_range()
    code path. No functionality change in this patch.
    
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

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

commit 18d82ebde7e40bf67c84b505a12be26133a89932
Author: venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com>
Date:   Fri Jan 9 16:13:09 2009 -0800

    x86 PAT: remove PFNMAP type on track_pfn_vma_new() error
    
    Impact: fix (harmless) double-free of memtype entries and avoid warning
    
    On track_pfn_vma_new() failure, reset the vm_flags so that there will be
    no second cleanup happening when upper level routines call unmap_vmas().
    
    This patch fixes part of the bug reported here:
    
      http://marc.info/?l=linux-kernel&m=123108883716357&w=2
    
    Specifically the error message:
    
      X:5010 freeing invalid memtype d0000000-d0101000
    
    Is due to multiple frees on error path, will not happen with the patch below.
    
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/mm/memory.c b/mm/memory.c
index e009ce8..61c7e1e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1672,8 +1672,14 @@ int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
 	vma->vm_flags |= VM_IO | VM_RESERVED | VM_PFNMAP;
 
 	err = track_pfn_vma_new(vma, prot, pfn, PAGE_ALIGN(size));
-	if (err)
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
