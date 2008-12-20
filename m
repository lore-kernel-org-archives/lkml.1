Return-Path: <linux-kernel-owner+w=401wt.eu-S1755151AbYLTOdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbYLTOdF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 09:33:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753098AbYLTOaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 09:30:20 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:41328 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbYLTOaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 09:30:10 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Cc: Jan Beulich <jbeulich@novell.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 24/26] kbuild: strip generated symbols from *.ko
Date: Sat, 20 Dec 2008 15:31:35 +0100
Message-Id: <1229783497-19550-24-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.2.GIT
In-Reply-To: <20081220142518.GA19390@uranus.ravnborg.org>
References: <20081220142518.GA19390@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Beulich <jbeulich@novell.com>

This patch changes the way __crc_ symbols are being resolved from
using ld to do so to using the assembler, thus allowing these symbols
to be marked local (the linker creates then as global ones) and hence
allow stripping (for modules) or ignoring (for vmlinux) them. While at
this, also strip other generated symbols during module installation.

One potentially debatable point is the handling of the flags passeed
to gcc when translating the intermediate assembly file into an object:
passing $(c_flags) unchanged doesn't work as gcc passes --gdwarf2 to
gas whenever is sees any -g* option, even for -g0, and despite the
fact that the compiler would have already produced all necessary debug
info in the C->assembly translation phase. I took the approach of just
filtering out all -g* options, but an alternative to such negative
filtering might be to have a positive filter which might, in the ideal
case allow just all the -Wa,* options to pass through.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Makefile                    |   16 ++++++------
 scripts/Makefile.build      |   55 +++++++++++++++++++++++++++---------------
 scripts/Makefile.modinst    |    3 +-
 scripts/genksyms/genksyms.c |   21 +++++++++++----
 scripts/mksysmap            |    7 +----
 scripts/strip-symbols       |   22 +++++++++++++++++
 6 files changed, 84 insertions(+), 40 deletions(-)
 create mode 100644 scripts/strip-symbols

diff --git a/Makefile b/Makefile
index e1c5ae8..5dd0ed3 100644
--- a/Makefile
+++ b/Makefile
@@ -605,19 +605,19 @@ MODLIB	= $(INSTALL_MOD_PATH)/lib/modules/$(KERNELRELEASE)
 export MODLIB
 
 #
-#  INSTALL_MOD_STRIP, if defined, will cause modules to be
-#  stripped after they are installed.  If INSTALL_MOD_STRIP is '1', then
-#  the default option --strip-debug will be used.  Otherwise,
-#  INSTALL_MOD_STRIP will used as the options to the strip command.
-
+# INSTALL_MOD_STRIP, if defined, will cause modules to be stripped while
+# they get installed.  If INSTALL_MOD_STRIP is '1', then the default
+# options (see below) will be used.  Otherwise, INSTALL_MOD_STRIP will
+# be used as the option(s) to the objcopy command.
 ifdef INSTALL_MOD_STRIP
 ifeq ($(INSTALL_MOD_STRIP),1)
-mod_strip_cmd = $(STRIP) --strip-debug
+mod_strip_cmd = $(OBJCOPY) --strip-debug --strip-symbols \
+		$(srctree)/scripts/strip-symbols --wildcard
 else
-mod_strip_cmd = $(STRIP) $(INSTALL_MOD_STRIP)
+mod_strip_cmd = $(OBJCOPY) $(INSTALL_MOD_STRIP)
 endif # INSTALL_MOD_STRIP=1
 else
-mod_strip_cmd = true
+mod_strip_cmd = false
 endif # INSTALL_MOD_STRIP
 export mod_strip_cmd
 
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index c1da14b..6a21538 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -151,16 +151,16 @@ cmd_cc_i_c       = $(CPP) $(c_flags)   -o $@ $<
 $(obj)/%.i: $(src)/%.c FORCE
 	$(call if_changed_dep,cc_i_c)
 
-cmd_gensymtypes =                                                           \
+cmd_genksyms =                                                              \
     $(CPP) -D__GENKSYMS__ $(c_flags) $< |                                   \
-    $(GENKSYMS) -T $@ -a $(ARCH)                                            \
+    $(GENKSYMS) -T $@ -A -a $(ARCH)                                         \
      $(if $(KBUILD_PRESERVE),-p)                                            \
      $(if $(1),-r $(firstword $(wildcard $(@:.symtypes=.symref) /dev/null)))
 
 quiet_cmd_cc_symtypes_c = SYM $(quiet_modtag) $@
 cmd_cc_symtypes_c =                                                         \
     set -e;                                                                 \
-    $(call cmd_gensymtypes, true) >/dev/null;                               \
+    $(call cmd_genksyms, true) >/dev/null;                                  \
     test -s $@ || rm -f $@
 
 $(obj)/%.symtypes : $(src)/%.c FORCE
@@ -177,28 +177,38 @@ cmd_cc_o_c = $(CC) $(c_flags) -c -o $@ $<
 
 else
 # When module versioning is enabled the following steps are executed:
-# o compile a .tmp_<file>.o from <file>.c
-# o if .tmp_<file>.o doesn't contain a __ksymtab version, i.e. does
-#   not export symbols, we just rename .tmp_<file>.o to <file>.o and
+# o compile a .tmp_<file>.s from <file>.c
+# o if .tmp_<file>.s doesn't contain a __ksymtab version, i.e. does
+#   not export symbols, we just assemble .tmp_<file>.s to <file>.o and
 #   are done.
 # o otherwise, we calculate symbol versions using the good old
 #   genksyms on the preprocessed source and postprocess them in a way
-#   that they are usable as a linker script
-# o generate <file>.o from .tmp_<file>.o using the linker to
-#   replace the unresolved symbols __crc_exported_symbol with
-#   the actual value of the checksum generated by genksyms
+#   that they are usable as assembly source
+# o assemble <file>.o from .tmp_<file>.s forcing inclusion of directives
+#   defining the actual values of __crc_*, followed by objcopy-ing them
+#   to force these symbols to be local to permit stripping them later.
+s_file = $(@D)/.tmp_$(@F:.o=.s)
+v_file = $(@D)/.tmp_$(@F:.o=.v)
+tmp_o_file = $(@D)/.tmp_$(@F)
+no_g_c_flags = $(filter-out -g%,$(c_flags))
+
+cmd_cc_o_c = $(CC) $(c_flags) -S -o $(s_file) $<
 
-cmd_cc_o_c = $(CC) $(c_flags) -c -o $(@D)/.tmp_$(@F) $<
 cmd_modversions =							\
-	if $(OBJDUMP) -h $(@D)/.tmp_$(@F) | grep -q __ksymtab; then	\
-		$(call cmd_gensymtypes, $(KBUILD_SYMTYPES))		\
-		    > $(@D)/.tmp_$(@F:.o=.ver);				\
-									\
-		$(LD) $(LDFLAGS) -r -o $@ $(@D)/.tmp_$(@F) 		\
-			-T $(@D)/.tmp_$(@F:.o=.ver);			\
-		rm -f $(@D)/.tmp_$(@F) $(@D)/.tmp_$(@F:.o=.ver);	\
+	if grep -q __ksymtab $(s_file); then				\
+		if $(call cmd_genksyms, $(KBUILD_SYMTYPES)) > $(v_file) \
+		   && $(CC) $(no_g_c_flags) -c -Wa,$(v_file)		\
+			    -o $(tmp_o_file) $(s_file)			\
+		   && $(OBJCOPY) -L '__crc_*' -L '___crc_*' -w		\
+				 $(tmp_o_file) $@;			\
+		then							\
+			: ;						\
+		else							\
+			rm -f $@; exit 1;				\
+		fi;							\
 	else								\
-		mv -f $(@D)/.tmp_$(@F) $@;				\
+		rm -f $(v_file);					\
+		$(CC) $(no_g_c_flags) -c -o $@ $(s_file);		\
 	fi;
 endif
 
@@ -221,7 +231,12 @@ define rule_cc_o_c
 	$(cmd_record_mcount)						  \
 	scripts/basic/fixdep $(depfile) $@ '$(call make-cmd,cc_o_c)' >    \
 	                                              $(dot-target).tmp;  \
-	rm -f $(depfile);						  \
+	if [ -r $(@D)/.tmp_$(@F:.o=.v) ]; then				  \
+		echo >> $(dot-target).tmp;				  \
+		echo '$@: $(GENKSYMS)' >> $(dot-target).tmp;		  \
+		echo '$(GENKSYMS):: ;' >> $(dot-target).tmp;		  \
+	fi;								  \
+	rm -f $(depfile) $(@D)/.tmp_$(@F:.o=.?);			  \
 	mv -f $(dot-target).tmp $(dot-target).cmd
 endef
 
diff --git a/scripts/Makefile.modinst b/scripts/Makefile.modinst
index efa5d94..a5122dc 100644
--- a/scripts/Makefile.modinst
+++ b/scripts/Makefile.modinst
@@ -17,7 +17,8 @@ __modinst: $(modules)
 	@:
 
 quiet_cmd_modules_install = INSTALL $@
-      cmd_modules_install = mkdir -p $(2); cp $@ $(2) ; $(mod_strip_cmd) $(2)/$(notdir $@)
+      cmd_modules_install = mkdir -p $(2); \
+			    $(mod_strip_cmd) $@ $(2)/$(notdir $@) || cp $@ $(2)
 
 # Modules built outside the kernel source tree go into extra by default
 INSTALL_MOD_DIR ?= extra
diff --git a/scripts/genksyms/genksyms.c b/scripts/genksyms/genksyms.c
index 3a8297b..f8bb4ca 100644
--- a/scripts/genksyms/genksyms.c
+++ b/scripts/genksyms/genksyms.c
@@ -43,7 +43,7 @@ int cur_line = 1;
 char *cur_filename;
 
 static int flag_debug, flag_dump_defs, flag_reference, flag_dump_types,
-	   flag_preserve, flag_warnings;
+	   flag_preserve, flag_warnings, flag_asm;
 static const char *arch = "";
 static const char *mod_prefix = "";
 
@@ -610,8 +610,11 @@ void export_symbol(const char *name)
 		if (flag_dump_defs)
 			fputs(">\n", debugfile);
 
-		/* Used as a linker script. */
-		printf("%s__crc_%s = 0x%08lx ;\n", mod_prefix, name, crc);
+		/* Used as assembly source or a linker script. */
+		printf(flag_asm
+		       ? ".equiv %s__crc_%s, %#08lx\n"
+		       : "%s__crc_%s = %#08lx ;\n",
+		       mod_prefix, name, crc);
 	}
 }
 
@@ -648,9 +651,10 @@ void error_with_pos(const char *fmt, ...)
 
 static void genksyms_usage(void)
 {
-	fputs("Usage:\n" "genksyms [-adDTwqhV] > /path/to/.tmp_obj.ver\n" "\n"
+	fputs("Usage:\n" "genksyms [-aAdDTwqhV] > /path/to/.tmp_obj.ver\n" "\n"
 #ifdef __GNU_LIBRARY__
 	      "  -a, --arch            Select architecture\n"
+	      "  -A, --asm             Generate assembly rather than linker script\n"
 	      "  -d, --debug           Increment the debug level (repeatable)\n"
 	      "  -D, --dump            Dump expanded symbol defs (for debugging only)\n"
 	      "  -r, --reference file  Read reference symbols from a file\n"
@@ -662,6 +666,7 @@ static void genksyms_usage(void)
 	      "  -V, --version         Print the release version\n"
 #else				/* __GNU_LIBRARY__ */
 	      "  -a                    Select architecture\n"
+	      "  -A                    Generate assembly rather than linker script\n"
 	      "  -d                    Increment the debug level (repeatable)\n"
 	      "  -D                    Dump expanded symbol defs (for debugging only)\n"
 	      "  -r file               Read reference symbols from a file\n"
@@ -683,6 +688,7 @@ int main(int argc, char **argv)
 #ifdef __GNU_LIBRARY__
 	struct option long_opts[] = {
 		{"arch", 1, 0, 'a'},
+		{"asm", 0, 0, 'A'},
 		{"debug", 0, 0, 'd'},
 		{"warnings", 0, 0, 'w'},
 		{"quiet", 0, 0, 'q'},
@@ -695,10 +701,10 @@ int main(int argc, char **argv)
 		{0, 0, 0, 0}
 	};
 
-	while ((o = getopt_long(argc, argv, "a:dwqVDr:T:ph",
+	while ((o = getopt_long(argc, argv, "a:dwqVADr:T:ph",
 				&long_opts[0], NULL)) != EOF)
 #else				/* __GNU_LIBRARY__ */
-	while ((o = getopt(argc, argv, "a:dwqVDr:T:ph")) != EOF)
+	while ((o = getopt(argc, argv, "a:dwqVADr:T:ph")) != EOF)
 #endif				/* __GNU_LIBRARY__ */
 		switch (o) {
 		case 'a':
@@ -716,6 +722,9 @@ int main(int argc, char **argv)
 		case 'V':
 			fputs("genksyms version 2.5.60\n", stderr);
 			break;
+		case 'A':
+			flag_asm = 1;
+			break;
 		case 'D':
 			flag_dump_defs = 1;
 			break;
diff --git a/scripts/mksysmap b/scripts/mksysmap
index 6e133a0..1db316a 100644
--- a/scripts/mksysmap
+++ b/scripts/mksysmap
@@ -37,9 +37,6 @@
 
 # readprofile starts reading symbols when _stext is found, and
 # continue until it finds a symbol which is not either of 'T', 't',
-# 'W' or 'w'. __crc_ are 'A' and placed in the middle
-# so we just ignore them to let readprofile continue to work.
-# (At least sparc64 has __crc_ in the middle).
-
-$NM -n $1 | grep -v '\( [aNUw] \)\|\(__crc_\)\|\( \$[adt]\)' > $2
+# 'W' or 'w'.
 
+$NM -n $1 | grep -v '\( [aNUw] \)\|\( \$[adt]\)' > $2
diff --git a/scripts/strip-symbols b/scripts/strip-symbols
new file mode 100644
index 0000000..29ee8c1
--- /dev/null
+++ b/scripts/strip-symbols
@@ -0,0 +1,22 @@
+<*>
+*.h
+__compound_literal[$.][0-9]*
+__crc_[a-zA-Z_]*
+__exitcall_[a-zA-Z_]*
+__func__[$.][0-9]*
+__FUNCTION__[$.][0-9]*
+gcc[0-9]_compiled[$.]
+__initcall_[a-zA-Z_]*
+__kcrctab_[a-zA-Z_]*
+__kstrtab_[a-zA-Z_]*
+__ksymtab_[a-zA-Z_]*
+__mod_[a-zA-Z_]*[0-9]
+__module_depends
+__param_[a-zA-Z_]*
+__pci_fixup_*PCI_ANY_IDPCI_ANY_ID*
+__pci_fixup_*PCI_ANY_IDPCI_DEVICE_ID_*
+__pci_fixup_*PCI_VENDOR_ID_*PCI_ANY_ID*
+__pci_fixup_*PCI_VENDOR_ID_*PCI_DEVICE_ID_*
+__PRETTY_FUNCTION__[$.][0-9]*
+__setup_[a-zA-Z_]*
+____versions
-- 
1.6.0.2.GIT

