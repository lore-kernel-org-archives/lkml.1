Return-Path: <linux-kernel-owner+w=401wt.eu-S1756427AbZKCKHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427AbZKCKHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 05:07:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752925AbZKCKHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 05:07:42 -0500
Received: from mxout-08.mxes.net ([216.86.168.183]:48984 "EHLO
	mxout-08.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153AbZKCKHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 05:07:38 -0500
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
To: greg@kroah.com
Cc: linux-kbuild@vger.kernel.org, carmelo73@gmail.com,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 05/10] kbuild: sort the list of symbols exported by the kernel (__ksymtab)
Date: Tue,  3 Nov 2009 10:06:17 +0000
Message-Id: <1257242782-10496-6-git-send-email-alan-jenkins@tuffmail.co.uk>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <9b2b86520911020852q49c55695rb05d87090fa9ad33@mail.gmail.com>
References: <9b2b86520911020852q49c55695rb05d87090fa9ad33@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

modpost of vmlinux.o now extracts the ksymtab sections and outputs
sorted versions of them as .tmp_exports-asm.S.  These sorted sections
are linked into vmlinux and the original unsorted sections are
discarded.

This will allow modules to be loaded faster, resolving symbols using
binary search, without any increase in the memory needed for the
symbol tables.

This does not affect the building of modules, so hopefully it won't
affect compile times too much.

Minimally tested on ARM under QEMU emulator.
Build tested on blackfin; output of "size -A" unchanged.

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
CC: Sam Ravnborg <sam@ravnborg.org>
---
 Makefile                          |   20 ++++++---
 include/asm-generic/vmlinux.lds.h |   39 ++++++++++++-----
 include/linux/mod_export.h        |   83 ++++++++++++++++++++++++++++++++++--
 init/Kconfig                      |    5 ++
 scripts/Makefile.modpost          |    2 +-
 scripts/mod/modpost.c             |   63 +++++++++++++++++++++++++++-
 6 files changed, 188 insertions(+), 24 deletions(-)

diff --git a/Makefile b/Makefile
index 00444a8..d7e4ed9 100644
--- a/Makefile
+++ b/Makefile
@@ -721,6 +721,8 @@ libs-y		:= $(libs-y1) $(libs-y2)
 #   +--< $(vmlinux-main)
 #   |    +--< driver/built-in.o mm/built-in.o + more
 #   |
+#   +-< .tmp_exports-asm.o (see comments regarding modpost of vmlinux.o)
+#   |
 #   +-< kallsyms.o (see description in CONFIG_KALLSYMS section)
 #
 # vmlinux version (uname -v) cannot be updated during normal
@@ -784,7 +786,6 @@ define rule_vmlinux__
 	$(verify_kallsyms)
 endef
 
-
 ifdef CONFIG_KALLSYMS
 # Generate section listing all symbols and add it into vmlinux $(kallsyms.o)
 # It's a three stage process:
@@ -844,13 +845,13 @@ quiet_cmd_kallsyms = KSYM    $@
 	$(call cmd,kallsyms)
 
 # .tmp_vmlinux1 must be complete except kallsyms, so update vmlinux version
-.tmp_vmlinux1: $(vmlinux-lds) $(vmlinux-all) FORCE
+.tmp_vmlinux1: $(vmlinux-lds) $(vmlinux-all) .tmp_exports-asm.o FORCE
 	$(call if_changed_rule,ksym_ld)
 
-.tmp_vmlinux2: $(vmlinux-lds) $(vmlinux-all) .tmp_kallsyms1.o FORCE
+.tmp_vmlinux2: $(vmlinux-lds) $(vmlinux-all) .tmp_exports-asm.o .tmp_kallsyms1.o FORCE
 	$(call if_changed,vmlinux__)
 
-.tmp_vmlinux3: $(vmlinux-lds) $(vmlinux-all) .tmp_kallsyms2.o FORCE
+.tmp_vmlinux3: $(vmlinux-lds) $(vmlinux-all) .tmp_exports-asm.o .tmp_kallsyms2.o FORCE
 	$(call if_changed,vmlinux__)
 
 # Needs to visit scripts/ before $(KALLSYMS) can be used.
@@ -882,7 +883,7 @@ define rule_vmlinux-modpost
 endef
 
 # vmlinux image - including updated kernel symbols
-vmlinux: $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) vmlinux.o $(kallsyms.o) FORCE
+vmlinux: $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) vmlinux.o .tmp_exports-asm.o $(kallsyms.o) FORCE
 ifdef CONFIG_HEADERS_CHECK
 	$(Q)$(MAKE) -f $(srctree)/Makefile headers_check
 endif
@@ -905,6 +906,12 @@ modpost-init := $(filter-out init/built-in.o, $(vmlinux-init))
 vmlinux.o: $(modpost-init) $(vmlinux-main) FORCE
 	$(call if_changed_rule,vmlinux-modpost)
 
+# The modpost of vmlinux.o above creates .tmp_exports-asm.S, a list of exported
+# symbols sorted by name.  This list is linked into vmlinux to replace the
+# original unsorted exports.  It allows symbols to be resolved efficiently
+# when loading modules.
+.tmp_exports-asm.S: vmlinux.o
+
 # The actual objects are generated when descending, 
 # make sure no implicit rule kicks in
 $(sort $(vmlinux-init) $(vmlinux-main)) $(vmlinux-lds): $(vmlinux-dirs) ;
@@ -1232,7 +1239,8 @@ endif # CONFIG_MODULES
 # Directories & files removed with 'make clean'
 CLEAN_DIRS  += $(MODVERDIR)
 CLEAN_FILES +=	vmlinux System.map \
-                .tmp_kallsyms* .tmp_version .tmp_vmlinux* .tmp_System.map
+                .tmp_kallsyms* .tmp_version .tmp_vmlinux* .tmp_System.map \
+                .tmp_exports-asm*
 
 # Directories & files removed with 'make mrproper'
 MRPROPER_DIRS  += include/config include2 usr/include include/generated
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index b6e818f..9feb474 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -254,76 +254,76 @@
 	/* Kernel symbol table: Normal symbols */			\
 	__ksymtab         : AT(ADDR(__ksymtab) - LOAD_OFFSET) {		\
 		VMLINUX_SYMBOL(__start___ksymtab) = .;			\
-		*(__ksymtab)						\
+		*(__ksymtab_sorted)					\
 		VMLINUX_SYMBOL(__stop___ksymtab) = .;			\
 	}								\
 									\
 	/* Kernel symbol table: GPL-only symbols */			\
 	__ksymtab_gpl     : AT(ADDR(__ksymtab_gpl) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__start___ksymtab_gpl) = .;		\
-		*(__ksymtab_gpl)					\
+		*(__ksymtab_gpl_sorted)					\
 		VMLINUX_SYMBOL(__stop___ksymtab_gpl) = .;		\
 	}								\
 									\
 	/* Kernel symbol table: Normal unused symbols */		\
 	__ksymtab_unused  : AT(ADDR(__ksymtab_unused) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__start___ksymtab_unused) = .;		\
-		*(__ksymtab_unused)					\
+		*(__ksymtab_unused_sorted)				\
 		VMLINUX_SYMBOL(__stop___ksymtab_unused) = .;		\
 	}								\
 									\
 	/* Kernel symbol table: GPL-only unused symbols */		\
 	__ksymtab_unused_gpl : AT(ADDR(__ksymtab_unused_gpl) - LOAD_OFFSET) { \
 		VMLINUX_SYMBOL(__start___ksymtab_unused_gpl) = .;	\
-		*(__ksymtab_unused_gpl)					\
+		*(__ksymtab_unused_gpl_sorted)				\
 		VMLINUX_SYMBOL(__stop___ksymtab_unused_gpl) = .;	\
 	}								\
 									\
 	/* Kernel symbol table: GPL-future-only symbols */		\
 	__ksymtab_gpl_future : AT(ADDR(__ksymtab_gpl_future) - LOAD_OFFSET) { \
 		VMLINUX_SYMBOL(__start___ksymtab_gpl_future) = .;	\
-		*(__ksymtab_gpl_future)					\
+		*(__ksymtab_gpl_future_sorted)				\
 		VMLINUX_SYMBOL(__stop___ksymtab_gpl_future) = .;	\
 	}								\
 									\
 	/* Kernel symbol table: Normal symbols */			\
 	__kcrctab         : AT(ADDR(__kcrctab) - LOAD_OFFSET) {		\
 		VMLINUX_SYMBOL(__start___kcrctab) = .;			\
-		*(__kcrctab)						\
+		*(__kcrctab_sorted)					\
 		VMLINUX_SYMBOL(__stop___kcrctab) = .;			\
 	}								\
 									\
 	/* Kernel symbol table: GPL-only symbols */			\
 	__kcrctab_gpl     : AT(ADDR(__kcrctab_gpl) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__start___kcrctab_gpl) = .;		\
-		*(__kcrctab_gpl)					\
+		*(__kcrctab_gpl_sorted)					\
 		VMLINUX_SYMBOL(__stop___kcrctab_gpl) = .;		\
 	}								\
 									\
 	/* Kernel symbol table: Normal unused symbols */		\
 	__kcrctab_unused  : AT(ADDR(__kcrctab_unused) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__start___kcrctab_unused) = .;		\
-		*(__kcrctab_unused)					\
+		*(__kcrctab_unused_sorted)				\
 		VMLINUX_SYMBOL(__stop___kcrctab_unused) = .;		\
 	}								\
 									\
 	/* Kernel symbol table: GPL-only unused symbols */		\
 	__kcrctab_unused_gpl : AT(ADDR(__kcrctab_unused_gpl) - LOAD_OFFSET) { \
 		VMLINUX_SYMBOL(__start___kcrctab_unused_gpl) = .;	\
-		*(__kcrctab_unused_gpl)					\
+		*(__kcrctab_unused_gpl_sorted)				\
 		VMLINUX_SYMBOL(__stop___kcrctab_unused_gpl) = .;	\
 	}								\
 									\
 	/* Kernel symbol table: GPL-future-only symbols */		\
 	__kcrctab_gpl_future : AT(ADDR(__kcrctab_gpl_future) - LOAD_OFFSET) { \
 		VMLINUX_SYMBOL(__start___kcrctab_gpl_future) = .;	\
-		*(__kcrctab_gpl_future)					\
+		*(__kcrctab_gpl_future_sorted)				\
 		VMLINUX_SYMBOL(__stop___kcrctab_gpl_future) = .;	\
 	}								\
 									\
 	/* Kernel symbol table: strings */				\
         __ksymtab_strings : AT(ADDR(__ksymtab_strings) - LOAD_OFFSET) {	\
-		*(__ksymtab_strings)					\
+		*(__ksymtab_strings_sorted)				\
 	}								\
 									\
 	/* __*init sections */						\
@@ -639,6 +639,23 @@
 	EXIT_DATA							\
 	EXIT_CALL							\
 	*(.discard)							\
+									\
+	/* 								\
+	 * Discard the original unsorted symbol tables.			\
+	 * In vmlinux they are replaced by sorted versions		\
+	 * generated by modpost -x.					\
+	 */								\
+	*(__ksymtab)							\
+	*(__ksymtab_gpl)						\
+	*(__ksymtab_unused)						\
+	*(__ksymtab_unused_gpl)						\
+	*(__ksymtab_gpl_future)						\
+	*(__kcrctab)							\
+	*(__kcrctab_gpl)						\
+	*(__kcrctab_unused)						\
+	*(__kcrctab_unused_gpl)						\
+	*(__kcrctab_gpl_future)						\
+	*(__ksymtab_strings)						\
 	}
 
 /**
diff --git a/include/linux/mod_export.h b/include/linux/mod_export.h
index 56b817a..3bb14e9 100644
--- a/include/linux/mod_export.h
+++ b/include/linux/mod_export.h
@@ -1,19 +1,35 @@
 #ifndef LINUX_MOD_EXPORT_H
 #define LINUX_MOD_EXPORT_H
 
+/*
+ * mod_export.h
+ *
+ * Define EXPORT_SYMBOL() and friends for kernel modules.
+ *
+ * Alternatively under __MODPOST_EXPORTS__, define __EXPORT_SYMBOL()
+ * in arch-independent assembly language.
+ */
+
+#ifndef __MODPOST_EXPORTS__
 #include <linux/compiler.h>
-#include <asm/module.h>
+#else
+#include <asm/bitsperlong.h>
+#include <linux/stringify.h>
+#endif
 
 /* Some toolchains use a `_' prefix for all user symbols. */
 #define MODULE_SYMBOL_PREFIX CONFIG_SYMBOL_PREFIX
 
+
+#ifndef __GENKSYMS__
+#ifndef __MODPOST_EXPORTS__
+#ifdef CONFIG_MODULES
+
 struct kernel_symbol {
 	unsigned long value;
 	const char *name;
 };
 
-#ifdef CONFIG_MODULES
-#ifndef __GENKSYMS__
 #ifdef CONFIG_MODVERSIONS
 /* Mark the CRC weak since genksyms apparently decides not to
  * generate a checksums for some symbols */
@@ -56,8 +72,6 @@ struct kernel_symbol {
 #define EXPORT_UNUSED_SYMBOL_GPL(sym)
 #endif
 
-#endif /* __GENKSYMS__ */
-
 #else /* !CONFIG_MODULES */
 
 #define EXPORT_SYMBOL(sym)
@@ -68,4 +82,63 @@ struct kernel_symbol {
 
 #endif /* CONFIG_MODULES */
 
+#else /* __MODPOST_EXPORTS__ */
+
+#if BITS_PER_LONG == 64
+#define PTR .quad
+#define ALGN .balign 8
+#else
+#define PTR .long
+#define ALGN .balign 4
+#endif
+
+/*
+ * We use CPP macros since they are more familiar than assembly macros.
+ * Note that CPP macros eat newlines, so each statement must be terminated
+ * by a semicolon.
+ */
+
+#ifdef CONFIG_HAVE_SYMBOL_PREFIX
+#define __SYM(sym) _##sym
+#else
+#define __SYM(sym) sym
+#endif
+
+#define SYM(sym) __SYM(sym)
+
+
+#ifdef CONFIG_MODVERSIONS
+#define __CRC_SYMBOL(sym, crcsec)				\
+	.globl SYM(__crc_##sym);				\
+	.weak SYM(__crc_##sym);					\
+	.pushsection crcsec, "a";				\
+	ALGN;							\
+	SYM(__kcrctab_##sym):					\
+	PTR SYM(__crc_##sym);					\
+	.popsection;
+#else
+#define __CRC_SYMBOL(sym, section)
+#endif
+
+#define __EXPORT_SYMBOL(sym, sec, strsec, crcsec)		\
+	.globl SYM(sym);					\
+								\
+	__CRC_SYMBOL(sym, crcsec)				\
+								\
+	.pushsection strsec, "a";				\
+	SYM(__kstrtab_##sym):					\
+	.asciz __stringify(SYM(sym));				\
+	.popsection;						\
+								\
+	.pushsection sec, "a";					\
+	ALGN;							\
+	SYM(__ksymtab_##sym):					\
+	PTR SYM(sym);						\
+	PTR SYM(__kstrtab_##sym);				\
+	.popsection;
+
+#endif /* __MODPOST_EXPORTS__ */
+
+#endif /* __GENKSYMS__ */
+
 #endif /* LINUX_MOD_EXPORT_H */
diff --git a/init/Kconfig b/init/Kconfig
index fe43d6d..7f4ddf6 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1100,6 +1100,11 @@ config BASE_SMALL
 	default 0 if BASE_FULL
 	default 1 if !BASE_FULL
 
+config HAVE_SYMBOL_PREFIX
+	bool
+	help
+	  Some arch toolchains use a `_' prefix for all user symbols.
+
 menuconfig MODULES
 	bool "Enable loadable module support"
 	help
diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index 8f14c81..876a3c7 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -91,7 +91,7 @@ __modpost: $(modules:.ko=.o) FORCE
 	$(call cmd,modpost) $(wildcard vmlinux) $(filter-out FORCE,$^)
 
 quiet_cmd_kernel-mod = MODPOST $@
-      cmd_kernel-mod = $(modpost) $@
+      cmd_kernel-mod = $(modpost) -x .tmp_exports-asm.S $@
 
 vmlinux.o: FORCE
 	$(call cmd,kernel-mod)
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 3867481..404b69a 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -158,6 +158,7 @@ struct symbol {
 };
 
 static struct symbol *symbolhash[SYMBOL_HASH_SIZE];
+unsigned int symbolcount;
 
 /* This is based on the hash agorithm from gdbm, via tdb */
 static inline unsigned int tdb_hash(const char *name)
@@ -195,6 +196,7 @@ static struct symbol *new_symbol(const char *name, struct module *module,
 	unsigned int hash;
 	struct symbol *new;
 
+	symbolcount++;
 	hash = tdb_hash(name) % SYMBOL_HASH_SIZE;
 	new = symbolhash[hash] = alloc_symbol(name, 0, symbolhash[hash]);
 	new->module = module;
@@ -1980,6 +1982,58 @@ static void write_dump(const char *fname)
 	write_if_changed(&buf, fname);
 }
 
+static const char *section_names[] = {
+	[export_plain] 		= "",
+	[export_unused]		= "_unused",
+	[export_gpl]		= "_gpl",
+	[export_unused_gpl]	= "_unused_gpl",
+	[export_gpl_future]	= "_gpl_future",
+};
+
+static int compare_symbol_names(const void *a, const void *b)
+{
+	struct symbol *const *syma = a;
+	struct symbol *const *symb = b;
+
+	return strcmp((*syma)->name, (*symb)->name);
+}
+
+/* sort exported symbols and output using arch-independent assembly macros */
+static void write_exports(const char *fname)
+{
+	struct buffer buf = { };
+	struct symbol *sym, **symbols;
+	int i, n;
+
+	symbols = NOFAIL(malloc(sizeof(struct symbol *) * symbolcount));
+	n = 0;
+
+	for (i = 0; i < SYMBOL_HASH_SIZE; i++) {
+		for (sym = symbolhash[i]; sym; sym = sym->next)
+			symbols[n++] = sym;
+	}
+
+	qsort(symbols, n, sizeof(struct symbol *), compare_symbol_names);
+
+	buf_printf(&buf, "#define __MODPOST_EXPORTS__\n");
+	buf_printf(&buf, "#include <linux/mod_export.h>\n");
+	buf_printf(&buf, "\n");
+
+	for (i = 0; i < n; i++) {
+		sym = symbols[i];
+
+		buf_printf(&buf, "__EXPORT_SYMBOL(%s,"
+					" __ksymtab%s_sorted,"
+					" __ksymtab_strings_sorted,"
+					" __kcrctab%s_sorted)\n",
+					sym->name,
+					section_names[sym->export],
+					section_names[sym->export]);
+	}
+
+	write_if_changed(&buf, fname);
+}
+
 static void add_marker(struct module *mod, const char *name, const char *fmt)
 {
 	char *line = NULL;
@@ -2081,6 +2135,7 @@ int main(int argc, char **argv)
 	struct buffer buf = { };
 	char *kernel_read = NULL, *module_read = NULL;
 	char *dump_write = NULL;
+	char *exports_write = NULL;
 	char *markers_read = NULL;
 	char *markers_write = NULL;
 	int opt;
@@ -2088,7 +2143,7 @@ int main(int argc, char **argv)
 	struct ext_sym_list *extsym_iter;
 	struct ext_sym_list *extsym_start = NULL;
 
-	while ((opt = getopt(argc, argv, "i:I:e:cmsSo:awM:K:")) != -1) {
+	while ((opt = getopt(argc, argv, "i:I:e:cmsSo:awM:K:x:")) != -1) {
 		switch (opt) {
 		case 'i':
 			kernel_read = optarg;
@@ -2126,6 +2181,9 @@ int main(int argc, char **argv)
 		case 'w':
 			warn_unresolved = 1;
 			break;
+		case 'x':
+			exports_write = optarg;
+			break;
 			case 'M':
 				markers_write = optarg;
 				break;
@@ -2186,6 +2244,9 @@ int main(int argc, char **argv)
 		     "'make CONFIG_DEBUG_SECTION_MISMATCH=y'\n",
 		     sec_mismatch_count);
 
+	if (exports_write)
+		write_exports(exports_write);
+
 	if (markers_read)
 		read_markers(markers_read);
 
-- 
1.6.3.2

