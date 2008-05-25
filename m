Return-Path: <linux-kernel-owner+w=401wt.eu-S1755152AbYEYVJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152AbYEYVJk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 17:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbYEYVJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 17:09:32 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:53265 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbYEYVJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 17:09:31 -0400
Date: Sun, 25 May 2008 23:10:10 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jike Song <albcamus@gmail.com>,
       Gabriel C <nix.or.die@googlemail.com>
Subject: Re: [GIT PULL] kbuild fixes
Message-ID: <20080525211010.GA19126@uranus.ravnborg.org>
References: <20080525071228.GA32120@uranus.ravnborg.org> <20080525183136.GA12806@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080525183136.GA12806@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

I wrote:
> > Sam Ravnborg (1):
> >       Kconfig: add KBUILD_DEFCONFIG to DEFCONFIG_LIST
> 
> And this commit caused my make to enter an
> infinite looke calling scripts/kconfig/conf -s arch/x86/Kconfig
> Reproduceable by:
> make defconfig
> make

The problem was that the environment variable KBUILD_DEFCONFIG
in some cases were not defined and in other cases it was defined.
Fixing this is non-trivial.

So I reverted back to a solution where we have one config symbol
defined in the ARCH specific Kconfig file.
For now only x86 uses this.

Please pull from:

   ssh://master.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-fixes.git

to receive the following updates:

Gabriel C (1):
      scripts/ver_linux use 'gcc -dumpversion'

Jike Song (1):
      .gitignore: match ncscope.out

Sam Ravnborg (1):
      Kconfig: introduce ARCH_DEFCONFIG to DEFCONFIG_LIST

 .gitignore        |    1 +
 arch/x86/Kconfig  |   13 +++----------
 init/Kconfig      |    1 +
 scripts/ver_linux |    5 +----
 4 files changed, 6 insertions(+), 14 deletions(-)


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
index fe361ae..dcbec34 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -26,17 +26,10 @@ config X86
 	select HAVE_KVM if ((X86_32 && !X86_VOYAGER && !X86_VISWS && !X86_NUMAQ) || X86_64)
 	select HAVE_ARCH_KGDB if !X86_VOYAGER
 
-config DEFCONFIG_LIST
+config ARCH_DEFCONFIG
 	string
-	depends on X86_32
-	option defconfig_list
-	default "arch/x86/configs/i386_defconfig"
-
-config DEFCONFIG_LIST
-	string
-	depends on X86_64
-	option defconfig_list
-	default "arch/x86/configs/x86_64_defconfig"
+	default "arch/x86/configs/i386_defconfig" if X86_32
+	default "arch/x86/configs/x86_64_defconfig" if X86_64
 
 
 config GENERIC_LOCKBREAK
diff --git a/init/Kconfig b/init/Kconfig
index 6135d07..6199d11 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -13,6 +13,7 @@ config DEFCONFIG_LIST
 	default "/lib/modules/$UNAME_RELEASE/.config"
 	default "/etc/kernel-config"
 	default "/boot/config-$UNAME_RELEASE"
+	default "$ARCH_DEFCONFIG"
 	default "arch/$ARCH/defconfig"
 
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
 
