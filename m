Return-Path: <linux-kernel-owner+w=401wt.eu-S1758270AbYHUKry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270AbYHUKry (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 06:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754328AbYHUKrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 06:47:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39454 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753784AbYHUKrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 06:47:45 -0400
Date: Thu, 21 Aug 2008 12:47:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Gregory Haskins <ghaskins@novell.com>, vatsa <vatsa@in.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: properly account IRQ and RT load in SCHED_OTHER
	load balancing
Message-ID: <20080821104718.GA28331@elte.hu>
References: <1219310330.8651.93.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219310330.8651.93.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> Subject: sched: properly account IRQ and RT load in SCHED_OTHER load balancing
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Thu Aug 14 09:31:20 CEST 2008
> 
> We used to account for RT tasks in SCHED_OTHER load-balancing by giving
> them some phantom weight.
> 
> This is incorrect because there is no saying how much time a RT task 
> will actually consume. Also, it doesn't take IRQ time into account.
> 
> This patch tries to solve this issue by accounting the time spend on 
> both Real-Time tasks and IRQ handling, and using that to 
> proportionally inflate the SCHED_OTHER load.

applied it to tip/sched/devel for more testing.

this bit:

> +void sched_irq_enter(void)
> +{
> +	if (!in_irq()) {
> +		struct rq *rq = this_rq();
> +
> +		update_rq_clock(rq);
> +		rq->irq_stamp = rq->clock;
> +	}

if we do this we might as well use the opportunity to do accurate IRQ 
(and softirq) CPU time accounting. I.e. right now it only drives 
balancing, but isnt fed into the wider IRQ/softirq /proc usage stats.

	Ingo
