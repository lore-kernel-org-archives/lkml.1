Return-Path: <linux-kernel-owner+w=401wt.eu-S936790AbXJSUm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936790AbXJSUm5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 16:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933332AbXJSUmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 16:42:45 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:59728 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761005AbXJSUmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 16:42:42 -0400
Date: Fri, 19 Oct 2007 22:44:15 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GI:wqT PULL] kbuild updates - second round
Message-ID: <20071019204415.GA623@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Following are the accumulated kbuild updates.
A mixture of new stuff and fixes.

The cc-cross-prefix is new and developed on request from Geert Uytterhoeven.
With cc-cross-prefix it is now much easier to have a few default
cross compile prefixes and defaulting to none - if none of them were present.
ARCH maintainers are expected to pick up this feature soon.

The other noteworthy change is the move of the mailing list for kbuild/kconfig.
Subscribe to the new list like this:
Send a mail to majordomo@vger.kernel.org
Subject: whatever
subscribe linux-kbuild

Then you will receive a confirmation mail and when you have answered
that mail you are subscribed to the new unmoderated list.

Please pull from:
	git://git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild.git

Full diff below - because it is so little. See individual patches in the git tree.

	Sam


 Documentation/kbuild/kconfig-language.txt |   14 ++++++++-
 Documentation/kbuild/makefiles.txt        |   22 ++++++++++++++
 MAINTAINERS                               |    3 +-
 Makefile                                  |   45 +++++++++++++----------------
 scripts/Kbuild.include                    |   11 +++++++
 scripts/basic/docproc.c                   |   11 ++++++-
 scripts/kconfig/Makefile                  |    2 +-
 scripts/mod/modpost.c                     |    3 ++
 scripts/package/builddeb                  |    2 +
 9 files changed, 83 insertions(+), 30 deletions(-)

Randy Dunlap (1):
      kconfig: update kconfig-language text

Rob Landley (2):
      kbuild: stop docproc segfaulting when SRCTREE isn't set.
      kconfig: comment typo in scripts/kconfig/Makefile.

Sam Ravnborg (4):
      kbuild: mailing list has moved
      kbuild: disable depmod in cross-compile kernel build
      kbuild: introduce cc-cross-prefix
      kbuild: fix first module build

Trent Piepho (1):
      kbuild: modpost problem when symbols move from one module to another

Yinghai Lu (1):
      kbuild: cscope - filter out .tmp_* in find_sources

bugme-daemon@bugzilla.kernel.org (1):
      kbuild: make deb-pkg - add 'Provides:' line

diff --git a/Documentation/kbuild/kconfig-language.txt b/Documentation/kbuild/kconfig-language.txt
index fe8b0c4..616043a 100644
--- a/Documentation/kbuild/kconfig-language.txt
+++ b/Documentation/kbuild/kconfig-language.txt
@@ -77,7 +77,12 @@ applicable everywhere (see syntax).
   Optionally, dependencies only for this default value can be added with
   "if".
 
-- dependencies: "depends on"/"requires" <expr>
+- type definition + default value:
+	"def_bool"/"def_tristate" <expr> ["if" <expr>]
+  This is a shorthand notation for a type definition plus a value.
+  Optionally dependencies for this default value can be added with "if".
+
+- dependencies: "depends on" <expr>
   This defines a dependency for this menu entry. If multiple
   dependencies are defined, they are connected with '&&'. Dependencies
   are applied to all other options within this menu entry (which also
@@ -289,3 +294,10 @@ source:
 	"source" <prompt>
 
 This reads the specified configuration file. This file is always parsed.
+
+mainmenu:
+
+	"mainmenu" <prompt>
+
+This sets the config program's title bar if the config program chooses
+to use it.
diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
index f099b81..6166e2d 100644
--- a/Documentation/kbuild/makefiles.txt
+++ b/Documentation/kbuild/makefiles.txt
@@ -518,6 +518,28 @@ more details, with real examples.
 	In this example for a specific GCC version the build will error out explaining
 	to the user why it stops.
 
+    cc-cross-prefix
+	cc-cross-prefix is used to check if there exist a $(CC) in path with
+	one of the listed prefixes. The first prefix where there exist a
+	prefix$(CC) in the PATH is returned - and if no prefix$(CC) is found
+	then nothing is returned.
+	Additional prefixes are separated by a single space in the
+	call of cc-cross-prefix.
+	This functionality is usefull for architecture Makefile that try
+	to set CROSS_COMPILE to well know values but may have several
+	values to select between.
+	It is recommended only to try to set CROSS_COMPILE is it is a cross
+	build (host arch is different from target arch). And is CROSS_COMPILE
+	is already set then leave it with the old value.
+
+	Example:
+		#arch/m68k/Makefile
+		ifneq ($(SUBARCH),$(ARCH))
+		        ifeq ($(CROSS_COMPILE),)
+		               CROSS_COMPILE := $(call cc-cross-prefix, m68k-linux-gnu-)
+			endif
+		endif
+
 === 4 Host Program support
 
 Kbuild supports building executables on the host for use during the
diff --git a/MAINTAINERS b/MAINTAINERS
index 10deabe..f978c60 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2178,7 +2178,7 @@ S:	Maintained
 KCONFIG
 P:	Roman Zippel
 M:	zippel@linux-m68k.org
-L:	kbuild-devel@lists.sourceforge.net
+L:	linux-kbuild@vger.kernel.org
 S:	Maintained
 
 KDUMP
@@ -2207,6 +2207,7 @@ KERNEL BUILD (kbuild: Makefile, scripts/Makefile.*)
 P:	Sam Ravnborg
 M:	sam@ravnborg.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/sam/kbuild.git
+L:	linux-kbuild@vger.kernel.org
 S:	Maintained
 
 KERNEL JANITORS
diff --git a/Makefile b/Makefile
index feca34c..6d7527c 100644
--- a/Makefile
+++ b/Makefile
@@ -884,10 +884,7 @@ prepare2: prepare3 outputmakefile
 
 prepare1: prepare2 include/linux/version.h include/linux/utsrelease.h \
                    include/asm include/config/auto.conf
-ifneq ($(KBUILD_MODULES),)
-	$(Q)mkdir -p $(MODVERDIR)
-	$(Q)rm -f $(MODVERDIR)/*
-endif
+	$(cmd_crmodverdir)
 
 archprepare: prepare1 scripts_basic
 
@@ -1030,19 +1027,12 @@ _modinst_:
 	fi
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modinst
 
-# If System.map exists, run depmod.  This deliberately does not have a
-# dependency on System.map since that would run the dependency tree on
-# vmlinux.  This depmod is only for convenience to give the initial
+# This depmod is only for convenience to give the initial
 # boot a modules.dep even before / is mounted read-write.  However the
 # boot script depmod is the master version.
-ifeq "$(strip $(INSTALL_MOD_PATH))" ""
-depmod_opts	:=
-else
-depmod_opts	:= -b $(INSTALL_MOD_PATH) -r
-endif
 PHONY += _modinst_post
 _modinst_post: _modinst_
-	if [ -r System.map -a -x $(DEPMOD) ]; then $(DEPMOD) -ae -F System.map $(depmod_opts) $(KERNELRELEASE); fi
+	$(call cmd,depmod)
 
 else # CONFIG_MODULES
 
@@ -1230,8 +1220,7 @@ else # KBUILD_EXTMOD
 KBUILD_MODULES := 1
 PHONY += crmodverdir
 crmodverdir:
-	$(Q)mkdir -p $(MODVERDIR)
-	$(Q)rm -f $(MODVERDIR)/*
+	$(cmd_crmodverdir)
 
 PHONY += $(objtree)/Module.symvers
 $(objtree)/Module.symvers:
@@ -1259,15 +1248,6 @@ _emodinst_:
 	$(Q)mkdir -p $(MODLIB)/$(install-dir)
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modinst
 
-# Run depmod only is we have System.map and depmod is executable
-quiet_cmd_depmod = DEPMOD  $(KERNELRELEASE)
-      cmd_depmod = if [ -r System.map -a -x $(DEPMOD) ]; then \
-                      $(DEPMOD) -ae -F System.map             \
-                      $(if $(strip $(INSTALL_MOD_PATH)),      \
-		      -b $(INSTALL_MOD_PATH) -r)              \
-		      $(KERNELRELEASE);                       \
-                   fi
-
 PHONY += _emodinst_post
 _emodinst_post: _emodinst_
 	$(call cmd,depmod)
@@ -1351,7 +1331,7 @@ define find-sources
 	  find $(__srctree)include/asm-generic $(RCS_FIND_IGNORE) \
 	       -name $1 -print; \
 	  find $(__srctree) $(RCS_FIND_IGNORE) \
-	       \( -name include -o -name arch \) -prune -o \
+	       \( -name include -o -name arch -o -name '.tmp_*' \) -prune -o \
 	       -name $1 -print; \
 	  )
 endef
@@ -1500,9 +1480,11 @@ endif
 
 # Modules
 / %/: prepare scripts FORCE
+	$(cmd_crmodverdir)
 	$(Q)$(MAKE) KBUILD_MODULES=$(if $(CONFIG_MODULES),1) \
 	$(build)=$(build-dir)
 %.ko: prepare scripts FORCE
+	$(cmd_crmodverdir)
 	$(Q)$(MAKE) KBUILD_MODULES=$(if $(CONFIG_MODULES),1)   \
 	$(build)=$(build-dir) $(@:.ko=.o)
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost
@@ -1516,6 +1498,19 @@ quiet_cmd_rmdirs = $(if $(wildcard $(rm-dirs)),CLEAN   $(wildcard $(rm-dirs)))
 quiet_cmd_rmfiles = $(if $(wildcard $(rm-files)),CLEAN   $(wildcard $(rm-files)))
       cmd_rmfiles = rm -f $(rm-files)
 
+# Run depmod only is we have System.map and depmod is executable
+# and we build for the host arch
+quiet_cmd_depmod = DEPMOD  $(KERNELRELEASE)
+      cmd_depmod = \
+	if [ -r System.map -a -x $(DEPMOD) -a "$(SUBARCH)" == "$(ARCH)" ]; then \
+		$(DEPMOD) -ae -F System.map                                     \
+		$(if $(strip $(INSTALL_MOD_PATH)), -b $(INSTALL_MOD_PATH) -r)   \
+		$(KERNELRELEASE);                                               \
+	fi
+
+# Create temporary dir for module support files
+cmd_crmodverdir = $(Q)mkdir -p $(MODVERDIR); rm -f $(MODVERDIR)/*
+
 
 a_flags = -Wp,-MD,$(depfile) $(KBUILD_AFLAGS) $(AFLAGS_KERNEL) \
 	  $(NOSTDINC_FLAGS) $(KBUILD_CPPFLAGS) \
diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index de7bb28..b96ea8d 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -56,6 +56,17 @@ endef
 # gcc support functions
 # See documentation in Documentation/kbuild/makefiles.txt
 
+# cc-cross-prefix
+# Usage: CROSS_COMPILE := $(call cc-cross-prefix, m68k-linux-gnu- m68k-linux-)
+# Return first prefix where a prefix$(CC) is found in PATH.
+# If no $(CC) found in PATH with listed prefixes return nothing
+cc-cross-prefix =  \
+	$(word 1, $(foreach c,$(1),                                   \
+		$(shell set -e;                                       \
+		if (which $(strip $(c))$(CC)) > /dev/null 2>&1 ; then \
+			echo $(c);                                    \
+		fi)))
+
 # output directory for tests below
 TMPOUT := $(if $(KBUILD_EXTMOD),$(firstword $(KBUILD_EXTMOD))/)
 
diff --git a/scripts/basic/docproc.c b/scripts/basic/docproc.c
index e5c6ac7..0e4bd54 100644
--- a/scripts/basic/docproc.c
+++ b/scripts/basic/docproc.c
@@ -66,12 +66,15 @@ FILELINE * entity_system;
 #define FUNCTION      "-function"
 #define NOFUNCTION    "-nofunction"
 
+char *srctree;
+
 void usage (void)
 {
 	fprintf(stderr, "Usage: docproc {doc|depend} file\n");
 	fprintf(stderr, "Input is read from file.tmpl. Output is sent to stdout\n");
 	fprintf(stderr, "doc: frontend when generating kernel documentation\n");
 	fprintf(stderr, "depend: generate list of files referenced within file\n");
+	fprintf(stderr, "Environment variable SRCTREE: absolute path to kernel source tree.\n");
 }
 
 /*
@@ -90,7 +93,7 @@ void exec_kernel_doc(char **svec)
 			exit(1);
 		case  0:
 			memset(real_filename, 0, sizeof(real_filename));
-			strncat(real_filename, getenv("SRCTREE"), PATH_MAX);
+			strncat(real_filename, srctree, PATH_MAX);
 			strncat(real_filename, KERNELDOCPATH KERNELDOC,
 					PATH_MAX - strlen(real_filename));
 			execvp(real_filename, svec);
@@ -171,7 +174,7 @@ void find_export_symbols(char * filename)
 	if (filename_exist(filename) == NULL) {
 		char real_filename[PATH_MAX + 1];
 		memset(real_filename, 0, sizeof(real_filename));
-		strncat(real_filename, getenv("SRCTREE"), PATH_MAX);
+		strncat(real_filename, srctree, PATH_MAX);
 		strncat(real_filename, filename,
 				PATH_MAX - strlen(real_filename));
 		sym = add_new_file(filename);
@@ -338,6 +341,10 @@ void parse_file(FILE *infile)
 int main(int argc, char *argv[])
 {
 	FILE * infile;
+
+	srctree = getenv("SRCTREE");
+	if (!srctree)
+		srctree = getcwd(NULL, 0);
 	if (argc != 3) {
 		usage();
 		exit(1);
diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index bb08069..83c5e76 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -84,7 +84,7 @@ help:
 # lxdialog stuff
 check-lxdialog  := $(srctree)/$(src)/lxdialog/check-lxdialog.sh
 
-# Use reursively expanded variables so we do not call gcc unless
+# Use recursively expanded variables so we do not call gcc unless
 # we really need to do so. (Do not call gcc as part of make mrproper)
 HOST_EXTRACFLAGS = $(shell $(CONFIG_SHELL) $(check-lxdialog) -ccflags)
 HOST_LOADLIBES   = $(shell $(CONFIG_SHELL) $(check-lxdialog) -ldflags $(HOSTCC))
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 2ef9a19..93ac52a 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -268,6 +268,9 @@ static struct symbol *sym_add_exported(const char *name, struct module *mod,
 			     "was in %s%s\n", mod->name, name,
 			     s->module->name,
 			     is_vmlinux(s->module->name) ?"":".ko");
+		} else {
+			/* In case Modules.symvers was out of date */
+			s->module = mod;
 		}
 	}
 	s->preloaded = 0;
diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 6edb29f..0f657b5 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -83,6 +83,7 @@ Maintainer: $name
 Standards-Version: 3.6.1
 
 Package: $packagename
+Provides: kernel-image-$version, linux-image-$version
 Architecture: any
 Description: User Mode Linux kernel, version $version
  User-mode Linux is a port of the Linux kernel to its own system call
@@ -104,6 +105,7 @@ Maintainer: $name
 Standards-Version: 3.6.1
 
 Package: $packagename
+Provides: kernel-image-$version, linux-image-$version
 Architecture: any
 Description: Linux kernel, version $version
  This package contains the Linux kernel, modules and corresponding other
