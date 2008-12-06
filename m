Return-Path: <linux-kernel-owner+w=401wt.eu-S1757968AbYLFAKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968AbYLFAKQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 19:10:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755083AbYLFAJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 19:09:58 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:49491 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754329AbYLFAJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 19:09:57 -0500
From: Jeff Arnold <jbarnold@MIT.EDU>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Denys Vlasenko <vda.linux@googlemail.com>,
       Tim Abbott <tabbott@MIT.EDU>, Anders Kaseorg <andersk@MIT.EDU>,
       Waseem Daher <wdaher@MIT.EDU>, Nikanth Karthikesan <knikanth@suse.de>
Subject: [PATCH 2/7] x86: Add an option to compile with -ffunction-sections -fdata-sections
Date: Fri,  5 Dec 2008 19:03:55 -0500
Message-Id: <1228521840-3886-3-git-send-email-jbarnold@mit.edu>
X-Mailer: git-send-email 1.6.0
In-Reply-To: <1228521840-3886-2-git-send-email-jbarnold@mit.edu>
References: <1228521840-3886-1-git-send-email-jbarnold@mit.edu>
 <1228521840-3886-2-git-send-email-jbarnold@mit.edu>
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
---
 Makefile                          |    4 ++++
 arch/x86/kernel/vmlinux_32.lds.S  |    1 +
 arch/x86/kernel/vmlinux_64.lds.S  |    1 +
 include/asm-generic/vmlinux.lds.h |    2 ++
 lib/Kconfig.debug                 |    9 +++++++++
 scripts/Makefile.modpost          |    1 +
 scripts/mod/modpost.c             |   10 ++++++++--
 7 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 9a49960..d3d6fa4 100644
--- a/Makefile
+++ b/Makefile
@@ -540,6 +540,10 @@ ifdef CONFIG_FUNCTION_TRACER
 KBUILD_CFLAGS	+= -pg
 endif
 
+ifdef CONFIG_FUNCTION_DATA_SECTIONS
+KBUILD_CFLAGS	+= -ffunction-sections -fdata-sections
+endif
+
 # We trigger additional mismatches with less inlining
 ifdef CONFIG_DEBUG_SECTION_MISMATCH
 KBUILD_CFLAGS += $(call cc-option, -fno-inline-functions-called-once)
diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
index 454ab4c..c0c4323 100644
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ b/arch/x86/kernel/vmlinux_32.lds.S
@@ -193,6 +193,7 @@ SECTIONS
 	__bss_start = .;		/* BSS */
 	*(.bss.kernel.page_aligned)
 	*(.bss)
+	*(.bss.*)
 	. = ALIGN(4);
 	__bss_stop = .;
   	_end = . ;
diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index 6fd4547..ccb74b0 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -222,6 +222,7 @@ SECTIONS
   .bss : AT(ADDR(.bss) - LOAD_OFFSET) {
 	*(.bss.kernel.page_aligned)
 	*(.bss)
+	*(.bss.*)
 	}
   __bss_stop = .;
 
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index e8d1bdd..4b5aea8 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -48,6 +48,7 @@
 /* .data section */
 #define DATA_DATA							\
 	*(.data)							\
+	*(.data.*)							\
 	*(.kernel.data.init.refok)					\
 	*(.ref.data)							\
 	DEV_KEEP(init.data)						\
@@ -235,6 +236,7 @@
 		ALIGN_FUNCTION();					\
 		*(.text.hot)						\
 		*(.text)						\
+		*(.text.*)						\
 		*(.ref.text)						\
 		*(.kernel.text.init.refok)				\
 		*(.kernel.text.exit.refok)				\
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index b0f239e..e121ab7 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -557,6 +557,15 @@ config FRAME_POINTER
 	  some architectures or if you use external debuggers.
 	  If you don't debug the kernel, you can say N.
 
+config FUNCTION_DATA_SECTIONS
+	bool "Compile with -ffunction-sections -fdata-sections"
+	depends on !FTRACE
+	help
+	  If you say Y here the compiler will give each function
+	  and data structure its own ELF section.
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
index afe9408..68d9e95 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -32,6 +32,8 @@ static int warn_unresolved = 0;
 /* How a symbol is exported */
 static int sec_mismatch_count = 0;
 static int sec_mismatch_verbose = 1;
+/* Are we using CONFIG_FUNCTION_DATA_SECTIONS? */
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
1.5.6.3

