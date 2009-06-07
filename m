Return-Path: <linux-kernel-owner+w=401wt.eu-S1756178AbZFGSwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178AbZFGSwY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 14:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255AbZFGSwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 14:52:16 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:37432 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbZFGSwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 14:52:15 -0400
Date: Sun, 7 Jun 2009 20:54:30 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Tim Abbott <tabbott@mit.edu>,
       linux arch <linux-arch@vger.kernel.org>
Subject: [PATCH] Improve vmlinux.lds.h support for arch specific linker scripts
Message-ID: <20090607185430.GA15299@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please review and comment..
It will be part of kbuild-next.git

	Sam

commit 59d59d97e34c6593bec43666679b28da5d583958
Author: Sam Ravnborg <sam@ravnborg.org>
Date:   Sun Jun 7 20:46:37 2009 +0200

    Improve vmlinux.lds.h support for arch specific linker scripts
    
    To support alingment of the individual architecture specific linker scripts
    provide a set of general definitions in vmlinux.lds.h
    
    With these definitions applied the diverse linekr scripts can be reduced
    in line count and their readability are improved - IMO.
    
    A sample linker script is included to give the preferred
    order of the sections for the architectures that do not
    have any special requirments.
    
    These definitions are also a first step towards eventual
    support for -ffunction-sections.
    The definitions makes it much easier to do a global
    renaming of section names - but the main purpose is
    to clean up the linker scripts.
    
    Tim Aboot has provided a lot of inputs to improve
    the definitions - all faults are mine.
    
    Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
    Cc: Tim Abbott <tabbott@mit.edu>

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 3edb114..d61058e 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -1,4 +1,58 @@
-#include <linux/section-names.h>
+/*
+ * Helper macros to support writing architecture specific
+ * linker scripts.
+ *
+ * A minimal linker scripts has following content:
+ * [This is a sample, architectures may have special requiriements]
+ *
+ * OUTPUT_FORMAT(...)
+ * OUTPUT_ARCH(...)
+ * ENTRY(...)
+ * SECTIONS
+ * {
+ *	. = START;
+ *	__init_begin = .;
+ *	HEAD_SECTION
+ *	INIT_TEXT_SECTION(PAGE_SIZE)
+ *	INIT_DATA_SECTION(...)
+ *	PERCPU(PAGE_SIZE)
+ *	__init_end = .;
+ *
+ *	_stext = .;
+ *	TEXT_SECTION = 0
+ *	_etext = .;
+ *
+ *      _sdata = .;
+ *	RO_DATA_SECTION(PAGE_SIZE)
+ *	RW_DATA_SECTION(...)
+ *	_edata = .;
+ *
+ *	EXCEPTION_TABLE(...)
+ *	NOTES
+ *
+ *	__bss_start = .;
+ *	BSS_SECTION(0, 0)
+ *	__bss_stop = .;
+ *	_end = .;
+ *
+ *	/DISCARD/ : {
+ *		EXIT_TEXT
+ *		EXIT_DATA
+ *		*(.exitcall.exit)
+ *	}
+ *	STABS_DEBUG
+ *	DWARF_DEBUG
+ * }
+ *
+ * [__init_begin, __init_end] is the init section that may be freed after init
+ * [_stext, _etext] is the text section
+ * [_sdata, _edata] is the data section
+ *
+ * Some of the included output section have their own set of constants.
+ * Examples are: [__initramfs_start, __initramfs_end] for initramfs and
+ *               [__nosave_begin, __nosave_end] for the nosave data
+ */
+ #include <linux/section-names.h>
 
 #ifndef LOAD_OFFSET
 #define LOAD_OFFSET 0
@@ -116,7 +170,36 @@
 	FTRACE_EVENTS()							\
 	TRACE_SYSCALLS()
 
-#define RO_DATA(align)							\
+/*
+ * Data section helpers
+ */
+#define NOSAVE_DATA							\
+	. = ALIGN(PAGE_SIZE);						\
+	VMLINUX_SYMBOL(__nosave_begin) = .;				\
+	*(.data.nosave)							\
+	. = ALIGN(PAGE_SIZE);						\
+	VMLINUX_SYMBOL(__nosave_end) = .;
+
+#define PAGE_ALIGNED_DATA(page_align)					\
+	. = ALIGN(page_align);						\
+	*(.data.page_aligned)
+
+#define READ_MOSTLY_DATA(align)						\
+	. = ALIGN(align);						\
+	*(.data.read_mostly)
+
+#define CACHELINE_ALIGNED_DATA(align)					\
+	. = ALIGN(align);						\
+	*(.data.cacheline_aligned)
+
+#define INIT_TASK(align)						\
+	. = ALIGN(align);						\
+	*(.data.init_task)
+
+/*
+ * Read only Data
+ */
+#define RO_DATA_SECTION(align)						\
 	. = ALIGN((align));						\
 	.rodata           : AT(ADDR(.rodata) - LOAD_OFFSET) {		\
 		VMLINUX_SYMBOL(__start_rodata) = .;			\
@@ -270,9 +353,10 @@
 	}								\
 	. = ALIGN((align));
 
-/* RODATA provided for backward compatibility.
+/* RODATA & RO_DATA provided for backward compatibility.
  * All archs are supposed to use RO_DATA() */
-#define RODATA RO_DATA(4096)
+#define RODATA          RO_DATA_SECTION(4096)
+#define RO_DATA(align)  RO_DATA_SECTION(align)
 
 #define SECURITY_INIT							\
 	.security_initcall.init : AT(ADDR(.security_initcall.init) - LOAD_OFFSET) { \
@@ -332,6 +416,31 @@
 /* Section used for early init (in .S files) */
 #define HEAD_TEXT  *(HEAD_TEXT_SECTION)
 
+#define HEAD_SECTION							\
+	.head.text : AT(ADDR(.head.text) - LOAD_OFFSET) {		\
+		HEAD_TEXT
+	}
+
+/*
+ * Exception table
+ */
+#define EXCEPTION_TABLE(align)						\
+	. = ALIGN(align);						\
+	__ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) {		\
+		VMLINUX_SYMBOL(__start___ex_table) = .;			\
+		*(__ex_table)						\
+		VMLINUX_SYMBOL(__stop___ex_table) = .;			\
+	}
+
+/*
+ * Init task
+ */
+#define INIT_TASK_DATA(align)						\
+	. = ALIGN(align);						\
+	.data.init_task : {						\
+		INIT_TASK						\
+	}
+
 /* init and exit section handling */
 #define INIT_DATA							\
 	*(.init.data)							\
@@ -364,9 +473,32 @@
 	CPU_DISCARD(exit.text)						\
 	MEM_DISCARD(exit.text)
 
-		/* DWARF debug sections.
-		Symbols in the DWARF debugging sections are relative to
-		the beginning of the section so we begin them at 0.  */
+/*
+ * bss (Block Started by Symbol) - uninitialized data
+ * zeroed during startup
+ */
+#define SBSS								\
+	.sbss : AT(ADDR(.sbss) - LOAD_OFFSET) {				\
+		*(.sbss)						\
+		*(.scommon)						\
+	}
+
+#define BSS(bss_align)							\
+	. = ALIGN(bss_align);						\
+	.bss : AT(ADDR(.bss) - LOAD_OFFSET) {				\
+		VMLINUX_SYMBOL(__bss_start) = .;			\
+		*(.bss.page_aligned)					\
+		*(.dynbss)						\
+		*(.bss)							\
+		*(COMMON)						\
+		VMLINUX_SYMBOL(__bss_stop) = .;				\
+	}
+
+/*
+ * DWARF debug sections.
+ * Symbols in the DWARF debugging sections are relative to
+ * the beginning of the section so we begin them at 0.
+ */
 #define DWARF_DEBUG							\
 		/* DWARF 1 */						\
 		.debug          0 : { *(.debug) }			\
@@ -433,6 +565,12 @@
 		VMLINUX_SYMBOL(__stop_notes) = .;			\
 	}
 
+#define INIT_SETUP(initsetup_align)					\
+		. = ALIGN(initsetup_align);				\
+		VMLINUX_SYMBOL(__setup_start) = .;			\
+		*(.init.setup)						\
+		VMLINUX_SYMBOL(__setup_end) = .;
+
 #define INITCALLS							\
 	*(.initcallearly.init)						\
 	VMLINUX_SYMBOL(__early_initcall_end) = .;			\
@@ -454,6 +592,31 @@
   	*(.initcall7.init)						\
   	*(.initcall7s.init)
 
+#define INIT_CALLS							\
+		VMLINUX_SYMBOL(__initcall_start) = .;			\
+		INITCALLS						\
+		VMLINUX_SYMBOL(__initcall_end) = .;
+
+#define CON_INITCALL							\
+		VMLINUX_SYMBOL(__con_initcall_start) = .;		\
+		*(.con_initcall.init)					\
+		VMLINUX_SYMBOL(__con_initcall_end) = .;
+
+#define SECURITY_INITCALL						\
+		VMLINUX_SYMBOL(__security_initcall_start) = .;		\
+		*(.security_initcall.init)				\
+		VMLINUX_SYMBOL(__security_initcall_end) = .;
+
+#ifdef CONFIG_BLK_DEV_INITRD
+#define INIT_RAM_FS							\
+	. = ALIGN(PAGE_SIZE);						\
+	VMLINUX_SYMBOL(__initramfs_start) = .;				\
+	*(.init.ramfs)							\
+	VMLINUX_SYMBOL(__initramfs_end) = .;
+#else
+#define INITRAMFS
+#endif
+
 /**
  * PERCPU_VADDR - define output section for percpu area
  * @vaddr: explicit base address (optional)
@@ -510,3 +673,57 @@
 		*(.data.percpu.shared_aligned)				\
 		VMLINUX_SYMBOL(__per_cpu_end) = .;			\
 	}
+
+
+/*
+ * Definition of the high level *_SECTION macros
+ * They will fit only a subset of the architectures
+ */
+
+
+/*
+ * Writeable data.
+ * All sections are combined in a single .data section.
+ * The sections following CONSTRUCTORS are arranged so their
+ * typical alignment matches.
+ * A cacheline is typical/always less than a PAGE_SIZE so
+ * the sections that has this restriction (or similar)
+ * is located before the ones requiring PAGE_SIZE alignment.
+ * NOSAVE_DATA starts and ends with a PAGE_SIZE alignment which
+ * matches the requirment of PAGE_ALIGNED_DATA.
+ *
+/* use 0 as page_align if page_aligned data is not used */
+#define RW_DATA_SECTION(cacheline, nosave, pagealigned, inittask)	\
+	. = ALIGN(PAGE_SIZE);						\
+	.data : AT(ADDR(.data) - LOAD_OFFSET) {				\
+		INIT_TASK(inittask)					\
+		CACHELINE_ALIGNED_DATA(cacheline)			\
+		READ_MOSTLY_DATA(cacheline)				\
+		DATA_DATA						\
+		CONSTRUCTORS						\
+		NOSAVE_DATA(nosave)					\
+		PAGE_ALIGNED_DATA(pagealigned)				\
+	}
+
+#define INIT_TEXT_SECTION(inittext_align)				\
+	. = ALIGN(inittext_align);					\
+	.init.text : AT(ADDR(.init.text) - LOAD_OFFSET) {		\
+		VMLINUX_SYMBOL(_sinittext) = .;				\
+		INIT_TEXT						\
+		VMLINUX_SYMBOL(_einittext) = .;				\
+	}
+
+#define INIT_DATA_SECTION(initsetup_align)				\
+	.init.data : AT(ADDR(.init.data) - LOAD_OFFSET) {		\
+		INIT_DATA						\
+		INIT_SETUP(initsetup_align)				\
+		INIT_CALLS						\
+		CON_INITCALL						\
+		SECURITY_INITCALL					\
+		INIT_RAM_FS						\
+	}
+
+#define BSS_SECTION(sbss_align, bss_align)				\
+	SBSS								\
+	BSS(bss_align)							\
+	. = ALIGN(4);							\
