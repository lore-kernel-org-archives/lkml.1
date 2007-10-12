Return-Path: <linux-kernel-owner+w=401wt.eu-S932658AbXJLQu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932658AbXJLQu3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbXJLQuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:50:20 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:41856 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbXJLQuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:50:17 -0400
Date: Fri, 12 Oct 2007 17:50:01 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Franck Bui-Huu <vagabon.xyz@gmail.com>, Ralf Baechle <ralf@linux-mips.org>,
       linux-arch@vger.kernel.org, linux-mips@linux-mips.org
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] Discardable strings for init and exit sections
Message-ID: <Pine.LNX.4.64N.0710121711120.21684@blysk.ds.pg.gda.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 We currently have infrastructure for discardable text and data, but no 
such thing for strings.  This is especially notable for inline strings 
such as ones used by printk() which are left behind resident in the memory 
throughout the life of the system even though code referring to them has 
been removed.

 Following a short discussion at the linux-mips list, here is a proposed 
implementation for discardable strings.  It adds __initstr and __exitstr 
plus most of the usual variations, but most importantly it adds wrapper 
macros that may be used for inline strings that make them be put in
separate sections which may then be discarded, while still preserving the 
usual merging property of sections containing strings.  The macros are 
called _i() and _e(), with the other alternatives adding at most two 
letters each.  This has been inspired by how the GNU gettext handles 
localised strings in a way that does not add too much clutter and the 
result is still reasonably well readable.  Some use examples have been 
included in <linux/init.h>.

 There is one pitfall here -- GCC does not let one specify section flags 
explicitly and provides its own set based on the type of the variable 
instead.  The guess, which is "aw", is not what we want here, so I had to 
circumvent it somehow.  The solution is to provide the flags and the 
further necessary parameters as a part of the section "name" and then emit 
a newline and an assembly comment character so that what GCC produces for 
section flags is ignored.  A newline is required for a reasonable 
implementation, because only the line comment character is almost 
universal across targets supported by binutils (except from a couple of 
obscure platforms we do not aim to support), while the trailing comment 
character varies wildly and may not even be available at all (cf. 
blackfin).  This is what this strange __strflags macro is for.

 Of course for this to work all the linker scripts have to be updated 
accordingly.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
 I did some proof-of-concept testing only of this change as for it to be 
of use, strings have to be annotated appropriately.  I do not expect it to 
happen soon or automatically, but I rely on people for whom the size 
matters to make the necessary adjustments.

 For testing I made the obvious choice ;-) of drivers/net/defxx.c; for 
which I have a patch that I will send separately.  The driver is nice 
enough to have a duplicate string that can be used to verify that merging 
still works and then the results of the discarding can be examined through 
/proc/kcore.  I have built the changes for MIPS, albeit with a slightly 
older kernel as the current version does not build for my configuration of 
interest, and successfully verified at the run time.

 Architecture maintainers, I have made a reasonable attempt to get the 
linker script changes right, but for a few of the more complicated setups 
I may have not done everything necessary or I may have misplaced the 
sections in the output even.  Please let me know of any adjustments 
necessary.

 Comments are welcome, whether positive or negative, but I do hope overall 
the feature is reasonable enough to be accepted.  This patch applies to 
the current Linus tree.

  Maciej

patch-2.6.23-20071012-inexitstr-5
diff -up --recursive --new-file linux-2.6.23-20071012.macro/arch/alpha/kernel/vmlinux.lds.S linux-2.6.23-20071012/arch/alpha/kernel/vmlinux.lds.S
--- linux-2.6.23-20071012.macro/arch/alpha/kernel/vmlinux.lds.S	2007-09-04 04:55:16.000000000 +0000
+++ linux-2.6.23-20071012/arch/alpha/kernel/vmlinux.lds.S	2007-10-12 13:53:22.000000000 +0000
@@ -42,6 +42,7 @@ SECTIONS
 	*(.init.text)
 	_einittext = .;
   }
+  .init.str1 : { *(.init.str1) }
   .init.data : { *(.init.data) }
 
   . = ALIGN(16);
@@ -107,7 +108,7 @@ SECTIONS
   _end = .;
 
   /* Sections to be discarded */
-  /DISCARD/ : { *(.exit.text) *(.exit.data) *(.exitcall.exit) }
+  /DISCARD/ : { *(.exit.text) *(.exit.str1) *(.exit.data) *(.exitcall.exit) }
 
   .mdebug 0 : { *(.mdebug) }
   .note 0 : { *(.note) }
diff -up --recursive --new-file linux-2.6.23-20071012.macro/arch/arm/kernel/vmlinux.lds.S linux-2.6.23-20071012/arch/arm/kernel/vmlinux.lds.S
--- linux-2.6.23-20071012.macro/arch/arm/kernel/vmlinux.lds.S	2007-09-04 04:55:16.000000000 +0000
+++ linux-2.6.23-20071012/arch/arm/kernel/vmlinux.lds.S	2007-10-12 13:53:22.000000000 +0000
@@ -41,6 +41,7 @@ SECTIONS
 		__tagtable_begin = .;
 			*(.taglist.init)
 		__tagtable_end = .;
+			*(.init.str1)
 		. = ALIGN(16);
 		__setup_start = .;
 			*(.init.setup)
@@ -78,6 +79,7 @@ SECTIONS
 
 	/DISCARD/ : {			/* Exit code and data		*/
 		*(.exit.text)
+		*(.exit.str1)
 		*(.exit.data)
 		*(.exitcall.exit)
 #ifndef CONFIG_MMU
diff -up --recursive --new-file linux-2.6.23-20071012.macro/arch/blackfin/kernel/vmlinux.lds.S linux-2.6.23-20071012/arch/blackfin/kernel/vmlinux.lds.S
--- linux-2.6.23-20071012.macro/arch/blackfin/kernel/vmlinux.lds.S	2007-10-12 02:56:53.000000000 +0000
+++ linux-2.6.23-20071012/arch/blackfin/kernel/vmlinux.lds.S	2007-10-12 13:53:22.000000000 +0000
@@ -94,6 +94,10 @@ SECTIONS
 		*(.init.text)
 		__einittext = .;
 	}
+	.init.str1 :
+	{
+		*(.init.str1)
+	}
 	.init.data :
 	{
 		. = ALIGN(16);
@@ -194,6 +198,7 @@ SECTIONS
 	/DISCARD/ :
 	{
 		*(.exit.text)
+		*(.exit.str1)
 		*(.exit.data)
 		*(.exitcall.exit)
 	}
diff -up --recursive --new-file linux-2.6.23-20071012.macro/arch/frv/kernel/vmlinux.lds.S linux-2.6.23-20071012/arch/frv/kernel/vmlinux.lds.S
--- linux-2.6.23-20071012.macro/arch/frv/kernel/vmlinux.lds.S	2007-09-04 04:55:18.000000000 +0000
+++ linux-2.6.23-20071012/arch/frv/kernel/vmlinux.lds.S	2007-10-12 13:53:22.000000000 +0000
@@ -35,6 +35,7 @@ SECTIONS
 #endif
   }
   _einittext = .;
+  .init.str1 : { *(.init.str1) }
   .init.data : { *(.init.data) }
 
   . = ALIGN(8);
@@ -124,6 +125,7 @@ SECTIONS
 	__trap_fixup_tables = .;
 	*(.trap.fixup.user .trap.fixup.kernel)
 
+	*(.exit.str1)
 	}
 
   . = ALIGN(8);		/* Exception table */
diff -up --recursive --new-file linux-2.6.23-20071012.macro/arch/h8300/kernel/vmlinux.lds.S linux-2.6.23-20071012/arch/h8300/kernel/vmlinux.lds.S
--- linux-2.6.23-20071012.macro/arch/h8300/kernel/vmlinux.lds.S	2007-07-10 04:55:29.000000000 +0000
+++ linux-2.6.23-20071012/arch/h8300/kernel/vmlinux.lds.S	2007-10-12 13:53:22.000000000 +0000
@@ -112,6 +112,7 @@ SECTIONS
 	__sinittext = .; 
 		*(.init.text)
 	__einittext = .; 
+		*(.init.str1)
 		*(.init.data)
 	. = ALIGN(0x4) ;
 	___setup_start = .;
@@ -125,6 +126,7 @@ SECTIONS
 		*(.con_initcall.init)
 	___con_initcall_end = .;
 		*(.exit.text)
+		*(.exit.str1)
 		*(.exit.data)
 #if defined(CONFIG_BLK_DEV_INITRD)
 		. = ALIGN(4);
diff -up --recursive --new-file linux-2.6.23-20071012.macro/arch/ia64/kernel/vmlinux.lds.S linux-2.6.23-20071012/arch/ia64/kernel/vmlinux.lds.S
--- linux-2.6.23-20071012.macro/arch/ia64/kernel/vmlinux.lds.S	2007-09-04 04:55:19.000000000 +0000
+++ linux-2.6.23-20071012/arch/ia64/kernel/vmlinux.lds.S	2007-10-12 13:53:22.000000000 +0000
@@ -28,6 +28,7 @@ SECTIONS
   /* Sections to be discarded */
   /DISCARD/ : {
 	*(.exit.text)
+	*(.exit.str1)
 	*(.exit.data)
 	*(.exitcall.exit)
 	*(.IA_64.unwind.exit.text)
@@ -123,6 +124,9 @@ SECTIONS
 	  _einittext = .;
 	}
 
+  .exit.str1 : AT(ADDR(.init.str1) - LOAD_OFFSET)
+	{ *(.exit.str1) }
+
   .init.data : AT(ADDR(.init.data) - LOAD_OFFSET)
 	{ *(.init.data) }
 
diff -up --recursive --new-file linux-2.6.23-20071012.macro/arch/m32r/kernel/vmlinux.lds.S linux-2.6.23-20071012/arch/m32r/kernel/vmlinux.lds.S
--- linux-2.6.23-20071012.macro/arch/m32r/kernel/vmlinux.lds.S	2007-09-04 04:55:19.000000000 +0000
+++ linux-2.6.23-20071012/arch/m32r/kernel/vmlinux.lds.S	2007-10-12 13:53:22.000000000 +0000
@@ -79,6 +79,7 @@ SECTIONS
 	*(.init.text)
 	_einittext = .;
   }
+  .init.str1 : { *(.init.str1) }
   .init.data : { *(.init.data) }
   . = ALIGN(16);
   __setup_start = .;
@@ -101,6 +102,7 @@ SECTIONS
   /* .exit.text is discard at runtime, not link time, to deal with references
      from .altinstructions and .eh_frame */
   .exit.text : { *(.exit.text) }
+  .exit.str1 : { *(.exit.str1) }
   .exit.data : { *(.exit.data) }
 
 #ifdef CONFIG_BLK_DEV_INITRD
diff -up --recursive --new-file linux-2.6.23-20071012.macro/arch/m68k/kernel/vmlinux-std.lds linux-2.6.23-20071012/arch/m68k/kernel/vmlinux-std.lds
--- linux-2.6.23-20071012.macro/arch/m68k/kernel/vmlinux-std.lds	2007-09-04 04:55:19.000000000 +0000
+++ linux-2.6.23-20071012/arch/m68k/kernel/vmlinux-std.lds	2007-10-12 13:53:22.000000000 +0000
@@ -48,6 +48,7 @@ SECTIONS
 	*(.init.text)
 	_einittext = .;
   }
+  .init.str1 : { *(.init.str1) }
   .init.data : { *(.init.data) }
   . = ALIGN(16);
   __setup_start = .;
@@ -83,6 +84,7 @@ SECTIONS
   /* Sections to be discarded */
   /DISCARD/ : {
 	*(.exit.text)
+	*(.exit.str1)
 	*(.exit.data)
 	*(.exitcall.exit)
 	}
diff -up --recursive --new-file linux-2.6.23-20071012.macro/arch/m68k/kernel/vmlinux-sun3.lds linux-2.6.23-20071012/arch/m68k/kernel/vmlinux-sun3.lds
--- linux-2.6.23-20071012.macro/arch/m68k/kernel/vmlinux-sun3.lds	2007-09-04 04:55:19.000000000 +0000
+++ linux-2.6.23-20071012/arch/m68k/kernel/vmlinux-sun3.lds	2007-10-12 13:53:22.000000000 +0000
@@ -41,6 +41,7 @@ __init_begin = .;
 		*(.init.text)
 		_einittext = .;
 	}
+	.init.str1 : { *(.init.str1) }
 	.init.data : { *(.init.data) }
 	. = ALIGN(16);
 	__setup_start = .;
@@ -78,6 +79,7 @@ __init_begin = .;
   /* Sections to be discarded */
   /DISCARD/ : {
 	*(.exit.text)
+	*(.exit.str1)
 	*(.exit.data)
 	*(.exitcall.exit)
 	}
diff -up --recursive --new-file linux-2.6.23-20071012.macro/arch/m68knommu/kernel/vmlinux.lds.S linux-2.6.23-20071012/arch/m68knommu/kernel/vmlinux.lds.S
--- linux-2.6.23-20071012.macro/arch/m68knommu/kernel/vmlinux.lds.S	2007-07-10 04:55:30.000000000 +0000
+++ linux-2.6.23-20071012/arch/m68knommu/kernel/vmlinux.lds.S	2007-10-12 13:53:22.000000000 +0000
@@ -145,6 +145,7 @@ SECTIONS {
 		_sinittext = .;
 		*(.init.text)
 		_einittext = .;
+		*(.init.str1)
 		*(.init.data)
 		. = ALIGN(16);
 		__setup_start = .;
@@ -171,6 +172,7 @@ SECTIONS {
 
 	/DISCARD/ : {
 		*(.exit.text)
+		*(.exit.str1)
 		*(.exit.data)
 		*(.exitcall.exit)
 	}
diff -up --recursive --new-file linux-2.6.23-20071012.macro/arch/mips/kernel/vmlinux.lds.S linux-2.6.23-20071012/arch/mips/kernel/vmlinux.lds.S
--- linux-2.6.23-20071012.macro/arch/mips/kernel/vmlinux.lds.S	2007-10-11 04:56:52.000000000 +0000
+++ linux-2.6.23-20071012/arch/mips/kernel/vmlinux.lds.S	2007-10-12 13:53:22.000000000 +0000
@@ -107,6 +107,9 @@ SECTIONS
 		*(.init.text)
 		_einittext = .;
 	}
+	.init.str1 : {
+		*(.init.str1)
+	}
 	.init.data : {
 		*(.init.data)
 	}
@@ -136,6 +139,9 @@ SECTIONS
 	.exit.text : {
 		*(.exit.text)
 	}
+	.exit.str1 : {
+		*(.exit.str1)
+	}
 	.exit.data : {
 		*(.exit.data)
 	}
diff -up --recursive --new-file linux-2.6.23-20071012.macro/arch/parisc/kernel/vmlinux.lds.S linux-2.6.23-20071012/arch/parisc/kernel/vmlinux.lds.S
--- linux-2.6.23-20071012.macro/arch/parisc/kernel/vmlinux.lds.S	2007-09-04 04:55:20.000000000 +0000
+++ linux-2.6.23-20071012/arch/parisc/kernel/vmlinux.lds.S	2007-10-12 13:53:22.000000000 +0000
@@ -150,6 +150,7 @@ SECTIONS
 	*(.init.text)
 	_einittext = .;
   }
+  .init.str1 : { *(.init.str1) }
   .init.data : { *(.init.data) }
   . = ALIGN(16);
   __setup_start = .;
@@ -176,6 +177,7 @@ SECTIONS
   /* .exit.text is discard at runtime, not link time, to deal with references
      from .altinstructions and .eh_frame */
   .exit.text : { *(.exit.text) }
+  .exit.str1 : { *(.exit.str1) }
   .exit.data : { *(.exit.data) }
 #ifdef CONFIG_BLK_DEV_INITRD
   . = ALIGN(ASM_PAGE_SIZE);
diff -up --recursive --new-file linux-2.6.23-20071012.macro/arch/powerpc/kernel/vmlinux.lds.S linux-2.6.23-20071012/arch/powerpc/kernel/vmlinux.lds.S
--- linux-2.6.23-20071012.macro/arch/powerpc/kernel/vmlinux.lds.S	2007-09-04 04:55:20.000000000 +0000
+++ linux-2.6.23-20071012/arch/powerpc/kernel/vmlinux.lds.S	2007-10-12 13:53:22.000000000 +0000
@@ -23,6 +23,7 @@ SECTIONS
 	/* Sections to be discarded. */
 	/DISCARD/ : {
 	*(.exitcall.exit)
+	*(.exit.str1)
 	*(.exit.data)
 	}
 
@@ -84,6 +85,8 @@ SECTIONS
 	 */
 	.exit.text : { *(.exit.text) }
 
+	.init.str1 : { *(.init.str1) }
+
 	.init.data : {
 		*(.init.data);
 		__vtop_table_begin = .;
diff -up --recursive --new-file linux-2.6.23-20071012.macro/arch/ppc/kernel/vmlinux.lds.S linux-2.6.23-20071012/arch/ppc/kernel/vmlinux.lds.S
--- linux-2.6.23-20071012.macro/arch/ppc/kernel/vmlinux.lds.S	2007-09-04 04:55:26.000000000 +0000
+++ linux-2.6.23-20071012/arch/ppc/kernel/vmlinux.lds.S	2007-10-12 13:53:22.000000000 +0000
@@ -101,6 +101,7 @@ SECTIONS
   /* .exit.text is discarded at runtime, not link time,
      to deal with references from __bug_table */
   .exit.text : { *(.exit.text) }
+  .init.str1 : { *(.init.str1) }
   .init.data : {
     *(.init.data);
     __vtop_table_begin = .;
@@ -162,6 +163,7 @@ SECTIONS
   /* Sections to be discarded. */
   /DISCARD/ : {
     *(.exitcall.exit)
+    *(.exit.str1)
     *(.exit.data)
   }
 }
diff -up --recursive --new-file linux-2.6.23-20071012.macro/arch/s390/kernel/vmlinux.lds.S linux-2.6.23-20071012/arch/s390/kernel/vmlinux.lds.S
--- linux-2.6.23-20071012.macro/arch/s390/kernel/vmlinux.lds.S	2007-09-04 04:55:27.000000000 +0000
+++ linux-2.6.23-20071012/arch/s390/kernel/vmlinux.lds.S	2007-10-12 13:53:22.000000000 +0000
@@ -87,6 +87,7 @@ SECTIONS
    * to deal with references from __bug_table
    */
   .exit.text :	 { *(.exit.text) }
+  .init.str1 : { *(.init.str1) }
 
   .init.data : { *(.init.data) }
   . = ALIGN(256);
@@ -124,7 +125,7 @@ SECTIONS
 
   /* Sections to be discarded */
   /DISCARD/ : {
-	*(.exit.data) *(.exitcall.exit)
+	*(.exit.str1) *(.exit.data) *(.exitcall.exit)
 	}
 
   /* Stabs debugging sections.  */
diff -up --recursive --new-file linux-2.6.23-20071012.macro/arch/sh/kernel/vmlinux.lds.S linux-2.6.23-20071012/arch/sh/kernel/vmlinux.lds.S
--- linux-2.6.23-20071012.macro/arch/sh/kernel/vmlinux.lds.S	2007-09-04 04:55:28.000000000 +0000
+++ linux-2.6.23-20071012/arch/sh/kernel/vmlinux.lds.S	2007-10-12 13:53:22.000000000 +0000
@@ -74,6 +74,7 @@ SECTIONS
   _sinittext = .;
   .init.text : { *(.init.text) }
   _einittext = .;
+  .init.str1 : { *(.init.str1) }
   .init.data : { *(.init.data) }
   . = ALIGN(16);
   __setup_start = .;
diff -up --recursive --new-file linux-2.6.23-20071012.macro/arch/sh64/kernel/vmlinux.lds.S linux-2.6.23-20071012/arch/sh64/kernel/vmlinux.lds.S
--- linux-2.6.23-20071012.macro/arch/sh64/kernel/vmlinux.lds.S	2007-09-04 04:55:29.000000000 +0000
+++ linux-2.6.23-20071012/arch/sh64/kernel/vmlinux.lds.S	2007-10-12 13:53:22.000000000 +0000
@@ -105,6 +105,7 @@ SECTIONS
   _sinittext = .;
   .init.text : C_PHYS(.init.text) { *(.init.text) }
   _einittext = .;
+  .init.str1 : C_PHYS(.init.str1) { *(.init.str1) }
   .init.data : C_PHYS(.init.data) { *(.init.data) }
   . = ALIGN(L1_CACHE_BYTES);	/* Better if Cache Line aligned */
   __setup_start = .;
@@ -141,6 +142,7 @@ SECTIONS
   /* Sections to be discarded */
   /DISCARD/ : {
 	*(.exit.text)
+	*(.exit.str1)
 	*(.exit.data)
 	*(.exitcall.exit)
 	}
diff -up --recursive --new-file linux-2.6.23-20071012.macro/arch/sparc/kernel/vmlinux.lds.S linux-2.6.23-20071012/arch/sparc/kernel/vmlinux.lds.S
--- linux-2.6.23-20071012.macro/arch/sparc/kernel/vmlinux.lds.S	2007-09-04 04:55:29.000000000 +0000
+++ linux-2.6.23-20071012/arch/sparc/kernel/vmlinux.lds.S	2007-10-12 13:53:22.000000000 +0000
@@ -45,6 +45,7 @@ SECTIONS
   }
   _einittext = .;
   __init_text_end = .;
+  .init.str1 : { *(.init.str1) }
   .init.data : { *(.init.data) }
   . = ALIGN(16);
   __setup_start = .;
@@ -83,7 +84,7 @@ SECTIONS
   }
   _end = . ;
   PROVIDE (end = .);
-  /DISCARD/ : { *(.exit.text) *(.exit.data) *(.exitcall.exit) }
+  /DISCARD/ : { *(.exit.text) *(.exit.str1) *(.exit.data) *(.exitcall.exit) }
 
   STABS_DEBUG
 
diff -up --recursive --new-file linux-2.6.23-20071012.macro/arch/sparc64/kernel/vmlinux.lds.S linux-2.6.23-20071012/arch/sparc64/kernel/vmlinux.lds.S
--- linux-2.6.23-20071012.macro/arch/sparc64/kernel/vmlinux.lds.S	2007-09-04 04:55:30.000000000 +0000
+++ linux-2.6.23-20071012/arch/sparc64/kernel/vmlinux.lds.S	2007-10-12 13:53:22.000000000 +0000
@@ -54,6 +54,7 @@ SECTIONS
 	*(.init.text)
 	_einittext = .;
   }
+  .init.str1 : { *(.init.str1) }
   .init.data : { *(.init.data) }
   . = ALIGN(16);
   __setup_start = .;
@@ -106,7 +107,7 @@ SECTIONS
   }
   _end = . ;
   PROVIDE (end = .);
-  /DISCARD/ : { *(.exit.text) *(.exit.data) *(.exitcall.exit) }
+  /DISCARD/ : { *(.exit.text) *(.exit.str1) *(.exit.data) *(.exitcall.exit) }
 
   STABS_DEBUG
 
diff -up --recursive --new-file linux-2.6.23-20071012.macro/arch/um/kernel/dyn.lds.S linux-2.6.23-20071012/arch/um/kernel/dyn.lds.S
--- linux-2.6.23-20071012.macro/arch/um/kernel/dyn.lds.S	2007-09-04 04:55:30.000000000 +0000
+++ linux-2.6.23-20071012/arch/um/kernel/dyn.lds.S	2007-10-12 13:53:22.000000000 +0000
@@ -22,6 +22,7 @@ SECTIONS
 	*(.init.text)
 	_einittext = .;
   }
+  .init.str1 : { *(.init.str1) }
 
   . = ALIGN(4096);
 
diff -up --recursive --new-file linux-2.6.23-20071012.macro/arch/um/kernel/uml.lds.S linux-2.6.23-20071012/arch/um/kernel/uml.lds.S
--- linux-2.6.23-20071012.macro/arch/um/kernel/uml.lds.S	2007-09-04 04:55:30.000000000 +0000
+++ linux-2.6.23-20071012/arch/um/kernel/uml.lds.S	2007-10-12 13:53:22.000000000 +0000
@@ -33,6 +33,7 @@ SECTIONS
 	*(.init.text)
 	_einittext = .;
   }
+  .init.str1 : { *(.init.str1) }
   . = ALIGN(4096);
 
   .text      :
diff -up --recursive --new-file linux-2.6.23-20071012.macro/arch/v850/kernel/vmlinux.lds.S linux-2.6.23-20071012/arch/v850/kernel/vmlinux.lds.S
--- linux-2.6.23-20071012.macro/arch/v850/kernel/vmlinux.lds.S	2007-07-10 04:55:50.000000000 +0000
+++ linux-2.6.23-20071012/arch/v850/kernel/vmlinux.lds.S	2007-10-12 13:53:22.000000000 +0000
@@ -99,6 +99,7 @@
 			*(.text.lock)					      \
 			*(.exitcall.exit)				      \
 		__real_etext = . ;	/* There may be data after here.  */  \
+			*(.exit.str1)					      \
 		RODATA_CONTENTS						      \
 		. = ALIGN (4) ;						      \
 		    	*(.call_table_data)				      \
@@ -159,6 +160,7 @@
 			__sinittext = .;				      \
 			*(.init.text)	/* 2.5 convention */		      \
 			__einittext = .;				      \
+			*(.init.str1)					      \
 			*(.init.data)					      \
 			*(.text.init)	/* 2.4 convention */		      \
 			*(.data.init)					      \
diff -up --recursive --new-file linux-2.6.23-20071012.macro/arch/x86/kernel/vmlinux_32.lds.S linux-2.6.23-20071012/arch/x86/kernel/vmlinux_32.lds.S
--- linux-2.6.23-20071012.macro/arch/x86/kernel/vmlinux_32.lds.S	2007-10-12 02:56:54.000000000 +0000
+++ linux-2.6.23-20071012/arch/x86/kernel/vmlinux_32.lds.S	2007-10-12 13:53:22.000000000 +0000
@@ -134,6 +134,7 @@ SECTIONS
 	*(.init.text)
 	_einittext = .;
   }
+  .init.str1 : AT(ADDR(.init.str1) - LOAD_OFFSET) { *(.init.str1) }
   .init.data : AT(ADDR(.init.data) - LOAD_OFFSET) { *(.init.data) }
   . = ALIGN(16);
   .init.setup : AT(ADDR(.init.setup) - LOAD_OFFSET) {
@@ -170,6 +171,7 @@ SECTIONS
   /* .exit.text is discard at runtime, not link time, to deal with references
      from .altinstructions and .eh_frame */
   .exit.text : AT(ADDR(.exit.text) - LOAD_OFFSET) { *(.exit.text) }
+  .exit.str1 : AT(ADDR(.exit.str1) - LOAD_OFFSET) { *(.exit.str1) }
   .exit.data : AT(ADDR(.exit.data) - LOAD_OFFSET) { *(.exit.data) }
 #if defined(CONFIG_BLK_DEV_INITRD)
   . = ALIGN(4096);
diff -up --recursive --new-file linux-2.6.23-20071012.macro/arch/x86/kernel/vmlinux_64.lds.S linux-2.6.23-20071012/arch/x86/kernel/vmlinux_64.lds.S
--- linux-2.6.23-20071012.macro/arch/x86/kernel/vmlinux_64.lds.S	2007-10-12 02:56:54.000000000 +0000
+++ linux-2.6.23-20071012/arch/x86/kernel/vmlinux_64.lds.S	2007-10-12 13:53:22.000000000 +0000
@@ -158,6 +158,7 @@ SECTIONS
 	*(.init.text)
 	_einittext = .;
   }
+  .init.str1 : AT(ADDR(.init.str1) - LOAD_OFFSET) { *(.init.str1) }
   __initdata_begin = .;
   .init.data : AT(ADDR(.init.data) - LOAD_OFFSET) { *(.init.data) }
   __initdata_end = .;
@@ -188,6 +189,7 @@ SECTIONS
   /* .exit.text is discard at runtime, not link time, to deal with references
      from .altinstructions and .eh_frame */
   .exit.text : AT(ADDR(.exit.text) - LOAD_OFFSET) { *(.exit.text) }
+  .exit.str1 : AT(ADDR(.exit.str1) - LOAD_OFFSET) { *(.exit.str1) }
   .exit.data : AT(ADDR(.exit.data) - LOAD_OFFSET) { *(.exit.data) }
 
 /* vdso blob that is mapped into user space */
diff -up --recursive --new-file linux-2.6.23-20071012.macro/arch/xtensa/kernel/vmlinux.lds.S linux-2.6.23-20071012/arch/xtensa/kernel/vmlinux.lds.S
--- linux-2.6.23-20071012.macro/arch/xtensa/kernel/vmlinux.lds.S	2007-09-04 04:55:30.000000000 +0000
+++ linux-2.6.23-20071012/arch/xtensa/kernel/vmlinux.lds.S	2007-10-12 13:53:22.000000000 +0000
@@ -140,6 +140,8 @@ SECTIONS
 	_einittext = .;
   }
 
+  .init.str1 : { *(.init.str1) }
+
   .init.data :
   {
     *(.init.data)
@@ -279,6 +281,7 @@ SECTIONS
   /DISCARD/ :
   {
   	*(.exit.literal .exit.text)
+	*(.exit.str1)
   	*(.exit.data)
         *(.exitcall.exit)
   }
diff -up --recursive --new-file linux-2.6.23-20071012.macro/include/asm-um/common.lds.S linux-2.6.23-20071012/include/asm-um/common.lds.S
--- linux-2.6.23-20071012.macro/include/asm-um/common.lds.S	2007-09-04 04:56:18.000000000 +0000
+++ linux-2.6.23-20071012/include/asm-um/common.lds.S	2007-10-12 13:53:22.000000000 +0000
@@ -98,6 +98,7 @@
   /* .exit.text is discard at runtime, not link time, to deal with references
      from .altinstructions and .eh_frame */
   .exit.text : { *(.exit.text) }
+  .exit.str1 : { *(.exit.str1) }
   .exit.data : { *(.exit.data) }
 
   .preinit_array : {
diff -up --recursive --new-file linux-2.6.23-20071012.macro/include/linux/init.h linux-2.6.23-20071012/include/linux/init.h
--- linux-2.6.23-20071012.macro/include/linux/init.h	2007-10-12 02:56:54.000000000 +0000
+++ linux-2.6.23-20071012/include/linux/init.h	2007-10-12 13:53:22.000000000 +0000
@@ -36,6 +36,20 @@
  * section.
  * 
  * Also note, that this data cannot be "const".
+ *
+ * For strings:
+ * Use __initstr, __exitstr like __initdata:
+ *
+ * static const char welcome[] __initstr = "Hello World!\n";
+ * static const char goodbye[] __exitstr = "Farewell then.\n";
+ *
+ * but also:
+ *
+ * pr_info(_i("%s: Thanks for selecting, will do my best\n"), dev->name);
+ * pr_info(_e("%s: Hope to be of use again soon\n"), dev->name);
+ *
+ * Note that strings have to be "const" and they are put in mergeable
+ * sections which means the linker will do nasty things to them. ;-)
  */
 
 /* These are for everybody (although not all archs will actually
@@ -45,6 +59,24 @@
 #define __exitdata	__attribute__ ((__section__(".exit.data")))
 #define __exit_call	__attribute_used__ __attribute__ ((__section__ (".exitcall.exit")))
 
+#define __initstr	__attribute__((__section__(".init.str1" __strflags)))
+#define __exitstr	__attribute__((__section__(".exit.str1" __strflags)))
+
+#define _i(str)								\
+({									\
+	static const char __istr[] __initstr = (str);			\
+	__istr;								\
+})
+#define _e(str)								\
+({									\
+	static const char __estr[] __exitstr = (str);			\
+	__istr;								\
+})
+
+/* Internal implementation detail for the above; just disregard. ;-)  */
+#define __strflags	",\"aMS\",@progbits,1\n"			\
+			"# Useless section flags supplied by GCC follow: "
+
 /* modpost check for section mismatches during the kernel build.
  * A section mismatch happens when there are references from a
  * code or data section to an init section (both code or data).
@@ -247,46 +279,74 @@ void __init parse_early_param(void);
 #ifdef CONFIG_MODULES
 #define __init_or_module
 #define __initdata_or_module
+#define __initstr_or_module
+#define _iom(str) (str)
 #else
 #define __init_or_module __init
 #define __initdata_or_module __initdata
+#define __initstr_or_module __initstr
+#define _iom(str) _i(str)
 #endif /*CONFIG_MODULES*/
 
 #ifdef CONFIG_HOTPLUG
 #define __devinit
 #define __devinitdata
+#define __devinitstr
+#define _di(str) (str)
 #define __devexit
 #define __devexitdata
+#define __devexitstr
+#define _de(str) (str)
 #else
 #define __devinit __init
 #define __devinitdata __initdata
+#define __devinitstr __initstr
+#define _di(str) _i(str)
 #define __devexit __exit
 #define __devexitdata __exitdata
+#define __devexitstr __exitstr
+#define _de(str) _e(str)
 #endif
 
 #ifdef CONFIG_HOTPLUG_CPU
 #define __cpuinit
 #define __cpuinitdata
+#define __cpuinitstr
+#define _ci(str) (str)
 #define __cpuexit
 #define __cpuexitdata
+#define __cpuexitstr
+#define _ce(str) (str)
 #else
 #define __cpuinit	__init
 #define __cpuinitdata __initdata
+#define __cpuinitstr __initstr
+#define _ci(str) _i(str)
 #define __cpuexit __exit
 #define __cpuexitdata	__exitdata
+#define __cpuexitstr __exitstr
+#define _ce(str) _e(str)
 #endif
 
 #if defined(CONFIG_MEMORY_HOTPLUG) || defined(CONFIG_ACPI_HOTPLUG_MEMORY) \
 	|| defined(CONFIG_ACPI_HOTPLUG_MEMORY_MODULE)
 #define __meminit
 #define __meminitdata
+#define __meminitstr
+#define _mi(str) (str)
 #define __memexit
 #define __memexitdata
+#define __memexitstr
+#define _me(str) (str)
 #else
 #define __meminit	__init
 #define __meminitdata __initdata
+#define __meminitstr __initstr
+#define _mi(str) _i(str)
 #define __memexit __exit
 #define __memexitdata	__exitdata
+#define __memexitstr __exitstr
+#define _me(str) _e(str)
 #endif
 
 /* Functions marked as __devexit may be discarded at kernel link time, depending
