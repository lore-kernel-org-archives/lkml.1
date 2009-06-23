Return-Path: <linux-kernel-owner+w=401wt.eu-S1759335AbZFWQ4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759335AbZFWQ4d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 12:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754164AbZFWQ4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 12:56:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38189 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754464AbZFWQ4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 12:56:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: kerneloops.org report for the week of June 14 2009
Date: Tue, 23 Jun 2009 18:56:23 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rjw; KDE/4.2.4; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Len Brown <lenb@kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
References: <20090614173331.18f01123@infradead.org> <alpine.LFD.2.00.0906231201430.2767@localhost.localdomain> <20090623115510.GC9497@elte.hu>
In-Reply-To: <20090623115510.GC9497@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906231856.24959.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 June 2009, Ingo Molnar wrote:
> 
> * Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > On Sun, 14 Jun 2009, Arjan van de Ven wrote:
> > > Rank 3: getnstimeofday (warning)
> > > 	Reported 309 times (2446 total reports)
> > > 	[suspend resume] getnstimeofday() is called before timekeeping is
> >         resumed
> > 
> > > Rank 6: hres_timers_resume (warning)
> > > 	Reported 188 times (1024 total reports)
> > > 	[suspend resume] hres_timers_resume() is incorrectly called with
> > >       interrupts on
> > 
> > Both have the same root cause. Something enables interrupts in the 
> > early resume path. IIRC, there was a culprit identified recently. 
> > Rafael ?

Apparently, we have smp_call_function_single() called from cpufreq_suspend
via acpi_cpufreq somehow, but I'm still to figure out how this happens.

> This can be debugged automatically today, using lockdep, by using a 
> 'helper lock':
> 
>   static DEFINE_PER_CPU(struct lockdep_map, helper_lock);
> 
> Then mark the lock irq-safe by doing something like:
> 
> static void mark_lock_irqsafe(void)
> {
> 	unsigned long flags;
> 	int cpu;
> 
> 	local_irq_save(flags);
> 	irq_enter(0);
> 
> 	for_each_online_cpu(cpu) {
> 		lock_acquire(&per_cpu(helper_lock, cpu), 0, 0, 0, 0, NULL, 0);
> 		lock_release(&per_cpu(helper_lock, cpu), 0, 0, 0, 0, NULL, 0);
> 	}
> 
> 	irq_exit(0);
> 	local_irq_restore(flags);
> }
> 
> Then, the resume path, when it disables irqs, you can disallow 
> irq-enable via:
> 
> 	local_irq_disable();
> 	lock_acquire(&__get_cpu_var(helper_lock), 0, 0, 0, 0, NULL, 0);
> 	...
> 	<extensive suspend or resume codepaths, callbacks> 
> 	...
> 	lock_release(&__get_cpu_var(helper_lock), 0, 0, 0, 0, NULL, 0);
> 	local_irq_enable();
> 
> And lockdep will warn if any function inbetween enables IRQs, by 
> emitting a splat about incorrectly enabled hardirqs. It will warn 
> about the specific place and will emit a relevant backtrace, - not 
> just the handler in general.
> 
> This should work just fine with current lockdep facilities.
> 
> Rafael?

We have some debug code for checking interrupts disabled in sysdev_suspend
and sysdev_resume already and these reports are from 2.6.29 where that code
was not present.

The long term solution for the issue at hand is to clean up the suspend-resume
support in cpufreq so that it doesn't do stupid things like calling
smp_call_function_single() with interrupts disabled, but that requires someone
(I can do it, but I need to dig through the cpufreq code for this purpose) to
figure out how to fix it.

I'm not quite sure if there's an acceptable short term solution, though.

In principle we can do

local_irq_save()
...
local_irq_restore()

around each sysdevs ->susend() and ->resume() in addition to checking the
status of interrupts.  Would that work?

Rafael
