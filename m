Return-Path: <linux-kernel-owner+w=401wt.eu-S1030505AbXDUIdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030505AbXDUIdn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 04:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030476AbXDUIdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 04:33:43 -0400
Received: from holomorphy.com ([66.93.40.71]:43388 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030505AbXDUIdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 04:33:42 -0400
Date: Sat, 21 Apr 2007 01:33:17 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Williams <pwil3058@bigpond.net.au>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [patch] CFS scheduler, v3
Message-ID: <20070421083317.GN31925@holomorphy.com>
References: <20070418175017.GA5250@elte.hu> <46280505.4020605@bigpond.net.au> <20070420131544.GG31925@holomorphy.com> <4629596B.6020403@bigpond.net.au> <20070421050734.GL31925@holomorphy.com> <4629A349.8060207@bigpond.net.au> <4629BE29.6010306@bigpond.net.au> <20070421075401.GA23410@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070421075401.GA23410@elte.hu>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 21, 2007 at 09:54:01AM +0200, Ingo Molnar wrote:
> In practice they can starve a bit when one renices thousands of tasks, 
> so i was thinking about the following special-case: to at least make 
> them easily killable: if a nice 0 task sends a SIGKILL to a nice 19 task 
> then we could 'share' its p->wait_runtime with that nice 19 task and 
> copy the signal sender's nice_offset. This would in essence pass the 
> right to execute over to the killed task, so that it can tear itself 
> down.
> This cannot be used to gain an 'unfair advantage' because the signal 
> sender spends its own 'right to execute on the CPU', and because the 
> target task cannot execute any user code anymore when it gets a SIGKILL.

I suppose this is a special case of the dreaded priority inversion. What
of, say, nice 19 tasks holding fs semaphores and/or mutexes that nice
-19 tasks are waiting to acquire? Perhaps rt_mutex should be the default
mutex implementation.


On Sat, Apr 21, 2007 at 09:54:01AM +0200, Ingo Molnar wrote:
> In any case, it is clear that rq->raw_cpu_load should be used instead of 
> rq->nr_running, when calculating the fair clock, but i begin to like the 
> nice_offset solution too in addition of this: it's effective in practice 
> and starvation-free in theory, and most importantly, it's very simple. 
> We could even make the nice offset granularity tunable, just in case 
> anyone wants to weaken (or strengthen) the effectivity of nice levels. 
> What do you think, can you see any obvious (or less obvious) 
> showstoppers with this approach?

->nice_offset's semantics are not meaningful to the end user, regardless
of whether it's effective. If there is something to be tuned, it should
be relative shares of CPU bandwidth (load_weight) corresponding to each
nice level or something else directly observable. The implementation
could be ->nice_offset, if it suffices.

Suppose a table of nice weights like the following is tuned via /proc/:

-20	21			 0	1
-19	20			 1	0.5
-18	19			 2	0.3333
-17	18			 3	0.25
-16	17			 4	0.2
-15	16			 5	0.1666
-14	15			 6	0.1429
-13	14			 7	0.125
-12	13			 8	0.1111
-11	12			 9	0.1
-10	11			10	0.0909
 -9	10			11	0.0833
 -8	9			12	0.0769
 -7	8			13	0.0714
 -6	7			14	0.0666
 -5	6			15	0.0625
 -4	5			16	0.0588
 -3	4			17	0.0555
 -2	3			18	0.0526
 -1	2			19	0.0476

Essentially 1/(n+1) when n >= 0 and 1-n when n < 0.

Now suppose two CPU hogs, one being nice 1 and the other nice -1,
compete against each other. The nice 1 hog should receive 0.5/(2+0.5)
= 20% of the CPU, and the nice -1 hog should receive 80% of the CPU.
A nice -5 hog vs. a nice 0 hog should have the nice 0 hog receive
1/(6+1) = 14.29% of the CPU and the nice -5 hog receive 85.71% of the
CPU. Three hogs, once nice -1, one nice 0, and one nice 1 should have
the nice -1 hog receive 2/(2+1+0.5) = 57.14% of the CPU, the nice 0
hog receive 1/(2+1+0.5) = 28.57% of the CPU, and the nice 1 hog
receive 0.5/(2+1+0.5) = 14.29% of the CPU. And so on. (Note that these
are very strong nice semantics, probably too strong for real use.) For
five hogs with nice numbers ranging from -2 to 2, we'd get:
-2	43.90%
-1	29.27%
 0	14.63%
 1	 7.32%
 2	 4.88%

However this is implemented doesn't matter so long as the semantics
are honored. I wouldn't specify too much beyond competing tasks with
equivalent sleep/wakeup behavior; one may wish to apply bonuses and
penalties to differing sleep/wakeup behavior in the future, even if
such is not now done.

Basically, the effect of nice numbers should be predictable somehow,
and frankly, making it specifiable by the user resolves the issue
of conflicting requirements.


-- wli
