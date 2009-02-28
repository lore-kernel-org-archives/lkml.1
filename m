Return-Path: <linux-kernel-owner+w=401wt.eu-S1763184AbZB1BzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763184AbZB1BzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 20:55:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762958AbZB1Bvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 20:51:31 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:45526
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762939AbZB1Bv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 20:51:27 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH] x86-32: use brk segment for allocating initial kernel pagetable
Date: Fri, 27 Feb 2009 17:51:20 -0800
Message-Id: <1235785882-17580-4-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1235785882-17580-1-git-send-email-jeremy@goop.org>
References: <1235785882-17580-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Rather than having special purpose init_pg_table_start/end variables
to delimit the kernel pagetable built by head_32.S, just use the brk
mechanism to extend the bss for the new pagetable.

This patch removes init_pg_table_start/end and pg0, defines __brk_base
(which is page-aligned and immediately follows _end), initializes
the brk region to start there, and uses it for the 32-bit pagetable.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/pgtable_32.h |    3 ---
 arch/x86/include/asm/setup.h      |    3 ---
 arch/x86/kernel/head32.c          |    5 -----
 arch/x86/kernel/head_32.S         |   14 +++++++-------
 arch/x86/kernel/setup.c           |   12 ++++--------
 arch/x86/kernel/vmlinux_32.lds.S  |    3 +--
 arch/x86/kernel/vmlinux_64.lds.S  |    2 ++
 arch/x86/lguest/boot.c            |    8 --------
 arch/x86/xen/mmu.c                |    8 +++++---
 9 files changed, 19 insertions(+), 39 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_32.h b/arch/x86/include/asm/pgtable_32.h
index 97612fc..31bd120 100644
--- a/arch/x86/include/asm/pgtable_32.h
+++ b/arch/x86/include/asm/pgtable_32.h
@@ -42,9 +42,6 @@ extern void set_pmd_pfn(unsigned long, unsigned long, pgprot_t);
  */
 #undef TEST_ACCESS_OK
 
-/* The boot page tables (all created as a single array) */
-extern unsigned long pg0[];
-
 #ifdef CONFIG_X86_PAE
 # include <asm/pgtable-3level.h>
 #else
diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index fd9b420..2ca00a9 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -110,9 +110,6 @@ void *extend_brk(size_t size, size_t align);
 void __init i386_start_kernel(void);
 extern void probe_roms(void);
 
-extern unsigned long init_pg_tables_start;
-extern unsigned long init_pg_tables_end;
-
 #else
 void __init x86_64_start_kernel(char *real_mode);
 void __init x86_64_start_reservations(char *real_mode_data);
diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index fa9ae31..b6caa9e 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -29,13 +29,8 @@ void __init i386_start_kernel(void)
 		reserve_early(ramdisk_image, ramdisk_end, "RAMDISK");
 	}
 #endif
-	reserve_early(init_pg_tables_start, init_pg_tables_end,
-			"INIT_PG_TABLE");
-
 	reserve_ebda_region();
 
-	init_brk((unsigned long)__va(init_pg_tables_end));
-
 	/*
 	 * At this point everything still needed from the boot loader
 	 * or BIOS or kernel text should be early reserved or marked not
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 6219259..d243437 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -167,7 +167,7 @@ num_subarch_entries = (. - subarch_entries) / 4
 /*
  * Initialize page tables.  This creates a PDE and a set of page
  * tables, which are located immediately beyond _end.  The variable
- * init_pg_tables_end is set up to point to the first "safe" location.
+ * _brk_end is set up to point to the first "safe" location.
  * Mappings are created both at virtual address 0 (identity mapping)
  * and PAGE_OFFSET for up to _end+sizeof(page tables)+INIT_MAP_BEYOND_END.
  *
@@ -190,8 +190,7 @@ default_entry:
 
 	xorl %ebx,%ebx				/* %ebx is kept at zero */
 
-	movl $pa(pg0), %edi
-	movl %edi, pa(init_pg_tables_start)
+	movl $pa(__brk_base), %edi
 	movl $pa(swapper_pg_pmd), %edx
 	movl $PTE_IDENT_ATTR, %eax
 10:
@@ -216,7 +215,8 @@ default_entry:
 	cmpl %ebp,%eax
 	jb 10b
 1:
-	movl %edi,pa(init_pg_tables_end)
+	addl $__PAGE_OFFSET, %edi
+	movl %edi, pa(_brk_end)
 	shrl $12, %eax
 	movl %eax, pa(max_pfn_mapped)
 
@@ -227,8 +227,7 @@ default_entry:
 
 page_pde_offset = (__PAGE_OFFSET >> 20);
 
-	movl $pa(pg0), %edi
-	movl %edi, pa(init_pg_tables_start)
+	movl $pa(__brk_base), %edi
 	movl $pa(swapper_pg_dir), %edx
 	movl $PTE_IDENT_ATTR, %eax
 10:
@@ -249,7 +248,8 @@ page_pde_offset = (__PAGE_OFFSET >> 20);
 	leal (INIT_MAP_BEYOND_END+PTE_IDENT_ATTR)(%edi),%ebp
 	cmpl %ebp,%eax
 	jb 10b
-	movl %edi,pa(init_pg_tables_end)
+	addl $__PAGE_OFFSET, %edi
+	movl %edi, pa(_brk_end)
 	shrl $12, %eax
 	movl %eax, pa(max_pfn_mapped)
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index c246dc4..ed02176 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -113,8 +113,10 @@
 #endif
 
 unsigned int boot_cpu_id __read_mostly;
-__initdata unsigned long _brk_start = (unsigned long)&_end;
-__initdata unsigned long _brk_end = (unsigned long)&_end;
+
+extern char __brk_base[];
+__initdata unsigned long _brk_start = (unsigned long)__brk_base;
+__initdata unsigned long _brk_end = (unsigned long)&__brk_base;
 
 #ifdef CONFIG_X86_64
 int default_cpu_present_to_apicid(int mps_cpu)
@@ -160,12 +162,6 @@ static struct resource bss_resource = {
 
 
 #ifdef CONFIG_X86_32
-/* This value is set up by the early boot code to point to the value
-   immediately after the boot time page tables.  It contains a *physical*
-   address, and must not be in the .bss segment! */
-unsigned long init_pg_tables_start __initdata = ~0UL;
-unsigned long init_pg_tables_end __initdata = ~0UL;
-
 static struct resource video_ram_resource = {
 	.name	= "Video RAM area",
 	.start	= 0xa0000,
diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
index 0d86096..2f772dc 100644
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ b/arch/x86/kernel/vmlinux_32.lds.S
@@ -190,9 +190,8 @@ SECTIONS
 	. = ALIGN(4);
 	__bss_stop = .;
   	_end = . ;
-	/* This is where the kernel creates the early boot page tables */
 	. = ALIGN(PAGE_SIZE);
-	pg0 = . ;
+	__brk_base = . ;
   }
 
   /* Sections to be discarded */
diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index fbfced6..4878198 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -245,6 +245,8 @@ SECTIONS
   __bss_stop = .;
 
   _end = . ;
+  . = ALIGN(PAGE_SIZE);
+  __brk_base = . ;
 
   /* Sections to be discarded */
   /DISCARD/ : {
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index f3a5305..ba2c2da 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
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
 
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 319bd40..cf16959 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1716,9 +1716,11 @@ __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
 {
 	pmd_t *kernel_pmd;
 
-	init_pg_tables_start = __pa(pgd);
-	init_pg_tables_end = __pa(pgd) + xen_start_info->nr_pt_frames*PAGE_SIZE;
-	max_pfn_mapped = PFN_DOWN(init_pg_tables_end + 512*1024);
+	/*
+	 * We already set _brk_start to point to the end of the
+	 * Xen-provided pagetables.
+	 */
+	max_pfn_mapped = PFN_DOWN(_brk_start + 512*1024);
 
 	kernel_pmd = m2v(pgd[KERNEL_PGD_BOUNDARY].pgd);
 	memcpy(level2_kernel_pgt, kernel_pmd, sizeof(pmd_t) * PTRS_PER_PMD);
-- 
1.6.0.6

