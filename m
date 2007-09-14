Return-Path: <linux-kernel-owner+w=401wt.eu-S1756567AbXINSGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567AbXINSGZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 14:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753932AbXINSGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 14:06:17 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:5504 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510AbXINSGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 14:06:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VfMk79BLBGr7+TUueb7vsYJOrM/XNs+vinWXkk8Dr/c+BuGUXS50f61Pr5jhQhVS935Vbc4qng6wYNcmUEDuLhhBKVqXgUk+/5z1RtsVIaR4AUp90hSXFZhqmxlb1ei6idC3WE+TpgWOqVf5FhUOTBQdVRql8E+shNG+Wa4ryjQ=
Message-ID: <863e9df20709141106p57ade527x8fc44d31475f0ef3@mail.gmail.com>
Date: Fri, 14 Sep 2007 23:36:13 +0530
From: "Abhishek Sagar" <sagar.abhishek@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [PATCH 0/4] build system: section garbage collection for vmlinux
Cc: "Denys Vlasenko" <vda.linux@googlemail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070913183548.GB27146@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200709112105.34301.vda.linux@googlemail.com>
	 <863e9df20709131126n182ec6f6l2c790bae4411d79e@mail.gmail.com>
	 <20070913183548.GB27146@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/14/07, Sam Ravnborg <sam@ravnborg.org> wrote:
> > With some tweaks it worked for me.
> Could you post your tweaked version - against an older kernel is OK.

The inlined patch should apply cleanly on top of the patch posted on
the link I mentioned before. The *.S files are the ones I chose to
bring them under the purview of --ffunction-sections. My observation
remains that if a fine-grained function/data/exported-symbol level
garbage collection can be incorporated into the build environment,
then it'll be something really useful.

--
Abhishek Sagar

---
diff -upNr linux_orig-2.6.12/arch/arm/kernel/armksyms.c
linux-2.6.12/arch/arm/kernel/armksyms.c
--- linux_orig-2.6.12/arch/arm/kernel/armksyms.c	2005-06-18
01:18:29.000000000 +0530
+++ linux-2.6.12/arch/arm/kernel/armksyms.c	2007-09-14 09:00:03.000000000 +0530
@@ -44,10 +44,17 @@ extern void fp_enter(void);
  * This has a special calling convention; it doesn't
  * modify any of the usual registers, except for LR.
  */
+#ifndef CONFIG_GCSECTIONS
 #define EXPORT_SYMBOL_ALIAS(sym,orig)		\
  const struct kernel_symbol __ksymtab_##sym	\
   __attribute__((section("__ksymtab"))) =	\
     { (unsigned long)&orig, #sym };
+#else
+#define EXPORT_SYMBOL_ALIAS(sym,orig)            \
+ const struct kernel_symbol __ksymtab_##sym      \
+  __attribute__((section("___ksymtab_" #sym))) = \
+    { (unsigned long)&orig, #sym };
+#endif /* CONFIG_GCSECTIONS */

 /*
  * floating point math emulator support.
diff -upNr linux_orig-2.6.12/arch/arm/kernel/iwmmxt.S
linux-2.6.12/arch/arm/kernel/iwmmxt.S
--- linux_orig-2.6.12/arch/arm/kernel/iwmmxt.S	2005-06-18
01:18:29.000000000 +0530
+++ linux-2.6.12/arch/arm/kernel/iwmmxt.S	2007-09-14 09:21:01.000000000 +0530
@@ -55,7 +55,11 @@
  *
  * called from prefetch exception handler with interrupts disabled
  */
-
+#ifdef CONFIG_GCSECTIONS
+	       .section ".text.iwmmxt_task_enable"
+#else
+	       .text
+#endif
 ENTRY(iwmmxt_task_enable)

 	mrc	p15, 0, r2, c15, c1, 0
diff -upNr linux_orig-2.6.12/arch/arm/kernel/vmlinux.lds.S
linux-2.6.12/arch/arm/kernel/vmlinux.lds.S
--- linux_orig-2.6.12/arch/arm/kernel/vmlinux.lds.S	2005-06-18
01:18:29.000000000 +0530
+++ linux-2.6.12/arch/arm/kernel/vmlinux.lds.S	2007-09-14
08:58:30.000000000 +0530
@@ -20,50 +20,50 @@ SECTIONS
 	.init : {			/* Init code and data		*/
 		_stext = .;
 			_sinittext = .;
-			*(.init.text)
+			KEEP(*(.init.text))
 			_einittext = .;
 		__proc_info_begin = .;
-			*(.proc.info)
+			KEEP(*(.proc.info))
 		__proc_info_end = .;
 		__arch_info_begin = .;
-			*(.arch.info)
+			KEEP(*(.arch.info))
 		__arch_info_end = .;
 		__tagtable_begin = .;
-			*(.taglist)
+			KEEP(*(.taglist))
 		__tagtable_end = .;
 		. = ALIGN(16);
 		__setup_start = .;
-			*(.init.setup)
+			KEEP(*(.init.setup))
 		__setup_end = .;
 		__early_begin = .;
-			*(__early_param)
+			KEEP(*(__early_param))
 		__early_end = .;
 		__initcall_start = .;
-			*(.initcall1.init)
-			*(.initcall2.init)
-			*(.initcall3.init)
-			*(.initcall4.init)
-			*(.initcall5.init)
-			*(.initcall6.init)
-			*(.initcall7.init)
+			KEEP(*(.initcall1.init))
+			KEEP(*(.initcall2.init))
+			KEEP(*(.initcall3.init))
+			KEEP(*(.initcall4.init))
+			KEEP(*(.initcall5.init))
+			KEEP(*(.initcall6.init))
+			KEEP(*(.initcall7.init))
 		__initcall_end = .;
 		__con_initcall_start = .;
-			*(.con_initcall.init)
+			KEEP(*(.con_initcall.init))
 		__con_initcall_end = .;
 		__security_initcall_start = .;
-			*(.security_initcall.init)
+			KEEP(*(.security_initcall.init))
 		__security_initcall_end = .;
 		. = ALIGN(32);
 		__initramfs_start = .;
-			usr/built-in.o(.init.ramfs)
+			KEEP(usr/built-in.o(.init.ramfs))
 		__initramfs_end = .;
 		. = ALIGN(64);
 		__per_cpu_start = .;
-			*(.data.percpu)
+			KEEP(*(.data.percpu))
 		__per_cpu_end = .;
 #ifndef CONFIG_XIP_KERNEL
 		__init_begin = _stext;
-		*(.init.data)
+		KEEP(*(.init.data))
 		. = ALIGN(4096);
 		__init_end = .;
 #endif
@@ -78,6 +78,8 @@ SECTIONS
 	.text : {			/* Real text segment		*/
 		_text = .;		/* Text and read-only data	*/
 			*(.text)
+			*(.text.*)
+			#include "vmlinux.ldskeep.h"
 			SCHED_TEXT
 			LOCK_TEXT
 			*(.fixup)
@@ -92,12 +94,42 @@ SECTIONS
 	. = ALIGN(16);
 	__ex_table : {			/* Exception table		*/
 		__start___ex_table = .;
-			*(__ex_table)
+			KEEP(*(__ex_table))
 		__stop___ex_table = .;
 	}

 	RODATA

+#ifdef CONFIG_GCSECTIONS
+	__ksymtab         : AT(ADDR(__ksymtab) - LOAD_OFFSET) {
+		VMLINUX_SYMBOL(__start___ksymtab) = .;		
+                #include "keep.ksymtab.txt"
+		VMLINUX_SYMBOL(__stop___ksymtab) = .;		
+	}							
+								
+	__ksymtab_gpl     : AT(ADDR(__ksymtab_gpl) - LOAD_OFFSET) {
+		VMLINUX_SYMBOL(__start___ksymtab_gpl) = .;		
+                #include "keep.ksymtabgpl.txt"
+		VMLINUX_SYMBOL(__stop___ksymtab_gpl) = .;
+	}
+
+	__kcrctab         : AT(ADDR(__kcrctab) - LOAD_OFFSET) {
+		VMLINUX_SYMBOL(__start___kcrctab) = .;
+		KEEP(*(__kcrctab))
+		VMLINUX_SYMBOL(__stop___kcrctab) = .;
+	}
+
+	__kcrctab_gpl     : AT(ADDR(__kcrctab_gpl) - LOAD_OFFSET) {
+		VMLINUX_SYMBOL(__start___kcrctab_gpl) = .;
+		KEEP(*(__kcrctab_gpl))
+		VMLINUX_SYMBOL(__stop___kcrctab_gpl) = .;
+	}
+
+        __ksymtab_strings : AT(ADDR(__ksymtab_strings) - LOAD_OFFSET) {
+		#include "keep.ksymstrings.txt"
+	}
+#endif /* CONFIG_GCSECTIONS */
+
 	_etext = .;			/* End of text and rodata section */

 #ifdef CONFIG_XIP_KERNEL
@@ -120,14 +152,14 @@ SECTIONS
 #ifdef CONFIG_XIP_KERNEL
 		. = ALIGN(4096);
 		__init_begin = .;
-		*(.init.data)
+		KEEP(*(.init.data))
 		. = ALIGN(4096);
 		__init_end = .;
 #endif

 		. = ALIGN(4096);
 		__nosave_begin = .;
-		*(.data.nosave)
+		KEEP(*(.data.nosave))
 		. = ALIGN(4096);
 		__nosave_end = .;

@@ -135,12 +167,13 @@ SECTIONS
 		 * then the cacheline aligned data
 		 */
 		. = ALIGN(32);
-		*(.data.cacheline_aligned)
+		KEEP(*(.data.cacheline_aligned))

 		/*
 		 * and the usual data section
 		 */
 		*(.data)
+		*(.data.*)
 		CONSTRUCTORS

 		_edata = .;
@@ -149,6 +182,7 @@ SECTIONS
 	.bss : {
 		__bss_start = .;	/* BSS				*/
 		*(.bss)
+		*(.bss.*)
 		*(COMMON)
 		_end = .;
 	}
diff -upNr linux_orig-2.6.12/arch/arm/lib/copy_page.S
linux-2.6.12/arch/arm/lib/copy_page.S
--- linux_orig-2.6.12/arch/arm/lib/copy_page.S	2005-06-18
01:18:29.000000000 +0530
+++ linux-2.6.12/arch/arm/lib/copy_page.S	2007-09-14 09:18:29.000000000 +0530
@@ -15,7 +15,11 @@

 #define COPY_COUNT (PAGE_SZ/64 PLD( -1 ))

-		.text
+#ifdef CONFIG_GCSECTIONS
+                .section ".text.copy_page"
+#else
+                .text
+#endif
 		.align	5
 /*
  * StrongARM optimised copy_page routine
diff -upNr linux_orig-2.6.12/arch/arm/lib/csumipv6.S
linux-2.6.12/arch/arm/lib/csumipv6.S
--- linux_orig-2.6.12/arch/arm/lib/csumipv6.S	2005-06-18
01:18:29.000000000 +0530
+++ linux-2.6.12/arch/arm/lib/csumipv6.S	2007-09-14 09:11:20.000000000 +0530
@@ -10,7 +10,11 @@
 #include <linux/linkage.h>
 #include <asm/assembler.h>

-		.text
+#ifdef CONFIG_GCSECTIONS
+               .section ".text.__csum_ipv6_magic"
+#else
+               .text
+#endif

 ENTRY(__csum_ipv6_magic)
 		str	lr, [sp, #-4]!
diff -upNr linux_orig-2.6.12/arch/arm/lib/csumpartialcopyuser.S
linux-2.6.12/arch/arm/lib/csumpartialcopyuser.S
--- linux_orig-2.6.12/arch/arm/lib/csumpartialcopyuser.S	2005-06-18
01:18:29.000000000 +0530
+++ linux-2.6.12/arch/arm/lib/csumpartialcopyuser.S	2007-09-14
09:17:34.000000000 +0530
@@ -15,7 +15,11 @@
 #include <asm/errno.h>
 #include <asm/constants.h>

-		.text
+#ifdef CONFIG_GCSECTIONS
+                .section ".text.csum_partial_copy_from_user"
+#else
+                .text
+#endif

 		.macro	save_regs
 		stmfd	sp!, {r1 - r2, r4 - r8, fp, ip, lr, pc}
diff -upNr linux_orig-2.6.12/arch/arm/lib/csumpartial.S
linux-2.6.12/arch/arm/lib/csumpartial.S
--- linux_orig-2.6.12/arch/arm/lib/csumpartial.S	2005-06-18
01:18:29.000000000 +0530
+++ linux-2.6.12/arch/arm/lib/csumpartial.S	2007-09-14 09:10:34.000000000 +0530
@@ -10,7 +10,11 @@
 #include <linux/linkage.h>
 #include <asm/assembler.h>

-		.text
+#ifdef CONFIG_GCSECTIONS
+        .section ".text.csum_partial"
+#else
+        .text
+#endif

 /*
  * Function: __u32 csum_partial(const char *src, int len, __u32 sum)
diff -upNr linux_orig-2.6.12/arch/arm/lib/memchr.S
linux-2.6.12/arch/arm/lib/memchr.S
--- linux_orig-2.6.12/arch/arm/lib/memchr.S	2005-06-18 01:18:29.000000000 +0530
+++ linux-2.6.12/arch/arm/lib/memchr.S	2007-09-14 09:11:56.000000000 +0530
@@ -12,7 +12,11 @@
 #include <linux/linkage.h>
 #include <asm/assembler.h>

-	.text
+#ifdef CONFIG_GCSECTIONS
+       .section ".text.memchr"
+#else
+       .text
+#endif
 	.align	5
 ENTRY(memchr)
 1:	subs	r2, r2, #1
diff -upNr linux_orig-2.6.12/arch/arm/lib/memset.S
linux-2.6.12/arch/arm/lib/memset.S
--- linux_orig-2.6.12/arch/arm/lib/memset.S	2005-06-18 01:18:29.000000000 +0530
+++ linux-2.6.12/arch/arm/lib/memset.S	2007-09-14 09:10:16.000000000 +0530
@@ -12,7 +12,11 @@
 #include <linux/linkage.h>
 #include <asm/assembler.h>

-	.text
+#ifdef CONFIG_GCSECTIONS
+        .section ".text.memset"
+#else
+        .text
+#endif
 	.align	5
 	.word	0

diff -upNr linux_orig-2.6.12/arch/arm/lib/memzero.S
linux-2.6.12/arch/arm/lib/memzero.S
--- linux_orig-2.6.12/arch/arm/lib/memzero.S	2005-06-18 01:18:29.000000000 +0530
+++ linux-2.6.12/arch/arm/lib/memzero.S	2007-09-14 09:19:58.000000000 +0530
@@ -10,7 +10,11 @@
 #include <linux/linkage.h>
 #include <asm/assembler.h>

-	.text
+#ifdef CONFIG_GCSECTIONS
+        .section ".text.__memzero"
+#else
+        .text
+#endif
 	.align	5
 	.word	0
 /*
diff -upNr linux_orig-2.6.12/arch/arm/lib/strchr.S
linux-2.6.12/arch/arm/lib/strchr.S
--- linux_orig-2.6.12/arch/arm/lib/strchr.S	2005-06-18 01:18:29.000000000 +0530
+++ linux-2.6.12/arch/arm/lib/strchr.S	2007-09-14 09:09:56.000000000 +0530
@@ -12,7 +12,11 @@
 #include <linux/linkage.h>
 #include <asm/assembler.h>

-		.text
+#ifdef CONFIG_GCSECTIONS
+                 .section ".text.strchr"
+#else
+                 .text
+#endif
 		.align	5
 ENTRY(strchr)
 		and	r1, r1, #0xff
diff -upNr linux_orig-2.6.12/arch/arm/lib/strncpy_from_user.S
linux-2.6.12/arch/arm/lib/strncpy_from_user.S
--- linux_orig-2.6.12/arch/arm/lib/strncpy_from_user.S	2005-06-18
01:18:29.000000000 +0530
+++ linux-2.6.12/arch/arm/lib/strncpy_from_user.S	2007-09-14
09:19:20.000000000 +0530
@@ -11,7 +11,11 @@
 #include <asm/assembler.h>
 #include <asm/errno.h>

-	.text
+#ifdef CONFIG_GCSECTIONS
+        .section ".text.__arch_strncpy_from_user"
+#else
+        .text
+#endif
 	.align	5

 /*
diff -upNr linux_orig-2.6.12/arch/arm/lib/strnlen_user.S
linux-2.6.12/arch/arm/lib/strnlen_user.S
--- linux_orig-2.6.12/arch/arm/lib/strnlen_user.S	2005-06-18
01:18:29.000000000 +0530
+++ linux-2.6.12/arch/arm/lib/strnlen_user.S	2007-09-14 09:10:42.000000000 +0530
@@ -11,7 +11,11 @@
 #include <asm/assembler.h>
 #include <asm/errno.h>

-	.text
+#ifdef CONFIG_GCSECTIONS
+        .section ".text.__arch_strnlen_user"
+#else
+        .text
+#endif
 	.align	5

 /* Prototype: unsigned long __arch_strnlen_user(const char *str, long n)
diff -upNr linux_orig-2.6.12/arch/arm/lib/strrchr.S
linux-2.6.12/arch/arm/lib/strrchr.S
--- linux_orig-2.6.12/arch/arm/lib/strrchr.S	2005-06-18 01:18:29.000000000 +0530
+++ linux-2.6.12/arch/arm/lib/strrchr.S	2007-09-14 09:10:06.000000000 +0530
@@ -12,7 +12,11 @@
 #include <linux/linkage.h>
 #include <asm/assembler.h>

-		.text
+#ifdef CONFIG_GCSECTIONS
+                 .section ".text.strrchr"
+#else
+                 .text
+#endif /* CONFIG_GCSECTIONS */
 		.align	5
 ENTRY(strrchr)
 		mov	r3, #0
