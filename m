Return-Path: <linux-kernel-owner+w=401wt.eu-S1754414AbYLHBs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414AbYLHBs0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 20:48:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbYLHBsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 20:48:17 -0500
Received: from casper.infradead.org ([85.118.1.10]:53060 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803AbYLHBsQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 20:48:16 -0500
Date: Sun, 7 Dec 2008 17:49:32 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Miller <davem@davemloft.net>, Paul Mackerras <paulus@samba.org>
Subject: Re: [patch] Performance Counters for Linux, v2
Message-ID: <20081207174932.09673cae@infradead.org>
In-Reply-To: <20081208012211.GA23106@elte.hu>
References: <20081208012211.GA23106@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Dec 2008 02:22:12 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> [ Performance counters are special hardware registers available on
> most modern CPUs. These register count the number of certain types of
> hw events: such as instructions executed, cachemisses suffered, or 
>   branches mis-predicted, without slowing down the kernel or 
>   applications. These registers can also trigger interrupts when a 
>   threshold number of events have passed - and can thus be used to 
>   profile the code that runs on that CPU. ]
> 
> This is version 2 of our Performance Counters subsystem
> implementation.
> 
> The biggest user-visible change in this release is a new user-space 
> text-mode profiling utility that is based on this code: KernelTop.
> 
> KernelTop can be downloaded from:
> 
>   http://redhat.com/~mingo/perfcounters/kerneltop.c
> 
> It's a standalone .c file that needs no extra libraries - it only
> needs a CONFIG_PERF_COUNTERS=y kernel to run on.
> 
> This utility is intended for kernel developers - it's basically a
> dynamic kernel profiler that gets hardware counter events dispatched
> to it continuously, which it feeds into a histogram and outputs it 
> periodically.
> 

I played with this a little, and while it works neat, I wanted a
feature added where it shows a detailed profile for the top function.
I've hacked this in quickly (the usability isn't all that great yet)
and put the source code up at
http://www.tglx.de/~arjan/kerneltop-0.02.tar.gz

with this it looks like this:

$ sudo ./kerneltop --vmlinux=/home/arjan/linux-2.6.git/vmlinux

------------------------------------------------------------------------------
 KernelTop:     274 irqs/sec  [NMI, 1000000 cycles],  (all, 2 CPUs)
------------------------------------------------------------------------------

             events         RIP          kernel function
             ______   ________________   _______________

                230 - 00000000c04189e9 : read_hpet
                 82 - 00000000c0409439 : mwait_idle_with_hints
                 77 - 00000000c051a7b7 : acpi_os_read_port
                 52 - 00000000c053cb3a : acpi_idle_enter_bm
                 38 - 00000000c0418d93 : hpet_next_event
                 19 - 00000000c051a802 : acpi_os_write_port
                 14 - 00000000c04f8704 : __copy_to_user_ll
                 13 - 00000000c0460c20 : get_page_from_freelist
                  7 - 00000000c041c96c : kunmap_atomic
                  5 - 00000000c06a30d2 : _spin_lock	[joydev]
                  4 - 00000000c04f79b7 : vsnprintf	[snd_seq]
                  4 - 00000000c06a3048 : _spin_lock_irqsave	[pcspkr]
                  3 - 00000000c0403b3c : irq_entries_start
                  3 - 00000000c0423fee : run_rebalance_domains
                  3 - 00000000c0425e2c : scheduler_tick
                  3 - 00000000c0430938 : get_next_timer_interrupt
                  3 - 00000000c043cdfa : __update_sched_clock
                  3 - 00000000c0448b14 : update_iter
                  2 - 00000000c04304bd : run_timer_softirq

Showing details for read_hpet
       0	c04189e9 <read_hpet>:
       2	c04189e9:	a1 b0 e0 89 c0       	mov    0xc089e0b0,%eax
       0	
       0	/*
       0	 * Clock source related code
       0	 */
       0	static cycle_t read_hpet(void)
       0	{
       1	c04189ee:	55                   	push   %ebp
       0	c04189ef:	89 e5                	mov    %esp,%ebp
       1	c04189f1:	05 f0 00 00 00       	add    $0xf0,%eax
       0	c04189f6:	8b 00                	mov    (%eax),%eax
       0		return (cycle_t)hpet_readl(HPET_COUNTER);
       0	}
     300	c04189f8:	31 d2                	xor    %edx,%edx
       0	c04189fa:	5d                   	pop    %ebp
       0	c04189fb:	c3                   	ret    
       0	

As is usual with profile outputs, the cost for the function always gets added to the instruction after
the really guilty one. I'd move the count one back, but this is hard if the previous instruction was a
(conditional) jump...

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
