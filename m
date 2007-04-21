Return-Path: <linux-kernel-owner+w=401wt.eu-S932332AbXDUI6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332AbXDUI6e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 04:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932344AbXDUI6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 04:58:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38718 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932332AbXDUI6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 04:58:33 -0400
Date: Sat, 21 Apr 2007 10:57:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Peter Williams <pwil3058@bigpond.net.au>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [patch] CFS scheduler, v3
Message-ID: <20070421085729.GD29800@elte.hu>
References: <20070418175017.GA5250@elte.hu> <46280505.4020605@bigpond.net.au> <20070420131544.GG31925@holomorphy.com> <4629596B.6020403@bigpond.net.au> <20070421050734.GL31925@holomorphy.com> <4629A349.8060207@bigpond.net.au> <4629BE29.6010306@bigpond.net.au> <20070421075401.GA23410@elte.hu> <20070421083317.GN31925@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070421083317.GN31925@holomorphy.com>
User-Agent: Mutt/1.4.2.2i
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


* William Lee Irwin III <wli@holomorphy.com> wrote:

> I suppose this is a special case of the dreaded priority inversion. 
> What of, say, nice 19 tasks holding fs semaphores and/or mutexes that 
> nice -19 tasks are waiting to acquire? Perhaps rt_mutex should be the 
> default mutex implementation.

while i agree that it could be an issue, lock inversion is nothing 
really new, so i'd not go _that_ drastic to convert all mutexes to 
rtmutexes. (i've taken my -rt/PREEMPT_RT hat off)

For example reiser3 based systems get pretty laggy on significant 
reniced load (even with the vanilla scheduler) if CONFIG_PREEMPT_BKL is 
enabled: reiser3 holds the BKL for extended periods of time so a "make 
-j50" workload can starve it significantly and the tty layer's BKL use 
makes any sort of keyboard (even over ssh) input laggy.

Other locks though are not held this frequently and the mutex 
implementation is pretty fair for waiters anyway. (the semaphore 
implementation is not nearly as much fair, and the Big Kernel Semaphore 
is still struct semaphore based) So i'd really wait for specific 
workloads to trigger problems, and _maybe_ convert certain mutexes to 
rtmutexes, on an as-needed basis.

> > In any case, it is clear that rq->raw_cpu_load should be used instead of 
> > rq->nr_running, when calculating the fair clock, but i begin to like the 
> > nice_offset solution too in addition of this: it's effective in practice 
> > and starvation-free in theory, and most importantly, it's very simple. 
> > We could even make the nice offset granularity tunable, just in case 
> > anyone wants to weaken (or strengthen) the effectivity of nice levels. 
> > What do you think, can you see any obvious (or less obvious) 
> > showstoppers with this approach?
> 
> ->nice_offset's semantics are not meaningful to the end user, 
> regardless of whether it's effective. [...]

yeah, agreed. That's one reason why i didnt make it tunable, it's pretty 
meaningless to the user.

> [...] If there is something to be tuned, it should be relative shares 
> of CPU bandwidth (load_weight) corresponding to each nice level or 
> something else directly observable. The implementation could be 
> ->nice_offset, if it suffices.
> 
> Suppose a table of nice weights like the following is tuned via 
> /proc/:
> 
> -20	21			 0	1
>  -1	2			19	0.0476

> Essentially 1/(n+1) when n >= 0 and 1-n when n < 0.

ok, thanks for thinking about it. I have changed the nice weight in 
CVSv5-to-be so that it defaults to something pretty close to your 
suggestion: the ratio between a nice 0 loop and a nice 19 loop is now 
set to about 2%. (This something that users requested for some time, the 
default ~5% is a tad high when running reniced SETI jobs, etc.)

the actual percentage scales almost directly with the nice offset 
granularity value, but if this should be exposed to users at all, i 
agree that it would be better to directly expose this as some sort of 
'ratio between nice 0 and nice 19 tasks', right? Or some other, more 
finegrained metric. Percentile is too coarse i think, and using 0.1% 
units isnt intuitive enough i think. The sysctl handler would then 
transform that 'human readable' sysctl value into the appropriate 
internal nice-offset-granularity value (or whatever mechanism the 
implementation ends up using).

I'd not do this as a per-nice-level thing but as a single value that 
rescales the whole nice level range at once. That's alot less easy to 
misconfigure and we've got enough nice levels for users to pick from 
almost arbitrarily, as long as they have the ability to influence the 
max.

does this sound mostly OK to you?

	Ingo
