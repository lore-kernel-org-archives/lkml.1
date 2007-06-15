Return-Path: <linux-kernel-owner+w=401wt.eu-S1755196AbXFOPwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbXFOPwj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 11:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbXFOPwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 11:52:31 -0400
Received: from mail.screens.ru ([213.234.233.54]:57759 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064AbXFOPwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 11:52:30 -0400
Date: Fri, 15 Jun 2007 19:52:31 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: john stultz <johnstul@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -rt] Fix TASKLET_STATE_SCHED WARN_ON()
Message-ID: <20070615155231.GA345@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

john stultz wrote:
>
> The following additional patch should correct this issue. Although since
> we weren't actually hitting it, the issue is a bit theoretical, so I've
> not been able to prove it really fixes anything.

Could you please look at the message below? I sent it privately near a month
ago, but I think these problems are not fixed yet.

Oleg.

---------------------------------------------------------------------------

> +__tasklet_action(struct softirq_action *a, struct tasklet_struct *list)
> +{
> +	int loops = 1000000;
>  
>  	while (list) {
>  		struct tasklet_struct *t = list;
>  
>  		list = list->next;
> +		/*
> +		 * Should always succeed - after a tasklist got on the
> +		 * list (after getting the SCHED bit set from 0 to 1),
> +		 * nothing but the tasklet softirq it got queued to can
> +		 * lock it:
> +		 */
> +		if (!tasklet_trylock(t)) {
> +			WARN_ON(1);
> +			continue;
> +		}
> +
> +		t->next = NULL;
> +
> +		/*
> +		 * If we cannot handle the tasklet because it's disabled,
> +		 * mark it as pending. tasklet_enable() will later
> +		 * re-schedule the tasklet.
> +		 */
> +		if (unlikely(atomic_read(&t->count))) {
> +out_disabled:
> +			/* implicit unlock: */
> +			wmb();
> +			t->state = TASKLET_STATEF_PENDING;

What if tasklet_enable() happens just before this line ?

After the next schedule_tasklet() we have all bits set: SCHED, RUN, PENDING.
The next invocation of __tasklet_action() clears SCHED, but tasklet_tryunlock()
below can never succeed because of PENDING.

> +again:
> +		t->func(t->data);
> +
> +		/*
> +		 * Try to unlock the tasklet. We must use cmpxchg, because
> +		 * another CPU might have scheduled or disabled the tasklet.
> +		 * We only allow the STATE_RUN -> 0 transition here.
> +		 */
> +		while (!tasklet_tryunlock(t)) {
> +			/*
> +			 * If it got disabled meanwhile, bail out:
> +			 */
> +			if (atomic_read(&t->count))
> +				goto out_disabled;
> +			/*
> +			 * If it got scheduled meanwhile, re-execute
> +			 * the tasklet function:
> +			 */
> +			if (test_and_clear_bit(TASKLET_STATE_SCHED, &t->state))
> +				goto again;

TASKLET_STATE_SCHED could be set by tasklet_kill(), in this case it is not nice
to call t->func() again (but probably harmless).

