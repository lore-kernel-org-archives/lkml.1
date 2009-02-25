Return-Path: <linux-kernel-owner+w=401wt.eu-S1759473AbZBYOlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759473AbZBYOlp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 09:41:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbZBYOlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 09:41:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:58269 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbZBYOlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 09:41:36 -0500
Date: Wed, 25 Feb 2009 09:41:32 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Martin Bligh <mbligh@google.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/4] tracing: add event trace infrastructure
In-Reply-To: <20090225012250.db68e480.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.0902250923360.12697@gandalf.stny.rr.com>
References: <20090225025608.956691460@goodmis.org> <20090225025753.798204550@goodmis.org> <20090224194548.3effb746.akpm@linux-foundation.org> <alpine.DEB.2.00.0902242252480.12697@gandalf.stny.rr.com> <20090224203308.8d623e0b.akpm@linux-foundation.org>
 <20090225081118.GC15303@elte.hu> <20090225002852.5ef5b869.akpm@linux-foundation.org> <84144f020902250100k41e55dd7w8a9c8d2ca96908ea@mail.gmail.com> <20090225012250.db68e480.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 25 Feb 2009, Andrew Morton wrote:

> On Wed, 25 Feb 2009 11:00:53 +0200 Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> Parse this:
> 
> irqsoff latency trace v1.1.5 on 2.6.26-rc8
> --------------------------------------------------------------------
>  latency: 97 us, #3/3, CPU#0 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:2)
>     -----------------
>     | task: swapper-0 (uid:0 nice:0 policy:0 rt_prio:0)
>     -----------------
>  => started at: apic_timer_interrupt
>  => ended at:   do_softirq
> 
> #                _------=> CPU#
> #               / _-----=> irqs-off
> #              | / _----=> need-resched
> #              || / _---=> hardirq/softirq
> #              ||| / _--=> preempt-depth
> #              |||| /
> #              |||||     delay
> #  cmd     pid ||||| time  |   caller
> #     \   /    |||||   \   |   /
>   <idle>-0     0d..1    0us+: trace_hardirqs_off_thunk (apic_timer_interrupt)
>   <idle>-0     0d.s.   97us : __do_softirq (do_softirq)
>   <idle>-0     0d.s1   98us : trace_hardirqs_on (do_softirq)
> 
> your time starts now.

Note, that is a legacy format, that works great for the latency tracers. 
Those include (the example you used) irqsoff, the preempt off, wake up 
latencies. This gives us a nice listing of why we are hitting a latency.
All other plugins generally use the trace file, although they could also 
use that file too.

As for your English comment. I showed the header to my wife, and she had 
no idea what irqs-off means, nor need-resched, nor preempt-depth ;-)   
They are not quite English as they are technical terms. Most of the names 
are hard coded into the kernel too.

Yeah, maybe that file (latency_trace) is a bit too much. I for one love 
it. It is great to load a kernel on some remote box, and run the irqs off 
latency tracer to see where the interrupts are disabled for the longest 
time. This format is really nice because it shows me when we are in an 
interrupt, or interrupts are disabled, and when the task should have been 
rescheduled.

This has help find places that we miss a preemption check too.

If I had to also include a user space program, I would need to tell the 
customer how to install it, and run it. Just telling someone to mount a 
directory, run your test, cat a file to some temp file and send me the 
temp file is much easier. Because most admins know how to do such things. 
No learning curve, except what to mount and what to cat.

I've given a few talks on ftrace. And when I'm approached afterward by 
people (usually the ones not paying attention to the speech ;-) asking 
what utils they need to install. You should see the smile on their faces 
when I tell them, "All you need is what is in busybox".  Then they say, 
"No, really? What do I need to use ftrace?" I again tell them, a kernel 
with ftrace and a minimum requirement of what is in busybox: cat, grep, 
echo. That is what makes ftrace powerful and robust.

Once I break that "busybox" rule. ftrace will be used by only a quarter of
those that use it now (and probably less).

-- Steve




