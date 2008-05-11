Return-Path: <linux-kernel-owner+w=401wt.eu-S1756086AbYEKLSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbYEKLSb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 07:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbYEKLSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 07:18:23 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:55049 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313AbYEKLSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 07:18:22 -0400
Date: Sun, 11 May 2008 13:18:20 +0200
From: Andreas Mohr <andi@lisas.de>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] kernel/sched*: optimize inlining
Message-ID: <20080511111820.GA3326@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080511092132.GE1645@cs181133002.pp.htv.fi>
X-Priority: none
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[manual reply, no access to original content]

Hi,

rather NACKish here (from my minor side, that is, since there are no
useful explanations, and in the case of a lack of explanations no
backing numbers either which would have been helpful to resolve this ;).

"x86: add optimized inlining"
(http://kerneltrap.org/mailarchive/git-commits-head/2008/4/26/1612644)
does not really say anything relevant to your patch, AFAICS.

That one simply says that previously every inline was force-inlined (ugh),
which now gcc is allowed to properly decide by itself now. This, however,
does _NOT_ imply that it's now somehow fully sufficient for a perfect outcome
to simply remove all open-coded "inline"s.

This part here:

> -static inline int task_current(struct rq *rq, struct task_struct *p)
> +static int task_current(struct rq *rq, struct task_struct *p)
>  {
>         return rq->curr == p;
>  }
>  
>  #ifndef __ARCH_WANT_UNLOCKED_CTXSW
> -static inline int task_running(struct rq *rq, struct task_struct *p)
> +static int task_running(struct rq *rq, struct task_struct *p)
>  {
>         return task_current(rq, p);
>  }
>  

is especially "nice" since it's now a non-inlined multi-call, with 2
parameters each and 6 callsites within sched.c.

Using this admittedly worst-caseish part as a simple compile testcase, I get
67013 vs. previously 66920 bytes for sched.o on x86 (gcc 4.2.3, 2.6.26-rc1).
Removing all "inline"s, we end up at 67891 even.
Size indicates that it's an increase in complexity, but size is
not even the problem here, the problem is that these calls are used in
inner scheduling / migration code, AFAICS, where a simple pointer
comparison now turns into a 2-parametric multi-call.
Examining this thing more closely (objdump, nm), I see that it did
inline task_running and chose to not inline task_current (which it was
before, and that seems like a wrong compiler decision).

OK, I know that it's not "chic" to argue about inlining stuff,
especially since it's such a b**ch to manage (do we inline this or don't
we, and what if the function silently grows to become an inlining
penalty?).
But in this case you seem to have brushed all criticism aside with an
argument (pointing to the other patch) that to me doesn't seem to hold
in the first place.
Also, sched.c isn't architecture-specific, IOW it will be used by
architectures with all kinds of ranges of "implementation dumbness".
Some of those may have lots of issues due to weak instruction caches or
badly-performing function invocation.

So, again,
- non-"inline"d functions sometimes (sufficiently frequently?) do not seem
  to get inlined no matter how small
- sched.c is very central, non-architecture-specific code
- looking at a "nice" size reduction really does _not_ matter (relatively)
  for such a centrally, frequently used code, what matters is performance
- the consequences of this change to me seem just a wee bit too gross
  to swallow

As long as compiler intelligence in the realms of inlining seems
spotty, I'd refrain from cleaning up centrally used, critical code.
Removing inlines in driver code which is rarely used (with the objective
of gaining size reductions, of course) is an entirely different discussion
with easily more positive outcome, I'd say.
If even x86 gcc (4.2.3) seems to do the wrong thing here, then I really don't
want to know what much less prominently compiler-optimized architectures
would end up with.

Just my thoughts (keep it or burn it),

Andreas Mohr
