Return-Path: <linux-kernel-owner+w=401wt.eu-S938254AbXG0WZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938254AbXG0WZk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 18:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765032AbXG0WZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 18:25:29 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:46919 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934915AbXG0WZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 18:25:28 -0400
Date: Sat, 28 Jul 2007 00:25:03 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
       david@lang.hm, Andrew Morton <akpm@linux-foundation.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
Subject: [2.6 patch] let SUSPEND select HOTPLUG_CPU
Message-ID: <20070727222503.GB15129@stusta.de>
References: <200707251238.50218.lenb@kernel.org> <200707262117.26353.rjw@sisk.pl> <alpine.LFD.0.999.0707261255380.3442@woody.linux-foundation.org> <200707262248.09187.rjw@sisk.pl> <alpine.LFD.0.999.0707261351430.3442@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707261351430.3442@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2007 at 01:55:18PM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 26 Jul 2007, Rafael J. Wysocki wrote:
> > 
> > My point is we have ACPI dependent on PM, so if you want ACPI, you end
> > up with all of the STR stuff built in, which is what you don't like (if I
> > understand that correctly).  If we have CONFIG_SUSPEND, you'll be able to
> > choose ACPI alone. :-)
> 
> Good point. 
> 
> Anyway, I think the ACPI problem really is as trivial as the following 
> three-liner removal fix. If the user doesn't want suspend, ACPI shouldn't 
> force it on him.
> 
> A nicer fix might be to also make some of the ACPI helper routines depend 
> on whether they are needed or not (which in turn will depend on whether 
> suspend support has been compiled into the kernel), but quite frankly, 
> that's secondary at least for me.
> 
> So if we have a few ACPI routines that will never get called (because we 
> don't even enable the interfaces that would *cause* them to be called), I 
> don't think that's a huge problem. It's a beauty wart, but nobody really 
> cares (and it's even something that we could get the compiler to optimize 
> away for us if we really cared).
> 
> 		Linus
> 
> ---
>     Don't force-enable suspend/hibernate support just for ACPI
>     
>     It's a totally independent decision for the user whether he wants
>     suspend and/or hibernation support, and ACPI shouldn't care.
>     
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> ---
>  drivers/acpi/Kconfig |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
> index 251344c..22b401b 100644
> --- a/drivers/acpi/Kconfig
> +++ b/drivers/acpi/Kconfig
> @@ -11,9 +11,6 @@ menuconfig ACPI
>  	depends on PCI
>  	depends on PM
>  	select PNP
> -	# for sleep
> -	select HOTPLUG_CPU if X86 && SMP
> -	select SUSPEND_SMP if X86 && SMP
>  	default y
>  	---help---
>  	  Advanced Configuration and Power Interface (ACPI) support for 

The dependency of SUSPEND_SMP on HOTPLUG_CPU is quite unintuitive, so 
what about something like the patch below?

This should address a main issue behind Len's patch.

cu
Adrian


<--  snip  -->


An implementation detail of the suspend code that is not intuitive for 
the user is the HOTPLUG_CPU dependency of SOFTWARE_SUSPEND if SMP.

This patch changes SOFTWARE_SUSPEND if SMP to select HOTPLUG_CPU instead 
of depending on it.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 kernel/power/Kconfig |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -72,9 +72,22 @@ config PM_TRACE
 	CAUTION: this option will cause your machine's real-time clock to be
 	set to an invalid time after a resume.
 
+config SUSPEND_SMP_POSSIBLE
+	bool
+	depends on (X86 && !X86_VOYAGER) || (PPC64 && (PPC_PSERIES || PPC_PMAC))
+	depends on SMP
+	default y
+
+config SUSPEND_SMP
+	bool
+	depends on SUSPEND_SMP_POSSIBLE && SOFTWARE_SUSPEND
+	select HOTPLUG_CPU
+	default y
+
 config SOFTWARE_SUSPEND
 	bool "Software Suspend (Hibernation)"
-	depends on PM && SWAP && (((X86 || PPC64_SWSUSP) && (!SMP || SUSPEND_SMP)) || ((FRV || PPC32) && !SMP))
+	depends on PM && SWAP
+	depends on ((X86 || PPC64_SWSUSP || FRV || PPC32) && !SMP) || SUSPEND_SMP_POSSIBLE
 	---help---
 	  Enable the suspend to disk (STD) functionality, which is usually
 	  called "hibernation" in user interfaces.  STD checkpoints the
@@ -132,11 +145,6 @@ config PM_STD_PARTITION
 	  suspended image to. It will simply pick the first available swap 
 	  device.
 
-config SUSPEND_SMP
-	bool
-	depends on HOTPLUG_CPU && (X86 || PPC64) && PM
-	default y
-
 config APM_EMULATION
 	tristate "Advanced Power Management Emulation"
 	depends on PM && SYS_SUPPORTS_APM_EMULATION

