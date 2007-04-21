Return-Path: <linux-kernel-owner+w=401wt.eu-S965051AbXDUHyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965051AbXDUHyi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 03:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965105AbXDUHyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 03:54:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44800 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965051AbXDUHyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 03:54:37 -0400
Date: Sat, 21 Apr 2007 09:54:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: William Lee Irwin III <wli@holomorphy.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [patch] CFS scheduler, v3
Message-ID: <20070421075401.GA23410@elte.hu>
References: <20070418175017.GA5250@elte.hu> <46280505.4020605@bigpond.net.au> <20070420131544.GG31925@holomorphy.com> <4629596B.6020403@bigpond.net.au> <20070421050734.GL31925@holomorphy.com> <4629A349.8060207@bigpond.net.au> <4629BE29.6010306@bigpond.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4629BE29.6010306@bigpond.net.au>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Williams <pwil3058@bigpond.net.au> wrote:

> I retract this suggestion as it's a very bad idea.  It introduces the 
> possibility of starvation via the poor sods at the bottom of the queue 
> having their "on CPU" forever postponed and we all know that even the 
> smallest possibility of starvation will eventually cause problems.
> 
> I think there should be a rule: Once a task is on the queue its "on 
> CPU" time is immutable.

Yeah, fully agreed. Currently i'm using the simple method of 
p->nice_offset, which plainly just moves the per nice level areas of the 
tree far enough apart (by a constant offset) so that lower nice levels 
rarely interact with higher nice levels. Lower nice levels never truly 
starve because rq->fair_clock increases deterministically and currently 
the fair_key values are indeed 'immutable' as you suggest.

In practice they can starve a bit when one renices thousands of tasks, 
so i was thinking about the following special-case: to at least make 
them easily killable: if a nice 0 task sends a SIGKILL to a nice 19 task 
then we could 'share' its p->wait_runtime with that nice 19 task and 
copy the signal sender's nice_offset. This would in essence pass the 
right to execute over to the killed task, so that it can tear itself 
down.

This cannot be used to gain an 'unfair advantage' because the signal 
sender spends its own 'right to execute on the CPU', and because the 
target task cannot execute any user code anymore when it gets a SIGKILL.

In any case, it is clear that rq->raw_cpu_load should be used instead of 
rq->nr_running, when calculating the fair clock, but i begin to like the 
nice_offset solution too in addition of this: it's effective in practice 
and starvation-free in theory, and most importantly, it's very simple. 
We could even make the nice offset granularity tunable, just in case 
anyone wants to weaken (or strengthen) the effectivity of nice levels. 
What do you think, can you see any obvious (or less obvious) 
showstoppers with this approach?

	Ingo
