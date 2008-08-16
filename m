Return-Path: <linux-kernel-owner+w=401wt.eu-S1753457AbYHPNqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbYHPNqX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 09:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751AbYHPNqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 09:46:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60741 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576AbYHPNqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 09:46:15 -0400
Date: Sat, 16 Aug 2008 15:46:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: torvalds@osdl.org, akpm@osdl.org, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] De-macro spin_trylock_irq, spin_trylock_irqsave,
	write_trylock_irqsave
Message-ID: <20080816134600.GC20652@elte.hu>
References: <20080816095951.GA19926@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080816095951.GA19926@martell.zuzino.mipt.ru>
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


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> 1) de-macro, remove ({ usages as side-effect,
> 2) change calling convention to not accept "flags" by value -- trylock
>    functions can modify them, so by-value is misleading, and number of users
>    is relatively low.
> 3) de-macro spin_trylock_irq() for a change.

> +++ b/kernel/sched.c
> @@ -1174,7 +1174,7 @@ static void resched_cpu(int cpu)
>  	struct rq *rq = cpu_rq(cpu);
>  	unsigned long flags;
>  
> -	if (!spin_trylock_irqsave(&rq->lock, flags))
> +	if (!spin_trylock_irqsave(&rq->lock, &flags))
>  		return;

hm, i dont really like this assymetric calling convention to other 
locking primitives that all take 'flags' as a value. 
[spin_lock_irqsave(), etc.]

so what's the point really? It sure does not make actual usage more 
readable. If we switched _all_ primitives to use flags as a pointer, 
that might make sense, in theory. (but it would also be hugely invasive, 
with not much upside with tons of downside like years of migration 
fallout and having to rewrite hundreds of kernel hacking books ;-) )

	Ingo
