Return-Path: <linux-kernel-owner+w=401wt.eu-S1756766AbYFPB6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766AbYFPB6U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 21:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751438AbYFPB6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 21:58:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:33394 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbYFPB6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 21:58:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id;
        b=tZIJ/xoypj5ZqPHRECzFCtbaPoNxLbI6QHCimeVX2m9QmAKXY0601L/hwNotK8EnVX
         pg5+Kvn0N7VaXiHLJzvO8cpB953RMNqgVzj/ejDllaLS0bl6XbRhM+W4a7dR/jx5SBH+
         iXVnhHEXg4EdbXIA0peRzRXsfEUzKpyeTfdyY=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: rename two e820 related functions
Date: Sun, 15 Jun 2008 18:58:51 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806151858.51200.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


rename update_memory_range to e820_update_range
rename add_memory_region to e820_add_region

to make them more clear about e820 map opertation

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/aperture_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/aperture_64.c
+++ linux-2.6/arch/x86/kernel/aperture_64.c
@@ -328,7 +328,7 @@ void __init early_gart_iommu_check(void)
 				    E820_RESERVED)) {
 			/* reserve it, so we can reuse it in second kernel */
 			printk(KERN_INFO "update e820 for GART\n");
-			add_memory_region(aper_base, aper_size, E820_RESERVED);
+			e820_add_region(aper_base, aper_size, E820_RESERVED);
 			update_e820();
 		}
 	}
Index: linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
@@ -1440,7 +1440,7 @@ static u64 __init real_trim_memory(unsig
 	trim_size <<= PAGE_SHIFT;
 	trim_size -= trim_start;
 
-	return update_memory_range(trim_start, trim_size, E820_RAM,
+	return e820_update_range(trim_start, trim_size, E820_RAM,
 				E820_RESERVED);
 }
 /**
Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -94,7 +94,7 @@ int __init e820_all_mapped(u64 start, u6
 /*
  * Add a memory region to the kernel e820 map.
  */
-void __init add_memory_region(u64 start, u64 size, int type)
+void __init e820_add_region(u64 start, u64 size, int type)
 {
 	int x = e820.nr_map;
 
@@ -384,12 +384,12 @@ int __init copy_e820_map(struct e820entr
 		if (start > end)
 			return -1;
 
-		add_memory_region(start, size, type);
+		e820_add_region(start, size, type);
 	} while (biosmap++, --nr_map);
 	return 0;
 }
 
-u64 __init update_memory_range(u64 start, u64 size, unsigned old_type,
+u64 __init e820_update_range(u64 start, u64 size, unsigned old_type,
 				unsigned new_type)
 {
 	int i;
@@ -414,7 +414,7 @@ u64 __init update_memory_range(u64 start
 		final_end = min(start + size, ei->addr + ei->size);
 		if (final_start >= final_end)
 			continue;
-		add_memory_region(final_start, final_end - final_start,
+		e820_add_region(final_start, final_end - final_start,
 					 new_type);
 		real_updated_size += final_end - final_start;
 	}
@@ -763,7 +763,7 @@ u64 __init early_reserve_e820(u64 startt
 		return 0;
 
 	addr = round_down(start + size - sizet, align);
-	update_memory_range(addr, sizet, E820_RAM, E820_RESERVED);
+	e820_update_range(addr, sizet, E820_RAM, E820_RESERVED);
 	printk(KERN_INFO "update e820 for early_reserve_e820\n");
 	update_e820();
 
@@ -938,13 +938,13 @@ static int __init parse_memmap_opt(char 
 	userdef = 1;
 	if (*p == '@') {
 		start_at = memparse(p+1, &p);
-		add_memory_region(start_at, mem_size, E820_RAM);
+		e820_add_region(start_at, mem_size, E820_RAM);
 	} else if (*p == '#') {
 		start_at = memparse(p+1, &p);
-		add_memory_region(start_at, mem_size, E820_ACPI);
+		e820_add_region(start_at, mem_size, E820_ACPI);
 	} else if (*p == '$') {
 		start_at = memparse(p+1, &p);
-		add_memory_region(start_at, mem_size, E820_RESERVED);
+		e820_add_region(start_at, mem_size, E820_RESERVED);
 	} else {
 		end_user_pfn = (mem_size >> PAGE_SHIFT);
 	}
Index: linux-2.6/arch/x86/kernel/efi.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/efi.c
+++ linux-2.6/arch/x86/kernel/efi.c
@@ -233,7 +233,7 @@ static void __init add_efi_memmap(void)
 			e820_type = E820_RAM;
 		else
 			e820_type = E820_RESERVED;
-		add_memory_region(start, size, e820_type);
+		e820_add_region(start, size, e820_type);
 	}
 	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
 }
Index: linux-2.6/arch/x86/lguest/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/lguest/boot.c
+++ linux-2.6/arch/x86/lguest/boot.c
@@ -835,7 +835,7 @@ static __init char *lguest_memory_setup(
 
 	/* The Linux bootloader header contains an "e820" memory map: the
 	 * Launcher populated the first entry with our memory limit. */
-	add_memory_region(boot_params.e820_map[0].addr,
+	e820_add_region(boot_params.e820_map[0].addr,
 			  boot_params.e820_map[0].size,
 			  boot_params.e820_map[0].type);
 
Index: linux-2.6/arch/x86/mach-default/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/mach-default/setup.c
+++ linux-2.6/arch/x86/mach-default/setup.c
@@ -184,8 +184,8 @@ char * __init machine_specific_memory_se
 		}
 
 		e820.nr_map = 0;
-		add_memory_region(0, LOWMEMSIZE(), E820_RAM);
-		add_memory_region(HIGH_MEMORY, mem_size << 10, E820_RAM);
+		e820_add_region(0, LOWMEMSIZE(), E820_RAM);
+		e820_add_region(HIGH_MEMORY, mem_size << 10, E820_RAM);
   	}
 	return who;
 }
Index: linux-2.6/arch/x86/mach-visws/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/mach-visws/setup.c
+++ linux-2.6/arch/x86/mach-visws/setup.c
@@ -175,9 +175,9 @@ char * __init machine_specific_memory_se
 	sgivwfb_mem_size &= ~((1 << 20) - 1);
 	sgivwfb_mem_phys = mem_size - gfx_mem_size;
 
-	add_memory_region(0, LOWMEMSIZE(), E820_RAM);
-	add_memory_region(HIGH_MEMORY, mem_size - sgivwfb_mem_size - HIGH_MEMORY, E820_RAM);
-	add_memory_region(sgivwfb_mem_phys, sgivwfb_mem_size, E820_RESERVED);
+	e820_add_region(0, LOWMEMSIZE(), E820_RAM);
+	e820_add_region(HIGH_MEMORY, mem_size - sgivwfb_mem_size - HIGH_MEMORY, E820_RAM);
+	e820_add_region(sgivwfb_mem_phys, sgivwfb_mem_size, E820_RESERVED);
 
 	return "PROM";
 }
Index: linux-2.6/arch/x86/mach-voyager/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/mach-voyager/setup.c
+++ linux-2.6/arch/x86/mach-voyager/setup.c
@@ -74,7 +74,7 @@ char *__init machine_specific_memory_set
 
 		e820.nr_map = 0;
 		for (i = 0; voyager_memory_detect(i, &addr, &length); i++) {
-			add_memory_region(addr, length, E820_RAM);
+			e820_add_region(addr, length, E820_RAM);
 		}
 		return who;
 	} else if (voyager_level == 4) {
@@ -92,14 +92,14 @@ char *__init machine_specific_memory_set
 			tom = (boot_params.screen_info.ext_mem_k) << 10;
 		}
 		who = "Voyager-TOM";
-		add_memory_region(0, 0x9f000, E820_RAM);
+		e820_add_region(0, 0x9f000, E820_RAM);
 		/* map from 1M to top of memory */
-		add_memory_region(1 * 1024 * 1024, tom - 1 * 1024 * 1024,
+		e820_add_region(1 * 1024 * 1024, tom - 1 * 1024 * 1024,
 				  E820_RAM);
 		/* FIXME: Should check the ASICs to see if I need to
 		 * take out the 8M window.  Just do it at the moment
 		 * */
-		add_memory_region(8 * 1024 * 1024, 8 * 1024 * 1024,
+		e820_add_region(8 * 1024 * 1024, 8 * 1024 * 1024,
 				  E820_RESERVED);
 		return who;
 	}
@@ -131,8 +131,8 @@ char *__init machine_specific_memory_set
 		}
 
 		e820.nr_map = 0;
-		add_memory_region(0, LOWMEMSIZE(), E820_RAM);
-		add_memory_region(HIGH_MEMORY, mem_size << 10, E820_RAM);
+		e820_add_region(0, LOWMEMSIZE(), E820_RAM);
+		e820_add_region(HIGH_MEMORY, mem_size << 10, E820_RAM);
 	}
 	return who;
 }
Index: linux-2.6/arch/x86/xen/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/xen/setup.c
+++ linux-2.6/arch/x86/xen/setup.c
@@ -40,8 +40,8 @@ char * __init xen_memory_setup(void)
 	max_pfn = min(MAX_DOMAIN_PAGES, max_pfn);
 
 	e820.nr_map = 0;
-	add_memory_region(0, LOWMEMSIZE(), E820_RAM);
-	add_memory_region(HIGH_MEMORY, PFN_PHYS(max_pfn)-HIGH_MEMORY, E820_RAM);
+	e820_add_region(0, LOWMEMSIZE(), E820_RAM);
+	e820_add_region(HIGH_MEMORY, PFN_PHYS(max_pfn)-HIGH_MEMORY, E820_RAM);
 
 	return "Xen";
 }
Index: linux-2.6/include/asm-x86/e820.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820.h
+++ linux-2.6/include/asm-x86/e820.h
@@ -60,12 +60,12 @@ extern struct e820map e820;
 
 extern int e820_any_mapped(u64 start, u64 end, unsigned type);
 extern int e820_all_mapped(u64 start, u64 end, unsigned type);
-extern void add_memory_region(u64 start, u64 size, int type);
+extern void e820_add_region(u64 start, u64 size, int type);
 extern void e820_print_map(char *who);
 extern int
 sanitize_e820_map(struct e820entry *biosmap, int max_nr_map, int *pnr_map);
 extern int copy_e820_map(struct e820entry *biosmap, int nr_map);
-extern u64 update_memory_range(u64 start, u64 size, unsigned old_type,
+extern u64 e820_update_range(u64 start, u64 size, unsigned old_type,
 			       unsigned new_type);
 extern void update_e820(void);
 extern void e820_setup_gap(void);
