Return-Path: <linux-kernel-owner+w=401wt.eu-S1755220AbZJTGvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbZJTGvY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 02:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbZJTGvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 02:51:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35609 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbZJTGvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 02:51:22 -0400
Date: Tue, 20 Oct 2009 08:50:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip tracing/kprobes 0/9] tracing/kprobes, perf: perf
	probe and kprobe-tracer bugfixes
Message-ID: <20091020065055.GL8550@elte.hu>
References: <20091017000711.16556.69935.stgit@dhcp-100-2-132.bos.redhat.com> <20091017080203.GA4155@elte.hu> <20091017103427.GA31238@elte.hu> <4ADAAF50.9040604@redhat.com> <20091019075103.GF17960@elte.hu> <20091019110055.GA5549@nowhere> <20091019112125.GA12829@elte.hu> <4ADCC348.2020800@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ADCC348.2020800@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Ah, I've gotten what you said, and many lines will be optimized out it 
> would be better to show line numbers which can be probed, as below.
> 
> 000	asmlinkage void __sched schedule(void)
> 	{
> 		struct task_struct *prev, *next;
> 		unsigned long *switch_count;
> 		struct rq *rq;
> 		int cpu;
> 
> 007	need_resched:
> 008		preempt_disable();
> 009		cpu = smp_processor_id();
> 010		rq = cpu_rq(cpu);
> 011		rcu_sched_qs(cpu);
> 012		prev = rq->curr;
> 013		switch_count = &prev->nivcsw;
> 
> 015		release_kernel_lock(prev);

Agreed, that's a very good idea!

( You could also make use of color_fprintf() to color-code some of the 
  numbers - for example lines with existing probes might be marked red. )

> > That way the following two are equivalent:
> >
> >   perf probe schedule
> >   perf probe schedule+0
> >
> > The advantage of relative line numbers is that they are much more
> > version invariant than absolute line numbers. Relative line numbers into
> > schedule() will only change if the function itself changes.
> >
> > This means that expressions like 'schedule+16' will have a lot longer
> > life-time than absolute line number driven probes. You can quote it in
> > an email and chances are that it will still be valid even a few kernel
> > releases down the road.
> 
> Hmm, I imagines 'schedule() + 16 byte offset' from 'schedule+16', 
> because many in-kernel(and oops) messages means that. :-) So I'd like 
> to use 'schedule:16'.

kernel symbol addresses are in the form of schedule+0x16/0x510.

I like the plus sign because it also allows the negative positions: 
relative position from the _end_ of the function. So for example 
'schedule-1' would probe the (last) return line of the function. 
[admittedly this is not as useful as the + operation though.]

But schedule:16 [and schedule:+16] would be fine too i suspect.

> >>> We also want to have functionality that helps people find probe
> >>> spots within a function:
> >>>
> >>>   perf probe --list-lines schedule
> >>>
> >>> Would list the line numbers and source code of the schedule()
> >>> function. (similar to how GDB 'list' works) That way someone can
> >>> have an ad-hoc session of deciding what place to probe, and the line
> >>> numbers make for an easy ID of the statement to probe.
> >>
> >> Agreed!
> >
> > Furthermore - to answer another question you raised above - the
> > following syntax:
> >
> >    perf probe schedule:'switch_count = &prev->nivcsw'
> >
> > is basically a 'fuzzy string match' based probe to within a function.
> >
> > For example you might want to probe the point within schedule that calls
> > switch_mm() - this could be done via:
> >
> >    perf probe schedule@switch_mm
> >
> > Or the point where 'next' gets assigned? Sure, you dont need to even
> > open the editor, if you know the rough outline of the function you can
> > probe it via:
> >
> >    perf probe schedule@'next ='
> >
> > Note that i was able to specify both probes without having opened an
> > editor - just based on the general knowledge of the scheduler.
> 
> It may be useful for return probe too :-)
> 
>  perf probe schedule@return
> 
> > The point is to prefer intuitive, non-mechanic, fundamentally human
> > expressions of information above mechanic ones (absolute line numbers,
> > addresses, ways of probing, etc.) - and to have a rich variety of them.
> >
> > String based pattern matching and intuitive syntax that reuses existing
> > paradigms of arithmetics and pattern-matching is good - limited syntax
> > and extra, arbitrary syntactic hoops to jump through is bad.
> >
> > If we provide all that, people will start using this stuff - and i'd
> > only like to merge this upstream once it's clear that people like me
> > will (be able to) use this facility for ad-hoc probe insertion.
> >
> > In other words: this facility has to 'live within' our source code and
> > has to be able to interact with it on a very broad basis - for it to be
> > maximally useful for everyday development.
> 
> Hmm, so you mean perf-probe should work with source-code? Without 
> source code (but with debuginfo), maybe we can't use string matching, 
> is that OK?

Well most forms of debuginfo embedd the full source code in the 
debuginfo, right? If it's not there (or we dont know where it is) then 
we cannot use it, obviously.

But we obviously want the whole 'perf probe' workflow to primarily 
operate on source code - we are humans.

	Ingo
