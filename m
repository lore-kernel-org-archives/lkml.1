Return-Path: <linux-kernel-owner+w=401wt.eu-S1755543AbZHYSA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543AbZHYSA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 14:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755485AbZHYSAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 14:00:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38202 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755484AbZHYSAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 14:00:54 -0400
Date: Tue, 25 Aug 2009 20:00:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT PULL] x86 fixes
Message-ID: <20090825180036.GA28732@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

( An item that might look a bit out of place is the old-binutils
  compatibility fix to the linker script. It's a tad large IMO, but
  pretty much unavoidable and the revert to .30 would be huge.
  I left it last, easy to re-route, in case you think we should do
  this differently. )

 Thanks,

	Ingo

------------------>
Amerigo Wang (1):
      x86: Fix an incorrect argument of reserve_bootmem()

Jan Beulich (3):
      i386: Fix section mismatches for init code with !HOTPLUG_CPU
      x86: add vmlinux.lds to targets in arch/x86/boot/compressed/Makefile
      x86: Fix build with older binutils and consolidate linker script

Jeremy Fitzhardinge (2):
      x86: make sure load_percpu_segment has no stackprotector
      xen: rearrange things to fix stackprotector

Suresh Siddha (1):
      x86, pat: Allow ISA memory range uncacheable mapping requests


 arch/x86/boot/compressed/Makefile |    2 +-
 arch/x86/include/asm/pgtable.h    |   12 +++-
 arch/x86/kernel/cpu/Makefile      |    4 +
 arch/x86/kernel/head_32.S         |    8 +--
 arch/x86/kernel/vmlinux.lds.S     |  126 ++++++++++++++-----------------------
 arch/x86/mm/init_64.c             |    2 +-
 arch/x86/mm/pat.c                 |    3 +-
 arch/x86/xen/Makefile             |    4 +
 arch/x86/xen/enlighten.c          |   22 +++----
 9 files changed, 80 insertions(+), 103 deletions(-)

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index e2ff504..f8ed065 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -4,7 +4,7 @@
 # create a compressed vmlinux image from the original vmlinux
 #
 
-targets := vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma head_$(BITS).o misc.o piggy.o
+targets := vmlinux.lds vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma head_$(BITS).o misc.o piggy.o
 
 KBUILD_CFLAGS := -m$(BITS) -D__KERNEL__ $(LINUX_INCLUDE) -O2
 KBUILD_CFLAGS += -fno-strict-aliasing -fPIC
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 3cc06e3..1674807 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -2,6 +2,7 @@
 #define _ASM_X86_PGTABLE_H
 
 #include <asm/page.h>
+#include <asm/e820.h>
 
 #include <asm/pgtable_types.h>
 
@@ -269,10 +270,17 @@ static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
 
 #define canon_pgprot(p) __pgprot(massage_pgprot(p))
 
-static inline int is_new_memtype_allowed(unsigned long flags,
-						unsigned long new_flags)
+static inline int is_new_memtype_allowed(u64 paddr, unsigned long size,
+					 unsigned long flags,
+					 unsigned long new_flags)
 {
 	/*
+	 * PAT type is always WB for ISA. So no need to check.
+	 */
+	if (is_ISA_range(paddr, paddr + size - 1))
+		return 1;
+
+	/*
 	 * Certain new memtypes are not allowed with certain
 	 * requested memtype:
 	 * - request is uncached, return cannot be write-back
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 3efcb2b..c1f253d 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -7,6 +7,10 @@ ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_common.o = -pg
 endif
 
+# Make sure load_percpu_segment has no stackprotector
+nostackp := $(call cc-option, -fno-stack-protector)
+CFLAGS_common.o		:= $(nostackp)
+
 obj-y			:= intel_cacheinfo.o addon_cpuid_features.o
 obj-y			+= proc.o capflags.o powerflags.o common.o
 obj-y			+= vmware.o hypervisor.o
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 0d98a01..cc827ac 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -261,9 +261,7 @@ page_pde_offset = (__PAGE_OFFSET >> 20);
  * which will be freed later
  */
 
-#ifndef CONFIG_HOTPLUG_CPU
-.section .init.text,"ax",@progbits
-#endif
+__CPUINIT
 
 #ifdef CONFIG_SMP
 ENTRY(startup_32_smp)
@@ -602,11 +600,7 @@ ignore_int:
 #endif
 	iret
 
-#ifndef CONFIG_HOTPLUG_CPU
-	__CPUINITDATA
-#else
 	__REFDATA
-#endif
 .align 4
 ENTRY(initial_code)
 	.long i386_start_kernel
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 78d185d..9fc1782 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -46,11 +46,10 @@ PHDRS {
 	data PT_LOAD FLAGS(7);          /* RWE */
 #ifdef CONFIG_X86_64
 	user PT_LOAD FLAGS(7);          /* RWE */
-	data.init PT_LOAD FLAGS(7);     /* RWE */
 #ifdef CONFIG_SMP
 	percpu PT_LOAD FLAGS(7);        /* RWE */
 #endif
-	data.init2 PT_LOAD FLAGS(7);    /* RWE */
+	init PT_LOAD FLAGS(7);          /* RWE */
 #endif
 	note PT_NOTE FLAGS(0);          /* ___ */
 }
@@ -103,65 +102,43 @@ SECTIONS
 		__stop___ex_table = .;
 	} :text = 0x9090
 
-	RODATA
+	RO_DATA(PAGE_SIZE)
 
 	/* Data */
-	. = ALIGN(PAGE_SIZE);
 	.data : AT(ADDR(.data) - LOAD_OFFSET) {
 		/* Start of data section */
 		_sdata = .;
-		DATA_DATA
-		CONSTRUCTORS
-	} :data
+
+		/* init_task */
+		INIT_TASK_DATA(THREAD_SIZE)
 
 #ifdef CONFIG_X86_32
-	/* 32 bit has nosave before _edata */
-	. = ALIGN(PAGE_SIZE);
-	.data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {
-		__nosave_begin = .;
-		*(.data.nosave)
-		. = ALIGN(PAGE_SIZE);
-		__nosave_end = .;
-	}
+		/* 32 bit has nosave before _edata */
+		NOSAVE_DATA
 #endif
 
-	. = ALIGN(PAGE_SIZE);
-	.data.page_aligned : AT(ADDR(.data.page_aligned) - LOAD_OFFSET) {
-		*(.data.page_aligned)
+		PAGE_ALIGNED_DATA(PAGE_SIZE)
 		*(.data.idt)
-	}
 
-#ifdef CONFIG_X86_32
-	. = ALIGN(32);
-#else
-	. = ALIGN(PAGE_SIZE);
-	. = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
-#endif
-	.data.cacheline_aligned :
-		AT(ADDR(.data.cacheline_aligned) - LOAD_OFFSET) {
-		*(.data.cacheline_aligned)
-	}
+		CACHELINE_ALIGNED_DATA(CONFIG_X86_L1_CACHE_BYTES)
 
-	/* rarely changed data like cpu maps */
-#ifdef CONFIG_X86_32
-	. = ALIGN(32);
-#else
-	. = ALIGN(CONFIG_X86_INTERNODE_CACHE_BYTES);
-#endif
-	.data.read_mostly : AT(ADDR(.data.read_mostly) - LOAD_OFFSET) {
-		*(.data.read_mostly)
+		DATA_DATA
+		CONSTRUCTORS
+
+		/* rarely changed data like cpu maps */
+		READ_MOSTLY_DATA(CONFIG_X86_INTERNODE_CACHE_BYTES)
 
 		/* End of data section */
 		_edata = .;
-	}
+	} :data
 
 #ifdef CONFIG_X86_64
 
 #define VSYSCALL_ADDR (-10*1024*1024)
-#define VSYSCALL_PHYS_ADDR ((LOADADDR(.data.read_mostly) + \
-                            SIZEOF(.data.read_mostly) + 4095) & ~(4095))
-#define VSYSCALL_VIRT_ADDR ((ADDR(.data.read_mostly) + \
-                            SIZEOF(.data.read_mostly) + 4095) & ~(4095))
+#define VSYSCALL_PHYS_ADDR ((LOADADDR(.data) + SIZEOF(.data) + \
+                            PAGE_SIZE - 1) & ~(PAGE_SIZE - 1))
+#define VSYSCALL_VIRT_ADDR ((ADDR(.data) + SIZEOF(.data) + \
+                            PAGE_SIZE - 1) & ~(PAGE_SIZE - 1))
 
 #define VLOAD_OFFSET (VSYSCALL_ADDR - VSYSCALL_PHYS_ADDR)
 #define VLOAD(x) (ADDR(x) - VLOAD_OFFSET)
@@ -227,35 +204,29 @@ SECTIONS
 
 #endif /* CONFIG_X86_64 */
 
-	/* init_task */
-	. = ALIGN(THREAD_SIZE);
-	.data.init_task : AT(ADDR(.data.init_task) - LOAD_OFFSET) {
-		*(.data.init_task)
+	/* Init code and data - will be freed after init */
+	. = ALIGN(PAGE_SIZE);
+	.init.begin : AT(ADDR(.init.begin) - LOAD_OFFSET) {
+		__init_begin = .; /* paired with __init_end */
 	}
-#ifdef CONFIG_X86_64
-	 :data.init
-#endif
 
+#if defined(CONFIG_X86_64) && defined(CONFIG_SMP)
 	/*
-	 * smp_locks might be freed after init
-	 * start/end must be page aligned
+	 * percpu offsets are zero-based on SMP.  PERCPU_VADDR() changes the
+	 * output PHDR, so the next output section - .init.text - should
+	 * start another segment - init.
 	 */
-	. = ALIGN(PAGE_SIZE);
-	.smp_locks : AT(ADDR(.smp_locks) - LOAD_OFFSET) {
-		__smp_locks = .;
-		*(.smp_locks)
-		__smp_locks_end = .;
-		. = ALIGN(PAGE_SIZE);
-	}
+	PERCPU_VADDR(0, :percpu)
+#endif
 
-	/* Init code and data - will be freed after init */
-	. = ALIGN(PAGE_SIZE);
 	.init.text : AT(ADDR(.init.text) - LOAD_OFFSET) {
-		__init_begin = .; /* paired with __init_end */
 		_sinittext = .;
 		INIT_TEXT
 		_einittext = .;
 	}
+#ifdef CONFIG_X86_64
+	:init
+#endif
 
 	.init.data : AT(ADDR(.init.data) - LOAD_OFFSET) {
 		INIT_DATA
@@ -326,17 +297,7 @@ SECTIONS
 	}
 #endif
 
-#if defined(CONFIG_X86_64) && defined(CONFIG_SMP)
-	/*
-	 * percpu offsets are zero-based on SMP.  PERCPU_VADDR() changes the
-	 * output PHDR, so the next output section - __data_nosave - should
-	 * start another section data.init2.  Also, pda should be at the head of
-	 * percpu area.  Preallocate it and define the percpu offset symbol
-	 * so that it can be accessed as a percpu variable.
-	 */
-	. = ALIGN(PAGE_SIZE);
-	PERCPU_VADDR(0, :percpu)
-#else
+#if !defined(CONFIG_X86_64) || !defined(CONFIG_SMP)
 	PERCPU(PAGE_SIZE)
 #endif
 
@@ -347,15 +308,22 @@ SECTIONS
 		__init_end = .;
 	}
 
+	/*
+	 * smp_locks might be freed after init
+	 * start/end must be page aligned
+	 */
+	. = ALIGN(PAGE_SIZE);
+	.smp_locks : AT(ADDR(.smp_locks) - LOAD_OFFSET) {
+		__smp_locks = .;
+		*(.smp_locks)
+		__smp_locks_end = .;
+		. = ALIGN(PAGE_SIZE);
+	}
+
 #ifdef CONFIG_X86_64
 	.data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {
-		. = ALIGN(PAGE_SIZE);
-		__nosave_begin = .;
-		*(.data.nosave)
-		. = ALIGN(PAGE_SIZE);
-		__nosave_end = .;
-	} :data.init2
-	/* use another section data.init2, see PERCPU_VADDR() above */
+		NOSAVE_DATA
+	}
 #endif
 
 	/* BSS */
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 6176fe8..ea56b8c 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -796,7 +796,7 @@ int __init reserve_bootmem_generic(unsigned long phys, unsigned long len,
 		return ret;
 
 #else
-	reserve_bootmem(phys, len, BOOTMEM_DEFAULT);
+	reserve_bootmem(phys, len, flags);
 #endif
 
 	if (phys+len <= MAX_DMA_PFN*PAGE_SIZE) {
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index e6718bb..352aa9e 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -623,7 +623,8 @@ static int reserve_pfn_range(u64 paddr, unsigned long size, pgprot_t *vma_prot,
 		return ret;
 
 	if (flags != want_flags) {
-		if (strict_prot || !is_new_memtype_allowed(want_flags, flags)) {
+		if (strict_prot ||
+		    !is_new_memtype_allowed(paddr, size, want_flags, flags)) {
 			free_memtype(paddr, paddr + size);
 			printk(KERN_ERR "%s:%d map pfn expected mapping type %s"
 				" for %Lx-%Lx, got %s\n",
diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
index 172438f..7410640 100644
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -5,6 +5,10 @@ CFLAGS_REMOVE_time.o = -pg
 CFLAGS_REMOVE_irq.o = -pg
 endif
 
+# Make sure early boot has no stackprotector
+nostackp := $(call cc-option, -fno-stack-protector)
+CFLAGS_enlighten.o		:= $(nostackp)
+
 obj-y		:= enlighten.o setup.o multicalls.o mmu.o irq.o \
 			time.o xen-asm.o xen-asm_$(BITS).o \
 			grant-table.o suspend.o
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 0a1700a..e90540a 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -974,10 +974,6 @@ asmlinkage void __init xen_start_kernel(void)
 
 	xen_domain_type = XEN_PV_DOMAIN;
 
-	BUG_ON(memcmp(xen_start_info->magic, "xen-3", 5) != 0);
-
-	xen_setup_features();
-
 	/* Install Xen paravirt ops */
 	pv_info = xen_info;
 	pv_init_ops = xen_init_ops;
@@ -986,8 +982,15 @@ asmlinkage void __init xen_start_kernel(void)
 	pv_apic_ops = xen_apic_ops;
 	pv_mmu_ops = xen_mmu_ops;
 
-	xen_init_irq_ops();
+#ifdef CONFIG_X86_64
+	/*
+	 * Setup percpu state.  We only need to do this for 64-bit
+	 * because 32-bit already has %fs set properly.
+	 */
+	load_percpu_segment(0);
+#endif
 
+	xen_init_irq_ops();
 	xen_init_cpuid_mask();
 
 #ifdef CONFIG_X86_LOCAL_APIC
@@ -997,6 +1000,8 @@ asmlinkage void __init xen_start_kernel(void)
 	set_xen_basic_apic_ops();
 #endif
 
+	xen_setup_features();
+
 	if (xen_feature(XENFEAT_mmu_pt_update_preserve_ad)) {
 		pv_mmu_ops.ptep_modify_prot_start = xen_ptep_modify_prot_start;
 		pv_mmu_ops.ptep_modify_prot_commit = xen_ptep_modify_prot_commit;
@@ -1004,13 +1009,6 @@ asmlinkage void __init xen_start_kernel(void)
 
 	machine_ops = xen_machine_ops;
 
-#ifdef CONFIG_X86_64
-	/*
-	 * Setup percpu state.  We only need to do this for 64-bit
-	 * because 32-bit already has %fs set properly.
-	 */
-	load_percpu_segment(0);
-#endif
 	/*
 	 * The only reliable way to retain the initial address of the
 	 * percpu gdt_page is to remember it here, so we can go and
