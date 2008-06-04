Return-Path: <linux-kernel-owner+w=401wt.eu-S1760562AbYFDMB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760562AbYFDMB3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 08:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754208AbYFDMBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 08:01:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50073 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160AbYFDMBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 08:01:18 -0400
Subject: Re: [PATCH] sched: fix cpupri hotplug support
From: Peter Zijlstra <peterz@infradead.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutonix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
In-Reply-To: <20080604032200.4821.87502.stgit@novell1.haskins.net>
References: <20080604032200.4821.87502.stgit@novell1.haskins.net>
Content-Type: text/plain
Date: Wed, 04 Jun 2008 13:59:56 +0200
Message-Id: <1212580796.23439.10.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-03 at 23:24 -0400, Gregory Haskins wrote:
> Hi Ingo, Steven, Thomas,
>   This patch is critical to fix a snafu in the root-domain/cpupri code.  It
>   applies to 25.4-rt4, but as mentioned below it affects most recent -rt
>   kernels as well as sched-devel.  If you accept this patch, and you have
>   non-trivial merge issues with other flavors just let me know and I will port
>   it to those kernels as well.
> 
> Regards
> -Greg
> 
> --------------------------------
> sched: fix cpupri hotplug support
> 
> The RT folks over at RedHat found an issue w.r.t. hotplug support which
> was traced to problems with the cpupri infrastructure in the scheduler:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=449676
> 
> This bug affects 23-rt12+, 24-rtX, 25-rtX, and sched-devel.  This patch
> applies to 25.4-rt4, though it should trivially apply to most cpupri enabled
> kernels mentioned above.
> 
> It turned out that the issue was that offline cpus could get inadvertently
> registered with cpupri so that they were erroneously selected during
> migration decisions.  The end result would be an OOPS as the offline cpu
> had tasks routed to it.

This is not what I saw, I traced it to select_task_rq_rt() selecting a
cpu that never was online. In my case cpu 2 on a dual core.

> This patch adds a new per-sched-class pair of interfaces:
> online/offline. They allow for the sched-class to register for
> notification when a run-queue is taken online or offline.  Additionally,
> the existing join/leave-domain code has been unified behind the new
> online/offline handlers so that they do the right thing w.r.t. the online
> status of a particular CPU.
> 
> I was able to easily reproduce the issue prior to this patch, and am no
> longer able to reproduce it after this patch.  I can offline cpus
> indefinately and everything seems to be in working order.
> 
> Thanks to Arnaldo (acme) and Thomas (tglx) for doing the legwork to point
> me in the right direction. 
> 
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Thomas Gleixner <tglx@linutonix.de>
> CC: Steven Rostedt <rostedt@goodmis.org>
> CC: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
> 
>  include/linux/sched.h |    2 ++
>  kernel/sched.c        |   19 +++++++++++++++++++
>  kernel/sched_rt.c     |   16 ++++++++++++----
>  3 files changed, 33 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index bb71371..9c5b8c9 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -970,6 +970,8 @@ struct sched_class {
>  
>  	void (*join_domain)(struct rq *rq);
>  	void (*leave_domain)(struct rq *rq);
> +	void (*online)(struct rq *rq);
> +	void (*offline)(struct rq *rq);

Rather unfortunate to add yet another two callbacks, can't this be done
with a creative use of leave/join?

>  	void (*switched_from) (struct rq *this_rq, struct task_struct *task,
>  			       int running);
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 0399411..fe96984 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -6278,6 +6278,9 @@ static void unregister_sched_domain_sysctl(void)
>  }
>  #endif
>  
> +#define for_each_class(class) \
> +   for (class = sched_class_highest; class; class = class->next)
> +
>  /*
>   * migration_call - callback that gets triggered when a CPU is added.
>   * Here we can start up the necessary migration thread for the new CPU.
> @@ -6314,8 +6317,15 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
>  		rq = cpu_rq(cpu);
>  		spin_lock_irqsave(&rq->lock, flags);
>  		if (rq->rd) {
> +			const struct sched_class *class;
> +
>  			BUG_ON(!cpu_isset(cpu, rq->rd->span));
>  			cpu_set(cpu, rq->rd->online);
> +
> +			for_each_class(class) {
> +				if (class->online)
> +					class->online(rq);
> +			}
>  		}
>  		spin_unlock_irqrestore(&rq->lock, flags);
>  		break;
> @@ -6375,8 +6385,17 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
>  		rq = cpu_rq(cpu);
>  		spin_lock_irqsave(&rq->lock, flags);
>  		if (rq->rd) {
> +			const struct sched_class *class;
> +
>  			BUG_ON(!cpu_isset(cpu, rq->rd->span));
> +
> +			for_each_class(class) {
> +				if (class->offline)
> +					class->offline(rq);
> +			}
> +
>  			cpu_clear(cpu, rq->rd->online);
> +
>  		}
>  		spin_unlock_irqrestore(&rq->lock, flags);
>  		break;

I'm thinking this should be done in update_sched_domains().

> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index 425cf01..8baf2e8 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -1101,8 +1101,11 @@ static void set_cpus_allowed_rt(struct task_struct *p, cpumask_t *new_mask)
>  }
>  
>  /* Assumes rq->lock is held */
> -static void join_domain_rt(struct rq *rq)
> +static void rq_online_rt(struct rq *rq)
>  {
> +	if (!cpu_isset(rq->cpu, rq->rd->online))
> +		return;
> +
>  	if (rq->rt.overloaded)
>  		rt_set_overload(rq);
>  
> @@ -1110,8 +1113,11 @@ static void join_domain_rt(struct rq *rq)
>  }
>  
>  /* Assumes rq->lock is held */
> -static void leave_domain_rt(struct rq *rq)
> +static void rq_offline_rt(struct rq *rq)
>  {
> +	if (!cpu_isset(rq->cpu, rq->rd->online))
> +		return;
> +
>  	if (rq->rt.overloaded)
>  		rt_clear_overload(rq);

So you now fully remove the leave/join calls because switching between
root domains doesn't need to migrate the overload status between those
domains? - seems unlikely.

> @@ -1278,8 +1284,10 @@ const struct sched_class rt_sched_class = {
>  	.load_balance		= load_balance_rt,
>  	.move_one_task		= move_one_task_rt,
>  	.set_cpus_allowed       = set_cpus_allowed_rt,
> -	.join_domain            = join_domain_rt,
> -	.leave_domain           = leave_domain_rt,
> +	.join_domain            = rq_online_rt,
> +	.leave_domain           = rq_offline_rt,
> +	.online                 = rq_online_rt,
> +	.offline                = rq_offline_rt,
>  	.pre_schedule		= pre_schedule_rt,
>  	.post_schedule		= post_schedule_rt,
>  	.task_wake_up		= task_wake_up_rt,



