Return-Path: <linux-kernel-owner+w=401wt.eu-S1760278AbZAGSrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760278AbZAGSrq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 13:47:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbZAGSrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 13:47:36 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44660 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbZAGSrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 13:47:35 -0500
Date: Wed, 7 Jan 2009 19:47:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: linux-next: Tree for December 11
Message-ID: <20090107184721.GA16193@elte.hu>
References: <20081211200459.14d18d7a.sfr@canb.auug.org.au> <f19298770812110440s7e3781eex4a16b961ad6847b2@mail.gmail.com> <f19298770812140634j434bf6a6gd883688f00dac45e@mail.gmail.com> <f19298770901070830q71cc7604nf55e1d5b70a22f37@mail.gmail.com> <alpine.LFD.2.00.0901070840240.3057@localhost.localdomain> <20090107171730.GA21799@elte.hu> <f19298770901070935u6396a367j86937c9394518877@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f19298770901070935u6396a367j86937c9394518877@mail.gmail.com>
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


* Alexey Zaytsev <alexey.zaytsev@gmail.com> wrote:

> And last time I bisected, it pointed to:
> 
> commit 7317d7b87edb41a9135e30be1ec3f7ef817c53dd
> Author: Nick Piggin <nickpiggin@yahoo.com.au>
> Date:   Tue Sep 30 20:50:27 2008 +1000
> 
>    sched: improve preempt debugging
>
> 
>    This patch helped me out with a problem I recently had....
> 
>    Basically, when the kernel lock is held, then preempt_count
> underflow does not
>    get detected until it is released which may be a long time (and arbitrarily,
>    eg at different points it may be rescheduled). If the bkl is released at
>    schedule, the resulting output is actually fairly cryptic...
> 
>    With any other lock that elevates preempt_count, it is illegal to schedule
>    under it (which would get found pretty quickly). bkl allows scheduling with
>    preempt_count elevated, which makes underflows hard to debug.
> 
>    Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> so at least a dumb bisection won't do here.

ah, sorry for being a slow starter, i missed that bit - merge window 
attention span troubles ...

I think the kernel_locked() check added here is plain buggy against IRQ 
contexts: we drop the BKL spinlock and reduce current->kernel_depth 
non-atomically.

So kernel_locked() can become detached from the preempt_count().

Nick, can you think of any better way of still saving this debug check, or 
should we revert it?

Although it seems a bit weird how consistently you seem to be able to 
trigger it - as this seems to be a narrow race. Is there an IRQ storm 
there perhaps, or something widens things up for Qemu to inject an IRQ 
right there?

	Ingo
