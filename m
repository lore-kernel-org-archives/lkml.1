Return-Path: <linux-kernel-owner+w=401wt.eu-S1755687AbZIVNiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687AbZIVNiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 09:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755440AbZIVNiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 09:38:54 -0400
Received: from mxout-08.mxes.net ([216.86.168.183]:47040 "EHLO
	mxout-08.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154AbZIVNiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 09:38:51 -0400
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       linux-modules@vger.org, Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 2/4] kbuild: sort the list of symbols exported by the kernel (__ksymtab)
Date: Tue, 22 Sep 2009 14:38:36 +0100
Message-Id: <1253626718-18887-3-git-send-email-alan-jenkins@tuffmail.co.uk>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1253626718-18887-1-git-send-email-alan-jenkins@tuffmail.co.uk>
References: <1253626718-18887-1-git-send-email-alan-jenkins@tuffmail.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

modpost of vmlinux.o now extracts the ksymtab sections and outputs
sorted versions of them as .tmp_exports.c.  These sorted sections
are linked into vmlinux and the original unsorted sections are
discarded.

This will allow modules to be loaded faster, resolving symbols using
binary search, without any increase in the memory needed for the
symbol tables.

This does not affect the building of modules, so hopefully it won't
affect compile times too much.

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
CC: Sam Ravnborg <sam@ravnborg.org>
---
 Makefile                          |   20 ++++++++---
 include/asm-generic/vmlinux.lds.h |   40 ++++++++++++++++------
 include/linux/mod_export.h        |   19 ++++++++--
 scripts/Makefile.modpost          |    2 +-
 scripts/mod/modpost.c             |   66 ++++++++++++++++++++++++++++++++++++-
 5 files changed, 124 insertions(+), 23 deletions(-)

diff --git a/Makefile b/Makefile
index 60de4ef..bb35b4d 100644
--- a/Makefile
+++ b/Makefile
@@ -674,6 +674,8 @@ libs-y		:= $(libs-y1) $(libs-y2)
 #   +--< $(vmlinux-main)
 #   |    +--< driver/built-in.o mm/built-in.o + more
 #   |
+#   +-< .tmp_exports.o (see comments regarding modpost of vmlinux.o)
+#   |
 #   +-< kallsyms.o (see description in CONFIG_KALLSYMS section)
 #
 # vmlinux version (uname -v) cannot be updated during normal
@@ -737,7 +739,6 @@ define rule_vmlinux__
 	$(verify_kallsyms)
 endef
 
-
 ifdef CONFIG_KALLSYMS
 # Generate section listing all symbols and add it into vmlinux $(kallsyms.o)
 # It's a three stage process:
@@ -797,13 +798,13 @@ quiet_cmd_kallsyms = KSYM    $@
 	$(call cmd,kallsyms)
 
 # .tmp_vmlinux1 must be complete except kallsyms, so update vmlinux version
-.tmp_vmlinux1: $(vmlinux-lds) $(vmlinux-all) FORCE
+.tmp_vmlinux1: $(vmlinux-lds) $(vmlinux-all) .tmp_exports.o FORCE
 	$(call if_changed_rule,ksym_ld)
 
-.tmp_vmlinux2: $(vmlinux-lds) $(vmlinux-all) .tmp_kallsyms1.o FORCE
+.tmp_vmlinux2: $(vmlinux-lds) $(vmlinux-all) .tmp_exports.o .tmp_kallsyms1.o FORCE
 	$(call if_changed,vmlinux__)
 
-.tmp_vmlinux3: $(vmlinux-lds) $(vmlinux-all) .tmp_kallsyms2.o FORCE
+.tmp_vmlinux3: $(vmlinux-lds) $(vmlinux-all) .tmp_exports.o .tmp_kallsyms2.o FORCE
 	$(call if_changed,vmlinux__)
 
 # Needs to visit scripts/ before $(KALLSYMS) can be used.
@@ -835,7 +836,7 @@ define rule_vmlinux-modpost
 endef
 
 # vmlinux image - including updated kernel symbols
-vmlinux: $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) vmlinux.o $(kallsyms.o) FORCE
+vmlinux: $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) vmlinux.o .tmp_exports.o $(kallsyms.o) FORCE
 ifdef CONFIG_HEADERS_CHECK
 	$(Q)$(MAKE) -f $(srctree)/Makefile headers_check
 endif
@@ -858,6 +859,12 @@ modpost-init := $(filter-out init/built-in.o, $(vmlinux-init))
 vmlinux.o: $(modpost-init) $(vmlinux-main) FORCE
 	$(call if_changed_rule,vmlinux-modpost)
 
+# The modpost of vmlinux.o above creates .tmp_exports.c, a list of exported
+# symbols sorted by name.  This list is linked into vmlinux to replace the
+# original unsorted exports.  It allows symbols to be resolved efficiently
+# when loading modules.
+.tmp_exports.c: vmlinux.o
+
 # The actual objects are generated when descending, 
 # make sure no implicit rule kicks in
 $(sort $(vmlinux-init) $(vmlinux-main)) $(vmlinux-lds): $(vmlinux-dirs) ;
@@ -1190,7 +1197,8 @@ endif # CONFIG_MODULES
 # Directories & files removed with 'make clean'
 CLEAN_DIRS  += $(MODVERDIR)
 CLEAN_FILES +=	vmlinux System.map \
-                .tmp_kallsyms* .tmp_version .tmp_vmlinux* .tmp_System.map
+                .tmp_kallsyms* .tmp_version .tmp_vmlinux* .tmp_System.map \
+                .tmp_exports*
 
 # Directories & files removed with 'make mrproper'
 MRPROPER_DIRS  += include/config include2 usr/include include/generated
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 6ad76bf..16c3e01 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -253,79 +253,97 @@
 									\
 	TRACEDATA							\
 									\
+	/* 								\
+	 * Kernel symbol table: discard the original unsorted tables	\
+	 * in favour of the sorted versions. 				\
+	 */								\
+	/DISCARD/ : {							\
+		*(__ksymtab)						\
+		*(__ksymtab_gpl)					\
+		*(__ksymtab_unused)					\
+		*(__ksymtab_unused_gpl)					\
+		*(__ksymtab_gpl_future)					\
+		*(__kcrctab)						\
+		*(__kcrctab_gpl)					\
+		*(__kcrctab_unused)					\
+		*(__kcrctab_unused_gpl)					\
+		*(__kcrctab_gpl_future)					\
+		*(__ksymtab_strings)					\
+	}								\
+									\
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
diff --git a/include/linux/mod_export.h b/include/linux/mod_export.h
index 3c51b9c..737a829 100644
--- a/include/linux/mod_export.h
+++ b/include/linux/mod_export.h
@@ -31,17 +31,20 @@ struct kernel_symbol
 #endif
 
 /* For every exported symbol, place a struct in the __ksymtab section */
-#define __EXPORT_SYMBOL(sym, sec)				\
+#define __EXPORT_SYMBOL_NAME(sym, sec, stringsec)			\
 	extern typeof(sym) sym;					\
 	__CRC_SYMBOL(sym, sec)					\
 	static const char __kstrtab_##sym[]			\
-	__attribute__((section("__ksymtab_strings"), aligned(1))) \
+	__attribute__((section(stringsec), aligned(1))) \
 	= MODULE_SYMBOL_PREFIX #sym;                    	\
 	static const struct kernel_symbol __ksymtab_##sym	\
 	__used							\
 	__attribute__((section("__ksymtab" sec), unused))	\
 	= { (unsigned long)&sym, __kstrtab_##sym }
 
+#define __EXPORT_SYMBOL(sym, sec) \
+	__EXPORT_SYMBOL_NAME(sym, sec, "__ksymtab_strings")
+
 #define EXPORT_SYMBOL(sym)					\
 	__EXPORT_SYMBOL(sym, "")
 
@@ -51,14 +54,22 @@ struct kernel_symbol
 #define EXPORT_SYMBOL_GPL_FUTURE(sym)				\
 	__EXPORT_SYMBOL(sym, "_gpl_future")
 
+
 #ifdef CONFIG_UNUSED_SYMBOLS
-#define EXPORT_UNUSED_SYMBOL(sym) __EXPORT_SYMBOL(sym, "_unused")
-#define EXPORT_UNUSED_SYMBOL_GPL(sym) __EXPORT_SYMBOL(sym, "_unused_gpl")
+#define EXPORT_UNUSED_SYMBOL(sym) __EXPORT_SYMBOL(sym, "_unused", "")
+#define EXPORT_UNUSED_SYMBOL_GPL(sym) __EXPORT_SYMBOL(sym, "_unused_gpl", "")
 #else
 #define EXPORT_UNUSED_SYMBOL(sym)
 #define EXPORT_UNUSED_SYMBOL_GPL(sym)
 #endif
 
+/*
+ * In vmlinux (but not modules), __ksymtab and friends are replaced by sorted
+ * versions generated by scripts/mod/modpost.c
+ */
+#define __EXPORT_SYMBOL_SORTED(sym, sec) \
+	__EXPORT_SYMBOL_NAME(sym, sec "_sorted", "__ksymtab_strings_sorted")
+
 #endif /* __GENKSYMS__ */
 
 #else /* !CONFIG_MODULES */
diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index f4053dc..8bee8cd 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -98,7 +98,7 @@ __modpost: $(modules:.ko=.o) FORCE
 	$(call cmd,modpost) $(wildcard vmlinux) $(filter-out FORCE,$^)
 
 quiet_cmd_kernel-mod = MODPOST $@
-      cmd_kernel-mod = $(modpost) $@
+      cmd_kernel-mod = $(modpost) -x .tmp_exports.c $@
 
 vmlinux.o: FORCE
 	@rm -fr $(kernelmarkersfile)
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 4522948..6302ce7 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -154,6 +154,7 @@ struct symbol {
 };
 
 static struct symbol *symbolhash[SYMBOL_HASH_SIZE];
+unsigned int symbolcount;
 
 /* This is based on the hash agorithm from gdbm, via tdb */
 static inline unsigned int tdb_hash(const char *name)
@@ -191,6 +192,7 @@ static struct symbol *new_symbol(const char *name, struct module *module,
 	unsigned int hash;
 	struct symbol *new;
 
+	symbolcount++;
 	hash = tdb_hash(name) % SYMBOL_HASH_SIZE;
 	new = symbolhash[hash] = alloc_symbol(name, 0, symbolhash[hash]);
 	new->module = module;
@@ -1976,6 +1978,61 @@ static void write_dump(const char *fname)
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
+/* sort exported symbols and output as */
+static void write_exports(const char *fname)
+{
+	struct buffer buf = { };
+	struct symbol *sym, **symbols;
+	int i, n;
+
+	symbols = NOFAIL(malloc(sizeof (struct symbol *) * symbolcount));
+	n = 0;
+
+	for (i = 0; i < SYMBOL_HASH_SIZE; i++) {
+		for (sym = symbolhash[i]; sym; sym = sym->next)
+			symbols[n++] = sym;
+	}
+
+	qsort(symbols, n, sizeof(struct symbol *), compare_symbol_names);
+
+	buf_printf(&buf, "#include <linux/mod_export.h>\n");
+	buf_printf(&buf, "\n");
+
+	for (i = 0; i < n; i++) {
+		sym = symbols[i];
+
+		/*
+		 * We need to declare the symbol with extern linkage.
+		 * Don't worry about the type. The linker won't care, and the
+		 * compiler won't complain unless we include a conflicting
+		 * declaration.
+		 */
+		buf_printf(&buf, "extern void *%s;\n", sym->name);
+
+		buf_printf(&buf, "__EXPORT_SYMBOL_SORTED(%s, \"%s\");\n",
+				sym->name,
+				section_names[sym->export]);
+	}
+
+	write_if_changed(&buf, fname);
+}
+
 static void add_marker(struct module *mod, const char *name, const char *fmt)
 {
 	char *line = NULL;
@@ -2077,6 +2134,7 @@ int main(int argc, char **argv)
 	struct buffer buf = { };
 	char *kernel_read = NULL, *module_read = NULL;
 	char *dump_write = NULL;
+	char *exports_write = NULL;
 	char *markers_read = NULL;
 	char *markers_write = NULL;
 	int opt;
@@ -2084,7 +2142,7 @@ int main(int argc, char **argv)
 	struct ext_sym_list *extsym_iter;
 	struct ext_sym_list *extsym_start = NULL;
 
-	while ((opt = getopt(argc, argv, "i:I:e:cmsSo:awM:K:")) != -1) {
+	while ((opt = getopt(argc, argv, "i:I:e:cmsSo:awM:K:x:")) != -1) {
 		switch (opt) {
 		case 'i':
 			kernel_read = optarg;
@@ -2122,6 +2180,9 @@ int main(int argc, char **argv)
 		case 'w':
 			warn_unresolved = 1;
 			break;
+		case 'x':
+			exports_write = optarg;
+			break;
 			case 'M':
 				markers_write = optarg;
 				break;
@@ -2182,6 +2243,9 @@ int main(int argc, char **argv)
 		     "'make CONFIG_DEBUG_SECTION_MISMATCH=y'\n",
 		     sec_mismatch_count);
 
+	if (exports_write)
+		write_exports(exports_write);
+
 	if (markers_read)
 		read_markers(markers_read);
 
-- 
1.6.3.2

