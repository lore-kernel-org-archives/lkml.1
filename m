Return-Path: <linux-kernel-owner+w=401wt.eu-S1756401AbYBPLgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401AbYBPLgT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 06:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbYBPLgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 06:36:06 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:41033 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254AbYBPLgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 06:36:01 -0500
Date: Sat, 16 Feb 2008 12:36:10 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Roland McGrath <roland@redhat.com>
Cc: Rene Herman <rene.herman@keyaccess.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-kbuild@vger.kernel.org
Subject: Re: 2.6.25-rc2 vdso_install breaks user "make install"
Message-ID: <20080216113610.GB11362@uranus.ravnborg.org>
References: <47B6592A.6030200@keyaccess.nl> <20080216034211.8DD03270193@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080216034211.8DD03270193@magilla.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 07:42:11PM -0800, Roland McGrath wrote:
> Perhaps it makes more sense to have vdso_install be a dependency of
> modules_install rather than install, since they both put things in /lib/modules.
> The installed vdso images are potentially useful for a kernel when you
> aren't bothering to build or install any modules, but those images are only
> ever useful for sophisticated debugging uses anyway.
> 
> Sam, any thoughts?  (See arch/x86/Makefile and arch/powerpc/Makefile.)

Installing the vdso files as aprt of modules_install would be
unintuitive as this has nothing to do with modules.

And since you wrote:
> useful for sophisticated debugging uses anyway
I suggest to make the vdso_install step independent as
in following patch.
[Note: help docs needs to mention the new target].

This solves the issue at ahnd and still gives us the posibility
to install the files should they be needed.

	Sam

diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index 6845482..1c6ce35 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -176,7 +176,7 @@ define archhelp
   @echo '  *_defconfig     - Select default config from arch/$(ARCH)/configs'
 endef
 
-install: vdso_install
+install:
 	$(Q)$(MAKE) $(build)=$(boot) install
 
 vdso_install:
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 204af43..f1e739a 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -229,7 +229,7 @@ zdisk bzdisk: vmlinux
 fdimage fdimage144 fdimage288 isoimage: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(KBUILD_IMAGE) $@
 
-install: vdso_install
+install:
 	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(KBUILD_IMAGE) install
 
 PHONY += vdso_install
