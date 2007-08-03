Return-Path: <linux-kernel-owner+w=401wt.eu-S1764260AbXHCWix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764260AbXHCWix (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 18:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758044AbXHCWio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 18:38:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47070 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756290AbXHCWin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 18:38:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] PM: Fix dependencies of CONFIG_SUSPEND and CONFIG_HIBERNATION
Date: Sat, 4 Aug 2007 00:47:34 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>
References: <200708032359.37677.rjw@sisk.pl> <alpine.LFD.0.999.0708031459090.8184@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0708031459090.8184@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708040047.35180.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 4 August 2007 00:01, Linus Torvalds wrote:
> 
> On Fri, 3 Aug 2007, Rafael J. Wysocki wrote:
> >  	depends on PM
> > -	depends on !SMP || SUSPEND_SMP_POSSIBLE
> > +	depends on SUSPEND_SMP_POSSIBLE || ((BLACKFIN || MIPS || SUPERH || FRV \
> > +		    || (PPC32 && PPC_MPC52xx)) && !SMP)
> 
> Please, do that as SUSPEND_UP_POSSIBLE, and make it look like
> 
> 	config SUSPEND_UP_POSSIBLE
> 		depends on BLACKFIN || MIPS || SUPERH || FRV || ((PPC32 && PPC_MPC52xx)
> 		depends on !SMP
> 		default y

OK

> and now you can write the above thing as
> 
> 	depends on SUSPEND_SMP_POSSIBLE || SUSPEND_UP_POSSIBLE
> 
> and it's all much nicer.
> 
> I would say that doing a similar setup for HIBERNATE would be nice too,
> but the SUSPEND case is more noticeable because the SMP case is so nice 
> already.

I did it symmetrically for suspend and hibernation and renamed SUSPEND_SMP to
PM_SLEEP_SMP.  Patch follows.

Greetings,
Rafael


---
From: Rafael J. Wysocki <rjw@sisk.pl>

Dependencies of CONFIG_SUSPEND and CONFIG_HIBERNATION introduced by commit
296699de6bdc717189a331ab6bbe90e05c94db06 "Introduce CONFIG_SUSPEND for
suspend-to-Ram and standby" are incorrect, as they don't cover the facts that
(1) not all architectures support suspend and (2) SMP hibernation is only
possible on X86 and PPC64 (if PPC64_SWSUSP is set).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/Kconfig |   40 ++++++++++++++++++++++++++++++----------
 1 file changed, 30 insertions(+), 10 deletions(-)

Index: linux-2.6/kernel/power/Kconfig
===================================================================
--- linux-2.6.orig/kernel/power/Kconfig	2007-07-30 07:58:48.000000000 +0200
+++ linux-2.6/kernel/power/Kconfig	2007-08-04 00:39:21.000000000 +0200
@@ -72,15 +72,10 @@ config PM_TRACE
 	CAUTION: this option will cause your machine's real-time clock to be
 	set to an invalid time after a resume.
 
-config SUSPEND_SMP_POSSIBLE
-	bool
-	depends on (X86 && !X86_VOYAGER) || (PPC64 && (PPC_PSERIES || PPC_PMAC))
-	depends on SMP
-	default y
-
-config SUSPEND_SMP
+config PM_SLEEP_SMP
 	bool
-	depends on SUSPEND_SMP_POSSIBLE && PM_SLEEP
+	depends on SUSPEND_SMP_POSSIBLE || HIBERNATION_SMP_POSSIBLE
+	depends on PM_SLEEP
 	select HOTPLUG_CPU
 	default y
 
@@ -89,20 +84,45 @@ config PM_SLEEP
 	depends on SUSPEND || HIBERNATION
 	default y
 
+config SUSPEND_UP_POSSIBLE
+	bool
+	depends on BLACKFIN || MIPS || SUPERH || FRV || (PPC32 && PPC_MPC52xx)
+	depends on !SMP
+	default y
+
+config SUSPEND_SMP_POSSIBLE
+	bool
+	depends on (X86 && !X86_VOYAGER) \
+		   || (PPC64 && (PPC_PSERIES || PPC_PMAC)) || ARM
+	depends on SMP
+	default y
+
 config SUSPEND
 	bool "Suspend to RAM and standby"
 	depends on PM
-	depends on !SMP || SUSPEND_SMP_POSSIBLE
+	depends on SUSPEND_UP_POSSIBLE || SUSPEND_SMP_POSSIBLE
 	default y
 	---help---
 	  Allow the system to enter sleep states in which main memory is
 	  powered and thus its contents are preserved, such as the
 	  suspend-to-RAM state (i.e. the ACPI S3 state).
 
+config HIBERNATION_UP_POSSIBLE
+	bool
+	depends on X86 || PPC64_SWSUSP || FRV || PPC32
+	depends on !SMP
+	default y
+
+config HIBERNATION_SMP_POSSIBLE
+	bool
+	depends on (X86 && !X86_VOYAGER) || PPC64_SWSUSP
+	depends on SMP
+	default y
+
 config HIBERNATION
 	bool "Hibernation (aka 'suspend to disk')"
 	depends on PM && SWAP
-	depends on ((X86 || PPC64_SWSUSP || FRV || PPC32) && !SMP) || SUSPEND_SMP_POSSIBLE
+	depends on HIBERNATION_UP_POSSIBLE || HIBERNATION_SMP_POSSIBLE
 	---help---
 	  Enable the suspend to disk (STD) functionality, which is usually
 	  called "hibernation" in user interfaces.  STD checkpoints the
