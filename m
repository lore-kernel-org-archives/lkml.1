Return-Path: <linux-kernel-owner+w=401wt.eu-S1422792AbYHFU2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422792AbYHFU2k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 16:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758026AbYHFU21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 16:28:27 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:43825 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761784AbYHFU2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 16:28:25 -0400
Date: Wed, 6 Aug 2008 22:27:38 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Denis ChengRq <crquan@gmail.com>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk@arm.linux.org.uk>
Subject: [GIT PULL] kbuild fixes
Message-ID: <20080806202738.GA20066@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

Please pull following kbuild related fixes.

o Fix "make O=..." builds for arm
o update to for newer cscope
o patch-kernel fix (but I doubt it has many uses)
o small Kconfig clean-up

	Sam

The following changes since commit 0967d61ea0d8e8a7826bd8949cd93dd1e829ac55:
  Linus Torvalds (1):
        Linux 2.6.27-rc2

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-fixes.git master

Denis ChengRq (1):
      kbuild: a better way to generate cscope database change

Erkki Lintunen (1):
      bugfix for scripts/patch-kernel in 2.6 sublevel stepping

Robert P. J. Day (1):
      Kconfig: Extend "menuconfig" for modules to simplify Kconfig file

Sam Ravnborg (1):
      kbuild: fix O=.. build with arm

 Makefile             |    8 ++++----
 init/Kconfig         |    9 ++++-----
 scripts/patch-kernel |    3 ++-
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/Makefile b/Makefile
index ea413fa..f3e2065 100644
--- a/Makefile
+++ b/Makefile
@@ -929,10 +929,10 @@ ifneq ($(KBUILD_SRC),)
 		echo "  in the '$(srctree)' directory.";\
 		/bin/false; \
 	fi;
-	$(Q)if [ ! -d include2 ]; then mkdir -p include2; fi;
-	$(Q)if [ -e $(srctree)/include/asm-$(SRCARCH)/errno.h ]; then  \
+	$(Q)if [ ! -d include2 ]; then                                  \
+	    mkdir -p include2;                                          \
 	    ln -fsn $(srctree)/include/asm-$(SRCARCH) include2/asm;     \
-	    fi
+	fi
 endif
 
 # prepare2 creates a makefile if using a separate output directory
@@ -1492,7 +1492,7 @@ quiet_cmd_cscope-file = FILELST cscope.files
       cmd_cscope-file = (echo \-k; echo \-q; $(all-sources)) > cscope.files
 
 quiet_cmd_cscope = MAKE    cscope.out
-      cmd_cscope = cscope -b
+      cmd_cscope = cscope -b -f cscope.out
 
 cscope: FORCE
 	$(call cmd,cscope-file)
diff --git a/init/Kconfig b/init/Kconfig
index 7e6dae1..b678803 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -845,9 +845,10 @@ menuconfig MODULES
 
 	  If unsure, say Y.
 
+if MODULES
+
 config MODULE_FORCE_LOAD
 	bool "Forced module loading"
-	depends on MODULES
 	default n
 	help
 	  Allow loading of modules without version information (ie. modprobe
@@ -856,7 +857,6 @@ config MODULE_FORCE_LOAD
 
 config MODULE_UNLOAD
 	bool "Module unloading"
-	depends on MODULES
 	help
 	  Without this option you will not be able to unload any
 	  modules (note that some modules may not be unloadable
@@ -875,7 +875,6 @@ config MODULE_FORCE_UNLOAD
 
 config MODVERSIONS
 	bool "Module versioning support"
-	depends on MODULES
 	help
 	  Usually, you have to use modules compiled with your kernel.
 	  Saying Y here makes it sometimes possible to use modules
@@ -886,7 +885,6 @@ config MODVERSIONS
 
 config MODULE_SRCVERSION_ALL
 	bool "Source checksum for all modules"
-	depends on MODULES
 	help
 	  Modules which contain a MODULE_VERSION get an extra "srcversion"
 	  field inserted into their modinfo section, which contains a
@@ -898,11 +896,12 @@ config MODULE_SRCVERSION_ALL
 
 config KMOD
 	def_bool y
-	depends on MODULES
 	help
 	  This is being removed soon.  These days, CONFIG_MODULES
 	  implies CONFIG_KMOD, so use that instead.
 
+endif # MODULES
+
 config STOP_MACHINE
 	bool
 	default y
diff --git a/scripts/patch-kernel b/scripts/patch-kernel
index ece46ef..46a59ca 100755
--- a/scripts/patch-kernel
+++ b/scripts/patch-kernel
@@ -213,6 +213,7 @@ fi
 if [ $stopvers != "default" ]; then
 	STOPSUBLEVEL=`echo $stopvers | cut -d. -f3`
 	STOPEXTRA=`echo $stopvers | cut -d. -f4`
+	STOPFULLVERSION=${stopvers%%.$STOPEXTRA}
 	#echo "#___STOPSUBLEVEL=/$STOPSUBLEVEL/, STOPEXTRA=/$STOPEXTRA/"
 else
 	STOPSUBLEVEL=9999
@@ -249,7 +250,7 @@ while :				# incrementing SUBLEVEL (s in v.p.s)
 do
     CURRENTFULLVERSION="$VERSION.$PATCHLEVEL.$SUBLEVEL"
     EXTRAVER=
-    if [ $stopvers = $CURRENTFULLVERSION ]; then
+    if [ $STOPFULLVERSION = $CURRENTFULLVERSION ]; then
         echo "Stopping at $CURRENTFULLVERSION base as requested."
         break
     fi
