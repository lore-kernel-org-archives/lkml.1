Return-Path: <linux-kernel-owner+w=401wt.eu-S1763508AbYBBNwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763508AbYBBNwk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 08:52:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762856AbYBBNwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 08:52:21 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:39021 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762754AbYBBNwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 08:52:19 -0500
Date: Sat, 2 Feb 2008 14:52:22 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC] Add EXPORT_INIT_SYMBOL()?
Message-ID: <20080202135222.GA23700@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While analysing some of the section mismatches reported
by modpost I came to the conclusion that there
was no good way to say that a certain function could
both be annotated say __cpuinit and exported.

One example is register_cpu_notifier() in kernel/cpu.c
The function is annotated __cpuinit which is correct
as this function is used only in the startup phase
of a non HOTPLUG_CPU kernel and always available if
CONFIG_HOTPLUG_CPU is equal 'y'.

There are more examples in the tree - I have used
register_cpu_notifier as an example.

So that left me with the following choices:
a) Drop the annotation of register_cpu_notifier()
   thus wasting memory and loosing the checks
   performed by modpost.
b) Add a small helper function annotated __ref
   that would call the __cpuinit annotated
   __register_cpu_notifier()
c) Drop all section mismatch checks for exported
   symbols expect those annotated with __init
d) Add a new EXPORT_SYMBOL variant that tell modpost
   that this symbol are safe to use any of the
   __devinit, __cpuinit, __meminit annotated
   functions.

I was quite tempted to just go for c) but decided to
get some opinions on approach d).
Implemented with following patch - and uses
the new EXPOST_INIT_SYMBOL() for register_cpu_notifier.

Btw. I went for EXPORT_INIT_SYMBOL in favour of
EXPORT_SYMBOL_INIT as the latter syntax is used for
symbol classification.

Comments?

Note: This is an RFC - I will split it up in two
patches if we go for this. One that introduce
EXPORT_INIT_SYMBOL and another that use the
new EXPORT for register_cpu_notifier().

	Sam

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index f784d2f..c64a675 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -97,6 +97,7 @@
 	__ksymtab         : AT(ADDR(__ksymtab) - LOAD_OFFSET) {		\
 		VMLINUX_SYMBOL(__start___ksymtab) = .;			\
 		*(__ksymtab)						\
+		*(__ksymtab_init)					\
 		VMLINUX_SYMBOL(__stop___ksymtab) = .;			\
 	}								\
 									\
@@ -132,6 +133,7 @@
 	__kcrctab         : AT(ADDR(__kcrctab) - LOAD_OFFSET) {		\
 		VMLINUX_SYMBOL(__start___kcrctab) = .;			\
 		*(__kcrctab)						\
+		*(__kcrctab_init)					\
 		VMLINUX_SYMBOL(__stop___kcrctab) = .;			\
 	}								\
 									\
diff --git a/include/linux/module.h b/include/linux/module.h
index ac481e2..f853b06 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -206,6 +206,14 @@ void *__symbol_get_gpl(const char *symbol);
 #define EXPORT_SYMBOL_GPL_FUTURE(sym)				\
 	__EXPORT_SYMBOL(sym, "_gpl_future")
 
+/*
+ * Use EXPORT_INIT_SYMBOL for code that are annotated __*init
+ * to document that this symbol is used only during the
+ * early init phase.
+ */
+#define EXPORT_INIT_SYMBOL(sym)					\
+	__EXPORT_SYMBOL(sym, "_init")
+
 
 #ifdef CONFIG_UNUSED_SYMBOLS
 #define EXPORT_UNUSED_SYMBOL(sym) __EXPORT_SYMBOL(sym, "_unused")
diff --git a/kernel/cpu.c b/kernel/cpu.c
index e0d3a4f..91833af 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -147,7 +147,7 @@ int __cpuinit register_cpu_notifier(struct notifier_block *nb)
 
 #ifdef CONFIG_HOTPLUG_CPU
 
-EXPORT_SYMBOL(register_cpu_notifier);
+EXPORT_INIT_SYMBOL(register_cpu_notifier);
 
 void unregister_cpu_notifier(struct notifier_block *nb)
 {
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index f8efc93..f4d660e 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -33,7 +33,8 @@ static int sec_mismatch_verbose = 1;
 
 enum export {
 	export_plain,      export_unused,     export_gpl,
-	export_unused_gpl, export_gpl_future, export_unknown
+	export_unused_gpl, export_gpl_future, export_init,
+	export_unknown
 };
 
 #define PRINTF __attribute__ ((format (printf, 1, 2)))
@@ -220,6 +221,7 @@ static struct {
 	{ .str = "EXPORT_SYMBOL_GPL",        .export = export_gpl },
 	{ .str = "EXPORT_UNUSED_SYMBOL_GPL", .export = export_unused_gpl },
 	{ .str = "EXPORT_SYMBOL_GPL_FUTURE", .export = export_gpl_future },
+	{ .str = "EXPORT_INIT_SYMBOL",       .export = export_init },
 	{ .str = "(unknown)",                .export = export_unknown },
 };
 
@@ -254,6 +256,8 @@ static enum export export_from_sec(struct elf_info *elf, Elf_Section sec)
 		return export_unused_gpl;
 	else if (sec == elf->export_gpl_future_sec)
 		return export_gpl_future;
+	else if (sec == elf->export_init_sec)
+		return export_init;
 	else
 		return export_unknown;
 }
@@ -435,6 +439,8 @@ static int parse_elf(struct elf_info *info, const char *filename)
 			info->export_unused_gpl_sec = i;
 		else if (strcmp(secname, "__ksymtab_gpl_future") == 0)
 			info->export_gpl_future_sec = i;
+		else if (strcmp(secname, "__ksymtab_init") == 0)
+			info->export_init_sec = i;
 
 		if (sechdrs[i].sh_type != SHT_SYMTAB)
 			continue;
@@ -867,6 +873,13 @@ const struct sectioncheck sectioncheck[] = {
 	.tosec   = { ALL_INIT_SECTIONS, NULL },
 	.mismatch = EXIT_TO_INIT,
 },
+/* export from __ksymtab_init to *init / *exit functions or data is OK */
+{
+	.fromsec = { "__ksymtab_init*", NULL },
+	.tosec   = { DEV_INIT_SECTIONS, CPU_INIT_SECTIONS, MEM_INIT_SECTIONS,
+	             DEV_EXIT_SECTIONS, CPU_EXIT_SECTIONS, MEM_EXIT_SECTIONS, NULL },
+	.mismatch = NO_MISMATCH
+},
 /* Do not export init/exit functions or data */
 {
 	.fromsec = { "__ksymtab*", NULL },
@@ -1573,6 +1586,7 @@ static void check_for_gpl_usage(enum export exp, const char *m, const char *s)
 	case export_plain:
 	case export_unused:
 	case export_unknown:
+	case export_init:
 		/* ignore */
 		break;
 	}
diff --git a/scripts/mod/modpost.h b/scripts/mod/modpost.h
index 999f15e..3d3ea05 100644
--- a/scripts/mod/modpost.h
+++ b/scripts/mod/modpost.h
@@ -126,6 +126,7 @@ struct elf_info {
 	Elf_Section  export_gpl_sec;
 	Elf_Section  export_unused_gpl_sec;
 	Elf_Section  export_gpl_future_sec;
+	Elf_Section  export_init_sec;
 	const char   *strtab;
 	char	     *modinfo;
 	unsigned int modinfo_len;
