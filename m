Return-Path: <linux-kernel-owner+w=401wt.eu-S967303AbXIKUWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967303AbXIKUWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 16:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932783AbXIKUWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 16:22:22 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:65233 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933232AbXIKUWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 16:22:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:message-id;
        b=oDkJzFJfWRNDlGqAK7/0gy9etvaVAMFydWMP4dEHL7e7zZTc7cn7X3dJLBpmKbwMXkzED5FgfHO6B6/ffXqNvMqBzKm9iDD0KvGv0XtZh01oH7fjCw+OKUica4rBUHcy+OjhxBlhjiOpeJGmafLAaf0bLQnG0th9YPL86Zv8zHU=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 4/4] build system: section garbage collection for vmlinux
Date: Tue, 11 Sep 2007 21:22:07 +0100
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org
References: <200709112105.34301.vda.linux@googlemail.com> <200709112110.14270.vda.linux@googlemail.com> <200709112111.21089.vda.linux@googlemail.com>
In-Reply-To: <200709112111.21089.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_vjv5GfQl0tidrFM"
Message-Id: <200709112122.07525.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_vjv5GfQl0tidrFM
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This is the core patch of the series.

It adds CONFIG_DISCARD_UNUSED_SECTIONS,
adds KEEP() directives to linker scripts,
adds custom module linker script which is needed
to avoid having modules with many small sections.
Modules got a bit smaller too, as a result.

This patch is slighty more risky than first three,
probably need to go into -mm first.
It should be safe with CONFIG_DISCARD_UNUSED_SECTIONS off, though.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda

--Boundary-00=_vjv5GfQl0tidrFM
Content-Type: text/x-diff;
  charset="iso-8859-15";
  name="linux-2.6.23-rc4.4.gc.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="linux-2.6.23-rc4.4.gc.patch"

diff -urpN linux-2.6.23-rc4.gc3/Makefile linux-2.6.23-rc4.gc4/Makefile
--- linux-2.6.23-rc4.gc3/Makefile	2007-08-31 18:58:29.000000000 +0100
+++ linux-2.6.23-rc4.gc4/Makefile	2007-09-11 21:12:31.000000000 +0100
@@ -508,6 +508,11 @@ CFLAGS          += $(call cc-option, -fn
 NOSTDINC_FLAGS += -nostdinc -isystem $(shell $(CC) -print-file-name=include)
 CHECKFLAGS     += $(NOSTDINC_FLAGS)
 
+ifdef CONFIG_DISCARD_UNUSED_SECTIONS
+CFLAGS          += $(call cc-option, -ffunction-sections -fdata-sections)
+LDFLAGS_vmlinux += --gc-sections --print-gc-sections -Map vmlinux.map
+endif
+
 # warn about C99 declaration after statement
 CFLAGS += $(call cc-option,-Wdeclaration-after-statement,)
 
diff -urpN linux-2.6.23-rc4.gc3/arch/frv/Makefile linux-2.6.23-rc4.gc4/arch/frv/Makefile
--- linux-2.6.23-rc4.gc3/arch/frv/Makefile	2007-08-31 18:31:02.000000000 +0100
+++ linux-2.6.23-rc4.gc4/arch/frv/Makefile	2007-09-11 20:34:22.000000000 +0100
@@ -52,7 +52,9 @@ endif
 
 #LDFLAGS_vmlinux	:= -Map linkmap.txt
 
-ifdef CONFIG_GC_SECTIONS
+# Is this needed? We do this already in kernel's top-level Makefile.
+# $(LINKFLAGS) seems to be unused.
+ifdef CONFIG_DISCARD_UNUSED_SECTIONS
 CFLAGS		+= -ffunction-sections -fdata-sections
 LINKFLAGS	+= --gc-sections
 endif
diff -urpN linux-2.6.23-rc4.gc3/arch/x86_64/kernel/modules.lds linux-2.6.23-rc4.gc4/arch/x86_64/kernel/modules.lds
--- linux-2.6.23-rc4.gc3/arch/x86_64/kernel/modules.lds	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.23-rc4.gc4/arch/x86_64/kernel/modules.lds	2007-09-11 21:19:20.000000000 +0100
@@ -0,0 +1,123 @@
+OUTPUT_FORMAT("elf64-x86-64", "elf64-x86-64", "elf64-x86-64")
+OUTPUT_ARCH(i386:x86-64)
+
+/*
+This linker script is used if CONFIG_DISCARD_UNUSED_SECTIONS=y.
+We are trying to minimize number of sections in .ko file
+by coalescing .text.x, rodata.x, .data.x and bss.x input
+sections into one output section.
+
+This script may be usable without CONFIG_DISCARD_UNUSED_SECTIONS too.
+
+Kernel module loader (kernel/module.c) needs to see the following sections:
+
+.init*
+.exit*
+.gnu.linkonce.this_module
+.percpu.data
+.modinfo
+__ksymtab_gpl_future
+__ksymtab_gpl
+__ksymtab_unused_gpl
+__ksymtab_unused
+__ksymtab
+__kcrctab_gpl_future
+__kcrctab_gpl
+__kcrctab_unused_gpl
+__kcrctab_unused
+__kcrctab
+__param
+__ex_table
+__obsparm
+__versions
+.debug (?!)
+$ARCH_UNWIND_SECTION_NAME (none for x86_64 yet)
+
+They must not be coalesced into sections with other names.
+
+*/
+
+SECTIONS
+{
+  /* ro, code */
+
+  /* .fixup and .altinstr_replacement work just fine
+   * without dedicated sections */
+  .text				: {
+				    *(SORT_BY_ALIGNMENT(.text*))
+				/* __ex_table points here */
+				    *(SORT_BY_ALIGNMENT(.fixup*))
+				/* .altinstructions points here */
+				    *(SORT_BY_ALIGNMENT(.altinstr_replacement*))
+				}
+  /* only if CONFIG_MODULE_UNLOAD */
+  .exit.text			: { *(SORT_BY_ALIGNMENT(.exit.text)) }
+  /* end CONFIG_MODULE_UNLOAD */
+
+  /* ro, data */
+
+  .rodata			: { *(SORT_BY_ALIGNMENT(.rodata*)) }
+  /* Kernel searches through this table when it needs to handle an exception */
+  __ex_table			: { *(__ex_table*) }
+  /* These two tables are not currently handled by in-kernel module loader,
+   * but likely will be in future kernels */
+  .altinstructions		: { *(.altinstructions*) }
+  .smp_locks			: { *(.smp_locks*) }
+  /* Used by depmod in order to generate modules.dep, modules.symbols */
+  __ksymtab_strings		: { *(SORT_BY_ALIGNMENT(__ksymtab_strings)) }
+  /* EXPORT_SYMBOLs exported in this module */
+  __ksymtab_gpl_future		: { *(__ksymtab_gpl_future) }
+  __ksymtab_gpl			: { *(__ksymtab_gpl) }
+  __ksymtab_unused_gpl		: { *(__ksymtab_unused_gpl) }
+  __ksymtab_unused		: { *(__ksymtab_unused) }
+  __ksymtab			: { *(__ksymtab) }
+  /* only if CONFIG_MODVERSIONS */
+  __kcrctab_gpl_future		: { *(__kcrctab_gpl_future) }
+  __kcrctab_gpl			: { *(__kcrctab_gpl) }
+  __kcrctab_unused_gpl		: { *(__kcrctab_unused_gpl) }
+  __kcrctab_unused		: { *(__kcrctab_unused) }
+  __kcrctab			: { *(__kcrctab) }
+  /* from *.mod.c: const struct modversion_info ____versions[] */
+  __versions			: { *(__versions) }
+  /* end CONFIG_MODVERSIONS */
+  __param			: { *(.__param) }
+  __obsparm			: { *(.__obsparm) }
+  /* from *.mod.c: const char __module_depends[] "depends=mod1,mod2" */
+  .modinfo			: { *(SORT_BY_ALIGNMENT(.modinfo)) }
+  /* ld segfaults if we give it --build-id and then discard this section */
+  .note.gnu.build-id		: { *(.note.gnu.build-id) }
+
+  /* rw, data */
+
+  .data				: {
+				    *(SORT_BY_ALIGNMENT(.cacheline_aligned.data))
+				    *(SORT_BY_ALIGNMENT(.data*))
+				    *(SORT_BY_ALIGNMENT(.read_mostly.data))
+				}
+  /* from *.mod.c: struct module __this_module */
+  .gnu.linkonce.this_module	: { *(.gnu.linkonce.this_module) }
+  /* only if CONFIG_SMP */
+  .percpu.data			: { *(SORT_BY_ALIGNMENT(.percpu.data)) }
+  /* end CONFIG_SMP */
+  /* only if CONFIG_MODULE_UNLOAD */
+  .exit.data			: { *(SORT_BY_ALIGNMENT(.exit.data)) }
+  /* end CONFIG_MODULE_UNLOAD */
+
+  /* rw, data initialized to 0 */
+
+  .bss				: { *(SORT_BY_ALIGNMENT(.bss*)) }
+
+  /* init code/data. discarded at the end of sys_init_module() */
+
+  .init.text			: { *(SORT_BY_ALIGNMENT(.init.text)) }
+  .init.data			: { *(SORT_BY_ALIGNMENT(.init.data)) }
+
+  /* Be bold and resist the temptation to pull junk "by default" */
+
+  /DISCARD/			: { *(*) }
+
+  /* If you are going to revive these, please add comment why it is needed */
+  /* .debug			: { *(.debug) } */
+  /* .comment			: { *(.comment) } */
+  /* .note.GNU-stack		: { *(.note.GNU-stack) } */
+}
diff -urpN linux-2.6.23-rc4.gc3/arch/x86_64/kernel/vmlinux.lds.S linux-2.6.23-rc4.gc4/arch/x86_64/kernel/vmlinux.lds.S
--- linux-2.6.23-rc4.gc3/arch/x86_64/kernel/vmlinux.lds.S	2007-09-11 20:30:02.000000000 +0100
+++ linux-2.6.23-rc4.gc4/arch/x86_64/kernel/vmlinux.lds.S	2007-09-11 20:34:22.000000000 +0100
@@ -28,14 +28,14 @@ SECTIONS
   _text = .;			/* Text and read-only data */
   .text :  AT(ADDR(.text) - LOAD_OFFSET) {
 	/* First the code that has to be first for bootstrapping */
-	*(.head.text)
+	KEEP(*(.head.text))
 	_stext = .;
 	/* Then the rest */
 	TEXT_TEXT
 	SCHED_TEXT
 	LOCK_TEXT
 	KPROBES_TEXT
-	*(.fixup)
+	*(.fixup) /* no need to KEEP, every .fixup is referenced by __ex_table */
 	*(.gnu.warning)
 	} :text = 0x9090
   				/* out-of-line lock text */
@@ -44,8 +44,9 @@ SECTIONS
   _etext = .;			/* End of text section */
 
   . = ALIGN(16);		/* Exception table */
+  /* Points to potentially-faulting insns and corresponding .fixups */
   __start___ex_table = .;
-  __ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) { *(__ex_table) }
+  __ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) { KEEP(*(__ex_table)) }
   __stop___ex_table = .;
 
   NOTES :text :note
@@ -91,34 +92,34 @@ SECTIONS
 #define VVIRT(x) (ADDR(x) - VVIRT_OFFSET)
 
   . = VSYSCALL_ADDR;
-  .vsyscall_0 :	 AT(VSYSCALL_PHYS_ADDR) { *(.vsyscall_0) } :user
+  .vsyscall_0 :	 AT(VSYSCALL_PHYS_ADDR) { KEEP(*(.vsyscall_0)) } :user
   __vsyscall_0 = VSYSCALL_VIRT_ADDR;
 
   . = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
-  .vsyscall_fn : AT(VLOAD(.vsyscall_fn)) { *(.vsyscall_fn) }
+  .vsyscall_fn : AT(VLOAD(.vsyscall_fn)) { KEEP(*(.vsyscall_fn)) }
   . = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
   .vsyscall_gtod_data : AT(VLOAD(.vsyscall_gtod_data))
-		{ *(.vsyscall_gtod_data) }
+		{ KEEP(*(.vsyscall_gtod_data)) }
   vsyscall_gtod_data = VVIRT(.vsyscall_gtod_data);
   .vsyscall_clock : AT(VLOAD(.vsyscall_clock))
-		{ *(.vsyscall_clock) }
+		{ KEEP(*(.vsyscall_clock)) }
   vsyscall_clock = VVIRT(.vsyscall_clock);
 
 
-  .vsyscall_1 ADDR(.vsyscall_0) + 1024: AT(VLOAD(.vsyscall_1))
-		{ *(.vsyscall_1) }
-  .vsyscall_2 ADDR(.vsyscall_0) + 2048: AT(VLOAD(.vsyscall_2))
-		{ *(.vsyscall_2) }
+  .vsyscall_1 VSYSCALL_ADDR + 1024: AT(VLOAD(.vsyscall_1))
+		{ KEEP(*(.vsyscall_1)) }
+  .vsyscall_2 VSYSCALL_ADDR + 2048: AT(VLOAD(.vsyscall_2))
+		{ KEEP(*(.vsyscall_2)) }
 
-  .vgetcpu_mode : AT(VLOAD(.vgetcpu_mode)) { *(.vgetcpu_mode) }
+  .vgetcpu_mode : AT(VLOAD(.vgetcpu_mode)) { KEEP(*(.vgetcpu_mode)) }
   vgetcpu_mode = VVIRT(.vgetcpu_mode);
 
   . = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
-  .jiffies : AT(VLOAD(.jiffies)) { *(.jiffies) }
+  .jiffies : AT(VLOAD(.jiffies)) { KEEP(*(.jiffies)) }
   jiffies = VVIRT(.jiffies);
 
-  .vsyscall_3 ADDR(.vsyscall_0) + 3072: AT(VLOAD(.vsyscall_3))
-		{ *(.vsyscall_3) }
+  .vsyscall_3 VSYSCALL_ADDR + 3072: AT(VLOAD(.vsyscall_3))
+		{ KEEP(*(.vsyscall_3)) }
 
   . = VSYSCALL_VIRT_ADDR + 4096;
 
@@ -141,11 +142,12 @@ SECTIONS
   }
 
   /* might get freed after init */
+
   . = ALIGN(4096);
   __smp_alt_begin = .;
   __smp_locks = .;
   .smp_locks : AT(ADDR(.smp_locks) - LOAD_OFFSET) {
-	*(.smp_locks)
+	KEEP(*(.smp_locks)) /* points to lock prefixes */
   }
   __smp_locks_end = .;
   . = ALIGN(4096);
@@ -155,15 +157,15 @@ SECTIONS
   __init_begin = .;
   .init.text : AT(ADDR(.init.text) - LOAD_OFFSET) {
 	_sinittext = .;
-	*(.init.text)
+	*(.init.text) /* no need to KEEP */
 	_einittext = .;
   }
   __initdata_begin = .;
-  .init.data : AT(ADDR(.init.data) - LOAD_OFFSET) { *(.init.data) }
+  .init.data : AT(ADDR(.init.data) - LOAD_OFFSET) { *(.init.data) } /* no need to KEEP */
   __initdata_end = .;
   . = ALIGN(16);
   __setup_start = .;
-  .init.setup : AT(ADDR(.init.setup) - LOAD_OFFSET) { *(.init.setup) }
+  .init.setup : AT(ADDR(.init.setup) - LOAD_OFFSET) { KEEP(*(.init.setup)) } /* obsolete_checksetup() walks it */
   __setup_end = .;
   __initcall_start = .;
   .initcall.init : AT(ADDR(.initcall.init) - LOAD_OFFSET) {
@@ -172,34 +174,34 @@ SECTIONS
   __initcall_end = .;
   __con_initcall_start = .;
   .con_initcall.init : AT(ADDR(.con_initcall.init) - LOAD_OFFSET) {
-	*(.con_initcall.init)
+	KEEP(*(.con_initcall.init)) /* console_init() walks it */
   }
   __con_initcall_end = .;
   SECURITY_INIT
   . = ALIGN(8);
   __alt_instructions = .;
   .altinstructions : AT(ADDR(.altinstructions) - LOAD_OFFSET) {
-	*(.altinstructions)
+	KEEP(*(.altinstructions)) /* alternative_instructions() walks it */
   }
   __alt_instructions_end = .; 
   .altinstr_replacement : AT(ADDR(.altinstr_replacement) - LOAD_OFFSET) {
-	*(.altinstr_replacement)
+	KEEP(*(.altinstr_replacement))
   }
-  /* .exit.text is discard at runtime, not link time, to deal with references
+  /* .exit.text is discarded at runtime, not link time, to deal with references
      from .altinstructions and .eh_frame */
   .exit.text : AT(ADDR(.exit.text) - LOAD_OFFSET) { *(.exit.text) }
   .exit.data : AT(ADDR(.exit.data) - LOAD_OFFSET) { *(.exit.data) }
 
 /* vdso blob that is mapped into user space */
   vdso_start = . ;
-  .vdso  : AT(ADDR(.vdso) - LOAD_OFFSET) { *(.vdso) }
+  .vdso  : AT(ADDR(.vdso) - LOAD_OFFSET) { KEEP(*(.vdso)) }
   . = ALIGN(4096);
   vdso_end = .;
 
 #ifdef CONFIG_BLK_DEV_INITRD
   . = ALIGN(4096);
   __initramfs_start = .;
-  .init.ramfs : AT(ADDR(.init.ramfs) - LOAD_OFFSET) { *(.init.ramfs) }
+  .init.ramfs : AT(ADDR(.init.ramfs) - LOAD_OFFSET) { KEEP(*(.init.ramfs)) }
   __initramfs_end = .;
 #endif
 
@@ -210,7 +212,7 @@ SECTIONS
 
   . = ALIGN(4096);
   __nosave_begin = .;
-  .data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) { *(.nosave.data) }
+  .data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) { *(.nosave.data) } /* not saved by suspend */
   . = ALIGN(4096);
   __nosave_end = .;
 
@@ -218,6 +220,7 @@ SECTIONS
   .bss : AT(ADDR(.bss) - LOAD_OFFSET) {
 	*(.bss.k.page_aligned)
 	*(.bss)
+	*(SORT_BY_ALIGNMENT(.bss.*))
 	}
   __bss_stop = .;
 
diff -urpN linux-2.6.23-rc4.gc3/include/asm-generic/vmlinux.lds.h linux-2.6.23-rc4.gc4/include/asm-generic/vmlinux.lds.h
--- linux-2.6.23-rc4.gc3/include/asm-generic/vmlinux.lds.h	2007-09-11 20:30:02.000000000 +0100
+++ linux-2.6.23-rc4.gc4/include/asm-generic/vmlinux.lds.h	2007-09-11 20:34:22.000000000 +0100
@@ -6,19 +6,26 @@
 #define VMLINUX_SYMBOL(_sym_) _sym_
 #endif
 
+#ifndef CONFIG_DISCARD_UNUSED_SECTIONS
+/* Don't confuse old ld with new stuff */
+#define KEEP(x) x
+#define SORT_BY_ALIGNMENT(x) x
+#endif
+
 /* Align . to a 8 byte boundary equals to maximum function alignment. */
 #define ALIGN_FUNCTION()  . = ALIGN(8)
 
 /* .data section */
 #define DATA_DATA							\
 	*(.data)							\
+	*(SORT_BY_ALIGNMENT(.data.*))					\
 	*(.init.refok.data)
 
 #define RO_DATA(align)							\
 	. = ALIGN((align));						\
 	.rodata           : AT(ADDR(.rodata) - LOAD_OFFSET) {		\
 		VMLINUX_SYMBOL(__start_rodata) = .;			\
-		*(.rodata) *(.rodata.*)					\
+		*(.rodata) *(SORT_BY_ALIGNMENT(.rodata.*))		\
 		*(__vermagic)		/* Kernel version magic */	\
 	}								\
 									\
@@ -28,109 +35,110 @@
 									\
 	/* PCI quirks */						\
 	.pci_fixup        : AT(ADDR(.pci_fixup) - LOAD_OFFSET) {	\
+		/* walked by pci_fixup_device() */			\
 		VMLINUX_SYMBOL(__start_pci_fixups_early) = .;		\
-		*(.pci_fixup_early)					\
+		KEEP(*(.pci_fixup_early))				\
 		VMLINUX_SYMBOL(__end_pci_fixups_early) = .;		\
 		VMLINUX_SYMBOL(__start_pci_fixups_header) = .;		\
-		*(.pci_fixup_header)					\
+		KEEP(*(.pci_fixup_header))				\
 		VMLINUX_SYMBOL(__end_pci_fixups_header) = .;		\
 		VMLINUX_SYMBOL(__start_pci_fixups_final) = .;		\
-		*(.pci_fixup_final)					\
+		KEEP(*(.pci_fixup_final))				\
 		VMLINUX_SYMBOL(__end_pci_fixups_final) = .;		\
 		VMLINUX_SYMBOL(__start_pci_fixups_enable) = .;		\
-		*(.pci_fixup_enable)					\
+		KEEP(*(.pci_fixup_enable))				\
 		VMLINUX_SYMBOL(__end_pci_fixups_enable) = .;		\
 		VMLINUX_SYMBOL(__start_pci_fixups_resume) = .;		\
-		*(.pci_fixup_resume)					\
+		KEEP(*(.pci_fixup_resume))				\
 		VMLINUX_SYMBOL(__end_pci_fixups_resume) = .;		\
 	}								\
 									\
 	/* RapidIO route ops */						\
 	.rio_route        : AT(ADDR(.rio_route) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__start_rio_route_ops) = .;		\
-		*(.rio_route_ops)					\
+		KEEP(*(.rio_route_ops))					\
 		VMLINUX_SYMBOL(__end_rio_route_ops) = .;		\
 	}								\
 									\
 	/* Kernel symbol table: Normal symbols */			\
 	__ksymtab         : AT(ADDR(__ksymtab) - LOAD_OFFSET) {		\
 		VMLINUX_SYMBOL(__start___ksymtab) = .;			\
-		*(__ksymtab)						\
+		KEEP(*(__ksymtab))					\
 		VMLINUX_SYMBOL(__stop___ksymtab) = .;			\
 	}								\
 									\
 	/* Kernel symbol table: GPL-only symbols */			\
 	__ksymtab_gpl     : AT(ADDR(__ksymtab_gpl) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__start___ksymtab_gpl) = .;		\
-		*(__ksymtab_gpl)					\
+		KEEP(*(__ksymtab_gpl))					\
 		VMLINUX_SYMBOL(__stop___ksymtab_gpl) = .;		\
 	}								\
 									\
 	/* Kernel symbol table: Normal unused symbols */		\
 	__ksymtab_unused  : AT(ADDR(__ksymtab_unused) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__start___ksymtab_unused) = .;		\
-		*(__ksymtab_unused)					\
+		KEEP(*(__ksymtab_unused))				\
 		VMLINUX_SYMBOL(__stop___ksymtab_unused) = .;		\
 	}								\
 									\
 	/* Kernel symbol table: GPL-only unused symbols */		\
 	__ksymtab_unused_gpl : AT(ADDR(__ksymtab_unused_gpl) - LOAD_OFFSET) { \
 		VMLINUX_SYMBOL(__start___ksymtab_unused_gpl) = .;	\
-		*(__ksymtab_unused_gpl)					\
+		KEEP(*(__ksymtab_unused_gpl))				\
 		VMLINUX_SYMBOL(__stop___ksymtab_unused_gpl) = .;	\
 	}								\
 									\
 	/* Kernel symbol table: GPL-future-only symbols */		\
 	__ksymtab_gpl_future : AT(ADDR(__ksymtab_gpl_future) - LOAD_OFFSET) { \
 		VMLINUX_SYMBOL(__start___ksymtab_gpl_future) = .;	\
-		*(__ksymtab_gpl_future)					\
+		KEEP(*(__ksymtab_gpl_future))				\
 		VMLINUX_SYMBOL(__stop___ksymtab_gpl_future) = .;	\
 	}								\
 									\
 	/* Kernel symbol table: Normal symbols */			\
 	__kcrctab         : AT(ADDR(__kcrctab) - LOAD_OFFSET) {		\
 		VMLINUX_SYMBOL(__start___kcrctab) = .;			\
-		*(__kcrctab)						\
+		KEEP(*(__kcrctab))					\
 		VMLINUX_SYMBOL(__stop___kcrctab) = .;			\
 	}								\
 									\
 	/* Kernel symbol table: GPL-only symbols */			\
 	__kcrctab_gpl     : AT(ADDR(__kcrctab_gpl) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__start___kcrctab_gpl) = .;		\
-		*(__kcrctab_gpl)					\
+		KEEP(*(__kcrctab_gpl))					\
 		VMLINUX_SYMBOL(__stop___kcrctab_gpl) = .;		\
 	}								\
 									\
 	/* Kernel symbol table: Normal unused symbols */		\
 	__kcrctab_unused  : AT(ADDR(__kcrctab_unused) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__start___kcrctab_unused) = .;		\
-		*(__kcrctab_unused)					\
+		KEEP(*(__kcrctab_unused))				\
 		VMLINUX_SYMBOL(__stop___kcrctab_unused) = .;		\
 	}								\
 									\
 	/* Kernel symbol table: GPL-only unused symbols */		\
 	__kcrctab_unused_gpl : AT(ADDR(__kcrctab_unused_gpl) - LOAD_OFFSET) { \
 		VMLINUX_SYMBOL(__start___kcrctab_unused_gpl) = .;	\
-		*(__kcrctab_unused_gpl)					\
+		KEEP(*(__kcrctab_unused_gpl))				\
 		VMLINUX_SYMBOL(__stop___kcrctab_unused_gpl) = .;	\
 	}								\
 									\
 	/* Kernel symbol table: GPL-future-only symbols */		\
 	__kcrctab_gpl_future : AT(ADDR(__kcrctab_gpl_future) - LOAD_OFFSET) { \
 		VMLINUX_SYMBOL(__start___kcrctab_gpl_future) = .;	\
-		*(__kcrctab_gpl_future)					\
+		KEEP(*(__kcrctab_gpl_future))				\
 		VMLINUX_SYMBOL(__stop___kcrctab_gpl_future) = .;	\
 	}								\
 									\
 	/* Kernel symbol table: strings */				\
         __ksymtab_strings : AT(ADDR(__ksymtab_strings) - LOAD_OFFSET) {	\
-		*(__ksymtab_strings)					\
+		KEEP(*(__ksymtab_strings))				\
 	}								\
 									\
 	/* Built-in module parameters. */				\
 	__param : AT(ADDR(__param) - LOAD_OFFSET) {			\
 		VMLINUX_SYMBOL(__start___param) = .;			\
-		*(__param)						\
+		KEEP(*(__param))					\
 		VMLINUX_SYMBOL(__stop___param) = .;			\
 		VMLINUX_SYMBOL(__end_rodata) = .;			\
 	}								\
@@ -144,7 +152,7 @@
 #define SECURITY_INIT							\
 	.security_initcall.init : AT(ADDR(.security_initcall.init) - LOAD_OFFSET) { \
 		VMLINUX_SYMBOL(__security_initcall_start) = .;		\
-		*(.security_initcall.init) 				\
+		KEEP(*(.security_initcall.init)) 			\
 		VMLINUX_SYMBOL(__security_initcall_end) = .;		\
 	}
 
@@ -153,6 +161,7 @@
 #define TEXT_TEXT							\
 		ALIGN_FUNCTION();					\
 		*(.text)						\
+		*(SORT_BY_ALIGNMENT(.text.*))				\
 		*(.init.refok.text)
 
 /* sched.text is aling to function alignment to secure we have same
@@ -231,23 +240,23 @@
 	}
 
 #define INITCALLS							\
-  	*(.initcall0.init)						\
-  	*(.initcall0s.init)						\
-  	*(.initcall1.init)						\
-  	*(.initcall1s.init)						\
-  	*(.initcall2.init)						\
-  	*(.initcall2s.init)						\
-  	*(.initcall3.init)						\
-  	*(.initcall3s.init)						\
-  	*(.initcall4.init)						\
-  	*(.initcall4s.init)						\
-  	*(.initcall5.init)						\
-  	*(.initcall5s.init)						\
-	*(.initcallrootfs.init)						\
-  	*(.initcall6.init)						\
-  	*(.initcall6s.init)						\
-  	*(.initcall7.init)						\
-  	*(.initcall7s.init)
+	KEEP(*(.initcall0.init))	/* do_initcalls() walks them */	\
+	KEEP(*(.initcall0s.init))					\
+	KEEP(*(.initcall1.init))					\
+	KEEP(*(.initcall1s.init))					\
+	KEEP(*(.initcall2.init))					\
+	KEEP(*(.initcall2s.init))					\
+	KEEP(*(.initcall3.init))					\
+	KEEP(*(.initcall3s.init))					\
+	KEEP(*(.initcall4.init))					\
+	KEEP(*(.initcall4s.init))					\
+	KEEP(*(.initcall5.init))					\
+	KEEP(*(.initcall5s.init))					\
+	KEEP(*(.initcallrootfs.init))					\
+	KEEP(*(.initcall6.init))					\
+	KEEP(*(.initcall6s.init))					\
+	KEEP(*(.initcall7.init))					\
+	KEEP(*(.initcall7s.init))
 
 #define PERCPU(align)							\
 	. = ALIGN(align);						\
diff -urpN linux-2.6.23-rc4.gc3/init/Kconfig linux-2.6.23-rc4.gc4/init/Kconfig
--- linux-2.6.23-rc4.gc3/init/Kconfig	2007-08-31 18:31:05.000000000 +0100
+++ linux-2.6.23-rc4.gc4/init/Kconfig	2007-09-11 21:14:46.000000000 +0100
@@ -347,6 +347,23 @@ config CC_OPTIMIZE_FOR_SIZE
 
 	  If unsure, say N.
 
+config DISCARD_UNUSED_SECTIONS
+	bool "Discard unused code/data sections (DANGEROUS)"
+	default n
+	depends on EXPERIMENTAL
+	help
+	  Enabling this option will pass --ffunction-sections -fdata-sections
+	  to gcc and --gc-sections to ld, resulting in a smaller kernel.
+
+	  WARNING: --gc-sections support is very new and considered highly
+	  experimental for now. You need at least binutils 2.18,
+	  and even then surprises are likely.
+
+	  This option also requires architecture-specific changes.
+	  Currently working architectures: x86_64
+
+	  If unsure, say N.
+
 config SYSCTL
 	bool
 
diff -urpN linux-2.6.23-rc4.gc3/scripts/Makefile.modpost linux-2.6.23-rc4.gc4/scripts/Makefile.modpost
--- linux-2.6.23-rc4.gc3/scripts/Makefile.modpost	2007-08-31 18:31:05.000000000 +0100
+++ linux-2.6.23-rc4.gc4/scripts/Makefile.modpost	2007-09-11 20:33:24.000000000 +0100
@@ -97,9 +97,15 @@ $(modules:.ko=.mod.o): %.mod.o: %.mod.c 
 targets += $(modules:.ko=.mod.o)
 
 # Step 6), final link of the modules
+ifdef CONFIG_DISCARD_UNUSED_SECTIONS
+quiet_cmd_ld_ko_o = LD [M]  $@
+      cmd_ld_ko_o = $(LD) -r -T arch/$(ARCH)/kernel/modules.lds $(LDFLAGS) $(LDFLAGS_MODULE) -o $@ -Map $@.map \
+			  $(filter-out FORCE,$^)
+else
 quiet_cmd_ld_ko_o = LD [M]  $@
       cmd_ld_ko_o = $(LD) -r $(LDFLAGS) $(LDFLAGS_MODULE) -o $@		\
 			  $(filter-out FORCE,$^)
+endif
 
 $(modules): %.ko :%.o %.mod.o FORCE
 	$(call if_changed,ld_ko_o)

--Boundary-00=_vjv5GfQl0tidrFM--
