Return-Path: <linux-kernel-owner+w=401wt.eu-S1753575AbYKHTK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbYKHTK1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 14:10:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbYKHTKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 14:10:18 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37089 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbYKHTKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 14:10:17 -0500
Date: Sat, 8 Nov 2008 20:10:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: [git pull] scheduler updates
Message-ID: <20081108191010.GA12852@elte.hu>
References: <20081108170224.GA553@elte.hu> <alpine.LFD.2.00.0811081026280.3468@nehalem.linux-foundation.org> <20081108104116.48bd26e6@infradead.org> <alpine.LFD.2.00.0811081051190.3468@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0811081051190.3468@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sat, 8 Nov 2008, Arjan van de Ven wrote:
> > 
> > historically it was for early AMD cpus (K7, not sure if early K8 did
> > this) where 2 consecutive rdtsc's in the same codestream would get
> > reordered compared to eachother, so you could observe the tsc go
> > backwards...
> 
> .. but this only happens with two _consecutive_ ones.
> 
> The thing is, nobody sane does that in generic code. The scheduler wants 
> to have cycles, yes, but two consecutive scheduler invocations will have 
> spinlocks etc in between. That's true of _all_ sane uses of a TSC.
> 
> I don't see that there is ever any reason to do the barriers for any 
> normal case. And the cases where it does matter would actually be worth 
> pointing out (ie making the barriers explicit in those cases, and those 
> cases only).
> 
> Doing it in get_cycles() and "forgetting about it" may sound like a simple 
> solution, but it's likely wrong. For example, one of the few cases where 
> we realy care about time going backwards is gettimeofday() - which uses 
> tsc, but which also has tons of serializing instructions on its own. 
> EXCEPT WHEN IT IS a vsyscall!
> 
> But in that case, we don't even have the barrier, because we put it in the 
> wrong function and 'forgot about it'. Of course, we may not need it 
> (rdtscp maybe always serializes, I didn't check), but the point is, an 
> explicit barrier is actually better than one that is hidden.
> 
> So who _really_ needs it? And why not just do it there?

i think, the tree as offered to you, intends to do just that, unless i 
made some grave (and unintended) mistake somewhere.

The barrier is only present in the vread function: which is the 
vsyscall-read function, to be used from user-space.

Even in the past, no was actually forgotten or put in the wrong 
function as far as i can see because previously _everything_ 
(including the vread method) had the barrier.

The change from me simply removes the barrier from the places that 
dont need it - exactly for the reason you outlined: the scheduler is 
both imprecise and has a ton of natural serialization anyway, so it's 
a non-issue there.

Hm?

	Ingo
