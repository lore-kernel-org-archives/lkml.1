Return-Path: <linux-kernel-owner+w=401wt.eu-S1756999AbZERH5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999AbZERH5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 03:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756847AbZERH5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 03:57:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47677 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756462AbZERH5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 03:57:11 -0400
Date: Mon, 18 May 2009 09:56:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       netfilter-devel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, davem@davemloft.net, dada1@cosmosbay.com,
       zbr@ioremap.net, jeff.chua.linux@gmail.com, paulus@samba.org,
       laijs@cn.fujitsu.com, jengelh@medozas.de, r000n@r000n.net,
       benh@kernel.crashing.org, mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH RFC] v5 expedited "big hammer" RCU grace periods
Message-ID: <20090518075630.GA10687@elte.hu>
References: <20090517191141.GA25915@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090517191141.GA25915@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> +void sched_expedited_wake(void *unused)
> +{
> +	mutex_lock(&__get_cpu_var(sched_expedited_done_mutex));
> +	if (__get_cpu_var(sched_expedited_done_qs) ==
> +	    SCHED_EXPEDITED_QS_DONE_QS) {
> +		__get_cpu_var(sched_expedited_done_qs) =
> +			SCHED_EXPEDITED_QS_NEED_QS;
> +		wake_up(&__get_cpu_var(sched_expedited_qs_wq));
> +	}
> +	mutex_unlock(&__get_cpu_var(sched_expedited_done_mutex));
> +}

( hm, IPI handlers are supposed to be atomic. )

> +/*
> + * Kernel thread that processes synchronize_sched_expedited() requests.
> + * This is implemented as a separate kernel thread to avoid the need
> + * to mess with other tasks' cpumasks.
> + */
> +static int krcu_sched_expedited(void *arg)
> +{
> +	int cpu;
> +	int mycpu;
> +	int nwait;
> +
> +	do {
> +		wait_event_interruptible(need_sched_expedited_wq,
> +					 need_sched_expedited);
> +		smp_mb(); /* In case we didn't sleep. */
> +		if (!need_sched_expedited)
> +			continue;
> +		need_sched_expedited = 0;
> +		get_online_cpus();
> +		preempt_disable();
> +		mycpu = smp_processor_id();
> +		smp_call_function(sched_expedited_wake, NULL, 1);
> +		preempt_enable();

i might be missing something fundamental here, but why not just have 
per CPU helper threads, all on the same waitqueue, and wake them up 
via a single wake_up() call? That would remove the SMP cross call 
(wakeups do immediate cross-calls already).

Even more - we already have a per-CPU, high RT priority helper 
thread that could be reused: the per CPU migration threads. Couldnt 
we queue these requests to them? RCU is arguably closely related to 
scheduling so there's no layering violation IMO.

There's already a struct migration_req machinery that performs 
something quite similar. (do work on behalf of another task, on a 
specific CPU, and then signal completion)

Also, per CPU workqueues have similar features as well.

	Ingo
