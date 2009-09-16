Return-Path: <linux-kernel-owner+w=401wt.eu-S933558AbZIPQpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933558AbZIPQpM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 12:45:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759927AbZIPQpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 12:45:08 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:41161 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759924AbZIPQpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 12:45:04 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
       Roman Zippel <zippel@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Tim Abbott <tabbott@ksplice.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [PATCH v2 2/2] m68k: Cleanup linker scripts using new linker script macros.
Date: Wed, 16 Sep 2009 12:44:26 -0400
Message-Id: <1253119466-19488-3-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253119466-19488-1-git-send-email-tabbott@ksplice.com>
References: <1253119466-19488-1-git-send-email-tabbott@ksplice.com>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-m68k@lists.linux-m68k.org
Cc: Sam Ravnborg <sam@ravnborg.org>
---
 arch/m68k/kernel/vmlinux-std.lds  |   53 +++++++-----------------------------
 arch/m68k/kernel/vmlinux-sun3.lds |   53 +++++++------------------------------
 2 files changed, 21 insertions(+), 85 deletions(-)

diff --git a/arch/m68k/kernel/vmlinux-std.lds b/arch/m68k/kernel/vmlinux-std.lds
index 47eac19..5927487 100644
--- a/arch/m68k/kernel/vmlinux-std.lds
+++ b/arch/m68k/kernel/vmlinux-std.lds
@@ -2,6 +2,7 @@
 
 #include <asm-generic/vmlinux.lds.h>
 #include <asm/page.h>
+#include <asm/thread_info.h>
 
 OUTPUT_FORMAT("elf32-m68k", "elf32-m68k", "elf32-m68k")
 OUTPUT_ARCH(m68k)
@@ -22,73 +23,41 @@ SECTIONS
 
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
+  INIT_TEXT_SECTION(PAGE_SIZE) :data
+  INIT_DATA_SECTION(16)
   .init.data : { INIT_DATA }
-  . = ALIGN(16);
-  __setup_start = .;
-  .init.setup : { *(.init.setup) }
-  __setup_end = .;
-  __initcall_start = .;
+  .init.setup : { INIT_SETUP(16) }
   .initcall.init : {
-	INITCALLS
+	INIT_CALLS
   }
-  __initcall_end = .;
-  __con_initcall_start = .;
-  .con_initcall.init : { *(.con_initcall.init) }
-  __con_initcall_end = .;
+  .con_initcall.init : { CON_INITCALL }
   .m68k_fixup : {
 	__start_fixup = .;
 	*(.m68k_fixup)
 	__stop_fixup = .;
   }
   SECURITY_INIT
-#ifdef CONFIG_BLK_DEV_INITRD
-  . = ALIGN(8192);
-  __initramfs_start = .;
-  .init.ramfs : { *(.init.ramfs) }
-  __initramfs_end = .;
-#endif
+  .init.ramfs : { INIT_RAM_FS }
   NOTES
   . = ALIGN(8192);
   __init_end = .;
 
-  .data.init_task : { *(.data.init_task) }	/* The initial task and kernel stack */
-
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
index 03efaf0..607d214 100644
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
+  EXCEPTION_TABLE(16)
+  RW_DATA_SECTION(16, PAGE_SIZE, THREAD_SIZE) :data
   /* End of data goes *here* so that freeing init code works properly. */
   _edata = .;
   NOTES
@@ -38,56 +33,28 @@ SECTIONS
   /* will be freed after init */
   . = ALIGN(PAGE_SIZE);	/* Init code and data */
 __init_begin = .;
-	.init.text : {
-		_sinittext = .;
-		INIT_TEXT
-		_einittext = .;
-	}
+	INIT_TEXT_SECTION(PAGE_SIZE)
 	.init.data : { INIT_DATA }
-	. = ALIGN(16);
-	__setup_start = .;
-	.init.setup : { *(.init.setup) }
-	__setup_end = .;
-	__initcall_start = .;
+	.init.setup : { INIT_SETUP(16) }
 	.initcall.init : {
-		INITCALLS
+		INIT_CALLS
 	}
-	__initcall_end = .;
-	__con_initcall_start = .;
-	.con_initcall.init : { *(.con_initcall.init) }
-	__con_initcall_end = .;
+	.con_initcall.init : { CON_INITCALL }
 	.m68k_fixup : {
 		__start_fixup = .;
 		*(.m68k_fixup)
 		__stop_fixup = .;
 	}
 	SECURITY_INIT
-#ifdef CONFIG_BLK_DEV_INITRD
-	. = ALIGN(PAGE_SIZE);
-	__initramfs_start = .;
-	.init.ramfs : { *(.init.ramfs) }
-	__initramfs_end = .;
-#endif
+	.init.ramfs : { INIT_RAM_FS }
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

