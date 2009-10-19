Return-Path: <linux-kernel-owner+w=401wt.eu-S1756047AbZJSLWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbZJSLWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 07:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755827AbZJSLWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 07:22:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46767 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755141AbZJSLWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 07:22:47 -0400
Date: Mon, 19 Oct 2009 13:21:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
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
Message-ID: <20091019112125.GA12829@elte.hu>
References: <20091017000711.16556.69935.stgit@dhcp-100-2-132.bos.redhat.com> <20091017080203.GA4155@elte.hu> <20091017103427.GA31238@elte.hu> <4ADAAF50.9040604@redhat.com> <20091019075103.GF17960@elte.hu> <20091019110055.GA5549@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091019110055.GA5549@nowhere>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Mon, Oct 19, 2009 at 09:51:03AM +0200, Ingo Molnar wrote:
> > > So, what would you think about using -D (def) and -U (undef) ?
> > 
> > The simpest case should be no extra character at all:
> > 
> >   perf probe schedule
> 
> Yeah, I really prefer that too.
> 
> 
>  
> > > > All the other extensions and possibilities - arguments, 
> > > > variables, source code lines, etc. should be natural and 
> > > > intuitive extensions of this basic, minimal syntax.
> > > 
> > > Don't you like current space(' ') separated arguments? :-) I mean, 
> > > what is 'natural' syntax in your opinion?
> > 
> > Yeah, space separated arguments are nice too. The question is how to 
> > specify a more precise coordinate for the bit we want to probe - and 
> > how to specify the information we want to extract. Something like:
> > 
> >   perf schedule+15
> 
> I personally don't imagine common easy usecases that imply relative 
> line offsets but rather absolute lines.

Absolute line numbers could be expressed too, via:

   perf schedule@5396

There's no immediate need to express 'sched.c'. (you can do it, or you 
can do it for extra clarity or for the case of local scope functions of 
which multiple instances exist)

> I guess the most immediate usecase is a direct function probe:
> 
> 	perf probe schedule
> 
> Just to know if a function is matched.

Correct.

> If you want more precision, it also means you have you code editor 
> opened and want to set a precise point. Since you also have the 
> absolute line directly displayed by your editor, you don't want to 
> calculate the relative line but rather the absolute one.

Not necessarily - see below:

> Hmm?
> 
> Hence I rather imagine the following:
> 
> perf probe schedule.c:line
> 
> (Unfortunately, schedule:line is shorter but less intuitive but that 
> could be a shortcut).
> 
> > Or this:
> > 
> >   perf schedule:'switch_count = &prev->nivcsw'
> > 
> > would insert the probe to the source code that matches that statement 
> > pattern. Rarely will people want to insert a probe to an absolutely line 
> > number - that's a usage mode for higher level tools. (so we definitely 
> > want to support it - but it should not use up valuable spots in our 
> > options space.) Same goes for symbol offsets, etc. - humans will rarely 
> > use them.
> 
> I don't understand your point. If your editor is opened and you have 
> the source code in front of you, why would you cut'n'paste a line 
> instead of actually write the line number?

The 'perf probe --list schedule' sub-tool i outlined would display 
relative line numbers for the function - starting at 0:

000	/*
001	 * schedule() is the main scheduler function.
002	 */
003	asmlinkage void __sched schedule(void)
004	{
005		struct task_struct *prev, *next;
006		unsigned long *switch_count;
007		struct rq *rq;
008		int cpu;
009
010	need_resched:
011		preempt_disable();
012		cpu = smp_processor_id();
013		rq = cpu_rq(cpu);
014		rcu_sched_qs(cpu);
015		prev = rq->curr;
016		switch_count = &prev->nivcsw;
017
018		release_kernel_lock(prev);

That way the following two are equivalent:

  perf probe schedule
  perf probe schedule+0

The advantage of relative line numbers is that they are much more 
version invariant than absolute line numbers. Relative line numbers into 
schedule() will only change if the function itself changes.

This means that expressions like 'schedule+16' will have a lot longer 
life-time than absolute line number driven probes. You can quote it in 
an email and chances are that it will still be valid even a few kernel 
releases down the road.

> > We also want to have functionality that helps people find probe 
> > spots within a function:
> > 
> >   perf probe --list-lines schedule
> > 
> > Would list the line numbers and source code of the schedule() 
> > function. (similar to how GDB 'list' works) That way someone can 
> > have an ad-hoc session of deciding what place to probe, and the line 
> > numbers make for an easy ID of the statement to probe.
> 
> Agreed!

Furthermore - to answer another question you raised above - the 
following syntax:

   perf probe schedule:'switch_count = &prev->nivcsw'

is basically a 'fuzzy string match' based probe to within a function. 

For example you might want to probe the point within schedule that calls 
switch_mm() - this could be done via:

   perf probe schedule@switch_mm

Or the point where 'next' gets assigned? Sure, you dont need to even 
open the editor, if you know the rough outline of the function you can 
probe it via:

   perf probe schedule@'next ='

Note that i was able to specify both probes without having opened an 
editor - just based on the general knowledge of the scheduler.

The point is to prefer intuitive, non-mechanic, fundamentally human 
expressions of information above mechanic ones (absolute line numbers, 
addresses, ways of probing, etc.) - and to have a rich variety of them.

String based pattern matching and intuitive syntax that reuses existing 
paradigms of arithmetics and pattern-matching is good - limited syntax 
and extra, arbitrary syntactic hoops to jump through is bad.

If we provide all that, people will start using this stuff - and i'd 
only like to merge this upstream once it's clear that people like me 
will (be able to) use this facility for ad-hoc probe insertion.

In other words: this facility has to 'live within' our source code and 
has to be able to interact with it on a very broad basis - for it to be 
maximally useful for everyday development.

	Ingo
