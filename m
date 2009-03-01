Return-Path: <linux-kernel-owner+w=401wt.eu-S1755978AbZCABYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbZCABYo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 20:24:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949AbZCABYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 20:24:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:46885 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786AbZCABYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 20:24:35 -0500
Message-ID: <49A9E392.6090004@kernel.org>
Date: Sat, 28 Feb 2009 17:23:30 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH] x86: put initial_pg_tables into bss
References: <1235785882-17580-1-git-send-email-jeremy@goop.org> <1235785882-17580-4-git-send-email-jeremy@goop.org> <86802c440902272302n3787b2bex3741b46a372a19b0@mail.gmail.com> <49A8E235.6010900@goop.org> <20090228071534.GB9351@elte.hu> <49A8EA1A.50802@kernel.org> <49A8ED3D.1060704@kernel.org> <49A8F319.3030802@goop.org>
In-Reply-To: <49A8F319.3030802@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Impact: cleanup

Don't use ram after _end blindly for pagetables.
put those pg table into bss

also remove init_pg_tables_start/end tricks all around

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/setup.h     |    3 ---
 arch/x86/kernel/head32.c         |    3 ---
 arch/x86/kernel/head_32.S        |   25 +++++++++++--------------
 arch/x86/kernel/setup.c          |    9 ---------
 arch/x86/kernel/vmlinux_32.lds.S |    3 ---
 arch/x86/lguest/boot.c           |    8 --------
 arch/x86/xen/mmu.c               |    4 +---
 7 files changed, 12 insertions(+), 43 deletions(-)

Index: linux-2.6/arch/x86/include/asm/setup.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/setup.h
+++ linux-2.6/arch/x86/include/asm/setup.h
@@ -105,9 +105,6 @@ extern struct boot_params boot_params;
 void __init i386_start_kernel(void);
 extern void probe_roms(void);
 
-extern unsigned long init_pg_tables_start;
-extern unsigned long init_pg_tables_end;
-
 #else
 void __init x86_64_start_kernel(char *real_mode);
 void __init x86_64_start_reservations(char *real_mode_data);
Index: linux-2.6/arch/x86/kernel/head32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/head32.c
+++ linux-2.6/arch/x86/kernel/head32.c
@@ -29,9 +29,6 @@ void __init i386_start_kernel(void)
 		reserve_early(ramdisk_image, ramdisk_end, "RAMDISK");
 	}
 #endif
-	reserve_early(init_pg_tables_start, init_pg_tables_end,
-			"INIT_PG_TABLE");
-
 	reserve_ebda_region();
 
 	/*
Index: linux-2.6/arch/x86/kernel/head_32.S
===================================================================
--- linux-2.6.orig/arch/x86/kernel/head_32.S
+++ linux-2.6/arch/x86/kernel/head_32.S
@@ -73,7 +73,7 @@ PAGE_TABLE_SIZE = (LOW_PAGES / PTRS_PER_
 BOOTBITMAP_SIZE = LOW_PAGES / 8
 ALLOCATOR_SLOP = 4
 
-INIT_MAP_BEYOND_END = BOOTBITMAP_SIZE + (PAGE_TABLE_SIZE + ALLOCATOR_SLOP)*PAGE_SIZE_asm
+INIT_MAP_SIZE = BOOTBITMAP_SIZE + (PAGE_TABLE_SIZE + ALLOCATOR_SLOP)*PAGE_SIZE_asm
 
 /*
  * 32-bit kernel entrypoint; only used by the boot CPU.  On entry,
@@ -166,10 +166,9 @@ num_subarch_entries = (. - subarch_entri
 
 /*
  * Initialize page tables.  This creates a PDE and a set of page
- * tables, which are located immediately beyond _end.  The variable
- * init_pg_tables_end is set up to point to the first "safe" location.
+ * tables, which are located immediately beyond _end. 
  * Mappings are created both at virtual address 0 (identity mapping)
- * and PAGE_OFFSET for up to _end+sizeof(page tables)+INIT_MAP_BEYOND_END.
+ * and PAGE_OFFSET for up to _end
  *
  * Note that the stack is not yet set up!
  */
@@ -191,7 +190,6 @@ default_entry:
 	xorl %ebx,%ebx				/* %ebx is kept at zero */
 
 	movl $pa(pg0), %edi
-	movl %edi, pa(init_pg_tables_start)
 	movl $pa(swapper_pg_pmd), %edx
 	movl $PTE_IDENT_ATTR, %eax
 10:
@@ -209,14 +207,13 @@ default_entry:
 	loop 11b
 
 	/*
-	 * End condition: we must map up to and including INIT_MAP_BEYOND_END
-	 * bytes beyond the end of our own page tables.
+	 * End condition: we must map up to the end.
 	 */
-	leal (INIT_MAP_BEYOND_END+PTE_IDENT_ATTR)(%edi),%ebp
+	movl $pa(_end), %ebp
+	addl PTE_IDENT_ATTR, %ebp
 	cmpl %ebp,%eax
 	jb 10b
 1:
-	movl %edi,pa(init_pg_tables_end)
 	shrl $12, %eax
 	movl %eax, pa(max_pfn_mapped)
 
@@ -228,7 +225,6 @@ default_entry:
 page_pde_offset = (__PAGE_OFFSET >> 20);
 
 	movl $pa(pg0), %edi
-	movl %edi, pa(init_pg_tables_start)
 	movl $pa(swapper_pg_dir), %edx
 	movl $PTE_IDENT_ATTR, %eax
 10:
@@ -242,14 +238,13 @@ page_pde_offset = (__PAGE_OFFSET >> 20);
 	addl $0x1000,%eax
 	loop 11b
 	/*
-	 * End condition: we must map up to and including INIT_MAP_BEYOND_END
-	 * bytes beyond the end of our own page tables; the +0x007 is
+	 * End condition: we must map up to end, the +0x007 is
 	 * the attribute bits
 	 */
-	leal (INIT_MAP_BEYOND_END+PTE_IDENT_ATTR)(%edi),%ebp
+	movl $pa(_end), %ebp
+	addl PTE_IDENT_ATTR, %ebp
 	cmpl %ebp,%eax
 	jb 10b
-	movl %edi,pa(init_pg_tables_end)
 	shrl $12, %eax
 	movl %eax, pa(max_pfn_mapped)
 
@@ -662,6 +657,8 @@ ENTRY(swapper_pg_dir)
 # endif
 	.align PAGE_SIZE_asm		/* needs to be page-sized too */
 #endif
+ENTRY(pg0)
+	.fill INIT_MAP_SIZE,1,0
 
 .data
 ENTRY(stack_start)
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -158,11 +158,6 @@ static struct resource bss_resource = {
 
 
 #ifdef CONFIG_X86_32
-/* This value is set up by the early boot code to point to the value
-   immediately after the boot time page tables.  It contains a *physical*
-   address, and must not be in the .bss segment! */
-unsigned long init_pg_tables_start __initdata = ~0UL;
-unsigned long init_pg_tables_end __initdata = ~0UL;
 
 static struct resource video_ram_resource = {
 	.name	= "Video RAM area",
@@ -715,11 +710,7 @@ void __init setup_arch(char **cmdline_p)
 	init_mm.start_code = (unsigned long) _text;
 	init_mm.end_code = (unsigned long) _etext;
 	init_mm.end_data = (unsigned long) _edata;
-#ifdef CONFIG_X86_32
-	init_mm.brk = init_pg_tables_end + PAGE_OFFSET;
-#else
 	init_mm.brk = (unsigned long) &_end;
-#endif
 
 	code_resource.start = virt_to_phys(_text);
 	code_resource.end = virt_to_phys(_etext)-1;
Index: linux-2.6/arch/x86/kernel/vmlinux_32.lds.S
===================================================================
--- linux-2.6.orig/arch/x86/kernel/vmlinux_32.lds.S
+++ linux-2.6/arch/x86/kernel/vmlinux_32.lds.S
@@ -190,9 +190,6 @@ SECTIONS
 	. = ALIGN(4);
 	__bss_stop = .;
   	_end = . ;
-	/* This is where the kernel creates the early boot page tables */
-	. = ALIGN(PAGE_SIZE);
-	pg0 = . ;
   }
 
   /* Sections to be discarded */
Index: linux-2.6/arch/x86/lguest/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/lguest/boot.c
+++ linux-2.6/arch/x86/lguest/boot.c
@@ -1051,14 +1051,6 @@ __init void lguest_init(void)
 	 * lguest_init() where the rest of the fairly chaotic boot setup
 	 * occurs. */
 
-	/* The native boot code sets up initial page tables immediately after
-	 * the kernel itself, and sets init_pg_tables_end so they're not
-	 * clobbered.  The Launcher places our initial pagetables somewhere at
-	 * the top of our physical memory, so we don't need extra space: set
-	 * init_pg_tables_end to the end of the kernel. */
-	init_pg_tables_start = __pa(pg0);
-	init_pg_tables_end = __pa(pg0);
-
 	/* As described in head_32.S, we map the first 128M of memory. */
 	max_pfn_mapped = (128*1024*1024) >> PAGE_SHIFT;
 
Index: linux-2.6/arch/x86/xen/mmu.c
===================================================================
--- linux-2.6.orig/arch/x86/xen/mmu.c
+++ linux-2.6/arch/x86/xen/mmu.c
@@ -1716,9 +1716,7 @@ __init pgd_t *xen_setup_kernel_pagetable
 {
 	pmd_t *kernel_pmd;
 
-	init_pg_tables_start = __pa(pgd);
-	init_pg_tables_end = __pa(pgd) + xen_start_info->nr_pt_frames*PAGE_SIZE;
-	max_pfn_mapped = PFN_DOWN(init_pg_tables_end + 512*1024);
+	max_pfn_mapped = PFN_DOWN(__pa(pgd) + xen_start_info->nr_pt_frames*PAGE_SIZE + 512*1024);
 
 	kernel_pmd = m2v(pgd[KERNEL_PGD_BOUNDARY].pgd);
 	memcpy(level2_kernel_pgt, kernel_pmd, sizeof(pmd_t) * PTRS_PER_PMD);
