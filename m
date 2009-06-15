Return-Path: <linux-kernel-owner+w=401wt.eu-S1764798AbZFOUrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764798AbZFOUrq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 16:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752494AbZFOUrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 16:47:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58867 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534AbZFOUri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 16:47:38 -0400
Date: Mon, 15 Jun 2009 22:47:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
       hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, efault@gmx.de,
       jeremy@goop.org, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain
	support to use NMI-safe methods
Message-ID: <20090615204715.GA24554@elte.hu>
References: <tip-74193ef0ecab92535c8517f082f1f50504526c9b@git.kernel.org> <alpine.LFD.2.01.0906151007560.3305@localhost.localdomain> <20090615171845.GA7664@elte.hu> <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain> <20090615180527.GB4201@Krystal> <alpine.LFD.2.01.0906151125320.6276@localhost.localdomain> <20090615183649.GA16999@elte.hu> <alpine.LFD.2.01.0906151152170.6276@localhost.localdomain> <20090615194344.GA12554@elte.hu> <20090615200619.GA10632@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090615200619.GA10632@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> In the category "crazy ideas one should never express out loud", I 
> could add the following. We could choose to save/restore the cr2 
> register on the local stack at every interrupt entry/exit, and 
> therefore allow the page fault handler to execute with interrupts 
> enabled.
> 
> I have not benchmarked the interrupt disabling overhead of the 
> page fault handler handled by starting an interrupt-gated handler 
> rather than trap-gated handler, but cli/sti instructions are known 
> to take quite a few cycles on some architectures. e.g. 131 cycles 
> for the pair on P4, 23 cycles on AMD Athlon X2 64, 43 cycles on 
> Intel Core2.

The cost on Nehalem (1 billion local_irq_save()+restore() pairs):

 aldebaran:~> perf stat --repeat 5 ./prctl 0 0

 Performance counter stats for './prctl 0 0' (5 runs):

   10950.813461  task-clock-msecs     #      0.997 CPUs    ( +-   1.594% )
              3  context-switches     #      0.000 M/sec   ( +-   0.000% )
              1  CPU-migrations       #      0.000 M/sec   ( +-   0.000% )
            145  page-faults          #      0.000 M/sec   ( +-   0.000% )
    33946294720  cycles               #   3099.888 M/sec   ( +-   1.132% )
     8030365827  instructions         #      0.237 IPC     ( +-   0.006% )
         100933  cache-references     #      0.009 M/sec   ( +-  12.568% )
          27250  cache-misses         #      0.002 M/sec   ( +-   3.897% )

   10.985768499  seconds time elapsed.

That's 33.9 cycles per iteration, with a 1.1% confidence factor.

Annotation gives this result:

    2.24 :      ffffffff810535e5:       9c                      pushfq 
    8.58 :      ffffffff810535e6:       58                      pop    %rax
   10.99 :      ffffffff810535e7:       fa                      cli    
   20.38 :      ffffffff810535e8:       50                      push   %rax
    0.00 :      ffffffff810535e9:       9d                      popfq  
   46.71 :      ffffffff810535ea:       ff c6                   inc    %esi
    0.42 :      ffffffff810535ec:       3b 35 72 31 76 00       cmp    0x763172(%rip),%e
   10.69 :      ffffffff810535f2:       7c f1                   jl     ffffffff810535e5 
    0.00 :      ffffffff810535f4:       e9 7c 01 00 00          jmpq   ffffffff81053775 

i.e. pushfq+cli is roughly 42.19% or 14 cycles, the popfq is 46.71 
or 16 cycles. So the combo cost is 30 cycles, +- 1 cycle.

(Actual effective cost in a real critical section can be better than 
this, dependent on surrounding instructions.)

It got quite a bit faster than Core2 - but still not as fast as AMD.

	Ingo
