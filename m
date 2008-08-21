Return-Path: <linux-kernel-owner+w=401wt.eu-S1754557AbYHURzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbYHURzg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 13:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbYHURz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 13:55:27 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:51882 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbYHURz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 13:55:26 -0400
Message-ID: <48ADABDF.1030007@linux.vnet.ibm.com>
Date: Thu, 21 Aug 2008 19:54:39 +0200
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH -mm] kernel: move CONSTRUCTORS section to asm-generic/vmlinux.lds.h
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch applies to 2.6.27-rc4 + current -mm patches.

From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>

Currently each arch/*/vmlinux.lds file separately mentions the
CONSTRUCTORS section. If it is not mentioned, constructors (such as
needed for the gcov infrastructure) are never called. If it is mentioned
outside of the same section as DATA_DATA, it can lead to linker
problems:

Paul Mackerras <paulus@samba.org> wrote:
> Ld versions before about 2.18 or so (older than April 2007, I think)
> have a bug where they put things in the wrong order in the output file
> if you don't have all the sections listed in the vmlinux.lds with an
> AT() clause on each one (it seems they all have to have AT(), or
> none).  With the gcov stuff turned on, we get a .data.gcov section
> which isn't mentioned in include/asm-generic/vmlinux.lds.h, which
> triggers this bug.  This works around the ld bug by making sure
> .data.gcov is mentioned in DATA_DATA.

Moving the CONSTRUCTORS section to DATA_DATA fixes this problem for
powerpc and reduces code duplication across all architectures.

Signed-off-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Sam Ravnborg <sam@ravnborg.org>

---
 arch/alpha/kernel/vmlinux.lds.S    |    1 -
 arch/arm/kernel/vmlinux.lds.S      |    1 -
 arch/avr32/kernel/vmlinux.lds.S    |    1 -
 arch/blackfin/kernel/vmlinux.lds.S |    1 -
 arch/frv/kernel/vmlinux.lds.S      |    1 -
 arch/ia64/kernel/vmlinux.lds.S     |    1 -
 arch/m32r/kernel/vmlinux.lds.S     |    1 -
 arch/m68k/kernel/vmlinux-std.lds   |    1 -
 arch/m68k/kernel/vmlinux-sun3.lds  |    1 -
 arch/mips/kernel/vmlinux.lds.S     |    1 -
 arch/mn10300/kernel/vmlinux.lds.S  |    1 -
 arch/parisc/kernel/vmlinux.lds.S   |    1 -
 arch/powerpc/kernel/vmlinux.lds.S  |    3 ---
 arch/s390/kernel/vmlinux.lds.S     |    1 -
 arch/sh/kernel/vmlinux_32.lds.S    |    1 -
 arch/sh/kernel/vmlinux_64.lds.S    |    1 -
 arch/sparc/kernel/vmlinux.lds.S    |    1 -
 arch/sparc64/kernel/vmlinux.lds.S  |    1 -
 arch/um/kernel/dyn.lds.S           |    1 -
 arch/um/kernel/uml.lds.S           |    1 -
 arch/x86/kernel/vmlinux_32.lds.S   |    1 -
 arch/x86/kernel/vmlinux_64.lds.S   |    1 -
 arch/xtensa/kernel/vmlinux.lds.S   |    1 -
 include/asm-generic/vmlinux.lds.h  |   12 ++++++------
 24 files changed, 6 insertions(+), 31 deletions(-)

Index: linux-2.6.26/arch/alpha/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6.26.orig/arch/alpha/kernel/vmlinux.lds.S
+++ linux-2.6.26/arch/alpha/kernel/vmlinux.lds.S
@@ -111,7 +111,6 @@ SECTIONS
 	/* Data */
 	.data : {
 		DATA_DATA
-		CONSTRUCTORS
 	}
 
 	.got : {
Index: linux-2.6.26/arch/arm/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6.26.orig/arch/arm/kernel/vmlinux.lds.S
+++ linux-2.6.26/arch/arm/kernel/vmlinux.lds.S
@@ -161,7 +161,6 @@ SECTIONS
 		 * and the usual data section
 		 */
 		DATA_DATA
-		CONSTRUCTORS
 
 		_edata = .;
 	}
Index: linux-2.6.26/arch/avr32/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6.26.orig/arch/avr32/kernel/vmlinux.lds.S
+++ linux-2.6.26/arch/avr32/kernel/vmlinux.lds.S
@@ -108,7 +108,6 @@ SECTIONS
 		/* And the rest... */
 		*(.data.rel*)
 		DATA_DATA
-		CONSTRUCTORS
 
 		_edata = .;
 	}
Index: linux-2.6.26/arch/blackfin/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6.26.orig/arch/blackfin/kernel/vmlinux.lds.S
+++ linux-2.6.26/arch/blackfin/kernel/vmlinux.lds.S
@@ -110,7 +110,6 @@ SECTIONS
 
 		DATA_DATA
 		*(.data.*)
-		CONSTRUCTORS
 
 		/* make sure the init_task is aligned to the
 		 * kernel thread size so we can locate the kernel
Index: linux-2.6.26/arch/frv/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6.26.orig/arch/frv/kernel/vmlinux.lds.S
+++ linux-2.6.26/arch/frv/kernel/vmlinux.lds.S
@@ -134,7 +134,6 @@ SECTIONS
 	DATA_DATA
 	*(.data.*)
 	EXIT_DATA
-	CONSTRUCTORS
 	}
 
   _edata = .;			/* End of data section */
Index: linux-2.6.26/arch/ia64/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6.26.orig/arch/ia64/kernel/vmlinux.lds.S
+++ linux-2.6.26/arch/ia64/kernel/vmlinux.lds.S
@@ -236,7 +236,6 @@ SECTIONS
 		DATA_DATA
 		*(.data1)
 		*(.gnu.linkonce.d*)
-		CONSTRUCTORS
 	}
 
   . = ALIGN(16);	/* gp must be 16-byte aligned for exc. table */
Index: linux-2.6.26/arch/m32r/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6.26.orig/arch/m32r/kernel/vmlinux.lds.S
+++ linux-2.6.26/arch/m32r/kernel/vmlinux.lds.S
@@ -51,7 +51,6 @@ SECTIONS
 	*(.spu)
 	*(.spi)
 	DATA_DATA
-	CONSTRUCTORS
 	}
 
   . = ALIGN(4096);
Index: linux-2.6.26/arch/m68k/kernel/vmlinux-std.lds
===================================================================
--- linux-2.6.26.orig/arch/m68k/kernel/vmlinux-std.lds
+++ linux-2.6.26/arch/m68k/kernel/vmlinux-std.lds
@@ -31,7 +31,6 @@ SECTIONS
 
   .data : {			/* Data */
 	DATA_DATA
-	CONSTRUCTORS
 	}
 
   .bss : { *(.bss) }		/* BSS */
Index: linux-2.6.26/arch/m68k/kernel/vmlinux-sun3.lds
===================================================================
--- linux-2.6.26.orig/arch/m68k/kernel/vmlinux-sun3.lds
+++ linux-2.6.26/arch/m68k/kernel/vmlinux-sun3.lds
@@ -25,7 +25,6 @@ SECTIONS
 
   .data : {			/* Data */
 	DATA_DATA
-	CONSTRUCTORS
 	. = ALIGN(16);		/* Exception table */
 	__start___ex_table = .;
 	*(__ex_table)
Index: linux-2.6.26/arch/mips/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6.26.orig/arch/mips/kernel/vmlinux.lds.S
+++ linux-2.6.26/arch/mips/kernel/vmlinux.lds.S
@@ -79,7 +79,6 @@ SECTIONS
 		*(.data.init_task)
 
 		DATA_DATA
-		CONSTRUCTORS
 	}
 	_gp = . + 0x8000;
 	.lit8 : {
Index: linux-2.6.26/arch/mn10300/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6.26.orig/arch/mn10300/kernel/vmlinux.lds.S
+++ linux-2.6.26/arch/mn10300/kernel/vmlinux.lds.S
@@ -52,7 +52,6 @@ SECTIONS
   /* writeable */
   .data : {			/* Data */
 	DATA_DATA
-	CONSTRUCTORS
 	}
 
   . = ALIGN(4096);
Index: linux-2.6.26/arch/parisc/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6.26.orig/arch/parisc/kernel/vmlinux.lds.S
+++ linux-2.6.26/arch/parisc/kernel/vmlinux.lds.S
@@ -102,7 +102,6 @@ SECTIONS
 	/* Data */
 	.data : {
 		DATA_DATA
-		CONSTRUCTORS
 	}
 
 	. = ALIGN(L1_CACHE_BYTES);
Index: linux-2.6.26/arch/powerpc/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6.26.orig/arch/powerpc/kernel/vmlinux.lds.S
+++ linux-2.6.26/arch/powerpc/kernel/vmlinux.lds.S
@@ -222,9 +222,6 @@ SECTIONS
 		*(.toc)
 	}
 #endif
-	.data.gcov : {
-		CONSTRUCTORS
-	}
 
 	. = ALIGN(PAGE_SIZE);
 	_edata  =  .;
Index: linux-2.6.26/arch/s390/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6.26.orig/arch/s390/kernel/vmlinux.lds.S
+++ linux-2.6.26/arch/s390/kernel/vmlinux.lds.S
@@ -59,7 +59,6 @@ SECTIONS
 
 	.data : {		/* Data */
 		DATA_DATA
-		CONSTRUCTORS
 	}
 
 	. = ALIGN(PAGE_SIZE);
Index: linux-2.6.26/arch/sh/kernel/vmlinux_32.lds.S
===================================================================
--- linux-2.6.26.orig/arch/sh/kernel/vmlinux_32.lds.S
+++ linux-2.6.26/arch/sh/kernel/vmlinux_32.lds.S
@@ -75,7 +75,6 @@ SECTIONS
 		__nosave_end = .;
 
 		DATA_DATA
-		CONSTRUCTORS
 	}
 
 	_edata = .;			/* End of data section */
Index: linux-2.6.26/arch/sh/kernel/vmlinux_64.lds.S
===================================================================
--- linux-2.6.26.orig/arch/sh/kernel/vmlinux_64.lds.S
+++ linux-2.6.26/arch/sh/kernel/vmlinux_64.lds.S
@@ -87,7 +87,6 @@ SECTIONS
 		__nosave_end = .;
 
 		DATA_DATA
-		CONSTRUCTORS
 	}
 
 	_edata = .;			/* End of data section */
Index: linux-2.6.26/arch/sparc/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6.26.orig/arch/sparc/kernel/vmlinux.lds.S
+++ linux-2.6.26/arch/sparc/kernel/vmlinux.lds.S
@@ -23,7 +23,6 @@ SECTIONS
 	RODATA
 	.data :	{
 		DATA_DATA
-		CONSTRUCTORS
 	}
 	.data1 : {
 		*(.data1)
Index: linux-2.6.26/arch/sparc64/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6.26.orig/arch/sparc64/kernel/vmlinux.lds.S
+++ linux-2.6.26/arch/sparc64/kernel/vmlinux.lds.S
@@ -26,7 +26,6 @@ SECTIONS
 	RO_DATA(PAGE_SIZE)
 	.data : {
 		DATA_DATA
-		CONSTRUCTORS
 	}
 	.data1 : {
 		*(.data1)
Index: linux-2.6.26/arch/um/kernel/dyn.lds.S
===================================================================
--- linux-2.6.26.orig/arch/um/kernel/dyn.lds.S
+++ linux-2.6.26/arch/um/kernel/dyn.lds.S
@@ -102,7 +102,6 @@ SECTIONS
     *(.data.init_irqstack)
     DATA_DATA
     *(.data.* .gnu.linkonce.d.*)
-    CONSTRUCTORS
   }
   .data1          : { *(.data1) }
   .tdata	  : { *(.tdata .tdata.* .gnu.linkonce.td.*) }
Index: linux-2.6.26/arch/um/kernel/uml.lds.S
===================================================================
--- linux-2.6.26.orig/arch/um/kernel/uml.lds.S
+++ linux-2.6.26/arch/um/kernel/uml.lds.S
@@ -58,7 +58,6 @@ SECTIONS
     *(.data.init_irqstack)
     DATA_DATA
     *(.gnu.linkonce.d*)
-    CONSTRUCTORS
   }
   .data1   : { *(.data1) }
   .ctors         :
Index: linux-2.6.26/arch/x86/kernel/vmlinux_32.lds.S
===================================================================
--- linux-2.6.26.orig/arch/x86/kernel/vmlinux_32.lds.S
+++ linux-2.6.26/arch/x86/kernel/vmlinux_32.lds.S
@@ -64,7 +64,6 @@ SECTIONS
   . = ALIGN(PAGE_SIZE);
   .data : AT(ADDR(.data) - LOAD_OFFSET) {	/* Data */
 	DATA_DATA
-	CONSTRUCTORS
 	} :data
 
   . = ALIGN(PAGE_SIZE);
Index: linux-2.6.26/arch/x86/kernel/vmlinux_64.lds.S
===================================================================
--- linux-2.6.26.orig/arch/x86/kernel/vmlinux_64.lds.S
+++ linux-2.6.26/arch/x86/kernel/vmlinux_64.lds.S
@@ -55,7 +55,6 @@ SECTIONS
 				/* Data */
   .data : AT(ADDR(.data) - LOAD_OFFSET) {
 	DATA_DATA
-	CONSTRUCTORS
 	} :data
 
   _edata = .;			/* End of data section */
Index: linux-2.6.26/arch/xtensa/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6.26.orig/arch/xtensa/kernel/vmlinux.lds.S
+++ linux-2.6.26/arch/xtensa/kernel/vmlinux.lds.S
@@ -119,7 +119,6 @@ SECTIONS
   .data :
   {
     DATA_DATA
-    CONSTRUCTORS
     . = ALIGN(XCHAL_ICACHE_LINESIZE);
     *(.data.cacheline_aligned)
   }
Index: linux-2.6.26/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux-2.6.26.orig/include/asm-generic/vmlinux.lds.h
+++ linux-2.6.26/include/asm-generic/vmlinux.lds.h
@@ -37,6 +37,10 @@
 #define MEM_DISCARD(sec) *(.mem##sec)
 #endif
 
+#define CONSTRUCTORS							\
+		VMLINUX_SYMBOL(__ctor_start) = .;			\
+		*(.ctors)						\
+		VMLINUX_SYMBOL(__ctor_end) = .;
 
 /* .data section */
 #define DATA_DATA							\
@@ -55,7 +59,8 @@
 	VMLINUX_SYMBOL(__stop___markers) = .;				\
 	VMLINUX_SYMBOL(__start___tracepoints) = .;			\
 	*(__tracepoints)						\
-	VMLINUX_SYMBOL(__stop___tracepoints) = .;
+	VMLINUX_SYMBOL(__stop___tracepoints) = .;			\
+	CONSTRUCTORS
 
 #define RO_DATA(align)							\
 	. = ALIGN((align));						\
@@ -422,8 +427,3 @@
 	}								\
 	VMLINUX_SYMBOL(__per_cpu_end) = .;
 #endif
-
-#define CONSTRUCTORS							\
-		VMLINUX_SYMBOL(__ctor_start) = .;			\
-		*(.ctors)						\
-		VMLINUX_SYMBOL(__ctor_end) = .;
