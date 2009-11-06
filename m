Return-Path: <linux-kernel-owner+w=401wt.eu-S1752891AbZKFH7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbZKFH7G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 02:59:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbZKFH7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 02:59:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52675 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbZKFH7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 02:59:04 -0500
Date: Fri, 6 Nov 2009 08:58:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>, Nick Piggin <npiggin@suse.de>
Cc: Jiri Kosina <jkosina@suse.cz>, Peter Zijlstra <peterz@infradead.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, cl@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: irq lock inversion
Message-ID: <20091106075820.GA28227@elte.hu>
References: <86802c440911041008q4969b9bdk15b4598c40bb84bd@mail.gmail.com> <4AF25FC7.4000502@kernel.org> <20091105082102.GA2870@elte.hu> <4AF28D7A.6020209@kernel.org> <alpine.LSU.2.00.0911051502060.9988@wotan.suse.de> <4AF3B9BD.9050300@kernel.org> <20091106071711.GA20946@elte.hu> <4AF3D428.8000804@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF3D428.8000804@kernel.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
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


* Tejun Heo <tj@kernel.org> wrote:

> Ingo Molnar wrote:
> >>> This warning is bogus -- sched_init() is being called very early with IRQs
> >>> disabled, and the irqsave/restore code paths in pcpu_alloc() are only for early
> >>> init. The path can never be called from irq context once the early init
> >>> finishes. Rationale for this is explained in changelog of the commit mentioned
> >>> above.
> >>>
> >>> This problem can be encountered generally in any other early code running
> >>> with IRQs off and using irqsave/irqrestore.
> >>>
> >>> Reported-by: Yinghai Lu <yhlu.kernel@gmail.com>
> >>> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> >> Looks good to me.  Ingo, what do you think?
> > 
> > Ugh, this explanation is _BOGUS_. As i said, taking a lock with irqs 
> > disabled does _NOT_ mark a lock as 'irq safe' - if it did, we'd have 
> > false positives left and right.
> > 
> > Read the lockdep message please, consider all the backtraces it prints, 
> > it says something different.
> 
> Ah... okay, the pcpu_free() path is correctly marking the lock 
> irqsafe.  I assumed this was caused by recent pcpu_alloc() change. 
> Sorry about that.  The lock inversion problem has always been there, 
> it just never showed up because none has use allocation map that large 
> I suppose.
> 
> So, the correct fix would be either 1. push down irqsafeness down to 
> vmalloc locks or 2. the rather ugly unlock-lock dancing in 
> pcpu_extend_area_map() I posted earlier.  For 2.6.32, I guess we'll 
> have to go with #2.  For longer term, we'll probably have to do #1 as 
> it's required to implement atomic percpu allocations too.
> 
> I'll try to reproduce the problem here and verify the previous locking 
> dance patch.

I havent looked deeply but at first sight i'm not 100% sure that even 
the lock dance hack is safe - doesnt vfree() do TLB flushes, which must 
be done with irqs enabled in general? If yes, then the whole notion of 
using the allocator from irqs-off sections is wrong and the flags 
save/restore is misguided (or at least incomplete).

So the real problem right now i think is the use of the pcpu allocator 
from within a BH section (and from irqs-off sections) - that usage 
should be eliminated from .32, or the allocator should be fixed. (which 
looks non-trivial vmalloc/vfree was never really intended to be used in 
irq-atomic contexts)

	Ingo
