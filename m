Return-Path: <linux-kernel-owner+w=401wt.eu-S1757344AbZJSTcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344AbZJSTcx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 15:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757250AbZJSTcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 15:32:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:31302 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757290AbZJSTcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 15:32:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=b01CFuFL79quhOAGJqrPvo9dOCeo3DFYUSJ3TxeLhhRiVshbb42Geq6uMdSGxLD1ce
         OzwEw4VWlA9YJMcaP3l5V9BiqnJmZaPEF13dxVvqteDFu00VBybNVXq14YPNOhvFeUIP
         IF2H3utQRafgbzWLFjgYJI33UbPamNUp+T6Ns=
Date: Mon, 19 Oct 2009 21:32:51 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
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
Message-ID: <20091019193248.GB4880@nowhere>
References: <20091017000711.16556.69935.stgit@dhcp-100-2-132.bos.redhat.com> <20091017080203.GA4155@elte.hu> <20091017103427.GA31238@elte.hu> <4ADAAF50.9040604@redhat.com> <20091019075103.GF17960@elte.hu> <20091019110055.GA5549@nowhere> <20091019112125.GA12829@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091019112125.GA12829@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19, 2009 at 01:21:25PM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > I personally don't imagine common easy usecases that imply relative 
> > line offsets but rather absolute lines.
> 
> Absolute line numbers could be expressed too, via:
> 
>    perf schedule@5396
> 
> There's no immediate need to express 'sched.c'. (you can do it, or you 
> can do it for extra clarity or for the case of local scope functions of 
> which multiple instances exist)



Ok. As long as there is an easy way to do that, like in the above
example, then I think it's fine.

(More argument below)

 
> > I don't understand your point. If your editor is opened and you have 
> > the source code in front of you, why would you cut'n'paste a line 
> > instead of actually write the line number?
> 
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
> 
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


I haven't thought that relative lines would make it less short-lived.
So yeah that's a good point.

I think absolute and relative line modes are not colliding/contending
at all but actually fit two different needs.

- absolute is nice when you are lonely doing kernel debugging.
  (can be expanded at will once you imagine user probes)
  You are stuck in your code editor, trying to figure out the
  origin of your problem and then you think it would be nice
  to set a probe in branch 1 and in branch 2 inside func_foo().
  Then you already have absolute lines and relying in
  perf probe --list func_foo() to resolve an absolute line into
  a relative one is a very undesired middle step.

- relative is nice in some other cases. When you already have
  the function target in mind, you even don't need to check your
  editor, just a quick check to this command and get the relative
  line. But also when you want to transmit a probe reference
  in a mailing list because of its better lifetime.


Both are important IMO.


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



Yeah, that's a nice advanced usage.


> 
> Note that i was able to specify both probes without having opened an 
> editor - just based on the general knowledge of the scheduler.


Yeah, that a good workflow for someone who knows well the targeted
code.

That can't cover every needs though, but I guess you agree that
abs_line/rel_line/smart_resolution methods need to coexist anyway,
all of them fit different level of needs.


> The point is to prefer intuitive, non-mechanic, fundamentally human 
> expressions of information above mechanic ones (absolute line numbers, 
> addresses, ways of probing, etc.) - and to have a rich variety of them.


Agreed!

 
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
> 
> 	Ingo


Ok.

Thanks.

