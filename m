Return-Path: <linux-kernel-owner+w=401wt.eu-S934079AbZFOVCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934079AbZFOVCw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 17:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933987AbZFOVCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 17:02:34 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:63533 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933976AbZFOVCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 17:02:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AokFALdSNkpMQWQl/2dsb2JhbACBT9QChA0F
Date: Mon, 15 Jun 2009 17:02:25 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
       hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, efault@gmx.de,
       jeremy@goop.org, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain
	support to use NMI-safe methods
Message-ID: <20090615210225.GA12919@Krystal>
References: <alpine.LFD.2.01.0906151007560.3305@localhost.localdomain> <20090615171845.GA7664@elte.hu> <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain> <20090615180527.GB4201@Krystal> <alpine.LFD.2.01.0906151125320.6276@localhost.localdomain> <20090615183649.GA16999@elte.hu> <alpine.LFD.2.01.0906151152170.6276@localhost.localdomain> <20090615194344.GA12554@elte.hu> <20090615200619.GA10632@Krystal> <20090615204715.GA24554@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090615204715.GA24554@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:59:29 up 107 days, 17:25,  3 users,  load average: 0.18, 0.31,
	0.38
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > In the category "crazy ideas one should never express out loud", I 
> > could add the following. We could choose to save/restore the cr2 
> > register on the local stack at every interrupt entry/exit, and 
> > therefore allow the page fault handler to execute with interrupts 
> > enabled.
> > 
> > I have not benchmarked the interrupt disabling overhead of the 
> > page fault handler handled by starting an interrupt-gated handler 
> > rather than trap-gated handler, but cli/sti instructions are known 
> > to take quite a few cycles on some architectures. e.g. 131 cycles 
> > for the pair on P4, 23 cycles on AMD Athlon X2 64, 43 cycles on 
> > Intel Core2.
> 
> The cost on Nehalem (1 billion local_irq_save()+restore() pairs):
> 
>  aldebaran:~> perf stat --repeat 5 ./prctl 0 0
> 
>  Performance counter stats for './prctl 0 0' (5 runs):
> 
>    10950.813461  task-clock-msecs     #      0.997 CPUs    ( +-   1.594% )
>               3  context-switches     #      0.000 M/sec   ( +-   0.000% )
>               1  CPU-migrations       #      0.000 M/sec   ( +-   0.000% )
>             145  page-faults          #      0.000 M/sec   ( +-   0.000% )
>     33946294720  cycles               #   3099.888 M/sec   ( +-   1.132% )
>      8030365827  instructions         #      0.237 IPC     ( +-   0.006% )
>          100933  cache-references     #      0.009 M/sec   ( +-  12.568% )
>           27250  cache-misses         #      0.002 M/sec   ( +-   3.897% )
> 
>    10.985768499  seconds time elapsed.
> 
> That's 33.9 cycles per iteration, with a 1.1% confidence factor.
> 
> Annotation gives this result:
> 
>     2.24 :      ffffffff810535e5:       9c                      pushfq 
>     8.58 :      ffffffff810535e6:       58                      pop    %rax
>    10.99 :      ffffffff810535e7:       fa                      cli    
>    20.38 :      ffffffff810535e8:       50                      push   %rax
>     0.00 :      ffffffff810535e9:       9d                      popfq  
>    46.71 :      ffffffff810535ea:       ff c6                   inc    %esi
>     0.42 :      ffffffff810535ec:       3b 35 72 31 76 00       cmp    0x763172(%rip),%e
>    10.69 :      ffffffff810535f2:       7c f1                   jl     ffffffff810535e5 
>     0.00 :      ffffffff810535f4:       e9 7c 01 00 00          jmpq   ffffffff81053775 
> 
> i.e. pushfq+cli is roughly 42.19% or 14 cycles, the popfq is 46.71 
> or 16 cycles. So the combo cost is 30 cycles, +- 1 cycle.
> 
> (Actual effective cost in a real critical section can be better than 
> this, dependent on surrounding instructions.)
> 
> It got quite a bit faster than Core2 - but still not as fast as AMD.
> 
> 	Ingo

Interesting, but in our specific case, what would be even more
interesting to know is how many trap gates/s vs interrupt gates/s can be
called. This would allow us to see if it's worth trying to make the page
fault handler interrupt-safe by mean of atomicity and context
save/restore by interrupt handlers (which would let us run the PF
handler with interrupts enabled).

Mathieu



-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
