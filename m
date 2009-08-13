Return-Path: <linux-kernel-owner+w=401wt.eu-S1755266AbZHMTZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266AbZHMTZP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:25:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753172AbZHMTZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:25:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48693 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753079AbZHMTZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:25:13 -0400
Date: Thu, 13 Aug 2009 12:24:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Thomas Gleixner <tglx@linutronix.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT pull] genirq fixes for 2.6.31
In-Reply-To: <alpine.LFD.2.00.0908132100210.1283@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0908131211550.28882@localhost.localdomain>
References: <alpine.LFD.2.00.0908132100210.1283@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 13 Aug 2009, Thomas Gleixner wrote:
>
> Please pull the latest irq-fixes-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-fixes-for-linus

Not without lots more explanations - or at least _fixed_ explanations.

> Thomas Gleixner (1):
>       genirq: Prevent race between free_irq() and handle_IRQ_event()
> 
> 
>  kernel/irq/handle.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
> index 065205b..4e7f17a 100644
> --- a/kernel/irq/handle.c
> +++ b/kernel/irq/handle.c
> @@ -403,8 +403,16 @@ irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
>  			 */
>  			if (likely(!test_bit(IRQTF_DIED,
>  					     &action->thread_flags))) {
> +				struct task_struct *tsk = action->thread;
> +
>  				set_bit(IRQTF_RUNTHREAD, &action->thread_flags);
> -				wake_up_process(action->thread);
> +				/*
> +				 * Check tsk as we might race against
> +				 * free_irq which sets action->thread
> +				 * to NULL
> +				 */
> +				if (tsk)
> +					wake_up_process(tsk);

Seriously, this looks entirely bogus.

The thing is, if "action" has been free'd, then dammit, 'tsk' is gone too. 
In fact, just look at _free_irq(), and realise how it does the

        if (irqthread) {
                if (!test_bit(IRQTF_DIED, &action->thread_flags))
                        kthread_stop(irqthread);
                put_task_struct(irqthread);
        }

_before_ it free's 'action'. So what does that fix?

There is no race that I can see - we're holding "action->lock" while all 
this happens.

Now, I can see a bug, which is that "action->tsk" may have been set to 
NULL. But I can't see a race, and I can't see a reason for all the code 
movement. So quite frankly, I think the comments (both in the code and in 
the commit message) are just wrong. And the odd "load it first, then do 
other things" code looks confused.

So why is this not just a

	if (action->thread)
		wake_up_process(action->thread);

with appropriate comments?

Or, alternatively, just move all the "clear action->thread" in free_irq() 
to after having done the "synchronize_irq()" thing, and then - afaik - 
you'll not need that test at all, because you're guaranteed that as long 
as you're in an interrupt handler, the thing shouldn't be cleared.

No?

		Linus
