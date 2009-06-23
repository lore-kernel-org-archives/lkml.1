Return-Path: <linux-kernel-owner+w=401wt.eu-S1759015AbZFWOuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759015AbZFWOuY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 10:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbZFWOuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 10:50:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:38815 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbZFWOuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 10:50:12 -0400
Date: Tue, 23 Jun 2009 07:50:48 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: kerneloops.org report for the week of June 14 2009
Message-ID: <20090623075048.36f50deb@infradead.org>
In-Reply-To: <20090623115510.GC9497@elte.hu>
References: <20090614173331.18f01123@infradead.org>
	<alpine.LFD.2.00.0906231201430.2767@localhost.localdomain>
	<20090623115510.GC9497@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009 13:55:10 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > On Sun, 14 Jun 2009, Arjan van de Ven wrote:
> > > Rank 3: getnstimeofday (warning)
> > > 	Reported 309 times (2446 total reports)
> > > 	[suspend resume] getnstimeofday() is called before
> > > timekeeping is
> >         resumed
> > 
> > > Rank 6: hres_timers_resume (warning)
> > > 	Reported 188 times (1024 total reports)
> > > 	[suspend resume] hres_timers_resume() is incorrectly
> > > called with interrupts on
> > 
> > Both have the same root cause. Something enables interrupts in the 
> > early resume path. IIRC, there was a culprit identified recently. 
> > Rafael ?
> 
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
> 		lock_acquire(&per_cpu(helper_lock, cpu), 0, 0, 0, 0,
> NULL, 0); lock_release(&per_cpu(helper_lock, cpu), 0, 0, 0, 0, NULL,
> 0); }
> 
> 	irq_exit(0);
> 	local_irq_restore(flags);
> }
> 
> Then, the resume path, when it disables irqs, you can disallow 
> irq-enable via:
> 
> 	local_irq_disable();
> 	lock_acquire(&__get_cpu_var(helper_lock), 0, 0, 0, 0, NULL,
> 0); ...
> 	<extensive suspend or resume codepaths, callbacks> 
> 	...
> 	lock_release(&__get_cpu_var(helper_lock), 0, 0, 0, 0, NULL,
> 0); local_irq_enable();
> 
> And lockdep will warn if any function inbetween enables IRQs, by 
> emitting a splat about incorrectly enabled hardirqs. It will warn 
> about the specific place and will emit a relevant backtrace, - not 
> just the handler in general.

looks like an interesting approach; it'll pinpoint the bad guy exactly
where he's enabling interrupts.. (assuming he's using kernel facilities
of course)



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
