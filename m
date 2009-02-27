Return-Path: <linux-kernel-owner+w=401wt.eu-S1757743AbZB0Onc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757743AbZB0Onc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 09:43:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753098AbZB0OnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 09:43:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:40415 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbZB0OnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 09:43:22 -0500
Date: Fri, 27 Feb 2009 09:43:18 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Dominique Toupin <dominique.toupin@ericsson.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jason Baron <jbaron@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH] new irq tracer
In-Reply-To: <20090227123806.1537.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0902270859100.25593@gandalf.stny.rr.com>
References: <20090227121053.152B.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.0902262230130.19122@gandalf.stny.rr.com> <20090227123806.1537.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 27 Feb 2009, KOSAKI Motohiro wrote:

> > 
> > On Fri, 27 Feb 2009, KOSAKI Motohiro wrote:
> > > >
> > > > In many cases we don't use Linux real-time, we have many systems that
> > > > are soft-real-time an non real-time Linux is good enough.
> > > >  
> > > 
> > > Agreed, rt-patch seems off topics. we discuss to mainline kernel.
> > 
> > The reason I brought up the rt-patch is that Mathieu is concerned about 
> > the small latency that happens when we run stop_machine to switch the nops 
> > to pointers to trace functions. This latency can be a couple of millisecs, 
> > but I can easily make a normal kernel suffer a couple of millisec latency 
> > by simply running hackbench (as a normal user).
> > 
> > The point being, I think Mathieu's point about the latency of enabling the 
> > function tracer is frivolous. It is a one time shot that happens when the 
> > sysadmin purposely enables the function tracing.  If this is unacceptable, 
> > then the system had better be running the rt patch because it will be 
> > hitting this unacceptable latency in normal operation.
> 
> ok, I missed last thread. thanks.
> 
> I think you talk about "ftrace, x86: make kernel text writable only for
> conversions" thread, right?
> hm, it seems very good discussion.

Yes, and as Mathieu and I finally convinced each other that there are
two different issues there (we both were trying to convince the other
about the same point. Sorta like the two blind man explaining what an 
Elephant looks like ;-)

  text_poke vs touching kernel mappings

  break_points vs stop_machine

The real issue came down to the latter.

> 
> My concern is, both your and Mathieu's point is fairly reasonable and
> good direction.
> 
> However, I would bring up another viewpoint. so, 
> 
>   - the latency issue can happen actual production server?
> 
> 
> Mathieu and Dominique explained ACTUAL production server problem.
> but I believe Dominique's server never run hackbench.
> 
> In other word, I agree mainline kernel has many latency corner case problems.
> but I don't agree corner case existing indicate no need latency improvement.
> Generally, actual experience indicate it's valuable to hear them requirement.

Then the production system had better not do any load at all. hackbench is 
a trivial way to produce the problem, and I used it only as an example 
that one can see. But anytime you have a large quantity of requests coming 
in, and waking up many threads, you run the risk of taking a 3 or 4ms 
interrupts off latency.  I've measured this running database applications.

Using 2.6.28, I did some measurements of the function tracer stop_machine.
Simply by using irqsoff tracer:

 # wc -l available_filter_functions
19043

That is 19 thousand available trace points in the kernel. All of them are
nops when tracing is disabled. But to activate all of them by running 
stop_machine can take a bit of time. It will also add a bit of overhead to
the system when tracing is active simply because you have 19 thousand 
trace points!

 # cd /debug/tracing
 # echo irqsoff > current_tracer
 # sysctl kernel.ftrace_enabled
kernel.ftrace_enabled = 1

 # echo 0 > tracing_max_latency
 # sysctl kernel.ftrace_enabled=0
kernel.ftrace_enabled = 0

 # cat latency_trace > full-disable.txt
 # echo 0 > tracing_max_latency
 # sysctl kernel.ftrace_enabled=1
kernel.ftrace_enabled = 1

 # cat latency_trace > full-enable.txt
 # echo do_fork > set_ftrace_filter
 # echo 0 > tracing_max_latency
 # sysctl kernel.ftrace_enabled=0
kernel.ftrace_enabled = 0
 
 # cat latency_trace > one-func-disable.txt
 # echo 0 > tracing_max_latency
 # sysctl kernel.ftrace_enabled=1
kernel.ftrace_enabled = 1

 # cat latency_trace > one-func-enable.txt
 # head available_filter_functions > set_ftrace_filter
 # echo 0 > tracing_max_latency
 # sysctl kernel.ftrace_enabled=0
kernel.ftrace_enabled = 0
 
 # cat latency_trace > ten-func-disable.txt
 # echo 0 > tracing_max_latency
 # sysctl kernel.ftrace_enabled=1
kernel.ftrace_enabled = 1

 # cat latency_trace > ten-func-enable.txt
 # head -100 available_filter_functions > set_ftrace_filter
 # echo 0 > tracing_max_latency
 # sysctl kernel.ftrace_enabled=0
kernel.ftrace_enabled = 0
 
 # cat latency_trace > hundred-func-disable.txt
 # echo 0 > tracing_max_latency
 # sysctl kernel.ftrace_enabled=1
kernel.ftrace_enabled = 1

 # cat latency_trace > hundred-func-enable.txt

 # sysctrl kernel.ftrace_enabled=0
kernel.ftrace_enabled = 0

 # echo 0 > tracing_max_latency
 # /usr/local/bin/hackbench 50
Time: 18.693

 # cat latency_trace > hackbench.txt

The above output traces and the available_filter_functions can be found
at http://rostedt.homelinux.com/traces/

The actual measured latencies are up on the top left corner. The trace
itself might be a little off because it is still recording the trace
after it recorded the latency, and you might see a few more microsecs
in the trace output.

Here's the latencies:

 one-disable:		564us
 one-enable:		567us

 ten-disable:		547us
 ten-enable:		549us

Funny how enabling 10 took less than one? Perhaps cache issues.

 hundred-disable:	580us
 hundred-enable:	581us

 full-disable: (19043)	9352us
 full-enable:  (19043)	19081us

 hackbench:		3859us

For some reason, full enabling always seems to take longer than full
disabling. Not sure why.

Now lets look at this data. You can enable 100 different call sites in 
just over a half a millisec.  The latency that Mathieu is complaining 
about is just a half a millisec.  That I can guarantee you, a production 
system doing any kind of work, will hit that latency, with any non RT 
Linux kernel.

Yes, you could say, "19ms! That is a lot!" Well, do not enable all
19 thousand trace points at once.  Just having them enabled will cause a 
bit of overhead that is noticeable. Mathieu pointed out that I said I 
would not have this done on an active production system. He is right. 
Although if something is going wrong with the production system, it may be 
worth taking this hit to analyze the situation. Or ever a periodical thing 
on off hours with a notice to customers that analysis of the system is 
being performed from (2am to 3am EST), expect some degradation in 
performance. You can do this. It is a controlled environment.

> 
> HOWEVER, I still also agree with your disliking messiness.
> Then, I would suggest we go into next step.
> 
> I mean make the patch of Mathieu's plan and measure it. Then
> we can mesure number by number. my number mean,
> 
>   (1) How much increasing line and messiness
>   (2) How much improving latency
> 
> that's fairly comparision and typical lkml discussion style, imho.
> 
> What do you think?

The problem with the above is that to replace stop_machine, I would need 
to implement the breakpoint method. This is by no means a trivial change. 
It may take weeks to get right. And for what? To get rid of a half a 
millisec latency that can happen at any time during normal operation?

Note, the stop_machine method can be ported to other archs trivially. 
David Miller ported it in 20 minutes to Sparc64. A break point scheme 
would take a lot more development by each arch maintainer, and risk adding 
many more bugs.

-- Steve

