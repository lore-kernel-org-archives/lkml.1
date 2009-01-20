Return-Path: <linux-kernel-owner+w=401wt.eu-S1760357AbZATKbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760357AbZATKbU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 05:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756068AbZATKbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 05:31:06 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:35977 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919AbZATKbF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 05:31:05 -0500
Message-Id: <4975B60F.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 20 Jan 2009 10:31:27 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: [PATCH] Re: [Bug #12416] Recent change to kernel spikes out
	 ccache/distcc
References: <0GOi9pntEoL.A.iGF.B9QdJB@chimera>
 <2QN7KFic7LG.A.cl.C-QdJB@chimera>
In-Reply-To: <2QN7KFic7LG.A.cl.C-QdJB@chimera>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To address the various issues raised on the stripping patches, this
patch
- adds a config option to control whether __crc_* symbols should be
  stripped from modules (and restores filtering out __crc_* in
  mksysmap)
- adds a fallback if the advanced module stripping fails during module
  installation
- disallows KALLSYMS_STRIP_GENERATED for 32-bit Sparc

Parts based on a draft patch from Sam Ravnborg.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Rafael J. Wysocki <rjw@sisk.pl>

---
 Makefile                 |    4 +++-
 init/Kconfig             |   12 ++++++++++++
 scripts/Makefile.build   |   20 +++++++++++++++++---
 scripts/Makefile.modinst |    3 ++-
 scripts/mksysmap         |    6 ++++--
 5 files changed, 38 insertions(+), 7 deletions(-)

--- linux-2.6.29-rc2/Makefile	2009-01-20 10:30:08.000000000 +0100
+++ 2.6.29-rc2-strip-conditional/Makefile	2009-01-07 15:35:07.000000000 +0100
@@ -620,13 +620,15 @@ mod_strip_cmd = $(OBJCOPY) --strip-debug
 ifeq ($(CONFIG_KALLSYMS_ALL),$(CONFIG_KALLSYMS_STRIP_GENERATED))
 mod_strip_cmd += --wildcard $(addprefix --strip-symbols ,$(strip-symbols))
 endif
+mod_strip_cmd2 = $(OBJCOPY) --strip-debug
 else
 mod_strip_cmd = $(OBJCOPY) $(INSTALL_MOD_STRIP)
 endif # INSTALL_MOD_STRIP=1
 else
 mod_strip_cmd = false
 endif # INSTALL_MOD_STRIP
-export mod_strip_cmd
+mod_strip_cmd2 ?= false
+export mod_strip_cmd mod_strip_cmd2
 
 
 ifeq ($(KBUILD_EXTMOD),)
--- linux-2.6.29-rc2/init/Kconfig	2009-01-20 10:30:37.000000000 +0100
+++ 2.6.29-rc2-strip-conditional/init/Kconfig	2009-01-08 09:34:39.000000000 +0100
@@ -628,6 +628,8 @@ config KALLSYMS_ALL
 config KALLSYMS_STRIP_GENERATED
 	bool "Strip machine generated symbols from kallsyms"
 	depends on KALLSYMS_ALL
+	# This doesn't work with -r in LDFLAGS_vmlinux.
+	depends on !SPARC || SPARC64
 	default y
 	help
 	  Say N if you want kallsyms to retain even machine generated symbols.
@@ -938,6 +940,16 @@ config MODVERSIONS
 	  make them incompatible with the kernel you are running.  If
 	  unsure, say N.
 
+config KBUILD_STRIP_CRC
+	bool "Strip __crc_* symbols from modules"
+	depends on MODVERSIONS
+	help
+	  Since they are useless to keep post compilation, this allows to
+	  strip these symbols. However, binutils don't offer a simple way
+	  to get rid of them, so the .c->.o compilation step gets broken up
+	  when selecting this option, which is known to have an adverse
+	  effect on compilation caching/distribution systems (ccache/distcc).
+
 config MODULE_SRCVERSION_ALL
 	bool "Source checksum for all modules"
 	help
--- linux-2.6.29-rc2/scripts/Makefile.build	2009-01-20 10:30:44.000000000 +0100
+++ 2.6.29-rc2-strip-conditional/scripts/Makefile.build	2009-01-08 10:03:27.000000000 +0100
@@ -153,7 +153,7 @@ $(obj)/%.i: $(src)/%.c FORCE
 
 cmd_genksyms =                                                              \
     $(CPP) -D__GENKSYMS__ $(c_flags) $< |                                   \
-    $(GENKSYMS) -T $@ -A -a $(ARCH)                                         \
+    $(GENKSYMS) -T $@ $(if $(CONFIG_KBUILD_STRIP_CRC), -A) -a $(ARCH)       \
      $(if $(KBUILD_PRESERVE),-p)                                            \
      $(if $(1),-r $(firstword $(wildcard $(@:.symtypes=.symref) /dev/null)))
 
@@ -187,11 +187,12 @@ else
 # o assemble <file>.o from .tmp_<file>.s forcing inclusion of directives
 #   defining the actual values of __crc_*, followed by objcopy-ing them
 #   to force these symbols to be local to permit stripping them later.
-s_file = $(@D)/.tmp_$(@F:.o=.s)
 v_file = $(@D)/.tmp_$(@F:.o=.v)
 tmp_o_file = $(@D)/.tmp_$(@F)
 no_g_c_flags = $(filter-out -g%,$(c_flags))
 
+ifneq ($(CONFIG_KBUILD_STRIP_CRC),)
+s_file = $(@D)/.tmp_$(@F:.o=.s)
 cmd_cc_o_c = $(CC) $(c_flags) -S -o $(s_file) $<
 
 cmd_modversions =							\
@@ -210,6 +211,19 @@ cmd_modversions =							\
 		rm -f $(v_file);					\
 		$(CC) $(no_g_c_flags) -c -o $@ $(s_file);		\
 	fi;
+else
+cmd_cc_o_c = $(CC) $(c_flags) -c -o $(tmp_o_file) $<
+
+cmd_modversions =							\
+	if $(OBJDUMP) -h $(tmp_o_file) | grep -q __ksymtab; then	\
+		$(cmd_genksyms) > $(v_file);				\
+		$(LD) $(LDFLAGS) -r -o $@ $(tmp_o_file)	-T $(v_file);	\
+	else								\
+		rm -f $(v_file);					\
+		mv $(tmp_o_file) $@;					\
+	fi;
+
+endif
 endif
 
 ifdef CONFIG_FTRACE_MCOUNT_RECORD
@@ -225,7 +239,7 @@ define rule_cc_o_c
 	$(cmd_record_mcount)						  \
 	scripts/basic/fixdep $(depfile) $@ '$(call make-cmd,cc_o_c)' >    \
 	                                              $(dot-target).tmp;  \
-	if [ -r $(@D)/.tmp_$(@F:.o=.v) ]; then				  \
+	if [ -r $(v_file) ]; then					  \
 		echo >> $(dot-target).tmp;				  \
 		echo '$@: $(GENKSYMS)' >> $(dot-target).tmp;		  \
 		echo '$(GENKSYMS):: ;' >> $(dot-target).tmp;		  \
--- linux-2.6.29-rc2/scripts/Makefile.modinst	2009-01-20 10:30:44.000000000 +0100
+++ 2.6.29-rc2-strip-conditional/scripts/Makefile.modinst	2009-01-07 15:32:23.000000000 +0100
@@ -18,7 +18,8 @@ __modinst: $(modules)
 
 quiet_cmd_modules_install = INSTALL $@
       cmd_modules_install = mkdir -p $(2); \
-			    $(mod_strip_cmd) $@ $(2)/$(notdir $@) || cp $@ $(2)
+			    $(mod_strip_cmd) $@ $(2)/$(notdir $@) || \
+			    $(mod_strip_cmd2) $@ $(2)/$(notdir $@) || cp $@ $(2)
 
 # Modules built outside the kernel source tree go into extra by default
 INSTALL_MOD_DIR ?= extra
--- linux-2.6.29-rc2/scripts/mksysmap	2009-01-20 10:30:44.000000000 +0100
+++ 2.6.29-rc2-strip-conditional/scripts/mksysmap	2009-01-20 00:00:00.000000000 +0100
@@ -37,6 +37,8 @@
 
 # readprofile starts reading symbols when _stext is found, and
 # continue until it finds a symbol which is not either of 'T', 't',
-# 'W' or 'w'.
+# 'W' or 'w'. __crc_ are 'A' and placed in the middle
+# so we just ignore them to let readprofile continue to work.
+# (At least sparc64 has __crc_ in the middle).
 
-$NM -n $1 | grep -v '\( [aNUw] \)\|\( \$[adt]\)' > $2
+$NM -n $1 | grep -v '\( [aNUw] \)\|\(__crc_\)\|\( \$[adt]\)' > $2


