Return-Path: <linux-kernel-owner+w=401wt.eu-S1752908AbZF3LwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbZF3LwK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 07:52:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754374AbZF3Lvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 07:51:52 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:46088 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbZF3Lvt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 07:51:49 -0400
Message-Id: <4A4A18780200007800008345@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 30 Jun 2009 12:51:52 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>, <tony.luck@intel.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Rusty Russell" <rusty@rustcorp.com.au>, <hpa@zytor.com>
Cc: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] reduce export symbol CRC table size on 64-bit archs
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since these CRCs are really only 32-bit quantities, there's no need to
store them in 64-bit slots. Since, however, gcc doesn't allow
respective initializations, asm() constructs get used to create the CRC
tables (and its for that reason that the patch only makes x86-64 and
ia64 utilize that functionality, as I can't verify this doesn't break
in some subtle way elsewhere).

Observed size reduction (x86-64):
- 16k kernel resident size
- 2k module resident size
- 1M vmlinux image size

If the asm() construct could be extended to all architectures, and if
modpost would guarantee generation of CRCs for all exported, then
the __crc_* symbols wouldn't need to be declared weak anymore, could
hence remain local to the exporting object. By adding
-Wa,-strip-local-absolute to the second compilation step the __crc_*
symbols could even be prevented from making it into any object file at
all.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/ia64/include/asm/module.h |    2 ++
 arch/x86/include/asm/module.h  |    1 +
 include/linux/module.h         |   41 ++++++++++++++++++++++++++---------------
 include/linux/moduleparam.h    |   10 +++++++++-
 kernel/module.c                |   26 +++++++++++++-------------
 scripts/genksyms/genksyms.c    |   16 ++++++++--------
 6 files changed, 59 insertions(+), 37 deletions(-)

--- linux-2.6.31-rc1/arch/ia64/include/asm/module.h	2009-06-10 05:05:27.000000000 +0200
+++ 2.6.31-rc1-module-crc-int/arch/ia64/include/asm/module.h	2009-04-27 12:12:50.000000000 +0200
@@ -39,4 +39,6 @@ struct mod_arch_specific {
 
 #define ARCH_SHF_SMALL	SHF_IA_64_SHORT
 
+#define ARCH_ASM_KSYM_CRC data4
+
 #endif /* _ASM_IA64_MODULE_H */
--- linux-2.6.31-rc1/arch/x86/include/asm/module.h	2008-12-25 00:26:37.000000000 +0100
+++ 2.6.31-rc1-module-crc-int/arch/x86/include/asm/module.h	2009-04-27 12:12:50.000000000 +0200
@@ -15,6 +15,7 @@ struct mod_arch_specific {};
 #endif
 
 #ifdef CONFIG_X86_64
+#define ARCH_ASM_KSYM_CRC .long
 /* X86_64 does not define MODULE_PROC_FAMILY */
 #elif defined CONFIG_M386
 #define MODULE_PROC_FAMILY "386 "
--- linux-2.6.31-rc1/include/linux/module.h	2009-06-26 17:50:00.000000000 +0200
+++ 2.6.31-rc1-module-crc-int/include/linux/module.h	2009-04-27 12:15:26.000000000 +0200
@@ -19,8 +19,6 @@
 #include <linux/tracepoint.h>
 #include <asm/local.h>
 
-#include <asm/module.h>
-
 /* Not Yet Implemented */
 #define MODULE_SUPPORTED_DEVICE(name)
 
@@ -39,7 +37,7 @@ struct kernel_symbol
 
 struct modversion_info
 {
-	unsigned long crc;
+	ksym_crc_t crc;
 	char name[MODULE_NAME_LEN];
 };
 
@@ -175,17 +173,30 @@ void *__symbol_get_gpl(const char *symbo
 #define symbol_get(x) ((typeof(&x))(__symbol_get(MODULE_SYMBOL_PREFIX #x)))
 
 #ifndef __GENKSYMS__
-#ifdef CONFIG_MODVERSIONS
+#define __KSTRTAB(sym) __kstrtab_##sym
+#ifndef CONFIG_MODVERSIONS
+#define __CRC_SYMBOL(sym, sec)
+#elif !defined(ARCH_ASM_KSYM_CRC) || defined(CC_PTR_CAST_INT)
 /* Mark the CRC weak since genksyms apparently decides not to
  * generate a checksums for some symbols */
 #define __CRC_SYMBOL(sym, sec)					\
 	extern void *__crc_##sym __attribute__((weak));		\
-	static const unsigned long __kcrctab_##sym		\
+	static const ksym_crc_t __kcrctab_##sym			\
 	__used							\
 	__attribute__((section("__kcrctab" sec), unused))	\
-	= (unsigned long) &__crc_##sym;
+	= (ksym_crc_t) (unsigned long) &__crc_##sym;
 #else
-#define __CRC_SYMBOL(sym, sec)
+#define __CRC_SYMBOL(sym, sec)					\
+	extern const char __Kstrtab_##sym[]			\
+	__asm__("__kstrtab_" #sym "\n\t"			\
+		".section __kcrctab" sec ",\"a\"\n\t"		\
+		".weak __crc_" #sym "\n\t"			\
+		__stringify(ARCH_ASM_KSYM_CRC) " __crc_" #sym "\n\t" \
+		".previous");					\
+	static const char __kstrtab_##sym[]			\
+	__used __attribute__((__unused__));
+#undef __KSTRTAB
+#define __KSTRTAB(sym) __Kstrtab_##sym
 #endif
 
 /* For every exported symbol, place a struct in the __ksymtab section */
@@ -198,7 +209,7 @@ void *__symbol_get_gpl(const char *symbo
 	static const struct kernel_symbol __ksymtab_##sym	\
 	__used							\
 	__attribute__((section("__ksymtab" sec), unused))	\
-	= { (unsigned long)&sym, __kstrtab_##sym }
+	= { (unsigned long)&sym, __KSTRTAB(sym) }
 
 #define EXPORT_SYMBOL(sym)					\
 	__EXPORT_SYMBOL(sym, "")
@@ -246,7 +257,7 @@ struct module
 
 	/* Exported symbols */
 	const struct kernel_symbol *syms;
-	const unsigned long *crcs;
+	const ksym_crc_t *crcs;
 	unsigned int num_syms;
 
 	/* Kernel parameters. */
@@ -256,23 +267,23 @@ struct module
 	/* GPL-only exported symbols. */
 	unsigned int num_gpl_syms;
 	const struct kernel_symbol *gpl_syms;
-	const unsigned long *gpl_crcs;
+	const ksym_crc_t *gpl_crcs;
 
 #ifdef CONFIG_UNUSED_SYMBOLS
 	/* unused exported symbols. */
 	const struct kernel_symbol *unused_syms;
-	const unsigned long *unused_crcs;
+	const ksym_crc_t *unused_crcs;
 	unsigned int num_unused_syms;
 
 	/* GPL-only, unused exported symbols. */
 	unsigned int num_unused_gpl_syms;
 	const struct kernel_symbol *unused_gpl_syms;
-	const unsigned long *unused_gpl_crcs;
+	const ksym_crc_t *unused_gpl_crcs;
 #endif
 
 	/* symbols that will be GPL-only in the near future. */
 	const struct kernel_symbol *gpl_future_syms;
-	const unsigned long *gpl_future_crcs;
+	const ksym_crc_t *gpl_future_crcs;
 	unsigned int num_gpl_future_syms;
 
 	/* Exception table */
@@ -406,7 +417,7 @@ struct module *find_module(const char *n
 
 struct symsearch {
 	const struct kernel_symbol *start, *stop;
-	const unsigned long *crcs;
+	const ksym_crc_t *crcs;
 	enum {
 		NOT_GPL_ONLY,
 		GPL_ONLY,
@@ -418,7 +429,7 @@ struct symsearch {
 /* Search for an exported symbol by name. */
 const struct kernel_symbol *find_symbol(const char *name,
 					struct module **owner,
-					const unsigned long **crc,
+					const ksym_crc_t **crc,
 					bool gplok,
 					bool warn);
 
--- linux-2.6.31-rc1/include/linux/moduleparam.h	2009-06-26 17:50:00.000000000 +0200
+++ 2.6.31-rc1-module-crc-int/include/linux/moduleparam.h	2009-04-27 12:12:50.000000000 +0200
@@ -5,6 +5,8 @@
 #include <linux/stringify.h>
 #include <linux/kernel.h>
 
+#include <asm/module.h>
+
 /* You can override this manually, but generally this should match the
    module name. */
 #ifdef MODULE
@@ -13,8 +15,14 @@
 #define MODULE_PARAM_PREFIX KBUILD_MODNAME "."
 #endif
 
+#ifdef ARCH_ASM_KSYM_CRC
+typedef unsigned int ksym_crc_t;
+#else
+typedef unsigned long ksym_crc_t;
+#endif
+
 /* Chosen so that structs with an unsigned long line up. */
-#define MAX_PARAM_PREFIX_LEN (64 - sizeof(unsigned long))
+#define MAX_PARAM_PREFIX_LEN (64 - sizeof(ksym_crc_t))
 
 #ifdef MODULE
 #define ___module_cat(a,b) __mod_ ## a ## b
--- linux-2.6.31-rc1/kernel/module.c	2009-06-26 17:50:00.000000000 +0200
+++ 2.6.31-rc1-module-crc-int/kernel/module.c	2009-04-27 12:16:40.000000000 +0200
@@ -174,16 +174,16 @@ extern const struct kernel_symbol __star
 extern const struct kernel_symbol __stop___ksymtab_gpl_future[];
 extern const struct kernel_symbol __start___ksymtab_gpl_future[];
 extern const struct kernel_symbol __stop___ksymtab_gpl_future[];
-extern const unsigned long __start___kcrctab[];
-extern const unsigned long __start___kcrctab_gpl[];
-extern const unsigned long __start___kcrctab_gpl_future[];
+extern const ksym_crc_t __start___kcrctab[];
+extern const ksym_crc_t __start___kcrctab_gpl[];
+extern const ksym_crc_t __start___kcrctab_gpl_future[];
 #ifdef CONFIG_UNUSED_SYMBOLS
 extern const struct kernel_symbol __start___ksymtab_unused[];
 extern const struct kernel_symbol __stop___ksymtab_unused[];
 extern const struct kernel_symbol __start___ksymtab_unused_gpl[];
 extern const struct kernel_symbol __stop___ksymtab_unused_gpl[];
-extern const unsigned long __start___kcrctab_unused[];
-extern const unsigned long __start___kcrctab_unused_gpl[];
+extern const ksym_crc_t __start___kcrctab_unused[];
+extern const ksym_crc_t __start___kcrctab_unused_gpl[];
 #endif
 
 #ifndef CONFIG_MODVERSIONS
@@ -276,7 +276,7 @@ struct find_symbol_arg {
 
 	/* Output */
 	struct module *owner;
-	const unsigned long *crc;
+	const ksym_crc_t *crc;
 	const struct kernel_symbol *sym;
 };
 
@@ -326,7 +326,7 @@ static bool find_symbol_in_section(const
  * (optional) module which owns it */
 const struct kernel_symbol *find_symbol(const char *name,
 					struct module **owner,
-					const unsigned long **crc,
+					const ksym_crc_t **crc,
 					bool gplok,
 					bool warn)
 {
@@ -1024,7 +1024,7 @@ static int check_version(Elf_Shdr *sechd
 			 unsigned int versindex,
 			 const char *symname,
 			 struct module *mod, 
-			 const unsigned long *crc)
+			 const ksym_crc_t *crc)
 {
 	unsigned int i, num_versions;
 	struct modversion_info *versions;
@@ -1047,8 +1047,8 @@ static int check_version(Elf_Shdr *sechd
 
 		if (versions[i].crc == *crc)
 			return 1;
-		DEBUGP("Found checksum %lX vs module %lX\n",
-		       *crc, versions[i].crc);
+		DEBUGP("Found checksum %X vs module %X\n",
+		       (unsigned int)*crc, (unsigned int)versions[i].crc);
 		goto bad_version;
 	}
 
@@ -1066,7 +1066,7 @@ static inline int check_modstruct_versio
 					  unsigned int versindex,
 					  struct module *mod)
 {
-	const unsigned long *crc;
+	const ksym_crc_t *crc;
 
 	if (!find_symbol("module_layout", NULL, &crc, true, false))
 		BUG();
@@ -1088,7 +1088,7 @@ static inline int check_version(Elf_Shdr
 				unsigned int versindex,
 				const char *symname,
 				struct module *mod, 
-				const unsigned long *crc)
+				const ksym_crc_t *crc)
 {
 	return 1;
 }
@@ -1116,7 +1116,7 @@ static const struct kernel_symbol *resol
 {
 	struct module *owner;
 	const struct kernel_symbol *sym;
-	const unsigned long *crc;
+	const ksym_crc_t *crc;
 
 	sym = find_symbol(name, &owner, &crc,
 			  !(mod->taints & (1 << TAINT_PROPRIETARY_MODULE)), true);
--- linux-2.6.31-rc1/scripts/genksyms/genksyms.c	2009-03-24 00:12:14.000000000 +0100
+++ 2.6.31-rc1-module-crc-int/scripts/genksyms/genksyms.c	2009-04-27 12:12:50.000000000 +0200
@@ -119,19 +119,19 @@ static const unsigned int crctab32[] = {
 	0x2d02ef8dU
 };
 
-static unsigned long partial_crc32_one(unsigned char c, unsigned long crc)
+static unsigned int partial_crc32_one(unsigned char c, unsigned int crc)
 {
 	return crctab32[(crc ^ c) & 0xff] ^ (crc >> 8);
 }
 
-static unsigned long partial_crc32(const char *s, unsigned long crc)
+static unsigned int partial_crc32(const char *s, unsigned int crc)
 {
 	while (*s)
 		crc = partial_crc32_one(*s++, crc);
 	return crc;
 }
 
-static unsigned long crc32(const char *s)
+static unsigned int crc32(const char *s)
 {
 	return partial_crc32(s, 0xffffffff) ^ 0xffffffff;
 }
@@ -149,7 +149,7 @@ static enum symbol_type map_to_ns(enum s
 
 struct symbol *find_symbol(const char *name, enum symbol_type ns)
 {
-	unsigned long h = crc32(name) % HASH_BUCKETS;
+	unsigned int h = crc32(name) % HASH_BUCKETS;
 	struct symbol *sym;
 
 	for (sym = symtab[h]; sym; sym = sym->hash_next)
@@ -180,7 +180,7 @@ struct symbol *__add_symbol(const char *
 			    struct string_list *defn, int is_extern,
 			    int is_reference)
 {
-	unsigned long h = crc32(name) % HASH_BUCKETS;
+	unsigned int h = crc32(name) % HASH_BUCKETS;
 	struct symbol *sym;
 	enum symbol_status status = STATUS_UNCHANGED;
 
@@ -433,7 +433,7 @@ static void print_list(FILE * f, struct 
 	}
 }
 
-static unsigned long expand_and_crc_sym(struct symbol *sym, unsigned long crc)
+static unsigned int expand_and_crc_sym(struct symbol *sym, unsigned int crc)
 {
 	struct string_list *list = sym->defn;
 	struct string_list **e, **b;
@@ -569,7 +569,7 @@ void export_symbol(const char *name)
 	if (!sym)
 		error_with_pos("export undefined symbol %s", name);
 	else {
-		unsigned long crc;
+		unsigned int crc;
 		int has_changed = 0;
 
 		if (flag_dump_defs)
@@ -611,7 +611,7 @@ void export_symbol(const char *name)
 			fputs(">\n", debugfile);
 
 		/* Used as a linker script. */
-		printf("%s__crc_%s = 0x%08lx ;\n", mod_prefix, name, crc);
+		printf("%s__crc_%s = %#08x ;\n", mod_prefix, name, crc);
 	}
 }
 


