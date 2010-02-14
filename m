Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758411Ab0BNKNA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 05:13:00 -0500
Received: from casper.infradead.org ([85.118.1.10]:60696 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758379Ab0BNKMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 05:12:49 -0500
Subject: Re: [PATCH tip/core/rcu 06/13] sched: use lockdep-based checking
 on rcu_dereference()
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com
In-Reply-To: <1265932839-25899-6-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20100212000016.GA25781@linux.vnet.ibm.com>
	 <1265932839-25899-6-git-send-email-paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Feb 2010 11:12:12 +0100
Message-ID: <1266142332.5273.415.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-11 at 16:00 -0800, Paul E. McKenney wrote:
> +               first = rcu_dereference_check(pid->tasks[type].first, rcu_read_lock_held() || lockdep_is_held(&tasklist_lock));
>                 if (first)
>                         result = hlist_entry(first, struct task_struct, pids[(type)].node);
>         }

I've seen that particular combination a few times in this patch, would
it make sense to create rcu_dereference_task()?

> diff --git a/kernel/sched.c b/kernel/sched.c
> index c535cc4..ad419d9 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -645,6 +645,11 @@ static inline int cpu_of(struct rq *rq)
>  #endif
>  }
>  
> +#define for_each_domain_rd(p) \
> +       rcu_dereference_check((p), \
> +                             rcu_read_lock_sched_held() || \
> +                             lockdep_is_held(&sched_domains_mutex))
> + 

Would rcu_dereference_rd() not be a better name?


