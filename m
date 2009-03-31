Return-Path: <linux-kernel-owner+w=401wt.eu-S1758700AbZCaGqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758700AbZCaGqF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 02:46:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755202AbZCaGpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 02:45:52 -0400
Received: from www.tglx.de ([62.245.132.106]:49581 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457AbZCaGpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 02:45:51 -0400
Date: Tue, 31 Mar 2009 08:44:45 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Darren Hart <dvhltc@us.ibm.com>
cc: linux-kernel@vger.kernel.org, Sripathi Kodi <sripathik@in.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       John Stultz <johnstul@us.ibm.com>, Steven Rostedt <rostedt@goodmis.org>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>,
       Sripathi Kodi <sripathik@in.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       John Stultz <johnstul@us.ibm.com>, Steven Rostedt <rostedt@goodmis.org>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>
Subject: Re: [tip PATCH v6 1/8] RFC: futex: futex_wait_queue_me()
In-Reply-To: <20090330213739.606.85804.stgit@Aeon>
Message-ID: <alpine.LFD.2.00.0903310836500.12916@localhost.localdomain>
References: <20090330213306.606.9540.stgit@Aeon> <20090330213739.606.85804.stgit@Aeon>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Mar 2009, Darren Hart wrote:
> +
> +	/* add_wait_queue is the barrier after __set_current_state. */
> +	__set_current_state(TASK_INTERRUPTIBLE);
> +	add_wait_queue(&q->waiter, &wait);
> +	/*
> +	 * NOTE: we don't remove ourselves from the waitqueue because
> +	 * we are the only user of it.
> +	 */

  This comment, while correct is at an odd place.

> +	/* Arm the timer */
> +	if (timeout) {
> +		hrtimer_start_expires(&timeout->timer, HRTIMER_MODE_ABS);
> +		if (!hrtimer_active(&timeout->timer))
> +			timeout->task = NULL;
> +	}
> +
> +	/*
> +	 * !plist_node_empty() is safe here without any lock.
> +	 * q.lock_ptr != 0 is not safe, because of ordering against wakeup.
> +	 */
> +	if (likely(!plist_node_empty(&q->list))) {
> +		/*
> +		 * If the timer has already expired, current will already be
> +		 * flagged for rescheduling. Only call schedule if there
> +		 * is no timeout, or if it has yet to expire.
> +		 */
> +		if (!timeout || likely(timeout->task))

  Remove the likely(). It does not make sense

> +			schedule();
> +	}
> +	__set_current_state(TASK_RUNNING);
> +}
> +
>  static int futex_wait(u32 __user *uaddr, int fshared,
>  		      u32 val, ktime_t *abs_time, u32 bitset, int clockrt)
>  {
> -	struct task_struct *curr = current;
> +	struct hrtimer_sleeper timeout, *to = NULL;
>  	struct restart_block *restart;
> -	DECLARE_WAITQUEUE(wait, curr);
>  	struct futex_hash_bucket *hb;
>  	struct futex_q q;
>  	u32 uval;
>  	int ret;
> -	struct hrtimer_sleeper t;
> -	int rem = 0;
>  
>  	if (!bitset)
>  		return -EINVAL;
>  
>  	q.pi_state = NULL;
>  	q.bitset = bitset;
> +
> +	if (abs_time) {
> +		unsigned long slack;

  missing new line

> +		to = &timeout;
> +		slack = current->timer_slack_ns;
> +		if (rt_task(current))
> +			slack = 0;

  Hmm. I thought we would use current->timer_slack_ns ?

Thanks,

	tglx
