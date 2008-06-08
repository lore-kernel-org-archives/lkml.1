Return-Path: <linux-kernel-owner+w=401wt.eu-S1754924AbYFHUIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924AbYFHUIq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 16:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756158AbYFHUHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 16:07:16 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:39603 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755870AbYFHUG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 16:06:58 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: <linux-kernel@vger.kernel.org>, <linux-kbuild@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, David Woodhouse <dwmw2@infradead.org>,
       Vegard@ravnborg.org, "Nossum <vegard.nossum"@gmail.com
Subject: [PATCH 6/6] kbuild: optimize headers_* targets
Date: Sun,  8 Jun 2008 22:07:38 +0200
Message-Id: <1212955658-32168-6-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.4.1.143.ge7e51
In-Reply-To: <20080608094730.GA30098@uranus.ravnborg.org>
References: <20080608094730.GA30098@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch bring the time to execute make headers_* down
to an accetable level with acceptable amount of output lines.

On my box we went from ~30 seconds down to ~10 seconds
for a "make headers_check" with all headers being installed.
The majority of the time is now spent in unifdef.

The patch introduces two perl scripts.
One is used for the install phase, and the other is used for the
check phase. They both receive a list of files to operate on
and process one directory at a time.

The headers_install.pl script will hopefully one day include
the functionality of unifdef utility to speed up the process.

And the headers_check.pl will most likely be extended to
cover additional type of checks.

Vegard Nossum <vegard.nossum@gmail.com> gave a lot
of feedback to the perl scripts.
David Woodhouse <dwmw2@infradead.org> contributed
with additional inputs that simplified the Makefile.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com
---
 Makefile                     |   28 +++++----
 include/Kbuild               |    4 +-
 scripts/Makefile.headersinst |  140 ++++++++++++++++-------------------------
 scripts/hdrcheck.sh          |   10 ---
 scripts/headers_check.pl     |   56 +++++++++++++++++
 scripts/headers_install.pl   |   43 +++++++++++++
 6 files changed, 171 insertions(+), 110 deletions(-)
 delete mode 100755 scripts/hdrcheck.sh
 create mode 100644 scripts/headers_check.pl
 create mode 100644 scripts/headers_install.pl

diff --git a/Makefile b/Makefile
index 8f8fd6f..088751a 100644
--- a/Makefile
+++ b/Makefile
@@ -1000,7 +1000,7 @@ depend dep:
 #Default location for installed headers
 export INSTALL_HDR_PATH = $(objtree)/usr
 
-hdr-filter := generic um ppc
+hdr-filter := generic um ppc sparc64
 hdr-archs  := $(filter-out $(hdr-filter),                           \
                   $(patsubst $(srctree)/include/asm-%/Kbuild,%,     \
                       $(wildcard $(srctree)/include/asm-*/Kbuild)))
@@ -1012,29 +1012,31 @@ __headers: include/linux/version.h scripts_basic FORCE
 
 PHONY += headers_install_all
 headers_install_all: __headers
+	$(Q)$(MAKE) $(hdr-inst)=include
 	$(Q)set -e; for arch in $(hdr-archs); do \
-	 $(MAKE) ARCH=$$arch SRCARCH=$$arch $(hdr-inst)=include \
-	         BIASMDIR=-bi-$$arch ;\
+	 $(MAKE) $(hdr-inst)=include/asm-$$arch   \
+	         SRCARCH=$$arch dst=include/asm-$$arch;  \
 	 done
 
 PHONY += headers_install
 headers_install: __headers
-	$(Q)if [ ! -r $(srctree)/include/asm-$(SRCARCH)/Kbuild ]; then \
-	  echo '*** Error: Headers not exportable for this architecture ($(SRCARCH))'; \
-	  exit 1 ; \
-	fi
-	$(Q)$(MAKE) $(hdr-inst)=include ARCH=$(SRCARCH)
+	$(if $(wildcard $(srctree)/include/asm-$(SRCARCH)/Kbuild),, \
+	$(error Headers not exportable for this architecture ($(SRCARCH))))
+	$(Q)$(MAKE) $(hdr-inst)=include
+	$(Q)$(MAKE) $(hdr-inst)=include/asm-$(SRCARCH) dst=include/asm
 
 PHONY += headers_check_all
-headers_check_all: headers_install_all
-	$(Q)set -e; for arch in $(hdr-archs); do \
-	 $(MAKE) ARCH=$$arch SRCARCH=$$arch $(hdr-inst)=include \
-	         BIASMDIR=-bi-$$arch HDRCHECK=1 ;\
+headers_check_all: headers_install headers_install_all
+	$(Q)$(MAKE) $(hdr-inst)=include HDRCHECK=1
+	$(Q)for arch in $(hdr-archs); do \
+	 $(MAKE) SRCARCH=$$arch $(hdr-inst)=include/asm-$$arch HDRCHECK=1 ;\
 	 done
 
 PHONY += headers_check
 headers_check: headers_install
-	$(Q)$(MAKE) $(hdr-inst)=include ARCH=$(SRCARCH) HDRCHECK=1
+	$(Q)$(MAKE) $(hdr-inst)=include HDRCHECK=1
+	$(Q)$(MAKE) $(hdr-inst)=include/asm-$(SRCARCH) \
+	            dst=include/asm HDRCHECK=1
 
 # ---------------------------------------------------------------------------
 # Modules
diff --git a/include/Kbuild b/include/Kbuild
index b522887..6ae595c 100644
--- a/include/Kbuild
+++ b/include/Kbuild
@@ -1,8 +1,8 @@
+# Top-level Makefile calls into asm-$(ARCH)
+
 header-y += asm-generic/
 header-y += linux/
 header-y += sound/
 header-y += mtd/
 header-y += rdma/
 header-y += video/
-
-header-y += asm-$(ARCH)/
diff --git a/scripts/Makefile.headersinst b/scripts/Makefile.headersinst
index 599adc6..aa1965d 100644
--- a/scripts/Makefile.headersinst
+++ b/scripts/Makefile.headersinst
@@ -7,20 +7,6 @@
 #
 # ==========================================================================
 
-UNIFDEF := scripts/unifdef -U__KERNEL__
-
-# Eliminate the contents of (and inclusions of) compiler.h
-HDRSED  := sed	-e "s/ inline / __inline__ /g" \
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
 
 kbuild-file := $(srctree)/$(obj)/Kbuild
@@ -28,98 +14,82 @@ include $(kbuild-file)
 
 include scripts/Kbuild.include
 
-# If this is include/asm-$(ARCH) then override $(_dst) so that
-# we install to include/asm directly.
-# Unless $(BIASMDIR) is set, in which case we're probably doing
-# a 'headers_install_all' build and we should keep the -$(ARCH)
-# in the directory name.
-ifeq ($(obj),include/asm-$(ARCH)$(BIASMDIR))
-     _dst := include/asm
-endif
+install      := $(INSTALL_HDR_PATH)/$(_dst)
 
-install := $(INSTALL_HDR_PATH)/$(_dst)
+header-y     := $(sort $(header-y) $(unifdef-y))
+subdirs      := $(patsubst %/,%,$(filter %/, $(header-y)))
+header-y     := $(filter-out %/, $(header-y))
 
-header-y	:= $(sort $(header-y) $(unifdef-y))
-subdir-y	:= $(patsubst %/,%,$(filter %/, $(header-y)))
-header-y	:= $(filter-out %/, $(header-y))
+# files used to track state of install/check
+install-file := $(install)/.install
+check-file   := $(install)/.check
 
-# stamp files for header checks
-check-y		:= $(patsubst %,.check.%,$(header-y) $(objhdr-y))
+# all headers files for this dir
+all-files    := $(header-y) $(objhdr-y)
 
 # Work out what needs to be removed
-oldheaders      := $(patsubst $(install)/%,%,$(wildcard $(install)/*.h))
-unwanted        := $(filter-out $(header-y) $(objhdr-y),$(oldheaders))
-
-oldcheckstamps  := $(patsubst $(install)/%,%,$(wildcard $(install)/.check.*.h))
-unwanted        += $(filter-out $(check-y),$(oldcheckstamps))
-
-# Prefix them all with full paths to $(INSTALL_HDR_PATH)
-header-y        := $(patsubst %,$(install)/%,$(header-y))
-objhdr-y        := $(patsubst %,$(install)/%,$(objhdr-y))
-check-y         := $(patsubst %,$(install)/%,$(check-y))
+oldheaders   := $(patsubst $(install)/%,%,$(wildcard $(install)/*.h))
+unwanted     := $(filter-out $(all-files),$(oldheaders))
 
-quiet_cmd_o_hdr_install = INSTALL $(patsubst $(INSTALL_HDR_PATH)/%,%,$@)
-      cmd_o_hdr_install = cp $(patsubst $(install)/%,$(objtree)/$(obj)/%,$@) \
-                             $(install)
+# Prefix all with full paths to $(INSTALL_HDR_PATH)
+header-y     := $(addprefix $(install)/, $(header-y))
+objhdr-y     := $(addprefix $(install)/, $(objhdr-y))
+unwanted     := $(addprefix $(install)/, $(unwanted))
 
-quiet_cmd_unifdef = UNIFDEF $(patsubst $(INSTALL_HDR_PATH)/%,%,$@)
-      cmd_unifdef = $(UNIFDEF) $(patsubst $(install)/%,$(srctree)/$(obj)/%,$@)\
-                               | $(HDRSED) > $@ || :
+printdir = $(patsubst $(INSTALL_HDR_PATH)/%/,%,$(dir $@))
 
-quiet_cmd_check = CHECK   $(patsubst $(install)/.check.%,$(_dst)/%,$@)
-      cmd_check = $(CONFIG_SHELL) $(srctree)/scripts/hdrcheck.sh \
-                  $(INSTALL_HDR_PATH)/include $(subst /.check.,/,$@) $@
+quiet_cmd_install = INSTALL $(printdir) ($(words $(all-files)) files)
+      cmd_install = $(PERL) $(srctree)/scripts/headers_install.pl \
+                            $(obj) $(install) $(all-files)
 
-quiet_cmd_remove = REMOVE  $(_dst)/$@
-      cmd_remove = rm -f $(install)/$@
+quiet_cmd_remove = REMOVE  $(patsubst $(INSTALL_HDR_PATH)/%,%,$(unwanted))
+      cmd_remove = rm -f $(unwanted)
 
-quiet_cmd_mkdir  = MKDIR   $(patsubst $(INSTALL_HDR_PATH)/%,%,$@)
-      cmd_mkdir  = mkdir -p $@
+quiet_cmd_check = CHECK   $(printdir) ($(words $(all-files)) files)
+      cmd_check = $(PERL) $(srctree)/scripts/headers_check.pl \
+                  $(INSTALL_HDR_PATH)/include                 \
+                  $(SRCARCH)                                  \
+                  $(addprefix $(install)/, $(all-files))
 
-.PHONY: __headersinst __headerscheck
+PHONY += __headersinst __headerscheck
 
 ifdef HDRCHECK
-__headerscheck: $(subdir-y) $(check-y)
-	@true
+__headerscheck: $(subdirs) $(check-file)
+	@:
 
-$(check-y) : $(install)/.check.%.h : $(install)/%.h
-	$(call cmd,check)
-
-# Other dependencies for $(check-y)
-include /dev/null $(wildcard $(check-y))
-
-# but leave $(check-y) as .PHONY for now until those
-# deps are actually correct.
-.PHONY: $(check-y)
+targets += $(check-file)
+$(check-file): $(addprefix $(srctree)/$(obj)/,$(all-files)) FORCE
+	$(call if_changed,check)
+	$(Q)touch $@
 
 else
 # Rules for installing headers
-__headersinst: $(subdir-y) $(header-y) $(objhdr-y)
-	@true
+__headersinst: $(subdirs) $(install-file)
+	@:
 
-$(objhdr-y) $(subdir-y) $(header-y): | $(install) $(unwanted)
+targets += $(install-file)
+$(install-file): $(addprefix $(srctree)/$(obj)/,$(all-files)) FORCE
+	$(if $(unwanted),$(call cmd,remove),)
+	$(if $(wildcard $(dir $@)),,$(shell mkdir -p $(dir $@)))
+	$(call if_changed,install)
+	$(Q)touch $@
 
-$(install):
-	$(call cmd,mkdir)
-
-# Rules for removing unwanted header files
-.PHONY: $(unwanted)
-$(unwanted):
-	$(call cmd,remove)
+endif
 
-# Install generated files
-$(objhdr-y): $(install)/%.h: $(objtree)/$(obj)/%.h $(kbuild-file)
-	$(call cmd,o_hdr_install)
+# Recursion
+hdr-inst := -rR -f $(srctree)/scripts/Makefile.headersinst obj
+.PHONY: $(subdirs)
+$(subdirs):
+	$(Q)$(MAKE) $(hdr-inst)=$(obj)/$@ dst=$(_dst)/$@
 
-# Unifdef header files and install them
-$(header-y): $(install)/%.h: $(srctree)/$(obj)/%.h $(kbuild-file)
-	$(call cmd,unifdef)
+targets := $(wildcard $(sort $(targets)))
+cmd_files := $(wildcard \
+             $(foreach f,$(targets),$(dir $(f)).$(notdir $(f)).cmd))
 
+ifneq ($(cmd_files),)
+	include $(cmd_files)
 endif
 
-hdr-inst := -rR -f $(srctree)/scripts/Makefile.headersinst obj
-
-# Recursion
-.PHONY: $(subdir-y)
-$(subdir-y):
-	$(Q)$(MAKE) $(hdr-inst)=$(obj)/$@ dst=$(_dst)/$@
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
index 0000000..15d53a6
--- /dev/null
+++ b/scripts/headers_check.pl
@@ -0,0 +1,56 @@
+#!/usr/bin/perl
+#
+# headers_check.pl execute a number of trivial consistency checks
+#
+# Usage: headers_check.pl dir [files...]
+# dir:   dir to look for included files
+# arch:  architecture
+# files: list of files to check
+#
+# The script reads the supplied files line by line and:
+#
+# 1) for each include statement it checks if the
+#    included file actually exists.
+#    Only include files located in asm* and linux* are checked.
+#    The rest are assumed to be system include files.
+#
+# 2) TODO: check for leaked CONFIG_ symbols
+
+use strict;
+use warnings;
+
+my ($dir, $arch, @files) = @ARGV;
+
+my $ret = 0;
+my $line;
+my $lineno = 0;
+my $filename;
+
+foreach my $file (@files) {
+	$filename = $file;
+	open(my $fh, '<', "$filename") or die "$filename: $!\n";
+	$lineno = 0;
+	while ($line = <$fh>) {
+		$lineno++;
+		check_include();
+	}
+	close $fh;
+}
+exit $ret;
+
+sub check_include
+{
+	if ($line =~ m/^\s*#\s*include\s+<((asm|linux).*)>/) {
+		my $inc = $1;
+		my $found;
+		$found = stat($dir . "/" . $inc);
+		if (!$found) {
+			$inc =~ s#asm/#asm-$arch/#;
+			$found = stat($dir . "/" . $inc);
+		}
+		if (!$found) {
+			printf STDERR "$filename:$lineno: included file '$inc' is not exported\n";
+			$ret = 1;
+		}
+	}
+}
diff --git a/scripts/headers_install.pl b/scripts/headers_install.pl
new file mode 100644
index 0000000..283c055
--- /dev/null
+++ b/scripts/headers_install.pl
@@ -0,0 +1,43 @@
+#!/usr/bin/perl
+#
+# headers_install prepare the listed header files for use in
+# user space and copy the files to their destination.
+#
+# Usage: headers_install.pl odir installdir [files...]
+# odir:    dir to open files
+# install: dir to install the files
+# files:   list of files to check
+#
+# Step in preparation for users space:
+# 1) Drop all use of compiler.h definitions
+# 2) Drop include of compiler.h
+# 3) Drop all sections defined out by __KERNEL__ (using unifdef)
+
+use strict;
+use warnings;
+
+my ($odir, $installdir, @files) = @ARGV;
+
+my $ret = 0;
+my $unifdef = "scripts/unifdef -U__KERNEL__";
+
+foreach my $file (@files) {
+	my $tmpfile = "$installdir/$file.tmp";
+	open(my $infile, '<', "$odir/$file") or die "$odir/$file: $!\n";
+	open(my $outfile, '>', "$tmpfile") or die "$tmpfile: $!\n";
+	while (my $line = <$infile>) {
+		$line =~ s/([\s(])__user\s/$1/g;
+		$line =~ s/([\s(])__force\s/$1/g;
+		$line =~ s/([\s(])__iomem\s/$1/g;
+		$line =~ s/\s__attribute_const__\s/ /g;
+		$line =~ s/\s__attribute_const__$//g;
+		$line =~ s/^#include <linux\/compiler.h>//;
+		printf $outfile "%s", $line;
+	}
+	close $outfile;
+	close $infile;
+	$ret = system $unifdef . " $tmpfile > $installdir/$file";
+	unlink $tmpfile;
+}
+
+exit $ret;
-- 
1.5.4.1.143.ge7e51

