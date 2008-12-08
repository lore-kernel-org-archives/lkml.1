Return-Path: <linux-kernel-owner+w=401wt.eu-S1758058AbYLHLy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058AbYLHLy4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:54:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756265AbYLHLtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:49:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47385 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288AbYLHLtp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:49:45 -0500
Date: Mon, 8 Dec 2008 12:49:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Miller <davem@davemloft.net>, Paul Mackerras <paulus@samba.org>
Subject: Re: [patch] Performance Counters for Linux, v2
Message-ID: <20081208114921.GA8635@elte.hu>
References: <20081208012211.GA23106@elte.hu> <20081207174932.09673cae@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20081207174932.09673cae@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@infradead.org> wrote:

> On Mon, 8 Dec 2008 02:22:12 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > [ Performance counters are special hardware registers available on
> > most modern CPUs. These register count the number of certain types of
> > hw events: such as instructions executed, cachemisses suffered, or 
> >   branches mis-predicted, without slowing down the kernel or 
> >   applications. These registers can also trigger interrupts when a 
> >   threshold number of events have passed - and can thus be used to 
> >   profile the code that runs on that CPU. ]
> > 
> > This is version 2 of our Performance Counters subsystem
> > implementation.
> > 
> > The biggest user-visible change in this release is a new user-space 
> > text-mode profiling utility that is based on this code: KernelTop.
> > 
> > KernelTop can be downloaded from:
> > 
> >   http://redhat.com/~mingo/perfcounters/kerneltop.c
> > 
> > It's a standalone .c file that needs no extra libraries - it only
> > needs a CONFIG_PERF_COUNTERS=y kernel to run on.
> > 
> > This utility is intended for kernel developers - it's basically a
> > dynamic kernel profiler that gets hardware counter events dispatched
> > to it continuously, which it feeds into a histogram and outputs it 
> > periodically.
> > 
> 
> I played with this a little, and while it works neat, I wanted a 
> feature added where it shows a detailed profile for the top function.

ah, very nice idea!

> I've hacked this in quickly (the usability isn't all that great yet) 
> and put the source code up at
>
> http://www.tglx.de/~arjan/kerneltop-0.02.tar.gz

ok, picked it up :-)

> with this it looks like this:
> 
> $ sudo ./kerneltop --vmlinux=/home/arjan/linux-2.6.git/vmlinux
> 
> ------------------------------------------------------------------------------
>  KernelTop:     274 irqs/sec  [NMI, 1000000 cycles],  (all, 2 CPUs)
> ------------------------------------------------------------------------------
> 
>              events         RIP          kernel function
>              ______   ________________   _______________
> 
>                 230 - 00000000c04189e9 : read_hpet
>                  82 - 00000000c0409439 : mwait_idle_with_hints
>                  77 - 00000000c051a7b7 : acpi_os_read_port
>                  52 - 00000000c053cb3a : acpi_idle_enter_bm
>                  38 - 00000000c0418d93 : hpet_next_event
>                  19 - 00000000c051a802 : acpi_os_write_port
>                  14 - 00000000c04f8704 : __copy_to_user_ll
>                  13 - 00000000c0460c20 : get_page_from_freelist
>                   7 - 00000000c041c96c : kunmap_atomic
>                   5 - 00000000c06a30d2 : _spin_lock	[joydev]
>                   4 - 00000000c04f79b7 : vsnprintf	[snd_seq]
>                   4 - 00000000c06a3048 : _spin_lock_irqsave	[pcspkr]
>                   3 - 00000000c0403b3c : irq_entries_start
>                   3 - 00000000c0423fee : run_rebalance_domains
>                   3 - 00000000c0425e2c : scheduler_tick
>                   3 - 00000000c0430938 : get_next_timer_interrupt
>                   3 - 00000000c043cdfa : __update_sched_clock
>                   3 - 00000000c0448b14 : update_iter
>                   2 - 00000000c04304bd : run_timer_softirq
> 
> Showing details for read_hpet
>        0	c04189e9 <read_hpet>:
>        2	c04189e9:	a1 b0 e0 89 c0       	mov    0xc089e0b0,%eax
>        0	
>        0	/*
>        0	 * Clock source related code
>        0	 */
>        0	static cycle_t read_hpet(void)
>        0	{
>        1	c04189ee:	55                   	push   %ebp
>        0	c04189ef:	89 e5                	mov    %esp,%ebp
>        1	c04189f1:	05 f0 00 00 00       	add    $0xf0,%eax
>        0	c04189f6:	8b 00                	mov    (%eax),%eax
>        0		return (cycle_t)hpet_readl(HPET_COUNTER);
>        0	}
>      300	c04189f8:	31 d2                	xor    %edx,%edx
>        0	c04189fa:	5d                   	pop    %ebp
>        0	c04189fb:	c3                   	ret    
>        0	

very nice and useful output! This for example shows that it's the readl() 
on the HPET_COUNTER IO address that is causing the overhead. That is to 
be expected - HPET is mapped uncached and the access goes out to the 
chipset.

> As is usual with profile outputs, the cost for the function always gets 
> added to the instruction after the really guilty one. I'd move the 
> count one back, but this is hard if the previous instruction was a 
> (conditional) jump...

yeah. Sometimes the delay can be multiple instructions - so it's best to 
leave the profiling picture as pristine as possible, and let the kernel 
developer chose the right counter type that displays particular problem 
areas in the most expressive way.

For example when i'm doing SMP scalability work, i generally look at 
cachemiss counts, for cacheline bouncing. The following kerneltop output 
shows last-level data-cache misses in the kernel during a tbench 64 run 
on a 16-way box, using latest mainline -git:

------------------------------------------------------------------------------
 KernelTop:    3744 irqs/sec  [NMI, 1000 cache-misses],  (all, 16 CPUs)
------------------------------------------------------------------------------

             events         RIP          kernel function
             ______   ________________   _______________

               7757 - ffffffff804d723e : dst_release
               7649 - ffffffff804e3611 : eth_type_trans
               6402 - ffffffff8050e470 : tcp_established_options
               5975 - ffffffff804fa054 : ip_rcv_finish
               5530 - ffffffff80365fb0 : copy_user_generic_string!
               3979 - ffffffff804ccf0c : skb_push
               3474 - ffffffff804fe6cb : ip_queue_xmit
               1950 - ffffffff804cdcdd : skb_release_head_state
               1595 - ffffffff804cce4f : skb_copy_and_csum_dev
               1365 - ffffffff80501079 : __inet_lookup_established
                908 - ffffffff804fa5fc : ip_local_deliver_finish
                743 - ffffffff8036cbcc : unmap_single
                452 - ffffffff80569402 : _read_lock
                411 - ffffffff80283010 : get_page_from_freelist
                410 - ffffffff80505b16 : tcp_sendmsg
                406 - ffffffff8028631a : put_page
                386 - ffffffff80509067 : tcp_ack
                204 - ffffffff804d2d55 : netif_rx
                194 - ffffffff8050b94b : tcp_data_queue

Cachemiss event samples tend to line up quite close to the instruction 
that causes them.

Looking at pure cycles (same workload) gives a different view:

------------------------------------------------------------------------------
 KernelTop:   27357 irqs/sec  [NMI, 1000000 cycles],  (all, 16 CPUs)
------------------------------------------------------------------------------

             events         RIP          kernel function
             ______   ________________   _______________

              16602 - ffffffff80365fb0 : copy_user_generic_string!
               7947 - ffffffff80505b16 : tcp_sendmsg
               7450 - ffffffff80509067 : tcp_ack
               7384 - ffffffff80332881 : avc_has_perm_noaudit
               6888 - ffffffff80504e7c : tcp_recvmsg
               6564 - ffffffff8056745e : schedule
               6170 - ffffffff8050ecd5 : tcp_transmit_skb
               4949 - ffffffff8020a75b : __switch_to
               4417 - ffffffff8050cc4f : tcp_rcv_established
               4283 - ffffffff804d723e : dst_release
               3842 - ffffffff804fed58 : ip_finish_output
               3760 - ffffffff804fe6cb : ip_queue_xmit
               3580 - ffffffff80501079 : __inet_lookup_established
               3540 - ffffffff80514ce5 : tcp_v4_rcv
               3475 - ffffffff8026c31f : audit_syscall_exit
               3411 - ffffffffff600130 : vread_hpet
               3267 - ffffffff802a73de : kfree
               3058 - ffffffff804d39ed : dev_queue_xmit
               3047 - ffffffff804eecf8 : nf_iterate

Cycles overhead tends to be harder to match up with instructions.

	Ingo
