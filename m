Return-Path: <linux-kernel-owner+w=401wt.eu-S1760326AbXISO6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760326AbXISO6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 10:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781AbXISO6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 10:58:10 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:24433
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752953AbXISO6J convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 10:58:09 -0400
Message-Id: <46F15559.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Wed, 19 Sep 2007 15:59:05 +0100
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
X-Mailing-List: linux-kernel@vger.kernel.org

Building upon parts of the module stripping patch, this patch
introduces similar stripping for vmlinux when CONFIG_KALLSYMS_ALL=y.
Using the newly added config option CONFIG_KALLSYMS_STRIP_GENERATED
reduces the overhead of CONFIG_KALLSYMS_ALL from 220k/260k to 60k/70k
for the i386/x86-64 kernels I tested with.

The patch also does away with the need to special case the kallsyms-
internal symbols by making them available even in the first linking
stage.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 Makefile           |   44 +++++++++++++++++++++++++++++++++-----------
 init/Kconfig       |    7 +++++++
 kernel/kallsyms.c  |   16 ++++++----------
 scripts/kallsyms.c |   18 ++++++------------
 4 files changed, 52 insertions(+), 33 deletions(-)

--- 2.6.23-rc6-strip.orig/Makefile
+++ 2.6.23-rc6-strip/Makefile
@@ -541,6 +541,8 @@ export	INSTALL_PATH ?= /boot
 MODLIB	= $(INSTALL_MOD_PATH)/lib/modules/$(KERNELRELEASE)
 export MODLIB
 
+strip-lst := $(srctree)/scripts/strip-syms.lst $(wildcard $(srctree)/arch/$(ARCH)/scripts/strip-syms.lst)
+
 #
 # INSTALL_MOD_STRIP, if defined, will cause modules to be stripped while
 # they get installed.  If INSTALL_MOD_STRIP is '1', then the default
@@ -548,7 +550,10 @@ export MODLIB
 # be used as the option(s) to the objcopy command.
 ifdef INSTALL_MOD_STRIP
 ifeq ($(INSTALL_MOD_STRIP),1)
-mod_strip_cmd = $(OBJCOPY) --strip-debug --strip-symbols $(srctree)/scripts/strip-syms.lst --wildcard
+mod_strip_cmd = $(OBJCOPY) --strip-debug
+ifeq ($(CONFIG_KALLSYMS_ALL),$(CONFIG_KALLSYMS_STRIP_GENERATED))
+mod_strip_cmd += --wildcard $(addprefix --strip-symbols ,$(strip-lst))
+endif
 else
 mod_strip_cmd = $(OBJCOPY) $(INSTALL_MOD_STRIP)
 endif # INSTALL_MOD_STRIP=1
@@ -707,24 +712,41 @@ endef
 
 # Generate .S file with all kernel symbols
 quiet_cmd_kallsyms = KSYM    $@
-      cmd_kallsyms = $(NM) -n $< | $(KALLSYMS) \
-                     $(if $(CONFIG_KALLSYMS_ALL),--all-symbols) > $@
+      cmd_kallsyms = { test $* -eq 0 || $(NM) -n $<; } \
+		     | $(KALLSYMS) $(if $(CONFIG_KALLSYMS_ALL),--all-symbols) >$@
 
-.tmp_kallsyms1.o .tmp_kallsyms2.o .tmp_kallsyms3.o: %.o: %.S scripts FORCE
+quiet_cmd_kstrip = STRIP   $@
+      cmd_kstrip = $(OBJCOPY) --wildcard $(addprefix --strip-symbols ,$(filter %.lst,$^)) $< $@
+
+$(foreach n,0 1 2 3,.tmp_kallsyms$(n).o): AFLAGS += -Wa,--strip-local-absolute
+$(foreach n,0 1 2 3,.tmp_kallsyms$(n).o): %.o: %.S scripts FORCE
 	$(call if_changed_dep,as_o_S)
 
-.tmp_kallsyms%.S: .tmp_vmlinux% $(KALLSYMS)
+ifeq ($(CONFIG_KALLSYMS_STRIP_GENERATED),y)
+strip-ext := .stripped
+endif
+
+.tmp_kallsyms%.S: .tmp_vmlinux%$(strip-ext) $(KALLSYMS) include/linux/autoconf.h
 	$(call cmd,kallsyms)
 
+# make -jN seems to have problems with intermediate files, see bug #3330.
+.SECONDARY: $(foreach n,1 2 3,.tmp_vmlinux$(n).stripped)
+.tmp_vmlinux%.stripped: .tmp_vmlinux% $(strip-lst) include/linux/autoconf.h
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
--- 2.6.23-rc6-strip.orig/init/Kconfig
+++ 2.6.23-rc6-strip/init/Kconfig
@@ -400,6 +400,13 @@ config KALLSYMS_ALL
 
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
--- 2.6.23-rc6-strip.orig/kernel/kallsyms.c
+++ 2.6.23-rc6-strip/kernel/kallsyms.c
@@ -30,15 +30,14 @@
 #define all_var 0
 #endif
 
-/* These will be re-linked against their real values during the second link stage */
-extern const unsigned long kallsyms_addresses[] __attribute__((weak));
-extern const unsigned long kallsyms_num_syms __attribute__((weak));
-extern const u8 kallsyms_names[] __attribute__((weak));
+extern const unsigned long kallsyms_addresses[];
+extern const unsigned long kallsyms_num_syms;
+extern const u8 kallsyms_names[];
 
-extern const u8 kallsyms_token_table[] __attribute__((weak));
-extern const u16 kallsyms_token_index[] __attribute__((weak));
+extern const u8 kallsyms_token_table[];
+extern const u16 kallsyms_token_index[];
 
-extern const unsigned long kallsyms_markers[] __attribute__((weak));
+extern const unsigned long kallsyms_markers[];
 
 static inline int is_kernel_inittext(unsigned long addr)
 {
@@ -172,9 +171,6 @@ static unsigned long get_symbol_pos(unsi
 	unsigned long symbol_start = 0, symbol_end = 0;
 	unsigned long i, low, high, mid;
 
-	/* This kernel should never had been booted. */
-	BUG_ON(!kallsyms_addresses);
-
 	/* do a binary search on the sorted kallsyms_addresses array */
 	low = 0;
 	high = kallsyms_num_syms;
--- 2.6.23-rc6-strip.orig/scripts/kallsyms.c
+++ 2.6.23-rc6-strip/scripts/kallsyms.c
@@ -138,18 +138,9 @@ static int read_symbol(FILE *in, struct 
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
@@ -181,7 +172,9 @@ static int symbol_valid(struct sym_entry
 	}
 
 	/* Exclude symbols which vary between passes. */
-	if (strstr((char *)s->sym + offset, "_compiled."))
+	if (strstr((char *)s->sym + offset, "_compiled.") ||
+	    strncmp((char*)s->sym + offset, "__compound_literal.", 19) == 0 ||
+	    strncmp((char*)s->sym + offset, "__compound_literal$", 19) == 0)
 		return 0;
 
 	for (i = 0; special_symbols[i]; i++)
@@ -527,7 +520,8 @@ int main(int argc, char **argv)
 		usage();
 
 	read_map(stdin);
-	optimize_token_table();
+	if (table_cnt)
+		optimize_token_table();
 	write_src();
 
 	return 0;


