Return-Path: <linux-kernel-owner+w=401wt.eu-S1753953AbZGTUF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbZGTUF0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 16:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbZGTUFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 16:05:25 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:33311 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbZGTUFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 16:05:23 -0400
Date: Mon, 20 Jul 2009 22:05:22 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: save ARCH & CROSS_COMPILE when building a
	kernel
Message-ID: <20090720200522.GA6854@merkur.ravnborg.org>
References: <20090720100157.GA6467@merkur.ravnborg.org> <1248086059.15751.8405.camel@twins> <20090720115134.GA6517@merkur.ravnborg.org> <1248091243.15751.8550.camel@twins> <20090720171200.GA6730@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090720171200.GA6730@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 07:12:00PM +0200, Sam Ravnborg wrote:
> On Mon, Jul 20, 2009 at 02:00:43PM +0200, Peter Zijlstra wrote:
> > On Mon, 2009-07-20 at 13:51 +0200, Sam Ravnborg wrote:
> > > -if [ -x ~/bin/${CROSS_COMPILE}installkernel ]; then exec ~/bin/${CROSS_COMPILE}installkernel "$@"; fi
> > > -if [ -x /sbin/${CROSS_COMPILE}installkernel ]; then exec /sbin/${CROSS_COMPILE}installkernel "$@"; fi
> > > +for INSTALL in ~/bin/${CROSS_COMPILE} /sbin/${CROSS_COMPILE} ~/bin /sbin/; do
> > > +       if [ -x ${INSTALL}installkernel ]; then
> > > +               exec ${INSTALL}installkernel "$@"
> > > +       fi
> > > +done
> > 
> > Won't that still get upset if CROSS_COMPILE has whitespace in it, which
> > would form weird filenames etc.. or worse, it might match ~/bin/distcc
> 
> The root cause of this is the use of CROSS_COMPILE for the installkernel
> script.
> We know that the CROSS_COMPILE prefix changes with the toolcahin and
> likely is a very personal thing.
> So rather than using CROSS_COMPILE we should let the user override
> the installkernel script used.
> 
> The simplest replacement is the following patch which solves this and
> only people relying on the use of CROSS_COMPILE for installkernel
> needs to change anything.
> 
> Needs to change the other ~20 uses of installkernel if we agree on
> this change.


This is the patch I have cooked up.
I will push that to kbuild-next soon if there is no futher comments.

	Sam

>From 27d34661aed0cd3fbf469b8efb24accaf83c1987 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Mon, 20 Jul 2009 21:37:11 +0200
Subject: [PATCH] kbuild: Use INSTALLKERNEL to select customized installkernel script

Replace the use of CROSS_COMPILE to select a customized
installkernel script with the possibility to set INSTALLKERNEL
to select a custom installkernel script when running make:

    make INSTALLKERNEL=arm-installkernel install

With this patch we are now more consistent across
different architectures - they did not all support use
of CROSS_COMPILE.

The use of CROSS_COMPILE was a hack as this really belongs
to gcc/binutils and the installkernel script does not change
just because we change toolchain.

The use of CROSS_COMPILE caused troubles with an upcoming patch
that saves CROSS_COMPILE when a kernel is built -
it would no longer be installable.
[Thanks to Peter for this hint]

This patch undos what Ian did in commit:

  0f8e2d62fa04441cd12c08ce521e84e5bd3f8a46
  ("use ${CROSS_COMPILE}installkernel in arch/*/boot/install.sh")

The patch has been lightly tested on x86 - but all changes
looks obvious.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ian Campbell <icampbell@arcom.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Documentation/kbuild/kbuild.txt      |   16 ++++++++++++++++
 Makefile                             |    4 +++-
 arch/arm/Makefile                    |    4 ++--
 arch/arm/boot/install.sh             |    4 ++--
 arch/blackfin/Makefile               |    4 ++--
 arch/blackfin/boot/install.sh        |    6 +++---
 arch/ia64/install.sh                 |    4 ++--
 arch/m32r/boot/compressed/install.sh |    4 ++--
 arch/m68k/install.sh                 |    4 ++--
 arch/parisc/Makefile                 |    4 ++--
 arch/parisc/install.sh               |    4 ++--
 arch/powerpc/Makefile                |    4 ++--
 arch/powerpc/boot/install.sh         |    4 ++--
 arch/s390/boot/install.sh            |    4 ++--
 arch/sh/boot/compressed/install.sh   |    4 ++--
 arch/x86/Makefile                    |    4 ++--
 arch/x86/boot/install.sh             |    4 ++--
 17 files changed, 50 insertions(+), 32 deletions(-)

diff --git a/Documentation/kbuild/kbuild.txt b/Documentation/kbuild/kbuild.txt
index f3355b6..bb3bf38 100644
--- a/Documentation/kbuild/kbuild.txt
+++ b/Documentation/kbuild/kbuild.txt
@@ -65,6 +65,22 @@ INSTALL_PATH
 INSTALL_PATH specifies where to place the updated kernel and system map
 images. Default is /boot, but you can set it to other values.
 
+INSTALLKERNEL
+--------------------------------------------------
+Install script called when using "make install".
+The default name is "installkernel".
+
+The script will be called with the following arguments:
+    $1 - kernel version
+    $2 - kernel image file
+    $3 - kernel map file
+    $4 - default install path (use root directory if blank)
+
+The implmentation of "make install" is architecture specific
+and it may differ from the above.
+
+INSTALLKERNEL is provided to enable the possibility to
+specify a custom installer when cross compiling a kernel.
 
 MODLIB
 --------------------------------------------------
diff --git a/Makefile b/Makefile
index 3c95e76..b55b47a 100644
--- a/Makefile
+++ b/Makefile
@@ -342,6 +342,7 @@ OBJCOPY		= $(CROSS_COMPILE)objcopy
 OBJDUMP		= $(CROSS_COMPILE)objdump
 AWK		= awk
 GENKSYMS	= scripts/genksyms/genksyms
+INSTALLKERNEL  := installkernel
 DEPMOD		= /sbin/depmod
 KALLSYMS	= scripts/kallsyms
 PERL		= perl
@@ -380,7 +381,8 @@ KERNELVERSION = $(VERSION).$(PATCHLEVEL).$(SUBLEVEL)$(EXTRAVERSION)
 
 export VERSION PATCHLEVEL SUBLEVEL KERNELRELEASE KERNELVERSION
 export ARCH SRCARCH CONFIG_SHELL HOSTCC HOSTCFLAGS CROSS_COMPILE AS LD CC
-export CPP AR NM STRIP OBJCOPY OBJDUMP MAKE AWK GENKSYMS PERL UTS_MACHINE
+export CPP AR NM STRIP OBJCOPY OBJDUMP
+export MAKE AWK GENKSYMS INSTALLKERNEL PERL UTS_MACHINE
 export HOSTCXX HOSTCXXFLAGS LDFLAGS_MODULE CHECK CHECKFLAGS
 
 export KBUILD_CPPFLAGS NOSTDINC_FLAGS LINUXINCLUDE OBJCOPYFLAGS LDFLAGS
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index c877d6d..a357614 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -266,7 +266,7 @@ define archhelp
   echo  '                  (supply initrd image via make variable INITRD=<path>)'
   echo  '  install       - Install uncompressed kernel'
   echo  '  zinstall      - Install compressed kernel'
-  echo  '                  Install using (your) ~/bin/installkernel or'
-  echo  '                  (distribution) /sbin/installkernel or'
+  echo  '                  Install using (your) ~/bin/$(INSTALLKERNEL) or'
+  echo  '                  (distribution) /sbin/$(INSTALLKERNEL) or'
   echo  '                  install to $$(INSTALL_PATH) and run lilo'
 endef
diff --git a/arch/arm/boot/install.sh b/arch/arm/boot/install.sh
index 9f9bed2..06ea7d4 100644
--- a/arch/arm/boot/install.sh
+++ b/arch/arm/boot/install.sh
@@ -21,8 +21,8 @@
 #
 
 # User may have a custom install script
-if [ -x ~/bin/${CROSS_COMPILE}installkernel ]; then exec ~/bin/${CROSS_COMPILE}installkernel "$@"; fi
-if [ -x /sbin/${CROSS_COMPILE}installkernel ]; then exec /sbin/${CROSS_COMPILE}installkernel "$@"; fi
+if [ -x ~/bin/${INSTALLKERNEL} ]; then exec ~/bin/${INSTALLKERNEL} "$@"; fi
+if [ -x /sbin/${INSTALLKERNEL} ]; then exec /sbin/${INSTALLKERNEL} "$@"; fi
 
 if [ "$(basename $2)" = "zImage" ]; then
 # Compressed install
diff --git a/arch/blackfin/Makefile b/arch/blackfin/Makefile
index 6f9533c..f063b77 100644
--- a/arch/blackfin/Makefile
+++ b/arch/blackfin/Makefile
@@ -155,7 +155,7 @@ define archhelp
   echo  '* vmImage.gz      - Kernel-only image for U-Boot (arch/$(ARCH)/boot/vmImage.gz)'
   echo  '  vmImage.lzma    - Kernel-only image for U-Boot (arch/$(ARCH)/boot/vmImage.lzma)'
   echo  '  install         - Install kernel using'
-  echo  '                     (your) ~/bin/$(CROSS_COMPILE)installkernel or'
-  echo  '                     (distribution) PATH: $(CROSS_COMPILE)installkernel or'
+  echo  '                     (your) ~/bin/$(INSTALLKERNEL) or'
+  echo  '                     (distribution) PATH: $(INSTALLKERNEL) or'
   echo  '                     install to $$(INSTALL_PATH)'
 endef
diff --git a/arch/blackfin/boot/install.sh b/arch/blackfin/boot/install.sh
index 9560a6b..e2c6e40 100644
--- a/arch/blackfin/boot/install.sh
+++ b/arch/blackfin/boot/install.sh
@@ -36,9 +36,9 @@ verify "$3"
 
 # User may have a custom install script
 
-if [ -x ~/bin/${CROSS_COMPILE}installkernel ]; then exec ~/bin/${CROSS_COMPILE}installkernel "$@"; fi
-if which ${CROSS_COMPILE}installkernel >/dev/null 2>&1; then
-	exec ${CROSS_COMPILE}installkernel "$@"
+if [ -x ~/bin/${INSTALLKERNEL} ]; then exec ~/bin/${INSTALLKERNEL} "$@"; fi
+if which ${INSTALLKERNEL} >/dev/null 2>&1; then
+	exec ${INSTALLKERNEL} "$@"
 fi
 
 # Default install - same as make zlilo
diff --git a/arch/ia64/install.sh b/arch/ia64/install.sh
index 929e780..0e932f5 100644
--- a/arch/ia64/install.sh
+++ b/arch/ia64/install.sh
@@ -21,8 +21,8 @@
 
 # User may have a custom install script
 
-if [ -x ~/bin/installkernel ]; then exec ~/bin/installkernel "$@"; fi
-if [ -x /sbin/installkernel ]; then exec /sbin/installkernel "$@"; fi
+if [ -x ~/bin/${INSTALLKERNEL} ]; then exec ~/bin/${INSTALLKERNEL} "$@"; fi
+if [ -x /sbin/${INSTALLKERNEL} ]; then exec /sbin/${INSTALLKERNEL} "$@"; fi
 
 # Default install - same as make zlilo
 
diff --git a/arch/m32r/boot/compressed/install.sh b/arch/m32r/boot/compressed/install.sh
index 6d72e9e..16e5a0a 100644
--- a/arch/m32r/boot/compressed/install.sh
+++ b/arch/m32r/boot/compressed/install.sh
@@ -24,8 +24,8 @@
 
 # User may have a custom install script
 
-if [ -x /sbin/installkernel ]; then
-  exec /sbin/installkernel "$@"
+if [ -x /sbin/${INSTALLKERNEL} ]; then
+  exec /sbin/${INSTALLKERNEL} "$@"
 fi
 
 if [ "$2" = "zImage" ]; then
diff --git a/arch/m68k/install.sh b/arch/m68k/install.sh
index 9c6bae6..57d640d 100644
--- a/arch/m68k/install.sh
+++ b/arch/m68k/install.sh
@@ -33,8 +33,8 @@ verify "$3"
 
 # User may have a custom install script
 
-if [ -x ~/bin/${CROSS_COMPILE}installkernel ]; then exec ~/bin/${CROSS_COMPILE}installkernel "$@"; fi
-if [ -x /sbin/${CROSS_COMPILE}installkernel ]; then exec /sbin/${CROSS_COMPILE}installkernel "$@"; fi
+if [ -x ~/bin/${INSTALLKERNEL} ]; then exec ~/bin/${INSTALLKERNEL} "$@"; fi
+if [ -x /sbin/${INSTALLKERNEL} ]; then exec /sbin/${INSTALLKERNEL} "$@"; fi
 
 # Default install - same as make zlilo
 
diff --git a/arch/parisc/Makefile b/arch/parisc/Makefile
index da6f669..55cca1d 100644
--- a/arch/parisc/Makefile
+++ b/arch/parisc/Makefile
@@ -118,8 +118,8 @@ define archhelp
 	@echo  '* vmlinux	- Uncompressed kernel image (./vmlinux)'
 	@echo  '  palo		- Bootable image (./lifimage)'
 	@echo  '  install	- Install kernel using'
-	@echo  '		  (your) ~/bin/installkernel or'
-	@echo  '		  (distribution) /sbin/installkernel or'
+	@echo  '		  (your) ~/bin/$(INSTALLKERNEL) or'
+	@echo  '		  (distribution) /sbin/$(INSTALLKERNEL) or'
 	@echo  '		  copy to $$(INSTALL_PATH)'
 endef
 
diff --git a/arch/parisc/install.sh b/arch/parisc/install.sh
index 9632b3e..e593fc8 100644
--- a/arch/parisc/install.sh
+++ b/arch/parisc/install.sh
@@ -21,8 +21,8 @@
 
 # User may have a custom install script
 
-if [ -x ~/bin/installkernel ]; then exec ~/bin/installkernel "$@"; fi
-if [ -x /sbin/installkernel ]; then exec /sbin/installkernel "$@"; fi
+if [ -x ~/bin/${INSTALLKERNEL} ]; then exec ~/bin/${INSTALLKERNEL} "$@"; fi
+if [ -x /sbin/${INSTALLKERNEL} ]; then exec /sbin/${INSTALLKERNEL} "$@"; fi
 
 # Default install
 
diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index bc35f4e..2be317d 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -182,8 +182,8 @@ define archhelp
   @echo '  simpleImage.<dt> - Firmware independent image.'
   @echo '  treeImage.<dt>  - Support for older IBM 4xx firmware (not U-Boot)'
   @echo '  install         - Install kernel using'
-  @echo '                    (your) ~/bin/installkernel or'
-  @echo '                    (distribution) /sbin/installkernel or'
+  @echo '                    (your) ~/bin/$(INSTALLKERNEL) or'
+  @echo '                    (distribution) /sbin/$(INSTALLKERNEL) or'
   @echo '                    install to $$(INSTALL_PATH) and run lilo'
   @echo '  *_defconfig     - Select default config from arch/$(ARCH)/configs'
   @echo ''
diff --git a/arch/powerpc/boot/install.sh b/arch/powerpc/boot/install.sh
index 98312d1..b6a256b 100644
--- a/arch/powerpc/boot/install.sh
+++ b/arch/powerpc/boot/install.sh
@@ -23,8 +23,8 @@ set -e
 
 # User may have a custom install script
 
-if [ -x ~/bin/${CROSS_COMPILE}installkernel ]; then exec ~/bin/${CROSS_COMPILE}installkernel "$@"; fi
-if [ -x /sbin/${CROSS_COMPILE}installkernel ]; then exec /sbin/${CROSS_COMPILE}installkernel "$@"; fi
+if [ -x ~/bin/${INSTALLKERNEL} ]; then exec ~/bin/${INSTALLKERNEL} "$@"; fi
+if [ -x /sbin/${INSTALLKERNEL} ]; then exec /sbin/${INSTALLKERNEL} "$@"; fi
 
 # Default install
 
diff --git a/arch/s390/boot/install.sh b/arch/s390/boot/install.sh
index d4026f6..aed3069 100644
--- a/arch/s390/boot/install.sh
+++ b/arch/s390/boot/install.sh
@@ -21,8 +21,8 @@
 
 # User may have a custom install script
 
-if [ -x ~/bin/${CROSS_COMPILE}installkernel ]; then exec ~/bin/${CROSS_COMPILE}installkernel "$@"; fi
-if [ -x /sbin/${CROSS_COMPILE}installkernel ]; then exec /sbin/${CROSS_COMPILE}installkernel "$@"; fi
+if [ -x ~/bin/${INSTALLKERNEL} ]; then exec ~/bin/${INSTALLKERNEL} "$@"; fi
+if [ -x /sbin/${INSTALLKERNEL} ]; then exec /sbin/${INSTALLKERNEL} "$@"; fi
 
 # Default install - same as make zlilo
 
diff --git a/arch/sh/boot/compressed/install.sh b/arch/sh/boot/compressed/install.sh
index 90589f0..f9f4181 100644
--- a/arch/sh/boot/compressed/install.sh
+++ b/arch/sh/boot/compressed/install.sh
@@ -23,8 +23,8 @@
 
 # User may have a custom install script
 
-if [ -x /sbin/installkernel ]; then
-  exec /sbin/installkernel "$@"
+if [ -x /sbin/${INSTALLKERNEL} ]; then
+  exec /sbin/${INSTALLKERNEL} "$@"
 fi
 
 if [ "$2" = "zImage" ]; then
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 1b68659..0b3b961 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -177,8 +177,8 @@ archclean:
 define archhelp
   echo  '* bzImage      - Compressed kernel image (arch/x86/boot/bzImage)'
   echo  '  install      - Install kernel using'
-  echo  '                  (your) ~/bin/installkernel or'
-  echo  '                  (distribution) /sbin/installkernel or'
+  echo  '                  (your) ~/bin/$(INSTALLKERNEL) or'
+  echo  '                  (distribution) /sbin/$(INSTALLKERNEL) or'
   echo  '                  install to $$(INSTALL_PATH) and run lilo'
   echo  '  fdimage      - Create 1.4MB boot floppy image (arch/x86/boot/fdimage)'
   echo  '  fdimage144   - Create 1.4MB boot floppy image (arch/x86/boot/fdimage)'
diff --git a/arch/x86/boot/install.sh b/arch/x86/boot/install.sh
index 8d60ee1..d13ec1c 100644
--- a/arch/x86/boot/install.sh
+++ b/arch/x86/boot/install.sh
@@ -33,8 +33,8 @@ verify "$3"
 
 # User may have a custom install script
 
-if [ -x ~/bin/${CROSS_COMPILE}installkernel ]; then exec ~/bin/${CROSS_COMPILE}installkernel "$@"; fi
-if [ -x /sbin/${CROSS_COMPILE}installkernel ]; then exec /sbin/${CROSS_COMPILE}installkernel "$@"; fi
+if [ -x ~/bin/${INSTALLKERNEL} ]; then exec ~/bin/${INSTALLKERNEL} "$@"; fi
+if [ -x /sbin/${INSTALLKERNEL} ]; then exec /sbin/${INSTALLKERNEL} "$@"; fi
 
 # Default install - same as make zlilo
 
-- 
1.6.2.5

