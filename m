Return-Path: <linux-kernel-owner+w=401wt.eu-S1754673AbZAZU3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673AbZAZU3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 15:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbZAZU3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 15:29:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59961 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019AbZAZU3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 15:29:06 -0500
Date: Mon, 26 Jan 2009 21:28:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, hpa@zytor.com,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>
Subject: Re: [git pull] x86 fixes
Message-ID: <20090126202844.GB8867@elte.hu>
References: <20090126171723.GA32030@elte.hu> <20090126110539.2000cd30.akpm@linux-foundation.org> <20090126192016.GA1211@elte.hu> <20090126114038.a2f6606f.akpm@linux-foundation.org> <20090126195910.GA13471@elte.hu> <20090126121426.32f391a9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090126121426.32f391a9.akpm@linux-foundation.org>
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

> On Mon, 26 Jan 2009 20:59:10 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > On Mon, 26 Jan 2009 20:20:16 +0100
> > > Ingo Molnar <mingo@elte.hu> wrote:
> > > 
> > > > 
> > > > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > > > 
> > > > > On Mon, 26 Jan 2009 18:17:23 +0100
> > > > > Ingo Molnar <mingo@elte.hu> wrote:
> > > > > 
> > > > > > Rusty Russell (2):
> > > > > >       ...
> > > > > >       work_on_cpu: Use our own workqueue.
> > > > > 
> > > > > wtf?
> > > > 
> > > > an x86 fix depends on it:
> > > > 
> > > > 7285908: cpufreq: use work_on_cpu in acpi-cpufreq.c for drv_read and drv_write
> > > > 
> > > 
> > > Right.  And these are currently under active (albeit rather slow) 
> > > discussion.
> > > 
> > > The changelogs suck, nobody can be assed actually telling us what the 
> > > bug is and the patches just casually toss yet another gaggle of kernel 
> > > threads into there.
> > 
> > One problem is that for example do_dbs_timer() [used both in the 
> > cpufreq_ondemand and cpufreq_conservative cpufreq drivers] gets queued 
> > into the generic kevent workqueue via schedule_work(). But 
> > work_on_cpu() needs to serialize on the worklet - i.e. it needs to do 
> > a flush_work() - and does this with the cpufreq lock held.
> 
> We've discovered many times that doing a workqueue flush with a lock 
> held is a bad idea.  If any callback takes that lock, or takes some 
> other lock which someone else takes while holding the original lock, 
> etc, we deadlock.

This is a bona fide deadlock in the _same_ callpath though - lockdep will 
catch it and it is straightforward to avoid.

The problem we had with work_on_cpu() was different: the "drive-by 
shooting" aspect of the keventd workqueue: it creates 'casual' (and hence 
hard to get right) dependencies between various, seemingly detached 
worklets.

Were were lucky that the tester was both willing to go through a dozen 
bisection steps to pin down the bug and also was kind enough to try 
countless rfc patches to figure it all out.

The only other maintainable way would be to remove work_on_cpu() - but 
it's a useful facility IMO.

> > So we have a 'worklet inversion' bug here - and this got reported as a 
> > hard to debug boot hang on some systems.
> > The root cause is that kevents is not that do_dbs_timer() uses 
> > schedule_work() - the root cause is that kevents workqueue is a too 
> > generic workqueue that is the union of all casual workqueue users in the 
> > kernel. That is fine (and it is its purpose) but it should not be used for 
> > core kernel facilities such as work_on_cpu() - precisely because doing so 
> > would limit that facility's genericity.
> 
> Yes, that's a point.
> 
> > This bug was always there but dormant until work_on_cpu() was used 
> > from a deep enough codepath.
> > 
> > So the solution here is to isolate work_on_cpu()s mechanisms from the 
> > 'misc' workqueue that schedule_work() deals with - this is what 
> > Rusty's patch does.
> 
> But it's still deadlockable, isn't it?  If you do a work_on_cpu() while 
> holding a lock, and the callback function takes that lock, deadlock? If 
> so, things didn't get much better?

Yes, but it's much different: the situation you describe is that if we 
think of work_on_cpu() as a 'remote function call' it can deadlock if a 
called function takes the same lock.

That's not news at all and developers should be careful not to take the 
same lock twice. work_on_cpu() does not change or extend that aspect of 
lock programming at all.

But the previous, fragile version of work_on_cpu() had a much more subtle 
dependency not related to the function that was called but related to 
work_on_cpu() _itself_ running in a context (the keventd workqueue 
threads) that have casual dependencies.

That's much harder to debug, much less intuitive, and also, IMO, a bug in 
the facility.

> > Your observation about there being too many workqueue threads is 
> > correct but this commit is IMO a valid use of the workqueue facility. 
> > This workqueue it only gets created on CONFIG_SMP so there cost is 
> > about ~10K RAM per CPU.
> 
> mm..  This is why I'd like to expend a little more effort trying to 
> avoid having to make this change.

work_on_cpu() clearly cannot be in the kevent workqueue. I can only see 
two other solutions:

 1) turn it into a singlethreaded workqueue. (Probably fine as all users 
    are not performance sensitive.)

 2) remove it altogether and convert all users to atomic call_on_cpu() 
    calls. Probably doable albeit a bit restrictive IMO.

	Ingo
