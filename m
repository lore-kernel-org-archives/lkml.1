Return-Path: <linux-kernel-owner+w=401wt.eu-S933179AbYF3ViV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933179AbYF3ViV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762977AbYF3Ven
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:34:43 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:51656 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763057AbYF3Ved (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:34:33 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 07/24] kbuild: optimize headers_* targets
Date: Mon, 30 Jun 2008 23:35:01 +0200
Message-Id: <1214861718-32626-7-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.6.1.93.gef98
In-Reply-To: <20080630213155.GA32479@uranus.ravnborg.org>
References: <20080630213155.GA32479@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the core functionality of headers_install
and headers_check to two small perl scripts.
The makefile is adapted to use the perl scrip and
changed to operate on all files in a directory.
So if one file is changed then all files in the
directory is processed.

perl were chosen for the helper scripts because this
is pure text processing which perl is good at and
especially the headers_check.pl script are expected to
see changes / new checks implmented.

The speed is ~300% faster on this box.
And the output generated to the screen is now down to
two lines per directory (one for install, one for check)
so it is easier to scroll back after a kernel build.

The perl scripts has been brought to sanity by patient
feedback from: Vegard Nossum <vegard.nossum@gmail.com>

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/Makefile.headersinst |  145 ++++++++++++++++++------------------------
 scripts/hdrcheck.sh          |   10 ---
 scripts/headers_check.pl     |   56 ++++++++++++++++
 scripts/headers_install.pl   |   42 ++++++++++++
 4 files changed, 161 insertions(+), 92 deletions(-)
 delete mode 100755 scripts/hdrcheck.sh
 create mode 100644 scripts/headers_check.pl
 create mode 100644 scripts/headers_install.pl

diff --git a/scripts/Makefile.headersinst b/scripts/Makefile.headersinst
index 599503f..be2b70c 100644
--- a/scripts/Makefile.headersinst
+++ b/scripts/Makefile.headersinst
@@ -1,26 +1,14 @@
 # ==========================================================================
 # Installing headers
 #
-# header-y files will be installed verbatim
-# unifdef-y are the files where unifdef will be run before installing files
-# objhdr-y are generated files that will be installed verbatim
+# header-y  - list files to be installed. They are preprocessed
+#             to remove __KERNEL__ section of the file
+# unifdef-y - Same as header-y. Obsolete
+# objhdr-y  - Same as header-y but for generated files
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
+# called may set destination dir (when installing to asm/)
 _dst := $(if $(dst),$(dst),$(obj))
 
 kbuild-file := $(srctree)/$(obj)/Kbuild
@@ -28,89 +16,82 @@ include $(kbuild-file)
 
 include scripts/Kbuild.include
 
-install := $(INSTALL_HDR_PATH)/$(_dst)
-
-header-y	:= $(sort $(header-y) $(unifdef-y))
-subdir-y	:= $(patsubst %/,%,$(filter %/, $(header-y)))
-header-y	:= $(filter-out %/, $(header-y))
+install       := $(INSTALL_HDR_PATH)/$(_dst)
 
-# stamp files for header checks
-check-y		:= $(patsubst %,.check.%,$(header-y) $(objhdr-y))
-
-# Work out what needs to be removed
-oldheaders      := $(patsubst $(install)/%,%,$(wildcard $(install)/*.h))
-unwanted        := $(filter-out $(header-y) $(objhdr-y),$(oldheaders))
+header-y      := $(sort $(header-y) $(unifdef-y))
+subdirs       := $(patsubst %/,%,$(filter %/, $(header-y)))
+header-y      := $(filter-out %/, $(header-y))
 
-oldcheckstamps  := $(patsubst $(install)/%,%,$(wildcard $(install)/.check.*.h))
-unwanted        += $(filter-out $(check-y),$(oldcheckstamps))
+# files used to track state of install/check
+install-file  := $(install)/.install
+check-file    := $(install)/.check
 
-# Prefix them all with full paths to $(INSTALL_HDR_PATH)
-header-y        := $(patsubst %,$(install)/%,$(header-y))
-objhdr-y        := $(patsubst %,$(install)/%,$(objhdr-y))
-check-y         := $(patsubst %,$(install)/%,$(check-y))
+# all headers files for this dir
+all-files     := $(header-y) $(objhdr-y)
+input-files   := $(addprefix $(srctree)/$(obj)/,$(header-y)) \
+                 $(addprefix $(objtree)/$(obj)/,$(objhdr-y))
+output-files  := $(addprefix $(install)/, $(all-files))
 
-quiet_cmd_o_hdr_install = INSTALL $(patsubst $(INSTALL_HDR_PATH)/%,%,$@)
-      cmd_o_hdr_install = cp $(patsubst $(install)/%,$(objtree)/$(obj)/%,$@) \
-                             $(install)
-
-quiet_cmd_unifdef = UNIFDEF $(patsubst $(INSTALL_HDR_PATH)/%,%,$@)
-      cmd_unifdef = $(UNIFDEF) $(patsubst $(install)/%,$(srctree)/$(obj)/%,$@)\
-                               | $(HDRSED) > $@ || :
+# Work out what needs to be removed
+oldheaders    := $(patsubst $(install)/%,%,$(wildcard $(install)/*.h))
+unwanted      := $(filter-out $(all-files),$(oldheaders))
 
-quiet_cmd_check = CHECK   $(patsubst $(install)/.check.%,$(_dst)/%,$@)
-      cmd_check = $(CONFIG_SHELL) $(srctree)/scripts/hdrcheck.sh \
-                  $(INSTALL_HDR_PATH)/include $(subst /.check.,/,$@) $@
+# Prefix unwanted with full paths to $(INSTALL_HDR_PATH)
+unwanted-file := $(addprefix $(install)/, $(unwanted))
 
-quiet_cmd_remove = REMOVE  $(_dst)/$@
-      cmd_remove = rm -f $(install)/$@
+printdir = $(patsubst $(INSTALL_HDR_PATH)/%/,%,$(dir $@))
 
-quiet_cmd_mkdir  = MKDIR   $(patsubst $(INSTALL_HDR_PATH)/%,%,$@)
-      cmd_mkdir  = mkdir -p $@
+quiet_cmd_install = INSTALL $(printdir) ($(words $(all-files))\
+                            file$(if $(word 2, $(all-files)),s))
+      cmd_install = $(PERL) $< $(srctree)/$(obj) $(install) $(header-y); \
+                    $(PERL) $< $(objtree)/$(obj) $(install) $(objhdr-y); \
+	            touch $@
 
-.PHONY: __headersinst __headerscheck
+quiet_cmd_remove = REMOVE  $(unwanted)
+      cmd_remove = rm -f $(unwanted-file)
 
-ifdef HDRCHECK
-__headerscheck: $(subdir-y) $(check-y)
-	@true
+quiet_cmd_check = CHECK   $(printdir) ($(words $(all-files)) files)
+      cmd_check = $(PERL) $< $(INSTALL_HDR_PATH)/include $(SRCARCH) \
+                  $(addprefix $(install)/, $(all-files));           \
+	          touch $@
 
-$(check-y) : $(install)/.check.%.h : $(install)/%.h
-	$(call cmd,check)
+PHONY += __headersinst __headerscheck
 
-# Other dependencies for $(check-y)
-include /dev/null $(wildcard $(check-y))
+ifndef HDRCHECK
+# Rules for installing headers
+__headersinst: $(subdirs) $(install-file)
+	@:
 
-# but leave $(check-y) as .PHONY for now until those
-# deps are actually correct.
-.PHONY: $(check-y)
+targets += $(install-file)
+$(install-file): scripts/headers_install.pl $(input-files) FORCE
+	$(if $(unwanted),$(call cmd,remove),)
+	$(if $(wildcard $(dir $@)),,$(shell mkdir -p $(dir $@)))
+	$(call if_changed,install)
 
 else
-# Rules for installing headers
-__headersinst: $(subdir-y) $(header-y) $(objhdr-y)
-	@true
+__headerscheck: $(subdirs) $(check-file)
+	@:
 
-$(objhdr-y) $(subdir-y) $(header-y): | $(install) $(unwanted)
+targets += $(check-file)
+$(check-file): scripts/headers_check.pl $(output-files) FORCE
+	$(call if_changed,check)
 
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
index 0000000..f0ff9a3
--- /dev/null
+++ b/scripts/headers_install.pl
@@ -0,0 +1,42 @@
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
+my ($readdir, $installdir, @files) = @ARGV;
+
+my $unifdef = "scripts/unifdef -U__KERNEL__";
+
+foreach my $file (@files) {
+	my $tmpfile = "$installdir/$file.tmp";
+	open(my $infile, '<', "$readdir/$file")
+		or die "$readdir/$file: $!\n";
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
+	system $unifdef . " $tmpfile > $installdir/$file";
+	unlink $tmpfile;
+}
+exit 0;
-- 
1.5.6.1.93.gef98

