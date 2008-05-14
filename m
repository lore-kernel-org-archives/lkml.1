Return-Path: <linux-kernel-owner+w=401wt.eu-S1754076AbYENG4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbYENG4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 02:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323AbYENG4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 02:56:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57377 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066AbYENG4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 02:56:36 -0400
Date: Wed, 14 May 2008 08:56:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Andi Kleen <ak@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>,
       Valdis.Kletnieks@vt.edu, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [BISECTED] Lots of "rescheduling IPIs" in powertop
Message-ID: <20080514065605.GB21369@elte.hu>
References: <20080513204206.GA17781@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080513204206.GA17781@damson.getinternet.no>
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


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> Hi,
> 
> Recap: powertop shows between 200-400 wakeups/second with the 
> description "<kernel IPI>: Rescheduling interrupts" when all 
> processors have load (e.g. I need to run two busy-loops on my 2-CPU 
> system for this to show up).

ok, could you try the fix below? It was a mistake to make mwait use 
dependent on power considerations - on a desktop CPU it is unlikely to 
use more power than a simple HLT - and the IPIs are extra scheduling 
latency and extra power used.

	Ingo

-------------->
Subject: x86: remove mwait C-state capability
From: Ingo Molnar <mingo@elte.hu>
Date: Wed May 14 08:47:40 CEST 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/process.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

Index: linux/arch/x86/kernel/process.c
===================================================================
--- linux.orig/arch/x86/kernel/process.c
+++ linux/arch/x86/kernel/process.c
@@ -99,15 +99,6 @@ static void mwait_idle(void)
 		local_irq_enable();
 }
 
-
-static int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
-{
-	if (force_mwait)
-		return 1;
-	/* Any C1 states supported? */
-	return c->cpuid_level >= 5 && ((cpuid_edx(5) >> 4) & 0xf) > 0;
-}
-
 /*
  * On SMP it's slightly faster (but much more power-consuming!)
  * to poll the ->work.need_resched flag instead of waiting for the
@@ -131,7 +122,7 @@ void __cpuinit select_idle_routine(const
 			" performance may degrade.\n");
 	}
 #endif
-	if (cpu_has(c, X86_FEATURE_MWAIT) && mwait_usable(c)) {
+	if (cpu_has(c, X86_FEATURE_MWAIT)) {
 		/*
 		 * Skip, if setup has overridden idle.
 		 * One CPU supports mwait => All CPUs supports mwait
