Return-Path: <linux-kernel-owner+w=401wt.eu-S1756604AbYHZHzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbYHZHzK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 03:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbYHZHy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 03:54:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55149 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100AbYHZHy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 03:54:56 -0400
Date: Tue, 26 Aug 2008 09:53:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, Alan.Brunelle@hp.com, travis@sgi.com,
       tglx@linutronix.de, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, akpm@linux-foundation.org,
       arjan@linux.intel.com, rusty@rustcorp.com.au
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c -
	bisected
Message-ID: <20080826075355.GA7596@elte.hu>
References: <alpine.LFD.1.10.0808251344250.3363@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808251401590.3363@nehalem.linux-foundation.org> <20080826072220.GB31876@elte.hu> <20080826.004607.253712060.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080826.004607.253712060.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Tue, 26 Aug 2008 09:22:20 +0200
> 
> > And i guess the next generation of 4K CPUs support should just get away 
> > from cpumask_t-on-kernel-stack model altogether, as the current model is 
> > not maintainable. We tried the on-kernel-stack variant, and it really 
> > does not work reliably. We can fix this in v2.6.28.
> 
> I recenetly did some work on sparc64 to use cpumask pointers as much 
> as possible.
> 
> The only case that didn't work was due to a limitation in arch 
> interfaces for the new generic smp_call_function() code. It passes a 
> cpumask_t instead of a pointer to one via 
> arch_send_call_function_ipi().
> 
> But other than that, the whole sparc64 SMP stuff uses cpumask_t 
> pointers only.

nice!

> What it comes down to is that you have to do the "self cpu" and other 
> tests in the cross-call dispatch routines themselves, instead of at 
> the top-level working on cpumask_t objects.
> 
> Otherwise you have to modify cpumask_t objects and thus pluck them 
> onto the stack where they take up silly amounts of space.

What we did was this: we added MAXSMP which just revs up all the SMP 
tunables to the maximum, so that we can see any problems early in 
testing.

And we triggered problems, and we fixed a couple of regressions all 
around stack footprint. But we didnt catch all of them - some were gcc 
version dependent and configuration dependent. So i think it's safe to 
say that the whole concept of allowing such a large cpumask_t to be on 
the stack is fragile.

Hence, i think the best way forward is to change the whole cpumask_t 
concept and disallow explicit masks altogether. It's so easy to smack a 
cpumask_t variable on the stack and nothing really warns about it, and 
any function can become part of a nested call sequence.

So i think the dynamics of it has to be changed: we need a get/put API 
and we need to make on-stack cpumask illegal on the build level (in 
generic code at least). This has been Rusty's main argument early on i 
think, and i now concur.

	Ingo
