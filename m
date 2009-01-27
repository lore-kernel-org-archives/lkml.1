Return-Path: <linux-kernel-owner+w=401wt.eu-S1754229AbZA0P3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbZA0P3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 10:29:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755682AbZA0P3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 10:29:18 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60300 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755519AbZA0P3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 10:29:16 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [Linux 2.6.29-rc2] BUG: using smp_processor_id() in preemptible
Date: Tue, 27 Jan 2009 16:28:53 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: =?iso-8859-1?q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <8db1092f0901170058k325dc6ddtddb42deea1ddd098@mail.gmail.com> <200901262148.49717.rjw@sisk.pl> <20090126213519.GB13670@elte.hu>
In-Reply-To: <20090126213519.GB13670@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901271628.54037.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 January 2009, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > On Monday 26 January 2009, Ingo Molnar wrote:
> [...]
> > > It would work like this, you could mark IRQs as disabled 'permanently':
> > > 
> > >    force_irqs_off_start();
> > >    ...
> > >    force_irqs_off_end();
> > > 
> > > you could mark an arbitrarily complex code sequence that way, and ftrace 
> > > would emit a WARN_ONCE() if irqs are enable anytime during that sequence - 
> > > by using the irq-tracking facilities we have for the irqsoff tracer (and 
> > > which we also have for lockdep).
> > > 
> > > Would that be useful?
> > 
> > Not sure, I only know a little about ftrace, I really can't judge.
> 
> The instrumentation is really simple, see kernel/tracing/trace_irqsoff.c:
> 
> we call this function if hardirqs are disabled anywhere in the kernel:
> 
>  static inline void
>  start_critical_timing(unsigned long ip, unsigned long parent_ip)
> 
> and we call this function if hardirqs are enabled anywhere in the kernel:
> 
>  static inline void
>  stop_critical_timing(unsigned long ip, unsigned long parent_ip)
> 
> that's all. You need a single line check in stop_critical_timing(), 
> something like this:
> 
>    WARN_ON_ONCE(per_cpu(hardirqs_forced_off, this_cpu));
>
> > Anyway, I think that putting the checks directly into the code path in 
> > question would be more reliable and would still work without ftrace.
> 
> More reliable than a WARN() triggering right at the buggy place that 
> erroneously enables IRQs? Regardless of how obscurely it's done - whether 
> it's a side effect of something, etc. etc.?

Actually, yes.
 
> With such a generic facility you'd not have to put in any explicit checks 
> anywhere _at all_.

That's under the assumption that the traces we get are always useful.

> In fact whatever check you put in it's _always_ going to be fundamentally 
> more fragile than direct instrumentation: you cannot possibly check all 
> possible places that enable interrupts. (they could be disabling 
> interrupts as a _restore_irqs() sequence for example)

In this particular case, I'm not really interested in that.  What I'm
interested in is which driver's ->suspend_late() or ->resume_early() (or the
equivalents for sysdevs) has enabled interrupts, which is quite easy to
check directly.

Thanks,
Rafael
