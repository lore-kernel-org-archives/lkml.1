Return-Path: <linux-kernel-owner+w=401wt.eu-S1751978AbXE3DpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbXE3DpE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 23:45:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbXE3Dox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 23:44:53 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34634 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751339AbXE3Dow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 23:44:52 -0400
Date: Tue, 29 May 2007 20:43:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>, Jason Baron <jbaron@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/5] lockstat: core infrastructure
Message-Id: <20070529204348.6b5a936e.akpm@linux-foundation.org>
In-Reply-To: <20070529130107.112347096@chello.nl>
References: <20070529125248.877196281@chello.nl>
	<20070529130107.112347096@chello.nl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2007 14:52:51 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Introduce the core lock statistics code.
> 

I must say that an aggregate addition of 27 ifdefs is a bit sad.  And there
is some easy stuff here.

> +#ifdef CONFIG_PROVE_LOCKING
> +int prove_locking = 1;
> +module_param(prove_locking, int, 0644);
> +#endif

#else
#define prove_locking 0
#endif

> +
> +#ifdef CONFIG_LOCK_STAT
> +int lock_stat = 1;
> +module_param(lock_stat, int, 0644);
> +#endif

ditto.

>
> ...
>
> +struct lock_class_stats lock_stats(struct lock_class *class)
> +{
> +	struct lock_class_stats stats;
> +	int cpu, i;
> +
> +	memset(&stats, 0, sizeof(struct lock_class_stats));
> +	for_each_possible_cpu(cpu) {
> +		struct lock_class_stats *pcs =
> +			&per_cpu(lock_stats, cpu)[class - lock_classes];
> +
> +		for (i = 0; i < ARRAY_SIZE(stats.contention_point); i++)
> +			stats.contention_point[i] += pcs->contention_point[i];
> +
> +		lock_time_add(&pcs->read_waittime, &stats.read_waittime);
> +		lock_time_add(&pcs->write_waittime, &stats.write_waittime);
> +
> +		lock_time_add(&pcs->read_holdtime, &stats.read_holdtime);
> +		lock_time_add(&pcs->write_holdtime, &stats.write_holdtime);
> +	}
> +
> +	return stats;
> +}

hm, that isn't trying to be very efficient.

> @@ -2035,6 +2131,11 @@ static int __lock_acquire(struct lockdep
>  	int chain_head = 0;
>  	u64 chain_key;
>  
> +#ifdef CONFIG_PROVE_LOCKING
> +	if (!prove_locking)
> +		check = 1;
> +#endif

Removable

> +#ifdef CONFIG_LOCK_STAT
> +static void lock_release_holdtime(struct held_lock *hlock)
> +{
> +	struct lock_class_stats *stats;
> +	unsigned long long holdtime;
> +
> +	if (!lock_stat)
> +		return;
> +
> +	holdtime = sched_clock() - hlock->holdtime_stamp;
> +
> +	stats = get_lock_stats(hlock->class);
> +
> +	if (hlock->read)
> +		lock_time_inc(&stats->read_holdtime, holdtime);
> +	else
> +		lock_time_inc(&stats->write_holdtime, holdtime);
> +
> +	put_lock_stats(stats);
> +}
> +#else
> +static void lock_release_holdtime(struct held_lock *hlock)

inline

> +{
> +}
> +#endif
> +
> ...
>
> @@ -2456,6 +2712,14 @@ void lock_acquire(struct lockdep_map *lo
>  {
>  	unsigned long flags;
>  
> +#ifdef CONFIG_LOCK_STAT
> +	if (unlikely(!lock_stat))
> +#endif

removable

> +#ifdef CONFIG_PROVE_LOCKING
> +		if (unlikely(!prove_locking))
> +#endif

removable

> @@ -2475,6 +2739,14 @@ void lock_release(struct lockdep_map *lo
>  {
>  	unsigned long flags;
>  
> +#ifdef CONFIG_LOCK_STAT
> +	if (unlikely(!lock_stat))
> +#endif

removable

> +#ifdef CONFIG_PROVE_LOCKING
> +		if (unlikely(!prove_locking))
> +#endif
> +			return;
> +
>  	if (unlikely(current->lockdep_recursion))
>  		return;
>  
>  
> ...
>
> +#ifdef CONFIG_LOCK_STAT
> +
> +extern void lock_contended(struct lockdep_map *lock, unsigned long ip);
> +extern void lock_acquired(struct lockdep_map *lock);
> +
> +#define LOCK_CONTENDED(_lock, try, lock)			\
> +do {								\
> +	if (!try(_lock)) {					\
> +		lock_contended(&(_lock)->dep_map, _RET_IP_);	\
> +		lock(_lock);					\
> +		lock_acquired(&(_lock)->dep_map);		\
> +	}							\
> +} while (0)
> +
> +#else /* CONFIG_LOCK_STAT */
> +
> +#define lock_contended(l, i)			do { } while (0)
> +#define lock_acquired(l)			do { } while (0)

inlines are better.

> +#define LOCK_CONTENDED(_lock, try, lock) \
> +	lock(_lock)
> +
> +#endif /* CONFIG_LOCK_STAT */
> +
>  	},
>
> ...
>
> +#ifdef CONFIG_PROVE_LOCKING
> +	{
> +		.ctl_name	= KERN_PROVE_LOCKING,
> +		.procname	= "prove_locking",
> +		.data		= &prove_locking,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= &proc_dointvec,
> +	},
> +#endif
> +#ifdef CONFIG_LOCK_STAT
> +	{
> +		.ctl_name	= KERN_LOCK_STAT,
> +		.procname	= "lock_stat",
> +		.data		= &lock_stat,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= &proc_dointvec,
> +	},
> +#endif

Please use CTL_UNNUNBERED for new sysctls.

>  	{ .ctl_name = 0 }
>  };
> Index: linux-2.6-git/include/linux/sysctl.h
> ===================================================================
> --- linux-2.6-git.orig/include/linux/sysctl.h
> +++ linux-2.6-git/include/linux/sysctl.h
> @@ -166,6 +166,8 @@ enum
>  	KERN_NMI_WATCHDOG=75, /* int: enable/disable nmi watchdog */
>  	KERN_PANIC_ON_NMI=76, /* int: whether we will panic on an unrecovered */
>  	KERN_POWEROFF_CMD=77,	/* string: poweroff command line */
> +	KERN_PROVE_LOCKING=78, /* int: enable lock dependancy checking */
> +	KERN_LOCK_STAT=79, /* int: enable lock statistics */
>  };

And lose these.

So I'm inclined to ask if you can redo these pathces with a view to reducing
the ifdef density with a bit of restructuring.

We could do that as a followon patch I guess.  Nicer not to though.
