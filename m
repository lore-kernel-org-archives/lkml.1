Return-Path: <linux-kernel-owner+w=401wt.eu-S933728AbZJMHqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933728AbZJMHqL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 03:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759065AbZJMHqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 03:46:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57458 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758982AbZJMHqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 03:46:09 -0400
Message-ID: <4AD42FF5.2080109@cn.fujitsu.com>
Date: Tue, 13 Oct 2009 15:44:53 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, avi@redhat.com,
       mtosatti@redhat.com, torvalds@linux-foundation.org
Subject: Re: [PATCH RFC tip/core/rcu 1/3] rcu: The Bloatwatch Edition, v7
References: <20091009224954.GA26516@linux.vnet.ibm.com> <12551286511987-git-send-email->
In-Reply-To: <12551286511987-git-send-email->
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Again. trivial code-beautifying except the last one.

Paul E. McKenney wrote:

[...]

> +
> +/* Global control variables for rcupdate callback mechanism. */
> +struct rcu_ctrlblk {
> +	struct rcu_head *rcucblist;	/* List of pending callbacks (CBs). */
> +	struct rcu_head **donetail;	/* ->next pointer of last "done" CB. */
> +	struct rcu_head **curtail;	/* ->next pointer of last CB. */
> +};
> +
> +extern struct rcu_ctrlblk rcu_ctrlblk;
> +extern struct rcu_ctrlblk rcu_bh_ctrlblk;

Since rcu_batches_completed() returns a constant, this piece of
code is not needed here. We can move it to rcutiny.c.

and remove "EXPORT_SYMBOL_GPL(rcu_ctrlblk);" &
"EXPORT_SYMBOL_GPL(rcu_bh_ctrlblk);".

[...]

> +/* extern void rcu_restart_cpu(int cpu); */
> +

redundant comments.

[...]

> +
> +static inline int rcu_pending(int cpu)
> +{
> +	return 1;
> +}

It seems that no one use it.

[...]

> +/* Definition for rcupdate control block. */
> +struct rcu_ctrlblk rcu_ctrlblk = {
> +	.rcucblist = NULL,
> +	.donetail = &rcu_ctrlblk.rcucblist,
> +	.curtail = &rcu_ctrlblk.rcucblist,
> +};
> +EXPORT_SYMBOL_GPL(rcu_ctrlblk);

remove "EXPORT_SYMBOL_GPL(rcu_ctrlblk);"

> +struct rcu_ctrlblk rcu_bh_ctrlblk = {
> +	.rcucblist = NULL,
> +	.donetail = &rcu_bh_ctrlblk.rcucblist,
> +	.curtail = &rcu_bh_ctrlblk.rcucblist,
> +};
> +EXPORT_SYMBOL_GPL(rcu_bh_ctrlblk);

remove "EXPORT_SYMBOL_GPL(rcu_bh_ctrlblk);"

> +
> +#ifdef CONFIG_NO_HZ
> +
> +static long rcu_dynticks_nesting = 1;
> +
> +/*
> + * Enter dynticks-idle mode, which is an extended quiescent state
> + * if we have fully entered that mode (i.e., if the new value of
> + * dynticks_nesting is zero).
> + */
> +void rcu_enter_nohz(void)
> +{
> +	if (--rcu_dynticks_nesting == 0)
> +		rcu_sched_qs(0); /* implies rcu_bh_qsctr_inc(0) */
> +}
> +
> +/*
> + * Exit dynticks-idle mode, so that we are no longer in an extended
> + * quiescent state.
> + */
> +void rcu_exit_nohz(void)
> +{
> +	rcu_dynticks_nesting++;
> +}
> +
> +#endif /* #ifdef CONFIG_NO_HZ */

It's an old issue.
It's not only about RCUTINY, it's also about other rcu implementations:

rcu_enter_nohz()/rcu_exit_nohz() are not called in pairs.

irq_exit() calls tick_nohz_stop_sched_tick() which calls rcu_enter_nohz(),
where is the corresponding rcu_exit_nohz()?
(or tick_nohz_restart_sched_tick())?
