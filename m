Return-Path: <linux-kernel-owner+w=401wt.eu-S1752338AbZFPIn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338AbZFPIn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 04:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751213AbZFPInS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 04:43:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39886 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211AbZFPInR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 04:43:17 -0400
Date: Tue, 16 Jun 2009 10:42:56 +0200
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
Message-ID: <20090616084256.GF16229@elte.hu>
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
> 
> I am tempted to think that taking, say, ~10 cycles on the 
> interrupt path worths it if we save a few tens of cycles on the 
> page fault handler fast path.
> 
> But again, this calls for benchmarks.

One absolutely non-trivial complication with such a scheme would be 
preemptability: if we enter #PF with irqs enabled then it's 
immediately preemptible on CONFIG_PREEMPT=y. The scheduler would 
switch away to another context and the cr2 value is lost before it 
has been read out.

This means an additional collateral damage to context-switch cr2. 
(which might still be worth it given that context-switches are a 
less hot codepath than pagefaults - but an additional complicaton.)

The ideal solution would be for the CPU to atomically push the cr2 
value to the #PF hardware stack, alongside the error code it already 
pushes there.

	Ingo
