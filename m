Return-Path: <linux-kernel-owner+w=401wt.eu-S1753548AbZAZVgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbZAZVgA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 16:36:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752134AbZAZVfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 16:35:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46659 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019AbZAZVfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 16:35:50 -0500
Date: Mon, 26 Jan 2009 22:35:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Linux 2.6.29-rc2] BUG: using smp_processor_id() in preemptible
Message-ID: <20090126213519.GB13670@elte.hu>
References: <8db1092f0901170058k325dc6ddtddb42deea1ddd098@mail.gmail.com> <200901262021.23763.rjw@sisk.pl> <20090126203559.GD8867@elte.hu> <200901262148.49717.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901262148.49717.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> On Monday 26 January 2009, Ingo Molnar wrote:
[...]
> > It would work like this, you could mark IRQs as disabled 'permanently':
> > 
> >    force_irqs_off_start();
> >    ...
> >    force_irqs_off_end();
> > 
> > you could mark an arbitrarily complex code sequence that way, and ftrace 
> > would emit a WARN_ONCE() if irqs are enable anytime during that sequence - 
> > by using the irq-tracking facilities we have for the irqsoff tracer (and 
> > which we also have for lockdep).
> > 
> > Would that be useful?
> 
> Not sure, I only know a little about ftrace, I really can't judge.

The instrumentation is really simple, see kernel/tracing/trace_irqsoff.c:

we call this function if hardirqs are disabled anywhere in the kernel:

 static inline void
 start_critical_timing(unsigned long ip, unsigned long parent_ip)

and we call this function if hardirqs are enabled anywhere in the kernel:

 static inline void
 stop_critical_timing(unsigned long ip, unsigned long parent_ip)

that's all. You need a single line check in stop_critical_timing(), 
something like this:

   WARN_ON_ONCE(per_cpu(hardirqs_forced_off, this_cpu));

> Anyway, I think that putting the checks directly into the code path in 
> question would be more reliable and would still work without ftrace.

More reliable than a WARN() triggering right at the buggy place that 
erroneously enables IRQs? Regardless of how obscurely it's done - whether 
it's a side effect of something, etc. etc.?

With such a generic facility you'd not have to put in any explicit checks 
anywhere _at all_.

In fact whatever check you put in it's _always_ going to be fundamentally 
more fragile than direct instrumentation: you cannot possibly check all 
possible places that enable interrupts. (they could be disabling 
interrupts as a _restore_irqs() sequence for example)

	Ingo
