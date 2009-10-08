Return-Path: <linux-kernel-owner+w=401wt.eu-S1758369AbZJHNkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758369AbZJHNkw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 09:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932136AbZJHNkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 09:40:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:45250 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758347AbZJHNku convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 09:40:50 -0400
Date: Thu, 8 Oct 2009 06:40:41 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Frans Pop <elendil@planet.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-wireless@vger.kernel.org
Subject: Re: [.32-rc3] scheduler: iwlagn consistently high in "waiting for
 CPU"
Message-ID: <20091008064041.67219b13@infradead.org>
In-Reply-To: <1254974743.7797.21.camel@marge.simson.net>
References: <200910051500.55875.elendil@planet.nl>
	<200910061749.02805.elendil@planet.nl>
	<200910071910.53907.elendil@planet.nl>
	<200910072034.57511.elendil@planet.nl>
	<1254974743.7797.21.camel@marge.simson.net>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Oct 2009 06:05:43 +0200
Mike Galbraith <efault@gmx.de> wrote:

> On Wed, 2009-10-07 at 20:34 +0200, Frans Pop wrote:
> > On Wednesday 07 October 2009, Frans Pop wrote:
> > > On Tuesday 06 October 2009, Frans Pop wrote:
> > > > I've checked for 2.6.31.1 now and iwlagn is listed high there
> > > > too when the system is idle, but with normal values of 60-100
> > > > ms. And phy0 has normal values of below 10 ms.
> > > > I've now rebooted with today's mainline git; phy0 now
> > > > frequently shows with values of around 100 ms too (i.e. higher
> > > > than last time).
> > >
> > > Mike privately sent me a script to try to capture the latencies
> > > with perf, but the perf output does not show any high latencies
> > > at all. It looks as if we may have found a bug in latencytop here
> > > instead.
> > 
> > Not sure if it's relevant nor what it means, but I frequently see
> > two lines for iwlagn, e.g:
> > 
> >     Scheduler: waiting for cpu              102.4 msec         99.7
> > % .                                         3.3 msec          0.3 %
> > 
> > I get the same results with both latencytop 0.4 and 0.5.
> 
> OK, I see latencytop spikes here on an idle box too, to the tune of up
> to a _second_.  Booting with nohz=off seems to have cured it.

interesting..


by chance, does this patch fix it ?

>From 33725d4939f457b12d7bc1bcbcc0dfb8b2f5bd48 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Thu, 24 Sep 2009 13:24:16 +0200
Subject: [PATCH] x86, timers: check for pending timers after (device) interrupts

Now that range timers and deferred timers are common, I found a
problem with these using the "perf timechart" tool.

It turns out that on x86, these two 'opportunistic' timers only
get checked when another "real" timer happens.
These opportunistic timers have the objective to save power by
hitchhiking on other wakeups, as to avoid CPU wakeups by themselves
as much as possible.

The change in this patch runs this check not only at timer interrupts,
but at all (device) interrupts. The effect is that
1) the deferred timers/range timers get delayed less
2) the range timers cause less wakeups by themselves because
   the percentage of hitchhiking on existing wakeup events goes up.

I've verified the working of the patch using "perf timechart",
the original exposed bug is gone with this patch.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/x86/kernel/irq.c |    2 ++
 arch/x86/kernel/smp.c |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 74656d1..3912061 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -244,6 +244,7 @@ unsigned int __irq_entry do_IRQ(struct pt_regs *regs)
 				__func__, smp_processor_id(), vector, irq);
 	}
 
+	run_local_timers();
 	irq_exit();
 
 	set_irq_regs(old_regs);
@@ -268,6 +269,7 @@ void smp_generic_interrupt(struct pt_regs *regs)
 	if (generic_interrupt_extension)
 		generic_interrupt_extension();
 
+	run_local_timers();
 	irq_exit();
 
 	set_irq_regs(old_regs);
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index ec1de97..d915d95 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -198,6 +198,7 @@ void smp_reschedule_interrupt(struct pt_regs *regs)
 {
 	ack_APIC_irq();
 	inc_irq_stat(irq_resched_count);
+	run_local_timers();
 	/*
 	 * KVM uses this interrupt to force a cpu out of guest mode
 	 */
-- 
1.6.0.6


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
