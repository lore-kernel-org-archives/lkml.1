Return-Path: <linux-kernel-owner+w=401wt.eu-S1757175AbZEDOZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175AbZEDOZi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 10:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754094AbZEDOZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 10:25:26 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:38607 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755999AbZEDOZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 10:25:23 -0400
Date: Mon, 4 May 2009 16:27:32 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tim Abbott <tabbott@MIT.EDU>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>
Subject: Re: [PATCH v2 0/6] macros for section name cleanup
Message-ID: <20090504142732.GA8237@uranus.ravnborg.org>
References: <1241121253-32341-1-git-send-email-tabbott@mit.edu> <20090501213118.GA28126@uranus.ravnborg.org> <alpine.DEB.1.10.0905011916530.10966@vinegar-pot.mit.edu> <20090502220132.GA4130@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090502220132.GA4130@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 03, 2009 at 12:01:32AM +0200, Sam Ravnborg wrote:
> On Fri, May 01, 2009 at 08:48:53PM -0400, Tim Abbott wrote:
> > On Fri, 1 May 2009, Sam Ravnborg wrote:
> > 
> > > This is the way I want to go where we have more complete
> > > definitions in the shared file and we try to keep the arch
> > > linker scripts to the arch specifc stuff.
> > 
> > I like the general look of this.  Indeed, I was planning to work on 
> > something like this as a follow-on to the linker script cleanup work I've 
> > done so far.
> 
> Keep in mind that my primary goal here is to clean up the linker scripts.
> Support for -ffunction-sections is only a spin-off of that.
> This is why I try to take a broader look at it.

Here comes the reworked version.
I have addressed your comments (thanks!), and also
added a lot more stuff.

I'm especially found of the "minimal" linker script
contained in the beginning of the file.
This helped me to gain better understanding of the general
sturcture - And I then also quickly spotted when an
architecture does not follow the normal flow.

I have converted powerpc to the new scheme - which
I have done a test build of.

If/when we get this in I will help all architectures
to convert to use these new defines killing a lot
of duplication in the process.
But we need to get this stuff agreed on first.

Comments appreciated!

	Sam

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 89853bc..91fe5d4 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -1,4 +1,60 @@
-#include <linux/section-names.h>
+/*
+ * Helper macros to support writing architecture specific
+ * linker scripts.
+ *
+ * A minimal linker scripts has following content:
+ *
+ * OUTPUT_FORMAT(...)
+ * OUTPUT_ARCH(...)
+ * ENTRY(...)
+ * SECTIONS
+ * {
+ *	. = START;
+ *	_stext = .;
+ *	.text : {
+ *		HEAD_TEXT
+ *		TEXT_TEXT
+ *		SCHED_TEXT
+ *		LOCK_TEXT
+ *		KPROBES_TEXT
+ *		IRQENTRY_TEXT
+ *	} = 0
+ *	_etext = .;
+ *
+ *	RO_DATA_SECTION(PAGE_SIZE)
+ *	RW_DATA_SECTION(...)
+ *	_edata = .;
+ *
+ *	EXCEPTION_TABLE(...)
+ *	NOTES
+ *
+ *	__init_begin = .;
+ *	INIT_TEXT_SECTION(PAGE_SIZE)
+ *	INIT_DATA_SECTION(...)
+ *	PERCPU(PAGE_SIZE)
+ *	__init_end = .;
+ *
+ *	BSS_SECTION(0, 0)
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
+ * [_stext, _etext] is the text section
+ * [_etext, _edata] is the data section
+ * [__init_begin, __init_end] is the init section that may be freed after init
+ *
+ * Some of the included output section include their own set of constants.
+ * Examples are: [__initramfs_start, __initramfs_end] for initramfs and
+ *               [__nosave_begin, __nosave_end] for the nosave data
+ */
+ #include <linux/section-names.h>
 
 #ifndef LOAD_OFFSET
 #define LOAD_OFFSET 0
@@ -116,6 +172,35 @@
 	FTRACE_EVENTS()							\
 	TRACE_SYSCALLS()
 
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
 #define RO_DATA(align)							\
 	. = ALIGN((align));						\
 	.rodata           : AT(ADDR(.rodata) - LOAD_OFFSET) {		\
@@ -332,6 +417,26 @@
 /* Section used for early init (in .S files) */
 #define HEAD_TEXT  *(HEAD_TEXT_SECTION)
 
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
@@ -363,9 +468,32 @@
 	CPU_DISCARD(exit.text)						\
 	MEM_DISCARD(exit.text)
 
-		/* DWARF debug sections.
-		Symbols in the DWARF debugging sections are relative to
-		the beginning of the section so we begin them at 0.  */
+/*
+ * bss (Block started by Symbol) - uninitialized data
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
@@ -432,6 +560,12 @@
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
@@ -453,6 +587,31 @@
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
@@ -509,3 +668,49 @@
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
+#define RO_DATA_SECTION(align) RO_DATA(align)
+
+/* use 0 as page_align if page_aligned data is not used */
+#define RW_DATA_SECTION(page_align, readmostly_align, cache_align, inittask_align) \
+	. = ALIGN(PAGE_SIZE);						\
+	.data : AT(ADDR(.data) - LOAD_OFFSET) {				\
+		DATA_DATA						\
+		CONSTRUCTORS						\
+		NOSAVE_DATA						\
+		PAGE_ALIGNED_DATA(page_align)				\
+		READMOSTLY_DATA(readmostly_align)			\
+		CACHELINE_ALIGNED_DATA(cache_align)			\
+		INIT_TASK(inittask_align)				\
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
+	VMLINUX_SYMBOL(__bss_start) = .;				\
+	BSS(bss_align)							\
+	. = ALIGN(4);							\
+	VMLINUX_SYMBOL(__bss_stop) = .;
