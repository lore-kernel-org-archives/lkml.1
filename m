Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbYAMVmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbYAMVmO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 16:42:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754182AbYAMVmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 16:42:03 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:48568 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753997AbYAMVmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 16:42:00 -0500
Date: Sun, 13 Jan 2008 22:42:04 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] __cpuinitconst and __devinitconst
Message-ID: <20080113214204.GB2205@uranus.ravnborg.org>
References: <47873D11.76E4.0078.0@novell.com> <20080111194428.GB29189@uranus.ravnborg.org> <20080112205635.GA6059@uranus.ravnborg.org> <20080113073024.GA30120@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080113073024.GA30120@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And I found another small buglet too. I hope to post a complete
> solution later today.

The modpost bits turned out to take longer than expected so 
they are not done yet. The problem was the modpost structure
were not prepared for adding such additional chacks.
So I reworked those bits and the patch has been sent out for review.

What follows here is the changes for init.h + all linker scripts
to show the idea.

Next step is to beat modpost in shape and to post this on linux-arch.

Note - in -mm there are changes to init.h so the logic
to decide type of __meminit notation is much simpler.

	Sam

 arch/alpha/kernel/vmlinux.lds.S     |    8 +--
 arch/arm/kernel/vmlinux.lds.S       |   10 ++--
 arch/avr32/kernel/vmlinux.lds.S     |    8 +--
 arch/blackfin/kernel/vmlinux.lds.S  |    8 +--
 arch/cris/arch-v10/vmlinux.lds.S    |    8 +--
 arch/cris/arch-v32/vmlinux.lds.S    |    8 +--
 arch/frv/kernel/vmlinux.lds.S       |   14 +++---
 arch/h8300/kernel/vmlinux.lds.S     |    8 +--
 arch/ia64/kernel/vmlinux.lds.S      |    8 +--
 arch/m32r/kernel/vmlinux.lds.S      |   12 ++---
 arch/m68k/kernel/vmlinux-std.lds    |    8 +--
 arch/m68k/kernel/vmlinux-sun3.lds   |    8 +--
 arch/m68knommu/kernel/vmlinux.lds.S |    8 +--
 arch/mips/kernel/vmlinux.lds.S      |    8 +--
 arch/parisc/kernel/vmlinux.lds.S    |    8 +--
 arch/powerpc/kernel/vmlinux.lds.S   |   10 ++--
 arch/ppc/kernel/vmlinux.lds.S       |    8 +--
 arch/s390/kernel/vmlinux.lds.S      |    8 +--
 arch/sh/kernel/vmlinux.lds.S        |    8 +--
 arch/sh64/kernel/vmlinux.lds.S      |    8 +--
 arch/sparc/kernel/vmlinux.lds.S     |    8 +--
 arch/sparc64/kernel/vmlinux.lds.S   |    8 +--
 arch/um/kernel/dyn.lds.S            |    4 -
 arch/um/kernel/uml.lds.S            |    4 -
 arch/v850/kernel/vmlinux.lds.S      |   10 ++--
 arch/x86/kernel/vmlinux_32.lds.S    |   14 ++++--
 arch/x86/kernel/vmlinux_64.lds.S    |   19 ++++++--
 arch/xtensa/kernel/vmlinux.lds.S    |    9 ++--
 include/asm-generic/vmlinux.lds.h   |   77 +++++++++++++++++++++++++++++++++++-
 include/linux/init.h                |   56 +++++++++-----------------
 30 files changed, 229 insertions(+), 154 deletions(-)

diff --git a/arch/alpha/kernel/vmlinux.lds.S b/arch/alpha/kernel/vmlinux.lds.S
index 55c05b5..f13249b 100644
--- a/arch/alpha/kernel/vmlinux.lds.S
+++ b/arch/alpha/kernel/vmlinux.lds.S
@@ -46,11 +46,11 @@ SECTIONS
 	__init_begin = .;
 	.init.text : {
 		_sinittext = .;
-		*(.init.text)
+		INIT_TEXT
 		_einittext = .;
 	}
 	.init.data : {
-		*(.init.data)
+		INIT_DATA
 	}
 
 	. = ALIGN(16);
@@ -136,8 +136,8 @@ SECTIONS
 
 	/* Sections to be discarded */
 	/DISCARD/ : {
-		*(.exit.text)
-		*(.exit.data)
+		EXIT_TEXT
+		EXIT_DATA
 		*(.exitcall.exit)
 	}
 
diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index 5ff5406..52221ef 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -30,7 +30,7 @@ SECTIONS
 	}
 
 	.init : {			/* Init code and data		*/
-			*(.init.text)
+			INIT_TEXT
 		_einittext = .;
 		__proc_info_begin = .;
 			*(.proc.info.init)
@@ -70,15 +70,15 @@ SECTIONS
 		__per_cpu_end = .;
 #ifndef CONFIG_XIP_KERNEL
 		__init_begin = _stext;
-		*(.init.data)
+		INIT_DATA
 		. = ALIGN(4096);
 		__init_end = .;
 #endif
 	}
 
 	/DISCARD/ : {			/* Exit code and data		*/
-		*(.exit.text)
-		*(.exit.data)
+		EXIT_TEXT
+		EXIT_DATA
 		*(.exitcall.exit)
 #ifndef CONFIG_MMU
 		*(.fixup)
@@ -129,7 +129,7 @@ SECTIONS
 #ifdef CONFIG_XIP_KERNEL
 		. = ALIGN(4096);
 		__init_begin = .;
-		*(.init.data)
+		INIT_DATA
 		. = ALIGN(4096);
 		__init_end = .;
 #endif
diff --git a/arch/avr32/kernel/vmlinux.lds.S b/arch/avr32/kernel/vmlinux.lds.S
index 11f08e3..481cfd4 100644
--- a/arch/avr32/kernel/vmlinux.lds.S
+++ b/arch/avr32/kernel/vmlinux.lds.S
@@ -27,19 +27,19 @@ SECTIONS
 		__init_begin = .;
 			_sinittext = .;
 			*(.text.reset)
-			*(.init.text)
+			INIT_TEXT
 			/*
 			 * .exit.text is discarded at runtime, not
 			 * link time, to deal with references from
 			 * __bug_table
 			 */
-			*(.exit.text)
+			EXIT_TEXT
 			_einittext = .;
 		. = ALIGN(4);
 		__tagtable_begin = .;
 			*(.taglist.init)
 		__tagtable_end = .;
-			*(.init.data)
+			INIT_DATA
 		. = ALIGN(16);
 		__setup_start = .;
 			*(.init.setup)
@@ -135,7 +135,7 @@ SECTIONS
 	 * thrown away, as cleanup code is never called unless it's a module.
 	 */
 	/DISCARD/       	: {
-		*(.exit.data)
+		EXIT_DATA
 		*(.exitcall.exit)
 	}
 
diff --git a/arch/blackfin/kernel/vmlinux.lds.S b/arch/blackfin/kernel/vmlinux.lds.S
index 9b75bc8..8587224 100644
--- a/arch/blackfin/kernel/vmlinux.lds.S
+++ b/arch/blackfin/kernel/vmlinux.lds.S
@@ -91,13 +91,13 @@ SECTIONS
 	{
 		. = ALIGN(PAGE_SIZE);
 		__sinittext = .;
-		*(.init.text)
+		INIT_TEXT
 		__einittext = .;
 	}
 	.init.data :
 	{
 		. = ALIGN(16);
-		*(.init.data)
+		INIT_DATA
 	}
 	.init.setup :
 	{
@@ -198,8 +198,8 @@ SECTIONS
 
 	/DISCARD/ :
 	{
-		*(.exit.text)
-		*(.exit.data)
+		EXIT_TEXT
+		EXIT_DATA
 		*(.exitcall.exit)
 	}
 }
diff --git a/arch/cris/arch-v10/vmlinux.lds.S b/arch/cris/arch-v10/vmlinux.lds.S
index 9859d49..62c69c3 100644
--- a/arch/cris/arch-v10/vmlinux.lds.S
+++ b/arch/cris/arch-v10/vmlinux.lds.S
@@ -56,10 +56,10 @@ SECTIONS
   	__init_begin = .;
 	.init.text : { 
 		   _sinittext = .;
-		   *(.init.text)
+		   INIT_TEXT
 		   _einittext = .;
 	}
-  	.init.data : { *(.init.data) }
+  	.init.data : { INIT_DATA }
   	. = ALIGN(16);
   	__setup_start = .;
   	.init.setup : { *(.init.setup) }
@@ -112,8 +112,8 @@ SECTIONS
 
 	/* Sections to be discarded */
   	/DISCARD/ : {
-        	*(.text.exit)
-        	*(.data.exit)
+        	EXIT_TEXT
+        	EXIT_DATA
 		*(.exitcall.exit)
         }
 
diff --git a/arch/cris/arch-v32/vmlinux.lds.S b/arch/cris/arch-v32/vmlinux.lds.S
index b076c13..bbd10c1 100644
--- a/arch/cris/arch-v32/vmlinux.lds.S
+++ b/arch/cris/arch-v32/vmlinux.lds.S
@@ -61,10 +61,10 @@ SECTIONS
   	__init_begin = .;
 	.init.text : {
 		   _sinittext = .;
-		   *(.init.text)
+		   INIT_TEXT
 		   _einittext = .;
 	}
-  	.init.data : { *(.init.data) }
+  	.init.data : { INIT_DATA }
   	. = ALIGN(16);
   	__setup_start = .;
   	.init.setup : { *(.init.setup) }
@@ -124,8 +124,8 @@ SECTIONS
 
 	/* Sections to be discarded */
   	/DISCARD/ : {
-        	*(.text.exit)
-        	*(.data.exit)
+        	EXIT_TEXT
+        	EXIT_DATA
 		*(.exitcall.exit)
         }
 
diff --git a/arch/frv/kernel/vmlinux.lds.S b/arch/frv/kernel/vmlinux.lds.S
index a17a81d..f42b328 100644
--- a/arch/frv/kernel/vmlinux.lds.S
+++ b/arch/frv/kernel/vmlinux.lds.S
@@ -28,14 +28,14 @@ SECTIONS
   .init.text : {
 	*(.text.head)
 #ifndef CONFIG_DEBUG_INFO
-	*(.init.text)
-	*(.exit.text)
-	*(.exit.data)
+	INIT_TEXT
+	EXIT_TEXT
+	EXIT_DATA
 	*(.exitcall.exit)
 #endif
   }
   _einittext = .;
-  .init.data : { *(.init.data) }
+  .init.data : { INIT_DATA }
 
   . = ALIGN(8);
   __setup_start = .;
@@ -106,8 +106,8 @@ SECTIONS
 	LOCK_TEXT
 #ifdef CONFIG_DEBUG_INFO
 	*(
-	.init.text
-	.exit.text
+	INIT_TEXT
+	EXIT_TEXT
 	.exitcall.exit
 	)
 #endif
@@ -138,7 +138,7 @@ SECTIONS
   .data : {			/* Data */
 	DATA_DATA
 	*(.data.*)
-	*(.exit.data)
+	EXIT_DATA
 	CONSTRUCTORS
 	}
 
diff --git a/arch/h8300/kernel/vmlinux.lds.S b/arch/h8300/kernel/vmlinux.lds.S
index a2e72d4..43a87b9 100644
--- a/arch/h8300/kernel/vmlinux.lds.S
+++ b/arch/h8300/kernel/vmlinux.lds.S
@@ -110,9 +110,9 @@ SECTIONS
 	. = ALIGN(0x4) ;
 	___init_begin = .;
 	__sinittext = .; 
-		*(.init.text)
+		INIT_TEXT
 	__einittext = .; 
-		*(.init.data)
+		INIT_DATA
 	. = ALIGN(0x4) ;
 	___setup_start = .;
 		*(.init.setup)
@@ -124,8 +124,8 @@ SECTIONS
 	___con_initcall_start = .;
 		*(.con_initcall.init)
 	___con_initcall_end = .;
-		*(.exit.text)
-		*(.exit.data)
+		EXIT_TEXT
+		EXIT_DATA
 #if defined(CONFIG_BLK_DEV_INITRD)
 		. = ALIGN(4);
 	___initramfs_start = .;
diff --git a/arch/ia64/kernel/vmlinux.lds.S b/arch/ia64/kernel/vmlinux.lds.S
index 757e419..80622ac 100644
--- a/arch/ia64/kernel/vmlinux.lds.S
+++ b/arch/ia64/kernel/vmlinux.lds.S
@@ -27,8 +27,8 @@ SECTIONS
 {
   /* Sections to be discarded */
   /DISCARD/ : {
-	*(.exit.text)
-	*(.exit.data)
+	EXIT_TEXT
+	EXIT_DATA
 	*(.exitcall.exit)
 	*(.IA_64.unwind.exit.text)
 	*(.IA_64.unwind_info.exit.text)
@@ -119,12 +119,12 @@ SECTIONS
   .init.text : AT(ADDR(.init.text) - LOAD_OFFSET)
 	{
 	  _sinittext = .;
-	  *(.init.text)
+	  INIT_TEXT
 	  _einittext = .;
 	}
 
   .init.data : AT(ADDR(.init.data) - LOAD_OFFSET)
-	{ *(.init.data) }
+	{ INIT_DATA }
 
 #ifdef CONFIG_BLK_DEV_INITRD
   .init.ramfs : AT(ADDR(.init.ramfs) - LOAD_OFFSET)
diff --git a/arch/m32r/kernel/vmlinux.lds.S b/arch/m32r/kernel/vmlinux.lds.S
index 942a8c7..41b0785 100644
--- a/arch/m32r/kernel/vmlinux.lds.S
+++ b/arch/m32r/kernel/vmlinux.lds.S
@@ -76,10 +76,10 @@ SECTIONS
   __init_begin = .;
   .init.text : {
 	_sinittext = .;
-	*(.init.text)
+	INIT_TEXT
 	_einittext = .;
   }
-  .init.data : { *(.init.data) }
+  .init.data : { INIT_DATA }
   . = ALIGN(16);
   __setup_start = .;
   .init.setup : { *(.init.setup) }
@@ -100,8 +100,8 @@ SECTIONS
   .altinstr_replacement : { *(.altinstr_replacement) }
   /* .exit.text is discard at runtime, not link time, to deal with references
      from .altinstructions and .eh_frame */
-  .exit.text : { *(.exit.text) }
-  .exit.data : { *(.exit.data) }
+  .exit.text : { EXIT_TEXT }
+  .exit.data : { EXIT_DATA }
 
 #ifdef CONFIG_BLK_DEV_INITRD
   . = ALIGN(4096);
@@ -124,8 +124,8 @@ SECTIONS
 
   /* Sections to be discarded */
   /DISCARD/ : {
-	*(.exit.text)
-	*(.exit.data)
+	EXIT_TEXT
+	EXIT_DATA
 	*(.exitcall.exit)
 	}
 
diff --git a/arch/m68k/kernel/vmlinux-std.lds b/arch/m68k/kernel/vmlinux-std.lds
index 59fe285..7537cc5 100644
--- a/arch/m68k/kernel/vmlinux-std.lds
+++ b/arch/m68k/kernel/vmlinux-std.lds
@@ -45,10 +45,10 @@ SECTIONS
   __init_begin = .;
   .init.text : {
 	_sinittext = .;
-	*(.init.text)
+	INIT_TEXT
 	_einittext = .;
   }
-  .init.data : { *(.init.data) }
+  .init.data : { INIT_DATA }
   . = ALIGN(16);
   __setup_start = .;
   .init.setup : { *(.init.setup) }
@@ -82,8 +82,8 @@ SECTIONS
 
   /* Sections to be discarded */
   /DISCARD/ : {
-	*(.exit.text)
-	*(.exit.data)
+	EXIT_TEXT
+	EXIT_DATA
 	*(.exitcall.exit)
 	}
 
diff --git a/arch/m68k/kernel/vmlinux-sun3.lds b/arch/m68k/kernel/vmlinux-sun3.lds
index 4adffef..cdc313e 100644
--- a/arch/m68k/kernel/vmlinux-sun3.lds
+++ b/arch/m68k/kernel/vmlinux-sun3.lds
@@ -38,10 +38,10 @@ SECTIONS
 __init_begin = .;
 	.init.text : {
 		_sinittext = .;
-		*(.init.text)
+		INIT_TEXT
 		_einittext = .;
 	}
-	.init.data : { *(.init.data) }
+	.init.data : { INIT_DATA }
 	. = ALIGN(16);
 	__setup_start = .;
 	.init.setup : { *(.init.setup) }
@@ -77,8 +77,8 @@ __init_begin = .;
 
   /* Sections to be discarded */
   /DISCARD/ : {
-	*(.exit.text)
-	*(.exit.data)
+	EXIT_TEXT
+	EXIT_DATA
 	*(.exitcall.exit)
 	}
 
diff --git a/arch/m68knommu/kernel/vmlinux.lds.S b/arch/m68knommu/kernel/vmlinux.lds.S
index 07a0055..b44edb0 100644
--- a/arch/m68knommu/kernel/vmlinux.lds.S
+++ b/arch/m68knommu/kernel/vmlinux.lds.S
@@ -143,9 +143,9 @@ SECTIONS {
 		. = ALIGN(4096);
 		__init_begin = .;
 		_sinittext = .;
-		*(.init.text)
+		INIT_TEXT
 		_einittext = .;
-		*(.init.data)
+		INIT_DATA
 		. = ALIGN(16);
 		__setup_start = .;
 		*(.init.setup)
@@ -170,8 +170,8 @@ SECTIONS {
 	} > INIT
 
 	/DISCARD/ : {
-		*(.exit.text)
-		*(.exit.data)
+		EXIT_TEXT
+		EXIT_DATA
 		*(.exitcall.exit)
 	}
 
diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.S
index 5fc2398..b5470ce 100644
--- a/arch/mips/kernel/vmlinux.lds.S
+++ b/arch/mips/kernel/vmlinux.lds.S
@@ -114,11 +114,11 @@ SECTIONS
 	__init_begin = .;
 	.init.text : {
 		_sinittext = .;
-		*(.init.text)
+		INIT_TEXT
 		_einittext = .;
 	}
 	.init.data : {
-		*(.init.data)
+		INIT_DATA
 	}
 	. = ALIGN(16);
 	.init.setup : {
@@ -144,10 +144,10 @@ SECTIONS
 	 * references from .rodata
 	 */
 	.exit.text : {
-		*(.exit.text)
+		EXIT_TEXT
 	}
 	.exit.data : {
-		*(.exit.data)
+		EXIT_DATA
 	}
 #if defined(CONFIG_BLK_DEV_INITRD)
 	. = ALIGN(_PAGE_SIZE);
diff --git a/arch/parisc/kernel/vmlinux.lds.S b/arch/parisc/kernel/vmlinux.lds.S
index 40d0ff9..50b4a3a 100644
--- a/arch/parisc/kernel/vmlinux.lds.S
+++ b/arch/parisc/kernel/vmlinux.lds.S
@@ -172,11 +172,11 @@ SECTIONS
 	__init_begin = .;
 	.init.text : { 
 		_sinittext = .;
-		*(.init.text)
+		INIT_TEXT
 		_einittext = .;
 	}
 	.init.data : {
-		*(.init.data)
+		INIT_DATA
 	}
 	. = ALIGN(16);
 	.init.setup : {
@@ -215,10 +215,10 @@ SECTIONS
 	 *  from .altinstructions and .eh_frame
 	 */
 	.exit.text : {
-		*(.exit.text)
+		EXIT_TEXT
 	}
 	.exit.data : {
-		*(.exit.data)
+		EXIT_DATA
 	}
 #ifdef CONFIG_BLK_DEV_INITRD
 	. = ALIGN(PAGE_SIZE);
diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index f66fa5d..0afb9e3 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -23,7 +23,7 @@ SECTIONS
 	/* Sections to be discarded. */
 	/DISCARD/ : {
 	*(.exitcall.exit)
-	*(.exit.data)
+	EXIT_DATA
 	}
 
 	. = KERNELBASE;
@@ -76,17 +76,19 @@ SECTIONS
 
 	.init.text : {
 		_sinittext = .;
-		*(.init.text)
+		INIT_TEXT
 		_einittext = .;
 	}
 
 	/* .exit.text is discarded at runtime, not link time,
 	 * to deal with references from __bug_table
 	 */
-	.exit.text : { *(.exit.text) }
+	.exit.text : {
+		EXIT_TEXT
+	}
 
 	.init.data : {
-		*(.init.data);
+		INIT_DATA
 		__vtop_table_begin = .;
 		*(.vtop_fixup);
 		__vtop_table_end = .;
diff --git a/arch/ppc/kernel/vmlinux.lds.S b/arch/ppc/kernel/vmlinux.lds.S
index 98c1212..52b64fc 100644
--- a/arch/ppc/kernel/vmlinux.lds.S
+++ b/arch/ppc/kernel/vmlinux.lds.S
@@ -97,14 +97,14 @@ SECTIONS
   __init_begin = .;
   .init.text : {
 	_sinittext = .;
-	*(.init.text)
+	INIT_TEXT
 	_einittext = .;
   }
   /* .exit.text is discarded at runtime, not link time,
      to deal with references from __bug_table */
-  .exit.text : { *(.exit.text) }
+  .exit.text : { EXIT_TEXT }
   .init.data : {
-    *(.init.data);
+    INIT_DATA
     __vtop_table_begin = .;
     *(.vtop_fixup);
     __vtop_table_end = .;
@@ -164,6 +164,6 @@ SECTIONS
   /* Sections to be discarded. */
   /DISCARD/ : {
     *(.exitcall.exit)
-    *(.exit.data)
+    EXIT_DATA
   }
 }
diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index 849120e..c62795f 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -91,7 +91,7 @@ SECTIONS
 	__init_begin = .;
 	.init.text : {
 		_sinittext = .;
-		*(.init.text)
+		INIT_TEXT
 		_einittext = .;
 	}
 	/*
@@ -99,11 +99,11 @@ SECTIONS
 	 * to deal with references from __bug_table
 	*/
 	.exit.text : {
-		*(.exit.text)
+		EXIT_TEXT
 	}
 
 	.init.data : {
-		*(.init.data)
+		INIT_DATA
 	}
 	. = ALIGN(0x100);
 	.init.setup : {
@@ -150,7 +150,7 @@ SECTIONS
 
 	/* Sections to be discarded */
 	/DISCARD/ : {
-		*(.exit.data)
+		EXIT_DATA
 		*(.exitcall.exit)
 	}
 
diff --git a/arch/sh/kernel/vmlinux.lds.S b/arch/sh/kernel/vmlinux.lds.S
index 0956fb3..4c20dd9 100644
--- a/arch/sh/kernel/vmlinux.lds.S
+++ b/arch/sh/kernel/vmlinux.lds.S
@@ -70,9 +70,9 @@ SECTIONS
 	. = ALIGN(PAGE_SIZE);		/* Init code and data */
 	__init_begin = .;
 	_sinittext = .;
-	.init.text : { *(.init.text) }
+	.init.text : { INIT_TEXT }
 	_einittext = .;
-	.init.data : { *(.init.data) }
+	.init.data : { INIT_DATA }
 
 	. = ALIGN(16);
 	__setup_start = .;
@@ -108,8 +108,8 @@ SECTIONS
 	 * .exit.text is discarded at runtime, not link time, to deal with
 	 * references from __bug_table
 	 */
-	.exit.text : { *(.exit.text) }
-	.exit.data : { *(.exit.data) }
+	.exit.text : { EXIT_TEXT }
+	.exit.data : { EXIT_DATA }
 
 	. = ALIGN(PAGE_SIZE);
 	.bss : {
diff --git a/arch/sh64/kernel/vmlinux.lds.S b/arch/sh64/kernel/vmlinux.lds.S
index f533a06..1696803 100644
--- a/arch/sh64/kernel/vmlinux.lds.S
+++ b/arch/sh64/kernel/vmlinux.lds.S
@@ -93,9 +93,9 @@ SECTIONS
   . = ALIGN(PAGE_SIZE);		/* Init code and data */
   __init_begin = .;
   _sinittext = .;
-  .init.text : C_PHYS(.init.text) { *(.init.text) }
+  .init.text : C_PHYS(.init.text) { INIT_TEXT }
   _einittext = .;
-  .init.data : C_PHYS(.init.data) { *(.init.data) }
+  .init.data : C_PHYS(.init.data) { INIT_DATA }
   . = ALIGN(L1_CACHE_BYTES);	/* Better if Cache Line aligned */
   __setup_start = .;
   .init.setup : C_PHYS(.init.setup) { *(.init.setup) }
@@ -130,8 +130,8 @@ SECTIONS
 
   /* Sections to be discarded */
   /DISCARD/ : {
-	*(.exit.text)
-	*(.exit.data)
+	EXIT_TEXT
+	EXIT_DATA
 	*(.exitcall.exit)
 	}
 
diff --git a/arch/sparc/kernel/vmlinux.lds.S b/arch/sparc/kernel/vmlinux.lds.S
index a8b4200..216147d 100644
--- a/arch/sparc/kernel/vmlinux.lds.S
+++ b/arch/sparc/kernel/vmlinux.lds.S
@@ -48,12 +48,12 @@ SECTIONS
 	__init_begin = .;
 	.init.text : {
 		_sinittext = .;
-		*(.init.text)
+		INIT_TEXT
 		_einittext = .;
 	}
 	__init_text_end = .;
 	.init.data : {
-		*(.init.data)
+		INIT_DATA
 	}
 	. = ALIGN(16);
 	.init.setup : {
@@ -102,8 +102,8 @@ SECTIONS
 	_end = . ;
 	PROVIDE (end = .);
 	/DISCARD/ : {
-		*(.exit.text)
-		*(.exit.data)
+		EXIT_TEXT
+		EXIT_DATA
 		*(.exitcall.exit)
 	}
 
diff --git a/arch/sparc64/kernel/vmlinux.lds.S b/arch/sparc64/kernel/vmlinux.lds.S
index 9fcd503..01f8096 100644
--- a/arch/sparc64/kernel/vmlinux.lds.S
+++ b/arch/sparc64/kernel/vmlinux.lds.S
@@ -56,11 +56,11 @@ SECTIONS
 	.init.text : {
 		__init_begin = .;
 		_sinittext = .;
-		*(.init.text)
+		INIT_TEXT
 		_einittext = .;
 	}
 	.init.data : {
-		*(.init.data)
+		INIT_DATA
 	}
 	. = ALIGN(16);
 	.init.setup : {
@@ -137,8 +137,8 @@ SECTIONS
 	PROVIDE (end = .);
 
 	/DISCARD/ : {
-		*(.exit.text)
-		*(.exit.data)
+		EXIT_TEXT
+		EXIT_DATA
 		*(.exitcall.exit)
 	}
 
diff --git a/arch/um/kernel/dyn.lds.S b/arch/um/kernel/dyn.lds.S
index 3866f49..26090b7 100644
--- a/arch/um/kernel/dyn.lds.S
+++ b/arch/um/kernel/dyn.lds.S
@@ -17,7 +17,7 @@ SECTIONS
   __init_begin = .;
   .init.text : {
 	_sinittext = .;
-	*(.init.text)
+	INIT_TEXT
 	_einittext = .;
   }
 
@@ -84,7 +84,7 @@ SECTIONS
 
   #include "asm/common.lds.S"
 
-  init.data : { *(.init.data) }
+  init.data : { INIT_DATA }
 
   /* Ensure the __preinit_array_start label is properly aligned.  We
      could instead move the label definition inside the section, but
diff --git a/arch/um/kernel/uml.lds.S b/arch/um/kernel/uml.lds.S
index 13df191..5828c1d 100644
--- a/arch/um/kernel/uml.lds.S
+++ b/arch/um/kernel/uml.lds.S
@@ -23,7 +23,7 @@ SECTIONS
   __init_begin = .;
   .init.text : {
 	_sinittext = .;
-	*(.init.text)
+	INIT_TEXT
 	_einittext = .;
   }
   . = ALIGN(4096);
@@ -48,7 +48,7 @@ SECTIONS
 
   #include "asm/common.lds.S"
 
-  init.data : { *(init.data) }
+  init.data : { INIT_DATA }
   .data    :
   {
     . = ALIGN(KERNEL_STACK_SIZE);		/* init_task */
diff --git a/arch/v850/kernel/vmlinux.lds.S b/arch/v850/kernel/vmlinux.lds.S
index 6172599..d08cd1d 100644
--- a/arch/v850/kernel/vmlinux.lds.S
+++ b/arch/v850/kernel/vmlinux.lds.S
@@ -114,7 +114,7 @@
 #define DATA_CONTENTS							      \
 		__sdata = . ;						      \
 		DATA_DATA						      \
-			*(.exit.data)	/* 2.5 convention */		      \
+			EXIT_DATA	/* 2.5 convention */		      \
 			*(.data.exit)	/* 2.4 convention */		      \
 		. = ALIGN (16) ;					      \
 		*(.data.cacheline_aligned)				      \
@@ -157,9 +157,9 @@
 		. = ALIGN (4096) ;					      \
 		__init_start = . ;					      \
 			__sinittext = .;				      \
-			*(.init.text)	/* 2.5 convention */		      \
+			INIT_TEXT	/* 2.5 convention */		      \
 			__einittext = .;				      \
-			*(.init.data)					      \
+			INIT_DATA					      \
 			*(.text.init)	/* 2.4 convention */		      \
 			*(.data.init)					      \
 		INITCALL_CONTENTS					      \
@@ -170,7 +170,7 @@
 #define ROMK_INIT_RAM_CONTENTS						      \
 		. = ALIGN (4096) ;					      \
 		__init_start = . ;					      \
-			*(.init.data)	/* 2.5 convention */		      \
+			INIT_DATA	/* 2.5 convention */		      \
 			*(.data.init)	/* 2.4 convention */		      \
 		__init_end = . ;					      \
 		. = ALIGN (4096) ;
@@ -179,7 +179,7 @@
    should go into ROM.  */	
 #define ROMK_INIT_ROM_CONTENTS						      \
 			_sinittext = .;					      \
-			*(.init.text)	/* 2.5 convention */		      \
+			INIT_TEXT	/* 2.5 convention */		      \
 			_einittext = .;					      \
 			*(.text.init)	/* 2.4 convention */		      \
 		INITCALL_CONTENTS					      \
diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
index 2197768..f1148ac 100644
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ b/arch/x86/kernel/vmlinux_32.lds.S
@@ -127,10 +127,12 @@ SECTIONS
   .init.text : AT(ADDR(.init.text) - LOAD_OFFSET) {
   	__init_begin = .;
 	_sinittext = .;
-	*(.init.text)
+	INIT_TEXT
 	_einittext = .;
   }
-  .init.data : AT(ADDR(.init.data) - LOAD_OFFSET) { *(.init.data) }
+  .init.data : AT(ADDR(.init.data) - LOAD_OFFSET) {
+	INIT_DATA
+  }
   . = ALIGN(16);
   .init.setup : AT(ADDR(.init.setup) - LOAD_OFFSET) {
   	__setup_start = .;
@@ -165,8 +167,12 @@ SECTIONS
   }
   /* .exit.text is discard at runtime, not link time, to deal with references
      from .altinstructions and .eh_frame */
-  .exit.text : AT(ADDR(.exit.text) - LOAD_OFFSET) { *(.exit.text) }
-  .exit.data : AT(ADDR(.exit.data) - LOAD_OFFSET) { *(.exit.data) }
+  .exit.text : AT(ADDR(.exit.text) - LOAD_OFFSET) {
+	EXIT_TEXT
+  }
+  .exit.data : AT(ADDR(.exit.data) - LOAD_OFFSET) {
+	EXIT_DATA
+  }
 #if defined(CONFIG_BLK_DEV_INITRD)
   . = ALIGN(4096);
   .init.ramfs : AT(ADDR(.init.ramfs) - LOAD_OFFSET) {
diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index ba8ea97..ea53869 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -155,12 +155,15 @@ SECTIONS
   __init_begin = .;
   .init.text : AT(ADDR(.init.text) - LOAD_OFFSET) {
 	_sinittext = .;
-	*(.init.text)
+	INIT_TEXT
 	_einittext = .;
   }
-  __initdata_begin = .;
-  .init.data : AT(ADDR(.init.data) - LOAD_OFFSET) { *(.init.data) }
-  __initdata_end = .;
+  .init.data : AT(ADDR(.init.data) - LOAD_OFFSET) {
+	__initdata_begin = .;
+	INIT_DATA
+	__initdata_end = .;
+   }
+
   . = ALIGN(16);
   __setup_start = .;
   .init.setup : AT(ADDR(.init.setup) - LOAD_OFFSET) { *(.init.setup) }
@@ -187,8 +190,12 @@ SECTIONS
   }
   /* .exit.text is discard at runtime, not link time, to deal with references
      from .altinstructions and .eh_frame */
-  .exit.text : AT(ADDR(.exit.text) - LOAD_OFFSET) { *(.exit.text) }
-  .exit.data : AT(ADDR(.exit.data) - LOAD_OFFSET) { *(.exit.data) }
+  .exit.text : AT(ADDR(.exit.text) - LOAD_OFFSET) {
+	EXIT_TEXT
+  }
+  .exit.data : AT(ADDR(.exit.data) - LOAD_OFFSET) {
+	EXIT_DATA
+  }
 
 /* vdso blob that is mapped into user space */
   vdso_start = . ;
diff --git a/arch/xtensa/kernel/vmlinux.lds.S b/arch/xtensa/kernel/vmlinux.lds.S
index ac4ed52..73c6e0b 100644
--- a/arch/xtensa/kernel/vmlinux.lds.S
+++ b/arch/xtensa/kernel/vmlinux.lds.S
@@ -136,13 +136,13 @@ SECTIONS
   __init_begin = .;
   .init.text : {
   	_sinittext = .;
-	*(.init.literal) *(.init.text)
+	*(.init.literal) INIT_TEXT
 	_einittext = .;
   }
 
   .init.data :
   {
-    *(.init.data)
+    INIT_DATA
     . = ALIGN(0x4);
     __tagtable_begin = .;
     *(.taglist)
@@ -278,8 +278,9 @@ SECTIONS
   /* Sections to be discarded */
   /DISCARD/ :
   {
-  	*(.exit.literal .exit.text)
-  	*(.exit.data)
+  	*(.exit.literal)
+	EXIT_TEXT
+  	EXIT_DATA
         *(.exitcall.exit)
   }
 
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 9f584cc..2f359d9 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -9,10 +9,48 @@
 /* Align . to a 8 byte boundary equals to maximum function alignment. */
 #define ALIGN_FUNCTION()  . = ALIGN(8)
 
+#ifdef CONFIG_HOTPLUG
+#define DEV_KEEP(sec)
+#define DEV_DISCARD(sec) *(.dev##sec)
+#else
+#define DEV_KEEP(sec)    *(.dev##sec)
+#define DEV_DISCARD(sec)
+#endif
+
+#ifdef CONFIG_HOTPLUG_CPU
+#define CPU_KEEP(sec)
+#define CPU_DISCARD(sec) *(.cpu##sec)
+#else
+#define CPU_KEEP(sec)    *(.cpu##sec)
+#define CPU_DISCARD(sec)
+#endif
+
+#if defined(CONFIG_MEMORY_HOTPLUG) || defined(CONFIG_ACPI_HOTPLUG_MEMORY) \
+        || defined(CONFIG_ACPI_HOTPLUG_MEMORY_MODULE)
+#define MEM_KEEP(sec)
+#define MEM_DISCARD(sec) *(.mem##sec)
+#else
+#define MEM_KEEP(sec)    *(.mem##sec)
+#define MEM_DISCARD(sec)
+#endif
+
+
 /* .data section */
 #define DATA_DATA							\
 	*(.data)							\
 	*(.data.init.refok)						\
+	DEV_KEEP(init.data)						\
+	DEV_KEEP(init.data.const)					\
+	DEV_KEEP(exit.data)						\
+	DEV_KEEP(exit.data.const)					\
+	CPU_KEEP(init.data)						\
+	CPU_KEEP(init.data.const)					\
+	CPU_KEEP(exit.data)						\
+	CPU_KEEP(exit.data.const)					\
+	MEM_KEEP(init.data)						\
+	MEM_KEEP(init.data.const)					\
+	MEM_KEEP(exit.data)						\
+	MEM_KEEP(exit.data.const)					\
 	. = ALIGN(8);							\
 	VMLINUX_SYMBOL(__start___markers) = .;				\
 	*(__markers)							\
@@ -159,7 +197,14 @@
 		ALIGN_FUNCTION();					\
 		*(.text)						\
 		*(.text.init.refok)					\
-		*(.exit.text.refok)
+		*(.exit.text.refok)					\
+	DEV_KEEP(init.text)						\
+	DEV_KEEP(exit.text)						\
+	CPU_KEEP(init.text)						\
+	CPU_KEEP(exit.text)						\
+	MEM_KEEP(init.text)						\
+	MEM_KEEP(exit.text)
+
 
 /* sched.text is aling to function alignment to secure we have same
  * address even at second ld pass when generating System.map */
@@ -255,6 +300,36 @@
   	*(.initcall7.init)						\
   	*(.initcall7s.init)
 
+#define INIT_DATA							\
+	*(.init.data)							\
+	DEV_DISCARD(init.data)						\
+	DEV_DISCARD(init.data.const)					\
+	CPU_DISCARD(init.data)						\
+	CPU_DISCARD(init.data.const)					\
+	MEM_DISCARD(init.data)						\
+	MEM_DISCARD(init.data.const)
+
+#define INIT_TEXT							\
+	*(.init.text)							\
+	DEV_DISCARD(init.text)						\
+	CPU_DISCARD(init.text)						\
+	MEM_DISCARD(init.text)
+
+#define EXIT_DATA							\
+	*(.exit.data)							\
+	DEV_DISCARD(exit.data)						\
+	DEV_DISCARD(exit.data.const)					\
+	CPU_DISCARD(exit.data)						\
+	CPU_DISCARD(exit.data.const)					\
+	MEM_DISCARD(exit.data)						\
+	MEM_DISCARD(exit.data.const)
+
+#define EXIT_TEXT							\
+	*(.exit.text)							\
+	DEV_DISCARD(exit.text)						\
+	CPU_DISCARD(exit.text)						\
+	MEM_DISCARD(exit.text)
+
 #define PERCPU(align)							\
 	. = ALIGN(align);						\
 	__per_cpu_start = .;						\
diff --git a/include/linux/init.h b/include/linux/init.h
index 86e7e94..b72897d 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -254,42 +254,26 @@ void __init parse_early_param(void);
 #define __initdata_or_module __initdata
 #endif /*CONFIG_MODULES*/
 
-#ifdef CONFIG_HOTPLUG
-#define __devinit
-#define __devinitdata
-#define __devexit
-#define __devexitdata
-#else
-#define __devinit __init
-#define __devinitdata __initdata
-#define __devexit __exit
-#define __devexitdata __exitdata
-#endif
-
-#if defined(CONFIG_HOTPLUG_CPU) || defined(CONFIG_PM_CPUINIT)
-#define __cpuinit
-#define __cpuinitdata
-#define __cpuexit
-#define __cpuexitdata
-#else
-#define __cpuinit	__init
-#define __cpuinitdata __initdata
-#define __cpuexit __exit
-#define __cpuexitdata	__exitdata
-#endif
-
-#if defined(CONFIG_MEMORY_HOTPLUG) || defined(CONFIG_ACPI_HOTPLUG_MEMORY) \
-	|| defined(CONFIG_ACPI_HOTPLUG_MEMORY_MODULE)
-#define __meminit
-#define __meminitdata
-#define __memexit
-#define __memexitdata
-#else
-#define __meminit	__init
-#define __meminitdata __initdata
-#define __memexit __exit
-#define __memexitdata	__exitdata
-#endif
+#define __devinit        __attribute__ ((__section__ (".devinit.text")))
+#define __devinitdata    __attribute__ ((__section__ (".devinit.data")))
+#define __devinitcdata   __attribute__ ((__section__ (".devinit.data.const")))
+#define __devexit        __attribute__ ((__section__ (".devexit.text")))
+#define __devexitdata    __attribute__ ((__section__ (".devexit.data")))
+#define __devexitcdata   __attribute__ ((__section__ (".devexit.data.const")))
+
+#define __cpuinit        __attribute__ ((__section__ (".cpuinit.text")))
+#define __cpuinitdata    __attribute__ ((__section__ (".cpuinit.data")))
+#define __cpuinitcdata   __attribute__ ((__section__ (".cpuinit.data.const")))
+#define __cpuexit        __attribute__ ((__section__ (".cpuexit.text")))
+#define __cpuexitdata    __attribute__ ((__section__ (".cpuexit.data")))
+#define __cpuexitcdata   __attribute__ ((__section__ (".cpuexit.data.const")))
+
+#define __meminit        __attribute__ ((__section__ (".meminit.text")))
+#define __meminitdata    __attribute__ ((__section__ (".meminit.data")))
+#define __meminitcdata   __attribute__ ((__section__ (".meminit.data.const")))
+#define __memexit        __attribute__ ((__section__ (".memexit.text")))
+#define __memexitdata    __attribute__ ((__section__ (".memexit.data")))
+#define __memexitcdata   __attribute__ ((__section__ (".memexit.data.const")))
 
 /* Functions marked as __devexit may be discarded at kernel link time, depending
    on config options.  Newer versions of binutils detect references from
