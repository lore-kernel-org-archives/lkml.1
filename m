Return-Path: <linux-kernel-owner+w=401wt.eu-S1757178AbYATULU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178AbYATULU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 15:11:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756148AbYATUJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 15:09:32 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:39116 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755992AbYATUJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 15:09:11 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       linux-arch@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, Adrian Bunk <bunk@kernel.org>
Subject: [PATCH] Use separate sections for __dev/__cpu/__mem code/data
Date: Sun, 20 Jan 2008 21:09:03 +0100
Message-Id: <1200859743-24037-8-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.3.5.628.ga1309
In-Reply-To: <1200859743-24037-7-git-send-email-sam@ravnborg.org>
References: <20080120200527.GA23852@uranus.ravnborg.org>
 <1200859743-24037-1-git-send-email-sam@ravnborg.org>
 <1200859743-24037-2-git-send-email-sam@ravnborg.org>
 <1200859743-24037-3-git-send-email-sam@ravnborg.org>
 <1200859743-24037-4-git-send-email-sam@ravnborg.org>
 <1200859743-24037-5-git-send-email-sam@ravnborg.org>
 <1200859743-24037-6-git-send-email-sam@ravnborg.org>
 <1200859743-24037-7-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introducing separate sections for __dev* (HOTPLUG),
__cpu* (HOTPLUG_CPU) and __mem* (MEMORY_HOTPLUG)
allows us to do a much more reliable Section mismatch
check in modpost. We are no longer dependent on the actual
configuration of for example HOTPLUG.

This has the effect that all users see much more
Section mismatch warnings than before because they
were almost all hidden when HOTPLUG was enabled.
The advantage of this is that when building a piece
of code then it is much more likely that the Section
mismatch errors are spotted and the warnings will be
felt less random of nature.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Greg KH <greg@kroah.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Adrian Bunk <bunk@kernel.org>
---
 include/asm-generic/vmlinux.lds.h |   88 ++++++++++++++++++++++++++++++++++---
 include/linux/init.h              |   77 ++++++++++++++++----------------
 scripts/mod/modpost.c             |   54 ++++++++++++++++------
 3 files changed, 159 insertions(+), 60 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index ded7ca2..e0a56fb 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -9,10 +9,46 @@
 /* Align . to a 8 byte boundary equals to maximum function alignment. */
 #define ALIGN_FUNCTION()  . = ALIGN(8)
 
+/* The actual configuration determine if the init/exit sections
+ * are handled as text/data or they can be discarded (which
+ * often happens at runtime)
+ */
+#ifdef CONFIG_HOTPLUG
+#define DEV_KEEP(sec)    *(.dev##sec)
+#define DEV_DISCARD(sec)
+#else
+#define DEV_KEEP(sec)
+#define DEV_DISCARD(sec) *(.dev##sec)
+#endif
+
+#ifdef CONFIG_HOTPLUG_CPU
+#define CPU_KEEP(sec)    *(.cpu##sec)
+#define CPU_DISCARD(sec)
+#else
+#define CPU_KEEP(sec)
+#define CPU_DISCARD(sec) *(.cpu##sec)
+#endif
+
+#if defined(CONFIG_MEMORY_HOTPLUG) || defined(CONFIG_ACPI_HOTPLUG_MEMORY) \
+	|| defined(CONFIG_ACPI_HOTPLUG_MEMORY_MODULE)
+#define MEM_KEEP(sec)    *(.mem##sec)
+#define MEM_DISCARD(sec)
+#else
+#define MEM_KEEP(sec)
+#define MEM_DISCARD(sec) *(.mem##sec)
+#endif
+
+
 /* .data section */
 #define DATA_DATA							\
 	*(.data)							\
 	*(.data.init.refok)						\
+	DEV_KEEP(init.data)						\
+	DEV_KEEP(exit.data)						\
+	CPU_KEEP(init.data)						\
+	CPU_KEEP(exit.data)						\
+	MEM_KEEP(init.data)						\
+	MEM_KEEP(exit.data)						\
 	. = ALIGN(8);							\
 	VMLINUX_SYMBOL(__start___markers) = .;				\
 	*(__markers)							\
@@ -132,6 +168,16 @@
 		*(__ksymtab_strings)					\
 	}								\
 									\
+	/* __*init sections */						\
+	__init_rodata : AT(ADDR(__init_rodata) - LOAD_OFFSET) {		\
+		DEV_KEEP(init.rodata)					\
+		DEV_KEEP(exit.rodata)					\
+		CPU_KEEP(init.rodata)					\
+		CPU_KEEP(exit.rodata)					\
+		MEM_KEEP(init.rodata)					\
+		MEM_KEEP(exit.rodata)					\
+	}								\
+									\
 	/* Built-in module parameters. */				\
 	__param : AT(ADDR(__param) - LOAD_OFFSET) {			\
 		VMLINUX_SYMBOL(__start___param) = .;			\
@@ -139,7 +185,6 @@
 		VMLINUX_SYMBOL(__stop___param) = .;			\
 		VMLINUX_SYMBOL(__end_rodata) = .;			\
 	}								\
-									\
 	. = ALIGN((align));
 
 /* RODATA provided for backward compatibility.
@@ -159,7 +204,14 @@
 		ALIGN_FUNCTION();					\
 		*(.text)						\
 		*(.text.init.refok)					\
-		*(.exit.text.refok)
+		*(.exit.text.refok)					\
+	DEV_KEEP(init.text)						\
+	DEV_KEEP(exit.text)						\
+	CPU_KEEP(init.text)						\
+	CPU_KEEP(exit.text)						\
+	MEM_KEEP(init.text)						\
+	MEM_KEEP(exit.text)
+
 
 /* sched.text is aling to function alignment to secure we have same
  * address even at second ld pass when generating System.map */
@@ -184,11 +236,35 @@
 		VMLINUX_SYMBOL(__kprobes_text_end) = .;
 
 /* init and exit section handling */
-#define INIT_TEXT *(init.text)
-#define INIT_DATA *(init.data)
-#define EXIT_TEXT *(exit.text)
-#define EXIT_DATA *(exit.data)
+#define INIT_DATA							\
+	*(.init.data)							\
+	DEV_DISCARD(init.data)						\
+	DEV_DISCARD(init.rodata)					\
+	CPU_DISCARD(init.data)						\
+	CPU_DISCARD(init.rodata)					\
+	MEM_DISCARD(init.data)						\
+	MEM_DISCARD(init.rodata)
+
+#define INIT_TEXT							\
+	*(.init.text)							\
+	DEV_DISCARD(init.text)						\
+	CPU_DISCARD(init.text)						\
+	MEM_DISCARD(init.text)
+
+#define EXIT_DATA							\
+	*(.exit.data)							\
+	DEV_DISCARD(exit.data)						\
+	DEV_DISCARD(exit.rodata)					\
+	CPU_DISCARD(exit.data)						\
+	CPU_DISCARD(exit.rodata)					\
+	MEM_DISCARD(exit.data)						\
+	MEM_DISCARD(exit.rodata)
 
+#define EXIT_TEXT							\
+	*(.exit.text)							\
+	DEV_DISCARD(exit.text)						\
+	CPU_DISCARD(exit.text)						\
+	MEM_DISCARD(exit.text)
 
 		/* DWARF debug sections.
 		Symbols in the DWARF debugging sections are relative to
diff --git a/include/linux/init.h b/include/linux/init.h
index 9980768..dcb66c7 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -60,18 +60,54 @@
 #define __exit_refok     noinline __section(.exit.text.refok)
 
 #ifdef MODULE
-#define __exit		__section(.exit.text) __cold
+#define __exitused
 #else
-#define __exit		__attribute_used__ __section(.exit.text) __cold
+#define __exitused  __used
 #endif
 
+#define __exit          __section(.exit.text) __exitused __cold
+
+/* Used for HOTPLUG */
+#define __devinit        __section(.devinit.text) __cold
+#define __devinitdata    __section(.devinit.data)
+#define __devinitconst   __section(.devinit.rodata)
+#define __devexit        __section(.devexit.text) __exitused __cold
+#define __devexitdata    __section(.devexit.data)
+#define __devexitconst   __section(.devexit.rodata)
+
+/* Used for HOTPLUG_CPU */
+#define __cpuinit        __section(.cpuinit.text) __cold
+#define __cpuinitdata    __section(.cpuinit.data)
+#define __cpuinitconst   __section(.cpuinit.rodata)
+#define __cpuexit        __section(.cpuexit.text) __exitused __cold
+#define __cpuexitdata    __section(.cpuexit.data)
+#define __cpuexitconst   __section(.cpuexit.rodata)
+
+/* Used for MEMORY_HOTPLUG */
+#define __meminit        __section(.meminit.text) __cold
+#define __meminitdata    __section(.meminit.data)
+#define __meminitconst   __section(.meminit.rodata)
+#define __memexit        __section(.memexit.text) __exitused __cold
+#define __memexitdata    __section(.memexit.data)
+#define __memexitconst   __section(.memexit.rodata)
+
 /* For assembly routines */
 #define __INIT		.section	".init.text","ax"
 #define __INIT_REFOK	.section	".text.init.refok","ax"
 #define __FINIT		.previous
+
 #define __INITDATA	.section	".init.data","aw"
 #define __INITDATA_REFOK .section	".data.init.refok","aw"
 
+#define __DEVINIT        .section	".devinit.text", "ax"
+#define __DEVINITDATA    .section	".devinit.data", "aw"
+
+#define __CPUINIT        .section	".cpuinit.text", "ax"
+#define __CPUINITDATA    .section	".cpuinit.data", "aw"
+
+#define __MEMINIT        .section	".meminit.text", "ax"
+#define __MEMINITDATA    .section	".meminit.data", "aw"
+
 #ifndef __ASSEMBLY__
 /*
  * Used for initialization calls..
@@ -254,43 +290,6 @@ void __init parse_early_param(void);
 #define __initdata_or_module __initdata
 #endif /*CONFIG_MODULES*/
 
-#ifdef CONFIG_HOTPLUG
-#define __devinit
-#define __devinitdata
-#define __devexit
-#define __devexitdata
-#else
-#define __devinit __init
-#define __devinitdata __initdata
-#define __devexit __exit
-#define __devexitdata __exitdata
-#endif
-
-#ifdef CONFIG_HOTPLUG_CPU
-#define __cpuinit
-#define __cpuinitdata
-#define __cpuexit
-#define __cpuexitdata
-#else
-#define __cpuinit	__init
-#define __cpuinitdata __initdata
-#define __cpuexit __exit
-#define __cpuexitdata	__exitdata
-#endif
-
-#if defined(CONFIG_MEMORY_HOTPLUG) || defined(CONFIG_ACPI_HOTPLUG_MEMORY) \
-	|| defined(CONFIG_ACPI_HOTPLUG_MEMORY_MODULE)
-#define __meminit
-#define __meminitdata
-#define __memexit
-#define __memexitdata
-#else
-#define __meminit	__init
-#define __meminitdata __initdata
-#define __memexit __exit
-#define __memexitdata	__exitdata
-#endif
-
 /* Functions marked as __devexit may be discarded at kernel link time, depending
    on config options.  Newer versions of binutils detect references from
    retained sections to discarded sections and flag an error.  Pointers to
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 986513d..730b321 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -670,27 +670,41 @@ int match(const char *sym, const char * const pat[])
 static const char *section_white_list[] =
 	{ ".debug*", ".stab*", ".note*", ".got*", ".toc*", NULL };
 
-#define INIT_DATA_SECTIONS ".init.data$"
-#define EXIT_DATA_SECTIONS ".exit.data$"
+#define ALL_INIT_DATA_SECTIONS \
+	".init.data$", ".devinit.data$", ".cpuinit.data$", ".meminit.data$"
+#define ALL_EXIT_DATA_SECTIONS \
+	".exit.data$", ".devexit.data$", ".cpuexit.data$", ".memexit.data$"
 
-#define INIT_TEXT_SECTIONS ".init.text$"
-#define EXIT_TEXT_SECTIONS ".exit.text$"
+#define ALL_INIT_TEXT_SECTIONS \
+	".init.text$", ".devinit.text$", ".cpuinit.text$", ".meminit.text$"
+#define ALL_EXIT_TEXT_SECTIONS \
+	".exit.text$", ".devexit.text$", ".cpuexit.text$", ".memexit.text$"
 
-#define INIT_SECTIONS INIT_DATA_SECTIONS, INIT_TEXT_SECTIONS
-#define EXIT_SECTIONS EXIT_DATA_SECTIONS, EXIT_TEXT_SECTIONS
+#define ALL_INIT_SECTIONS ALL_INIT_DATA_SECTIONS, ALL_INIT_TEXT_SECTIONS
+#define ALL_EXIT_SECTIONS ALL_EXIT_DATA_SECTIONS, ALL_EXIT_TEXT_SECTIONS
 
 #define DATA_SECTIONS ".data$", ".data.rel$"
 #define TEXT_SECTIONS ".text$"
 
+#define INIT_SECTIONS      ".init.data$", ".init.text$"
+#define DEV_INIT_SECTIONS  ".devinit.data$", ".devinit.text$"
+#define CPU_INIT_SECTIONS  ".cpuinit.data$", ".cpuinit.text$"
+#define MEM_INIT_SECTIONS  ".meminit.data$", ".meminit.text$"
+
+#define EXIT_SECTIONS      ".exit.data$", ".exit.text$"
+#define DEV_EXIT_SECTIONS  ".devexit.data$", ".devexit.text$"
+#define CPU_EXIT_SECTIONS  ".cpuexit.data$", ".cpuexit.text$"
+#define MEM_EXIT_SECTIONS  ".memexit.data$", ".memexit.text$"
+
 /* init data sections */
-static const char *init_data_sections[] = { INIT_DATA_SECTIONS, NULL };
+static const char *init_data_sections[] = { ALL_INIT_DATA_SECTIONS, NULL };
 
 /* all init sections */
-static const char *init_sections[] = { INIT_SECTIONS, NULL };
+static const char *init_sections[] = { ALL_INIT_SECTIONS, NULL };
 
 /* All init and exit sections (code + data) */
 static const char *init_exit_sections[] =
-	{INIT_SECTIONS, EXIT_SECTIONS, NULL };
+	{ALL_INIT_SECTIONS, ALL_EXIT_SECTIONS, NULL };
 
 /* data section */
 static const char *data_sections[] = { DATA_SECTIONS, NULL };
@@ -734,22 +748,32 @@ const struct sectioncheck sectioncheck[] = {
  */
 {
 	.fromsec = { TEXT_SECTIONS, DATA_SECTIONS, NULL },
-	.tosec   = { INIT_SECTIONS, EXIT_SECTIONS, NULL }
+	.tosec   = { ALL_INIT_SECTIONS, ALL_EXIT_SECTIONS, NULL }
+},
+/* Do not reference init code/data from devinit/cpuinit/meminit code/data */
+{
+	.fromsec = { DEV_INIT_SECTIONS, CPU_INIT_SECTIONS, MEM_INIT_SECTIONS, NULL },
+	.tosec   = { INIT_SECTIONS, NULL }
+},
+/* Do not reference exit code/data from devexit/cpuexit/memexit code/data */
+{
+	.fromsec = { DEV_EXIT_SECTIONS, CPU_EXIT_SECTIONS, MEM_EXIT_SECTIONS, NULL },
+	.tosec   = { EXIT_SECTIONS, NULL }
 },
 /* Do not use exit code/data from init code */
 {
-	.fromsec = { INIT_SECTIONS, NULL },
-	.tosec   = { EXIT_SECTIONS, NULL },
+	.fromsec = { ALL_INIT_SECTIONS, NULL },
+	.tosec   = { ALL_EXIT_SECTIONS, NULL },
 },
 /* Do not use init code/data from exit code */
 {
-	.fromsec = { EXIT_SECTIONS, NULL },
-	.tosec   = { INIT_SECTIONS, NULL }
+	.fromsec = { ALL_EXIT_SECTIONS, NULL },
+	.tosec   = { ALL_INIT_SECTIONS, NULL }
 },
 /* Do not export init/exit functions or data */
 {
 	.fromsec = { "__ksymtab*", NULL },
-	.tosec   = { INIT_SECTIONS, EXIT_SECTIONS, NULL }
+	.tosec   = { ALL_INIT_SECTIONS, ALL_EXIT_SECTIONS, NULL }
 }
 };
 
-- 
1.5.4.rc3.14.g44397

