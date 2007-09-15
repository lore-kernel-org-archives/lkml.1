Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592AbXIOVVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbXIOVVq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 17:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbXIOVVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 17:21:39 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:53600 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbXIOVVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 17:21:38 -0400
Date: Sat, 15 Sep 2007 23:23:00 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: rth@twiddle.net, ink@jurassic.park.msu.ru,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] alpha: beautify vmlinux.lds
Message-ID: <20070915212300.GA15365@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Introduced a consistent style in vmlinux.lds and
it now matches the soon-to-be common style for
all arch's vmlinux.lds files.

In addition:
- Replaced hardcoded constant with PAGE_SIZE
- Fix page.h so PAGE_SIZE can be used from assembler and in lds files
- Move a few labels inside brackets so linker alignment will not
  make label point ot a too low address
- Replaced DWARF and STABS sections with definitions from asm-generic

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
build tested only

	Sam

diff --git a/arch/alpha/kernel/vmlinux.lds.S b/arch/alpha/kernel/vmlinux.lds.S
index 7af07d3..55c05b5 100644
--- a/arch/alpha/kernel/vmlinux.lds.S
+++ b/arch/alpha/kernel/vmlinux.lds.S
@@ -1,4 +1,5 @@
 #include <asm-generic/vmlinux.lds.h>
+#include <asm/page.h>
 
 OUTPUT_FORMAT("elf64-alpha")
 OUTPUT_ARCH(alpha)
@@ -8,138 +9,145 @@ jiffies = jiffies_64;
 SECTIONS
 {
 #ifdef CONFIG_ALPHA_LEGACY_START_ADDRESS
-  . = 0xfffffc0000310000;
+	. = 0xfffffc0000310000;
 #else
-  . = 0xfffffc0001010000;
+	. = 0xfffffc0001010000;
 #endif
 
-  _text = .;					/* Text and read-only data */
-  .text : { 
+	_text = .;	/* Text and read-only data */
+	.text : {
 	*(.text.head)
-	TEXT_TEXT
-	SCHED_TEXT
-	LOCK_TEXT
-	*(.fixup)
-	*(.gnu.warning)
-  } :kernel
-  _etext = .;					/* End of text section */
-
-  . = ALIGN(16);
-  __start___ex_table = .;			/* Exception table */
-  __ex_table : { *(__ex_table) }
-  __stop___ex_table = .;
-
-  NOTES :kernel :note
-  .dummy : { *(.dummy) } :kernel
-
-  RODATA
-
-  /* Will be freed after init */
-  . = ALIGN(8192);				/* Init code and data */
-  __init_begin = .;
-  .init.text : { 
-	_sinittext = .;
-	*(.init.text)
-	_einittext = .;
-  }
-  .init.data : { *(.init.data) }
-
-  . = ALIGN(16);
-  __setup_start = .;
-  .init.setup : { *(.init.setup) }
-  __setup_end = .;
-
-  . = ALIGN(8);
-  __initcall_start = .;
-  .initcall.init : {
-	INITCALLS
-  }
-  __initcall_end = .;
+		TEXT_TEXT
+		SCHED_TEXT
+		LOCK_TEXT
+		*(.fixup)
+		*(.gnu.warning)
+	} :kernel
+	_etext = .;	/* End of text section */
+
+	/* Exception table */
+	. = ALIGN(16);
+	__ex_table : {
+		__start___ex_table = .;
+		*(__ex_table)
+		__stop___ex_table = .;
+	}
+
+	NOTES :kernel :note
+	.dummy : {
+		*(.dummy)
+	} :kernel
+
+	RODATA
+
+	/* Will be freed after init */
+	. = ALIGN(PAGE_SIZE);
+	/* Init code and data */
+	__init_begin = .;
+	.init.text : {
+		_sinittext = .;
+		*(.init.text)
+		_einittext = .;
+	}
+	.init.data : {
+		*(.init.data)
+	}
+
+	. = ALIGN(16);
+	.init.setup : {
+		__setup_start = .;
+		*(.init.setup)
+		__setup_end = .;
+	}
+
+	. = ALIGN(8);
+	.initcall.init : {
+		__initcall_start = .;
+		INITCALLS
+		__initcall_end = .;
+	}
 
 #ifdef CONFIG_BLK_DEV_INITRD
-  . = ALIGN(8192);
-  __initramfs_start = .;
-  .init.ramfs : { *(.init.ramfs) }
-  __initramfs_end = .;
+	. = ALIGN(PAGE_SIZE);
+	.init.ramfs : {
+		__initramfs_start = .;
+		*(.init.ramfs)
+		__initramfs_end = .;
+	}
 #endif
 
-  . = ALIGN(8);
-  .con_initcall.init : {
-	__con_initcall_start = .;
-	*(.con_initcall.init)
-	__con_initcall_end = .;
-  }
-
-  . = ALIGN(8);
-  SECURITY_INIT
-
-  PERCPU(8192)
-
-  . = ALIGN(2*8192);
-  __init_end = .;
-  /* Freed after init ends here */
-
-  /* Note 2 page alignment above.  */
-  .data.init_thread : { *(.data.init_thread) }
-
-  . = ALIGN(8192);
-  .data.page_aligned : { *(.data.page_aligned) }
-
-  . = ALIGN(64);
-  .data.cacheline_aligned : { *(.data.cacheline_aligned) }
-
-  _data = .;
-  .data : {					/* Data */
-	DATA_DATA
-	CONSTRUCTORS
-  }
-
-  .got : { *(.got) }
-  .sdata : { *(.sdata) }
-
-  _edata = .;					/* End of data section */
-
-  __bss_start = .;
-  .sbss : { *(.sbss) *(.scommon) }
-  .bss : { *(.bss) *(COMMON) }
-  __bss_stop = .;
-
-  _end = .;
-
-  /* Sections to be discarded */
-  /DISCARD/ : { *(.exit.text) *(.exit.data) *(.exitcall.exit) }
-
-  .mdebug 0 : { *(.mdebug) }
-  .note 0 : { *(.note) }
-  .comment 0 : { *(.comment) }
-
-  /* Stabs debugging sections */
-  .stab 0 : { *(.stab) }
-  .stabstr 0 : { *(.stabstr) }
-  .stab.excl 0 : { *(.stab.excl) }
-  .stab.exclstr 0 : { *(.stab.exclstr) }
-  .stab.index 0 : { *(.stab.index) }
-  .stab.indexstr 0 : { *(.stab.indexstr) }
-  /* DWARF 1 */
-  .debug          0 : { *(.debug) }
-  .line           0 : { *(.line) }
-  /* GNU DWARF 1 extensions */
-  .debug_srcinfo  0 : { *(.debug_srcinfo) }
-  .debug_sfnames  0 : { *(.debug_sfnames) }
-  /* DWARF 1.1 and DWARF 2 */
-  .debug_aranges  0 : { *(.debug_aranges) }
-  .debug_pubnames 0 : { *(.debug_pubnames) }
-  /* DWARF 2 */
-  .debug_info     0 : { *(.debug_info) }
-  .debug_abbrev   0 : { *(.debug_abbrev) }
-  .debug_line     0 : { *(.debug_line) }
-  .debug_frame    0 : { *(.debug_frame) }
-  .debug_str      0 : { *(.debug_str) }
-  .debug_loc      0 : { *(.debug_loc) }
-  .debug_macinfo  0 : { *(.debug_macinfo) }
-  /* SGI/MIPS DWARF 2 extensions */
-  .debug_weaknames 0 : { *(.debug_weaknames) }
-  .debug_funcnames 0 : { *(.debug_funcnames) }
-  .debug_typenames 0 : { *(.debug_typenames) }
-  .debug_varnames  0 : { *(.debug_varnames) }
+	. = ALIGN(8);
+	.con_initcall.init : {
+		__con_initcall_start = .;
+		*(.con_initcall.init)
+		__con_initcall_end = .;
+	}
+
+	. = ALIGN(8);
+	SECURITY_INIT
+
+	PERCPU(PAGE_SIZE)
+
+	. = ALIGN(2 * PAGE_SIZE);
+	__init_end = .;
+	/* Freed after init ends here */
+
+	/* Note 2 page alignment above.  */
+	.data.init_thread : {
+		*(.data.init_thread)
+	}
+
+	. = ALIGN(PAGE_SIZE);
+	.data.page_aligned : {
+		*(.data.page_aligned)
+	}
+
+	. = ALIGN(64);
+	.data.cacheline_aligned : {
+		*(.data.cacheline_aligned)
+	}
+
+	_data = .;
+	/* Data */
+	.data : {
+		DATA_DATA
+		CONSTRUCTORS
+	}
+
+	.got : {
+		*(.got)
+	}
+	.sdata : {
+		*(.sdata)
+	}
+	_edata = .;	/* End of data section */
+
+	__bss_start = .;
+	.sbss : {
+		*(.sbss)
+		*(.scommon)
+	}
+	.bss : {
+		*(.bss)
+		*(COMMON)
+	}
+	__bss_stop = .;
+	_end = .;
+
+	/* Sections to be discarded */
+	/DISCARD/ : {
+		*(.exit.text)
+		*(.exit.data)
+		*(.exitcall.exit)
+	}
+
+	.mdebug 0 : {
+		*(.mdebug)
+	}
+	.note 0 : {
+		*(.note)
+	}
+
+	STABS_DEBUG
+	DWARF_DEBUG
 }
diff --git a/include/asm-alpha/page.h b/include/asm-alpha/page.h
index bae7f05..8cc97bf 100644
--- a/include/asm-alpha/page.h
+++ b/include/asm-alpha/page.h
@@ -3,11 +3,12 @@
 
 #ifdef __KERNEL__
 
+#include <linux/const.h>
 #include <asm/pal.h>
 
 /* PAGE_SHIFT determines the page size */
 #define PAGE_SHIFT	13
-#define PAGE_SIZE	(1UL << PAGE_SHIFT)
+#define PAGE_SIZE	(_AC(1,UL) << PAGE_SHIFT)
 #define PAGE_MASK	(~(PAGE_SIZE-1))
 
 #ifndef __ASSEMBLY__
