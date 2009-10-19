Return-Path: <linux-kernel-owner+w=401wt.eu-S1757409AbZJSTuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409AbZJSTuZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 15:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757325AbZJSTuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 15:50:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172AbZJSTuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 15:50:24 -0400
Message-ID: <4ADCC348.2020800@redhat.com>
Date: Mon, 19 Oct 2009 15:51:36 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
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
References: <20091017000711.16556.69935.stgit@dhcp-100-2-132.bos.redhat.com> <20091017080203.GA4155@elte.hu> <20091017103427.GA31238@elte.hu> <4ADAAF50.9040604@redhat.com> <20091019075103.GF17960@elte.hu> <20091019110055.GA5549@nowhere> <20091019112125.GA12829@elte.hu>
In-Reply-To: <20091019112125.GA12829@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> The 'perf probe --list schedule' sub-tool i outlined would display
> relative line numbers for the function - starting at 0:
>
> 000	/*
> 001	 * schedule() is the main scheduler function.
> 002	 */
> 003	asmlinkage void __sched schedule(void)
> 004	{
> 005		struct task_struct *prev, *next;
> 006		unsigned long *switch_count;
> 007		struct rq *rq;
> 008		int cpu;
> 009
> 010	need_resched:
> 011		preempt_disable();
> 012		cpu = smp_processor_id();
> 013		rq = cpu_rq(cpu);
> 014		rcu_sched_qs(cpu);
> 015		prev = rq->curr;
> 016		switch_count = &prev->nivcsw;
> 017
> 018		release_kernel_lock(prev);

Ah, I've gotten what you said, and many lines will be optimized out
it would be better to show line numbers which can be probed, as below.

000	asmlinkage void __sched schedule(void)
	{
		struct task_struct *prev, *next;
		unsigned long *switch_count;
		struct rq *rq;
		int cpu;

007	need_resched:
008		preempt_disable();
009		cpu = smp_processor_id();
010		rq = cpu_rq(cpu);
011		rcu_sched_qs(cpu);
012		prev = rq->curr;
013		switch_count = &prev->nivcsw;

015		release_kernel_lock(prev);


> That way the following two are equivalent:
>
>   perf probe schedule
>   perf probe schedule+0
>
> The advantage of relative line numbers is that they are much more
> version invariant than absolute line numbers. Relative line numbers into
> schedule() will only change if the function itself changes.
>
> This means that expressions like 'schedule+16' will have a lot longer
> life-time than absolute line number driven probes. You can quote it in
> an email and chances are that it will still be valid even a few kernel
> releases down the road.

Hmm, I imagines 'schedule() + 16 byte offset' from 'schedule+16', because
many in-kernel(and oops) messages means that. :-)
So I'd like to use 'schedule:16'.

>>> We also want to have functionality that helps people find probe
>>> spots within a function:
>>>
>>>   perf probe --list-lines schedule
>>>
>>> Would list the line numbers and source code of the schedule()
>>> function. (similar to how GDB 'list' works) That way someone can
>>> have an ad-hoc session of deciding what place to probe, and the line
>>> numbers make for an easy ID of the statement to probe.
>>
>> Agreed!
>
> Furthermore - to answer another question you raised above - the
> following syntax:
>
>    perf probe schedule:'switch_count = &prev->nivcsw'
>
> is basically a 'fuzzy string match' based probe to within a function.
>
> For example you might want to probe the point within schedule that calls
> switch_mm() - this could be done via:
>
>    perf probe schedule@switch_mm
>
> Or the point where 'next' gets assigned? Sure, you dont need to even
> open the editor, if you know the rough outline of the function you can
> probe it via:
>
>    perf probe schedule@'next ='
>
> Note that i was able to specify both probes without having opened an
> editor - just based on the general knowledge of the scheduler.

It may be useful for return probe too :-)

 perf probe schedule@return

> The point is to prefer intuitive, non-mechanic, fundamentally human
> expressions of information above mechanic ones (absolute line numbers,
> addresses, ways of probing, etc.) - and to have a rich variety of them.
>
> String based pattern matching and intuitive syntax that reuses existing
> paradigms of arithmetics and pattern-matching is good - limited syntax
> and extra, arbitrary syntactic hoops to jump through is bad.
>
> If we provide all that, people will start using this stuff - and i'd
> only like to merge this upstream once it's clear that people like me
> will (be able to) use this facility for ad-hoc probe insertion.
>
> In other words: this facility has to 'live within' our source code and
> has to be able to interact with it on a very broad basis - for it to be
> maximally useful for everyday development.

Hmm, so you mean perf-probe should work with source-code?
Without source code (but with debuginfo), maybe we can't use
string matching, is that OK?

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

