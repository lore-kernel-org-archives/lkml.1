Return-Path: <linux-kernel-owner+w=401wt.eu-S933291AbXJRLQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933291AbXJRLQt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 07:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763450AbXJRLPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 07:15:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:60730 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763322AbXJRLPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 07:15:42 -0400
Message-Id: <20071018111536.261090144@strauss.suse.de>
References: <20071018111535.356215664@strauss.suse.de>
User-Agent: quilt/0.46-60
Date: Thu, 18 Oct 2007 13:15:37 +0200
From: Bernhard Walle <bwalle@suse.de>
To: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Cc: akpm@linux-foundation.org, ak@suse.de, vgoyal@in.ibm.com
Subject: [patch 2/3] Introduce BOOTMEM_EXCLUSIVE
Content-Disposition: inline; filename=bootmem-alloc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This flag changes the reserve_bootmem() function to accept a new flag
BOOTMEM_EXCLUSIVE. If that flag is set, the function returns with
-EBUSY if the memory already has been reserved in the past. This is to
avoid conflicts.

Because it's necessary to unreserve the bootmem if a collision is discovered in
the middle of the area, a rwlock is introduced: only one BOOTMEM_EXCLUSIVE
caller is possible, but multiple BOOTMEM_DEFAULT callers. But if a
BOOTMEM_EXCLUSIVE caller is in reserve_bootmem_core(), no BOOTMEM_DEFAULT
callers are allowd.

IMPORTANT: The patch is only proof of concept. This means that it's only for
x86 and breaks other architectures. If the patch is ok, I'll change all other
architectures, too.


Signed-off-by: Bernhard Walle <bwalle@suse.de>

---
 arch/x86/kernel/mpparse_32.c |    6 ++++--
 arch/x86/kernel/setup_32.c   |   15 ++++++++-------
 arch/x86/kernel/setup_64.c   |    5 +++--
 include/linux/bootmem.h      |   14 +++++++++++++-
 mm/bootmem.c                 |   25 ++++++++++++++++++++-----
 5 files changed, 48 insertions(+), 17 deletions(-)

--- a/arch/x86/kernel/mpparse_32.c
+++ b/arch/x86/kernel/mpparse_32.c
@@ -736,7 +736,8 @@ static int __init smp_scan_config (unsig
 			smp_found_config = 1;
 			printk(KERN_INFO "found SMP MP-table at %08lx\n",
 						virt_to_phys(mpf));
-			reserve_bootmem(virt_to_phys(mpf), PAGE_SIZE);
+			reserve_bootmem(virt_to_phys(mpf), PAGE_SIZE,
+					BOOTMEM_DEFAULT);
 			if (mpf->mpf_physptr) {
 				/*
 				 * We cannot access to MPC table to compute
@@ -751,7 +752,8 @@ static int __init smp_scan_config (unsig
 				unsigned long end = max_low_pfn * PAGE_SIZE;
 				if (mpf->mpf_physptr + size > end)
 					size = end - mpf->mpf_physptr;
-				reserve_bootmem(mpf->mpf_physptr, size);
+				reserve_bootmem(mpf->mpf_physptr, size,
+						BOOTMEM_DEFAULT);
 			}
 
 			mpf_found = mpf;
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -317,7 +317,7 @@ static void __init reserve_ebda_region(v
 	unsigned int addr;
 	addr = get_bios_ebda();
 	if (addr)
-		reserve_bootmem(addr, PAGE_SIZE);	
+		reserve_bootmem(addr, PAGE_SIZE, BOOTMEM_DEFAULT);
 }
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES
@@ -411,7 +411,7 @@ static void __init reserve_crashkernel(v
 					(unsigned long)(total_mem >> 20));
 			crashk_res.start = crash_base;
 			crashk_res.end   = crash_base + crash_size - 1;
-			reserve_bootmem(crash_base, crash_size);
+			reserve_bootmem(crash_base, crash_size, BOOTMEM_DEFAULT);
 		} else
 			printk(KERN_INFO "crashkernel reservation failed - "
 					"you have to specify a base address\n");
@@ -439,13 +439,14 @@ void __init setup_bootmem_allocator(void
 	 * bootmem allocator with an invalid RAM area.
 	 */
 	reserve_bootmem(__pa_symbol(_text), (PFN_PHYS(min_low_pfn) +
-			 bootmap_size + PAGE_SIZE-1) - __pa_symbol(_text));
+			 bootmap_size + PAGE_SIZE-1) - __pa_symbol(_text),
+			 BOOTMEM_DEFAULT);
 
 	/*
 	 * reserve physical page 0 - it's a special BIOS page on many boxes,
 	 * enabling clean reboots, SMP operation, laptop functions.
 	 */
-	reserve_bootmem(0, PAGE_SIZE);
+	reserve_bootmem(0, PAGE_SIZE, BOOTMEM_DEFAULT);
 
 	/* reserve EBDA region, it's a 4K region */
 	reserve_ebda_region();
@@ -455,7 +456,7 @@ void __init setup_bootmem_allocator(void
        unless you have no PS/2 mouse plugged in. */
 	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
 	    boot_cpu_data.x86 == 6)
-	     reserve_bootmem(0xa0000 - 4096, 4096);
+	     reserve_bootmem(0xa0000 - 4096, 4096, BOOTMEM_DEFAULT);
 
 #ifdef CONFIG_SMP
 	/*
@@ -463,7 +464,7 @@ void __init setup_bootmem_allocator(void
 	 * FIXME: Don't need the extra page at 4K, but need to fix
 	 * trampoline before removing it. (see the GDT stuff)
 	 */
-	reserve_bootmem(PAGE_SIZE, PAGE_SIZE);
+	reserve_bootmem(PAGE_SIZE, PAGE_SIZE, BOOTMEM_DEFAULT);
 #endif
 #ifdef CONFIG_ACPI_SLEEP
 	/*
@@ -481,7 +482,7 @@ void __init setup_bootmem_allocator(void
 #ifdef CONFIG_BLK_DEV_INITRD
 	if (LOADER_TYPE && INITRD_START) {
 		if (INITRD_START + INITRD_SIZE <= (max_low_pfn << PAGE_SHIFT)) {
-			reserve_bootmem(INITRD_START, INITRD_SIZE);
+			reserve_bootmem(INITRD_START, INITRD_SIZE, BOOTMEM_DEFAULT);
 			initrd_start = INITRD_START + PAGE_OFFSET;
 			initrd_end = initrd_start+INITRD_SIZE;
 		}
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -171,7 +171,7 @@ contig_initmem_init(unsigned long start_
 	bootmap_size = init_bootmem(bootmap >> PAGE_SHIFT, end_pfn);
 	e820_register_active_regions(0, start_pfn, end_pfn);
 	free_bootmem_with_active_regions(0, end_pfn);
-	reserve_bootmem(bootmap, bootmap_size);
+	reserve_bootmem(bootmap, bootmap_size, BOOTMEM_DEFAULT);
 } 
 #endif
 
@@ -218,7 +218,8 @@ static void __init reserve_crashkernel(v
 					(unsigned long)(free_mem >> 20));
 			crashk_res.start = crash_base;
 			crashk_res.end   = crash_base + crash_size - 1;
-			reserve_bootmem(crash_base, crash_size);
+			reserve_bootmem(crash_base, crash_size,
+					BOOTMEM_DEFAULT);
 		} else
 			printk(KERN_INFO "crashkernel reservation failed - "
 					"you have to specify a base address\n");
--- a/include/linux/bootmem.h
+++ b/include/linux/bootmem.h
@@ -61,8 +61,20 @@ extern void *__alloc_bootmem_core(struct
 				  unsigned long limit);
 extern void *alloc_bootmem_high_node(pg_data_t *pgdat, unsigned long size);
 
+/*
+ * flags for reserve_bootmem (also if CONFIG_HAVE_ARCH_BOOTMEM_NODE,
+ * the architecture-specific code should honor this)
+ */
+#define BOOTMEM_DEFAULT		0
+#define BOOTMEM_EXCLUSIVE	(1<<0)
+
 #ifndef CONFIG_HAVE_ARCH_BOOTMEM_NODE
-extern void reserve_bootmem(unsigned long addr, unsigned long size);
+/*
+ * If flags is 0, then the return value is always 0 (success). If
+ * flags contains BOOTMEM_EXCLUSIVE, then -EBUSY is returned if the
+ * memory already was reserved.
+ */
+extern int reserve_bootmem(unsigned long addr, unsigned long size, int flags);
 #define alloc_bootmem(x) \
 	__alloc_bootmem(x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
 #define alloc_bootmem_low(x) \
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -111,11 +111,12 @@ static unsigned long __init init_bootmem
  * might be used for boot-time allocations - or it might get added
  * to the free page pool later on.
  */
-static void __init reserve_bootmem_core(bootmem_data_t *bdata, unsigned long addr,
-					unsigned long size)
+static int __init reserve_bootmem_core(bootmem_data_t *bdata, unsigned long addr,
+					unsigned long size, int flags)
 {
 	unsigned long sidx, eidx;
 	unsigned long i;
+	int ret;
 
 	/*
 	 * round up, partially reserved pages are considered
@@ -133,7 +134,20 @@ static void __init reserve_bootmem_core(
 #ifdef CONFIG_DEBUG_BOOTMEM
 			printk("hm, page %08lx reserved twice.\n", i*PAGE_SIZE);
 #endif
+			if (flags & BOOTMEM_EXCLUSIVE) {
+				ret = -EBUSY;
+				goto err;
+			}
 		}
+
+	return 0;
+
+err:
+	/* unreserve memory we accidentally reserved */
+	for (i--; i >= sidx; i--)
+		clear_bit(i, bdata->node_bootmem_map);
+
+	return ret;
 }
 
 static void __init free_bootmem_core(bootmem_data_t *bdata, unsigned long addr,
@@ -376,7 +390,7 @@ unsigned long __init init_bootmem_node(p
 void __init reserve_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
 				 unsigned long size)
 {
-	reserve_bootmem_core(pgdat->bdata, physaddr, size);
+	reserve_bootmem_core(pgdat->bdata, physaddr, size, BOOTMEM_DEFAULT);
 }
 
 void __init free_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
@@ -398,9 +412,10 @@ unsigned long __init init_bootmem(unsign
 }
 
 #ifndef CONFIG_HAVE_ARCH_BOOTMEM_NODE
-void __init reserve_bootmem(unsigned long addr, unsigned long size)
+int __init reserve_bootmem(unsigned long addr, unsigned long size,
+			    int flags)
 {
-	reserve_bootmem_core(NODE_DATA(0)->bdata, addr, size);
+	return reserve_bootmem_core(NODE_DATA(0)->bdata, addr, size, flags);
 }
 #endif /* !CONFIG_HAVE_ARCH_BOOTMEM_NODE */
 

-- 
