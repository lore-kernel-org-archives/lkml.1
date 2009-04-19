Return-Path: <linux-kernel-owner+w=401wt.eu-S1756593AbZDSJYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593AbZDSJYA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 05:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753190AbZDSJXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 05:23:50 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:56123 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbZDSJXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 05:23:49 -0400
Date: Sun, 19 Apr 2009 11:25:55 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: [GIT] kbuild
Message-ID: <20090419092555.GA19213@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

We have on the lists recently discussed two features:
1) Move generated files to include/generated
2) Introduce support for subdir-ccflags-y

Both features has low risk of introducing regressions
and including them now allow us to use the features for next
merge window.

This will for example allow arm to support mach-types.h in
include/generated without touching files outside arch/arm.

Please pull.

	Sam

The following changes since commit ff54250a0ebab7f90a5f848a0ba63f999830c872:
  Linus Torvalds (1):
        Remove 'recurse into child resources' logic from 'reserve_region_with_split()'

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-fixes.git master

Sam Ravnborg (2):
      kbuild: support include/generated
      kbuild: introduce subdir-ccflags-y

 .gitignore                         |    1 +
 Documentation/kbuild/makefiles.txt |   10 ++++++++++
 Makefile                           |    2 +-
 scripts/Makefile.build             |    3 +++
 scripts/Makefile.lib               |    9 +++++++--
 5 files changed, 22 insertions(+), 3 deletions(-)


diff --git a/.gitignore b/.gitignore
index 869e1a3..51bd99d 100644
--- a/.gitignore
+++ b/.gitignore
@@ -49,6 +49,7 @@ include/linux/compile.h
 include/linux/version.h
 include/linux/utsrelease.h
 include/linux/bounds.h
+include/generated
 
 # stgit generated dirs
 patches-*
diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
index d4b0567..d76cfd8 100644
--- a/Documentation/kbuild/makefiles.txt
+++ b/Documentation/kbuild/makefiles.txt
@@ -316,6 +316,16 @@ more details, with real examples.
 		#arch/m68k/fpsp040/Makefile
 		ldflags-y := -x
 
+    subdir-ccflags-y, subdir-asflags-y
+	The two flags listed above are similar to ccflags-y and as-falgs-y.
+	The difference is that the subdir- variants has effect for the kbuild
+	file where tey are present and all subdirectories.
+	Options specified using subdir-* are added to the commandline before
+	the options specified using the non-subdir variants.
+
+	Example:
+		subdir-ccflags-y := -Werror
+
     CFLAGS_$@, AFLAGS_$@
 
 	CFLAGS_$@ and AFLAGS_$@ only apply to commands in current
diff --git a/Makefile b/Makefile
index bfdef56..6f4208f 100644
--- a/Makefile
+++ b/Makefile
@@ -1200,7 +1200,7 @@ CLEAN_FILES +=	vmlinux System.map \
                 .tmp_kallsyms* .tmp_version .tmp_vmlinux* .tmp_System.map
 
 # Directories & files removed with 'make mrproper'
-MRPROPER_DIRS  += include/config include2 usr/include
+MRPROPER_DIRS  += include/config include2 usr/include include/generated
 MRPROPER_FILES += .config .config.old include/asm .version .old_version \
                   include/linux/autoconf.h include/linux/version.h      \
                   include/linux/utsrelease.h                            \
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 39a9642..5c4b7a4 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -27,6 +27,9 @@ ccflags-y  :=
 cppflags-y :=
 ldflags-y  :=
 
+subdir-asflags-y :=
+subdir-ccflags-y :=
+
 # Read auto.conf if it exists, otherwise ignore
 -include include/config/auto.conf
 
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 9796195..cba61ca 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -4,6 +4,11 @@ ccflags-y  += $(EXTRA_CFLAGS)
 cppflags-y += $(EXTRA_CPPFLAGS)
 ldflags-y  += $(EXTRA_LDFLAGS)
 
+#
+# flags that take effect in sub directories
+export KBUILD_SUBDIR_ASFLAGS := $(KBUILD_SUBDIR_ASFLAGS) $(subdir-asflags-y)
+export KBUILD_SUBDIR_CCFLAGS := $(KBUILD_SUBDIR_CCFLAGS) $(subdir-ccflags-y)
+
 # Figure out what we need to build from the various variables
 # ===========================================================================
 
@@ -104,10 +109,10 @@ else
 debug_flags =
 endif
 
-orig_c_flags   = $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS)                     \
+orig_c_flags   = $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) $(KBUILD_SUBDIR_CCFLAGS) \
                  $(ccflags-y) $(CFLAGS_$(basetarget).o)
 _c_flags       = $(filter-out $(CFLAGS_REMOVE_$(basetarget).o), $(orig_c_flags))
-_a_flags       = $(KBUILD_CPPFLAGS) $(KBUILD_AFLAGS)                     \
+_a_flags       = $(KBUILD_CPPFLAGS) $(KBUILD_AFLAGS) $(KBUILD_SUBDIR_ASFLAGS) \
                  $(asflags-y) $(AFLAGS_$(basetarget).o)
 _cpp_flags     = $(KBUILD_CPPFLAGS) $(cppflags-y) $(CPPFLAGS_$(@F))
 
