Return-Path: <linux-kernel-owner+w=401wt.eu-S932718AbXIBJ03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932718AbXIBJ03 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 05:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754702AbXIBJ0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 05:26:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38264 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754677AbXIBJ0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 05:26:18 -0400
Date: Sun, 2 Sep 2007 11:26:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [ANNOUNCE/RFC] Really Fair Scheduler
Message-ID: <20070902092611.GA14783@elte.hu>
References: <Pine.LNX.4.64.0708310139280.1817@scrub.home> <20070831105447.GA17956@elte.hu> <Pine.LNX.4.64.0708311341510.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708311341510.1817@scrub.home>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Roman Zippel <zippel@linux-m68k.org> wrote:

> > with Peter's queue there are no underflows/overflows either anymore 
> > in any synthetic corner-case we could come up with. Peter's queue 
> > works well but it's 2.6.24 material.
> 
> Did you even try to understand what I wrote? I didn't say that it's a 
> "common problem", it's a conceptual problem. The rounding has been 
> improved lately, so it's not as easy to trigger with some simple busy 
> loops.

As i mentioned it in my first reply to you i really welcome your changes 
and your interest in the Linux scheduler, but i'm still somewhat 
surprised why you focus on rounding so much (and why you attack CFS's 
math implementation so vehemently and IMO so unfairly) - and we had this 
discussion before in the "CFS review" thread that you started.

The kind of rounding error you seem to be worried about is very, very 
small. For normal nice-0 tasks it's in the "one part per a hundred 
million" range, or smaller. As a comparison: "top"'s CPU utilization 
statistics are accurate to "one part per thousand" - and that's roughly 
the precision range that humans care about. (Graphical tools are even 
coarser - one part per hundred or worse.)

I suspect if rounding effects are measurable you will post numbers that 
prove it, correct? You did not do that so far. Or if they are not 
measurable for any workload we care about, why should we worry about it 
if it causes no problems in practice? (or if it causes problems, what 
are the actual effects and can they be addressed in a simpler way?)

The main reason i'm interested in changing the fairness math under CFS 
(be that Peter's changes or your changes) is _not_ primarily to address 
any rounding behavior, but to potentially improve performance! Rounding 
errors are at most an academic issue, unless they are actually 
measurable in a workload we care about. (If rounding gets improved as a 
side-effect of a change that's an added, albeit lower-prio bonus.) But 
even more important is quality of scheduling - performance is secondary 
to that. (unless performance is so bad that it becomes a quality issue: 
such as an O(N) algorithm would do.)

Your math is fairly simple (and that is _good_, just like CFS's existing 
math is simple), it can be summed up in essence as (without complicating 
it with nice-level weighting, for easy understandability):

" use the already existing p->sum_exec_runtime 'task runtime' metric 
  that CFS maintains, and use that as the key into the rb-tree that 
  selects tasks that should be run next. To handle sleeping tasks: keep 
  a per-rq sum of all runnable task's ->sum_exec_runtime values and 
  start newly woken tasks at the average rq->sum/nr_running value. "

Now your patch does not actually do it that way in a clearly discernible 
manner because lots of changes are intermixed into one big patch. 

( please correct me if i got your math wrong. Your patch does not add 
  any comments at all to the new code and this slowed down my review
  and analysis of your patch quite considerably. Lack of comments makes
  it harder to see the purpose and makes it harder to notice the
  benefits/tradeoffs involved in each change. )

Much of the remaining complexity in your patch i see as an add-on 
optimization to that concept: you use a quite complex Bresenham 
implementation that hides the real machinery of the code. Yes, rounding 
improves too with Breshenham, but to me that is secondary - i'm mainly 
interested in the performance aspects of Breshenham. There are 
advantages of your approach but it also has disadavantages: you removed 
sleeper fairness for example, which makes it harder to compare the 
scheduling quality of the two implementations.

To sum up: the math in your patch _could_ be implemented as a much 
smaller add-on to the already existing variables maintained by CFS, but 
you chose to do lots of changes, variable-renames and removals at once 
and posted them as one big change.

I really welcome large changes to the scheduler (hey, in the past 2.5 
years alone we added 350+ scheduler commits from over 95 unique 
contributors, so i'm as feature-happy as it gets), but it's far easier 
to review and merge stuff if it's nicely split up. (I'll eventually get 
through your patch too, but it's much harder that way and as you 
probably know every core kernel hacker is away for the Kernel Summit so 
dont expect much activity for a week or so.)

One conceptual reason behind the intrusive policy-modularization done in 
CFS was to _never again_ be forced to do "big" scheduler changes - we 
now can do most things in small, understandable steps.

I posted my very first, raw version of CFS after 3 days of hacking which 
showed the raw math and nothing more, and i posted every iteration since 
then, so you can follow through its history. _Please_, separate things 
out so that they can be reviewed one by one. And _please_ order the 
patches in "level of intrusiveness" order - i.e. leave the more 
intrusive patches as late in the patch-queue as possible. Thanks!

	Ingo
