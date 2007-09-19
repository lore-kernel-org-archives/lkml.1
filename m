Return-Path: <linux-kernel-owner+w=401wt.eu-S1753975AbXIST5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbXIST5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 15:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbXIST5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 15:57:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55359 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbXIST5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 15:57:08 -0400
Date: Wed, 19 Sep 2007 21:56:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, Antoine Martin <antoine@nagafix.co.uk>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: CFS: some bad numbers with Java/database threading [FIXED]
Message-ID: <20070919195633.GA23595@elte.hu>
References: <20070913112427.GA20686@elte.hu> <20070914083246.GA20514@elte.hu> <a781481a0709140306k3faf3585haae26853fe81381c@mail.gmail.com> <46EAA7E4.8020700@nagafix.co.uk> <20070914153216.GA27213@elte.hu> <46F00417.7080301@redhat.com> <20070918224656.GA26719@elte.hu> <46F058EE.1080408@redhat.com> <20070919191837.GA19500@elte.hu> <alpine.LFD.0.999.0709191230230.16478@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0709191230230.16478@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > Linus, what do you think? I have no strong feelings, I think the 
> > patch cannot hurt (it does not change anything by default) - but we 
> > should not turn the workaround flag on by default.
> 
> I disagree. I think CFS made "sched_yield()" worse, and what you call 
> "bug workaround" is likely the *better* behaviour.
> 
> The fact is, sched_yield() is not - and should not be - about 
> "recalculating the position in the scheduler queue" like you do now in 
> CFS.
> 
> It very much is about moving the thread *dead last* within its 
> priority group.
[...]
> and quite frankly, the current CFS behaviour simply looks buggy. It 
> should simply not move it to the "right place" in the rbtree. It 
> should move it *last*.

ok, we can do that.

the O(1) implementation of yield() was pretty arbitrary: it did not move 
it last on the same priority level - it only did it within the active 
array. So expired tasks (such as CPU hogs) would come _after_ a 
yield()-ing task.

so the yield() implementation was so much tied to the data structures of 
the O(1) scheduler that it was impossible to fully emulate it in CFS.

in CFS we dont have a per-nice-level rbtree, so we cannot move it dead 
last within the same priority group - but we can move it dead last in 
the whole tree. (then they'd be put even after nice +19 tasks.) People 
might complain about _that_.

another practical problem is that this will break certain desktop apps 
that do calls to yield() [some firefox plugins do that, some 3D apps do 
that, etc.] but they dont expect to be moved 'very late' into the queue 
- they expect the O(1) scheduler's behavior of being delayed "a bit". 
(That's why i added the yield-granularity tunable.)

we can make yield super-agressive, that is pretty much the only sane 
(because well-defined) thing to do (besides turning yield into a NOP), 
but there will be lots of regression reports about lost interactivity 
during load. sched_yield() is a mortally broken API. "fix the app" would 
be the answer, but still there will be lots of complaints.

	Ingo
