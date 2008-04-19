Return-Path: <linux-kernel-owner+w=401wt.eu-S1762027AbYDSVSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762027AbYDSVSa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 17:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755591AbYDSVSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 17:18:21 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:43389 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754863AbYDSVSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 17:18:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: At0FACv+CUhMROPA/2dsb2JhbACBYKht
Date: Sat, 19 Apr 2008 17:18:17 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       akpm@osdl.org, "H. Peter Anvin" <hpa@zytor.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86 NMI-safe INT3 and Page Fault (v3)
Message-ID: <20080419211817.GC1554@Krystal>
References: <20080414230344.GA16061@Krystal> <20080414230530.GB16061@Krystal> <20080416130605.GG6304@elte.hu> <20080416151054.GA32456@elte.hu> <20080416162810.GA20450@Krystal> <48063E19.9090701@goop.org> <20080417162932.GA23351@Krystal> <48077EB2.9030009@firstfloor.org> <20080418000551.GA5062@Krystal> <48085B73.3070904@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <48085B73.3070904@firstfloor.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:01:25 up 50 days, 17:12,  4 users,  load average: 0.09, 0.22,
	0.26
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (andi@firstfloor.org) wrote:
> 
> > arch/x86/oprofile/nmi_timer_int.c: profile_timer_exceptions_notify()
> > calls
> > drivers/oprofile/oprofile_add_sample()
> > which calls oprofile_add_ext_sample()
> > where
> >        if (log_sample(cpu_buf, pc, is_kernel, event))
> >                 oprofile_ops.backtrace(regs, backtrace_depth);
> 
> A red hering: The notifier setup calls vmalloc_sync_all() and oprofile
> allocates its buffers before registering the notifier.
> 

Ah, yes, you are right on this one, it was well hidden. :)

> > First, log_sample writes into the vmalloc'd cpu buffer. That's for one
> > possible page fault.
> 
>  
> > Then, is a kernel backtrace happen, then I am not sure if printk_address
> > won't try to read any of the module data, which is vmalloc'd.
> 
> Yes, admittedly the backtrace mode was always somewhat flakey. It probably
> has more problems too.
> 
> The right fix for that is to call vmalloc_sync_all() after module load
> when any nmi notifiers are registered.

I guess it would work, but it certainly looks like a patchy workaround.

>  
> > 
> > 
> >> NMI are maybe 5-6 functions all over the kernel.
> >>
> >> I just don't think it makes any sense to put markers in there.
> >> It is a really small part of the kernel the kernel that is unlikely
> >> to be really useful for anybody. You should rather first solve the
> >> problem of tracing the other 99.999999% of the kernel properly.
> >>
> > 
> > The fact is that NMIs are very useful and powerful when it comes to try
> > to understand where code disabling interrupts is stucked, to get
> > performance counter reads periodically
> 
> First there are no truly periodic (as in time) NMIs. The NMI watchdog 
> is not really periodic but is delayed arbitrarily all the time when the CPU 
> is in sleep states.
> 

The is no such thing as "perfect" periodicity. There is just better and
worse periodicity. NMIs just tend to have much less jitter.

> Then oprofile does this already what you describe. Why do we need
> another questionable infrastructure to reimplement what is 
> already there? 
> 

I don't like to duplicate work. I would just like to dump performance
counters in LTTng trace buffers at specific points. I guess building on
top of oprofile would be a good way to do it.

>  without suffering from IRQ
> > latency
> 
> Just from all kind of other latency caused by non ticking performance
> counters.
> 
> . Also, when trying to figure out what is actually happening in
> > the kernel timekeeping, having a stable periodic time source can be
> > pretty useful. 
> 
> Haha. You seem to be so deep into nonsense land, it is hard to comprehend.
> 
> > That would be one way to do it, except that it would not deal with int3.
> > Also, it would have to be taken into account at module load time. To me,
> > that looks like an error-prone design. If the problem is at the lower
> > end of the architecture, in the interrupt return path, why don't we
> > simply fix it there for good ?
> 
> There are all kinds of problems with NMIs, this is only one of them.
> And NMIs are a really really obscure case
> 

Which other problems ? I am listening.

> Frankly, if you spend all your time on fringe cases like this instead
> of getting it to work on the 99.99999999999999% case it doesn't
> surprise me that the markers don't make any progress for years now.
> 

One thing is that I really don't want to add fragility to a traced
kernel. A tracer that would make the kernel more fragile is the last
thing I want. Therefore, I make sure the tracer provides good reentrancy
so it can be called from virtually any kernel context and I also make
sure it stays in its own sandbox as much as possible, using atomic
operations to update its data structures/buffers.

>  And yes, boot code is one of the first thing embedded system
> > developers want to instrument.
> 
> Crap. That code runs once. The only interest is correctness and 
> if it's not correct you just step it through with a JTAG debugger.
> 

looking at these links tells us that some embedded developers are
interested in speeding up Linux boot time, and that's a task a kernel
tracer is very good at.

http://www.linuxdevices.com/news/NS5907201615.html
http://elinux.org/Boot_Time

> > I wonder if they are used so rarely because the underlying kernel is
> > buggy with respect with NMIs or because they are useless.
> 
> lockless programming is just really hard and not doing it is in most 
> cases the sanest option.
> 

I think kernel tracing would be an exception; that a kernel tracer
should be designed not to use any sort of lock, to have as little
dependency on the rest of the kernel as possible and to update its own
data structures atomically. That insures the tracer can be called from
virtually anywhere without having to worry about side-effects.  Given
that LTTng users have been happy with it for the past 2.5 years, I tend
to think I was right.

Mathieu

> Anyways I give up. Do what you want.
> 
> -Andi
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
