Return-Path: <linux-kernel-owner+w=401wt.eu-S1756775AbZDEXQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775AbZDEXQW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 19:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754095AbZDEXQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 19:16:05 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:56007 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752212AbZDEXQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 19:16:02 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Tim Abbott <tabbott@MIT.EDU>, Anders Kaseorg <andersk@MIT.EDU>,
       Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Arnold <jbarnold@MIT.EDU>
Subject: [PATCH v2 4/4] x86: Add an option to compile with -ffunction-sections -fdata-sections
Date: Sun,  5 Apr 2009 19:14:38 -0400
Message-Id: <1238973278-31735-5-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1238973278-31735-4-git-send-email-tabbott@mit.edu>
References: <1238973278-31735-1-git-send-email-tabbott@mit.edu>
 <1238973278-31735-2-git-send-email-tabbott@mit.edu>
 <1238973278-31735-3-git-send-email-tabbott@mit.edu>
 <1238973278-31735-4-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Waseem Daher <wdaher@mit.edu>

This patch makes it possible to link and boot an x86 kernel with
-ffunction-sections and -fdata-sections enabled.

Modpost currently warns whenever it sees a section with a name
matching [.][0-9]+$ because they are often caused by section flag
mismatch errors.  When compiling with -ffunction-sections
-fdata-sections, gcc places various classes of local symbols in
sections with names such as .rodata.__func__.12345, causing these
warnings to be printed spuriously.  The simplest fix is to disable the
warning when CONFIG_FUNCTION_DATA_SECTIONS is enabled.

Signed-off-by: Waseem Daher <wdaher@mit.edu>
[tabbott@mit.edu: modpost support]
Signed-off-by: Tim Abbott <tabbott@mit.edu>
[andersk@mit.edu: depend on x86, update CONFIG_FUNCTION_TRACER conflict]
Signed-off-by: Anders Kaseorg <andersk@mit.edu>
---
 Makefile                          |    4 ++++
 arch/x86/Kconfig                  |    1 +
 arch/x86/kernel/vmlinux_32.lds.S  |    1 +
 arch/x86/kernel/vmlinux_64.lds.S  |    1 +
 include/asm-generic/vmlinux.lds.h |    5 ++++-
 lib/Kconfig.debug                 |   18 ++++++++++++++++++
 6 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index c6307b6..939104e 100644
--- a/Makefile
+++ b/Makefile
@@ -552,6 +552,10 @@ ifdef CONFIG_FUNCTION_TRACER
 KBUILD_CFLAGS	+= -pg
 endif
 
+ifdef CONFIG_FUNCTION_DATA_SECTIONS
+KBUILD_CFLAGS	+= -ffunction-sections -fdata-sections
+endif
+
 # We trigger additional mismatches with less inlining
 ifdef CONFIG_DEBUG_SECTION_MISMATCH
 KBUILD_CFLAGS += $(call cc-option, -fno-inline-functions-called-once)
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5b2196a..032d75d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -28,6 +28,7 @@ config X86
 	select HAVE_KPROBES
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARCH_WANT_FRAME_POINTERS
+	select HAVE_FUNCTION_DATA_SECTIONS
 	select HAVE_KRETPROBES
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_DYNAMIC_FTRACE
diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
index 5342ea8..21c764e 100644
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ b/arch/x86/kernel/vmlinux_32.lds.S
@@ -187,6 +187,7 @@ SECTIONS
 	__bss_start = .;		/* BSS */
 	*(.bss..page_aligned)
 	*(.bss)
+	*(.bss.[A-Za-z$_]*)		/* handle -fdata-sections */
 	. = ALIGN(4);
 	__bss_stop = .;
   }
diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index 98016a2..e7dac7d 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -246,6 +246,7 @@ SECTIONS
 	__bss_start = .;		/* BSS */
 	*(.bss..page_aligned)
 	*(.bss)
+	*(.bss.[A-Za-z$_]*)	/* handle -fdata-sections */
 	__bss_stop = .;
   }
 
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 37feab0..70a2a67 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -88,6 +88,7 @@
 /* .data section */
 #define DATA_DATA							\
 	*(.data)							\
+	*(.data.[A-Za-z$_]*)	/* handle -fdata-sections */		\
 	*(.data..init.refok)						\
 	*(.ref.data)							\
 	DEV_KEEP(init.data)						\
@@ -119,7 +120,8 @@
 	. = ALIGN((align));						\
 	.rodata           : AT(ADDR(.rodata) - LOAD_OFFSET) {		\
 		VMLINUX_SYMBOL(__start_rodata) = .;			\
-		*(.rodata) *(.rodata.*)					\
+		*(.rodata)						\
+		*(.rodata.[A-Za-z$_]*)	/* handle -fdata-sections */	\
 		*(__vermagic)		/* Kernel version magic */	\
 		*(__markers_strings)	/* Markers: strings */		\
 		*(__tracepoints_strings)/* Tracepoints: strings */	\
@@ -286,6 +288,7 @@
 		ALIGN_FUNCTION();					\
 		*(.text.hot)						\
 		*(.text)						\
+		*(.text.[A-Za-z$_]*)	/* handle -ffunction-sections */\
 		*(.ref.text)						\
 		*(.text..init.refok)					\
 		*(.text..exit.refok)					\
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 9638d99..45fe0c2 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -591,6 +591,24 @@ config FRAME_POINTER
 	  larger and slower, but it gives very useful debugging information
 	  in case of kernel bugs. (precise oopses/stacktraces/warnings)
 
+config HAVE_FUNCTION_DATA_SECTIONS
+	bool
+
+config FUNCTION_DATA_SECTIONS
+	bool "Compile with -ffunction-sections -fdata-sections"
+	depends on HAVE_FUNCTION_DATA_SECTIONS
+	depends on !FUNCTION_TRACER
+	help
+	  If you say Y here the compiler will give each function
+	  and data structure its own ELF section.
+
+	  This option conflicts with CONFIG_FUNCTION_TRACER, which
+	  enables profiling code generation, because current GCC does
+	  not support compiling with -ffunction-sections -pg (see
+	  <http://gcc.gnu.org/ml/gcc-help/2008-11/msg00128.html>).
+
+	  If unsure, say N.
+
 config BOOT_PRINTK_DELAY
 	bool "Delay each boot printk message by N milliseconds"
 	depends on DEBUG_KERNEL && PRINTK && GENERIC_CALIBRATE_DELAY
-- 
1.6.2.1

