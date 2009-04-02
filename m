Return-Path: <linux-kernel-owner+w=401wt.eu-S934955AbZDBDpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934955AbZDBDpA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 23:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934890AbZDBDop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 23:44:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45537 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933045AbZDBDoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 23:44:44 -0400
Date: Thu, 2 Apr 2009 05:42:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <cl@linux.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, rusty@rustcorp.com.au,
       tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       heiko.carstens@de.ibm.com, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH UPDATED] percpu: use dynamic percpu allocator as the
	default percpu allocator
Message-ID: <20090402034223.GA25791@elte.hu>
References: <alpine.DEB.1.10.0903301049060.13333@qirst.com> <alpine.DEB.1.10.0903311208110.17960@qirst.com> <49D2B209.9060000@kernel.org> <alpine.DEB.1.10.0904010948120.7643@qirst.com> <20090401154913.GA31435@elte.hu> <alpine.DEB.1.10.0904011404240.29839@qirst.com> <20090401190113.GA734@elte.hu> <alpine.LFD.2.00.0904011235160.4130@localhost.localdomain> <20090401223241.GA28168@elte.hu> <alpine.DEB.1.10.0904012216370.32656@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0904012216370.32656@qirst.com>
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


* Christoph Lameter <cl@linux.com> wrote:

> On Thu, 2 Apr 2009, Ingo Molnar wrote:
> 
> > So ... we regressed the performance of percpu_free(NULL) with a 
> > potential cross-CPU cacheline bounce. Without the patch, 
> > percpu_free(NULL) would never do such a bounce. So i dont think 
> > the patch is a good idea.
> 
> But percpu_free is not an operation typical for hot code paths. 
> Per cpu variables are allocated and freed in rarely used code 
> paths. Typically the use of the per cpu variables occurs in hot 
> code paths, not their allocations.

to quote an earlier part of my mail:

> > We encourage kfree(NULL) and it triggers commonly in the kernel 
> > today [on distro kernels we checked it can trigger once per 
> > syscall!] - so i think we should consider free_percpu(NULL) a 
> > possibly common pattern too. (even though today it's likely 
> > _not_ common at all.)

I specifically mentioned that it is not at all common now.

But there's no reason why an object shutdown fastpath with an 
optional percpu buffer (say for debug statistics, not enabled by 
default) couldnt look like this:

	percpu_free(NULL);

We actually have such patterns of kfree(ptr) use, where the _common_ 
case in a fastpath is kfree(NULL).

So, had your patch been applied as-is, we might have created this 
situation.

Yes, it can be fixed, and yes, it is probably not worth even 
bothering (percpu alloc/free goes over all online CPUs) - but i 
found it kind of interesting that this random specific example we 
ran into (i totally didnt go out and try to find some other, better 
example) showed so many variable placement ambiguities and false 
cacheline sharing problems, and showed visible inefficiencies in the 
layout (i showed a whole line of variables wastefully spaces - 
unrelated to the percpu allocator).

So these examples almost seemed to support my earlier points in the 
thread where i suggested that variable placement is often random and 
ambigious, and that we could fix inefficiencies in the layout ;-)

	Ingo
