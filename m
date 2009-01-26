Return-Path: <linux-kernel-owner+w=401wt.eu-S1754291AbZAZXBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291AbZAZXBG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 18:01:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753300AbZAZXAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 18:00:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51565 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592AbZAZXAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 18:00:47 -0500
Date: Mon, 26 Jan 2009 23:59:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: oleg@redhat.com, a.p.zijlstra@chello.nl, rusty@rustcorp.com.au,
       travis@sgi.com, mingo@redhat.com, davej@redhat.com,
       cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] work_on_cpu: Use our own workqueue.
Message-ID: <20090126225957.GA3999@elte.hu>
References: <20090126202022.GA8867@elte.hu> <20090126130046.37b8f34e.akpm@linux-foundation.org> <20090126212727.GA13670@elte.hu> <20090126133551.fab5e27a.akpm@linux-foundation.org> <20090126214516.GA22142@elte.hu> <20090126140116.35f9c173.akpm@linux-foundation.org> <20090126220537.GA6755@elte.hu> <20090126141605.707877bb.akpm@linux-foundation.org> <20090126222002.GB10215@elte.hu> <20090126145003.b29b81d7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090126145003.b29b81d7.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 26 Jan 2009 23:20:02 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > On Mon, 26 Jan 2009 23:05:37 +0100
> > > Ingo Molnar <mingo@elte.hu> wrote:
> > > 
> > > > 
> > > > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > > > 
> > > > > Well it turns out that I was having a less-than-usually-senile moment:
> > > > > 
> > > > > :     implement flush_work()
> > > > 
> > > > > Why isn't that working in this case??
> > > > 
> > > > how would that work in this case? We defer processing into the workqueue 
> > > > exactly because we want its per-CPU properties.
> > > 
> > > It detaches the work item, moves it to head-of-queue, reinserts it then 
> > > waits on it.  I think.
> > > 
> > > This might have a race+hole.  If a currently-running "unrelated" work 
> > > item tries to take the lock which the flush_work() caller is holding 
> > > then there's no way in which keventd will come back to execute the work 
> > > item which we just put on the head of queue.
> > 
> > Correct - or the unrelated worklet might also be blocked on something - so 
> > the window is rather large.
> > 
> 
> hm, OK, that sucks.
> 
> But the deadlock still exists with Rusty's patches, doesn't it?  We 
> still have a single kernel thread per CPU processing all the unrelated 
> work_on_cpu() callers.  All we've done is to decouple work_on_cpu() from 
> the keventd queue.

This particular deadlock does not exist - but you are indeed right that 
similar types of 'unrelated' interactions might exist in the future, as 
the usage of this facility is extended.

> If correct, we'd need to create a gaggle of kernel threads on each call 
> to work_on_cpu(), which doesn't sound nice.
> 
> A more efficient but trickier approach would be to create kernel threads 
> within flush_work(), with which to run the CPU-specific worklet.  We 
> only need to do that in the case where the CPU's keventd thread was off 
> doing something and might deadlock, which will be rare. If the keventd 
> was just parked waiting for something to do then we can safely feed it 
> the to-be-flushed work item for immediate processing.

i think what you describe is a variant of the syslet thread pool ;-)

> It'd be saner to just say "don't call work_on_cpu() while holding locks"
> :( I bet there's some lockdep infrastructre which we could peek into to
> add the assertion check...

The problem isnt doing the assertions - lockdep already covers workqueue 
dependencies very efficiently.

The problem is the intrinsic utility of work_on_cpu(): we _really_ want 
such a generic facility to be usable from any (blockable) context, just 
like on_each_cpu(func, info) does for atomic functions, without 
restrictions on locking context.

	Ingo
