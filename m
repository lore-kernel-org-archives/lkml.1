Return-Path: <linux-kernel-owner+w=401wt.eu-S1757003AbYBSNAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003AbYBSNAc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 08:00:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbYBSNAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 08:00:22 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:3997 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbYBSNAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 08:00:21 -0500
Date: Tue, 19 Feb 2008 13:00:48 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Rusty Russel <rusty@rustcorp.com.au>
Subject: Re: [PATCH, RFC] kthread: (possibly) a missing memory barrier in kthread_stop()
Message-ID: <20080219130033.GK24479@shadowen.org>
References: <1203375817.7619.73.camel@earth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203375817.7619.73.camel@earth>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 12:03:37AM +0100, Dmitry Adamushko wrote:
> 
> Hi,
> 
> 
> [ description ]
> 
> Subject: kthread: add a memory barrier to kthread_stop()
> 
> 'kthread' threads do a check in the following order:
> - set_current_state(TASK_INTERRUPTIBLE);
> - kthread_should_stop();
> 
> and set_current_state() implies an smp_mb().
> 
> on another side (kthread_stop), wake_up_process() does not seem to
> guarantee a full mb.
> 
> And 'kthread_stop_info.k' must be visible before wake_up_process()
> checks for/modifies a state of the 'kthread' task.
> 
> (the patch is at the end of the message)
> 
> 
> [ more detailed description ]
> 
> the current code might well be safe in case a to-be-stopped 'kthread'
> task is _not_ running on another CPU at the moment when kthread_stop()
> is called (in this case, 'rq->lock' will act as a kind of synch.
> point/barrier).
> 
> Another case is as follows:
> 
> CPU#0:
> 
> ...
> while (kthread_should_stop()) {
> 
>        if (condition)
>              schedule();
> 
>        /* ... do something useful ... */   <--- EIP
> 
>        set_current_state(TASK_INTERRUPTIBLE);
> }
> 
> so a 'kthread' task is about to call
> set_current_state(TASK_INTERRUPTIBLE) ...
> 
> 
> (in the mean time)
> 
> CPU#1:
> 
> kthread_stop()
> 
> -> kthread_stop_info.k = k                 (*)
> -> wake_up_process()
> 
> wake_up_process() looks like:
> 
> (try_to_wake_up)
> 
> IRQ_OFF
> LOCK
> 
> old_state = p->state;
> if (!(old_state & state))                  (**)
>          goto out;
> 
> ...
> 
> UNLOCK
> IRQ_ON
> 
> 
> let's suppose (*) and (**) are reordered
> (according to Documentation/memory-barriers.txt, neither IRQ_OFF nor
> LOCK may prevent it from happening).
> 
> - the state is TASK_RUNNING, so we are about to return.
> 
> - CPU#1 is about to execute (*) (it's guaranteed to be done before
> spin_unlock(&rq->lock) at the end of try_to_wake_up())
> 
> 
> (in the mean time)
> 
> CPU#0:
> 
> - set_current_state(TASK_INTERRUPTIBLE);
> - kthread_should_stop();
> 
> here, kthread_stop_info.k is not yet visible
> 
> - schedule()
> 
> ... 
> 
> we missed a 'kthread_stop' event.
> 
> hum?
> 
> 
> TIA,
> 
> ---
> 
> From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
> Subject: kthread: add a memory barrier to kthread_stop()
> 
> 'kthread' threads do a check in the following order:
> - set_current_state(TASK_INTERRUPTIBLE);
> - kthread_should_stop();
> 
> and set_current_state() implies an smp_mb().
> 
> on another side (kthread_stop), wake_up_process() is not guaranteed to
> act as a full mb.
> 
> 'kthread_stop_info.k' must be visible before wake_up_process() checks
> for/modifies a state of the 'kthread' task.
> 
> 
> Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>
> 
> 
> diff --git a/kernel/kthread.c b/kernel/kthread.c
> index 0ac8878..5167110 100644
> --- a/kernel/kthread.c
> +++ b/kernel/kthread.c
> @@ -211,6 +211,10 @@ int kthread_stop(struct task_struct *k)
>  
>  	/* Now set kthread_should_stop() to true, and wake it up. */
>  	kthread_stop_info.k = k;
> +
> +	/* The previous store operation must not get ahead of the wakeup. */
> +	smp_mb();
> +
>  	wake_up_process(k);
>  	put_task_struct(k);

The rules as written do seem to support your theory.  The CPU has every
right to delay the .k = k as late as the UNLOCK operation.

On the read-side there is a full barrier implied by the
set_current_state(TASK_INTERRUPTIBLE), however this synchronises us with
the current global state, which may well not have the updated version
of .k.

That seems to imply that a write memory barrier would be sufficient to
cover this.

So three comments.  First, should this not be an smp_wmb.  Second, this
memory barrier is paired with the barrier in
set_current_state(TASK_INTERRUPTIBLE) and that probabally should be
documented as part of this patch.  Finally, I think the comment as is is
hard to understand I got the sense of it backwards on first reading;
perhaps something like this:

	/*
	 * Ensure kthread_stop_info.k is visible before wakeup, paired
	 * with barrier in set_current_state().
	 */

-apw
