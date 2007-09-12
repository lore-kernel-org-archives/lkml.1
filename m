Return-Path: <linux-kernel-owner+w=401wt.eu-S1765285AbXILUbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765285AbXILUbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 16:31:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755323AbXILUa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 16:30:58 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:22352 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757339AbXILUa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 16:30:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:message-id;
        b=LMaThoSN4mD0eLQp6VkIKNdbhAMsyCzYYOYscuS8/C3xgAbeU07p6LE5YiCmc4jTjYpD6NKnyJ4CtnuUqThJEco/4EVsy2cq1IaUN06tCpxdses9/bpQ6n5RAHnFX43nsi2eLqMDs+KY2M1N+mLtf3HoxuF1PygqBvalnHu2Bqw=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 2/2] section garbage collection for i386
Date: Wed, 12 Sep 2007 21:30:48 +0100
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org
References: <200709122124.21164.vda.linux@googlemail.com>
In-Reply-To: <200709122124.21164.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_4xE6GbijCVNy6Rm"
Message-Id: <200709122130.48889.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_4xE6GbijCVNy6Rm
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Sam,

This patch adds module linker script (completely analogous to x86_64),
and "minimally" fixes vmlinux linker script by adding KEEPs.
It also deleted an outdated comment and amends help text.

I got a few "section mismatch" warnings with .config which doesn't
show them (IIRC) on original kernel.

I took a look and I think that original kernel was actually in error
and these warnings are correct!

WARNING: vmlinux.o(.text.kmem_cache_create+0x32f): Section mismatch: reference to .init.refok.text:setup_cpu_cache (after 'kmem_cache_create')
WARNING: vmlinux.o(.text.vgacon_startup+0x2dd): Section mismatch: reference to .init.refok.text:vgacon_scrollback_startup (after 'vgacon_startup')
WARNING: vmlinux.o(.data.smp_ops+0x0): Section mismatch: reference to .init.text:native_smp_prepare_boot_cpu (after 'smp_ops')
WARNING: vmlinux.o(.data.smp_ops+0x4): Section mismatch: reference to .init.text:native_smp_prepare_cpus (after 'smp_ops')
WARNING: vmlinux.o(.data.smp_ops+0xc): Section mismatch: reference to .init.text:native_smp_cpus_done (after 'smp_ops')
WARNING: vmlinux.o(.data.vesafb_driver+0x0): Section mismatch: reference to .init.text:vesafb_probe (after 'vesafb_driver')
WARNING: vmlinux.o(.data.serial8250_console+0x20): Section mismatch: reference to .init.text:serial8250_console_setup (after 'serial8250_console')
WARNING: vmlinux.o(.data.dgrs_pci_driver+0x10): Section mismatch: reference to .init.text:dgrs_pci_probe (after 'dgrs_pci_driver')

Risk of this patch is analogous to last patch of first series -
run-tested and looks safe, but needs to go into -mm first.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda

--Boundary-00=_4xE6GbijCVNy6Rm
Content-Type: text/x-diff;
  charset="iso-8859-15";
  name="linux-2.6.23-rc4.6.i386.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="linux-2.6.23-rc4.6.i386.patch"

diff -urpN linux-2.6.23-rc4.gc5/arch/i386/kernel/modules.lds linux-2.6.23-rc4.gc6/arch/i386/kernel/modules.lds
--- linux-2.6.23-rc4.gc5/arch/i386/kernel/modules.lds	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.23-rc4.gc6/arch/i386/kernel/modules.lds	2007-09-12 19:49:10.000000000 +0100
@@ -0,0 +1,123 @@
+OUTPUT_FORMAT("elf32-i386", "elf32-i386", "elf32-i386")
+OUTPUT_ARCH(i386)
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
+$ARCH_UNWIND_SECTION_NAME
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
diff -urpN linux-2.6.23-rc4.gc5/arch/i386/kernel/vmlinux.lds.S linux-2.6.23-rc4.gc6/arch/i386/kernel/vmlinux.lds.S
--- linux-2.6.23-rc4.gc5/arch/i386/kernel/vmlinux.lds.S	2007-09-12 19:46:32.000000000 +0100
+++ linux-2.6.23-rc4.gc6/arch/i386/kernel/vmlinux.lds.S	2007-09-12 19:51:42.000000000 +0100
@@ -32,7 +32,7 @@ SECTIONS
 
   .head.text : AT(ADDR(.head.text) - LOAD_OFFSET) {
   	_text = .;			/* Text and read-only data */
-	*(.head.text)
+	KEEP(*(.head.text))
   } :text = 0x9090
 
   /* read-only */
@@ -41,6 +41,7 @@ SECTIONS
 	SCHED_TEXT
 	LOCK_TEXT
 	KPROBES_TEXT
+	/* No need to KEEP - referenced by __ex_table */
 	*(.fixup)
 	*(.gnu.warning)
   	_etext = .;			/* End of text section */
@@ -49,7 +50,7 @@ SECTIONS
   . = ALIGN(16);		/* Exception table */
   __ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) {
   	__start___ex_table = .;
-	 *(__ex_table)
+	KEEP(*(__ex_table))
   	__stop___ex_table = .;
   }
 
@@ -60,7 +61,8 @@ SECTIONS
   . = ALIGN(4);
   .tracedata : AT(ADDR(.tracedata) - LOAD_OFFSET) {
   	__tracedata_start = .;
-	*(.tracedata)
+	/* Resume debug tracing */
+	KEEP(*(.tracedata))
   	__tracedata_end = .;
   }
 
@@ -71,11 +73,12 @@ SECTIONS
   .data : AT(ADDR(.data) - LOAD_OFFSET) {	/* Data */
 	DATA_DATA
 	CONSTRUCTORS
-	} :data
+  } :data
 
   . = ALIGN(4096);
   .data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {
   	__nosave_begin = .;
+	/* No need to KEEP */
 	*(.nosave.data)
   	. = ALIGN(4096);
   	__nosave_end = .;
@@ -108,19 +111,13 @@ SECTIONS
   . = ALIGN(4096);
   .smp_locks : AT(ADDR(.smp_locks) - LOAD_OFFSET) {
   	__smp_locks = .;
-	*(.smp_locks)
+	KEEP(*(.smp_locks))
 	__smp_locks_end = .;
   }
-  /* will be freed after init
-   * Following ALIGN() is required to make sure no other data falls on the
-   * same page where __smp_alt_end is pointing as that page might be freed
-   * after boot. Always make sure that ALIGN() directive is present after
-   * the section which contains __smp_alt_end.
-   */
-  . = ALIGN(4096);
 
-  /* will be freed after init */
-  . = ALIGN(4096);		/* Init code and data */
+  /* Will be freed after init */
+  /* Init code and data */
+  . = ALIGN(4096);
   .init.text : AT(ADDR(.init.text) - LOAD_OFFSET) {
   	__init_begin = .;
 	_sinittext = .;
@@ -131,7 +128,9 @@ SECTIONS
   . = ALIGN(16);
   .init.setup : AT(ADDR(.init.setup) - LOAD_OFFSET) {
   	__setup_start = .;
-	*(.init.setup)
+	/* __setup_param() macro produces these,
+	 * obsolete_checksetup() processes them */
+	KEEP(*(.init.setup))
   	__setup_end = .;
    }
   .initcall.init : AT(ADDR(.initcall.init) - LOAD_OFFSET) {
@@ -141,46 +140,50 @@ SECTIONS
   }
   .con_initcall.init : AT(ADDR(.con_initcall.init) - LOAD_OFFSET) {
   	__con_initcall_start = .;
-	*(.con_initcall.init)
+	KEEP(*(.con_initcall.init))
   	__con_initcall_end = .;
   }
   SECURITY_INIT
   . = ALIGN(4);
   .altinstructions : AT(ADDR(.altinstructions) - LOAD_OFFSET) {
   	__alt_instructions = .;
-	*(.altinstructions)
+	KEEP(*(.altinstructions))
 	__alt_instructions_end = .;
   }
   .altinstr_replacement : AT(ADDR(.altinstr_replacement) - LOAD_OFFSET) {
+	/* No need to KEEP - referenced by .altinstructions */
 	*(.altinstr_replacement)
   }
   . = ALIGN(4);
   .parainstructions : AT(ADDR(.parainstructions) - LOAD_OFFSET) {
   	__parainstructions = .;
-	*(.parainstructions)
+	KEEP(*(.parainstructions))
   	__parainstructions_end = .;
   }
-  /* .exit.text is discard at runtime, not link time, to deal with references
+  /* .exit.text is discarded at runtime, not link time, to deal with references
      from .altinstructions and .eh_frame */
   .exit.text : AT(ADDR(.exit.text) - LOAD_OFFSET) { *(.exit.text) }
   .exit.data : AT(ADDR(.exit.data) - LOAD_OFFSET) { *(.exit.data) }
+
 #if defined(CONFIG_BLK_DEV_INITRD)
   . = ALIGN(4096);
   .init.ramfs : AT(ADDR(.init.ramfs) - LOAD_OFFSET) {
 	__initramfs_start = .;
-	*(.init.ramfs)
+	KEEP(*(.init.ramfs))
 	__initramfs_end = .;
   }
 #endif
+
   . = ALIGN(4096);
-  .percpu.data  : AT(ADDR(.percpu.data) - LOAD_OFFSET) {
+  .percpu.data : AT(ADDR(.percpu.data) - LOAD_OFFSET) {
 	__per_cpu_start = .;
 	*(.percpu.data)
 	*(.percpu.shared_aligned.data)
 	__per_cpu_end = .;
   }
   . = ALIGN(4096);
-  /* freed after init ends here */
+
+  /* End of "freed after init" portion */
 	
   .bss : AT(ADDR(.bss) - LOAD_OFFSET) {
 	__init_end = .;
@@ -189,7 +192,7 @@ SECTIONS
          * we want to combine into bss, otherwise gcc does not set
          * 'nobits' flag for the section, and it cannot be merged into bss. */
 	*(.bss.k.page_aligned)
-	*(.bss)
+	*(SORT_BY_ALIGNMENT(.bss*))
 	. = ALIGN(4);
 	__bss_stop = .;
   	_end = . ;
@@ -201,7 +204,7 @@ SECTIONS
   /* Sections to be discarded */
   /DISCARD/ : {
 	*(.exitcall.exit)
-	}
+  }
 
   STABS_DEBUG
 
diff -urpN linux-2.6.23-rc4.gc5/init/Kconfig linux-2.6.23-rc4.gc6/init/Kconfig
--- linux-2.6.23-rc4.gc5/init/Kconfig	2007-09-12 19:46:32.000000000 +0100
+++ linux-2.6.23-rc4.gc6/init/Kconfig	2007-09-12 21:23:39.000000000 +0100
@@ -360,7 +360,7 @@ config DISCARD_UNUSED_SECTIONS
 	  and even then surprises are likely.
 
 	  This option also requires architecture-specific changes.
-	  Currently working architectures: x86_64
+	  Currently working architectures: x86_64, i386
 
 	  If unsure, say N.
 

--Boundary-00=_4xE6GbijCVNy6Rm--
