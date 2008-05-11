Return-Path: <linux-kernel-owner+w=401wt.eu-S1759180AbYEKXDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759180AbYEKXDp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 19:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755082AbYEKXDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 19:03:35 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:49798 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752769AbYEKXDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 19:03:34 -0400
Date: Mon, 12 May 2008 01:03:21 +0200
From: Sebastian Siewior <lkml@ml.breakpoint.cc>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Greg Ungerer <gerg@snapgear.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, gerg@uclinux.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68knommu: missing sections for linker script
Message-ID: <20080511230321.GA20157@Chamillionaire.breakpoint.cc>
References: <200805070052.m470qdod017612@goober> <20080511004107.GA2675@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20080511004107.GA2675@uranus.ravnborg.org>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sam Ravnborg | 2008-05-11 02:41:07 [+0200]:

>Any specific reasons why m68knommu does
>not use include/asm-generic/vmlinux-lds.h?
Yes, binutils syntax. I made a patch that changes vmlinux-lds a little
to make it work with the generic one. I posted it to uclinux ml and wait
for Greg's feedback (whether here is fine with this approach). I can
recall that he wanted to use the generic if possible. Here is the patch
so you drop an eye on it.

>
>	Sam
Sebastian
---

From: Sebastian Siewior <bigeasy@linutronix.de>
Subject: [PATCH] generic: add OUTPUT_DATA_SECTION to vmlinux.lds.h

the m68k compiler requires an information in which memory location
this section belongs. Something like

|       .data DATA_ADDR : {
|                 . = ALIGN(4);
|                 _sdata = . ;
|                 DATA_DATA
|                 . = ALIGN(8192) ;
|                 *(.data.init_task)
|                 _edata = . ;
|         } > DATA
|

is used where DATA is defined as something like
| MEMORY {
|         DATA     : ORIGIN = RAM_START, LENGTH = RAM_LENGTH
| }

and RAM_START & RAM_LENGTH is comming from Kconfig and describes
the memory.
With this patch the arch specific vmlinux.lds.S could get a little
smaller and requires less updates cycles (after adding new section
to the kernel).

Signed-off-by: Sebastian Siewior <bigeasy@linutronix.de>
---
 include/asm-generic/vmlinux.lds.h |   43 ++++++++++++++++++++----------------
 1 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index f054778..4f1feae 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -6,6 +6,10 @@
 #define VMLINUX_SYMBOL(_sym_) _sym_
 #endif
 
+#ifndef OUTPUT_DATA_SECTION
+#define OUTPUT_DATA_SECTION
+#endif
+
 /* Align . to a 8 byte boundary equals to maximum function alignment. */
 #define ALIGN_FUNCTION()  . = ALIGN(8)
 
@@ -61,11 +65,11 @@
 		*(.rodata) *(.rodata.*)					\
 		*(__vermagic)		/* Kernel version magic */	\
 		*(__markers_strings)	/* Markers: strings */		\
-	}								\
+	} OUTPUT_DATA_SECTION						\
 									\
 	.rodata1          : AT(ADDR(.rodata1) - LOAD_OFFSET) {		\
 		*(.rodata1)						\
-	}								\
+	} OUTPUT_DATA_SECTION						\
 									\
 	/* PCI quirks */						\
 	.pci_fixup        : AT(ADDR(.pci_fixup) - LOAD_OFFSET) {	\
@@ -84,89 +88,89 @@
 		VMLINUX_SYMBOL(__start_pci_fixups_resume) = .;		\
 		*(.pci_fixup_resume)					\
 		VMLINUX_SYMBOL(__end_pci_fixups_resume) = .;		\
-	}								\
+	} OUTPUT_DATA_SECTION						\
 									\
 	/* RapidIO route ops */						\
 	.rio_route        : AT(ADDR(.rio_route) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__start_rio_route_ops) = .;		\
 		*(.rio_route_ops)					\
 		VMLINUX_SYMBOL(__end_rio_route_ops) = .;		\
-	}								\
+	} OUTPUT_DATA_SECTION						\
 									\
 	/* Kernel symbol table: Normal symbols */			\
 	__ksymtab         : AT(ADDR(__ksymtab) - LOAD_OFFSET) {		\
 		VMLINUX_SYMBOL(__start___ksymtab) = .;			\
 		*(__ksymtab)						\
 		VMLINUX_SYMBOL(__stop___ksymtab) = .;			\
-	}								\
+	} OUTPUT_DATA_SECTION						\
 									\
 	/* Kernel symbol table: GPL-only symbols */			\
 	__ksymtab_gpl     : AT(ADDR(__ksymtab_gpl) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__start___ksymtab_gpl) = .;		\
 		*(__ksymtab_gpl)					\
 		VMLINUX_SYMBOL(__stop___ksymtab_gpl) = .;		\
-	}								\
+	} OUTPUT_DATA_SECTION						\
 									\
 	/* Kernel symbol table: Normal unused symbols */		\
 	__ksymtab_unused  : AT(ADDR(__ksymtab_unused) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__start___ksymtab_unused) = .;		\
 		*(__ksymtab_unused)					\
 		VMLINUX_SYMBOL(__stop___ksymtab_unused) = .;		\
-	}								\
+	} OUTPUT_DATA_SECTION						\
 									\
 	/* Kernel symbol table: GPL-only unused symbols */		\
 	__ksymtab_unused_gpl : AT(ADDR(__ksymtab_unused_gpl) - LOAD_OFFSET) { \
 		VMLINUX_SYMBOL(__start___ksymtab_unused_gpl) = .;	\
 		*(__ksymtab_unused_gpl)					\
 		VMLINUX_SYMBOL(__stop___ksymtab_unused_gpl) = .;	\
-	}								\
+	} OUTPUT_DATA_SECTION						\
 									\
 	/* Kernel symbol table: GPL-future-only symbols */		\
 	__ksymtab_gpl_future : AT(ADDR(__ksymtab_gpl_future) - LOAD_OFFSET) { \
 		VMLINUX_SYMBOL(__start___ksymtab_gpl_future) = .;	\
 		*(__ksymtab_gpl_future)					\
 		VMLINUX_SYMBOL(__stop___ksymtab_gpl_future) = .;	\
-	}								\
+	} OUTPUT_DATA_SECTION						\
 									\
 	/* Kernel symbol table: Normal symbols */			\
 	__kcrctab         : AT(ADDR(__kcrctab) - LOAD_OFFSET) {		\
 		VMLINUX_SYMBOL(__start___kcrctab) = .;			\
 		*(__kcrctab)						\
 		VMLINUX_SYMBOL(__stop___kcrctab) = .;			\
-	}								\
+	} OUTPUT_DATA_SECTION						\
 									\
 	/* Kernel symbol table: GPL-only symbols */			\
 	__kcrctab_gpl     : AT(ADDR(__kcrctab_gpl) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__start___kcrctab_gpl) = .;		\
 		*(__kcrctab_gpl)					\
 		VMLINUX_SYMBOL(__stop___kcrctab_gpl) = .;		\
-	}								\
+	} OUTPUT_DATA_SECTION						\
 									\
 	/* Kernel symbol table: Normal unused symbols */		\
 	__kcrctab_unused  : AT(ADDR(__kcrctab_unused) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__start___kcrctab_unused) = .;		\
 		*(__kcrctab_unused)					\
 		VMLINUX_SYMBOL(__stop___kcrctab_unused) = .;		\
-	}								\
+	} OUTPUT_DATA_SECTION						\
 									\
 	/* Kernel symbol table: GPL-only unused symbols */		\
 	__kcrctab_unused_gpl : AT(ADDR(__kcrctab_unused_gpl) - LOAD_OFFSET) { \
 		VMLINUX_SYMBOL(__start___kcrctab_unused_gpl) = .;	\
 		*(__kcrctab_unused_gpl)					\
 		VMLINUX_SYMBOL(__stop___kcrctab_unused_gpl) = .;	\
-	}								\
+	} OUTPUT_DATA_SECTION						\
 									\
 	/* Kernel symbol table: GPL-future-only symbols */		\
 	__kcrctab_gpl_future : AT(ADDR(__kcrctab_gpl_future) - LOAD_OFFSET) { \
 		VMLINUX_SYMBOL(__start___kcrctab_gpl_future) = .;	\
 		*(__kcrctab_gpl_future)					\
 		VMLINUX_SYMBOL(__stop___kcrctab_gpl_future) = .;	\
-	}								\
+	} OUTPUT_DATA_SECTION						\
 									\
 	/* Kernel symbol table: strings */				\
         __ksymtab_strings : AT(ADDR(__ksymtab_strings) - LOAD_OFFSET) {	\
 		*(__ksymtab_strings)					\
-	}								\
+	} OUTPUT_DATA_SECTION						\
 									\
 	/* __*init sections */						\
 	__init_rodata : AT(ADDR(__init_rodata) - LOAD_OFFSET) {		\
@@ -177,7 +181,7 @@
 		CPU_KEEP(exit.rodata)					\
 		MEM_KEEP(init.rodata)					\
 		MEM_KEEP(exit.rodata)					\
-	}								\
+	} OUTPUT_DATA_SECTION						\
 									\
 	/* Built-in module parameters. */				\
 	__param : AT(ADDR(__param) - LOAD_OFFSET) {			\
@@ -186,7 +190,8 @@
 		VMLINUX_SYMBOL(__stop___param) = .;			\
 		. = ALIGN((align));					\
 		VMLINUX_SYMBOL(__end_rodata) = .;			\
-	}								\
+	} OUTPUT_DATA_SECTION						\
+									\
 	. = ALIGN((align));
 
 /* RODATA provided for backward compatibility.
@@ -316,7 +321,7 @@
 		__start___bug_table = .;				\
 		*(__bug_table)						\
 		__stop___bug_table = .;					\
-	}
+	} OUTPUT_DATA_SECTION
 
 #define NOTES								\
 	.notes : AT(ADDR(.notes) - LOAD_OFFSET) {			\
@@ -350,5 +355,5 @@
 	.data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {		\
 		*(.data.percpu)						\
 		*(.data.percpu.shared_aligned)				\
-	}								\
+	} OUTPUT_DATA_SECTION						\
 	__per_cpu_end = .;
-- 
1.5.4.3

