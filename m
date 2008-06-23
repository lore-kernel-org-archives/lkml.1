Return-Path: <linux-kernel-owner+w=401wt.eu-S1755478AbYFWKFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbYFWKFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 06:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbYFWKFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 06:05:06 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:16186 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbYFWKFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 06:05:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=egN0mFz3CDP2bBsDAOZICpIpSp0o7zn3xP4sO/aJXGsj6GasjKquVpw8ZlyW1UMkIk
         6Czp1eDIrssCeO4bFROTVPbCZLGgt5xaX/0CWb6N5tNggTxq/iLCkVR0KYGUzIGpqjfz
         v9RNbi7MzeLl57Z/hgHrizRnTo8VyT/XZQEfo=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] x86: cleanup using max_low_pfn for 32 bit
Date: Mon, 23 Jun 2008 03:05:30 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806180215.53755.yhlu.kernel@gmail.com> <200806220245.39289.yhlu.kernel@gmail.com> <200806220246.58958.yhlu.kernel@gmail.com>
In-Reply-To: <200806220246.58958.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806230305.30944.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


for max_low_pfn is not changed after it is set.
so we can move that early and out of initmem_init.

could call find_low_pfn_range just after max_pfn is set.

also could move reserve_initrd out of setup_bootmem_allocator

so 32bit is more like 64bit.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/setup_32.c |   16 ++++++++++------
 arch/x86/kernel/setup_64.c |    2 +-
 arch/x86/mm/discontig_32.c |   22 +++++++---------------
 arch/x86/mm/init_32.c      |   25 +++++++++----------------
 include/asm-x86/page_32.h  |    3 ++-
 include/asm-x86/setup.h    |    2 --
 6 files changed, 29 insertions(+), 41 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_32.c
+++ linux-2.6/arch/x86/kernel/setup_32.c
@@ -189,13 +189,14 @@ static inline void copy_edd(void)
 
 static bool do_relocate_initrd = false;
 
-void __init reserve_initrd(void)
+static void __init reserve_initrd(void)
 {
 	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
 	u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
 	u64 ramdisk_end   = ramdisk_image + ramdisk_size;
 	u64 end_of_lowmem = max_low_pfn << PAGE_SHIFT;
 	u64 ramdisk_here;
+	u64 ramdisk_target;
 
 	if (!boot_params.hdr.type_of_loader ||
 	    !ramdisk_image || !ramdisk_size)
@@ -203,7 +204,7 @@ void __init reserve_initrd(void)
 
 	initrd_start = 0;
 
-	if (ramdisk_size >= end_of_lowmem/2) {
+	if (ramdisk_size >= (end_of_lowmem>>1)) {
 		free_early(ramdisk_image, ramdisk_end);
 		printk(KERN_ERR "initrd too large to handle, "
 		       "disabling initrd\n");
@@ -226,7 +227,8 @@ void __init reserve_initrd(void)
 	}
 
 	/* We need to move the initrd down into lowmem */
-	ramdisk_here = find_e820_area(min_low_pfn<<PAGE_SHIFT,
+	ramdisk_target = max_pfn_mapped<<PAGE_SHIFT;
+	ramdisk_here = find_e820_area(min(ramdisk_target, end_of_lowmem>>1),
 				 end_of_lowmem, ramdisk_size,
 				 PAGE_SIZE);
 
@@ -347,8 +349,6 @@ static void set_mca_bus(int x) { }
  */
 void __init setup_arch(char **cmdline_p)
 {
-	unsigned long max_low_pfn;
-
 	memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
 	pre_setup_arch_hook();
 	early_cpu_init();
@@ -456,6 +456,10 @@ void __init setup_arch(char **cmdline_p)
 		max_pfn = e820_end_of_ram();
 	}
 
+	find_low_pfn_range();
+
+	reserve_initrd();
+
 	dmi_scan_machine();
 
 	io_delay_init();
@@ -472,7 +476,7 @@ void __init setup_arch(char **cmdline_p)
         acpi_numa_init();
 #endif
 
-	max_low_pfn = initmem_init(0, max_pfn);
+	initmem_init(0, max_pfn);
 
 #ifdef CONFIG_ACPI_SLEEP
 	/*
Index: linux-2.6/arch/x86/kernel/setup_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_64.c
+++ linux-2.6/arch/x86/kernel/setup_64.c
@@ -154,7 +154,7 @@ static inline void copy_edd(void)
 }
 #endif
 
-void __init reserve_initrd(void)
+static void __init reserve_initrd(void)
 {
 #ifdef CONFIG_BLK_DEV_INITRD
 	if (boot_params.hdr.type_of_loader && boot_params.hdr.ramdisk_image) {
Index: linux-2.6/arch/x86/mm/discontig_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/discontig_32.c
+++ linux-2.6/arch/x86/mm/discontig_32.c
@@ -309,11 +309,10 @@ static void init_remap_allocator(int nid
 		(ulong) node_remap_end_vaddr[nid]);
 }
 
-unsigned long __init initmem_init(unsigned long start_pfn,
+void __init initmem_init(unsigned long start_pfn,
 				  unsigned long end_pfn)
 {
 	int nid;
-	unsigned long system_start_pfn, system_max_low_pfn;
 	long kva_target_pfn;
 
 	/*
@@ -324,17 +323,11 @@ unsigned long __init initmem_init(unsign
 	 * and ZONE_HIGHMEM.
 	 */
 
-	/* call find_max_low_pfn at first, it could update max_pfn */
-	system_max_low_pfn = max_low_pfn = find_max_low_pfn();
-
 	remove_all_active_ranges();
 	get_memcfg_numa();
 
 	kva_pages = round_up(calculate_numa_remap_pages(), PTRS_PER_PTE);
 
-	/* partially used pages are not usable - thus round upwards */
-	system_start_pfn = min_low_pfn = PFN_UP(init_pg_tables_end);
-
 	kva_target_pfn = round_down(max_low_pfn - kva_pages, PTRS_PER_PTE);
 	do {
 		kva_start_pfn = find_e820_area(kva_target_pfn<<PAGE_SHIFT,
@@ -357,19 +350,19 @@ unsigned long __init initmem_init(unsign
 		     "KVA PG");
 #ifdef CONFIG_HIGHMEM
 	highstart_pfn = highend_pfn = max_pfn;
-	if (max_pfn > system_max_low_pfn)
-		highstart_pfn = system_max_low_pfn;
+	if (max_pfn > max_low_pfn)
+		highstart_pfn = max_low_pfn;
 	printk(KERN_NOTICE "%ldMB HIGHMEM available.\n",
 	       pages_to_mb(highend_pfn - highstart_pfn));
 	num_physpages = highend_pfn;
 	high_memory = (void *) __va(highstart_pfn * PAGE_SIZE - 1) + 1;
 #else
-	num_physpages = system_max_low_pfn;
-	high_memory = (void *) __va(system_max_low_pfn * PAGE_SIZE - 1) + 1;
+	num_physpages = max_low_pfn;
+	high_memory = (void *) __va(max_low_pfn * PAGE_SIZE - 1) + 1;
 #endif
 	printk(KERN_NOTICE "%ldMB LOWMEM available.\n",
-			pages_to_mb(system_max_low_pfn));
-	printk("min_low_pfn = %ld, max_low_pfn = %ld, highstart_pfn = %ld\n", 
+			pages_to_mb(max_low_pfn));
+	printk("min_low_pfn = %ld, max_low_pfn = %ld, highstart_pfn = %ld\n",
 			min_low_pfn, max_low_pfn, highstart_pfn);
 
 	printk("Low memory ends at vaddr %08lx\n",
@@ -387,7 +380,6 @@ unsigned long __init initmem_init(unsign
 	memset(NODE_DATA(0), 0, sizeof(struct pglist_data));
 	NODE_DATA(0)->bdata = &node0_bdata;
 	setup_bootmem_allocator();
-	return max_low_pfn;
 }
 
 void __init zone_sizes_init(void)
Index: linux-2.6/arch/x86/mm/init_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_32.c
+++ linux-2.6/arch/x86/mm/init_32.c
@@ -561,9 +561,15 @@ early_param("highmem", parse_highmem);
 /*
  * Determine low and high memory ranges:
  */
-unsigned long __init find_max_low_pfn(void)
+void __init find_low_pfn_range(void)
 {
-	unsigned long max_low_pfn;
+	/* it could update max_pfn */
+
+	/*
+	 * partially used pages are not usable - thus
+	 * we are rounding upwards:
+	 */
+	min_low_pfn = PFN_UP(init_pg_tables_end);
 
 	max_low_pfn = max_pfn;
 	if (max_low_pfn > MAXMEM_PFN) {
@@ -625,21 +631,12 @@ unsigned long __init find_max_low_pfn(vo
 					" kernel!\n");
 #endif
 	}
-	return max_low_pfn;
 }
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES
-unsigned long __init initmem_init(unsigned long start_pfn,
+void __init initmem_init(unsigned long start_pfn,
 				  unsigned long end_pfn)
 {
-	/*
-	 * partially used pages are not usable - thus
-	 * we are rounding upwards:
-	 */
-	min_low_pfn = PFN_UP(init_pg_tables_end);
-
-	max_low_pfn = find_max_low_pfn();
-
 #ifdef CONFIG_HIGHMEM
 	highstart_pfn = highend_pfn = max_pfn;
 	if (max_pfn > max_low_pfn)
@@ -661,8 +658,6 @@ unsigned long __init initmem_init(unsign
 			pages_to_mb(max_low_pfn));
 
 	setup_bootmem_allocator();
-
-	return max_low_pfn;
 }
 
 void __init zone_sizes_init(void)
@@ -699,8 +694,6 @@ void __init setup_bootmem_allocator(void
 		panic("Cannot find bootmem map of size %ld\n", bootmap_size);
 	reserve_early(bootmap, bootmap + bootmap_size, "BOOTMAP");
 
-	reserve_initrd();
-
 	bootmap_size = init_bootmem(bootmap >> PAGE_SHIFT, max_low_pfn);
 	printk(KERN_INFO "  mapped low ram: 0 - %08lx\n",
 		 max_pfn_mapped<<PAGE_SHIFT);
Index: linux-2.6/include/asm-x86/page_32.h
===================================================================
--- linux-2.6.orig/include/asm-x86/page_32.h
+++ linux-2.6/include/asm-x86/page_32.h
@@ -97,7 +97,8 @@ extern int sysctl_legacy_va_layout;
 #define VMALLOC_RESERVE		((unsigned long)__VMALLOC_RESERVE)
 #define MAXMEM			(-__PAGE_OFFSET - __VMALLOC_RESERVE)
 
-extern unsigned long initmem_init(unsigned long, unsigned long);
+extern void find_low_pfn_range(void);
+extern void initmem_init(unsigned long, unsigned long);
 extern void zone_sizes_init(void);
 extern void setup_bootmem_allocator(void);
 
Index: linux-2.6/include/asm-x86/setup.h
===================================================================
--- linux-2.6.orig/include/asm-x86/setup.h
+++ linux-2.6/include/asm-x86/setup.h
@@ -39,8 +39,6 @@ void reserve_crashkernel(void);
 #include <asm/bootparam.h>
 
 void reserve_standard_io_resources(void);
-void reserve_initrd(void);
-
 
 #ifndef _SETUP
 
