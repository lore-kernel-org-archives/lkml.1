Return-Path: <linux-kernel-owner+w=401wt.eu-S1752673AbXIDGa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673AbXIDGa0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 02:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbXIDGaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 02:30:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58528 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300AbXIDGaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 02:30:10 -0400
Date: Tue, 4 Sep 2007 08:29:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [ANNOUNCE/RFC] Really Simple Really Fair Scheduler
Message-ID: <20070904062957.GA25634@elte.hu>
References: <20070902120154.GA23769@elte.hu> <Pine.LNX.4.64.0709032030320.1817@scrub.home> <20070903185403.GA23479@elte.hu> <Pine.LNX.4.64.0709032106070.1817@scrub.home> <20070903192050.GA29049@elte.hu> <Pine.LNX.4.64.0709032140140.1817@scrub.home> <20070903200405.GA2943@elte.hu> <Pine.LNX.4.64.0709040130360.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709040130360.1817@scrub.home>
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

> > > It's a variation of the sleeper bonus. [...]
> > 
> > hm, where are its effects described in your explanation? Seems like a 
> > key item.
> 
> It has no direct effect on the correctness of the mathematical model, 
> the time is initialized before the time is added to the model. What 
> you're after is the effect on the behaviour, which wasn't my focus, so 
> sorry, I didn't mention it.

and what about the mirror image problem? Your math assumes that tasks 
use up their full timeslices, somewhere starting at (12):

| (12)    time_norm_app = sum_{t}^{T}(time_norm_{t} * weight_{t}) /
|                                            sum_{t}^{T}(weight_{t})
|
| This produces only a approximate normalized time, but if all 
| time_norm_{t} are equal (i.e. all tasks got their share), the result 
| is the same, thus the error is only temporary.

>From here on the reasoning and the math is flawed i believe: it assumes 
that tasks use up their timeslices - which is rarely the case.

In practical terms: your code causes unfairness to tasks that sleep when 
they have used up only a fraction of their slice, when they are in a 
fairness-deficit. For example consider a task that just waited alot to 
get on the CPU, and when it finally got there (gathering a fairness 
deficit of say 9 milliseconds), a hundred microseconds later it sleeps.

The problem is that when it wakes up and gets back on the runqueue your 
code "forgets" that the task is in "need of fairness" by 9 milliseconds: 
the task continues as if its previous starvation didnt happen at all. 
This effect can cause _far more noise_ and even systematic starvation 
than any numeric rounding effects could cause. (This could perhaps 
explain the unfairness Mike reported, and this could perhaps explain the 
noisy hackbench results i'm seeing with your patch - although i'm not 
certain about this, i havent looked into those usecases in detail.)

CFS's current math addresses this problem via the use of the fair-clock 
metric and via ->wait_runtime: that gives us a good idea what happened 
to the system while the task slept. With your model, that information is 
not maintained at all, and is not regainable. At the moment i dont see 
how we could achieve good sleeper behavior with your model, you've 
over-simplified the scheduler metrics and we've lost essential 
information.

That's why i'm concentrating on the basic scheduling properties first, 
without considering nice levels, rounding or optimizations - if that 
basic model does not fit then a scheduler cannot work. That's also why 
i've asked for a split-up patch series - it makes it far easier to 
review and test the code and it makes it far easier to quickly apply the 
obviously correct bits.

And i'd like to concur with Tong Li's observation that currently CFS is 
a very generic fair scheduler upon which a multitude of scheduling 
variants can be built and prototyped (we use a specific one right now, 
but it's not cast into stone). The 30-lines-changed patch i sent shows 
this property of CFS pretty well - and it already demonstrates the 
issues we are talking about here.

	Ingo
