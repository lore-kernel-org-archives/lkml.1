Return-Path: <linux-kernel-owner+w=401wt.eu-S1754531AbXG1ExX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbXG1ExX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 00:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751200AbXG1ExO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 00:53:14 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:47011 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751148AbXG1ExM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 00:53:12 -0400
Date: Sat, 28 Jul 2007 06:52:47 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
       david@lang.hm, Andrew Morton <akpm@linux-foundation.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [2.6 patch] SOFTWARE_SUSPEND: handle HOTPLUG_CPU automatically
Message-ID: <20070728045247.GF15129@stusta.de>
References: <200707251238.50218.lenb@kernel.org> <200707262117.26353.rjw@sisk.pl> <alpine.LFD.0.999.0707261255380.3442@woody.linux-foundation.org> <200707262248.09187.rjw@sisk.pl> <alpine.LFD.0.999.0707261351430.3442@woody.linux-foundation.org> <20070727222503.GB15129@stusta.de> <alpine.LFD.0.999.0707271545220.3442@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707271545220.3442@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2007 at 03:57:39PM -0700, Linus Torvalds wrote:
> 
> 
> On Sat, 28 Jul 2007, Adrian Bunk wrote:
> > 
> > The dependency of SUSPEND_SMP on HOTPLUG_CPU is quite unintuitive, so 
> > what about something like the patch below?
> 
> Yeah, this looks reasonable.
> 
> May I suggest another level of indirection, though:
> 
> > +config SUSPEND_SMP_POSSIBLE
> > +	bool
> > +	depends on (X86 && !X86_VOYAGER) || (PPC64 && (PPC_PSERIES || PPC_PMAC))
> > +	depends on SMP
> > +	default y
> 
> How about making this a bit more split up, and do it as
> 
> 	# SMP suspend is possible on ..
> 	config SUSPEND_SMP_POSSIBLE
> 		bool
> 		depends on (X86 && !X86_VOYAGER) || (PPC64 && (PPC_PSERIES || PPC_PMAC))
> 		default y
> 
> 	# UP suspend is possible on ..
> 	config SUSPEND_UP_POSSIBLE
> 		bool
> 		depends on X86 || PPC64_SWSUSP || FRV || PPC32
> 		default y 

Sounds good.

> 	# Can we suspend?
> 	config SUSPEND_POSSIBLE
> 		bool
> 		depends on (SMP && SUSPEND_SMP_POSSIBLE) || (SUSPEND_UP_POSSIBLE && !SMP)
> 		default y

IMHO not required:

config SOFTWARE_SUSPEND
	bool "Software Suspend (Hibernation)"
	depends on PM && SWAP
	depends on SUSPEND_UP_POSSIBLE || SUSPEND_SMP_POSSIBLE

> and then we have just a
> 
> 	config SOFTWARE_SUSPEND
> 		bool "Software Suspend (Hibernation)"
> 		depends on PM && SWAP
> 		depends on SUSPEND_POSSIBLE
> 
> 	config SUSPEND_SMP
> 		bool
> 		depends on SOFTWARE_SUSPEND && SMP
> 		select HOTPLUG_CPU
> 		default y
> 
> and now each of the config options looks pretty simple and describe one 
> thing.
> 
> [ For extra bonus points: the SUSPEND_POSSIBLE thing is still pretty 
>   complicated, and it might actually be a better idea to make it a 
>   per-arch config option, and just make the x86/arch say
> 
> 	config SUSPEND_POSSIBLE
> 		bool
> 		depends on !(X86_VOYAGER && SMP)
> 		default y

This would give you "trying to assign nonexistent symbol SUSPEND_POSSIBLE"
kconfig warnings on architectures without SUSPEND_POSSIBLE.

(And you missed the UP case in your example.)

>   instead: since SUSPEND_POSSIBLE is always true on x86 regardless of SMP 
>   or not, just not on X86_VOYAGER. Then, each architecture can have its 
>   own private rules for whether that architecture has SUSPEND_POSSIBLE or 
>   not, so on ppc, it might look like
> 
> 	config SUSPEND_POSSIBLE
> 		bool
> 		depends on (PPC64 && (PPC_PSERIES || PPC_PMAC)) || PPC_SWSUSP
> 		bool y
> 
>   or something, but the point is, now the complexity is a per-architecture 
>   thing, so other architectures simply don't have to care any more! ]
> 
> And the user only ever sees one single question: the one for 
> "SOFTWARE_SUSPEND". All the others would directly flow either from the 
> architecture choice, or from that.
> 
> Anybody willing to rewrite it that way?

Patch below.

> 			Linus

cu
Adrian


<--  snip  -->


An implementation detail of the suspend code that is not intuitive for 
the user is the HOTPLUG_CPU dependency of SOFTWARE_SUSPEND if SMP.

This patch handles the dependency of SOFTWARE_SUSPEND on HOTPLUG_CPU 
automatically without the user requiring to know about it.

Thanks to Stefan Richter and Linus Torvalds for valuable feedback.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 arch/i386/Kconfig    |   16 +++++++++++-----
 arch/powerpc/Kconfig |   11 +++++++++--
 arch/x86_64/Kconfig  |   19 ++++++++++++-------
 kernel/power/Kconfig |   23 +++++++++++++++++------
 4 files changed, 49 insertions(+), 20 deletions(-)

commit bb14e6721dc4e1a97efbfa5398d6021b321af52d
Author: Adrian Bunk <bunk@stusta.de>
Date:   Sat Jul 28 06:47:03 2007 +0200

    asdf

diff --git a/arch/i386/Kconfig b/arch/i386/Kconfig
index abb582b..eb00a12 100644
--- a/arch/i386/Kconfig
+++ b/arch/i386/Kconfig
@@ -903,13 +903,19 @@ config PHYSICAL_ALIGN
 
 	  Don't change this unless you know what you are doing.
 
-config HOTPLUG_CPU
-	bool "Support for suspend on SMP and hot-pluggable CPUs (EXPERIMENTAL)"
+config HOTPLUG_CPU_POSSIBLE
+	bool
 	depends on SMP && HOTPLUG && EXPERIMENTAL && !X86_VOYAGER
+	select SUSPEND_SMP_POSSIBLE
+	default y
+
+config HOTPLUG_CPU
+	bool "Support for hot-pluggable CPUs (EXPERIMENTAL)" if !SUSPEND_SMP
+	depends on HOTPLUG_CPU_POSSIBLE
+	default y if SUSPEND_SMP
 	---help---
-	  Say Y here to experiment with turning CPUs off and on, and to
-	  enable suspend on SMP systems. CPUs can be controlled through
-	  /sys/devices/system/cpu.
+	  Say Y here to experiment with turning CPUs off and on.
+	  CPUs can be controlled through /sys/devices/system/cpu.
 
 config COMPAT_VDSO
 	bool "Compat VDSO support"
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 00099ef..950be0b 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -192,9 +192,16 @@ config IOMMU_VMERGE
 	  from *_map_sg(). Say Y if you know the drivers you are using are
 	  properly handling this case.
 
-config HOTPLUG_CPU
-	bool "Support for enabling/disabling CPUs"
+config HOTPLUG_CPU_POSSIBLE
+	bool
 	depends on SMP && HOTPLUG && EXPERIMENTAL && (PPC_PSERIES || PPC_PMAC)
+	select SUSPEND_SMP_POSSIBLE if PPC64
+	default y
+
+config HOTPLUG_CPU
+	bool "Support for enabling/disabling CPUs (EXPERIMENTAL)" if !SUSPEND_SMP
+	depends on HOTPLUG_CPU_POSSIBLE
+	default y if SUSPEND_SMP
 	---help---
 	  Say Y here to be able to disable and re-enable individual
 	  CPUs at runtime on SMP machines.
diff --git a/arch/x86_64/Kconfig b/arch/x86_64/Kconfig
index 45f82ae..810ed4b 100644
--- a/arch/x86_64/Kconfig
+++ b/arch/x86_64/Kconfig
@@ -443,16 +443,21 @@ config PHYSICAL_ALIGN
 	hex
 	default "0x200000"
 
-config HOTPLUG_CPU
-	bool "Support for suspend on SMP and hot-pluggable CPUs (EXPERIMENTAL)"
+config HOTPLUG_CPU_POSSIBLE
+	bool
 	depends on SMP && HOTPLUG && EXPERIMENTAL
+	select SUSPEND_SMP_POSSIBLE
+	default y
+
+config HOTPLUG_CPU
+	bool "Support for hot-pluggable CPUs (EXPERIMENTAL)" if !SUSPEND_SMP
+	depends on HOTPLUG_CPU_POSSIBLE
+	default y if SUSPEND_SMP
 	help
-		Say Y here to experiment with turning CPUs off and on.  CPUs
-		can be controlled through /sys/devices/system/cpu/cpu#.
-		This is also required for suspend/hibernation on SMP systems.
+	  Say Y here to experiment with turning CPUs off and on.
+	  CPUs can be controlled through /sys/devices/system/cpu/cpu#.
 
-		Say N if you want to disable CPU hotplug and don't need to
-		suspend.
+	  If unsure, say N.
 
 config ARCH_ENABLE_MEMORY_HOTPLUG
 	def_bool y
diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index c1a106d..c7f74ba 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -72,9 +72,25 @@ config PM_TRACE
 	CAUTION: this option will cause your machine's real-time clock to be
 	set to an invalid time after a resume.
 
+config SUSPEND_UP_POSSIBLE
+	bool
+	depends on FRV || PPC32 || PPC64_SWSUSP || X86
+	depends on !SMP
+	default y
+
+# select'ed from arch/<arch>/Kconfig if supported
+config SUSPEND_SMP_POSSIBLE
+	bool
+
+config SUSPEND_SMP
+	bool
+	depends on SUSPEND_SMP_POSSIBLE && SOFTWARE_SUSPEND
+	default y
+
 config SOFTWARE_SUSPEND
 	bool "Software Suspend (Hibernation)"
-	depends on PM && SWAP && (((X86 || PPC64_SWSUSP) && (!SMP || SUSPEND_SMP)) || ((FRV || PPC32) && !SMP))
+	depends on PM && SWAP
+	depends on SUSPEND_UP_POSSIBLE || SUSPEND_SMP_POSSIBLE
 	---help---
 	  Enable the suspend to disk (STD) functionality, which is usually
 	  called "hibernation" in user interfaces.  STD checkpoints the
@@ -132,11 +148,6 @@ config PM_STD_PARTITION
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

