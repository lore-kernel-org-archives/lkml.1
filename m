Return-Path: <linux-kernel-owner+w=401wt.eu-S1754223AbYEYHMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbYEYHMA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 03:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbYEYHLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 03:11:50 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:49516 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775AbYEYHLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 03:11:49 -0400
Date: Sun, 25 May 2008 09:12:28 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jike Song <albcamus@gmail.com>,
       Gabriel C <nix.or.die@googlemail.com>
Subject: [GIT PULL] kbuild fixes
Message-ID: <20080525071228.GA32120@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

Please pull from:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-fixes.git

This fixes the 'make oldconfig' regression you reported.
And in addition a small .gitignore and ver_linux update.

	Sam

The pull includes the following patches:

Gabriel C (1):
      scripts/ver_linux use 'gcc -dumpversion'

Jike Song (1):
      .gitignore: match ncscope.out

Sam Ravnborg (1):
      Kconfig: add KBUILD_DEFCONFIG to DEFCONFIG_LIST


 .gitignore        |    1 +
 arch/x86/Kconfig  |   13 -------------
 init/Kconfig      |   11 ++++++++++-
 scripts/ver_linux |    5 +----
 4 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/.gitignore b/.gitignore
index 9c0d650..d24ad50 100644
--- a/.gitignore
+++ b/.gitignore
@@ -52,6 +52,7 @@ series
 
 # cscope files
 cscope.*
+ncscope.*
 
 *.orig
 *~
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index fe361ae..6a4b98e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -26,19 +26,6 @@ config X86
 	select HAVE_KVM if ((X86_32 && !X86_VOYAGER && !X86_VISWS && !X86_NUMAQ) || X86_64)
 	select HAVE_ARCH_KGDB if !X86_VOYAGER
 
-config DEFCONFIG_LIST
-	string
-	depends on X86_32
-	option defconfig_list
-	default "arch/x86/configs/i386_defconfig"
-
-config DEFCONFIG_LIST
-	string
-	depends on X86_64
-	option defconfig_list
-	default "arch/x86/configs/x86_64_defconfig"
-
-
 config GENERIC_LOCKBREAK
 	def_bool n
 
diff --git a/init/Kconfig b/init/Kconfig
index 6135d07..2aa7180 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -6,6 +6,14 @@ config KERNELVERSION
 	string
 	option env="KERNELVERSION"
 
+config KBUILD_DEFCONFIG
+	string
+	option env="KBUILD_DEFCONFIG"
+
+config SRCARCH
+	string
+	option env="SRCARCH"
+
 config DEFCONFIG_LIST
 	string
 	depends on !UML
@@ -13,7 +21,8 @@ config DEFCONFIG_LIST
 	default "/lib/modules/$UNAME_RELEASE/.config"
 	default "/etc/kernel-config"
 	default "/boot/config-$UNAME_RELEASE"
-	default "arch/$ARCH/defconfig"
+	default "arch/$SRCARCH/configs/$KBUILD_DEFCONFIG"
+	default "arch/$SRCARCH/defconfig"
 
 menu "General setup"
 
diff --git a/scripts/ver_linux b/scripts/ver_linux
index ab69ece..7ac0e30 100755
--- a/scripts/ver_linux
+++ b/scripts/ver_linux
@@ -12,12 +12,9 @@ echo ' '
 uname -a
 echo ' '
 
-gcc --version 2>&1| head -n 1 | grep -v gcc | awk \
+gcc -dumpversion 2>&1| awk \
 'NR==1{print "Gnu C                 ", $1}'
 
-gcc --version 2>&1| grep gcc | awk \
-'NR==1{print "Gnu C                 ", $3}'
-
 make --version 2>&1 | awk -F, '{print $1}' | awk \
       '/GNU Make/{print "Gnu make              ",$NF}'
 
