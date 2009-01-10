Return-Path: <linux-kernel-owner+w=401wt.eu-S932674AbZAJA1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932674AbZAJA1E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 19:27:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760186AbZAJAYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 19:24:43 -0500
Received: from mga01.intel.com ([192.55.52.88]:30104 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756970AbZAJAYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 19:24:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,242,1231142400"; 
   d="scan'208";a="655938479"
Message-Id: <20090110001405.193213000@intel.com>
References: <20090110001308.403550000@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 09 Jan 2009 16:13:14 -0800
From: venkatesh.pallipadi@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
       kjwinchester@gmail.com,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [patch 6/6] x86 PAT: Remove CPA WARN_ON for zero pte
Content-Disposition: inline; filename=function_kernel_map_sync_memtype.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Patch below handles this by removing the WARN_ON and returning a specific
error value (EFAULT) to indicate that the address does not have any
identity mapping. The code that tries to keep identity map in sync can ignore
this error, with other callers of cpa still getting error here.
 
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

---
 arch/x86/mm/pageattr.c |   10 ++++++----
 arch/x86/mm/pat.c      |   45 ++++++++++++++++++++++++++++++++-------------
 2 files changed, 38 insertions(+), 17 deletions(-)

Index: linux-2.6/arch/x86/mm/pat.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/pat.c	2009-01-09 13:19:52.000000000 -0800
+++ linux-2.6/arch/x86/mm/pat.c	2009-01-09 14:00:20.000000000 -0800
@@ -505,6 +505,35 @@ static inline int range_is_allowed(unsig
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
@@ -555,9 +584,7 @@ int phys_mem_access_prot_allowed(struct 
 	if (retval < 0)
 		return 0;
 
-	if (((pfn < max_low_pfn_mapped) ||
-	     (pfn >= (1UL<<(32 - PAGE_SHIFT)) && pfn < max_pfn_mapped)) &&
-	    ioremap_change_attr((unsigned long)__va(offset), size, flags) < 0) {
+	if (kernel_map_sync_memtype(offset, size, flags)) {
 		free_memtype(offset, offset + size);
 		printk(KERN_INFO
 		"%s:%d /dev/mem ioremap_change_attr failed %s for %Lx-%Lx\n",
@@ -605,7 +632,7 @@ static int reserve_pfn_range(u64 paddr, 
 				int strict_prot)
 {
 	int is_ram = 0;
-	int id_sz, ret;
+	int ret;
 	unsigned long flags;
 	unsigned long want_flags = (pgprot_val(*vma_prot) & _PAGE_CACHE_MASK);
 
@@ -646,15 +673,7 @@ static int reserve_pfn_range(u64 paddr, 
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
Index: linux-2.6/arch/x86/mm/pageattr.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/pageattr.c	2009-01-09 13:19:52.000000000 -0800
+++ linux-2.6/arch/x86/mm/pageattr.c	2009-01-09 13:54:46.000000000 -0800
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

-- 

