Return-Path: <linux-kernel-owner+w=401wt.eu-S1756995AbXIENze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995AbXIENze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 09:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755981AbXIENzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 09:55:24 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:35719 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198AbXIENzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 09:55:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:message-id;
        b=nS+pPwOp9mStJ6ibudByW7vGzxCI0DrLto47S0QxbvSpVTouJRcR+VwAJZr3ec9Jx7g3+v+S+DWWWo437tFnAxeEOKb2Qyz3CFOMkzHG1eZCUEGqT69HMVvUV6x9xVF+Wfg+8//cJHMl3m54E41FyQrjG/xRq6/Vx3Ufr4yC5xY=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: sam@ravnborg.org
Subject: [PATCH 3/3] build system: section garbage collection for vmlinux
Date: Wed, 5 Sep 2007 14:55:05 +0100
User-Agent: KMail/1.9.1
Cc: kai@germaschewski.name, linux-kernel@vger.kernel.org
References: <200709051443.21522.vda.linux@googlemail.com> <200709051447.00774.vda.linux@googlemail.com> <200709051449.22567.vda.linux@googlemail.com>
In-Reply-To: <200709051449.22567.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_5Ur3G4teFUeOLlq"
Message-Id: <200709051455.05508.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_5Ur3G4teFUeOLlq
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday 05 September 2007 14:49, Denys Vlasenko wrote:
> On Wednesday 05 September 2007 14:47, Denys Vlasenko wrote:
> > On Wednesday 05 September 2007 14:43, Denys Vlasenko wrote:
> > > These patches fix section names and add
> > > CONFIG_DISCARD_UNUSED_SECTIONS. It is not enabled
> > > unconditionally because only newest binutils have
> > > ld --gc-sections which is stable enough for kernel use.
> > > IOW: this is an experimental feature for now.
> > 
> > Part 1: fix section names over entire source (all arches).
> 
> Part 2: fix x86_64 vdso linker script to not produce
> broken vdso image with gcc -ffunction-sections -fdata-sections.

Part 3:

Makefile:
init/Kconfig:
  add config DISCARD_UNUSED_SECTIONS with appropriate
  big scary warning. It enables gcc and ld options
  for section garbage collection.

arch/x86_64/kernel/vmlinux.lds.S:
include/asm-generic/vmlinux.lds.h:
  add KEEP and SORT_BY_ALIGNMENT directives, as needed.

arch/frv/Makefile:
  had half-baked option similar to DISCARD_UNUSED_SECTIONS,
  replace it.

DISCARD_UNUSED_SECTIONS=n should be safe for all arches.

DISCARD_UNUSED_SECTIONS=y is usable only for x86_64 at the moment.
--
vda

--Boundary-00=_5Ur3G4teFUeOLlq
Content-Type: text/x-diff;
  charset="iso-8859-15";
  name="linux-2.6.23-rc4.3.gc.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="linux-2.6.23-rc4.3.gc.patch"

diff -urpN linux-2.6.23-rc4.gc2/Makefile linux-2.6.23-rc4.gc3/Makefile
--- linux-2.6.23-rc4.gc2/Makefile	2007-08-31 18:58:29.000000000 +0100
+++ linux-2.6.23-rc4.gc3/Makefile	2007-09-05 14:15:33.000000000 +0100
@@ -508,6 +508,11 @@ CFLAGS          += $(call cc-option, -fn
 NOSTDINC_FLAGS += -nostdinc -isystem $(shell $(CC) -print-file-name=include)
 CHECKFLAGS     += $(NOSTDINC_FLAGS)
 
+ifdef CONFIG_DISCARD_UNUSED_SECTIONS
+CFLAGS          += $(call cc-option, -ffunction-sections -fdata-sections)
+LDFLAGS_vmlinux += $(call ld-option, -gc-sections)
+endif
+
 # warn about C99 declaration after statement
 CFLAGS += $(call cc-option,-Wdeclaration-after-statement,)
 
diff -urpN linux-2.6.23-rc4.gc2/arch/frv/Makefile linux-2.6.23-rc4.gc3/arch/frv/Makefile
--- linux-2.6.23-rc4.gc2/arch/frv/Makefile	2007-08-31 18:31:02.000000000 +0100
+++ linux-2.6.23-rc4.gc3/arch/frv/Makefile	2007-09-05 14:15:33.000000000 +0100
@@ -52,7 +52,9 @@ endif
 
 #LDFLAGS_vmlinux	:= -Map linkmap.txt
 
-ifdef CONFIG_GC_SECTIONS
+# Is this needed? We do this already in kernel's top-level Makefile.
+# $(LINKFLAGS) seems to be unused.
+ifdef CONFIG_DISCARD_UNUSED_SECTIONS
 CFLAGS		+= -ffunction-sections -fdata-sections
 LINKFLAGS	+= --gc-sections
 endif
diff -urpN linux-2.6.23-rc4.gc2/arch/x86_64/kernel/vmlinux.lds.S linux-2.6.23-rc4.gc3/arch/x86_64/kernel/vmlinux.lds.S
--- linux-2.6.23-rc4.gc2/arch/x86_64/kernel/vmlinux.lds.S	2007-09-05 14:14:37.000000000 +0100
+++ linux-2.6.23-rc4.gc3/arch/x86_64/kernel/vmlinux.lds.S	2007-09-05 14:32:42.000000000 +0100
@@ -28,14 +28,14 @@ SECTIONS
   _text = .;			/* Text and read-only data */
   .text :  AT(ADDR(.text) - LOAD_OFFSET) {
 	/* First the code that has to be first for bootstrapping */
-	*(.text_head)
+	KEEP(*(.text_head))
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
-  .data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) { *(.data_nosave) }
+  .data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) { *(.data_nosave) } /* not saved by suspend */
   . = ALIGN(4096);
   __nosave_end = .;
 
@@ -218,6 +220,7 @@ SECTIONS
   .bss : AT(ADDR(.bss) - LOAD_OFFSET) {
 	*(.bss_page_aligned)
 	*(.bss)
+	*(SORT_BY_ALIGNMENT(.bss.*))
 	}
   __bss_stop = .;
 
diff -urpN linux-2.6.23-rc4.gc2/include/asm-generic/vmlinux.lds.h linux-2.6.23-rc4.gc3/include/asm-generic/vmlinux.lds.h
--- linux-2.6.23-rc4.gc2/include/asm-generic/vmlinux.lds.h	2007-09-05 14:14:38.000000000 +0100
+++ linux-2.6.23-rc4.gc3/include/asm-generic/vmlinux.lds.h	2007-09-05 14:26:20.000000000 +0100
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
 	*(.data_init_refok)
 
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
 		*(.text_init_refok)
 
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
diff -urpN linux-2.6.23-rc4.gc2/init/Kconfig linux-2.6.23-rc4.gc3/init/Kconfig
--- linux-2.6.23-rc4.gc2/init/Kconfig	2007-08-31 18:31:05.000000000 +0100
+++ linux-2.6.23-rc4.gc3/init/Kconfig	2007-09-05 14:15:33.000000000 +0100
@@ -347,6 +347,20 @@ config CC_OPTIMIZE_FOR_SIZE
 
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
+	  If unsure, say N.
+
 config SYSCTL
 	bool
 

--Boundary-00=_5Ur3G4teFUeOLlq--
