Return-Path: <linux-kernel-owner+w=401wt.eu-S2993232AbXECPRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993232AbXECPRt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 11:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993235AbXECPRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 11:17:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60956 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993232AbXECPRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 11:17:47 -0400
Date: Thu, 3 May 2007 17:17:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ting Yang <tingy@cs.umass.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v7
Message-ID: <20070503151741.GC1812@elte.hu>
References: <200704300820.49078.a1426z@gawab.com> <20070503074552.GA14960@elte.hu> <4639F970.5080701@cs.umass.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4639F970.5080701@cs.umass.edu>
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


* Ting Yang <tingy@cs.umass.edu> wrote:

> +    s64 __delta = curr->fair_key - p->fair_key;
> +
> +    /*
> +     * Take scheduling granularity into account - do not
> +     * preempt the current task unless the best task has
> +     * a larger than sched_granularity fairness advantage:
> +     */
> +    if (__delta > niced_granularity(rq, curr, granularity))
> +        resched_task(curr);
> +}
> 
> This code actually now says, the difference of fair_key needed to 
> preempt the current task is amplified by a facto of its weigh (in Al 
> Boldi's example 32). However, the weighted task already advance its 
> p->fair_key by its weight, (also 32 here). The combination of them 
> becomes quadratic!

it's not quadratic in terms of CPU share: the first factor impacts the 
CPU share, the second factor impacts the granularity. This means that 
reniced workloads will be preempted in a more finegrained way - but 
otherwise there's _no_ quadratic effect for CPU time - which is a 
completely separate metric. Remember: there are no timeslices in CFS, so 
a task can be preempted any number of times without being at a 
disadvantage.

>     Besides this quadratic effect, another minor issue amplified this 
> a little bit further: p->wait_runtime accumulated before. [...]

actually, this 'minor issue' was the main issue that caused the bug ;-)

	Ingo
