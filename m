Return-Path: <linux-kernel-owner+w=401wt.eu-S1751533AbZI0R6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbZI0R6Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 13:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750999AbZI0R6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 13:58:22 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:52221 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751071AbZI0R6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 13:58:21 -0400
Date: Sun, 27 Sep 2009 13:57:55 -0400 (EDT)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@dr-wily.mit.edu
To: Andreas Schwab <schwab@linux-m68k.org>
cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Roman Zippel <zippel@linux-m68k.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH v2 2/2] m68k: Cleanup linker scripts using new linker 
 script macros.
In-Reply-To: <m2ocowwngg.fsf@igel.home>
Message-ID: <alpine.DEB.1.10.0909271351110.14151@dr-wily.mit.edu>
References: <1253119466-19488-1-git-send-email-tabbott@ksplice.com> <1253119466-19488-3-git-send-email-tabbott@ksplice.com> <10f740e80909270258o6bde0f3dk720bd5b5c091ed2f@mail.gmail.com> <m2ocowwngg.fsf@igel.home>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Sep 2009, Andreas Schwab wrote:

> Geert Uytterhoeven <geert@linux-m68k.org> writes:
> 
> > On Wed, Sep 16, 2009 at 18:44, Tim Abbott <tabbott@ksplice.com> wrote:
> >> Signed-off-by: Tim Abbott <tabbott@ksplice.com>
> >> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> >> Cc: Roman Zippel <zippel@linux-m68k.org>
> >> Cc: linux-m68k@lists.linux-m68k.org
> >> Cc: Sam Ravnborg <sam@ravnborg.org>
> >
> > This patch must do something wrong, as it now fails to boot on ARAnyM:
> >
> > | CPU: Double bus fault detected !
> > | CPU: Halting
> >
> > Haven't investigated why yet, though...
> 
> The problem is that _end no longer matches the end of the load segment.
> Previously, the .data.init_task section was the last allocated item in
> the linker script, now the last item is an align.  This align does not
> affect the memsize of the segment.  The startup code expects the boot
> info to be placed at _end, but the boot loader puts it at the end of the
> load segment, which is the best it can do.

Below is a new version of the second patch that attempts to address this 
by putting the ALIGN inside a section, so that _end is at the end of the 
load segment (I also did a bit more cleanup):

  .init_end : {
	/* This ALIGN be in a section so that _end is at the end of the
	   load segment. */
	. = ALIGN(PAGE_SIZE);
	__init_end = .;
  }
  
  _end = .;

	-Tim Abbott

m68k: Cleanup linker scripts using new linker script macros.

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-m68k@lists.linux-m68k.org
Cc: Sam Ravnborg <sam@ravnborg.org>
---
 arch/m68k/kernel/vmlinux-std.lds  |   61 ++++++++-----------------------------
 arch/m68k/kernel/vmlinux-sun3.lds |   54 ++++----------------------------
 2 files changed, 20 insertions(+), 95 deletions(-)

diff --git a/arch/m68k/kernel/vmlinux-std.lds b/arch/m68k/kernel/vmlinux-std.lds
index 47eac19..878be5f 100644
--- a/arch/m68k/kernel/vmlinux-std.lds
+++ b/arch/m68k/kernel/vmlinux-std.lds
@@ -2,6 +2,7 @@
 
 #include <asm-generic/vmlinux.lds.h>
 #include <asm/page.h>
+#include <asm/thread_info.h>
 
 OUTPUT_FORMAT("elf32-m68k", "elf32-m68k", "elf32-m68k")
 OUTPUT_ARCH(m68k)
@@ -22,73 +23,37 @@ SECTIONS
 
   _etext = .;			/* End of text section */
 
-  . = ALIGN(16);		/* Exception table */
-  __start___ex_table = .;
-  __ex_table : { *(__ex_table) }
-  __stop___ex_table = .;
+  EXCEPTION_TABLE(16)
 
   RODATA
 
-  .data : {			/* Data */
-	DATA_DATA
-	CONSTRUCTORS
-	}
+  RW_DATA_SECTION(16, PAGE_SIZE, THREAD_SIZE)
 
-  . = ALIGN(16);
-  .data.cacheline_aligned : { *(.data.cacheline_aligned) }
-
-  .bss : { *(.bss) }		/* BSS */
+  BSS_SECTION(0, 0, 0)
 
   _edata = .;			/* End of data section */
 
   /* will be freed after init */
   . = ALIGN(PAGE_SIZE);		/* Init code and data */
   __init_begin = .;
-  .init.text : {
-	_sinittext = .;
-	INIT_TEXT
-	_einittext = .;
-  } :data
-  .init.data : { INIT_DATA }
-  . = ALIGN(16);
-  __setup_start = .;
-  .init.setup : { *(.init.setup) }
-  __setup_end = .;
-  __initcall_start = .;
-  .initcall.init : {
-	INITCALLS
-  }
-  __initcall_end = .;
-  __con_initcall_start = .;
-  .con_initcall.init : { *(.con_initcall.init) }
-  __con_initcall_end = .;
+  INIT_TEXT_SECTION(PAGE_SIZE) :data
+  INIT_DATA_SECTION(16)
   .m68k_fixup : {
 	__start_fixup = .;
 	*(.m68k_fixup)
 	__stop_fixup = .;
   }
-  SECURITY_INIT
-#ifdef CONFIG_BLK_DEV_INITRD
-  . = ALIGN(8192);
-  __initramfs_start = .;
-  .init.ramfs : { *(.init.ramfs) }
-  __initramfs_end = .;
-#endif
   NOTES
-  . = ALIGN(8192);
-  __init_end = .;
-
-  .data.init_task : { *(.data.init_task) }	/* The initial task and kernel stack */
+  .init_end : {
+	/* This ALIGN be in a section so that _end is at the end of the
+	   load segment. */
+	. = ALIGN(PAGE_SIZE);
+	__init_end = .;
+  }
 
   _end = . ;
 
-  /* Stabs debugging sections.  */
-  .stab 0 : { *(.stab) }
-  .stabstr 0 : { *(.stabstr) }
-  .stab.excl 0 : { *(.stab.excl) }
-  .stab.exclstr 0 : { *(.stab.exclstr) }
-  .stab.index 0 : { *(.stab.index) }
-  .stab.indexstr 0 : { *(.stab.indexstr) }
+  STABS_DEBUG
   .comment 0 : { *(.comment) }
 
   /* Sections to be discarded */
diff --git a/arch/m68k/kernel/vmlinux-sun3.lds b/arch/m68k/kernel/vmlinux-sun3.lds
index 03efaf0..1ad6b7a 100644
--- a/arch/m68k/kernel/vmlinux-sun3.lds
+++ b/arch/m68k/kernel/vmlinux-sun3.lds
@@ -2,6 +2,7 @@
 
 #include <asm-generic/vmlinux.lds.h>
 #include <asm/page.h>
+#include <asm/thread_info.h>
 
 OUTPUT_FORMAT("elf32-m68k", "elf32-m68k", "elf32-m68k")
 OUTPUT_ARCH(m68k)
@@ -23,14 +24,8 @@ SECTIONS
 
   _etext = .;			/* End of text section */
 
-  .data : {			/* Data */
-	DATA_DATA
-	CONSTRUCTORS
-	. = ALIGN(16);		/* Exception table */
-	__start___ex_table = .;
-	*(__ex_table)
-	__stop___ex_table = .;
-	} :data
+  EXCEPTION_TABLE(16) :data
+  RW_DATA_SECTION(16, PAGE_SIZE, THREAD_SIZE) :data
   /* End of data goes *here* so that freeing init code works properly. */
   _edata = .;
   NOTES
@@ -38,56 +33,21 @@ SECTIONS
   /* will be freed after init */
   . = ALIGN(PAGE_SIZE);	/* Init code and data */
 __init_begin = .;
-	.init.text : {
-		_sinittext = .;
-		INIT_TEXT
-		_einittext = .;
-	}
-	.init.data : { INIT_DATA }
-	. = ALIGN(16);
-	__setup_start = .;
-	.init.setup : { *(.init.setup) }
-	__setup_end = .;
-	__initcall_start = .;
-	.initcall.init : {
-		INITCALLS
-	}
-	__initcall_end = .;
-	__con_initcall_start = .;
-	.con_initcall.init : { *(.con_initcall.init) }
-	__con_initcall_end = .;
+	INIT_TEXT_SECTION(PAGE_SIZE)
+	INIT_DATA_SECTION(16)
 	.m68k_fixup : {
 		__start_fixup = .;
 		*(.m68k_fixup)
 		__stop_fixup = .;
 	}
-	SECURITY_INIT
-#ifdef CONFIG_BLK_DEV_INITRD
-	. = ALIGN(PAGE_SIZE);
-	__initramfs_start = .;
-	.init.ramfs : { *(.init.ramfs) }
-	__initramfs_end = .;
-#endif
 	. = ALIGN(PAGE_SIZE);
 	__init_end = .;
-	.data.init.task : { *(.data.init_task) }
-
 
-  .bss : { *(.bss) }		/* BSS */
+  BSS_SECTION(0, 0, 0)
 
   _end = . ;
 
-  .crap : {
-	/* Stabs debugging sections.  */
-	*(.stab)
-	*(.stabstr)
-	*(.stab.excl)
-	*(.stab.exclstr)
-	*(.stab.index)
-	*(.stab.indexstr)
-	*(.comment)
-	*(.note)
-  }
+  STABS_DEBUG
 
   /* Sections to be discarded */
   DISCARDS
-- 
1.6.3.3

