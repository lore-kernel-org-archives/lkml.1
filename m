Return-Path: <linux-kernel-owner+w=401wt.eu-S1758619AbXICC5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619AbXICC5l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 22:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753945AbXICC5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 22:57:33 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:4485 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752888AbXICC5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 22:57:32 -0400
Date: Mon, 3 Sep 2007 04:58:03 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, peterz@infradead.org,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [ANNOUNCE/RFC] Really Fair Scheduler
In-Reply-To: <20070902092611.GA14783@elte.hu>
Message-ID: <Pine.LNX.4.64.0709021940241.1817@scrub.home>
References: <Pine.LNX.4.64.0708310139280.1817@scrub.home> <20070831105447.GA17956@elte.hu>
 <Pine.LNX.4.64.0708311341510.1817@scrub.home> <20070902092611.GA14783@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, 2 Sep 2007, Ingo Molnar wrote:

> > Did you even try to understand what I wrote? I didn't say that it's a 
> > "common problem", it's a conceptual problem. The rounding has been 
> > improved lately, so it's not as easy to trigger with some simple busy 
> > loops.
> 
> As i mentioned it in my first reply to you i really welcome your changes 
> and your interest in the Linux scheduler, but i'm still somewhat 
> surprised why you focus on rounding so much (and why you attack CFS's 
> math implementation so vehemently and IMO so unfairly) - and we had this 
> discussion before in the "CFS review" thread that you started.

The rounding is insofar a problem as it makes it very difficult to produce 
a correct mathematical model of CFS, which can be used to verify the 
working of code.
With the recent rounding changes they have indeed little effect in the 
short term, especially as the error is distributed equally to the task, so 
every task gets relatively the same time, the error still exists 
nonetheless and adds up over time (although with the rounding changes it 
doesn't grow into one direction anymore). The problem is now the limiting, 
which you can't remove as long as the error exists. Part of this problem
is that CFS doesn't really maintain a balanced sum of the available 
runtime, i.e. the sum of all updated wait_runtime values of all active 
tasks should be zero. This means under complex loads it's possible to hit 
the wait_runtime limits and the overflow/underflow time is lost in the 
calculation and this value can be easily in the millisecond range.
To be honest I have no idea how real this problem in the praxis is right 
now, quite possibly people will only see it as a small glitch and in most 
cases they won't even notice. Previously it had been rather easy to 
trigger these problems due to the rounding problems. The main problem for 
me here is now that with any substantial change in CFS I'm running risk of 
making this worse and noticable again somehow. For example CFS relies on 
the 64bit math to have enough resolution so that the errors aren't 
noticable.
That's why I needed a mathematical model I can work with and with it for 
example I can easily downscale the math to 32bit and I know exactly the 
limits within it will work correctly.

> Your math is fairly simple (and that is _good_, just like CFS's existing 
> math is simple),

I really wouldn't call CFS's existing math simple, the basic ideas are 
indeed simple, but that the math of the actual implementation is quite a 
bit more complex.

> it can be summed up in essence as (without complicating 
> it with nice-level weighting, for easy understandability):
> 
> " use the already existing p->sum_exec_runtime 'task runtime' metric 
>   that CFS maintains, and use that as the key into the rb-tree that 
>   selects tasks that should be run next. To handle sleeping tasks: keep 
>   a per-rq sum of all runnable task's ->sum_exec_runtime values and 
>   start newly woken tasks at the average rq->sum/nr_running value. "
> 
> Now your patch does not actually do it that way in a clearly discernible 
> manner because lots of changes are intermixed into one big patch. 

Well, it's part of the math, but I wouldn't call it the "essence" of the 
_math_, as it leaves many questions unanswered, the essence of the math 
mainly involves how the problems are solved created by the weighting.

If you want to describe the basic logical differences, you can do it a 
little simpler: CFS maintains the runtime of a task relative to a global 
clock, while in my model every task has its own clock and an approximated 
average is used to initialize the clock of new tasks.

> ( please correct me if i got your math wrong. Your patch does not add 
>   any comments at all to the new code and this slowed down my review
>   and analysis of your patch quite considerably. Lack of comments makes
>   it harder to see the purpose and makes it harder to notice the
>   benefits/tradeoffs involved in each change. )

I hope you did notice that I explained in the announcement in quite detail 
what the code does.

> To sum up: the math in your patch _could_ be implemented as a much 
> smaller add-on to the already existing variables maintained by CFS, but 
> you chose to do lots of changes, variable-renames and removals at once 
> and posted them as one big change.

I didn't rename that much and there are only a few that could be reused, 
for most part I indeed removed quite a bit and the rest really has a 
different meaning.

>  _Please_, separate things 
> out so that they can be reviewed one by one.

That's not really the problem, but _please_ someone explain to me the 
features you want to see preserved. I don't want to be left at guessing 
what they're intendend to do and blindly implement something which should 
do something similiar.
Thanks.

bye, Roman
