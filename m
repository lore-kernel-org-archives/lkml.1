Return-Path: <linux-kernel-owner+w=401wt.eu-S1755379AbZBYAW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbZBYAW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 19:22:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752014AbZBYAWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 19:22:15 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:64515 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751693AbZBYAWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 19:22:14 -0500
From: Tim Abbott <tabbott@MIT.EDU>
To: linux-kernel@vger.kernel.org
Cc: Tim Abbott <tabbott@MIT.EDU>, Anders Kaseorg <andersk@MIT.EDU>,
       Jeff Arnold <jbarnold@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH v2 2/4] x86: Add an option to compile with -ffunction-sections -fdata-sections
Date: Tue, 24 Feb 2009 19:21:53 -0500
Message-Id: <1235521315-3424-3-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1235521315-3424-2-git-send-email-tabbott@mit.edu>
References: <1235521315-3424-1-git-send-email-tabbott@mit.edu>
 <1235521315-3424-2-git-send-email-tabbott@mit.edu>
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
 scripts/Makefile.modpost          |    1 +
 scripts/mod/modpost.c             |   10 ++++++++--
 8 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 22d7584..b95cf67 100644
--- a/Makefile
+++ b/Makefile
@@ -550,6 +550,10 @@ ifdef CONFIG_FUNCTION_TRACER
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
index 9c39095..d3a991c 100644
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
index 31c131a..fbc5c3f 100644
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ b/arch/x86/kernel/vmlinux_32.lds.S
@@ -194,6 +194,7 @@ SECTIONS
 	__bss_start = .;		/* BSS */
 	*(.bss..page_aligned)
 	*(.bss)
+	*(.bss.[A-Za-z$_]*)		/* handle -fdata-sections */
 	. = ALIGN(4);
 	__bss_stop = .;
   	_end = . ;
diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index 56ed592..6e03cb2 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -223,6 +223,7 @@ SECTIONS
   .bss : AT(ADDR(.bss) - LOAD_OFFSET) {
 	*(.bss..page_aligned)
 	*(.bss)
+	*(.bss.[A-Za-z$_]*)	/* handle -fdata-sections */
 	}
   __bss_stop = .;
 
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 0485f0b..2b31598 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -64,6 +64,7 @@
 /* .data section */
 #define DATA_DATA							\
 	*(.data)							\
+	*(.data.[A-Za-z$_]*)	/* handle -fdata-sections */		\
 	*(.data..init.refok)						\
 	*(.ref.data)							\
 	DEV_KEEP(init.data)						\
@@ -87,7 +88,8 @@
 	. = ALIGN((align));						\
 	.rodata           : AT(ADDR(.rodata) - LOAD_OFFSET) {		\
 		VMLINUX_SYMBOL(__start_rodata) = .;			\
-		*(.rodata) *(.rodata.*)					\
+		*(.rodata)						\
+		*(.rodata.[A-Za-z$_]*)	/* handle -fdata-sections */	\
 		*(__vermagic)		/* Kernel version magic */	\
 		*(__markers_strings)	/* Markers: strings */		\
 		*(__tracepoints_strings)/* Tracepoints: strings */	\
@@ -254,6 +256,7 @@
 		ALIGN_FUNCTION();					\
 		*(.text.hot)						\
 		*(.text)						\
+		*(.text.[A-Za-z$_]*)	/* handle -ffunction-sections */\
 		*(.ref.text)						\
 		*(.text..init.refok)					\
 		*(.text..exit.refok)					\
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 29044f5..3412706 100644
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
diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index f4053dc..a712bb2 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -87,6 +87,7 @@ modpost = scripts/mod/modpost                    \
  $(if $(CONFIG_DEBUG_SECTION_MISMATCH),,-S)      \
  $(if $(CONFIG_MARKERS),-K $(kernelmarkersfile)) \
  $(if $(CONFIG_MARKERS),-M $(markersfile))	 \
+ $(if $(filter -ffunction-sections -fdata-sections,$(KBUILD_CFLAGS) $(CFLAGS_KERNEL)),-F) \
  $(if $(KBUILD_EXTMOD)$(KBUILD_MODPOST_WARN),-w) \
  $(if $(cross_build),-c)
 
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index a7e282e..8a99299 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -32,6 +32,8 @@ static int warn_unresolved = 0;
 /* How a symbol is exported */
 static int sec_mismatch_count = 0;
 static int sec_mismatch_verbose = 1;
+/* Are we using -ffunction-sections or -fdata-sections? */
+static int function_data_sections = 0;
 
 enum export {
 	export_plain,      export_unused,     export_gpl,
@@ -736,7 +738,8 @@ static int check_section(const char *modname, const char *sec)
 		/* consume all digits */
 		while (*e && e != sec && isdigit(*e))
 			e--;
-		if (*e == '.' && !strstr(sec, ".linkonce")) {
+		if (*e == '.' && !strstr(sec, ".linkonce") &&
+		    !function_data_sections) {
 			warn("%s (%s): unexpected section name.\n"
 			     "The (.[number]+) following section name are "
 			     "ld generated and not expected.\n"
@@ -2063,7 +2066,7 @@ int main(int argc, char **argv)
 	struct ext_sym_list *extsym_iter;
 	struct ext_sym_list *extsym_start = NULL;
 
-	while ((opt = getopt(argc, argv, "i:I:e:cmsSo:awM:K:")) != -1) {
+	while ((opt = getopt(argc, argv, "i:I:e:cFmsSo:awM:K:")) != -1) {
 		switch (opt) {
 		case 'i':
 			kernel_read = optarg;
@@ -2083,6 +2086,9 @@ int main(int argc, char **argv)
 			extsym_iter->file = optarg;
 			extsym_start = extsym_iter;
 			break;
+		case 'F':
+			function_data_sections = 1;
+			break;
 		case 'm':
 			modversions = 1;
 			break;
-- 
1.6.1.3

