Return-Path: <linux-kernel-owner+w=401wt.eu-S1764717AbXFRSBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764717AbXFRSBQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 14:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761760AbXFRSBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 14:01:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35415 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761651AbXFRSA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 14:00:59 -0400
Date: Mon, 18 Jun 2007 20:00:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, cebbert@redhat.com, chris@atlee.ca,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: Re: [BUG] long freezes on thinkpad t60
Message-ID: <20070618180041.GA13483@elte.hu>
References: <E1HrGom-0006AC-00@dorka.pomaz.szeredi.hu> <20070524210153.GB19672@elte.hu> <E1HrWSH-0000mH-00@dorka.pomaz.szeredi.hu> <E1Hyrnk-0006On-00@dorka.pomaz.szeredi.hu> <20070616103707.GA28096@elte.hu> <E1I02Zx-0005qu-00@dorka.pomaz.szeredi.hu> <20070618064343.GA31113@elte.hu> <E1I0Baz-0006cP-00@dorka.pomaz.szeredi.hu> <20070618081204.GA11153@elte.hu> <alpine.LFD.0.98.0706180857120.14121@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706180857120.14121@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> That code does:
> 
> 	if (unlikely(p->array || task_running(rq, p))) {
> 
> to decide if it needs to just unlock and repeat, but then to decide if 
> it need to *yield* it only uses *one* of those tests (namely
> 
> 	preempted = !task_running(rq, p);
> 	..
> 	if (preempted)
> 		yield();
> 
> and I think that's just broken. It basically says:
> 
>  - if the task is running, I will busy-loop on getting/releasing the 
>    task_rq_lock
> 
> and that is the _real_ bug here.
> 
> Trying to make the spinlocks do somethign else than what they do is 
> just papering over the real bug. The real bug is that anybody who just 
> busy-loops getting a lock is wasting resources so much that we should 
> not be at all surprised that some multi-core or NUMA situations will 
> get starvation.
> 
> Blaming some random Core 2 hardware implementation issue that just 
> makes it show up is wrong. It's a software bug, plain and simple.

yeah, agreed. wait_task_inactive() is butt-ugly, and Roland i think 
found a way to get rid of it in utrace (but it's not implemented yet, 
boggle) - but nevertheless this needs fixing for .22.

> So how about this diff? The diff looks big, but the *code* is actually 
> simpler and shorter, I just added tons of comments, which is what 
> blows it up.

> 
> The new *code* looks like this:
> 
> 	repeat:
> 		/* Unlocked, optimistic looping! */
> 	        rq = task_rq(p);
> 	        while (task_running(rq, p))
> 	                cpu_relax();

ok. Do we have an guarantee that cpu_relax() is also an smp_rmb()?

> 
> 		/* Get the *real* values */
> 	        rq = task_rq_lock(p, &flags);
> 	        running = task_running(rq, p);
> 	        array = p->array;
> 	        task_rq_unlock(rq, &flags);
> 
> 		/* Check them.. */
> 	        if (unlikely(running)) {
> 	                cpu_relax();
> 	                goto repeat;
> 	        }
> 
> 	        if (unlikely(array)) {
> 	                yield();
> 	                goto repeat;
> 	        }

hm, this might still go into a non-nice busy loop on SMP: one cpu runs 
the strace, another one runs two tasks, one of which is runnable but not 
on the runqueue (the one we are waiting for). In that case we'd call 
yield() on this CPU in a loop (and likely wont pull that task over from 
that CPU). And yield() itself is a high-frequency rq-lock touching thing 
too, just a bit heavier than the other path in the wait function.

> Hmm? Untested, I know. Maybe I overlooked something. But even the 
> generated assembly code looks fine (much better than it looked 
> before!)

it looks certainly better and cleaner than what we had before!

	Ingo
