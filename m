Return-Path: <linux-kernel-owner+w=401wt.eu-S934514AbZKYI7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934514AbZKYI7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 03:59:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbZKYI7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 03:59:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:48744 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbZKYI7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 03:59:51 -0500
Message-ID: <4B0CF1B3.1050200@kernel.org>
Date: Wed, 25 Nov 2009 00:58:27 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: seperate reserve_early and reserve_early_overlap_check
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


when the area is from find_e820_area(), it could be overlapped with others.

so just add it directly. the new reserve_early()

and rename old reserve_early() to reserve_early_overlap_check()

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/e820.h  |    3 ++-
 arch/x86/kernel/e820.c       |   26 +++++++++++++++++++++++++-
 arch/x86/kernel/efi.c        |    4 ++--
 arch/x86/kernel/head32.c     |    6 ++++--
 arch/x86/kernel/head64.c     |    6 ++++--
 arch/x86/kernel/mpparse.c    |    6 ++++--
 arch/x86/kernel/setup.c      |    6 ++++--
 arch/x86/kernel/trampoline.c |    7 ++++---
 arch/x86/xen/mmu.c           |    4 ++--
 arch/x86/xen/setup.c         |    2 +-
 10 files changed, 52 insertions(+), 18 deletions(-)

Index: linux-2.6/arch/x86/include/asm/e820.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/e820.h
+++ linux-2.6/arch/x86/include/asm/e820.h
@@ -111,7 +111,8 @@ extern unsigned long end_user_pfn;
 
 extern u64 find_e820_area(u64 start, u64 end, u64 size, u64 align);
 extern u64 find_e820_area_size(u64 start, u64 *sizep, u64 align);
-extern void reserve_early(u64 start, u64 end, char *name);
+void reserve_early(u64 start, u64 end, char *name);
+void reserve_early_overlap_check(u64 start, u64 end, char *name);
 extern void reserve_early_overlap_ok(u64 start, u64 end, char *name);
 extern void free_early(u64 start, u64 end);
 extern void early_res_to_bootmem(u64 start, u64 end);
Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -835,6 +835,30 @@ static void __init drop_overlaps_that_ar
 	}
 }
 
+void __init reserve_early(u64 start, u64 end, char *name)
+{
+	int i;
+	struct early_res *r;
+
+	if (start >= end)
+		return;
+
+	for (i = 0; i < MAX_EARLY_RES; i++) {
+		r = &early_res[i];
+		if (!r->end) {
+			r->start = start;
+			r->end = end;
+			if (name)
+				strncpy(r->name, name, sizeof(r->name) - 1);
+			r->overlap_ok = 0;
+
+			return;
+		}
+	}
+
+	panic("Too many early reservations");
+}
+
 static void __init __reserve_early(u64 start, u64 end, char *name,
 						int overlap_ok)
 {
@@ -891,7 +915,7 @@ void __init reserve_early_overlap_ok(u64
  * range without risk of panic'ing on an overlapping overlap_ok
  * early reservation.
  */
-void __init reserve_early(u64 start, u64 end, char *name)
+void __init reserve_early_overlap_check(u64 start, u64 end, char *name)
 {
 	if (start >= end)
 		return;
Index: linux-2.6/arch/x86/kernel/efi.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/efi.c
+++ linux-2.6/arch/x86/kernel/efi.c
@@ -290,8 +290,8 @@ void __init efi_reserve_early(void)
 		boot_params.efi_info.efi_memdesc_size;
 	memmap.desc_version = boot_params.efi_info.efi_memdesc_version;
 	memmap.desc_size = boot_params.efi_info.efi_memdesc_size;
-	reserve_early(pmap, pmap + memmap.nr_map * memmap.desc_size,
-		      "EFI memmap");
+	reserve_early_overlap_check(pmap,
+			 pmap + memmap.nr_map * memmap.desc_size, "EFI memmap");
 }
 
 #if EFI_DEBUG
Index: linux-2.6/arch/x86/kernel/head32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/head32.c
+++ linux-2.6/arch/x86/kernel/head32.c
@@ -31,7 +31,8 @@ void __init i386_start_kernel(void)
 {
 	reserve_trampoline_memory();
 
-	reserve_early(__pa_symbol(&_text), __pa_symbol(&__bss_stop), "TEXT DATA BSS");
+	reserve_early_overlap_check(__pa_symbol(&_text),
+				 __pa_symbol(&__bss_stop), "TEXT DATA BSS");
 
 #ifdef CONFIG_BLK_DEV_INITRD
 	/* Reserve INITRD */
@@ -39,7 +40,8 @@ void __init i386_start_kernel(void)
 		u64 ramdisk_image = boot_params.hdr.ramdisk_image;
 		u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
 		u64 ramdisk_end   = ramdisk_image + ramdisk_size;
-		reserve_early(ramdisk_image, ramdisk_end, "RAMDISK");
+		reserve_early_overlap_check(ramdisk_image, ramdisk_end,
+						 "RAMDISK");
 	}
 #endif
 
Index: linux-2.6/arch/x86/kernel/head64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/head64.c
+++ linux-2.6/arch/x86/kernel/head64.c
@@ -100,7 +100,8 @@ void __init x86_64_start_reservations(ch
 
 	reserve_trampoline_memory();
 
-	reserve_early(__pa_symbol(&_text), __pa_symbol(&__bss_stop), "TEXT DATA BSS");
+	reserve_early_overlap_check(__pa_symbol(&_text),
+				 __pa_symbol(&__bss_stop), "TEXT DATA BSS");
 
 #ifdef CONFIG_BLK_DEV_INITRD
 	/* Reserve INITRD */
@@ -108,7 +109,8 @@ void __init x86_64_start_reservations(ch
 		unsigned long ramdisk_image = boot_params.hdr.ramdisk_image;
 		unsigned long ramdisk_size  = boot_params.hdr.ramdisk_size;
 		unsigned long ramdisk_end   = ramdisk_image + ramdisk_size;
-		reserve_early(ramdisk_image, ramdisk_end, "RAMDISK");
+		reserve_early_overlap_check(ramdisk_image, ramdisk_end,
+						 "RAMDISK");
 	}
 #endif
 
Index: linux-2.6/arch/x86/kernel/mpparse.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/mpparse.c
+++ linux-2.6/arch/x86/kernel/mpparse.c
@@ -671,7 +671,8 @@ static void __init smp_reserve_memory(st
 {
 	unsigned long size = get_mpc_size(mpf->physptr);
 
-	reserve_early(mpf->physptr, mpf->physptr+size, "MP-table mpc");
+	reserve_early_overlap_check(mpf->physptr, mpf->physptr+size,
+					 "MP-table mpc");
 }
 
 static int __init smp_scan_config(unsigned long base, unsigned long length)
@@ -700,7 +701,8 @@ static int __init smp_scan_config(unsign
 			       mpf, (u64)virt_to_phys(mpf));
 
 			mem = virt_to_phys(mpf);
-			reserve_early(mem, mem + sizeof(*mpf), "MP-table mpf");
+			reserve_early_overlap_check(mem, mem + sizeof(*mpf),
+							 "MP-table mpf");
 			if (mpf->physptr)
 				smp_reserve_memory(mpf);
 
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -299,7 +299,8 @@ static inline void init_gbpages(void)
 static void __init reserve_brk(void)
 {
 	if (_brk_end > _brk_start)
-		reserve_early(__pa(_brk_start), __pa(_brk_end), "BRK");
+		reserve_early_overlap_check(__pa(_brk_start), __pa(_brk_end),
+						 "BRK");
 
 	/* Mark brk area as locked down and no longer taking any
 	   new allocations */
@@ -476,7 +477,8 @@ static void __init reserve_early_setup_d
 	while (pa_data) {
 		data = early_memremap(pa_data, sizeof(*data));
 		sprintf(buf, "setup data %x", data->type);
-		reserve_early(pa_data, pa_data+sizeof(*data)+data->len, buf);
+		reserve_early_overlap_check(pa_data,
+					 pa_data+sizeof(*data)+data->len, buf);
 		pa_data = data->next;
 		early_iounmap(data, sizeof(*data));
 	}
Index: linux-2.6/arch/x86/kernel/trampoline.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/trampoline.c
+++ linux-2.6/arch/x86/kernel/trampoline.c
@@ -22,11 +22,12 @@ void __init reserve_trampoline_memory(vo
 	 * FIXME: Don't need the extra page at 4K, but need to fix
 	 * trampoline before removing it. (see the GDT stuff)
 	 */
-	reserve_early(PAGE_SIZE, PAGE_SIZE + PAGE_SIZE, "EX TRAMPOLINE");
+	reserve_early_overlap_check(PAGE_SIZE, PAGE_SIZE + PAGE_SIZE,
+					 "EX TRAMPOLINE");
 #endif
 	/* Has to be in very low memory so we can execute real-mode AP code. */
-	reserve_early(TRAMPOLINE_BASE, TRAMPOLINE_BASE + TRAMPOLINE_SIZE,
-			"TRAMPOLINE");
+	reserve_early_overlap_check(TRAMPOLINE_BASE,
+			 TRAMPOLINE_BASE + TRAMPOLINE_SIZE, "TRAMPOLINE");
 }
 
 /*
Index: linux-2.6/arch/x86/xen/mmu.c
===================================================================
--- linux-2.6.orig/arch/x86/xen/mmu.c
+++ linux-2.6/arch/x86/xen/mmu.c
@@ -1751,7 +1751,7 @@ __init pgd_t *xen_setup_kernel_pagetable
 	__xen_write_cr3(true, __pa(pgd));
 	xen_mc_issue(PARAVIRT_LAZY_CPU);
 
-	reserve_early(__pa(xen_start_info->pt_base),
+	reserve_early_overlap_check(__pa(xen_start_info->pt_base),
 		      __pa(xen_start_info->pt_base +
 			   xen_start_info->nr_pt_frames * PAGE_SIZE),
 		      "XEN PAGETABLES");
@@ -1789,7 +1789,7 @@ __init pgd_t *xen_setup_kernel_pagetable
 
 	pin_pagetable_pfn(MMUEXT_PIN_L3_TABLE, PFN_DOWN(__pa(swapper_pg_dir)));
 
-	reserve_early(__pa(xen_start_info->pt_base),
+	reserve_early_overlap_check(__pa(xen_start_info->pt_base),
 		      __pa(xen_start_info->pt_base +
 			   xen_start_info->nr_pt_frames * PAGE_SIZE),
 		      "XEN PAGETABLES");
Index: linux-2.6/arch/x86/xen/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/xen/setup.c
+++ linux-2.6/arch/x86/xen/setup.c
@@ -61,7 +61,7 @@ char * __init xen_memory_setup(void)
 	 *  - xen_start_info
 	 * See comment above "struct start_info" in <xen/interface/xen.h>
 	 */
-	reserve_early(__pa(xen_start_info->mfn_list),
+	reserve_early_overlap_check(__pa(xen_start_info->mfn_list),
 		      __pa(xen_start_info->pt_base),
 			"XEN START INFO");
 
