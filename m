Return-Path: <linux-kernel-owner+w=401wt.eu-S1751258AbZHTDaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751258AbZHTDaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 23:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751001AbZHTDaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 23:30:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57025 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbZHTDa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 23:30:29 -0400
Message-ID: <4A8CC365.8040007@cn.fujitsu.com>
Date: Thu, 20 Aug 2009 11:30:45 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca, mingo@elte.hu,
       josht@linux.vnet.ibm.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       hugh.dickins@tiscali.co.uk, benh@kernel.crashing.org
Subject: Re: [PATCH -tip/core/rcu] Fix rcu_migrate_callback() to allow for
 multiple waiters
References: <20090820013153.GA19944@linux.vnet.ibm.com>
In-Reply-To: <20090820013153.GA19944@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> The current interaction between rcu_barrier() and CPU hotplug can result
> in multiple tasks waiting on rcu_migrate_wq: there can be one CPU-hotplug
> notifier, and, because rcu_barrier() invokes wait_migrated_callbacks()
> outside of rcu_barrier_mutex, an arbitrarily large number of tasks
> executing in _rcu_barrier().  This situation could result in hangs,
> because rcu_migrate_callback() would wake up but one task.
> 
> This patch addresses this problem by awakening all sleepers.
> 
> Located-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
> 
>  rcupdate.c |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
> index bd5d5c8..6c59e1b 100644
> --- a/kernel/rcupdate.c
> +++ b/kernel/rcupdate.c
> @@ -211,10 +211,17 @@ void rcu_barrier_sched(void)
>  }
>  EXPORT_SYMBOL_GPL(rcu_barrier_sched);
>  
> +/*
> + * Wake up anyone waiting on migration of RCU callbacks from a CPU
> + * going offline.  There can be only one CPU-hotplug notifier waiting,
> + * but there can be any number of rcu_barrier() invocations waiting,
> + * due to the fact that rcu_barrier() does its wait outside of the
> + * rcu_barrier_mutex.
> + */
>  static void rcu_migrate_callback(struct rcu_head *notused)
>  {
>  	if (atomic_dec_and_test(&rcu_migrate_type_count))
> -		wake_up(&rcu_migrate_wq);
> +		wake_up_all(&rcu_migrate_wq);
>  }
>  
>  extern int rcu_cpu_notify(struct notifier_block *self,
> 

Maybe wake_up_all() is good for readability. But wake_up()
is enough for the logic.

In wait_migrated_callbacks(), we use wait_event(), The current
thread is queued as a non-exclusive waiter. And wake_up()
wakes up all non-exclusive waiter. (We only have
non-exclusive waiters in the rcu_migrate_wq)


