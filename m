Return-Path: <linux-kernel-owner+w=401wt.eu-S1753789AbYJDOeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789AbYJDOeU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 10:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752979AbYJDOeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 10:34:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:43735 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969AbYJDOeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 10:34:10 -0400
Date: Sat, 4 Oct 2008 10:34:06 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 0/3] ring-buffer: less locking and only disable
 preemption
In-Reply-To: <20081004084002.GE27624@elte.hu>
Message-ID: <alpine.DEB.1.10.0810041015330.4551@gandalf.stny.rr.com>
References: <20081004060057.660306328@goodmis.org> <20081004084002.GE27624@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ Added Arjan to CC regarding the last statements ]

On Sat, 4 Oct 2008, Ingo Molnar wrote:
> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> > These patches need to be put through the ringer. Could you add them to 
> > your ring-buffer branch, so we can test them out before putting them 
> > into your master branch.
> 
> hey, in fact your latest iteration already tested out so well on a wide 
> range of boxes that I've merged it all into tip/tracing/core already.

Great to hear!

> 
> I'll reuse tip/tracing/ring-buffer for these latest 3 patches (merge it 
> up to tip/tracing/core and add these three patches) but it's a delta, 
> i.e. the whole ring-buffer approach is ready for prime time i think.
> 
> Hm, do we do deallocation of the buffers already when we switch tracers?

Not yet, but that is one of the trivial changes. I spent too much time
on these more complex changes to get around to it.

> 
> > The following patches bring the ring buffer closer to a lockless 
> > solution. They move the locking only to the actual moving the 
> > tail/write pointer from one page to the next. Interrupts are now 
> > enabled during most of the writes.
> 
> very nice direction!

Thanks!

> 
> > A lot of the locking protection is still within the ftrace 
> > infrastructure. The last patch takes some of that away.
> > 
> > The function tracer cannot be reentrant just due to the nature that it 
> > traces everything, and can cause recursion issues.
> 
> Correct, and that's by far the yuckiest aspect of it. And there's 
> another aspect: NMIs. We've still got the tip/tracing/nmisafe angle with 
> these commits:
> 
>  d979781: ftrace: mark lapic_wd_event() notrace
>  c2c27ba: ftrace: ignore functions that cannot be kprobe-ed
>  431e946: ftrace: do not trace NMI contexts
>  1eda930: x86, tracing, nmisafe: fix threadinfo_ -> TI_ rename fallout
>  84c2ca9: sched: sched_clock() improvement: use in_nmi()
>  0d84b78: x86 NMI-safe INT3 and Page Fault
>  a04464b: x86_64 page fault NMI-safe
>  b335389: Change avr32 active count bit
>  a581cbd: Change Alpha active count bit
>  eca0999: Stringify support commas
> 
> but I'm not yet fully convinced about the NMI angle, the practical cross 
> section to random low level x86 code is wider than any sched_clock() 
> impact for example. We might be best off avoiding it: force-disable the 
> NMI watchdog when we trace?

Since we still have the locking in the ring buffer, it is still not NMI 
safe. But once we remove all locking, then the tracer is fine.

BUT!

The dynamic function tracer is another issue. The problem with NMIs has 
nothing to do with locking, or corrupting the buffers. It has to do with 
the dynamic code modification.  Whenever we modify code, we must guarantee 
that it will not be executed on another CPU.

Kstop_machine serves this purpose rather well. We can modify code without 
worrying it will be executed on another CPU, except for NMIs. The problem 
now comes where an NMI can come in and execute the code being modified. 
That's why I put in all the notrace, lines. But it gets difficult because 
of nmi_notifier can call all over the kernel.  Perhaps, we can simply 
disable the nmi-notifier when we are doing the kstop_machine call?

-- Steve

