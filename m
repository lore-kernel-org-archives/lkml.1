Return-Path: <linux-kernel-owner+w=401wt.eu-S933521AbYDYTJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933521AbYDYTJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 15:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933247AbYDYSzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 14:55:41 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:56616 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933345AbYDYSze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 14:55:34 -0400
Date: Fri, 25 Apr 2008 20:56:05 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] kbuild patches for merge window
Message-ID: <20080425185605.GA10902@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

Please apply the following kbuild patches.
A few have had some exposure in -mm / -next
but most has been sitting in my inbox for
too long time.
All are trivial and full patch attached.

Pull from:

   master.kernel.org/pub/scm/linux/kernel/git/sam/kbuild.git

	Sam


Alexey Dobriyan (1):
      kbuild: add kconfig symbols to tags output

Andi Kleen (1):
      Add option to enable -Wframe-larger-than= on gcc 4.4

Richard Hacker (2):
      kbuild: support loading extra symbols in modpost
      kbuild: Add new Kbuild variable KBUILD_EXTRA_SYMBOLS

Robert P. J. Day (1):
      kbuild: fix some minor typoes

Sam Ravnborg (1):
      kbuild: error out on missing MODULE_LICENSE

Uwe Kleine-König (1):
      kbuild: fix depmod comment

 Documentation/kbuild/modules.txt |    9 ++++++++-
 Makefile                         |    9 ++++++---
 lib/Kconfig.debug                |   11 +++++++++++
 scripts/Makefile.build           |    6 +++---
 scripts/Makefile.clean           |    2 +-
 scripts/Makefile.host            |   12 ++++++------
 scripts/Makefile.modpost         |    8 ++++++++
 scripts/mod/modpost.c            |   27 ++++++++++++++++++++++++++-
 8 files changed, 69 insertions(+), 15 deletions(-)


diff --git a/Documentation/kbuild/modules.txt b/Documentation/kbuild/modules.txt
index 1d247d5..1821c07 100644
--- a/Documentation/kbuild/modules.txt
+++ b/Documentation/kbuild/modules.txt
@@ -486,7 +486,7 @@ Module.symvers contains a list of all exported symbols from a kernel build.
 	Sometimes, an external module uses exported symbols from another
 	external module. Kbuild needs to have full knowledge on all symbols
 	to avoid spitting out warnings about undefined symbols.
-	Two solutions exist to let kbuild know all symbols of more than
+	Three solutions exist to let kbuild know all symbols of more than
 	one external module.
 	The method with a top-level kbuild file is recommended but may be
 	impractical in certain situations.
@@ -523,6 +523,13 @@ Module.symvers contains a list of all exported symbols from a kernel build.
 		containing the sum of all symbols defined and not part of the
 		kernel.
 
+	Use make variable KBUILD_EXTRA_SYMBOLS in the Makefile
+		If it is impractical to copy Module.symvers from another
+		module, you can assign a space separated list of files to
+		KBUILD_EXTRA_SYMBOLS in your Makfile. These files will be
+		loaded by modpost during the initialisation of its symbol
+		tables.
+
 === 8. Tips & Tricks
 
 --- 8.1 Testing for CONFIG_FOO_BAR
diff --git a/Makefile b/Makefile
index 3dbc826..fc3411e 100644
--- a/Makefile
+++ b/Makefile
@@ -507,6 +507,10 @@ else
 KBUILD_CFLAGS	+= -O2
 endif
 
+ifneq (CONFIG_FRAME_WARN,0)
+KBUILD_CFLAGS += $(call cc-option,-Wframe-larger-than=${CONFIG_FRAME_WARN})
+endif
+
 # Force gcc to behave correct even for buggy distributions
 # Arch Makefiles may override this setting
 KBUILD_CFLAGS += $(call cc-option, -fno-stack-protector)
@@ -1396,7 +1400,7 @@ define xtags
 	    $(all-kconfigs) | xargs $1 -a \
 		--langdef=kconfig \
 		--language-force=kconfig \
-		--regex-kconfig='/^[[:blank:]]*config[[:blank:]]+([[:alnum:]_]+)/\1/'; \
+		--regex-kconfig='/^[[:blank:]]*(menu|)config[[:blank:]]+([[:alnum:]_]+)/\2/'; \
 	    $(all-defconfigs) | xargs -r $1 -a \
 		--langdef=dotconfig \
 		--language-force=dotconfig \
@@ -1404,7 +1408,7 @@ define xtags
 	elif $1 --version 2>&1 | grep -iq emacs; then \
 	    $(all-sources) | xargs $1 -a; \
 	    $(all-kconfigs) | xargs $1 -a \
-		--regex='/^[ \t]*config[ \t]+\([a-zA-Z0-9_]+\)/\1/'; \
+		--regex='/^[ \t]*(menu|)config[ \t]+\([a-zA-Z0-9_]+\)/\2/'; \
 	    $(all-defconfigs) | xargs -r $1 -a \
 		--regex='/^#?[ \t]?\(CONFIG_[a-zA-Z0-9_]+\)/\1/'; \
 	else \
@@ -1539,7 +1543,6 @@ quiet_cmd_rmfiles = $(if $(wildcard $(rm-files)),CLEAN   $(wildcard $(rm-files))
       cmd_rmfiles = rm -f $(rm-files)
 
 # Run depmod only if we have System.map and depmod is executable
-# and we build for the host arch
 quiet_cmd_depmod = DEPMOD  $(KERNELRELEASE)
       cmd_depmod = \
 	if [ -r System.map -a -x $(DEPMOD) ]; then                              \
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 623ef24..754cc00 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -25,6 +25,17 @@ config ENABLE_MUST_CHECK
 	  suppress the "warning: ignoring return value of 'foo', declared with
 	  attribute warn_unused_result" messages.
 
+config FRAME_WARN
+	int "Warn for stack frames larger than (needs gcc 4.4)"
+	range 0 8192
+	default 1024 if !64BIT
+	default 2048 if 64BIT
+	help
+	  Tell gcc to warn at build time for stack frames larger than this.
+	  Setting this too low will cause a lot of warnings.
+	  Setting it to 0 disables the warning.
+	  Requires gcc 4.4
+
 config MAGIC_SYSRQ
 	bool "Magic SysRq key"
 	depends on !UML
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 67fb453..277cfe0 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -27,12 +27,12 @@ ccflags-y  :=
 cppflags-y :=
 ldflags-y  :=
 
-# Read .config if it exist, otherwise ignore
+# Read auto.conf if it exists, otherwise ignore
 -include include/config/auto.conf
 
 include scripts/Kbuild.include
 
-# For backward compatibility check that these variables does not change
+# For backward compatibility check that these variables do not change
 save-cflags := $(CFLAGS)
 
 # The filename Kbuild has precedence over Makefile
@@ -55,7 +55,7 @@ hostprogs-y += $(host-progs)
 endif
 endif
 
-# Do not include host rules unles needed
+# Do not include host rules unless needed
 ifneq ($(hostprogs-y)$(hostprogs-m),)
 include scripts/Makefile.host
 endif
diff --git a/scripts/Makefile.clean b/scripts/Makefile.clean
index 2c64710..6f89fbb 100644
--- a/scripts/Makefile.clean
+++ b/scripts/Makefile.clean
@@ -37,7 +37,7 @@ subdir-ymn      := $(sort $(subdir-ym) $(subdir-n) $(subdir-))
 
 subdir-ymn	:= $(addprefix $(obj)/,$(subdir-ymn))
 
-# build a list of files to remove, usually releative to the current
+# build a list of files to remove, usually relative to the current
 # directory
 
 __clean-files	:= $(extra-y) $(always)                  \
diff --git a/scripts/Makefile.host b/scripts/Makefile.host
index 6943a7a..1ac414f 100644
--- a/scripts/Makefile.host
+++ b/scripts/Makefile.host
@@ -3,9 +3,9 @@
 # Binaries are used during the compilation of the kernel, for example
 # to preprocess a data file.
 #
-# Both C and C++ is supported, but preferred language is C for such utilities.
+# Both C and C++ are supported, but preferred language is C for such utilities.
 #
-# Samle syntax (see Documentation/kbuild/makefile.txt for reference)
+# Sample syntax (see Documentation/kbuild/makefiles.txt for reference)
 # hostprogs-y := bin2hex
 # Will compile bin2hex.c and create an executable named bin2hex
 #
@@ -23,10 +23,10 @@
 # hostprogs-y := conf
 # conf-objs  := conf.o libkconfig.so
 # libkconfig-objs := expr.o type.o
-# Will create a shared library named libkconfig.so that consist of
-# expr.o and type.o (they are both compiled as C code and the object file
+# Will create a shared library named libkconfig.so that consists of
+# expr.o and type.o (they are both compiled as C code and the object files
 # are made as position independent code).
-# conf.c is compiled as a c program, and conf.o is linked together with
+# conf.c is compiled as a C program, and conf.o is linked together with
 # libkconfig.so as the executable conf.
 # Note: Shared libraries consisting of C++ files are not supported
 
@@ -61,7 +61,7 @@ host-cobjs	:= $(filter-out %.so,$(host-cobjs))
 host-cshobjs	:= $(sort $(foreach m,$(host-cshlib),$($(m:.so=-objs))))
 
 # output directory for programs/.o files
-# hostprogs-y := tools/build may have been specified. Retreive directory
+# hostprogs-y := tools/build may have been specified. Retrieve directory
 host-objdirs := $(foreach f,$(__hostprogs), $(if $(dir $(f)),$(dir $(f))))
 # directory of .o files from prog-objs notation
 host-objdirs += $(foreach f,$(host-cmulti),                  \
diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index 2d20640..24b3c8f 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -42,6 +42,13 @@ _modpost: __modpost
 
 include include/config/auto.conf
 include scripts/Kbuild.include
+
+ifneq ($(KBUILD_EXTMOD),)
+# Include the module's Makefile to find KBUILD_EXTRA_SYMBOLS
+include $(if $(wildcard $(KBUILD_EXTMOD)/Kbuild), \
+             $(KBUILD_EXTMOD)/Kbuild, $(KBUILD_EXTMOD)/Makefile)
+endif
+
 include scripts/Makefile.lib
 
 kernelsymfile := $(objtree)/Module.symvers
@@ -69,6 +76,7 @@ modpost = scripts/mod/modpost                    \
  $(if $(CONFIG_MODULE_SRCVERSION_ALL),-a,)       \
  $(if $(KBUILD_EXTMOD),-i,-o) $(kernelsymfile)   \
  $(if $(KBUILD_EXTMOD),-I $(modulesymfile))      \
+ $(if $(iKBUILD_EXTRA_SYMBOLS), $(patsubst %, -e %,$(EXTRA_SYMBOLS))) \
  $(if $(KBUILD_EXTMOD),-o $(modulesymfile))      \
  $(if $(CONFIG_DEBUG_SECTION_MISMATCH),,-S)      \
  $(if $(CONFIG_MARKERS),-K $(kernelmarkersfile)) \
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 110cf24..f8b42ab 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1552,6 +1552,10 @@ static void read_symbols(char *modname)
 	}
 
 	license = get_modinfo(info.modinfo, info.modinfo_len, "license");
+	if (!license && !is_vmlinux(modname))
+		fatal("modpost: missing MODULE_LICENSE() in %s\n"
+		      "see include/linux/module.h for "
+		      "more information\n", modname);
 	while (license) {
 		if (license_is_gpl_compatible(license))
 			mod->gpl_compatible = 1;
@@ -2015,6 +2019,11 @@ static void write_markers(const char *fname)
 	write_if_changed(&buf, fname);
 }
 
+struct ext_sym_list {
+	struct ext_sym_list *next;
+	const char *file;
+};
+
 int main(int argc, char **argv)
 {
 	struct module *mod;
@@ -2025,8 +2034,10 @@ int main(int argc, char **argv)
 	char *markers_write = NULL;
 	int opt;
 	int err;
+	struct ext_sym_list *extsym_iter;
+	struct ext_sym_list *extsym_start = NULL;
 
-	while ((opt = getopt(argc, argv, "i:I:cmsSo:awM:K:")) != -1) {
+	while ((opt = getopt(argc, argv, "i:I:e:cmsSo:awM:K:")) != -1) {
 		switch (opt) {
 		case 'i':
 			kernel_read = optarg;
@@ -2038,6 +2049,14 @@ int main(int argc, char **argv)
 		case 'c':
 			cross_build = 1;
 			break;
+		case 'e':
+			external_module = 1;
+			extsym_iter =
+			   NOFAIL(malloc(sizeof(*extsym_iter)));
+			extsym_iter->next = extsym_start;
+			extsym_iter->file = optarg;
+			extsym_start = extsym_iter;
+			break;
 		case 'm':
 			modversions = 1;
 			break;
@@ -2071,6 +2090,12 @@ int main(int argc, char **argv)
 		read_dump(kernel_read, 1);
 	if (module_read)
 		read_dump(module_read, 0);
+	while (extsym_start) {
+		read_dump(extsym_start->file, 0);
+		extsym_iter = extsym_start->next;
+		free(extsym_start);
+		extsym_start = extsym_iter;
+	}
 
 	while (optind < argc)
 		read_symbols(argv[optind++]);
