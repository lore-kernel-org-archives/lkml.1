Return-Path: <linux-kernel-owner+w=401wt.eu-S1760806AbYDPTzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760806AbYDPTzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 15:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759072AbYDPTzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 15:55:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57570 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757434AbYDPTza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 15:55:30 -0400
Date: Wed, 16 Apr 2008 21:55:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.25 and DEBUG_SECTION_MISMATCH
Message-ID: <20080416195504.GA2408@elte.hu>
References: <20080416175135.GN1677@cs181133002.pp.htv.fi> <20080416192306.GA3090@uranus.ravnborg.org> <20080416193102.GA16981@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080416193102.GA16981@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> * Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > I would prefer we were down to less than 5 warnings so we could 
> > enable it in kconfig but maybe after next merge window.
> 
> they get regenerated. More than 1 out of every 100 new patches. Quite 
> expensive feature (in terms of maintenance overhead) for a rather 
> theoretical memory saving benefit.

in v2.6.24 we had at least 200 section fixes:

  $ git-log v2.6.24.. | egrep -c 'WARNING:.*Section mismatch'
  198

for 12671 commits - that's 1 section type fix for every 60 commits. Even 
considering that in v2.6.24 you did a titanic effort of fixing tons of 
section matches - chances are that we'll still see about 1 section fix 
for every 100 commits in the future too. That's more than 100 section 
mismatch fixes for v2.6.26. That's _much_ more maintenance overhead than 
a lot of _big_ features - and there's no end in sight. x86.git has more 
than 10 section mismatch fixes for about 1000 new patches - that matches 
the 1% cost approximately.

and 90% of the problems could be reduced via the very simple patch below 
...

so ... why shouldnt we say that if someone wants to have this feature, 
it should be done all automatically, in the link space. There's no 
reason why the dependencies couldnt be figured out all automatically.

	Ingo

------------------->
Subject: x86: force __cpuinit on for CONFIG_PM without HOTPLUG_CPU
From: Andi Kleen <ak@suse.de>

This avoids the requirement to mark a lot of initialization functions not
__cpuinit just for resume from RAM.

More functions could be converted now, didn't do all.

Cc: rjw@sisk.pl
Cc: pavel@suse.cz

Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/Kconfig                |    5 +++++
 arch/x86/kernel/cpu/mtrr/main.c |    2 +-
 arch/x86/kernel/trampoline_64.S |    2 +-
 include/linux/init.h            |    2 +-
 4 files changed, 8 insertions(+), 3 deletions(-)

Index: linux/arch/x86/Kconfig
===================================================================
--- linux.orig/arch/x86/Kconfig
+++ linux/arch/x86/Kconfig
@@ -130,6 +130,11 @@ config GENERIC_PENDING_IRQ
 	depends on GENERIC_HARDIRQS && SMP
 	default y
 
+config PM_CPUINIT
+	bool
+	depends on PM
+	default y
+
 config X86_SMP
 	bool
 	depends on SMP && ((X86_32 && !X86_VOYAGER) || X86_64)
Index: linux/arch/x86/kernel/cpu/mtrr/main.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ linux/arch/x86/kernel/cpu/mtrr/main.c
@@ -712,7 +712,7 @@ void __init mtrr_bp_init(void)
 	}
 }
 
-void mtrr_ap_init(void)
+void __cpuinit mtrr_ap_init(void)
 {
 	unsigned long flags;
 
Index: linux/arch/x86/kernel/trampoline_64.S
===================================================================
--- linux.orig/arch/x86/kernel/trampoline_64.S
+++ linux/arch/x86/kernel/trampoline_64.S
@@ -34,7 +34,7 @@
 #include <asm/segment.h>
 
 /* We can free up trampoline after bootup if cpu hotplug is not supported. */
-#ifndef CONFIG_HOTPLUG_CPU
+#if !defined(CONFIG_HOTPLUG_CPU) && !defined(CONFIG_PM_CPUINIT)
 .section .init.data, "aw", @progbits
 #else
 .section .rodata, "a", @progbits
Index: linux/include/linux/init.h
===================================================================
--- linux.orig/include/linux/init.h
+++ linux/include/linux/init.h
@@ -266,7 +266,7 @@ void __init parse_early_param(void);
 #define __devexitdata __exitdata
 #endif
 
-#ifdef CONFIG_HOTPLUG_CPU
+#if defined(CONFIG_HOTPLUG_CPU) || defined(CONFIG_PM_CPUINIT)
 #define __cpuinit
 #define __cpuinitdata
 #define __cpuexit
