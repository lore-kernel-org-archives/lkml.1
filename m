Return-Path: <linux-kernel-owner+w=401wt.eu-S1756094AbZJATYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094AbZJATYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 15:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755062AbZJATYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 15:24:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44319 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754466AbZJATYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 15:24:19 -0400
Date: Thu, 1 Oct 2009 21:23:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tejun Heo <tj@kernel.org>, jeff@garzik.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       jens.axboe@oracle.com, rusty@rustcorp.com.au, cl@linux-foundation.org,
       dhowells@redhat.com, arjan@linux.intel.com
Subject: Re: [PATCH 03/19] scheduler: implement workqueue scheduler class
Message-ID: <20091001192338.GA24862@elte.hu>
References: <1254384558-1018-1-git-send-email-tj@kernel.org> <1254384558-1018-4-git-send-email-tj@kernel.org> <alpine.LFD.2.01.0910010953010.6996@localhost.localdomain> <20091001184824.GA21357@elte.hu> <4AC4FC47.4010405@redhat.com> <alpine.LFD.2.01.0910011207180.6996@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0910011207180.6996@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 1 Oct 2009, Avi Kivity wrote:
> > 
> > Sure, but it would mean that we need a new notifier.  sched_out, 
> > sched_in, and wakeup (and, return to userspace, with the new 
> > notifier).
> 
> Ok, see the email I just sent out.
> 
> And I don't think we want a new notifier - mainly because I don't 
> think we want to walk the list four times (prepare, out, in, final - 
> we need to make sure that these things nest properly, so even if "in" 
> and "final" happen with the same state, they aren't the same, because 
> "in" only happens if "out" was called, while "final" would happen if 
> "prepare" was called)
> 
> So it would be better to have separate lists, in order to avoid 
> walking the lists four times just because there was a single notifier 
> that just wanted to be called for the inner (or outer) cases.

Sounds a bit like perf events with callbacks, triggered at those places. 
(allowing arbitrary permutation of the callbacks)

But ... it needs some work to shape in precisely such a way. Primarily 
it would need a splitting/slimming of struct perf_event, to allow the 
callback properties to be separated out for in-kernel users that are 
only interested in the callbacks, not in the other abstractions.

But it looks straightforward and useful ... the kind of useful work 
interested parties would be able to complete by the next merge window 
;-)

Other places could use this too - we really want just one callback 
facility for certain system events - be that in-kernel use for other 
kernel facilities, or external instrumentation injected by user-space.

> > btw, I've been thinking we should extend concurrency managed 
> > workqueues to userspace.  Right now userspace can spawn a massive 
> > amount of threads, hoping to hide any waiting by making more work 
> > available to the scheduler.  That has the drawback of increasing 
> > latency due to involuntary preemption.  Or userspace can use one 
> > thread per cpu, hope it's the only application on the machine, and 
> > go all-aio.
> 
> This is what the whole next-gen AIO was supposed to do with the 
> threadlets, ie avoid doing a new thread if it could do the IO all 
> cached and without being preempted.

Yeah. That scheme was hobbled by signal semantics: it looked hard to do 
the 'flip a reserve thread with a blocked thread' trick in the scheduler 
while still keeping all the signal details in place.

	Ingo
