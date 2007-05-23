Return-Path: <linux-kernel-owner+w=401wt.eu-S1760017AbXEWSoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760017AbXEWSoV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 14:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756509AbXEWSoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 14:44:06 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:60902 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762707AbXEWSoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 14:44:04 -0400
Date: Wed, 23 May 2007 20:45:02 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] headercheck: add dependency check and improve speed
Message-ID: <20070523184502.GD23425@uranus.ravnborg.org>
References: <20070523181140.GA23425@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070523181140.GA23425@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Modified Makfile.headerinst so all files in a dir is checked with
one call to checkhdr.pl script.

The file check is used as marker when last run was executed.
And the file .check.cmd contains a list of dependencies used
by make to determine if a new check should be executed.

The perl script was named check* to follow same naming
as other check scripts.

The speedup is > 10 seconds for a build with headercheck enabled.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---

This version works on powerpc.
The assignment of checkfile had to move below the point where we check for biarch.

	Sam

 lib/Kconfig.debug            |    1 +
 scripts/Makefile.headersinst |   55 +++++++++++++++++++++++------------------
 scripts/checkhdr.pl          |   53 ++++++++++++++++++++++++++++++++++++++++
 scripts/hdrcheck.sh          |   10 -------
 4 files changed, 85 insertions(+), 34 deletions(-)
 create mode 100644 scripts/checkhdr.pl
 delete mode 100755 scripts/hdrcheck.sh

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index fbc5c62..596f973 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -70,6 +70,7 @@ config HEADERS_CHECK
 	  relevant for userspace, say 'Y', and check the headers
 	  exported to $(INSTALL_HDR_PATH) (usually 'usr/include' in
 	  your build tree), to make sure they're suitable.
+	  Note: Enabling this check requires perl to be installed
 
 config DEBUG_KERNEL
 	bool "Kernel debugging"
diff --git a/scripts/Makefile.headersinst b/scripts/Makefile.headersinst
index 8cd6301..6d74b54 100644
--- a/scripts/Makefile.headersinst
+++ b/scripts/Makefile.headersinst
@@ -28,7 +28,7 @@ ifeq (,$(patsubst include/asm/%,,$(obj)/))
 # both sets of Kbuild files; we'll generate anything which is mentioned in
 # _either_ arch, and recurse into subdirectories which are mentioned in either
 # arch. Since some directories may exist in one but not the other, we must
-# use $(wildcard...). 
+# use $(wildcard...).
 GENASM := 1
 archasm	   := $(subst include/asm,asm-$(ARCH),$(obj))
 altarchasm := $(subst include/asm,asm-$(ALTARCH),$(obj))
@@ -39,7 +39,7 @@ endif
 
 include $(KBUILDFILES)
 
-include scripts/Kbuild.include 
+include scripts/Kbuild.include
 
 # If this is include/asm-$(ARCH) and there's no $(ALTARCH), then
 # override $(_dst) so that we install to include/asm directly.
@@ -50,28 +50,29 @@ ifeq ($(obj)$(ALTARCH),include/asm-$(ARCH)$(BIASMDIR))
      _dst := include/asm
 endif
 
+# file generated during checktime listing depfiles and incfiles
+depsfile  := $(INSTALL_HDR_PATH)/$(_dst)/.check.cmd
+checkfile := $(INSTALL_HDR_PATH)/$(_dst)/check
+
+
 header-y	:= $(sort $(header-y))
 unifdef-y	:= $(sort $(unifdef-y))
 subdir-y	:= $(patsubst %/,%,$(filter %/, $(header-y)))
 header-y	:= $(filter-out %/, $(header-y))
 header-y	:= $(filter-out $(unifdef-y),$(header-y))
 
-# stamp files for header checks
-check-y		:= $(patsubst %,.check.%,$(header-y) $(unifdef-y) $(objhdr-y))
+# All files to check for this dir
+check-y		:= $(header-y) $(unifdef-y) $(objhdr-y)
 
 # Work out what needs to be removed
 oldheaders	:= $(patsubst $(INSTALL_HDR_PATH)/$(_dst)/%,%,$(wildcard $(INSTALL_HDR_PATH)/$(_dst)/*.h))
-unwanted	:= $(filter-out $(header-y) $(unifdef-y) $(objhdr-y),$(oldheaders))
-
-oldcheckstamps	:= $(patsubst $(INSTALL_HDR_PATH)/$(_dst)/%,%,$(wildcard $(INSTALL_HDR_PATH)/$(_dst)/.check.*.h))
-unwanted	+= $(filter-out $(check-y),$(oldcheckstamps))
+unwanted	:= $(filter-out $(check-y),$(oldheaders))
 
 # Prefix them all with full paths to $(INSTALL_HDR_PATH)
-header-y 	:= $(patsubst %,$(INSTALL_HDR_PATH)/$(_dst)/%,$(header-y))
-unifdef-y 	:= $(patsubst %,$(INSTALL_HDR_PATH)/$(_dst)/%,$(unifdef-y))
-objhdr-y 	:= $(patsubst %,$(INSTALL_HDR_PATH)/$(_dst)/%,$(objhdr-y))
-check-y 	:= $(patsubst %,$(INSTALL_HDR_PATH)/$(_dst)/%,$(check-y))
-
+header-y   := $(patsubst %,$(INSTALL_HDR_PATH)/$(_dst)/%,$(header-y))
+unifdef-y  := $(patsubst %,$(INSTALL_HDR_PATH)/$(_dst)/%,$(unifdef-y))
+objhdr-y   := $(patsubst %,$(INSTALL_HDR_PATH)/$(_dst)/%,$(objhdr-y))
+check-y    := $(patsubst %,$(INSTALL_HDR_PATH)/$(_dst)/%,$(check-y))
 
 ifdef ALTARCH
 ifeq ($(obj),include/asm-$(ARCH))
@@ -96,9 +97,9 @@ quiet_cmd_unifdef	  = UNIFDEF $(patsubst $(INSTALL_HDR_PATH)/%,%,$@)
       cmd_unifdef	  = $(UNIFDEF) $(patsubst $(INSTALL_HDR_PATH)/$(_dst)/%,$(srctree)/$(obj)/%,$@) \
 				   | $(HDRSED) > $@ || :
 
-quiet_cmd_check		  = CHECK   $(patsubst $(INSTALL_HDR_PATH)/$(_dst)/.check.%,$(_dst)/%,$@)
-      cmd_check		  = $(CONFIG_SHELL) $(srctree)/scripts/hdrcheck.sh \
-                              $(INSTALL_HDR_PATH)/include $(subst /.check.,/,$@) $@
+quiet_cmd_check		  = CHECK   $(words $(check-y)) files in $(_dst)
+      cmd_check		  = $(PERL) $(srctree)/scripts/checkhdr.pl \
+                              $(INSTALL_HDR_PATH)/include $(depsfile) $(check-y)
 
 quiet_cmd_remove	  = REMOVE  $(_dst)/$@
       cmd_remove	  = rm -f $(INSTALL_HDR_PATH)/$(_dst)/$@
@@ -137,17 +138,22 @@ echo "\#endif /* $$STUBDEF */" ;					\
 .PHONY: __headersinst __headerscheck
 
 ifdef HDRCHECK
-__headerscheck: $(subdir-y) $(check-y)
-	@true
+__headerscheck: $(subdir-y) $(checkfile)
+	$(Q):
 
-$(check-y) : $(INSTALL_HDR_PATH)/$(_dst)/.check.%.h : $(INSTALL_HDR_PATH)/$(_dst)/%.h 
-	$(call cmd,check)
+.PHONY: FORCE
+$(checkfile): FORCE
+	$(if $?, $(call cmd,check))
+	$(Q)touch $(checkfile)
 
-# Other dependencies for $(check-y)
-include /dev/null $(wildcard $(check-y))
+# Include autogenerated file listing depfiles and incfiles
+ifneq ($(wildcard $(depsfile)),)
+  include $(depsfile)
+endif
 
-# ... but leave $(check-y) as .PHONY for now until those deps are actually correct.
-.PHONY: $(check-y)
+$(checkfile) : $(depfiles)
+# dummy rule - cannot be made
+$(depfiles) : ;
 
 else
 # Rules for installing headers
@@ -192,3 +198,4 @@ altarch-dir: $(subdir-y) $(header-y) $(unifdef-y) $(objhdr-y)
 .PHONY: $(subdir-y)
 $(subdir-y):
 	$(Q)$(MAKE) $(hdrinst)=$(obj)/$@ dst=$(_dst)/$@ rel=../$(rel)
+
diff --git a/scripts/checkhdr.pl b/scripts/checkhdr.pl
new file mode 100644
index 0000000..bad7dd7
--- /dev/null
+++ b/scripts/checkhdr.pl
@@ -0,0 +1,53 @@
+#!/usr/bin/perl
+#
+# checkhdr.pl check that all files included by a file exists
+#
+# Usage: dir depfile [files...]
+# dir:      dir to look for included files
+# depfile:  file to write out which files was parsed and used by the parsed file
+# files...: list of files to check
+#
+# The script reads the supplied file line by line and for each include statement
+# it checks if the included file actually exists.
+#
+# Only include files located in asm* and linux* are checked. The rest are assumed
+# to be system include files.
+# The depfile has a list of unique filenames - make does not allow duplicates
+
+my ($dir, $depfile, @files) = @ARGV;
+
+my $includere = qr/^\s*#\s*include\s+<(.*)>/;
+my $ret = 0;
+my $lineno = 0;
+my @depfiles;
+
+foreach $file (@files) {
+	open(FILE, "< $file") or die "$file: $!\n";
+	push(@depfiles, $file);
+	$lineno = 0;
+	while ($line = <FILE>) {
+		$lineno++;
+		if ($line =~ m/$includere/) {
+			my $inc = $1;
+			if ($inc =~ m/^asm/ || $inc =~ m/^linux/) {
+				if (!(stat($dir . "/" . $inc))) {
+					print STDERR "$file:$lineno: included file '$inc' is not exported\n";
+					$ret = 1;
+				}
+				push(@depfiles, $dir . "/" . $inc);
+			}
+		}
+	}
+	close(FILE);
+}
+open(DEPFILE, "> $depfile") or die "$depfile: $!\n";
+print DEPFILE "depfiles := \\\n";
+
+@dep_unique{@depfiles} = ();
+@dep_unique_list = sort keys %dep_unique;
+foreach $f (@dep_unique_list) {
+	print DEPFILE "  $f \\\n";
+}
+print DEPFILE "\n";
+close(DEPFILE);
+exit($ret);
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
-- 
1.5.1.rc3.20.gaa453

