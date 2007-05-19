Return-Path: <linux-kernel-owner+w=401wt.eu-S1762510AbXESIE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762510AbXESIE5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 04:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754078AbXESIEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 04:04:42 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:35099 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403AbXESIEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 04:04:35 -0400
Date: Sat, 19 May 2007 10:05:32 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PATCHES] kbuild fixes for -rc2
Message-ID: <20070519080532.GA22031@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

This is a number of kbuild fixes queued up for -rc.
The majority of the fixes are related to section mismatch
warnings. With these fixes we can now on the callee site
control if warnings should be issued or not.
There is also a number of patches that just improve the
readability of the warnings.
With these patches included we get rid of the most noisy
section mismatch warnings and a i386 and x86_64 defconfig
build is now section mismatch warning free.

For powerpc one important patch are included to fix MODALIAS handling.

A few patches improve portability of code in scripts/.

In general all low-risk patches.
Patches has been reviewed at lkml and on linux-arch.
Please apply.

	Sam

The following changes since commit 55b637c6a003a8c4850b41a2c2fd6942d8a7f530:
  Linus Torvalds (1):
        Linux v2.6.22-rc2

are found in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-fix.git

Atsushi Nemoto (1):
      kbuild: make better section mismatch reports on i386, arm and mips

Li Yang (1):
      kbuild: add "Section mismatch" warning whitelist for powerpc

Mike Frysinger (2):
      kbuild: include limits.h in sumversion.c for PATH_MAX
      kconfig: search harder for curses library in check-lxdialog.sh

Russell King (1):
      kbuild: make modpost section warnings clearer

Sam Ravnborg (6):
      all-archs: consolidate .text section definition in asm-generic
      all-archs: consolidate .data section definition in asm-generic
      kbuild: introduce __init_refok/__initdata_refok to supress section mismatch warnings
      init/main: use __init_refok to fix section mismatch
      mm: fix section mismatch warnings
      mm/slab: fix section mismatch warning

Sylvain Munaut (1):
      powerpc: Fix the MODALIAS generation in modpost for of devices

 arch/alpha/kernel/vmlinux.lds.S            |    4 +-
 arch/arm/kernel/vmlinux.lds.S              |    4 +-
 arch/arm26/kernel/vmlinux-arm26-xip.lds.in |    4 +-
 arch/arm26/kernel/vmlinux-arm26.lds.in     |    4 +-
 arch/avr32/kernel/vmlinux.lds.c            |    4 +-
 arch/blackfin/kernel/vmlinux.lds.S         |    4 +-
 arch/frv/kernel/vmlinux.lds.S              |    6 +-
 arch/h8300/kernel/vmlinux.lds.S            |    4 +-
 arch/i386/kernel/vmlinux.lds.S             |    4 +-
 arch/ia64/kernel/vmlinux.lds.S             |    9 +-
 arch/m32r/kernel/vmlinux.lds.S             |    4 +-
 arch/m68k/kernel/vmlinux-std.lds           |    4 +-
 arch/m68k/kernel/vmlinux-sun3.lds          |    4 +-
 arch/m68knommu/kernel/vmlinux.lds.S        |    4 +-
 arch/mips/kernel/vmlinux.lds.S             |    4 +-
 arch/parisc/kernel/vmlinux.lds.S           |    4 +-
 arch/powerpc/kernel/vmlinux.lds.S          |    5 +-
 arch/ppc/kernel/vmlinux.lds.S              |    4 +-
 arch/s390/kernel/vmlinux.lds.S             |    4 +-
 arch/sh/kernel/vmlinux.lds.S               |    4 +-
 arch/sh64/kernel/vmlinux.lds.S             |    4 +-
 arch/sparc/kernel/vmlinux.lds.S            |    4 +-
 arch/sparc64/kernel/vmlinux.lds.S          |    4 +-
 arch/um/kernel/dyn.lds.S                   |    5 +-
 arch/um/kernel/uml.lds.S                   |    4 +-
 arch/v850/kernel/vmlinux.lds.S             |    4 +-
 arch/x86_64/kernel/vmlinux.lds.S           |    4 +-
 arch/xtensa/kernel/vmlinux.lds.S           |    6 +-
 include/asm-generic/vmlinux.lds.h          |   12 ++
 include/linux/init.h                       |   13 ++
 init/main.c                                |    2 +-
 mm/page_alloc.c                            |    4 +-
 mm/slab.c                                  |    2 +-
 mm/sparse.c                                |    2 +-
 scripts/kconfig/lxdialog/check-lxdialog.sh |   24 ++---
 scripts/mod/file2alias.c                   |   11 ++-
 scripts/mod/modpost.c                      |  169 +++++++++++++++++++---------
 scripts/mod/modpost.h                      |    3 +
 scripts/mod/sumversion.c                   |    1 +
 39 files changed, 234 insertions(+), 132 deletions(-)
diff --git a/arch/alpha/kernel/vmlinux.lds.S b/arch/alpha/kernel/vmlinux.lds.S
index cf1e6fc..449e76f 100644
--- a/arch/alpha/kernel/vmlinux.lds.S
+++ b/arch/alpha/kernel/vmlinux.lds.S
@@ -15,7 +15,7 @@ SECTIONS
 
   _text = .;					/* Text and read-only data */
   .text : { 
-	*(.text) 
+	TEXT_TEXT
 	SCHED_TEXT
 	LOCK_TEXT
 	*(.fixup)
@@ -89,7 +89,7 @@ SECTIONS
 
   _data = .;
   .data : {					/* Data */
-	*(.data)
+	DATA_DATA
 	CONSTRUCTORS
   }
 
diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index e4156e7..2b7a8f5 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -90,7 +90,7 @@ SECTIONS
 			__exception_text_start = .;
 			*(.exception.text)
 			__exception_text_end = .;
-			*(.text)
+			TEXT_TEXT
 			SCHED_TEXT
 			LOCK_TEXT
 #ifdef CONFIG_MMU
@@ -158,7 +158,7 @@ SECTIONS
 		/*
 		 * and the usual data section
 		 */
-		*(.data)
+		DATA_DATA
 		CONSTRUCTORS
 
 		_edata = .;
diff --git a/arch/arm26/kernel/vmlinux-arm26-xip.lds.in b/arch/arm26/kernel/vmlinux-arm26-xip.lds.in
index 046a850..4ec715c 100644
--- a/arch/arm26/kernel/vmlinux-arm26-xip.lds.in
+++ b/arch/arm26/kernel/vmlinux-arm26-xip.lds.in
@@ -64,7 +64,7 @@ SECTIONS
 
 	.text : {			/* Real text segment		*/
 		_text = .;		/* Text and read-only data	*/
-			*(.text)
+			TEXT_TEXT
 			SCHED_TEXT
 			LOCK_TEXT       /* FIXME - borrowed from arm32 - check*/
 			*(.fixup)
@@ -111,7 +111,7 @@ SECTIONS
 		/*
 		 * and the usual data section
 		 */
-		*(.data)
+		DATA_DATA
 		CONSTRUCTORS
 
 		*(.init.data)
diff --git a/arch/arm26/kernel/vmlinux-arm26.lds.in b/arch/arm26/kernel/vmlinux-arm26.lds.in
index 1d2949e..6c44f6a 100644
--- a/arch/arm26/kernel/vmlinux-arm26.lds.in
+++ b/arch/arm26/kernel/vmlinux-arm26.lds.in
@@ -65,7 +65,7 @@ SECTIONS
 
 	.text : {			/* Real text segment		*/
 		_text = .;		/* Text and read-only data	*/
-			*(.text)
+			TEXT_TEXT
 			SCHED_TEXT
 			LOCK_TEXT
 			*(.fixup)
@@ -106,7 +106,7 @@ SECTIONS
 		/*
 		 * and the usual data section
 		 */
-		*(.data)
+		DATA_DATA
 		CONSTRUCTORS
 
 		_edata = .;
diff --git a/arch/avr32/kernel/vmlinux.lds.c b/arch/avr32/kernel/vmlinux.lds.c
index e7f72c9..db0438f 100644
--- a/arch/avr32/kernel/vmlinux.lds.c
+++ b/arch/avr32/kernel/vmlinux.lds.c
@@ -76,7 +76,7 @@ SECTIONS
 		. = 0x100;
 		*(.scall.text)
 		*(.irq.text)
-		*(.text)
+		TEXT_TEXT
 		SCHED_TEXT
 		LOCK_TEXT
 		KPROBES_TEXT
@@ -112,7 +112,7 @@ SECTIONS
 
 		/* And the rest... */
 		*(.data.rel*)
-		*(.data)
+		DATA_DATA
 		CONSTRUCTORS
 
 		_edata = .;
diff --git a/arch/blackfin/kernel/vmlinux.lds.S b/arch/blackfin/kernel/vmlinux.lds.S
index 6ae9ebb..86fe679 100644
--- a/arch/blackfin/kernel/vmlinux.lds.S
+++ b/arch/blackfin/kernel/vmlinux.lds.S
@@ -54,7 +54,7 @@ SECTIONS
 	{
 		 _text = .;
 		 __stext = .;
-		*(.text)
+		TEXT_TEXT
 		SCHED_TEXT
 		*(.text.lock)
 		. = ALIGN(16);
@@ -200,7 +200,7 @@ SECTIONS
 		 __sdata = .;
 		. = ALIGN(0x2000);
 		*(.data.init_task)
-		*(.data)
+		DATA_DATA
 
 		. = ALIGN(32);
 		*(.data.cacheline_aligned)
diff --git a/arch/frv/kernel/vmlinux.lds.S b/arch/frv/kernel/vmlinux.lds.S
index 28eae97..481dc13 100644
--- a/arch/frv/kernel/vmlinux.lds.S
+++ b/arch/frv/kernel/vmlinux.lds.S
@@ -101,13 +101,14 @@ SECTIONS
   _stext = .;
   .text : {
 	*(
-		.text.start .text .text.*
+		.text.start .text.*
 #ifdef CONFIG_DEBUG_INFO
 	.init.text
 	.exit.text
 	.exitcall.exit
 #endif
 	)
+	TEXT_TEXT
 	SCHED_TEXT
 	LOCK_TEXT
 	*(.fixup)
@@ -135,7 +136,8 @@ SECTIONS
 
   _sdata = .;
   .data : {			/* Data */
-	*(.data .data.*)
+	DATA_DATA
+	*(.data.*)
 	*(.exit.data)
 	CONSTRUCTORS
 	}
diff --git a/arch/h8300/kernel/vmlinux.lds.S b/arch/h8300/kernel/vmlinux.lds.S
index 65f1cdc..a2e72d4 100644
--- a/arch/h8300/kernel/vmlinux.lds.S
+++ b/arch/h8300/kernel/vmlinux.lds.S
@@ -75,7 +75,7 @@ SECTIONS
 	*(.int_redirect)
 #endif
 	__stext = . ;
-        	*(.text)
+	TEXT_TEXT
 	SCHED_TEXT
 	LOCK_TEXT
 	__etext = . ;
@@ -103,7 +103,7 @@ SECTIONS
 	. = ALIGN(0x2000) ;
 		*(.data.init_task)
 	. = ALIGN(0x4) ;
-		*(.data)
+		DATA_DATA
 	. = ALIGN(0x4) ;
 		*(.data.*)	
 
diff --git a/arch/i386/kernel/vmlinux.lds.S b/arch/i386/kernel/vmlinux.lds.S
index 80bec66..aa87b06 100644
--- a/arch/i386/kernel/vmlinux.lds.S
+++ b/arch/i386/kernel/vmlinux.lds.S
@@ -44,7 +44,7 @@ SECTIONS
 
   /* read-only */
   .text : AT(ADDR(.text) - LOAD_OFFSET) {
-	*(.text)
+	TEXT_TEXT
 	SCHED_TEXT
 	LOCK_TEXT
 	KPROBES_TEXT
@@ -74,7 +74,7 @@ SECTIONS
   /* writeable */
   . = ALIGN(4096);
   .data : AT(ADDR(.data) - LOAD_OFFSET) {	/* Data */
-	*(.data)
+	DATA_DATA
 	CONSTRUCTORS
 	} :data
 
diff --git a/arch/ia64/kernel/vmlinux.lds.S b/arch/ia64/kernel/vmlinux.lds.S
index 6923826..5a65965 100644
--- a/arch/ia64/kernel/vmlinux.lds.S
+++ b/arch/ia64/kernel/vmlinux.lds.S
@@ -44,7 +44,7 @@ SECTIONS
   .text : AT(ADDR(.text) - LOAD_OFFSET)
     {
 	IVT_TEXT
-	*(.text)
+	TEXT_TEXT
 	SCHED_TEXT
 	LOCK_TEXT
 	KPROBES_TEXT
@@ -214,7 +214,12 @@ SECTIONS
 
   data : { } :data
   .data : AT(ADDR(.data) - LOAD_OFFSET)
-	{ *(.data) *(.data1) *(.gnu.linkonce.d*) CONSTRUCTORS }
+	{
+		DATA_DATA
+		*(.data1)
+		*(.gnu.linkonce.d*)
+		CONSTRUCTORS
+	}
 
   . = ALIGN(16);	/* gp must be 16-byte aligned for exc. table */
   .got : AT(ADDR(.got) - LOAD_OFFSET)
diff --git a/arch/m32r/kernel/vmlinux.lds.S b/arch/m32r/kernel/vmlinux.lds.S
index 6c73bca..4e2d5b9 100644
--- a/arch/m32r/kernel/vmlinux.lds.S
+++ b/arch/m32r/kernel/vmlinux.lds.S
@@ -27,7 +27,7 @@ SECTIONS
   _text = .;			/* Text and read-only data */
   .boot : { *(.boot) } = 0
   .text : {
-	*(.text)
+	TEXT_TEXT
 	SCHED_TEXT
 	LOCK_TEXT
 	*(.fixup)
@@ -50,7 +50,7 @@ SECTIONS
   .data : {			/* Data */
 	*(.spu)
 	*(.spi)
-	*(.data)
+	DATA_DATA
 	CONSTRUCTORS
 	}
 
diff --git a/arch/m68k/kernel/vmlinux-std.lds b/arch/m68k/kernel/vmlinux-std.lds
index 437b4f8..78f1392 100644
--- a/arch/m68k/kernel/vmlinux-std.lds
+++ b/arch/m68k/kernel/vmlinux-std.lds
@@ -11,7 +11,7 @@ SECTIONS
   . = 0x1000;
   _text = .;			/* Text and read-only data */
   .text : {
-	*(.text)
+	TEXT_TEXT
 	SCHED_TEXT
 	LOCK_TEXT
 	*(.fixup)
@@ -28,7 +28,7 @@ SECTIONS
   _etext = .;			/* End of text section */
 
   .data : {			/* Data */
-	*(.data)
+	DATA_DATA
 	CONSTRUCTORS
 	}
 
diff --git a/arch/m68k/kernel/vmlinux-sun3.lds b/arch/m68k/kernel/vmlinux-sun3.lds
index 2868e20..c8999b2 100644
--- a/arch/m68k/kernel/vmlinux-sun3.lds
+++ b/arch/m68k/kernel/vmlinux-sun3.lds
@@ -12,7 +12,7 @@ SECTIONS
   _text = .;			/* Text and read-only data */
   .text : {
 	*(.head)
-	*(.text)
+	TEXT_TEXT
 	SCHED_TEXT
 	LOCK_TEXT
 	*(.fixup)
@@ -23,7 +23,7 @@ SECTIONS
   _etext = .;			/* End of text section */
 
   .data : {			/* Data */
-	*(.data)
+	DATA_DATA
 	CONSTRUCTORS
 	. = ALIGN(16);		/* Exception table */
 	__start___ex_table = .;
diff --git a/arch/m68knommu/kernel/vmlinux.lds.S b/arch/m68knommu/kernel/vmlinux.lds.S
index c86a1bf..07a0055 100644
--- a/arch/m68knommu/kernel/vmlinux.lds.S
+++ b/arch/m68knommu/kernel/vmlinux.lds.S
@@ -62,7 +62,7 @@ SECTIONS {
 	.text : {
 		_text = .;
 		_stext = . ;
-        	*(.text)
+		TEXT_TEXT
 		SCHED_TEXT
         	*(.text.lock)
 
@@ -133,7 +133,7 @@ SECTIONS {
 	.data DATA_ADDR : {
 		. = ALIGN(4);
 		_sdata = . ;
-		*(.data)
+		DATA_DATA
 		. = ALIGN(8192) ;
 		*(.data.init_task)
 		_edata = . ;
diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.S
index 043f637..9b9992c 100644
--- a/arch/mips/kernel/vmlinux.lds.S
+++ b/arch/mips/kernel/vmlinux.lds.S
@@ -27,7 +27,7 @@ SECTIONS
   /* read-only */
   _text = .;			/* Text and read-only data */
   .text : {
-    *(.text)
+    TEXT_TEXT
     SCHED_TEXT
     LOCK_TEXT
     *(.fixup)
@@ -62,7 +62,7 @@ SECTIONS
     . = ALIGN(_PAGE_SIZE);
     *(.data.init_task)
 
-    *(.data)
+    DATA_DATA
 
     CONSTRUCTORS
   }
diff --git a/arch/parisc/kernel/vmlinux.lds.S b/arch/parisc/kernel/vmlinux.lds.S
index c745859..4d96ba4 100644
--- a/arch/parisc/kernel/vmlinux.lds.S
+++ b/arch/parisc/kernel/vmlinux.lds.S
@@ -51,7 +51,7 @@ SECTIONS
 
   _text = .;			/* Text and read-only data */
   .text ALIGN(16) : {
-	*(.text)
+	TEXT_TEXT
 	SCHED_TEXT
 	LOCK_TEXT
 	*(.text.do_softirq)
@@ -91,7 +91,7 @@ SECTIONS
 
   . = ALIGN(L1_CACHE_BYTES);
   .data : {			/* Data */
-	*(.data)
+	DATA_DATA
 	CONSTRUCTORS
 	}
 
diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index 1320673..f7d7bf1 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -34,7 +34,8 @@ SECTIONS
 	/* Text and gots */
 	.text : {
 		_text = .;
-		*(.text .text.*)
+		*(.text.*)
+		TEXT_TEXT
 		SCHED_TEXT
 		LOCK_TEXT
 		KPROBES_TEXT
@@ -167,7 +168,7 @@ SECTIONS
 #ifdef CONFIG_PPC32
 	.data    :
 	{
-		*(.data)
+		DATA_DATA
 		*(.sdata)
 		*(.got.plt) *(.got)
 	}
diff --git a/arch/ppc/kernel/vmlinux.lds.S b/arch/ppc/kernel/vmlinux.lds.S
index 44cd128..19db874 100644
--- a/arch/ppc/kernel/vmlinux.lds.S
+++ b/arch/ppc/kernel/vmlinux.lds.S
@@ -32,7 +32,7 @@ SECTIONS
   .text      :
   {
     _text = .;
-    *(.text)
+    TEXT_TEXT
     SCHED_TEXT
     LOCK_TEXT
     *(.fixup)
@@ -67,7 +67,7 @@ SECTIONS
   . = ALIGN(4096);
   .data    :
   {
-    *(.data)
+    DATA_DATA
     *(.data1)
     *(.sdata)
     *(.sdata2)
diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index e9d3432..7158a80 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -21,7 +21,7 @@ SECTIONS
   . = 0x00000000;
   _text = .;			/* Text and read-only data */
   .text : {
-	*(.text)
+	TEXT_TEXT
 	SCHED_TEXT
 	LOCK_TEXT
 	KPROBES_TEXT
@@ -48,7 +48,7 @@ SECTIONS
   BUG_TABLE
 
   .data : {			/* Data */
-	*(.data)
+	DATA_DATA
 	CONSTRUCTORS
 	}
 
diff --git a/arch/sh/kernel/vmlinux.lds.S b/arch/sh/kernel/vmlinux.lds.S
index d83143c..4c5b57e 100644
--- a/arch/sh/kernel/vmlinux.lds.S
+++ b/arch/sh/kernel/vmlinux.lds.S
@@ -22,7 +22,7 @@ SECTIONS
 	*(.empty_zero_page)
 	} = 0
   .text : {
-	*(.text)
+	TEXT_TEXT
 	SCHED_TEXT
 	LOCK_TEXT
 	*(.fixup)
@@ -41,7 +41,7 @@ SECTIONS
   BUG_TABLE
 
   .data : {			/* Data */
-	*(.data)
+	DATA_DATA
 
  	 /* Align the initial ramdisk image (INITRD) on page boundaries. */
  	 . = ALIGN(PAGE_SIZE);
diff --git a/arch/sh64/kernel/vmlinux.lds.S b/arch/sh64/kernel/vmlinux.lds.S
index 4f9616f..02aea86 100644
--- a/arch/sh64/kernel/vmlinux.lds.S
+++ b/arch/sh64/kernel/vmlinux.lds.S
@@ -54,7 +54,7 @@ SECTIONS
 	} = 0
 
   .text : C_PHYS(.text) {
-	*(.text)
+	TEXT_TEXT
 	*(.text64)
         *(.text..SHmedia32)
 	SCHED_TEXT
@@ -78,7 +78,7 @@ SECTIONS
   _etext = .;			/* End of text section */
 
   .data : C_PHYS(.data) {			/* Data */
-	*(.data)
+	DATA_DATA
 	CONSTRUCTORS
 	}
 
diff --git a/arch/sparc/kernel/vmlinux.lds.S b/arch/sparc/kernel/vmlinux.lds.S
index f0bb6e6..f75a1b8 100644
--- a/arch/sparc/kernel/vmlinux.lds.S
+++ b/arch/sparc/kernel/vmlinux.lds.S
@@ -12,7 +12,7 @@ SECTIONS
   .text 0xf0004000 :
   {
     _text = .;
-    *(.text)
+    TEXT_TEXT
     SCHED_TEXT
     LOCK_TEXT
     *(.gnu.warning)
@@ -22,7 +22,7 @@ SECTIONS
   RODATA
   .data    :
   {
-    *(.data)
+    DATA_DATA
     CONSTRUCTORS
   }
   .data1   : { *(.data1) }
diff --git a/arch/sparc64/kernel/vmlinux.lds.S b/arch/sparc64/kernel/vmlinux.lds.S
index 13fa2a2..fb648de 100644
--- a/arch/sparc64/kernel/vmlinux.lds.S
+++ b/arch/sparc64/kernel/vmlinux.lds.S
@@ -14,7 +14,7 @@ SECTIONS
   .text 0x0000000000404000 :
   {
     _text = .;
-    *(.text)
+    TEXT_TEXT
     SCHED_TEXT
     LOCK_TEXT
     KPROBES_TEXT
@@ -27,7 +27,7 @@ SECTIONS
 
   .data    :
   {
-    *(.data)
+    DATA_DATA
     CONSTRUCTORS
   }
   .data1   : { *(.data1) }
diff --git a/arch/um/kernel/dyn.lds.S b/arch/um/kernel/dyn.lds.S
index 87a4e44..2454774 100644
--- a/arch/um/kernel/dyn.lds.S
+++ b/arch/um/kernel/dyn.lds.S
@@ -62,7 +62,7 @@ SECTIONS
   } =0x90909090
   .plt            : { *(.plt) }
   .text           : {
-    *(.text)
+    TEXT_TEXT
     SCHED_TEXT
     LOCK_TEXT
     *(.fixup)
@@ -99,7 +99,8 @@ SECTIONS
     *(.data.init_task)
     . = ALIGN(KERNEL_STACK_SIZE);
     *(.data.init_irqstack)
-    *(.data .data.* .gnu.linkonce.d.*)
+    DATA_DATA
+    *(.data.* .gnu.linkonce.d.*)
     SORT(CONSTRUCTORS)
   }
   .data1          : { *(.data1) }
diff --git a/arch/um/kernel/uml.lds.S b/arch/um/kernel/uml.lds.S
index bc59f97..307b937 100644
--- a/arch/um/kernel/uml.lds.S
+++ b/arch/um/kernel/uml.lds.S
@@ -37,7 +37,7 @@ SECTIONS
 
   .text      :
   {
-    *(.text)
+    TEXT_TEXT
     SCHED_TEXT
     LOCK_TEXT
     *(.fixup)
@@ -61,7 +61,7 @@ SECTIONS
     *(.data.init_task)
     . = ALIGN(KERNEL_STACK_SIZE);
     *(.data.init_irqstack)
-    *(.data)
+    DATA_DATA
     *(.gnu.linkonce.d*)
     CONSTRUCTORS
   }
diff --git a/arch/v850/kernel/vmlinux.lds.S b/arch/v850/kernel/vmlinux.lds.S
index 3563082..6172599 100644
--- a/arch/v850/kernel/vmlinux.lds.S
+++ b/arch/v850/kernel/vmlinux.lds.S
@@ -92,7 +92,7 @@
 #define TEXT_CONTENTS							      \
 		_text = .;						      \
 		__stext = . ;						      \
-        	*(.text)						      \
+		TEXT_TEXT						      \
 		SCHED_TEXT						      \
 			*(.exit.text)	/* 2.5 convention */		      \
 			*(.text.exit)	/* 2.4 convention */		      \
@@ -113,7 +113,7 @@
 /* Kernel data segment.  */
 #define DATA_CONTENTS							      \
 		__sdata = . ;						      \
-        	*(.data)						      \
+		DATA_DATA						      \
 			*(.exit.data)	/* 2.5 convention */		      \
 			*(.data.exit)	/* 2.4 convention */		      \
 		. = ALIGN (16) ;					      \
diff --git a/arch/x86_64/kernel/vmlinux.lds.S b/arch/x86_64/kernel/vmlinux.lds.S
index 88cfa50..dbccfda 100644
--- a/arch/x86_64/kernel/vmlinux.lds.S
+++ b/arch/x86_64/kernel/vmlinux.lds.S
@@ -31,7 +31,7 @@ SECTIONS
 	*(.bootstrap.text)
 	_stext = .;
 	/* Then the rest */
-	*(.text)
+	TEXT_TEXT
 	SCHED_TEXT
 	LOCK_TEXT
 	KPROBES_TEXT
@@ -55,7 +55,7 @@ SECTIONS
   . = ALIGN(PAGE_SIZE);        /* Align data segment to page size boundary */
 				/* Data */
   .data : AT(ADDR(.data) - LOAD_OFFSET) {
-	*(.data)
+	DATA_DATA
 	CONSTRUCTORS
 	} :data
 
diff --git a/arch/xtensa/kernel/vmlinux.lds.S b/arch/xtensa/kernel/vmlinux.lds.S
index 4fbd66a..4b7b4ff 100644
--- a/arch/xtensa/kernel/vmlinux.lds.S
+++ b/arch/xtensa/kernel/vmlinux.lds.S
@@ -84,7 +84,8 @@ SECTIONS
   {
     /* The .head.text section must be the first section! */
     *(.head.text)
-    *(.literal .text)
+    *(.literal)
+    TEXT_TEXT
     *(.srom.text)
     VMLINUX_SYMBOL(__sched_text_start) = .;
     *(.sched.literal .sched.text)
@@ -144,7 +145,8 @@ SECTIONS
   _fdata = .;
   .data :
   {
-    *(.data) CONSTRUCTORS
+    DATA_DATA
+    CONSTRUCTORS
     . = ALIGN(XCHAL_ICACHE_LINESIZE);
     *(.data.cacheline_aligned)
   }
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index f3806a7..8307b1b 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -9,6 +9,11 @@
 /* Align . to a 8 byte boundary equals to maximum function alignment. */
 #define ALIGN_FUNCTION()  . = ALIGN(8)
 
+/* .data section */
+#define DATA_DATA							\
+	*(.data)							\
+	*(.data.init.refok)
+
 #define RODATA								\
 	. = ALIGN(4096);						\
 	.rodata           : AT(ADDR(.rodata) - LOAD_OFFSET) {		\
@@ -139,6 +144,13 @@
 		VMLINUX_SYMBOL(__security_initcall_end) = .;		\
 	}
 
+/* .text section. Map to function alignment to avoid address changes
+ * during second ld run in second ld pass when generating System.map */
+#define TEXT_TEXT							\
+		ALIGN_FUNCTION();					\
+		*(.text)						\
+		*(.text.init.refok)
+
 /* sched.text is aling to function alignment to secure we have same
  * address even at second ld pass when generating System.map */
 #define SCHED_TEXT							\
diff --git a/include/linux/init.h b/include/linux/init.h
index e007ae4..56ec4c6 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -45,6 +45,19 @@
 #define __exitdata	__attribute__ ((__section__(".exit.data")))
 #define __exit_call	__attribute_used__ __attribute__ ((__section__ (".exitcall.exit")))
 
+/* modpost check for section mismatches during the kernel build.
+ * A section mismatch happens when there are references from a
+ * code or data section to an init section (both code or data).
+ * The init sections are (for most archs) discarded by the kernel
+ * when early init has completed so all such references are potential bugs.
+ * For exit sections the same issue exists.
+ * The following markers are used for the cases where the reference to
+ * the init/exit section (code or data) is valid and will teach modpost
+ * not to issue a warning.
+ * The markers follow same syntax rules as __init / __initdata. */
+#define __init_refok     noinline __attribute__ ((__section__ (".text.init.refok")))
+#define __initdata_refok          __attribute__ ((__section__ (".data.init.refok")))
+
 #ifdef MODULE
 #define __exit		__attribute__ ((__section__(".exit.text")))
 #else
diff --git a/init/main.c b/init/main.c
index 1940fa7..eb8bdba 100644
--- a/init/main.c
+++ b/init/main.c
@@ -423,7 +423,7 @@ static void __init setup_command_line(char *command_line)
  * gcc-3.4 accidentally inlines this function, so use noinline.
  */
 
-static void noinline rest_init(void)
+static void noinline __init_refok rest_init(void)
 	__releases(kernel_lock)
 {
 	int pid;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ae96dd8..8b000d6 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2165,7 +2165,7 @@ void __init setup_per_cpu_pageset(void)
 
 #endif
 
-static __meminit noinline
+static noinline __init_refok
 int zone_wait_table_init(struct zone *zone, unsigned long zone_size_pages)
 {
 	int i;
@@ -2678,7 +2678,7 @@ static void __meminit free_area_init_core(struct pglist_data *pgdat,
 	}
 }
 
-static void __meminit alloc_node_mem_map(struct pglist_data *pgdat)
+static void __init_refok alloc_node_mem_map(struct pglist_data *pgdat)
 {
 	/* Skip empty nodes */
 	if (!pgdat->node_spanned_pages)
diff --git a/mm/slab.c b/mm/slab.c
index 528243e..2e71a32 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2037,7 +2037,7 @@ static size_t calculate_slab_order(struct kmem_cache *cachep,
 	return left_over;
 }
 
-static int setup_cpu_cache(struct kmem_cache *cachep)
+static int __init_refok setup_cpu_cache(struct kmem_cache *cachep)
 {
 	if (g_cpucache_up == FULL)
 		return enable_cpucache(cachep);
diff --git a/mm/sparse.c b/mm/sparse.c
index 6f3fff9..1302f83 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -44,7 +44,7 @@ EXPORT_SYMBOL(page_to_nid);
 #endif
 
 #ifdef CONFIG_SPARSEMEM_EXTREME
-static struct mem_section noinline *sparse_index_alloc(int nid)
+static struct mem_section noinline __init_refok *sparse_index_alloc(int nid)
 {
 	struct mem_section *section = NULL;
 	unsigned long array_size = SECTIONS_PER_ROOT *
diff --git a/scripts/kconfig/lxdialog/check-lxdialog.sh b/scripts/kconfig/lxdialog/check-lxdialog.sh
index 120d624..cdca738 100644
--- a/scripts/kconfig/lxdialog/check-lxdialog.sh
+++ b/scripts/kconfig/lxdialog/check-lxdialog.sh
@@ -4,21 +4,15 @@
 # What library to link
 ldflags()
 {
-	$cc -print-file-name=libncursesw.so | grep -q /
-	if [ $? -eq 0 ]; then
-		echo '-lncursesw'
-		exit
-	fi
-	$cc -print-file-name=libncurses.so | grep -q /
-	if [ $? -eq 0 ]; then
-		echo '-lncurses'
-		exit
-	fi
-	$cc -print-file-name=libcurses.so | grep -q /
-	if [ $? -eq 0 ]; then
-		echo '-lcurses'
-		exit
-	fi
+	for ext in so a dylib ; do
+		for lib in ncursesw ncurses curses ; do
+			$cc -print-file-name=lib${lib}.${ext} | grep -q /
+			if [ $? -eq 0 ]; then
+				echo "-l${lib}"
+				exit
+			fi
+		done
+	done
 	exit 1
 }
 
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index ed1244d..f646381 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -353,11 +353,16 @@ static int do_pcmcia_entry(const char *filename,
 
 static int do_of_entry (const char *filename, struct of_device_id *of, char *alias)
 {
+    int len;
     char *tmp;
-    sprintf (alias, "of:N%sT%sC%s",
+    len = sprintf (alias, "of:N%sT%s",
                     of->name[0] ? of->name : "*",
-                    of->type[0] ? of->type : "*",
-                    of->compatible[0] ? of->compatible : "*");
+                    of->type[0] ? of->type : "*");
+
+    if (of->compatible[0])
+        sprintf (&alias[len], "%sC%s",
+                     of->type[0] ? "*" : "",
+                     of->compatible);
 
     /* Replace all whitespace with underscores */
     for (tmp = alias; tmp && *tmp; tmp++)
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 113dc77..8424d1f 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -384,6 +384,7 @@ static int parse_elf(struct elf_info *info, const char *filename)
 		sechdrs[i].sh_size   = TO_NATIVE(sechdrs[i].sh_size);
 		sechdrs[i].sh_link   = TO_NATIVE(sechdrs[i].sh_link);
 		sechdrs[i].sh_name   = TO_NATIVE(sechdrs[i].sh_name);
+		sechdrs[i].sh_info   = TO_NATIVE(sechdrs[i].sh_info);
 	}
 	/* Find symbol table. */
 	for (i = 1; i < hdr->e_shnum; i++) {
@@ -582,6 +583,12 @@ static int strrcmp(const char *s, const char *sub)
 
 /**
  * Whitelist to allow certain references to pass with no warning.
+ *
+ * Pattern 0:
+ *   Do not warn if funtion/data are marked with __init_refok/__initdata_refok.
+ *   The pattern is identified by:
+ *   fromsec = .text.init.refok | .data.init.refok
+ *
  * Pattern 1:
  *   If a module parameter is declared __initdata and permissions=0
  *   then this is legal despite the warning generated.
@@ -619,14 +626,6 @@ static int strrcmp(const char *s, const char *sub)
  *   This pattern is identified by
  *   refsymname = __init_begin, _sinittext, _einittext
  *
- * Pattern 6:
- *   During the early init phase we have references from .init.text to
- *   .text we have an intended section mismatch - do not warn about it.
- *   See kernel_init() in init/main.c
- *   tosec   = .init.text
- *   fromsec = .text
- *   atsym = kernel_init
- *
  * Pattern 7:
  *  Logos used in drivers/video/logo reside in __initdata but the
  *  funtion that references them are EXPORT_SYMBOL() so cannot be
@@ -642,16 +641,11 @@ static int strrcmp(const char *s, const char *sub)
  *  tosec   = .init.text
  *  fromsec  = .paravirtprobe
  *
- * Pattern 9:
- *  Some of functions are common code between boot time and hotplug
- *  time. The bootmem allocater is called only boot time in its
- *  functions. So it's ok to reference.
- *  tosec    = .init.text
- *
  * Pattern 10:
- *  ia64 has machvec table for each platform. It is mixture of function
- *  pointer of .init.text and .text.
- *  fromsec  = .machvec
+ *  ia64 has machvec table for each platform and
+ *  powerpc has a machine desc table for each platform.
+ *  It is mixture of function pointers of .init.text and .text.
+ *  fromsec  = .machvec | .machine.desc
  **/
 static int secref_whitelist(const char *modname, const char *tosec,
 			    const char *fromsec, const char *atsym,
@@ -678,11 +672,10 @@ static int secref_whitelist(const char *modname, const char *tosec,
 		NULL
 	};
 
-	const char *pat4sym[] = {
-		"sparse_index_alloc",
-		"zone_wait_table_init",
-		NULL
-	};
+	/* Check for pattern 0 */
+	if ((strcmp(fromsec, ".text.init.refok") == 0) ||
+	    (strcmp(fromsec, ".data.init.refok") == 0))
+		return 1;
 
 	/* Check for pattern 1 */
 	if (strcmp(tosec, ".init.data") != 0)
@@ -725,12 +718,6 @@ static int secref_whitelist(const char *modname, const char *tosec,
 		if (strcmp(refsymname, *s) == 0)
 			return 1;
 
-	/* Check for pattern 6 */
-	if ((strcmp(tosec, ".init.text") == 0) &&
-	    (strcmp(fromsec, ".text") == 0) &&
-	    (strcmp(refsymname, "kernel_init") == 0))
-		return 1;
-
 	/* Check for pattern 7 */
 	if ((strcmp(tosec, ".init.data") == 0) &&
 	    (strncmp(fromsec, ".text", strlen(".text")) == 0) &&
@@ -742,15 +729,9 @@ static int secref_whitelist(const char *modname, const char *tosec,
 	    (strcmp(fromsec, ".paravirtprobe") == 0))
 		return 1;
 
-	/* Check for pattern 9 */
-	if ((strcmp(tosec, ".init.text") == 0) &&
-	    (strcmp(fromsec, ".text") == 0))
-		for (s = pat4sym; *s; s++)
-			if (strcmp(atsym, *s) == 0)
-				return 1;
-
 	/* Check for pattern 10 */
-	if (strcmp(fromsec, ".machvec") == 0)
+	if ((strcmp(fromsec, ".machvec") == 0) ||
+	    (strcmp(fromsec, ".machine.desc") == 0))
 		return 1;
 
 	return 0;
@@ -773,6 +754,8 @@ static Elf_Sym *find_elf_symbol(struct elf_info *elf, Elf_Addr addr,
 	for (sym = elf->symtab_start; sym < elf->symtab_stop; sym++) {
 		if (sym->st_shndx != relsym->st_shndx)
 			continue;
+		if (ELF_ST_TYPE(sym->st_info) == STT_SECTION)
+			continue;
 		if (sym->st_value == addr)
 			return sym;
 	}
@@ -884,33 +867,99 @@ static void warn_sec_mismatch(const char *modname, const char *fromsec,
 			     elf->strtab + before->st_name, refsymname))
 		return;
 
+	/* fromsec whitelist - without a valid 'before'
+	 * powerpc has a GOT table in .got2 section */
+	if (strcmp(fromsec, ".got2") == 0)
+		return;
+
 	if (before && after) {
-		warn("%s - Section mismatch: reference to %s:%s from %s "
-		     "between '%s' (at offset 0x%llx) and '%s'\n",
-		     modname, secname, refsymname, fromsec,
+		warn("%s(%s+0x%llx): Section mismatch: reference to %s:%s "
+		     "(between '%s' and '%s')\n",
+		     modname, fromsec, (unsigned long long)r.r_offset,
+		     secname, refsymname,
 		     elf->strtab + before->st_name,
-		     (long long)r.r_offset,
 		     elf->strtab + after->st_name);
 	} else if (before) {
-		warn("%s - Section mismatch: reference to %s:%s from %s "
-		     "after '%s' (at offset 0x%llx)\n",
-		     modname, secname, refsymname, fromsec,
-		     elf->strtab + before->st_name,
-		     (long long)r.r_offset);
+		warn("%s(%s+0x%llx): Section mismatch: reference to %s:%s "
+		     "(after '%s')\n",
+		     modname, fromsec, (unsigned long long)r.r_offset,
+		     secname, refsymname,
+		     elf->strtab + before->st_name);
 	} else if (after) {
-		warn("%s - Section mismatch: reference to %s:%s from %s "
+		warn("%s(%s+0x%llx): Section mismatch: reference to %s:%s "
 		     "before '%s' (at offset -0x%llx)\n",
-		     modname, secname, refsymname, fromsec,
-		     elf->strtab + after->st_name,
-		     (long long)r.r_offset);
+		     modname, fromsec, (unsigned long long)r.r_offset,
+		     secname, refsymname,
+		     elf->strtab + after->st_name);
 	} else {
-		warn("%s - Section mismatch: reference to %s:%s from %s "
-		     "(offset 0x%llx)\n",
-		     modname, secname, fromsec, refsymname,
-		     (long long)r.r_offset);
+		warn("%s(%s+0x%llx): Section mismatch: reference to %s:%s\n",
+		     modname, fromsec, (unsigned long long)r.r_offset,
+		     secname, refsymname);
 	}
 }
 
+static void addend_386_rel(struct elf_info *elf, int section, Elf_Rela *r)
+{
+	Elf_Shdr *sechdrs = elf->sechdrs;
+	unsigned int r_typ;
+	unsigned int *location;
+
+	r_typ = ELF_R_TYPE(r->r_info);
+	location = (void *)elf->hdr +
+		sechdrs[sechdrs[section].sh_info].sh_offset + r->r_offset;
+	switch (r_typ) {
+	case R_386_32:
+		r->r_addend = TO_NATIVE(*location);
+		break;
+	case R_386_PC32:
+		r->r_addend = TO_NATIVE(*location) + 4;
+		break;
+	}
+}
+
+static void addend_arm_rel(struct elf_info *elf, int section, Elf_Rela *r)
+{
+	Elf_Shdr *sechdrs = elf->sechdrs;
+	unsigned int r_typ;
+	unsigned int *location;
+
+	r_typ = ELF_R_TYPE(r->r_info);
+	location = (void *)elf->hdr +
+		sechdrs[sechdrs[section].sh_info].sh_offset + r->r_offset;
+	switch (r_typ) {
+	case R_ARM_ABS32:
+		r->r_addend = TO_NATIVE(*location);
+		break;
+	case R_ARM_PC24:
+		r->r_addend = ((TO_NATIVE(*location) & 0x00ffffff) << 2) + 8;
+		break;
+	}
+}
+
+static int addend_mips_rel(struct elf_info *elf, int section, Elf_Rela *r)
+{
+	Elf_Shdr *sechdrs = elf->sechdrs;
+	unsigned int r_typ;
+	unsigned int *location;
+	unsigned int inst;
+
+	r_typ = ELF_R_TYPE(r->r_info);
+	if (r_typ == R_MIPS_HI16)
+		return 1;	/* skip this */
+	location = (void *)elf->hdr +
+		sechdrs[sechdrs[section].sh_info].sh_offset + r->r_offset;
+	inst = TO_NATIVE(*location);
+	switch (r_typ) {
+	case R_MIPS_LO16:
+		r->r_addend = ((inst & 0xffff) ^ 0x8000) - 0x8000;
+		break;
+	case R_MIPS_26:
+		r->r_addend = (inst & 0x03ffffff) << 2;
+		break;
+	}
+	return 0;
+}
+
 /**
  * A module includes a number of sections that are discarded
  * either when loaded or when used as built-in.
@@ -954,8 +1003,11 @@ static void check_sec_ref(struct module *mod, const char *modname,
 				r.r_offset = TO_NATIVE(rela->r_offset);
 #if KERNEL_ELFCLASS == ELFCLASS64
 				if (hdr->e_machine == EM_MIPS) {
+					unsigned int r_typ;
 					r_sym = ELF64_MIPS_R_SYM(rela->r_info);
 					r_sym = TO_NATIVE(r_sym);
+					r_typ = ELF64_MIPS_R_TYPE(rela->r_info);
+					r.r_info = ELF64_R_INFO(r_sym, r_typ);
 				} else {
 					r.r_info = TO_NATIVE(rela->r_info);
 					r_sym = ELF_R_SYM(r.r_info);
@@ -988,8 +1040,11 @@ static void check_sec_ref(struct module *mod, const char *modname,
 				r.r_offset = TO_NATIVE(rel->r_offset);
 #if KERNEL_ELFCLASS == ELFCLASS64
 				if (hdr->e_machine == EM_MIPS) {
+					unsigned int r_typ;
 					r_sym = ELF64_MIPS_R_SYM(rel->r_info);
 					r_sym = TO_NATIVE(r_sym);
+					r_typ = ELF64_MIPS_R_TYPE(rel->r_info);
+					r.r_info = ELF64_R_INFO(r_sym, r_typ);
 				} else {
 					r.r_info = TO_NATIVE(rel->r_info);
 					r_sym = ELF_R_SYM(r.r_info);
@@ -999,6 +1054,14 @@ static void check_sec_ref(struct module *mod, const char *modname,
 				r_sym = ELF_R_SYM(r.r_info);
 #endif
 				r.r_addend = 0;
+				if (hdr->e_machine == EM_386)
+					addend_386_rel(elf, i, &r);
+				else if (hdr->e_machine == EM_ARM)
+					addend_arm_rel(elf, i, &r);
+				else if (hdr->e_machine == EM_MIPS) {
+					if (addend_mips_rel(elf, i, &r))
+						continue;
+				}
 				sym = elf->symtab_start + r_sym;
 				/* Skip special sections */
 				if (sym->st_shndx >= SHN_LORESERVE)
diff --git a/scripts/mod/modpost.h b/scripts/mod/modpost.h
index 0858caa..4156dd3 100644
--- a/scripts/mod/modpost.h
+++ b/scripts/mod/modpost.h
@@ -60,6 +60,9 @@ typedef union
 #define ELF64_MIPS_R_SYM(i) \
   ((__extension__ (_Elf64_Mips_R_Info_union)(i)).r_info_fields.r_sym)
 
+#define ELF64_MIPS_R_TYPE(i) \
+  ((__extension__ (_Elf64_Mips_R_Info_union)(i)).r_info_fields.r_type1)
+
 #if KERNEL_ELFDATA != HOST_ELFDATA
 
 static inline void __endian(const void *src, void *dest, unsigned int size)
diff --git a/scripts/mod/sumversion.c b/scripts/mod/sumversion.c
index 6873d5a..d9cc690 100644
--- a/scripts/mod/sumversion.c
+++ b/scripts/mod/sumversion.c
@@ -7,6 +7,7 @@
 #include <ctype.h>
 #include <errno.h>
 #include <string.h>
+#include <limits.h>
 #include "modpost.h"
 
 /*
