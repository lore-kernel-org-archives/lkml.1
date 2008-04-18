Return-Path: <linux-kernel-owner+w=401wt.eu-S1755367AbYDRI2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbYDRI2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 04:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752260AbYDRI2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 04:28:32 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46595 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbYDRI23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 04:28:29 -0400
Message-ID: <48085B73.3070904@firstfloor.org>
Date: Fri, 18 Apr 2008 10:27:31 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       akpm@osdl.org, "H. Peter Anvin" <hpa@zytor.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86 NMI-safe INT3 and Page Fault (v3)
References: <20080414230344.GA16061@Krystal> <20080414230530.GB16061@Krystal> <20080416130605.GG6304@elte.hu> <20080416151054.GA32456@elte.hu> <20080416162810.GA20450@Krystal> <48063E19.9090701@goop.org> <20080417162932.GA23351@Krystal> <48077EB2.9030009@firstfloor.org> <20080418000551.GA5062@Krystal>
In-Reply-To: <20080418000551.GA5062@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> arch/x86/oprofile/nmi_timer_int.c: profile_timer_exceptions_notify()
> calls
> drivers/oprofile/oprofile_add_sample()
> which calls oprofile_add_ext_sample()
> where
>        if (log_sample(cpu_buf, pc, is_kernel, event))
>                 oprofile_ops.backtrace(regs, backtrace_depth);

A red hering: The notifier setup calls vmalloc_sync_all() and oprofile
allocates its buffers before registering the notifier.

> First, log_sample writes into the vmalloc'd cpu buffer. That's for one
> possible page fault.

 
> Then, is a kernel backtrace happen, then I am not sure if printk_address
> won't try to read any of the module data, which is vmalloc'd.

Yes, admittedly the backtrace mode was always somewhat flakey. It probably
has more problems too.

The right fix for that is to call vmalloc_sync_all() after module load
when any nmi notifiers are registered.
 
> 
> 
>> NMI are maybe 5-6 functions all over the kernel.
>>
>> I just don't think it makes any sense to put markers in there.
>> It is a really small part of the kernel the kernel that is unlikely
>> to be really useful for anybody. You should rather first solve the
>> problem of tracing the other 99.999999% of the kernel properly.
>>
> 
> The fact is that NMIs are very useful and powerful when it comes to try
> to understand where code disabling interrupts is stucked, to get
> performance counter reads periodically

First there are no truly periodic (as in time) NMIs. The NMI watchdog 
is not really periodic but is delayed arbitrarily all the time when the CPU 
is in sleep states.

Then oprofile does this already what you describe. Why do we need
another questionable infrastructure to reimplement what is 
already there? 

 without suffering from IRQ
> latency

Just from all kind of other latency caused by non ticking performance
counters.

. Also, when trying to figure out what is actually happening in
> the kernel timekeeping, having a stable periodic time source can be
> pretty useful. 

Haha. You seem to be so deep into nonsense land, it is hard to comprehend.

> That would be one way to do it, except that it would not deal with int3.
> Also, it would have to be taken into account at module load time. To me,
> that looks like an error-prone design. If the problem is at the lower
> end of the architecture, in the interrupt return path, why don't we
> simply fix it there for good ?

There are all kinds of problems with NMIs, this is only one of them.
And NMIs are a really really obscure case

Frankly, if you spend all your time on fringe cases like this instead
of getting it to work on the 99.99999999999999% case it doesn't
surprise me that the markers don't make any progress for years now.

 And yes, boot code is one of the first thing embedded system
> developers want to instrument.

Crap. That code runs once. The only interest is correctness and 
if it's not correct you just step it through with a JTAG debugger.

> I wonder if they are used so rarely because the underlying kernel is
> buggy with respect with NMIs or because they are useless.

lockless programming is just really hard and not doing it is in most 
cases the sanest option.

Anyways I give up. Do what you want.

-Andi
