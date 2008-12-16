Return-Path: <linux-kernel-owner+w=401wt.eu-S1755941AbYLPL37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbYLPL37 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 06:29:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbYLPL3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 06:29:50 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:38861 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbYLPL3s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 06:29:48 -0500
Message-Id: <49479F50.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 16 Dec 2008 11:30:08 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <sam@ravnborg.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] allow stripping of generated symbols under
	 CONFIG_KALLSYMS_ALL
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building upon parts of the module stripping patch, this patch
introduces similar stripping for vmlinux when CONFIG_KALLSYMS_ALL=y.
Using CONFIG_KALLSYMS_STRIP_GENERATED reduces the overhead of
CONFIG_KALLSYMS_ALL from 245k/310k to 65k/80k for the (i386/x86-64)
kernels I tested with.

The patch also does away with the need to special case the kallsyms-
internal symbols by making them available even in the first linking
stage.

While it is a generated file, the patch includes the changes to 
scripts/genksyms/keywords.c_shipped, as I'm unsure what the procedure
here is.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 Makefile                            |   47 ++++++--
 arch/x86/scripts/strip-symbols      |    1 
 init/Kconfig                        |    7 +
 kernel/kallsyms.c                   |   16 +--
 scripts/genksyms/keywords.c_shipped |  189 ++++++++++++++++++------------------
 scripts/genksyms/keywords.gperf     |    2 
 scripts/kallsyms.c                  |   21 +---
 7 files changed, 155 insertions(+), 128 deletions(-)

--- 2.6.28-rc8-strip.orig/Makefile
+++ 2.6.28-rc8-strip/Makefile
@@ -600,6 +600,9 @@ export	INSTALL_PATH ?= /boot
 MODLIB	= $(INSTALL_MOD_PATH)/lib/modules/$(KERNELRELEASE)
 export MODLIB
 
+strip-symbols := $(srctree)/scripts/strip-symbols \
+		 $(wildcard $(srctree)/arch/$(ARCH)/scripts/strip-symbols)
+
 #
 # INSTALL_MOD_STRIP, if defined, will cause modules to be stripped while
 # they get installed.  If INSTALL_MOD_STRIP is '1', then the default
@@ -607,8 +610,10 @@ export MODLIB
 # be used as the option(s) to the objcopy command.
 ifdef INSTALL_MOD_STRIP
 ifeq ($(INSTALL_MOD_STRIP),1)
-mod_strip_cmd = $(OBJCOPY) --strip-debug --strip-symbols \
-		$(srctree)/scripts/strip-symbols --wildcard
+mod_strip_cmd = $(OBJCOPY) --strip-debug
+ifeq ($(CONFIG_KALLSYMS_ALL),$(CONFIG_KALLSYMS_STRIP_GENERATED))
+mod_strip_cmd += --wildcard $(addprefix --strip-symbols ,$(strip-symbols))
+endif
 else
 mod_strip_cmd = $(OBJCOPY) $(INSTALL_MOD_STRIP)
 endif # INSTALL_MOD_STRIP=1
@@ -743,6 +748,7 @@ last_kallsyms := 2
 endif
 
 kallsyms.o := .tmp_kallsyms$(last_kallsyms).o
+kallsyms.h := $(wildcard include/config/kallsyms/*.h) $(wildcard include/config/kallsyms/*/*.h)
 
 define verify_kallsyms
 	$(Q)$(if $($(quiet)cmd_sysmap),                                      \
@@ -767,24 +773,41 @@ endef
 
 # Generate .S file with all kernel symbols
 quiet_cmd_kallsyms = KSYM    $@
-      cmd_kallsyms = $(NM) -n $< | $(KALLSYMS) \
-                     $(if $(CONFIG_KALLSYMS_ALL),--all-symbols) > $@
+      cmd_kallsyms = { test $* -eq 0 || $(NM) -n $<; } \
+		     | $(KALLSYMS) $(if $(CONFIG_KALLSYMS_ALL),--all-symbols) >$@
 
-.tmp_kallsyms1.o .tmp_kallsyms2.o .tmp_kallsyms3.o: %.o: %.S scripts FORCE
+quiet_cmd_kstrip = STRIP   $@
+      cmd_kstrip = $(OBJCOPY) --wildcard $(addprefix --strip$(if $(CONFIG_RELOCATABLE),-unneeded)-symbols ,$(filter %/scripts/strip-symbols,$^)) $< $@
+
+$(foreach n,0 1 2 3,.tmp_kallsyms$(n).o): KBUILD_AFLAGS += -Wa,--strip-local-absolute
+$(foreach n,0 1 2 3,.tmp_kallsyms$(n).o): %.o: %.S scripts FORCE
 	$(call if_changed_dep,as_o_S)
 
-.tmp_kallsyms%.S: .tmp_vmlinux% $(KALLSYMS)
+ifeq ($(CONFIG_KALLSYMS_STRIP_GENERATED),y)
+strip-ext := .stripped
+endif
+
+.tmp_kallsyms%.S: .tmp_vmlinux%$(strip-ext) $(KALLSYMS) $(kallsyms.h)
 	$(call cmd,kallsyms)
 
+# make -jN seems to have problems with intermediate files, see bug #3330.
+.SECONDARY: $(foreach n,1 2 3,.tmp_vmlinux$(n).stripped)
+.tmp_vmlinux%.stripped: .tmp_vmlinux% $(strip-symbols) $(kallsyms.h)
+	$(call cmd,kstrip)
+
+ifneq ($(CONFIG_DEBUG_INFO),y)
+.tmp_vmlinux%: LDFLAGS_vmlinux += -S
+endif
 # .tmp_vmlinux1 must be complete except kallsyms, so update vmlinux version
-.tmp_vmlinux1: $(vmlinux-lds) $(vmlinux-all) FORCE
-	$(call if_changed_rule,ksym_ld)
+.tmp_vmlinux%: $(vmlinux-lds) $(vmlinux-all) FORCE
+	$(if $(filter 1,$*),$(call if_changed_rule,ksym_ld),$(call if_changed,vmlinux__))
 
-.tmp_vmlinux2: $(vmlinux-lds) $(vmlinux-all) .tmp_kallsyms1.o FORCE
-	$(call if_changed,vmlinux__)
+.tmp_vmlinux0$(strip-ext):
+	$(Q)echo "placeholder" >$@
 
-.tmp_vmlinux3: $(vmlinux-lds) $(vmlinux-all) .tmp_kallsyms2.o FORCE
-	$(call if_changed,vmlinux__)
+.tmp_vmlinux1: .tmp_kallsyms0.o
+.tmp_vmlinux2: .tmp_kallsyms1.o
+.tmp_vmlinux3: .tmp_kallsyms2.o
 
 # Needs to visit scripts/ before $(KALLSYMS) can be used.
 $(KALLSYMS): scripts ;
--- /dev/null
+++ 2.6.28-rc8-strip/arch/x86/scripts/strip-symbols
@@ -0,0 +1 @@
+__cpu_vendor_dev_X86_VENDOR_*
--- 2.6.28-rc8-strip.orig/init/Kconfig
+++ 2.6.28-rc8-strip/init/Kconfig
@@ -588,6 +588,13 @@ config KALLSYMS_ALL
 
 	   Say N.
 
+config KALLSYMS_STRIP_GENERATED
+	bool "Strip machine generated symbols from kallsyms"
+	depends on KALLSYMS_ALL
+	default y
+	help
+	  Say N if you want kallsyms to retain even machine generated symbols.
+
 config KALLSYMS_EXTRA_PASS
 	bool "Do an extra kallsyms pass"
 	depends on KALLSYMS
--- 2.6.28-rc8-strip.orig/scripts/genksyms/keywords.gperf
+++ 2.6.28-rc8-strip/scripts/genksyms/keywords.gperf
@@ -5,6 +5,8 @@ struct resword { const char *name; int t
 EXPORT_SYMBOL, EXPORT_SYMBOL_KEYW
 EXPORT_SYMBOL_GPL, EXPORT_SYMBOL_KEYW
 EXPORT_SYMBOL_GPL_FUTURE, EXPORT_SYMBOL_KEYW
+EXPORT_UNUSED_SYMBOL, EXPORT_SYMBOL_KEYW
+EXPORT_UNUSED_SYMBOL_GPL, EXPORT_SYMBOL_KEYW
 __asm, ASM_KEYW
 __asm__, ASM_KEYW
 __attribute, ATTRIBUTE_KEYW
--- 2.6.28-rc8-strip.orig/kernel/kallsyms.c
+++ 2.6.28-rc8-strip/kernel/kallsyms.c
@@ -30,20 +30,19 @@
 #define all_var 0
 #endif
 
-/* These will be re-linked against their real values during the second link stage */
-extern const unsigned long kallsyms_addresses[] __attribute__((weak));
-extern const u8 kallsyms_names[] __attribute__((weak));
+extern const unsigned long kallsyms_addresses[];
+extern const u8 kallsyms_names[];
 
 /* tell the compiler that the count isn't in the small data section if the arch
  * has one (eg: FRV)
  */
 extern const unsigned long kallsyms_num_syms
-__attribute__((weak, section(".rodata")));
+	__attribute__((__section__(".rodata")));
 
-extern const u8 kallsyms_token_table[] __attribute__((weak));
-extern const u16 kallsyms_token_index[] __attribute__((weak));
+extern const u8 kallsyms_token_table[];
+extern const u16 kallsyms_token_index[];
 
-extern const unsigned long kallsyms_markers[] __attribute__((weak));
+extern const unsigned long kallsyms_markers[];
 
 static inline int is_kernel_inittext(unsigned long addr)
 {
@@ -168,9 +167,6 @@ static unsigned long get_symbol_pos(unsi
 	unsigned long symbol_start = 0, symbol_end = 0;
 	unsigned long i, low, high, mid;
 
-	/* This kernel should never had been booted. */
-	BUG_ON(!kallsyms_addresses);
-
 	/* do a binary search on the sorted kallsyms_addresses array */
 	low = 0;
 	high = kallsyms_num_syms;
--- 2.6.28-rc8-strip.orig/scripts/kallsyms.c
+++ 2.6.28-rc8-strip/scripts/kallsyms.c
@@ -130,18 +130,9 @@ static int read_symbol(FILE *in, struct 
 static int symbol_valid(struct sym_entry *s)
 {
 	/* Symbols which vary between passes.  Passes 1 and 2 must have
-	 * identical symbol lists.  The kallsyms_* symbols below are only added
-	 * after pass 1, they would be included in pass 2 when --all-symbols is
-	 * specified so exclude them to get a stable symbol list.
+	 * identical symbol lists.
 	 */
 	static char *special_symbols[] = {
-		"kallsyms_addresses",
-		"kallsyms_num_syms",
-		"kallsyms_names",
-		"kallsyms_markers",
-		"kallsyms_token_table",
-		"kallsyms_token_index",
-
 	/* Exclude linker generated symbols which vary between passes */
 		"_SDA_BASE_",		/* ppc */
 		"_SDA2_BASE_",		/* ppc */
@@ -173,7 +164,9 @@ static int symbol_valid(struct sym_entry
 	}
 
 	/* Exclude symbols which vary between passes. */
-	if (strstr((char *)s->sym + offset, "_compiled."))
+	if (strstr((char *)s->sym + offset, "_compiled.") ||
+	    strncmp((char*)s->sym + offset, "__compound_literal.", 19) == 0 ||
+	    strncmp((char*)s->sym + offset, "__compound_literal$", 19) == 0)
 		return 0;
 
 	for (i = 0; special_symbols[i]; i++)
@@ -550,8 +543,10 @@ int main(int argc, char **argv)
 		usage();
 
 	read_map(stdin);
-	sort_symbols();
-	optimize_token_table();
+	if (table_cnt) {
+		sort_symbols();
+		optimize_token_table();
+	}
 	write_src();
 
 	return 0;
--- 2.6.28-rc8-strip.orig/scripts/genksyms/keywords.c_shipped
+++ 2.6.28-rc8-strip/scripts/genksyms/keywords.c_shipped
@@ -1,4 +1,4 @@
-/* ANSI-C code produced by gperf version 3.0.2 */
+/* ANSI-C code produced by gperf version 3.0.1 */
 /* Command-line: gperf -L ANSI-C -a -C -E -g -H is_reserved_hash -k '1,3,$' -N is_reserved_word -p -t scripts/genksyms/keywords.gperf  */
 
 #if !((' ' == 32) && ('!' == 33) && ('"' == 34) && ('#' == 35) \
@@ -32,7 +32,7 @@
 
 #line 3 "scripts/genksyms/keywords.gperf"
 struct resword { const char *name; int token; };
-/* maximum key range = 62, duplicates = 0 */
+/* maximum key range = 64, duplicates = 0 */
 
 #ifdef __GNUC__
 __inline
@@ -46,32 +46,32 @@ is_reserved_hash (register const char *s
 {
   static const unsigned char asso_values[] =
     {
-      65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
-      65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
-      65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
-      65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
-      65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
-      65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
-      65, 65, 65, 65, 65, 65, 65, 65, 65,  5,
-      65, 65, 65, 65, 65, 65, 35, 65, 65, 65,
-       0, 65, 65, 65, 65, 65, 65, 65, 65, 65,
-      65, 65, 65, 65, 65,  0, 65,  0, 65,  5,
-      20, 15, 10, 30, 65, 15, 65, 65, 20,  0,
-      10, 35, 20, 65, 10,  5,  0, 10,  5, 65,
-      65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
-      65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
-      65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
-      65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
-      65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
-      65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
-      65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
-      65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
-      65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
-      65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
-      65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
-      65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
-      65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
-      65, 65, 65, 65, 65, 65
+      67, 67, 67, 67, 67, 67, 67, 67, 67, 67,
+      67, 67, 67, 67, 67, 67, 67, 67, 67, 67,
+      67, 67, 67, 67, 67, 67, 67, 67, 67, 67,
+      67, 67, 67, 67, 67, 67, 67, 67, 67, 67,
+      67, 67, 67, 67, 67, 67, 67, 67, 67, 67,
+      67, 67, 67, 67, 67, 67, 67, 67, 67, 67,
+      67, 67, 67, 67, 67, 67, 67, 67, 67,  0,
+      67, 67, 67, 67, 67, 67, 15, 67, 67, 67,
+       0, 67, 67, 67, 67, 67, 67, 67, 67, 67,
+      67, 67, 67, 67, 67,  0, 67,  0, 67,  5,
+      25, 20, 15, 30, 67, 15, 67, 67, 10,  0,
+      10, 40, 20, 67, 10,  5,  0, 10, 15, 67,
+      67, 67, 67, 67, 67, 67, 67, 67, 67, 67,
+      67, 67, 67, 67, 67, 67, 67, 67, 67, 67,
+      67, 67, 67, 67, 67, 67, 67, 67, 67, 67,
+      67, 67, 67, 67, 67, 67, 67, 67, 67, 67,
+      67, 67, 67, 67, 67, 67, 67, 67, 67, 67,
+      67, 67, 67, 67, 67, 67, 67, 67, 67, 67,
+      67, 67, 67, 67, 67, 67, 67, 67, 67, 67,
+      67, 67, 67, 67, 67, 67, 67, 67, 67, 67,
+      67, 67, 67, 67, 67, 67, 67, 67, 67, 67,
+      67, 67, 67, 67, 67, 67, 67, 67, 67, 67,
+      67, 67, 67, 67, 67, 67, 67, 67, 67, 67,
+      67, 67, 67, 67, 67, 67, 67, 67, 67, 67,
+      67, 67, 67, 67, 67, 67, 67, 67, 67, 67,
+      67, 67, 67, 67, 67, 67
     };
   return len + asso_values[(unsigned char)str[2]] + asso_values[(unsigned char)str[0]] + asso_values[(unsigned char)str[len - 1]];
 }
@@ -84,116 +84,119 @@ is_reserved_word (register const char *s
 {
   enum
     {
-      TOTAL_KEYWORDS = 43,
+      TOTAL_KEYWORDS = 45,
       MIN_WORD_LENGTH = 3,
       MAX_WORD_LENGTH = 24,
       MIN_HASH_VALUE = 3,
-      MAX_HASH_VALUE = 64
+      MAX_HASH_VALUE = 66
     };
 
   static const struct resword wordlist[] =
     {
       {""}, {""}, {""},
-#line 26 "scripts/genksyms/keywords.gperf"
+#line 28 "scripts/genksyms/keywords.gperf"
       {"asm", ASM_KEYW},
       {""},
-#line 8 "scripts/genksyms/keywords.gperf"
+#line 10 "scripts/genksyms/keywords.gperf"
       {"__asm", ASM_KEYW},
       {""},
-#line 9 "scripts/genksyms/keywords.gperf"
+#line 11 "scripts/genksyms/keywords.gperf"
       {"__asm__", ASM_KEYW},
       {""}, {""},
-#line 52 "scripts/genksyms/keywords.gperf"
+#line 54 "scripts/genksyms/keywords.gperf"
       {"__typeof__", TYPEOF_KEYW},
       {""},
-#line 12 "scripts/genksyms/keywords.gperf"
+#line 14 "scripts/genksyms/keywords.gperf"
       {"__const", CONST_KEYW},
-#line 11 "scripts/genksyms/keywords.gperf"
-      {"__attribute__", ATTRIBUTE_KEYW},
 #line 13 "scripts/genksyms/keywords.gperf"
+      {"__attribute__", ATTRIBUTE_KEYW},
+#line 15 "scripts/genksyms/keywords.gperf"
       {"__const__", CONST_KEYW},
-#line 18 "scripts/genksyms/keywords.gperf"
+#line 20 "scripts/genksyms/keywords.gperf"
       {"__signed__", SIGNED_KEYW},
-#line 44 "scripts/genksyms/keywords.gperf"
+#line 46 "scripts/genksyms/keywords.gperf"
       {"static", STATIC_KEYW},
-#line 20 "scripts/genksyms/keywords.gperf"
-      {"__volatile__", VOLATILE_KEYW},
-#line 39 "scripts/genksyms/keywords.gperf"
+      {""},
+#line 41 "scripts/genksyms/keywords.gperf"
       {"int", INT_KEYW},
-#line 32 "scripts/genksyms/keywords.gperf"
+#line 34 "scripts/genksyms/keywords.gperf"
       {"char", CHAR_KEYW},
-#line 33 "scripts/genksyms/keywords.gperf"
+#line 35 "scripts/genksyms/keywords.gperf"
       {"const", CONST_KEYW},
-#line 45 "scripts/genksyms/keywords.gperf"
+#line 47 "scripts/genksyms/keywords.gperf"
       {"struct", STRUCT_KEYW},
-#line 24 "scripts/genksyms/keywords.gperf"
+#line 26 "scripts/genksyms/keywords.gperf"
       {"__restrict__", RESTRICT_KEYW},
-#line 25 "scripts/genksyms/keywords.gperf"
+#line 27 "scripts/genksyms/keywords.gperf"
       {"restrict", RESTRICT_KEYW},
-#line 23 "scripts/genksyms/keywords.gperf"
-      {"_restrict", RESTRICT_KEYW},
-#line 16 "scripts/genksyms/keywords.gperf"
+#line 7 "scripts/genksyms/keywords.gperf"
+      {"EXPORT_SYMBOL_GPL_FUTURE", EXPORT_SYMBOL_KEYW},
+#line 18 "scripts/genksyms/keywords.gperf"
       {"__inline__", INLINE_KEYW},
-#line 10 "scripts/genksyms/keywords.gperf"
-      {"__attribute", ATTRIBUTE_KEYW},
       {""},
-#line 14 "scripts/genksyms/keywords.gperf"
+#line 22 "scripts/genksyms/keywords.gperf"
+      {"__volatile__", VOLATILE_KEYW},
+#line 5 "scripts/genksyms/keywords.gperf"
+      {"EXPORT_SYMBOL", EXPORT_SYMBOL_KEYW},
+#line 25 "scripts/genksyms/keywords.gperf"
+      {"_restrict", RESTRICT_KEYW},
+      {""},
+#line 12 "scripts/genksyms/keywords.gperf"
+      {"__attribute", ATTRIBUTE_KEYW},
+#line 6 "scripts/genksyms/keywords.gperf"
+      {"EXPORT_SYMBOL_GPL", EXPORT_SYMBOL_KEYW},
+#line 16 "scripts/genksyms/keywords.gperf"
       {"__extension__", EXTENSION_KEYW},
-#line 35 "scripts/genksyms/keywords.gperf"
+#line 37 "scripts/genksyms/keywords.gperf"
       {"enum", ENUM_KEYW},
-#line 19 "scripts/genksyms/keywords.gperf"
-      {"__volatile", VOLATILE_KEYW},
-#line 36 "scripts/genksyms/keywords.gperf"
+#line 8 "scripts/genksyms/keywords.gperf"
+      {"EXPORT_UNUSED_SYMBOL", EXPORT_SYMBOL_KEYW},
+#line 38 "scripts/genksyms/keywords.gperf"
       {"extern", EXTERN_KEYW},
       {""},
-#line 17 "scripts/genksyms/keywords.gperf"
+#line 19 "scripts/genksyms/keywords.gperf"
       {"__signed", SIGNED_KEYW},
-#line 7 "scripts/genksyms/keywords.gperf"
-      {"EXPORT_SYMBOL_GPL_FUTURE", EXPORT_SYMBOL_KEYW},
-      {""},
-#line 51 "scripts/genksyms/keywords.gperf"
+#line 9 "scripts/genksyms/keywords.gperf"
+      {"EXPORT_UNUSED_SYMBOL_GPL", EXPORT_SYMBOL_KEYW},
+#line 49 "scripts/genksyms/keywords.gperf"
+      {"union", UNION_KEYW},
+#line 53 "scripts/genksyms/keywords.gperf"
       {"typeof", TYPEOF_KEYW},
-#line 46 "scripts/genksyms/keywords.gperf"
+#line 48 "scripts/genksyms/keywords.gperf"
       {"typedef", TYPEDEF_KEYW},
-#line 15 "scripts/genksyms/keywords.gperf"
+#line 17 "scripts/genksyms/keywords.gperf"
       {"__inline", INLINE_KEYW},
-#line 31 "scripts/genksyms/keywords.gperf"
+#line 33 "scripts/genksyms/keywords.gperf"
       {"auto", AUTO_KEYW},
-#line 47 "scripts/genksyms/keywords.gperf"
-      {"union", UNION_KEYW},
-      {""}, {""},
-#line 48 "scripts/genksyms/keywords.gperf"
-      {"unsigned", UNSIGNED_KEYW},
-#line 49 "scripts/genksyms/keywords.gperf"
-      {"void", VOID_KEYW},
-#line 42 "scripts/genksyms/keywords.gperf"
-      {"short", SHORT_KEYW},
+#line 21 "scripts/genksyms/keywords.gperf"
+      {"__volatile", VOLATILE_KEYW},
       {""}, {""},
 #line 50 "scripts/genksyms/keywords.gperf"
-      {"volatile", VOLATILE_KEYW},
-      {""},
-#line 37 "scripts/genksyms/keywords.gperf"
-      {"float", FLOAT_KEYW},
-#line 34 "scripts/genksyms/keywords.gperf"
-      {"double", DOUBLE_KEYW},
+      {"unsigned", UNSIGNED_KEYW},
       {""},
-#line 5 "scripts/genksyms/keywords.gperf"
-      {"EXPORT_SYMBOL", EXPORT_SYMBOL_KEYW},
-      {""}, {""},
-#line 38 "scripts/genksyms/keywords.gperf"
+#line 44 "scripts/genksyms/keywords.gperf"
+      {"short", SHORT_KEYW},
+#line 40 "scripts/genksyms/keywords.gperf"
       {"inline", INLINE_KEYW},
-#line 6 "scripts/genksyms/keywords.gperf"
-      {"EXPORT_SYMBOL_GPL", EXPORT_SYMBOL_KEYW},
-#line 41 "scripts/genksyms/keywords.gperf"
-      {"register", REGISTER_KEYW},
       {""},
-#line 22 "scripts/genksyms/keywords.gperf"
+#line 52 "scripts/genksyms/keywords.gperf"
+      {"volatile", VOLATILE_KEYW},
+#line 42 "scripts/genksyms/keywords.gperf"
+      {"long", LONG_KEYW},
+#line 24 "scripts/genksyms/keywords.gperf"
       {"_Bool", BOOL_KEYW},
-#line 43 "scripts/genksyms/keywords.gperf"
-      {"signed", SIGNED_KEYW},
       {""}, {""},
-#line 40 "scripts/genksyms/keywords.gperf"
-      {"long", LONG_KEYW}
+#line 43 "scripts/genksyms/keywords.gperf"
+      {"register", REGISTER_KEYW},
+#line 51 "scripts/genksyms/keywords.gperf"
+      {"void", VOID_KEYW},
+#line 39 "scripts/genksyms/keywords.gperf"
+      {"float", FLOAT_KEYW},
+#line 36 "scripts/genksyms/keywords.gperf"
+      {"double", DOUBLE_KEYW},
+      {""}, {""}, {""}, {""},
+#line 45 "scripts/genksyms/keywords.gperf"
+      {"signed", SIGNED_KEYW}
     };
 
   if (len <= MAX_WORD_LENGTH && len >= MIN_WORD_LENGTH)


