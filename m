Return-Path: <linux-kernel-owner+w=401wt.eu-S1759673AbYFHJrE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759673AbYFHJrE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 05:47:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755473AbYFHJqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 05:46:52 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:48298 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755434AbYFHJqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 05:46:50 -0400
Date: Sun, 8 Jun 2008 11:47:30 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] Speed up "make headers_*"
Message-ID: <20080608094730.GA30098@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is just a heads up patch if anyone is interested.
I finally took the time needed to optimize the
make headers_* targets.

On my box it now takes less than 10 seconds to run
the full install + check cycle.
And it generates roughtly one screen full of output.

Compare that to ~31 seconds and output filling up
my scroll back buffer.

This fixes a long standing complaint from Linus that this is
too simple to warrant such long execution time - yet
there are room for improvements.

Note that this patchset removes support for ALTARCH - only remaining
user is sparc and patches are pending to remove ALTARCH usage form sparc too.

I will do a proper split-up of the patch later and add it
to kbuild-next.git.

Comments (especially to the perl scripts) are welcome.

	Sam

 b/Makefile                     |   41 ++++---
 b/scripts/Makefile.headersinst |  218 ++++++++++++-----------------------------
 b/scripts/headers_check.pl     |   48 +++++++++
 b/scripts/headers_install.pl   |   39 +++++++
 scripts/hdrcheck.sh            |   10 -
 5 files changed, 176 insertions(+), 180 deletions(-)

diff --git a/Makefile b/Makefile
index 8db70fe..8f8fd6f 100644
--- a/Makefile
+++ b/Makefile
@@ -996,36 +996,45 @@ depend dep:
 
 # ---------------------------------------------------------------------------
 # Kernel headers
-INSTALL_HDR_PATH=$(objtree)/usr
-export INSTALL_HDR_PATH
 
-HDRFILTER=generic i386 x86_64
-HDRARCHES=$(filter-out $(HDRFILTER),$(patsubst $(srctree)/include/asm-%/Kbuild,%,$(wildcard $(srctree)/include/asm-*/Kbuild)))
+#Default location for installed headers
+export INSTALL_HDR_PATH = $(objtree)/usr
 
-PHONY += headers_install_all
-headers_install_all: include/linux/version.h scripts_basic FORCE
+hdr-filter := generic um ppc
+hdr-archs  := $(filter-out $(hdr-filter),                           \
+                  $(patsubst $(srctree)/include/asm-%/Kbuild,%,     \
+                      $(wildcard $(srctree)/include/asm-*/Kbuild)))
+hdr-inst := -rR -f $(srctree)/scripts/Makefile.headersinst obj
+
+PHONY += __headers
+__headers: include/linux/version.h scripts_basic FORCE
 	$(Q)$(MAKE) $(build)=scripts scripts/unifdef
-	$(Q)for arch in $(HDRARCHES); do \
-	 $(MAKE) ARCH=$$arch -f $(srctree)/scripts/Makefile.headersinst obj=include BIASMDIR=-bi-$$arch ;\
+
+PHONY += headers_install_all
+headers_install_all: __headers
+	$(Q)set -e; for arch in $(hdr-archs); do \
+	 $(MAKE) ARCH=$$arch SRCARCH=$$arch $(hdr-inst)=include \
+	         BIASMDIR=-bi-$$arch ;\
 	 done
 
 PHONY += headers_install
-headers_install: include/linux/version.h scripts_basic FORCE
-	@if [ ! -r $(srctree)/include/asm-$(SRCARCH)/Kbuild ]; then \
+headers_install: __headers
+	$(Q)if [ ! -r $(srctree)/include/asm-$(SRCARCH)/Kbuild ]; then \
 	  echo '*** Error: Headers not exportable for this architecture ($(SRCARCH))'; \
-	  exit 1 ; fi
-	$(Q)$(MAKE) $(build)=scripts scripts/unifdef
-	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.headersinst ARCH=$(SRCARCH) obj=include
+	  exit 1 ; \
+	fi
+	$(Q)$(MAKE) $(hdr-inst)=include ARCH=$(SRCARCH)
 
 PHONY += headers_check_all
 headers_check_all: headers_install_all
-	$(Q)for arch in $(HDRARCHES); do \
-	 $(MAKE) ARCH=$$arch -f $(srctree)/scripts/Makefile.headersinst obj=include BIASMDIR=-bi-$$arch HDRCHECK=1 ;\
+	$(Q)set -e; for arch in $(hdr-archs); do \
+	 $(MAKE) ARCH=$$arch SRCARCH=$$arch $(hdr-inst)=include \
+	         BIASMDIR=-bi-$$arch HDRCHECK=1 ;\
 	 done
 
 PHONY += headers_check
 headers_check: headers_install
-	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.headersinst ARCH=$(SRCARCH) obj=include HDRCHECK=1
+	$(Q)$(MAKE) $(hdr-inst)=include ARCH=$(SRCARCH) HDRCHECK=1
 
 # ---------------------------------------------------------------------------
 # Modules
diff --git a/scripts/Makefile.headersinst b/scripts/Makefile.headersinst
index 53dae3e..80df6f3 100644
--- a/scripts/Makefile.headersinst
+++ b/scripts/Makefile.headersinst
@@ -7,188 +7,98 @@
 #
 # ==========================================================================
 
-UNIFDEF := scripts/unifdef -U__KERNEL__
-
-# Eliminate the contents of (and inclusions of) compiler.h
-HDRSED  := sed 	-e "s/ inline / __inline__ /g" \
-		-e "s/[[:space:]]__user[[:space:]]\{1,\}/ /g" \
-		-e "s/(__user[[:space:]]\{1,\}/ (/g" \
-		-e "s/[[:space:]]__force[[:space:]]\{1,\}/ /g" \
-		-e "s/(__force[[:space:]]\{1,\}/ (/g" \
-		-e "s/[[:space:]]__iomem[[:space:]]\{1,\}/ /g" \
-		-e "s/(__iomem[[:space:]]\{1,\}/ (/g" \
-		-e "s/[[:space:]]__attribute_const__[[:space:]]\{1,\}/\ /g" \
-		-e "s/[[:space:]]__attribute_const__$$//" \
-		-e "/^\#include <linux\/compiler.h>/d"
-
 _dst := $(if $(dst),$(dst),$(obj))
 
-ifeq (,$(patsubst include/asm/%,,$(obj)/))
-# For producing the generated stuff in include/asm for biarch builds, include
-# both sets of Kbuild files; we'll generate anything which is mentioned in
-# _either_ arch, and recurse into subdirectories which are mentioned in either
-# arch. Since some directories may exist in one but not the other, we must
-# use $(wildcard...). 
-GENASM := 1
-archasm	   := $(subst include/asm,asm-$(ARCH),$(obj))
-altarchasm := $(subst include/asm,asm-$(ALTARCH),$(obj))
-KBUILDFILES := $(wildcard $(srctree)/include/$(archasm)/Kbuild $(srctree)/include/$(altarchasm)/Kbuild)
-else
-KBUILDFILES := $(srctree)/$(obj)/Kbuild
-endif
+kbuild-file := $(srctree)/$(obj)/Kbuild
+include $(kbuild-file)
 
-include $(KBUILDFILES)
+include scripts/Kbuild.include
 
-include scripts/Kbuild.include 
-
-# If this is include/asm-$(ARCH) and there's no $(ALTARCH), then
-# override $(_dst) so that we install to include/asm directly.
+# If this is include/asm-$(ARCH) then override $(_dst) so that
+# we install to include/asm directly.
 # Unless $(BIASMDIR) is set, in which case we're probably doing
 # a 'headers_install_all' build and we should keep the -$(ARCH)
 # in the directory name.
-ifeq ($(obj)$(ALTARCH),include/asm-$(ARCH)$(BIASMDIR))
+ifeq ($(obj),include/asm-$(ARCH)$(BIASMDIR))
      _dst := include/asm
 endif
 
-header-y	:= $(sort $(header-y))
-unifdef-y	:= $(sort $(unifdef-y))
-subdir-y	:= $(patsubst %/,%,$(filter %/, $(header-y)))
-header-y	:= $(filter-out %/, $(header-y))
-header-y	:= $(filter-out $(unifdef-y),$(header-y))
+install      := $(INSTALL_HDR_PATH)/$(_dst)
 
-# stamp files for header checks
-check-y		:= $(patsubst %,.check.%,$(header-y) $(unifdef-y) $(objhdr-y))
+header-y     := $(sort $(header-y) $(unifdef-y))
+subdirs      := $(patsubst %/,%,$(filter %/, $(header-y)))
+header-y     := $(filter-out %/, $(header-y))
 
-# Work out what needs to be removed
-oldheaders	:= $(patsubst $(INSTALL_HDR_PATH)/$(_dst)/%,%,$(wildcard $(INSTALL_HDR_PATH)/$(_dst)/*.h))
-unwanted	:= $(filter-out $(header-y) $(unifdef-y) $(objhdr-y),$(oldheaders))
+# files used to track state of install/check
+install-file := $(install)/.install
+check-file   := $(install)/.check
+check-dep    := $(install)/.check.d
 
-oldcheckstamps	:= $(patsubst $(INSTALL_HDR_PATH)/$(_dst)/%,%,$(wildcard $(INSTALL_HDR_PATH)/$(_dst)/.check.*.h))
-unwanted	+= $(filter-out $(check-y),$(oldcheckstamps))
+# all headers files for this dir
+all-files    := $(header-y) $(objhdr-y)
 
-# Prefix them all with full paths to $(INSTALL_HDR_PATH)
-header-y 	:= $(patsubst %,$(INSTALL_HDR_PATH)/$(_dst)/%,$(header-y))
-unifdef-y 	:= $(patsubst %,$(INSTALL_HDR_PATH)/$(_dst)/%,$(unifdef-y))
-objhdr-y 	:= $(patsubst %,$(INSTALL_HDR_PATH)/$(_dst)/%,$(objhdr-y))
-check-y 	:= $(patsubst %,$(INSTALL_HDR_PATH)/$(_dst)/%,$(check-y))
+# Work out what needs to be removed
+oldheaders   := $(patsubst $(install)/%,%,$(wildcard $(install)/*.h))
+unwanted     := $(filter-out $(all-files),$(oldheaders))
 
+# Prefix all with full paths to $(INSTALL_HDR_PATH)
+header-y     := $(addprefix $(install)/, $(header-y))
+objhdr-y     := $(addprefix $(install)/, $(objhdr-y))
+unwanted     := $(addprefix $(install)/, $(unwanted))
 
-ifdef ALTARCH
-ifeq ($(obj),include/asm-$(ARCH))
-altarch-y	:= altarch-dir
-endif
-endif
+printdir = $(patsubst $(INSTALL_HDR_PATH)/%/,%,$(dir $@))
 
-# Make the definitions visible for recursive make invocations
-export ALTARCH
-export ARCHDEF
-export ALTARCHDEF
-
-quiet_cmd_o_hdr_install   = INSTALL $(patsubst $(INSTALL_HDR_PATH)/%,%,$@)
-      cmd_o_hdr_install   = cp $(patsubst $(INSTALL_HDR_PATH)/$(_dst)/%,$(objtree)/$(obj)/%,$@) \
-			    $(INSTALL_HDR_PATH)/$(_dst)
-
-quiet_cmd_headers_install = INSTALL $(patsubst $(INSTALL_HDR_PATH)/%,%,$@)
-      cmd_headers_install = $(HDRSED) $(patsubst $(INSTALL_HDR_PATH)/$(_dst)/%,$(srctree)/$(obj)/%,$@)	\
-			    > $@
-
-quiet_cmd_unifdef	  = UNIFDEF $(patsubst $(INSTALL_HDR_PATH)/%,%,$@)
-      cmd_unifdef	  = $(UNIFDEF) $(patsubst $(INSTALL_HDR_PATH)/$(_dst)/%,$(srctree)/$(obj)/%,$@) \
-				   | $(HDRSED) > $@ || :
-
-quiet_cmd_check		  = CHECK   $(patsubst $(INSTALL_HDR_PATH)/$(_dst)/.check.%,$(_dst)/%,$@)
-      cmd_check		  = $(CONFIG_SHELL) $(srctree)/scripts/hdrcheck.sh \
-                              $(INSTALL_HDR_PATH)/include $(subst /.check.,/,$@) $@
-
-quiet_cmd_remove	  = REMOVE  $(_dst)/$@
-      cmd_remove	  = rm -f $(INSTALL_HDR_PATH)/$(_dst)/$@
-
-quiet_cmd_mkdir		  = MKDIR   $(patsubst $(INSTALL_HDR_PATH)/%,%,$@)
-      cmd_mkdir		  = mkdir -p $@
-
-quiet_cmd_gen		  = GEN     $(patsubst $(INSTALL_HDR_PATH)/%,%,$@)
-      cmd_gen		  = \
-FNAME=$(patsubst $(INSTALL_HDR_PATH)/$(_dst)/%,%,$@);			\
-STUBDEF=__ASM_STUB_`echo $$FNAME | tr a-z.- A-Z__`;			\
-(echo "/* File autogenerated by 'make headers_install' */" ;		\
-echo "\#ifndef $$STUBDEF" ;						\
-echo "\#define $$STUBDEF" ;						\
-echo "\# if $(ARCHDEF)" ;						\
-if [ -r $(subst /$(_dst)/,/include/$(archasm)/,$@) ]; then		\
-	echo "\#  include <$(archasm)/$$FNAME>" ;			\
-else									\
-	echo "\#  error $(archasm)/$$FNAME does not exist in"		\
-			"the $(ARCH) architecture" ;			\
-fi ;									\
-echo "\# elif $(ALTARCHDEF)" ;						\
-if [ -r $(subst /$(_dst)/,/include/$(altarchasm)/,$@) ]; then		\
-	echo "\#  include <$(altarchasm)/$$FNAME>" ;			\
-else									\
-	echo "\#  error $(altarchasm)/$$FNAME does not exist in"	\
-			"the $(ALTARCH) architecture" ;			\
-fi ;									\
-echo "\# else" ;							\
-echo "\#  warning This machine appears to be"				\
-		 "neither $(ARCH) nor $(ALTARCH)." ;			\
-echo "\# endif" ;							\
-echo "\#endif /* $$STUBDEF */" ;					\
-) > $@
-
-.PHONY: __headersinst __headerscheck
+quiet_cmd_install = INSTALL $(printdir) ($(words $(all-files)) files)
+      cmd_install = $(PERL) $(srctree)/scripts/headers_install.pl \
+                            $(obj) $(install) $(all-files)
 
-ifdef HDRCHECK
-__headerscheck: $(subdir-y) $(check-y)
-	@true
+quiet_cmd_remove = REMOVE  $(patsubst $(INSTALL_HDR_PATH)/%,%,$(unwanted))
+      cmd_remove = rm -f $(unwanted)
+
+quiet_cmd_check = CHECK   $(printdir) ($(words $(all-files)) files)
+      cmd_check = $(PERL) $(srctree)/scripts/headers_check.pl \
+                  $(INSTALL_HDR_PATH)/include                 \
+                  $(addprefix $(install)/, $(all-files))
 
-$(check-y) : $(INSTALL_HDR_PATH)/$(_dst)/.check.%.h : $(INSTALL_HDR_PATH)/$(_dst)/%.h 
-	$(call cmd,check)
+PHONY += __headersinst __headerscheck
 
-# Other dependencies for $(check-y)
-include /dev/null $(wildcard $(check-y))
+ifdef HDRCHECK
+__headerscheck: $(subdirs) $(check-file)
+	@:
 
-# ... but leave $(check-y) as .PHONY for now until those deps are actually correct.
-.PHONY: $(check-y)
+targets += $(check-file)
+$(check-file): $(addprefix $(srctree)/$(obj)/,$(all-files)) FORCE
+	$(call if_changed,check)
+	$(Q)touch $@
 
 else
 # Rules for installing headers
-__headersinst: $(subdir-y) $(header-y) $(unifdef-y) $(altarch-y) $(objhdr-y)
-	@true
-
-$(objhdr-y) $(subdir-y) $(header-y) $(unifdef-y): | $(INSTALL_HDR_PATH)/$(_dst) $(unwanted)
-
-$(INSTALL_HDR_PATH)/$(_dst):
-	$(call cmd,mkdir)
+__headersinst: $(subdirs) $(install-file)
+	@:
 
-.PHONY: $(unwanted)
-$(unwanted):
-	$(call cmd,remove)
+targets += $(install-file)
+$(install-file): $(addprefix $(srctree)/$(obj)/,$(all-files)) FORCE
+	$(if $(unwanted),$(call cmd,remove),)
+	$(if $(wildcard $(dir $@)),,$(shell mkdir -p $(dir $@)))
+	$(call if_changed,install)
+	$(Q)touch $@
 
-ifdef GENASM
-$(objhdr-y) $(header-y) $(unifdef-y): $(KBUILDFILES)
-	$(call cmd,gen)
+endif
 
-else
-$(objhdr-y) :		$(INSTALL_HDR_PATH)/$(_dst)/%.h: $(objtree)/$(obj)/%.h $(KBUILDFILES)
-	$(call cmd,o_hdr_install)
+# Recursion
+hdr-inst := -rR -f $(srctree)/scripts/Makefile.headersinst obj
+.PHONY: $(subdirs)
+$(subdirs):
+	$(Q)$(MAKE) $(hdr-inst)=$(obj)/$@ dst=$(_dst)/$@
 
-$(header-y) :		$(INSTALL_HDR_PATH)/$(_dst)/%.h: $(srctree)/$(obj)/%.h $(KBUILDFILES)
-	$(call cmd,headers_install)
+targets := $(wildcard $(sort $(targets)))
+cmd_files := $(wildcard \
+             $(foreach f,$(targets),$(dir $(f)).$(notdir $(f)).cmd))
 
-$(unifdef-y) :		$(INSTALL_HDR_PATH)/$(_dst)/%.h: $(srctree)/$(obj)/%.h $(KBUILDFILES)
-	$(call cmd,unifdef)
-endif
+ifneq ($(cmd_files),)
+	include $(cmd_files)
 endif
 
-hdrinst := -rR -f $(srctree)/scripts/Makefile.headersinst obj
-
-.PHONY: altarch-dir
-# All the files in the normal arch dir must be created first, since we test
-# for their existence.
-altarch-dir: $(subdir-y) $(header-y) $(unifdef-y) $(objhdr-y)
-	$(Q)$(MAKE) $(hdrinst)=include/asm-$(ALTARCH) dst=include/asm-$(ALTARCH)
-	$(Q)$(MAKE) $(hdrinst)=include/asm dst=include/asm$(BIASMDIR)
-
-# Recursion
-.PHONY: $(subdir-y)
-$(subdir-y):
-	$(Q)$(MAKE) $(hdrinst)=$(obj)/$@ dst=$(_dst)/$@ rel=../$(rel)
+.PHONY: $(PHONY)
+PHONY += FORCE
+FORCE: ;
diff --git a/scripts/hdrcheck.sh b/scripts/hdrcheck.sh
deleted file mode 100755
index 3159858..0000000
--- a/scripts/hdrcheck.sh
+++ /dev/null
@@ -1,10 +0,0 @@
-#!/bin/sh
-
-for FILE in `grep '^[ \t]*#[ \t]*include[ \t]*<' $2 | cut -f2 -d\< | cut -f1 -d\> | egrep ^linux\|^asm` ; do
-    if [ ! -r $1/$FILE ]; then
-	echo $2 requires $FILE, which does not exist in exported headers
-	exit 1
-    fi
-done
-# FIXME: List dependencies into $3
-touch $3
diff --git a/scripts/headers_check.pl b/scripts/headers_check.pl
new file mode 100644
index 0000000..dfb2ec7
--- /dev/null
+++ b/scripts/headers_check.pl
@@ -0,0 +1,48 @@
+#!/usr/bin/perl
+#
+# headers_check.pl execute a number of trivial consistency checks
+#
+# Usage: headers_check.pl dir [files...]
+# dir..:  dir to look for included files
+# files:  list of files to check
+#
+# The script reads the supplied files line by line and:
+#
+# 1) for each include statement it checks if the
+#    included file actually exists.
+#    Only include files located in asm* and linux* are checked.
+#    The rest are assumed to be system include files.
+#
+# 2) TODO
+
+my ($dir, @files) = @ARGV;
+
+my $ret = 0;
+my $lineno = 0;
+my $filename;
+
+foreach $file (@files) {
+	$filename = $file;
+	open(FILE, "< $filename") or die "$filename: $!\n";
+	$lineno = 0;
+	while ($line = <FILE>) {
+		$lineno++;
+		&check_include();
+	}
+	close(FILE);
+}
+exit($ret);
+
+my $includere = qr/^\s*#\s*include\s+<(.*)>/;
+sub check_include()
+{
+	if ($line =~ m/^\s*#\s*include\s+<(.*)>/) {
+		my $inc = $1;
+		if ($inc =~ m/^asm/ || $inc =~ m/^linux/) {
+			if (!(stat($dir . "/" . $inc))) {
+				printf STDERR "$filename:$lineno: included file '$inc' is not exported\n";
+				$ret = 1;
+			}
+		}
+	}
+}
diff --git a/scripts/headers_install.pl b/scripts/headers_install.pl
new file mode 100644
index 0000000..8aa66af
--- /dev/null
+++ b/scripts/headers_install.pl
@@ -0,0 +1,39 @@
+#!/usr/bin/perl
+#
+# headers_install prepare the listed header files for use in
+# user space and copy the files to their destination.
+#
+# Usage: headers_install.pl opendir installdir [files...]
+# opendir: dir to open files
+# install: dir to install the files
+# files..: list of files to check
+#
+# Step in preparation for users space:
+# 1) Drop all use of compiler.h definitions
+# 2) Drop include of compiler.h
+# 3) Drop all sections defined out by __KERNEL__
+
+my ($opendir, $installdir, @files) = @ARGV;
+
+my $ret = 0;
+
+foreach $file (@files) {
+	open(INFILE, "< $opendir/$file") or die "$openddir/$file: $!\n";
+	open(OUTFILE, "> $installdir/$file.tmp") or
+		die "$installdir/$file.tmp: $!\n";
+	while ($line = <INFILE>) {
+		$line =~ s/([\s(])__user\s/\1/g;
+		$line =~ s/([\s(])__force\s/\1/g;
+		$line =~ s/([\s(])__iomem\s/\1/g;
+		$line =~ s/\s__attribute_const__\s/ /g;
+		$line =~ s/\s__attribute_const__$//g;
+		$line =~ s/^#include <linux\/compiler.h>//;
+		printf OUTFILE $line;
+	}
+	close(OUTFILE);
+	close(INFILE);
+	system "scripts/unifdef -U__KERNEL__ $installdir/$file.tmp > $installdir/$file"
+}
+
+exit($ret);
+
