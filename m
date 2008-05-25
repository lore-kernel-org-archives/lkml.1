Return-Path: <linux-kernel-owner+w=401wt.eu-S1754843AbYEYGWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbYEYGWS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 02:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751026AbYEYGWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 02:22:07 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:39674 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065AbYEYGWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 02:22:06 -0400
Date: Sun, 25 May 2008 08:22:10 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] x86: use defconfig as last resort
Message-ID: <20080525062210.GA31195@uranus.ravnborg.org>
References: <20080524192540.GA28067@uranus.ravnborg.org> <alpine.LFD.1.10.0805241320200.3081@woody.linux-foundation.org> <20080524203748.GA2343@uranus.ravnborg.org> <alpine.LFD.1.10.0805241825460.3081@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805241825460.3081@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Wouldn't this be cleaner as just *one* entry, and then just have 
> different default statements, ie something like
> 
>     config DEFCONFIG_LIST
> 	string
> 	option defconfig_list
> 	default "arch/x86/configs/i386_defconfig" if X86_32
> 	default "arch/x86/configs/x86_64_defconfig" if X86_64
> 
> instead?

Following patch moves the stuff away from the arch
specific Kconfig file and works at least for
x86 and alpha.
It uses the already defined environment variables to locate
the defconfig and try known locations.

	Sam

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
 
