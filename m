Return-Path: <linux-kernel-owner+w=401wt.eu-S1759703AbZGHJ1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759703AbZGHJ1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 05:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758836AbZGHJ1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 05:27:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:48385 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758829AbZGHJ1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 05:27:38 -0400
Message-ID: <4A546670.6070701@kernel.org>
Date: Wed, 08 Jul 2009 18:27:12 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Michal Simek <monstr@monstr.eu>, microblaze-uclinux@itee.uq.edu.au,
       Sam Ravnborg <sam@ravnborg.org>, Paul Mundt <lethal@linux-sh.org>,
       Tony Luck <tony.luck@intel.com>, Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH 2/2] linker script: unify usage of discard definition
References: <4A546646.70305@kernel.org>
In-Reply-To: <4A546646.70305@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 08 Jul 2009 09:27:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Discarded sections in different archs share some commonality but have
considerable differences.  This led to linker script for each arch
implementing its own /DISCARD/ definition, which makes maintaining
tedious and adding new entries error-prone.

This patch makes all linker scripts to move discard definitions to the
end of the linker script and use the common DISCARDS macro.  As ld
uses the first matching section definition, archs can include default
discarded sections by including them earlier in the linker script.

ia64 is notable because it first throws away some ia64 specific
subsections and then include the rest of the sections into the final
image, so those sections must be discarded before the inclusion.

defconfig compile tested for x86, x86-64, powerpc, powerpc64, ia64,
alpha, sparc, sparc64 and s390.  Michal Simek tested microblaze.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Acked-by: Mike Frysinger <vapier@gentoo.org>
Tested-by: Michal Simek <monstr@monstr.eu>
Cc: linux-arch@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>
Cc: microblaze-uclinux@itee.uq.edu.au
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Tony Luck <tony.luck@intel.com>
---
ia64 needed some massaging to get it working.

 arch/alpha/kernel/vmlinux.lds.S      |   10 ++--------
 arch/avr32/kernel/vmlinux.lds.S      |   10 +++-------
 arch/blackfin/kernel/vmlinux.lds.S   |    6 +-----
 arch/cris/kernel/vmlinux.lds.S       |   10 ++--------
 arch/frv/kernel/vmlinux.lds.S        |    2 +-
 arch/h8300/kernel/vmlinux.lds.S      |    6 ++----
 arch/ia64/kernel/vmlinux.lds.S       |   17 ++++++++---------
 arch/m32r/kernel/vmlinux.lds.S       |   11 +++--------
 arch/m68k/kernel/vmlinux-std.lds     |   11 +++--------
 arch/m68k/kernel/vmlinux-sun3.lds    |   10 ++--------
 arch/m68knommu/kernel/vmlinux.lds.S  |    8 +-------
 arch/microblaze/kernel/vmlinux.lds.S |    2 +-
 arch/mips/kernel/vmlinux.lds.S       |   22 ++++++++++------------
 arch/mn10300/kernel/vmlinux.lds.S    |    9 +++------
 arch/parisc/kernel/vmlinux.lds.S     |    9 ++++-----
 arch/powerpc/kernel/vmlinux.lds.S    |   10 +++-------
 arch/s390/kernel/vmlinux.lds.S       |   10 +++-------
 arch/sh/kernel/vmlinux.lds.S         |   11 ++++-------
 arch/sparc/kernel/vmlinux.lds.S      |    9 ++-------
 arch/um/include/asm/common.lds.S     |    5 -----
 arch/um/kernel/dyn.lds.S             |    2 +-
 arch/um/kernel/uml.lds.S             |    2 +-
 arch/x86/kernel/vmlinux.lds.S        |   11 ++++-------
 arch/xtensa/kernel/vmlinux.lds.S     |   14 ++++----------
 include/asm-generic/vmlinux.lds.h    |   18 ++++++++++++------
 25 files changed, 80 insertions(+), 155 deletions(-)

Index: work/arch/alpha/kernel/vmlinux.lds.S
===================================================================
--- work.orig/arch/alpha/kernel/vmlinux.lds.S
+++ work/arch/alpha/kernel/vmlinux.lds.S
@@ -134,14 +134,6 @@ SECTIONS
 	__bss_stop = .;
 	_end = .;
 
-	/* Sections to be discarded */
-	/DISCARD/ : {
-		EXIT_TEXT
-		EXIT_DATA
-		*(.exitcall.exit)
-		*(.discard)
-	}
-
 	.mdebug 0 : {
 		*(.mdebug)
 	}
@@ -151,4 +143,6 @@ SECTIONS
 
 	STABS_DEBUG
 	DWARF_DEBUG
+
+	DISCARDS
 }
Index: work/arch/avr32/kernel/vmlinux.lds.S
===================================================================
--- work.orig/arch/avr32/kernel/vmlinux.lds.S
+++ work/arch/avr32/kernel/vmlinux.lds.S
@@ -124,15 +124,11 @@ SECTIONS
 		_end = .;
 	}
 
+	DWARF_DEBUG
+
 	/* When something in the kernel is NOT compiled as a module, the module
 	 * cleanup code and data are put into these segments. Both can then be
 	 * thrown away, as cleanup code is never called unless it's a module.
 	 */
-	/DISCARD/       	: {
-		EXIT_DATA
-		*(.exitcall.exit)
-		*(.discard)
-	}
-
-	DWARF_DEBUG
+	DISCARDS
 }
Index: work/arch/blackfin/kernel/vmlinux.lds.S
===================================================================
--- work.orig/arch/blackfin/kernel/vmlinux.lds.S
+++ work/arch/blackfin/kernel/vmlinux.lds.S
@@ -277,9 +277,5 @@ SECTIONS
 
 	DWARF_DEBUG
 
-	/DISCARD/ :
-	{
-		*(.exitcall.exit)
-		*(.discard)
-	}
+	DISCARDS
 }
Index: work/arch/cris/kernel/vmlinux.lds.S
===================================================================
--- work.orig/arch/cris/kernel/vmlinux.lds.S
+++ work/arch/cris/kernel/vmlinux.lds.S
@@ -140,13 +140,7 @@ SECTIONS
 	_end = .;
 	__end = .;
 
-	/* Sections to be discarded */
-	/DISCARD/ : {
-		EXIT_TEXT
-		EXIT_DATA
-		*(.exitcall.exit)
-		*(.discard)
-        }
-
 	dram_end = dram_start + (CONFIG_ETRAX_DRAM_SIZE - __CONFIG_ETRAX_VMEM_SIZE)*1024*1024;
+
+	DISCARDS
 }
Index: work/arch/frv/kernel/vmlinux.lds.S
===================================================================
--- work.orig/arch/frv/kernel/vmlinux.lds.S
+++ work/arch/frv/kernel/vmlinux.lds.S
@@ -178,7 +178,7 @@ SECTIONS
 
   .comment 0 : { *(.comment) }
 
-  /DISCARD/ : { *(.discard) }
+  DISCARDS
 }
 
 __kernel_image_size_no_bss = __bss_start - __kernel_image_start;
Index: work/arch/h8300/kernel/vmlinux.lds.S
===================================================================
--- work.orig/arch/h8300/kernel/vmlinux.lds.S
+++ work/arch/h8300/kernel/vmlinux.lds.S
@@ -152,10 +152,6 @@ SECTIONS
 	__end = . ;
 	__ramstart = .;
 	}
-	/DISCARD/ : {
-		*(.exitcall.exit)
-		*(.discard)
-	}
         .romfs :	
 	{
 		*(.romfs*)
@@ -166,4 +162,6 @@ SECTIONS
 	COMMAND_START = . - 0x200 ;
 	__ramend = . ;
 	}
+
+	DISCARDS
 }
Index: work/arch/ia64/kernel/vmlinux.lds.S
===================================================================
--- work.orig/arch/ia64/kernel/vmlinux.lds.S
+++ work/arch/ia64/kernel/vmlinux.lds.S
@@ -24,15 +24,14 @@ PHDRS {
 }
 SECTIONS
 {
-  /* Sections to be discarded */
+  /* unwind exit sections must be discarded before the rest of the
+     sections get included. */
   /DISCARD/ : {
-	EXIT_TEXT
-	EXIT_DATA
-	*(.exitcall.exit)
-	*(.discard)
 	*(.IA_64.unwind.exit.text)
 	*(.IA_64.unwind_info.exit.text)
-	}
+	*(.comment)
+	*(.note)
+  }
 
   v = PAGE_OFFSET;	/* this symbol is here to make debugging easier... */
   phys_start = _start - LOAD_OFFSET;
@@ -317,7 +316,7 @@ SECTIONS
   .debug_funcnames 0 : { *(.debug_funcnames) }
   .debug_typenames 0 : { *(.debug_typenames) }
   .debug_varnames  0 : { *(.debug_varnames) }
-  /* These must appear regardless of  .  */
-  /DISCARD/ : { *(.comment) }
-  /DISCARD/ : { *(.note) }
+
+  /* Default discards */
+  DISCARDS
 }
Index: work/arch/m32r/kernel/vmlinux.lds.S
===================================================================
--- work.orig/arch/m32r/kernel/vmlinux.lds.S
+++ work/arch/m32r/kernel/vmlinux.lds.S
@@ -120,14 +120,6 @@ SECTIONS
 
   _end = . ;
 
-  /* Sections to be discarded */
-  /DISCARD/ : {
-	EXIT_TEXT
-	EXIT_DATA
-	*(.exitcall.exit)
-	*(.discard)
-	}
-
   /* Stabs debugging sections.  */
   .stab 0 : { *(.stab) }
   .stabstr 0 : { *(.stabstr) }
@@ -136,4 +128,7 @@ SECTIONS
   .stab.index 0 : { *(.stab.index) }
   .stab.indexstr 0 : { *(.stab.indexstr) }
   .comment 0 : { *(.comment) }
+
+  /* Sections to be discarded */
+  DISCARDS
 }
Index: work/arch/m68knommu/kernel/vmlinux.lds.S
===================================================================
--- work.orig/arch/m68knommu/kernel/vmlinux.lds.S
+++ work/arch/m68knommu/kernel/vmlinux.lds.S
@@ -184,13 +184,6 @@ SECTIONS {
 		__init_end = .;
 	} > INIT
 
-	/DISCARD/ : {
-		EXIT_TEXT
-		EXIT_DATA
-		*(.exitcall.exit)
-		*(.discard)
-	}
-
 	.bss : {
 		. = ALIGN(4);
 		_sbss = . ;
@@ -201,5 +194,6 @@ SECTIONS {
 	 	_end = . ;
 	} > BSS
 
+	DISCARDS
 }
 
Index: work/arch/microblaze/kernel/vmlinux.lds.S
===================================================================
--- work.orig/arch/microblaze/kernel/vmlinux.lds.S
+++ work/arch/microblaze/kernel/vmlinux.lds.S
@@ -163,5 +163,5 @@ SECTIONS {
 	. = ALIGN(4096);
 	_end = .;
 
-	/DISCARD/ : { *(.discard) }
+	DISCARDS
 }
Index: work/arch/mips/kernel/vmlinux.lds.S
===================================================================
--- work.orig/arch/mips/kernel/vmlinux.lds.S
+++ work/arch/mips/kernel/vmlinux.lds.S
@@ -176,18 +176,6 @@ SECTIONS
 
 	_end = . ;
 
-	/* Sections to be discarded */
-	/DISCARD/ : {
-		*(.exitcall.exit)
-		*(.discard)
-
-		/* ABI crap starts here */
-		*(.MIPS.options)
-		*(.options)
-		*(.pdr)
-		*(.reginfo)
-	}
-
 	/* These mark the ABI of the kernel for debuggers.  */
 	.mdebug.abi32 : {
 		KEEP(*(.mdebug.abi32))
@@ -213,4 +201,14 @@ SECTIONS
 		*(.gptab.bss)
 		*(.gptab.sbss)
 	}
+
+	/* Sections to be discarded */
+	DISCARDS
+	/DISCARD/ : {
+		/* ABI crap starts here */
+		*(.MIPS.options)
+		*(.options)
+		*(.pdr)
+		*(.reginfo)
+	}
 }
Index: work/arch/mn10300/kernel/vmlinux.lds.S
===================================================================
--- work.orig/arch/mn10300/kernel/vmlinux.lds.S
+++ work/arch/mn10300/kernel/vmlinux.lds.S
@@ -115,13 +115,10 @@ SECTIONS
   . = ALIGN(PAGE_SIZE);
   pg0 = .;
 
-  /* Sections to be discarded */
-  /DISCARD/ : {
-	EXIT_CALL
-	*(.discard)
-	}
-
   STABS_DEBUG
 
   DWARF_DEBUG
+
+  /* Sections to be discarded */
+  DISCARDS
 }
Index: work/arch/parisc/kernel/vmlinux.lds.S
===================================================================
--- work.orig/arch/parisc/kernel/vmlinux.lds.S
+++ work/arch/parisc/kernel/vmlinux.lds.S
@@ -237,10 +237,12 @@ SECTIONS
 	/* freed after init ends here */
 	_end = . ;
 
+	STABS_DEBUG
+	.note 0 : { *(.note) }
+
 	/* Sections to be discarded */
+	DISCARDS
 	/DISCARD/ : {
-		*(.exitcall.exit)
-		*(.discard)
 #ifdef CONFIG_64BIT
 		/* temporary hack until binutils is fixed to not emit these
 	 	 * for static binaries
@@ -253,7 +255,4 @@ SECTIONS
 		*(.gnu.hash)
 #endif
 	}
-
-	STABS_DEBUG
-	.note 0 : { *(.note) }	
 }
Index: work/arch/powerpc/kernel/vmlinux.lds.S
===================================================================
--- work.orig/arch/powerpc/kernel/vmlinux.lds.S
+++ work/arch/powerpc/kernel/vmlinux.lds.S
@@ -37,13 +37,6 @@ jiffies = jiffies_64 + 4;
 #endif
 SECTIONS
 {
-	/* Sections to be discarded. */
-	/DISCARD/ : {
-	*(.exitcall.exit)
-	*(.discard)
-	EXIT_DATA
-	}
-
 	. = KERNELBASE;
 
 /*
@@ -299,4 +292,7 @@ SECTIONS
 	. = ALIGN(PAGE_SIZE);
 	_end = . ;
 	PROVIDE32 (end = .);
+
+	/* Sections to be discarded. */
+	DISCARDS
 }
Index: work/arch/s390/kernel/vmlinux.lds.S
===================================================================
--- work.orig/arch/s390/kernel/vmlinux.lds.S
+++ work/arch/s390/kernel/vmlinux.lds.S
@@ -157,14 +157,10 @@ SECTIONS
 
 	_end = . ;
 
-	/* Sections to be discarded */
-	/DISCARD/ : {
-		EXIT_DATA
-		*(.exitcall.exit)
-		*(.discard)
-	}
-
 	/* Debugging sections.	*/
 	STABS_DEBUG
 	DWARF_DEBUG
+
+	/* Sections to be discarded */
+	DISCARDS
 }
Index: work/arch/sh/kernel/vmlinux.lds.S
===================================================================
--- work.orig/arch/sh/kernel/vmlinux.lds.S
+++ work/arch/sh/kernel/vmlinux.lds.S
@@ -163,17 +163,14 @@ SECTIONS
 		_end = . ;
 	}
 
+	STABS_DEBUG
+	DWARF_DEBUG
+
 	/*
 	 * When something in the kernel is NOT compiled as a module, the
 	 * module cleanup code and data are put into these segments. Both
 	 * can then be thrown away, as cleanup code is never called unless
 	 * it's a module.
 	 */
-	/DISCARD/ : {
-		*(.exitcall.exit)
-		*(.discard)
-	}
-
-	STABS_DEBUG
-	DWARF_DEBUG
+	DISCARDS
 }
Index: work/arch/sparc/kernel/vmlinux.lds.S
===================================================================
--- work.orig/arch/sparc/kernel/vmlinux.lds.S
+++ work/arch/sparc/kernel/vmlinux.lds.S
@@ -171,13 +171,8 @@ SECTIONS
 	}
 	_end = . ;
 
-	/DISCARD/ : {
-		EXIT_TEXT
-		EXIT_DATA
-		*(.exitcall.exit)
-		*(.discard)
-	}
-
 	STABS_DEBUG
 	DWARF_DEBUG
+
+	DISCARDS
 }
Index: work/arch/x86/kernel/vmlinux.lds.S
===================================================================
--- work.orig/arch/x86/kernel/vmlinux.lds.S
+++ work/arch/x86/kernel/vmlinux.lds.S
@@ -387,15 +387,12 @@ SECTIONS
 		_end = .;
 	}
 
-	/* Sections to be discarded */
-	/DISCARD/ : {
-		*(.exitcall.exit)
-		*(.eh_frame)
-		*(.discard)
-	}
-
         STABS_DEBUG
         DWARF_DEBUG
+
+	/* Sections to be discarded */
+	DISCARDS
+	/DISCARD/ : { *(.eh_frame) }
 }
 
 
Index: work/arch/xtensa/kernel/vmlinux.lds.S
===================================================================
--- work.orig/arch/xtensa/kernel/vmlinux.lds.S
+++ work/arch/xtensa/kernel/vmlinux.lds.S
@@ -280,16 +280,6 @@ SECTIONS
     *(.ResetVector.text)
   }
 
-  /* Sections to be discarded */
-  /DISCARD/ :
-  {
-	*(.exit.literal)
-	EXIT_TEXT
-	EXIT_DATA
-        *(.exitcall.exit)
-	*(.discard)
-  }
-
   .xt.lit : { *(.xt.lit) }
   .xt.prop : { *(.xt.prop) }
 
@@ -322,4 +312,8 @@ SECTIONS
     *(.xt.lit)
     *(.gnu.linkonce.p*)
   }
+
+  /* Sections to be discarded */
+  DISCARDS
+  /DISCARD/ : { *(.exit.literal) }
 }
Index: work/include/asm-generic/vmlinux.lds.h
===================================================================
--- work.orig/include/asm-generic/vmlinux.lds.h
+++ work/include/asm-generic/vmlinux.lds.h
@@ -35,13 +35,10 @@
  *	__bss_stop = .;
  *	_end = .;
  *
- *	/DISCARD/ : {
- *		EXIT_TEXT
- *		EXIT_DATA
- *		EXIT_CALL
- *	}
  *	STABS_DEBUG
  *	DWARF_DEBUG
+ *
+ *	DISCARDS		// must be the last
  * }
  *
  * [__init_begin, __init_end] is the init section that may be freed after init
@@ -629,11 +626,20 @@
 #define INIT_RAM_FS
 #endif
 
+/*
+ * Default discarded sections.
+ *
+ * Some archs want to discard exit text/data at runtime rather than
+ * link time due to cross-section references such as alt instructions,
+ * bug table, eh_frame, etc.  DISCARDS must be the last of output
+ * section definitions so that such archs put those in earlier section
+ * definitions.
+ */
 #define DISCARDS							\
 	/DISCARD/ : {							\
 	EXIT_TEXT							\
 	EXIT_DATA							\
-	*(.exitcall.exit)						\
+	EXIT_CALL							\
 	*(.discard)							\
 	}
 
Index: work/arch/m68k/kernel/vmlinux-std.lds
===================================================================
--- work.orig/arch/m68k/kernel/vmlinux-std.lds
+++ work/arch/m68k/kernel/vmlinux-std.lds
@@ -82,14 +82,6 @@ SECTIONS
 
   _end = . ;
 
-  /* Sections to be discarded */
-  /DISCARD/ : {
-	EXIT_TEXT
-	EXIT_DATA
-	*(.exitcall.exit)
-	*(.discard)
-	}
-
   /* Stabs debugging sections.  */
   .stab 0 : { *(.stab) }
   .stabstr 0 : { *(.stabstr) }
@@ -98,4 +90,7 @@ SECTIONS
   .stab.index 0 : { *(.stab.index) }
   .stab.indexstr 0 : { *(.stab.indexstr) }
   .comment 0 : { *(.comment) }
+
+  /* Sections to be discarded */
+  DISCARDS
 }
Index: work/arch/m68k/kernel/vmlinux-sun3.lds
===================================================================
--- work.orig/arch/m68k/kernel/vmlinux-sun3.lds
+++ work/arch/m68k/kernel/vmlinux-sun3.lds
@@ -77,14 +77,6 @@ __init_begin = .;
 
   _end = . ;
 
-  /* Sections to be discarded */
-  /DISCARD/ : {
-	EXIT_TEXT
-	EXIT_DATA
-	*(.exitcall.exit)
-	*(.discard)
-	}
-
   .crap : {
 	/* Stabs debugging sections.  */
 	*(.stab)
@@ -97,4 +89,6 @@ __init_begin = .;
 	*(.note)
   }
 
+  /* Sections to be discarded */
+  DISCARDS
 }
Index: work/arch/um/include/asm/common.lds.S
===================================================================
--- work.orig/arch/um/include/asm/common.lds.S
+++ work/arch/um/include/asm/common.lds.S
@@ -123,8 +123,3 @@
 	__initramfs_end = .;
   }
 
-  /* Sections to be discarded */
-  /DISCARD/ : {
- 	*(.exitcall.exit)
-  }
-
Index: work/arch/um/kernel/dyn.lds.S
===================================================================
--- work.orig/arch/um/kernel/dyn.lds.S
+++ work/arch/um/kernel/dyn.lds.S
@@ -157,5 +157,5 @@ SECTIONS
 
   DWARF_DEBUG
 
-  /DISCARD/	: { *(.discard) }
+  DISCARDS
 }
Index: work/arch/um/kernel/uml.lds.S
===================================================================
--- work.orig/arch/um/kernel/uml.lds.S
+++ work/arch/um/kernel/uml.lds.S
@@ -101,5 +101,5 @@ SECTIONS
 
   DWARF_DEBUG
 
-  /DISCARD/	: { *(.discard) }
+  DISCARDS
 }
