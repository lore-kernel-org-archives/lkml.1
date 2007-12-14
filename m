Return-Path: <linux-kernel-owner+w=401wt.eu-S1756437AbXLNOwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437AbXLNOwZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 09:52:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbXLNOwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 09:52:17 -0500
Received: from saeurebad.de ([85.214.36.134]:46694 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223AbXLNOwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 09:52:16 -0500
From: Johannes Weiner <hannes-kernel@saeurebad.de>
To: ego@in.ibm.com
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Paul E McKenney <paulmck@us.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ted Tso <tytso@us.ibm.com>,
       dvhltc@us.ibm.com, Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>, bunk@kernel.org,
       Josh Triplett <josh@freedesktop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH 2/6] Preempt-RCU: Reorganize RCU code into rcuclassic.c and rcupdate.c
References: <20071213170348.GA25981@in.ibm.com>
	<20071213171508.GC25981@in.ibm.com>
Date: Fri, 14 Dec 2007 15:51:14 +0100
In-Reply-To: <20071213171508.GC25981@in.ibm.com> (Gautham R. Shenoy's message
	of "Thu, 13 Dec 2007 22:45:08 +0530")
Message-ID: <x7fxy572jh.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Gautham R Shenoy <ego@in.ibm.com> writes:

> diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
> new file mode 100644
> index 0000000..11c16aa
> --- /dev/null
> +++ b/kernel/rcuclassic.c
> +/**
> + * call_rcu - Queue an RCU callback for invocation after a grace period.
> + * @head: structure to be used for queueing the RCU updates.
> + * @func: actual update function to be invoked after the grace period
> + *
> + * The update function will be invoked some time after a full grace
> + * period elapses, in other words after all currently executing RCU
> + * read-side critical sections have completed.  RCU read-side critical
> + * sections are delimited by rcu_read_lock() and rcu_read_unlock(),
> + * and may be nested.
> + */
> +void call_rcu(struct rcu_head *head,
> +				void (*func)(struct rcu_head *rcu))
> +{
> +	unsigned long flags;
> +	struct rcu_data *rdp;
> +
> +	head->func = func;
> +	head->next = NULL;
> +	local_irq_save(flags);
> +	rdp = &__get_cpu_var(rcu_data);
> +	*rdp->nxttail = head;
> +	rdp->nxttail = &head->next;
> +	if (unlikely(++rdp->qlen > qhimark)) {
> +		rdp->blimit = INT_MAX;
> +		force_quiescent_state(rdp, &rcu_ctrlblk);
> +	}
> +	local_irq_restore(flags);
> +}
> +EXPORT_SYMBOL_GPL(call_rcu);
> +
> +/**
> + * call_rcu_bh - Queue an RCU for invocation after a quicker grace period.
> + * @head: structure to be used for queueing the RCU updates.
> + * @func: actual update function to be invoked after the grace period
> + *
> + * The update function will be invoked some time after a full grace
> + * period elapses, in other words after all currently executing RCU
> + * read-side critical sections have completed. call_rcu_bh() assumes
> + * that the read-side critical sections end on completion of a softirq
> + * handler. This means that read-side critical sections in process
> + * context must not be interrupted by softirqs. This interface is to be
> + * used when most of the read-side critical sections are in softirq context.
> + * RCU read-side critical sections are delimited by rcu_read_lock() and
> + * rcu_read_unlock(), * if in interrupt context or rcu_read_lock_bh()
> + * and rcu_read_unlock_bh(), if in process context. These may be nested.
> + */
> +void call_rcu_bh(struct rcu_head *head,
> +				void (*func)(struct rcu_head *rcu))
> +{
> +	unsigned long flags;
> +	struct rcu_data *rdp;
> +
> +	head->func = func;
> +	head->next = NULL;
> +	local_irq_save(flags);
> +	rdp = &__get_cpu_var(rcu_bh_data);
> +	*rdp->nxttail = head;
> +	rdp->nxttail = &head->next;
> +
> +	if (unlikely(++rdp->qlen > qhimark)) {
> +		rdp->blimit = INT_MAX;
> +		force_quiescent_state(rdp, &rcu_bh_ctrlblk);
> +	}
> +
> +	local_irq_restore(flags);
> +}
> +EXPORT_SYMBOL_GPL(call_rcu_bh);

Those two functions are identical beside the difference of `rcu_data'
<-> `rcu_bh_data' and `rcu_ctrlblk' <-> `rcu_bh_ctrlblk'.

Is there a way to collapse the code into one helper function or would
that effect performance too much?

	Hannes
