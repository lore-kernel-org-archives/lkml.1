Return-Path: <linux-kernel-owner+w=401wt.eu-S1752604AbZCKQ7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604AbZCKQ7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 12:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbZCKQ7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 12:59:37 -0400
Received: from gw.goop.org ([64.81.55.164]:43359 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbZCKQ7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 12:59:35 -0400
Message-ID: <49B7EDF4.7060904@goop.org>
Date: Wed, 11 Mar 2009 09:59:32 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] x86: add brk allocator for very early allocations
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aggregate patch below.

The following changes since commit 11f5585820ae805c48f41c09bc260d0e51744792:
  Ingo Molnar (1):
        Merge branch 'tracing/ftrace'

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git push/x86/brk

Jeremy Fitzhardinge (4):
      x86: make section delimiter symbols part of their section
      x86: add brk allocation for very, very early allocations
      x86-32: use brk segment for allocating initial kernel pagetable
      x86: use brk allocation for DMI

 arch/x86/include/asm/dmi.h        |   14 +-----
 arch/x86/include/asm/pgtable_32.h |    3 -
 arch/x86/include/asm/sections.h   |    7 +++
 arch/x86/include/asm/setup.h      |    7 ++-
 arch/x86/kernel/head32.c          |    5 +--
 arch/x86/kernel/head64.c          |    2 +-
 arch/x86/kernel/head_32.S         |   14 +++---
 arch/x86/kernel/setup.c           |   51 ++++++++++++++-------
 arch/x86/kernel/vmlinux_32.lds.S  |    9 +++-
 arch/x86/kernel/vmlinux_64.lds.S  |   90 ++++++++++++++++++++----------------
 arch/x86/lguest/boot.c            |    8 ---
 arch/x86/mm/pageattr.c            |    5 +-
 arch/x86/xen/mmu.c                |    6 +-
 13 files changed, 118 insertions(+), 103 deletions(-)

diff --git a/arch/x86/include/asm/dmi.h b/arch/x86/include/asm/dmi.h
index bc68212..aa32f7e 100644
--- a/arch/x86/include/asm/dmi.h
+++ b/arch/x86/include/asm/dmi.h
@@ -2,21 +2,11 @@
 #define _ASM_X86_DMI_H
 
 #include <asm/io.h>
+#include <asm/setup.h>
 
-#define DMI_MAX_DATA 2048
-
-extern int dmi_alloc_index;
-extern char dmi_alloc_data[DMI_MAX_DATA];
-
-/* This is so early that there is no good way to allocate dynamic memory.
-   Allocate data in an BSS array. */
 static inline void *dmi_alloc(unsigned len)
 {
-	int idx = dmi_alloc_index;
-	if ((dmi_alloc_index + len) > DMI_MAX_DATA)
-		return NULL;
-	dmi_alloc_index += len;
-	return dmi_alloc_data + idx;
+	return extend_brk(len, sizeof(int));
 }
 
 /* Use early IO mappings for DMI because it's initialized early */
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
diff --git a/arch/x86/include/asm/sections.h b/arch/x86/include/asm/sections.h
index 2b8c516..1b7ee5d 100644
--- a/arch/x86/include/asm/sections.h
+++ b/arch/x86/include/asm/sections.h
@@ -1 +1,8 @@
+#ifndef _ASM_X86_SECTIONS_H
+#define _ASM_X86_SECTIONS_H
+
 #include <asm-generic/sections.h>
+
+extern char __brk_base[], __brk_limit[];
+
+#endif	/* _ASM_X86_SECTIONS_H */
diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index 05c6f6b..366d366 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -100,14 +100,15 @@ extern struct boot_params boot_params;
  */
 #define LOWMEMSIZE()	(0x9f000)
 
+/* exceedingly early brk-like allocator */
+extern unsigned long _brk_end;
+void *extend_brk(size_t size, size_t align);
+
 #ifdef __i386__
 
 void __init i386_start_kernel(void);
 extern void probe_roms(void);
 
-extern unsigned long init_pg_tables_start;
-extern unsigned long init_pg_tables_end;
-
 #else
 void __init x86_64_start_kernel(char *real_mode);
 void __init x86_64_start_reservations(char *real_mode_data);
diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index ac108d1..3f8579f 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -18,7 +18,7 @@ void __init i386_start_kernel(void)
 {
 	reserve_trampoline_memory();
 
-	reserve_early(__pa_symbol(&_text), __pa_symbol(&_end), "TEXT DATA BSS");
+	reserve_early(__pa_symbol(&_text), __pa_symbol(&__bss_stop), "TEXT DATA BSS");
 
 #ifdef CONFIG_BLK_DEV_INITRD
 	/* Reserve INITRD */
@@ -29,9 +29,6 @@ void __init i386_start_kernel(void)
 		reserve_early(ramdisk_image, ramdisk_end, "RAMDISK");
 	}
 #endif
-	reserve_early(init_pg_tables_start, init_pg_tables_end,
-			"INIT_PG_TABLE");
-
 	reserve_ebda_region();
 
 	/*
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index f5b2722..70eaa85 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -100,7 +100,7 @@ void __init x86_64_start_reservations(char *real_mode_data)
 
 	reserve_trampoline_memory();
 
-	reserve_early(__pa_symbol(&_text), __pa_symbol(&_end), "TEXT DATA BSS");
+	reserve_early(__pa_symbol(&_text), __pa_symbol(&__bss_stop), "TEXT DATA BSS");
 
 #ifdef CONFIG_BLK_DEV_INITRD
 	/* Reserve INITRD */
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
index ce9e888..b344908 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -114,6 +114,9 @@
 
 unsigned int boot_cpu_id __read_mostly;
 
+static __initdata unsigned long _brk_start = (unsigned long)__brk_base;
+unsigned long _brk_end = (unsigned long)__brk_base;
+
 #ifdef CONFIG_X86_64
 int default_cpu_present_to_apicid(int mps_cpu)
 {
@@ -158,12 +161,6 @@ static struct resource bss_resource = {
 
 
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
@@ -219,12 +216,6 @@ unsigned long mmu_cr4_features = X86_CR4_PAE;
 int bootloader_type;
 
 /*
- * Early DMI memory
- */
-int dmi_alloc_index;
-char dmi_alloc_data[DMI_MAX_DATA];
-
-/*
  * Setup options
  */
 struct screen_info screen_info;
@@ -337,6 +328,34 @@ static void __init relocate_initrd(void)
 }
 #endif
 
+void * __init extend_brk(size_t size, size_t align)
+{
+	size_t mask = align - 1;
+	void *ret;
+
+	BUG_ON(_brk_start == 0);
+	BUG_ON(align & mask);
+
+	_brk_end = (_brk_end + mask) & ~mask;
+	BUG_ON((char *)(_brk_end + size) > __brk_limit);
+
+	ret = (void *)_brk_end;
+	_brk_end += size;
+
+	memset(ret, 0, size);
+
+	return ret;
+}
+
+static void __init reserve_brk(void)
+{
+	if (_brk_end > _brk_start)
+		reserve_early(__pa(_brk_start), __pa(_brk_end), "BRK");
+
+	/* Mark brk area as locked down and no longer taking any new allocations */
+	_brk_start = 0;
+}
+
 static void __init reserve_initrd(void)
 {
 	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
@@ -717,11 +736,7 @@ void __init setup_arch(char **cmdline_p)
 	init_mm.start_code = (unsigned long) _text;
 	init_mm.end_code = (unsigned long) _etext;
 	init_mm.end_data = (unsigned long) _edata;
-#ifdef CONFIG_X86_32
-	init_mm.brk = init_pg_tables_end + PAGE_OFFSET;
-#else
-	init_mm.brk = (unsigned long) &_end;
-#endif
+	init_mm.brk = _brk_end;
 
 	code_resource.start = virt_to_phys(_text);
 	code_resource.end = virt_to_phys(_etext)-1;
@@ -842,6 +857,8 @@ void __init setup_arch(char **cmdline_p)
 	setup_bios_corruption_check();
 #endif
 
+	reserve_brk();
+
 	/* max_pfn_mapped is updated here */
 	max_low_pfn_mapped = init_memory_mapping(0, max_low_pfn<<PAGE_SHIFT);
 	max_pfn_mapped = max_low_pfn_mapped;
diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
index 0d86096..1063fbe 100644
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ b/arch/x86/kernel/vmlinux_32.lds.S
@@ -189,10 +189,13 @@ SECTIONS
 	*(.bss)
 	. = ALIGN(4);
 	__bss_stop = .;
-  	_end = . ;
-	/* This is where the kernel creates the early boot page tables */
+
 	. = ALIGN(PAGE_SIZE);
-	pg0 = . ;
+	__brk_base = . ;
+	. += 1024 * 1024 ;
+	__brk_limit = . ;
+
+  	_end = . ;
   }
 
   /* Sections to be discarded */
diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index fbfced6..b8b83e4 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -29,8 +29,8 @@ SECTIONS
 {
   . = __START_KERNEL;
   phys_startup_64 = startup_64 - LOAD_OFFSET;
-  _text = .;			/* Text and read-only data */
   .text :  AT(ADDR(.text) - LOAD_OFFSET) {
+  	_text = .;			/* Text and read-only data */
 	/* First the code that has to be first for bootstrapping */
 	*(.text.head)
 	_stext = .;
@@ -61,13 +61,13 @@ SECTIONS
   .data : AT(ADDR(.data) - LOAD_OFFSET) {
 	DATA_DATA
 	CONSTRUCTORS
+	_edata = .;			/* End of data section */
 	} :data
 
-  _edata = .;			/* End of data section */
 
-  . = ALIGN(PAGE_SIZE);
-  . = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
   .data.cacheline_aligned : AT(ADDR(.data.cacheline_aligned) - LOAD_OFFSET) {
+	. = ALIGN(PAGE_SIZE);
+	. = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
 	*(.data.cacheline_aligned)
   }
   . = ALIGN(CONFIG_X86_INTERNODE_CACHE_BYTES);
@@ -125,29 +125,29 @@ SECTIONS
 #undef VVIRT_OFFSET
 #undef VVIRT
 
-  . = ALIGN(THREAD_SIZE);	/* init_task */
   .data.init_task : AT(ADDR(.data.init_task) - LOAD_OFFSET) {
+	. = ALIGN(THREAD_SIZE);	/* init_task */
 	*(.data.init_task)
   }:data.init
 
-  . = ALIGN(PAGE_SIZE);
   .data.page_aligned : AT(ADDR(.data.page_aligned) - LOAD_OFFSET) {
+	. = ALIGN(PAGE_SIZE);
 	*(.data.page_aligned)
   }
 
-  /* might get freed after init */
-  . = ALIGN(PAGE_SIZE);
-  __smp_alt_begin = .;
-  __smp_locks = .;
   .smp_locks : AT(ADDR(.smp_locks) - LOAD_OFFSET) {
+	/* might get freed after init */
+	. = ALIGN(PAGE_SIZE);
+	__smp_alt_begin = .;
+	__smp_locks = .;
 	*(.smp_locks)
+	__smp_locks_end = .;
+	. = ALIGN(PAGE_SIZE);
+	__smp_alt_end = .;
   }
-  __smp_locks_end = .;
-  . = ALIGN(PAGE_SIZE);
-  __smp_alt_end = .;
 
   . = ALIGN(PAGE_SIZE);		/* Init code and data */
-  __init_begin = .;
+  __init_begin = .;	/* paired with __init_end */
   .init.text : AT(ADDR(.init.text) - LOAD_OFFSET) {
 	_sinittext = .;
 	INIT_TEXT
@@ -159,40 +159,42 @@ SECTIONS
 	__initdata_end = .;
    }
 
-  . = ALIGN(16);
-  __setup_start = .;
-  .init.setup : AT(ADDR(.init.setup) - LOAD_OFFSET) { *(.init.setup) }
-  __setup_end = .;
-  __initcall_start = .;
+  .init.setup : AT(ADDR(.init.setup) - LOAD_OFFSET) {
+	. = ALIGN(16);
+	__setup_start = .;
+	*(.init.setup)
+	__setup_end = .;
+  }
   .initcall.init : AT(ADDR(.initcall.init) - LOAD_OFFSET) {
+	__initcall_start = .;
 	INITCALLS
+	__initcall_end = .;
   }
-  __initcall_end = .;
-  __con_initcall_start = .;
   .con_initcall.init : AT(ADDR(.con_initcall.init) - LOAD_OFFSET) {
+	__con_initcall_start = .;
 	*(.con_initcall.init)
+	__con_initcall_end = .;
   }
-  __con_initcall_end = .;
-  __x86_cpu_dev_start = .;
   .x86_cpu_dev.init : AT(ADDR(.x86_cpu_dev.init) - LOAD_OFFSET) {
+	__x86_cpu_dev_start = .;
 	*(.x86_cpu_dev.init)
+	__x86_cpu_dev_end = .;
   }
-  __x86_cpu_dev_end = .;
   SECURITY_INIT
 
   . = ALIGN(8);
   .parainstructions : AT(ADDR(.parainstructions) - LOAD_OFFSET) {
-  __parainstructions = .;
+	__parainstructions = .;
        *(.parainstructions)
-  __parainstructions_end = .;
+	__parainstructions_end = .;
   }
 
-  . = ALIGN(8);
-  __alt_instructions = .;
   .altinstructions : AT(ADDR(.altinstructions) - LOAD_OFFSET) {
+	. = ALIGN(8);
+	__alt_instructions = .;
 	*(.altinstructions)
+	__alt_instructions_end = .;
   }
-  __alt_instructions_end = .;
   .altinstr_replacement : AT(ADDR(.altinstr_replacement) - LOAD_OFFSET) {
 	*(.altinstr_replacement)
   }
@@ -207,9 +209,11 @@ SECTIONS
 
 #ifdef CONFIG_BLK_DEV_INITRD
   . = ALIGN(PAGE_SIZE);
-  __initramfs_start = .;
-  .init.ramfs : AT(ADDR(.init.ramfs) - LOAD_OFFSET) { *(.init.ramfs) }
-  __initramfs_end = .;
+  .init.ramfs : AT(ADDR(.init.ramfs) - LOAD_OFFSET) {
+	__initramfs_start = .;
+	*(.init.ramfs)
+	__initramfs_end = .;
+  }
 #endif
 
 #ifdef CONFIG_SMP
@@ -229,20 +233,26 @@ SECTIONS
   . = ALIGN(PAGE_SIZE);
   __init_end = .;
 
-  . = ALIGN(PAGE_SIZE);
-  __nosave_begin = .;
   .data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {
-      *(.data.nosave)
+	. = ALIGN(PAGE_SIZE);
+	__nosave_begin = .;
+	*(.data.nosave)
+	. = ALIGN(PAGE_SIZE);
+	__nosave_end = .;
   } :data.init2 /* use another section data.init2, see PERCPU_VADDR() above */
-  . = ALIGN(PAGE_SIZE);
-  __nosave_end = .;
 
-  __bss_start = .;		/* BSS */
   .bss : AT(ADDR(.bss) - LOAD_OFFSET) {
+	. = ALIGN(PAGE_SIZE);
+	__bss_start = .;		/* BSS */
 	*(.bss.page_aligned)
 	*(.bss)
-	}
-  __bss_stop = .;
+	__bss_stop = .;
+
+ 	. = ALIGN(PAGE_SIZE);
+ 	__brk_base = . ;
+ 	. += 1024 * 1024 ;
+ 	__brk_limit = . ;
+  }
 
   _end = . ;
 
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index 9fe4dda..90e44a1 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -1058,14 +1058,6 @@ __init void lguest_init(void)
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
 
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 4629a87..8eb4eaa 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -16,6 +16,7 @@
 #include <asm/processor.h>
 #include <asm/tlbflush.h>
 #include <asm/sections.h>
+#include <asm/setup.h>
 #include <asm/uaccess.h>
 #include <asm/pgalloc.h>
 #include <asm/proto.h>
@@ -95,7 +96,7 @@ static inline unsigned long highmap_start_pfn(void)
 
 static inline unsigned long highmap_end_pfn(void)
 {
-	return __pa(roundup((unsigned long)_end, PMD_SIZE)) >> PAGE_SHIFT;
+	return __pa(roundup(_brk_end, PMD_SIZE)) >> PAGE_SHIFT;
 }
 
 #endif
@@ -700,7 +701,7 @@ static int cpa_process_alias(struct cpa_data *cpa)
 	 * No need to redo, when the primary call touched the high
 	 * mapping already:
 	 */
-	if (within(vaddr, (unsigned long) _text, (unsigned long) _end))
+	if (within(vaddr, (unsigned long) _text, _brk_end))
 		return 0;
 
 	/*
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index cb6afa4..72f6a76 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1723,9 +1723,9 @@ __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
 {
 	pmd_t *kernel_pmd;
 
-	init_pg_tables_start = __pa(pgd);
-	init_pg_tables_end = __pa(pgd) + xen_start_info->nr_pt_frames*PAGE_SIZE;
-	max_pfn_mapped = PFN_DOWN(init_pg_tables_end + 512*1024);
+	max_pfn_mapped = PFN_DOWN(__pa(xen_start_info->pt_base) +
+				  xen_start_info->nr_pt_frames * PAGE_SIZE +
+				  512*1024);
 
 	kernel_pmd = m2v(pgd[KERNEL_PGD_BOUNDARY].pgd);
 	memcpy(level2_kernel_pgt, kernel_pmd, sizeof(pmd_t) * PTRS_PER_PMD);


