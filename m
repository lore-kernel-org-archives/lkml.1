Return-Path: <linux-kernel-owner+w=401wt.eu-S1763133AbZEAV3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763133AbZEAV3W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 17:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbZEAV3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 17:29:13 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:52886 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbZEAV3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 17:29:12 -0400
Date: Fri, 1 May 2009 23:31:18 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tim Abbott <tabbott@MIT.EDU>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH v2 0/6] macros for section name cleanup
Message-ID: <20090501213118.GA28126@uranus.ravnborg.org>
References: <1241121253-32341-1-git-send-email-tabbott@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241121253-32341-1-git-send-email-tabbott@mit.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tim.

[cc trimmed so this hits lkml]

I've tried to make the patch to vmlinux.lds.h more complete.
With this patch I managed to achive the following diffstat:

 arch/mips/kernel/vmlinux.lds.S    |   70 ++----------------
 arch/mn10300/kernel/vmlinux.lds.S |   82 +++-------------------
 arch/sparc/kernel/vmlinux.lds.S   |   82 +++-------------------
 include/asm-generic/vmlinux.lds.h |  139 ++++++++++++++++++++++++++++++++++++-
 4 files changed, 165 insertions(+), 208 deletions(-)

So with 3 architecture I have more lines deleted than added.
None of these has been build tested but this shows the potential.

Below you will find the *untested* patch for vmlinux.lds.h.
This is the way I want to go where we have more complete
definitions in the shared file and we try to keep the arch
linker scripts to the arch specifc stuff.

This is not a 1:1 replacement for your patches as they touches files
outside vmlinux.lds.h but I concentrated on this single file for now.

Comments welcome!

	Sam

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 89853bc..950d0d7 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -116,6 +116,43 @@
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
+	. = ALIGN((page_align));					\
+	*(.data.page_aligned)
+
+#define READ_MOSTLY_DATA(align)						\
+	. = ALIGN((align));						\
+	*(.data.read_mostly)
+
+#define CACHELINE_ALIGNED_DATA(align)					\
+	. = ALIGN((align));						\
+	*(.data.cacheline_aligned)
+
+/* use 0 as page_align if page_aligned data is not used */
+#define RW_DATA(page_align, readmostly_align, cache_align)		\
+	. = ALIGN(PAGE_SIZE);						\
+	.data : AT(ADDR(.data) - LOAD_OFFSET) {				\
+		DATA_DATA						\
+		CONSTRUCTORS						\
+		NOSAVE_DATA						\
+		PAGE_ALIGNED_DATA(page_align)				\
+		READMOSTLY_DATA((readmostly_align))			\
+		CACHELINE_ALIGNED_DATA((cache_align))			\
+	}
+
+/*
+ * Read only Data
+ */
 #define RO_DATA(align)							\
 	. = ALIGN((align));						\
 	.rodata           : AT(ADDR(.rodata) - LOAD_OFFSET) {		\
@@ -274,6 +311,18 @@
  * All archs are supposed to use RO_DATA() */
 #define RODATA RO_DATA(4096)
 
+#ifdef CONFIG_BLK_DEV_INITRD
+#define INITRAMFS							\
+	. = ALIGN(PAGE_SIZE);						\
+	.init.ramfs : AT(ADDR(.init.ramfs) - LOAD_OFFSET) {		\
+		VMLINUX_SYMBOL(__initramfs_start) = .;			\
+		*(.init.ramfs)						\
+		VMLINUX_SYMBOL(__initramfs_end) = .;			\
+	}
+#else
+#define INITRAMFS
+#endif
+
 #define SECURITY_INIT							\
 	.security_initcall.init : AT(ADDR(.security_initcall.init) - LOAD_OFFSET) { \
 		VMLINUX_SYMBOL(__security_initcall_start) = .;		\
@@ -281,6 +330,24 @@
 		VMLINUX_SYMBOL(__security_initcall_end) = .;		\
 	}
 
+#define INITDATA(initsetup_align)					\
+	.init.data : AT(ADDR(.init.data) - LOAD_OFFSET) {		\
+		INIT_DATA						\
+		. = ALIGN(initsetup_align);				\
+		VMLINUX_SYMBOL(__setup_start) = .;			\
+		*(.init.setup)						\
+		VMLINUX_SYMBOL(__setup_end) = .;			\
+		VMLINUX_SYMBOL(__initcall_start) = .;			\
+		INITCALLS						\
+		VMLINUX_SYMBOL(__initcall_end) = .;			\
+		VMLINUX_SYMBOL(__con_initcall_start) = .;		\
+		*(.con_initcall.init)					\
+		VMLINUX_SYMBOL(__con_initcall_end) = .;
+		VMLINUX_SYMBOL(__security_initcall_start) = .;		\
+		*(.security_initcall.init)				\
+		VMLINUX_SYMBOL(__security_initcall_end) = .;		\
+	}
+
 /* .text section. Map to function alignment to avoid address changes
  * during second ld run in second ld pass when generating System.map */
 #define TEXT_TEXT							\
@@ -332,6 +399,29 @@
 /* Section used for early init (in .S files) */
 #define HEAD_TEXT  *(HEAD_TEXT_SECTION)
 
+/*
+ * Exception table
+ */
+#define EXCEPTION_TABLE(align)						\
+	. = ALIGN((align));						\
+	__ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) {		\
+		VMLINUX_SYMBOL(__start___ex_table) = .;			\
+		*(__ex_table)						\
+		VMLINUX_SYMBOL(__stop___ex_table) = .;			\
+	}
+
+/*
+ * Init task
+ */
+#define INIT_TASK							\
+	*(.data.init_task)
+
+#define INIT_TASK_DATA(align)						\
+	. = ALIGN((align));						\
+	.data.init_task : {						\
+		INIT_TASK						\
+	}
+
 /* init and exit section handling */
 #define INIT_DATA							\
 	*(.init.data)							\
@@ -363,9 +453,52 @@
 	CPU_DISCARD(exit.text)						\
 	MEM_DISCARD(exit.text)
 
-		/* DWARF debug sections.
-		Symbols in the DWARF debugging sections are relative to
-		the beginning of the section so we begin them at 0.  */
+#define INITTEXT(inittext_align)					\
+	. = ALIGN((inittext_align));					\
+	.init.text : AT(ADDR(.init.text) - LOAD_OFFSET) {		\
+		VMLINUX_SYMBOL(__init_begin) = .;			\
+		VMLINUX_SYMBOL(_sinittext) = .;				\
+		INIT_TEXT						\
+		VMLINUX_SYMBOL(_einittext) = .;				\
+	}
+
+#define INITDATA(initdata_align)					\
+	. = ALIGN((initdata_align));					\
+	.init.data : AT(ADDR(.init.data) - LOAD_OFFSET) {		\
+		INIT_DATA						\
+	}
+
+/*
+ * bss
+ */
+#define SBSS(sbss_align)						\
+	. = ALIGN((sbss_align));					\
+	.sbss : AT(ADDR(.sbss) - LOAD_OFFSET) {				\
+		*(.sbss)						\
+		*(.scommon)						\
+	}
+
+#define BSS(bss_align)							\
+	. = ALIGN((bss_align));						\
+	.bss : AT(ADDR(.bss) - LOAD_OFFSET) {				\
+		*(.bss.page_aligned)					\
+		*(.dynbss)						\
+		*(.bss)							\
+		*(COMMON)						\
+	}
+
+#define SBSS_BSS(sbss_align, bss_align)					\
+	VMLINUX_SYMBOL(__bss_start) = .;				\
+	SBSS(sbss_align)						\
+	BSS(bss_align)							\
+	ALIGN_FUNCTION();						\
+	VMLINUX_SYMBOL(__bss_stop) = .;
+
+/*
+ * DWARF debug sections.
+ * Symbols in the DWARF debugging sections are relative to
+ * the beginning of the section so we begin them at 0.
+ */
 #define DWARF_DEBUG							\
 		/* DWARF 1 */						\
 		.debug          0 : { *(.debug) }			\
