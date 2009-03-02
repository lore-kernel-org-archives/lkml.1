Return-Path: <linux-kernel-owner+w=401wt.eu-S1758971AbZCBA4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758971AbZCBA4d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 19:56:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756989AbZCBA4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 19:56:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:55877 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756728AbZCBA4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 19:56:06 -0500
Message-ID: <49AB2E69.1010201@kernel.org>
Date: Sun, 01 Mar 2009 16:55:05 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH] x86: put initial_pg_tables into bss -v2
References: <1235785882-17580-1-git-send-email-jeremy@goop.org> <1235785882-17580-4-git-send-email-jeremy@goop.org> <86802c440902272302n3787b2bex3741b46a372a19b0@mail.gmail.com> <49A8E235.6010900@goop.org> <20090228071534.GB9351@elte.hu> <49A8EA1A.50802@kernel.org> <49A8ED3D.1060704@kernel.org> <49A8F319.3030802@goop.org> <49A9E392.6090004@kernel.org> <49AA47D2.4020804@kernel.org> <49AA5356.3050602@zytor.com> <49AACEB3.5050206@kernel.org> <49AB1A5C.6040300@zytor.com>
In-Reply-To: <49AB1A5C.6040300@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Yinghai Lu wrote:
>>
>>> No, this is garbage.  If you're insisting on getting rid of the brk-like
>>> allocation patterns,> YH
>  then you have to get an alternative dynamic
>>> allocator available to the pre-paging code.  Now, there is no reason we
>>> couldn't execute C code before enabling paging, although the code would
>>> either have to be PIC or linked at the physical address.
>>
>> you can use find_e820_area()/reserve_early() pair to find right
>> position for that.
>>
> 
> This stuff is currently done before paging is enabled, and existing C
> code can't be run as-is.  There are three ways to deal with that:
> 
> a) compile some of the code with -fPIC/-fPIE.
> b) link some code twice with different offsets.
> c) play really ugly games with segments (thus making the virtualization
>    guys unhappy.)
> 
> Pretty much, these options all suck.  Another option, of course, is to
> generate a fixed amount of page tables just to get us into the C
> environment, generate a new set, *and reclaim the old ones*.  That way
> we're not wasting memory if we're on a small-RAM machine.
> 
> It's still really ugly, though.  A much easier and cleaner way would
> seem to be to calculate a far limit on the brk and then marking it as a
> formal (non-alloc) section in the linker script and vmlinux file.  That
> way anything that examines the vmlinux file will see it as an exclusion
> section.  We can (and should) even verify that we don't overflow the brk
> and panic if we do.
> 
please check

[PATCH] x86: put initial_pg_tables into .data -v3

Impact: cleanup

Don't use ram after _end blindly for pagetables.
put those pg table into .data

also remove init_pg_tables_start/end tricks all around

v2: keep initial page table up to 512M only.
v3: acctually it is in .data.page_aligned
    add KERNEL_IMAGE_SIZE for 32bit, so small set it some small value than 512M
	when installed RAM is smaller than 512M
    initial_pgtable will cover to KERNEL_IMAGE_SIZE to avoid wasting.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/Kconfig                     |    9 +++++
 arch/x86/include/asm/page_32_types.h |    9 +++++
 arch/x86/include/asm/pgtable_32.h    |    3 -
 arch/x86/include/asm/setup.h         |    3 -
 arch/x86/kernel/head32.c             |    3 -
 arch/x86/kernel/head_32.S            |   53 ++++++++++++-----------------------
 arch/x86/kernel/setup.c              |    9 -----
 arch/x86/kernel/vmlinux_32.lds.S     |    9 +++--
 arch/x86/lguest/boot.c               |    8 -----
 arch/x86/xen/mmu.c                   |    4 --
 10 files changed, 44 insertions(+), 66 deletions(-)

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
@@ -38,42 +38,30 @@
 #define X86_VENDOR_ID	new_cpu_data+CPUINFO_x86_vendor_id
 
 /*
- * This is how much memory *in addition to the memory covered up to
- * and including _end* we need mapped initially.
- * We need:
- *  - one bit for each possible page, but only in low memory, which means
- *     2^32/4096/8 = 128K worst case (4G/4G split.)
+ * This is how much memory for page table to and including _end
+ * we need mapped initially.
  *  - enough space to map all low memory, which means
- *     (2^32/4096) / 1024 pages (worst case, non PAE)
- *     (2^32/4096) / 512 + 4 pages (worst case for PAE)
- *  - a few pages for allocator use before the kernel pagetable has
- *     been set up
+ *     (KERNEL_IMAGE_SIZE/4096) / 1024 pages (worst case, non PAE)
+ *     (KERNEL_IMAGE_SIZE/4096) / 512 + 4 pages (worst case for PAE)
  *
  * Modulo rounding, each megabyte assigned here requires a kilobyte of
  * memory, which is currently unreclaimed.
  *
  * This should be a multiple of a page.
+ *
+ * KERNEL_IMAGE_SIZE should be greater than pa(_end)
+ * and small than max_low_pfn, otherwise will waste some page table entries
  */
-LOW_PAGES = 1<<(32-PAGE_SHIFT_asm)
-
-/*
- * To preserve the DMA pool in PAGEALLOC kernels, we'll allocate
- * pagetables from above the 16MB DMA limit, so we'll have to set
- * up pagetables 16MB more (worst-case):
- */
-#if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KMEMCHECK)
-LOW_PAGES = LOW_PAGES + 0x1000000
-#endif
+LOW_PAGES = (KERNEL_IMAGE_SIZE + PAGE_SIZE_asm - 1)>>PAGE_SHIFT
 
 #if PTRS_PER_PMD > 1
 PAGE_TABLE_SIZE = (LOW_PAGES / PTRS_PER_PMD) + PTRS_PER_PGD
 #else
 PAGE_TABLE_SIZE = (LOW_PAGES / PTRS_PER_PGD)
 #endif
-BOOTBITMAP_SIZE = LOW_PAGES / 8
 ALLOCATOR_SLOP = 4
 
-INIT_MAP_BEYOND_END = BOOTBITMAP_SIZE + (PAGE_TABLE_SIZE + ALLOCATOR_SLOP)*PAGE_SIZE_asm
+INIT_MAP_SIZE = (PAGE_TABLE_SIZE + ALLOCATOR_SLOP) * PAGE_SIZE_asm
 
 /*
  * 32-bit kernel entrypoint; only used by the boot CPU.  On entry,
@@ -166,10 +154,9 @@ num_subarch_entries = (. - subarch_entri
 
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
@@ -191,7 +178,6 @@ default_entry:
 	xorl %ebx,%ebx				/* %ebx is kept at zero */
 
 	movl $pa(pg0), %edi
-	movl %edi, pa(init_pg_tables_start)
 	movl $pa(swapper_pg_pmd), %edx
 	movl $PTE_IDENT_ATTR, %eax
 10:
@@ -209,14 +195,13 @@ default_entry:
 	loop 11b
 
 	/*
-	 * End condition: we must map up to and including INIT_MAP_BEYOND_END
-	 * bytes beyond the end of our own page tables.
+	 * End condition: we must map up to the end.
 	 */
-	leal (INIT_MAP_BEYOND_END+PTE_IDENT_ATTR)(%edi),%ebp
+	movl $KERNEL_IMAGE_SIZE, %ebp
+	addl PTE_IDENT_ATTR, %ebp
 	cmpl %ebp,%eax
 	jb 10b
 1:
-	movl %edi,pa(init_pg_tables_end)
 	shrl $12, %eax
 	movl %eax, pa(max_pfn_mapped)
 
@@ -228,7 +213,6 @@ default_entry:
 page_pde_offset = (__PAGE_OFFSET >> 20);
 
 	movl $pa(pg0), %edi
-	movl %edi, pa(init_pg_tables_start)
 	movl $pa(swapper_pg_dir), %edx
 	movl $PTE_IDENT_ATTR, %eax
 10:
@@ -242,14 +226,13 @@ page_pde_offset = (__PAGE_OFFSET >> 20);
 	addl $0x1000,%eax
 	loop 11b
 	/*
-	 * End condition: we must map up to and including INIT_MAP_BEYOND_END
-	 * bytes beyond the end of our own page tables; the +0x007 is
+	 * End condition: we must map up to end, the +0x007 is
 	 * the attribute bits
 	 */
-	leal (INIT_MAP_BEYOND_END+PTE_IDENT_ATTR)(%edi),%ebp
+	movl $KERNEL_IMAGE_SIZE, %ebp
+	addl PTE_IDENT_ATTR, %ebp
 	cmpl %ebp,%eax
 	jb 10b
-	movl %edi,pa(init_pg_tables_end)
 	shrl $12, %eax
 	movl %eax, pa(max_pfn_mapped)
 
@@ -662,6 +645,8 @@ ENTRY(swapper_pg_dir)
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
@@ -205,6 +202,12 @@ SECTIONS
   DWARF_DEBUG
 }
 
+/*
+ * Build-time check on the image size:
+ */
+ASSERT((_end - LOAD_OFFSET <= KERNEL_IMAGE_SIZE),
+	"kernel image bigger than KERNEL_IMAGE_SIZE")
+
 #ifdef CONFIG_KEXEC
 /* Link time checks */
 #include <asm/kexec.h>
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
Index: linux-2.6/arch/x86/include/asm/pgtable_32.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/pgtable_32.h
+++ linux-2.6/arch/x86/include/asm/pgtable_32.h
@@ -42,9 +42,6 @@ extern void set_pmd_pfn(unsigned long, u
  */
 #undef TEST_ACCESS_OK
 
-/* The boot page tables (all created as a single array) */
-extern unsigned long pg0[];
-
 #ifdef CONFIG_X86_PAE
 # include <asm/pgtable-3level.h>
 #else
Index: linux-2.6/arch/x86/include/asm/page_32_types.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/page_32_types.h
+++ linux-2.6/arch/x86/include/asm/page_32_types.h
@@ -39,6 +39,15 @@
 #define __VIRTUAL_MASK_SHIFT	32
 #endif	/* CONFIG_X86_PAE */
 
+/*
+ * Kernel image size is limited to 512 MB (see in arch/x86/kernel/head_32.S)
+ */
+#ifndef CONFIG_VMLINUX_RAM_SIZE
+# define KERNEL_IMAGE_SIZE	(512 * 1024 * 1024)
+#else
+# define KERNEL_IMAGE_SIZE	CONFIG_VMLINUX_RAM_SIZE
+#endif
+
 #ifndef __ASSEMBLY__
 
 /*
Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -1030,6 +1030,15 @@ config PAGE_OFFSET
 	default 0xC0000000
 	depends on X86_32
 
+config VMLINUX_RAM_SIZE
+	hex "Initial ram size directly mapped"
+	range 0x400000 0x20000000
+	default 0x1000000
+	depends on X86_32 && EMBEDDED
+	---help---
+	  Select ram size that initial page table will cover. for system less 512M ram installed.
+	  the value should be greater than vmlinux and less than 512M
+
 config HIGHMEM
 	def_bool y
 	depends on X86_32 && (HIGHMEM64G || HIGHMEM4G)
