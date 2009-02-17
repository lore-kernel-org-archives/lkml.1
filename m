Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbZBQUGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbZBQUGf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 15:06:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbZBQUG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 15:06:27 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58904 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028AbZBQUG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 15:06:27 -0500
Date: Tue, 17 Feb 2009 21:02:47 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v4] generic-ipi: remove kmalloc()
Message-ID: <20090217200247.GA8158@redhat.com>
References: <20090216163847.431174825@chello.nl> <20090216164114.433430761@chello.nl> <1234885258.4744.153.camel@laptop> <20090217172113.GA26459@redhat.com> <1234892420.4744.158.camel@laptop> <1234898958.4744.225.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234898958.4744.225.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17, Peter Zijlstra wrote:
>
> +	list_for_each_entry_rcu(data, &call_function.queue, csd.list) {
> +		void (*func)(void *);
> +		void *info;
> +		int refs, wait;
>  
>  		spin_lock(&data->lock);
> -		cpumask_clear_cpu(cpu, to_cpumask(data->cpumask_bits));
> +		if (!cpumask_test_cpu(cpu, data->cpumask)) {
> +			spin_unlock(&data->lock);
> +			continue;
> +		}
> +		cpumask_clear_cpu(cpu, data->cpumask);
>  		WARN_ON(data->refs == 0);
> -		data->refs--;
> -		refs = data->refs;
> +		refs = --data->refs;
> +		func = data->csd.func;
> +		info = data->csd.info;
> +		wait = (data->csd.flags & CSD_FLAG_WAIT);
>  		spin_unlock(&data->lock);
>  
> -		if (refs)
> -			continue;
> +		if (!refs) {
> +			spin_lock(&call_function.lock);
> +			list_del_rcu(&data->csd.list);
> +			spin_unlock(&call_function.lock);
> +			csd_unlock(&data->csd);
> +		}
>  
> -		spin_lock(&call_function_lock);
> -		list_del_rcu(&data->csd.list);
> -		spin_unlock(&call_function_lock);
> +		func(info);
>  
> -		if (data->csd.flags & CSD_FLAG_WAIT) {
> -			/*
> -			 * serialize stores to data with the flag clear
> -			 * and wakeup
> -			 */
> -			smp_wmb();
> -			data->csd.flags &= ~CSD_FLAG_WAIT;
> -		}
> -		if (data->csd.flags & CSD_FLAG_ALLOC)
> -			call_rcu(&data->rcu_head, rcu_free_call_data);
> +		if (!refs && wait)
> +			csd_complete(&data->csd);

Argh! Sorry-sorry-sorry. I managed to confused myself and you.

Please return to the previous version. With this patch we do:

		func(info);

		if (!refs && wait)
			csd_complete();

but we can't do csd_complete(), we can not be sure other CPUs
has already passed this function call.

Of course we can add another counter, but I don't think this
worth the trouble.


As for the previous version. I am almost sure I missed something
again, but do we really need both CSD_FLAG_WAIT and CSD_FLAG_LOCK
flags? smp_call_function_many(wait => 1) can just wait for
!CSD_FLAG_LOCK.

Oleg.

