Return-Path: <linux-kernel-owner+w=401wt.eu-S1763504AbYHETYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763504AbYHETYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 15:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761296AbYHETYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 15:24:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:44979 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763312AbYHETYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 15:24:36 -0400
Date: Tue, 5 Aug 2008 15:24:33 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       akpm@linux-foundation.org, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca
Subject: Re: LTTng finds abnormally long APIC interrupt handler : 58.2 ms
In-Reply-To: <20080805182007.GA4631@Krystal>
Message-ID: <alpine.DEB.1.10.0808051523370.28170@gandalf.stny.rr.com>
References: <20080805182007.GA4631@Krystal>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 5 Aug 2008, Mathieu Desnoyers wrote:

> Hi,
> 
> I would like to bring an interesting kernel latency issue I am
> experiencing.
> 
> A trace taken with LTTng on a x86_64 dual quad-core, Linux kernel
> 2.6.26.1, shows that IRQ 239 handler (LOCAL_TIMER_VECTOR ->
> smp_apic_timer_interrupt) runs for about 58.2 ms on 2 of the 8 cores,
> and a bit later on the other 6. It can be repeated by taking a trace
> shortly after boot : it happens at about 120 seconds after the cycle
> counters has been reset.
> 
> The execution trace of one interrupt handler is (edited for clarity) :

Mathieu,

Have you tried using ftrace to see what functions are being called here?

-- Steve

> 
> Format :
> event name: timestamp
>   pid, tgid, process name, execution mode
>   { event data }
> 
> kernel_irq_entry: 121.733399510
>   0, 0, swapper, IRQ
>   { irq_id = 239, kernel_mode = 1, ip = 0xFFFFFFFF80213936 }
> kernel_softirq_raise: 121.733400143
>   0, 0, swapper, IRQ
>   { softirq_id = 1 [run_timer_softirq+0x0/0x230] }
> 
> (takes a while : 58.2 ms)
> 
> kernel_sched_try_wakeup: 121.791694536
>   0, 0, swapper, IRQ
>   { pid = 8, state = 1 }
> kernel_softirq_raise: 121.791696762
>   0, 0, swapper, IRQ
>   { softirq_id = 6 [run_rebalance_domains+0x0/0x6e0] }
> kernel_irq_exit: 121.791697692
>   0, 0, swapper, SYSCALL
>   { handled = 1 }
> 
> Where pid = 8  is kernel thread watchdog/1
> 
> The same trace happens on the other CPUs which also have a long
> interrupt handler. The surroundings of the problem points out to
> run_local_timers(), which is the function responsible for raising the
> TIMER_SOFTIRQ. (which is the last event that occurs on the system for a
> while). It could also be the caller : update_process_times(), any
> function called from update_process_times() after the run_local_timers()
> call or actually any function executing between the "raise" and the "try
> wakeup" events.
> 
> The kernel config is attached below, so is the dmesg.
> 
> Any idea regarding what is happening here ?
> 
