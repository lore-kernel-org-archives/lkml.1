Return-Path: <linux-kernel-owner+w=401wt.eu-S964857AbXHaKzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964857AbXHaKzN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 06:55:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932433AbXHaKy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 06:54:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52366 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932415AbXHaKy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 06:54:57 -0400
Date: Fri, 31 Aug 2007 12:54:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [ANNOUNCE/RFC] Really Fair Scheduler
Message-ID: <20070831105447.GA17956@elte.hu>
References: <Pine.LNX.4.64.0708310139280.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708310139280.1817@scrub.home>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Roman Zippel <zippel@linux-m68k.org> wrote:

> Hi,
> 
> I'm glad to announce a working prototype of the basic algorithm I 
> already suggested last time. As I already tried to explain previously 
> CFS has a considerable algorithmic and computational complexity. [...]

hey, thanks for working on this, it's appreciated! In terms of merging 
your stuff, your patch looks a bit large and because you did not tell us 
that you were coding in this area, you probably missed Peter Zijlstra's 
excellent CFS work:

  http://programming.kicks-ass.net/kernel-patches/sched-cfs/

The following portion of Peter's series does much of the core math 
changes of what your patch provides (and which makes up for most of the 
conceptual delta in your patch), on a step by step basis:

  sched-update_weight_inv.patch
  sched-se_load.patch
  sched-se_load-2.patch
  sched-64-wait_runtime.patch
  sched-scaled-limit.patch
  sched-wait_runtime-scale.patch
  sched-calc_delta.patch

So the most intrusive (math) aspects of your patch have been implemented 
already for CFS (almost a month ago), in a finegrained way.

Peter's patches change the CFS calculations gradually over from 
'normalized' to 'non-normalized' wait-runtime, to avoid the 
normalizing/denormalizing overhead and rounding error. Turn off sleeper 
fairness, remove the limit code and we should arrive to something quite 
close to the core math in your patch, with similar rounding properties 
and similar overhead/complexity. (there are some other small details in 
the math but this is the biggest item by far.) I find Peter's series 
very understandable and he outlined the math arguments in his replies to 
your review mails. (would be glad to re-open those discussions though if 
you still think there are disagreements.)

Peter's work fully solves the rounding corner-cases you described as:

> This model is far more accurate than CFS is and doesn't add an error 
> over time, thus there are no more underflow/overflow anymore within 
> the described limits.

( your characterisation errs in that it makes it appear to be a common
  problem, while in practice it's only a corner-case limited to extreme 
  negative nice levels and even there it needs a very high rate of 
  scheduling and an artificially constructed workload: several hundreds 
  of thousand of context switches per second with a yield-ing loop to be 
  even measurable with unmodified CFS. So this is not a 2.6.23 issue at 
  all - unless there's some testcase that proves the opposite. )

with Peter's queue there are no underflows/overflows either anymore in 
any synthetic corner-case we could come up with. Peter's queue works 
well but it's 2.6.24 material.

Non-normalized wait-runtime is simply a different unit (resulting in 
slightly higher context-switch performance), the principle and the end 
result does not change.

All in one, we dont disagree, this is an incremental improvement we are 
thinking about for 2.6.24. We do disagree with this being positioned as 
something fundamentally different though - it's just the same thing 
mathematically, expressed without a "/weight" divisor, resulting in no 
change in scheduling behavior. (except for a small shift of CPU 
utilization for a synthetic corner-case)

And if we handled that fundamental aspect via Peter's queue, all the 
remaining changes you did can be done (and considered and merged) 
evolutionarily instead of revolutionarily, ontop of CFS - this should 
cut down on the size and the impact of your changes significantly!

So if you'd like to work with us on this and get items that make sense 
merged (which we'd very much like to see happen), could you please 
re-shape the rest of your changes and ideas (such as whether to use 
ready-queueing or a runqueue concept, which does look interesting) ontop 
of Peter's queue, and please do it as a finegrained, reviewable, 
mergable series of patches, like Peter did. Thanks!

	Ingo
