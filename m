Return-Path: <linux-kernel-owner+w=401wt.eu-S1753827AbXLIIDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbXLIIDw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 03:03:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751756AbXLIIDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 03:03:44 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:47133 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668AbXLIIDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 03:03:43 -0500
Date: Sun, 9 Dec 2007 09:05:32 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Cc: Jay Cliburn <jacliburn@bellsouth.net>,
       Jan Altenberg <jan.altenberg@linutronix.de>
Subject: [GIT PATCHES] 2x kbuild fixes for -rc
Message-ID: <20071209080532.GA4954@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

Following are two fixes for two kbuild regressions that
has not been tracked by Rafael's list but anyway has
been sitting in my mailbox.

Please pull from:

	ssh://master.kernel.org/pub/scm/linux/kernel/git/sam/fix-kbuild.git

to receive the following patches:

Sam Ravnborg (2):
      kbuild: fix building with redirected output.
      kbuild: fix building with O=.. options

 Makefile           |   14 ++++++--------
 scripts/mkmakefile |    6 ++++++
 2 files changed, 12 insertions(+), 8 deletions(-)


Full diff of both patches:


diff --git a/Makefile b/Makefile
index 92dc3cb..7fb1a2c 100644
--- a/Makefile
+++ b/Makefile
@@ -108,6 +108,9 @@ endif
 PHONY := _all
 _all:
 
+# Cancel implicit rules on top Makefile
+$(CURDIR)/Makefile Makefile: ;
+
 ifneq ($(KBUILD_OUTPUT),)
 # Invoke a second make in the output directory, passing relevant variables
 # check that the output directory actually exists
@@ -115,13 +118,10 @@ saved-output := $(KBUILD_OUTPUT)
 KBUILD_OUTPUT := $(shell cd $(KBUILD_OUTPUT) && /bin/pwd)
 $(if $(KBUILD_OUTPUT),, \
      $(error output directory "$(saved-output)" does not exist))
-# Check that OUTPUT directory is not the same as where we have kernel src
-$(if $(filter-out $(KBUILD_OUTPUT),$(shell /bin/pwd)),, \
-     $(error Output directory (O=...) specifies kernel src dir))
 
 PHONY += $(MAKECMDGOALS) sub-make
 
-$(filter-out _all sub-make,$(MAKECMDGOALS)) _all: sub-make
+$(filter-out _all sub-make $(CURDIR)/Makefile, $(MAKECMDGOALS)) _all: sub-make
 	$(Q)@:
 
 sub-make: FORCE
@@ -291,7 +291,8 @@ export quiet Q KBUILD_VERBOSE
 # Look for make include files relative to root of kernel src
 MAKEFLAGS += --include-dir=$(srctree)
 
-# We need some generic definitions.
+# We need some generic definitions (do not try to remake the file).
+$(srctree)/scripts/Kbuild.include: ;
 include $(srctree)/scripts/Kbuild.include
 
 # Make variables (CC, etc...)
@@ -1560,9 +1561,6 @@ endif	# skip-makefile
 PHONY += FORCE
 FORCE:
 
-# Cancel implicit rules on top Makefile, `-rR' will apply to sub-makes.
-Makefile: ;
-
 # Declare the contents of the .PHONY variable as phony.  We keep that
 # information in a variable se we can use it in if_changed and friends.
 .PHONY: $(PHONY)
diff --git a/scripts/mkmakefile b/scripts/mkmakefile
index ee39fac..9ad1bd7 100644
--- a/scripts/mkmakefile
+++ b/scripts/mkmakefile
@@ -11,6 +11,12 @@
 
 
 test ! -r $2/Makefile -o -O $2/Makefile || exit 0
+# Only overwrite automatically generated Makefiles
+# (so we do not overwrite kernel Makefile)
+if ! grep -q Automatically $2/Makefile
+then
+	exit 0
+fi
 echo "  GEN     $2/Makefile"
 
 cat << EOF > $2/Makefile
