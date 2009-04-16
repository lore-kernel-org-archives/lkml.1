Return-Path: <linux-kernel-owner+w=401wt.eu-S1752772AbZDPFDF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbZDPFDF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 01:03:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751598AbZDPFCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 01:02:48 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:48303 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbZDPFCq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 01:02:46 -0400
Message-ID: <49E6BBA9.2030701@cosmosbay.com>
Date: Thu, 16 Apr 2009 07:01:29 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, kaber@trash.net,
       jeff.chua.linux@gmail.com, paulmck@linux.vnet.ibm.com, paulus@samba.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, jengelh@medozas.de,
       r000n@r000n.net, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       benh@kernel.crashing.org
Subject: Re: [PATCH] netfilter: use per-cpu spinlock and RCU (v5)
References: <49E5BDF7.8090502@trash.net>	<20090415135526.2afc4d18@nehalam>	<49E64C91.5020708@cosmosbay.com>	<20090415.164811.19905145.davem@davemloft.net>	<20090415170111.6e1ca264@nehalam>	<alpine.LFD.2.00.0904151705120.4042@localhost.localdomain> <20090415174551.529d241c@nehalam>
In-Reply-To: <20090415174551.529d241c@nehalam>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 16 Apr 2009 07:01:32 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger a écrit :
> This is an alternative version of ip/ip6/arp tables locking using
> per-cpu locks.  This avoids the overhead of synchronize_net() during
> update but still removes the expensive rwlock in earlier versions.
> 
> The idea for this came from an earlier version done by Eric Dumazet.
> Locking is done per-cpu, the fast path locks on the current cpu
> and updates counters.  The slow case involves acquiring the locks on
> all cpu's. This version uses RCU for the table->base reference
> but per-cpu-lock for counters.
> 
> The mutex that was added for 2.6.30 in xt_table is unnecessary since
> there already is a mutex for xt[af].mutex that is held.
> 
> This version does not do coarse locking or synchronize_net() during
> the __do_replace function, so there is a small race which allows for
> some of the old counter values to be incorrect (Ncpu -1). Scenario
> would be replacing a rule set and the same rules are inflight on other
> CPU.  The other CPU might still be looking at the old rules (and
> update those counters), after counter values have been captured.
> 
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

This version is a regression over 2.6.2[0-9], because of two points

1) Much more atomic ops :

Because of additional

> +			spin_lock(&__get_cpu_var(ip_tables_lock));
>  			ADD_COUNTER(e->counters, ntohs(ip->tot_len), 1);
> +			spin_unlock(&__get_cpu_var(ip_tables_lock));

added on each counter updates.

On many setups, each packet coming in or out of the machine has
to update between 2 to 20 rule counters. So to avoid *one* atomic ops
of read_unlock(), this v4 version adds 2 to 20 atomic ops...


I still not see the problem between the previous version (2.6.2[0-8]) that had a central
 rwlock, that hurted performance on SMP because of cache line ping pong, and the solution
having one rwlock per cpu.

We wanted to reduce the cache line ping pong first. This *is* the hurting point,
by an order of magnitude.

We tried a full RCU solution, it took us three years and we failed.
Lets take an easy solution, before whole replacement of x_table by new Patrick
infrastructure.

Then, if it appears the rwlock itself and its two atomic ops are *really* a problem,
we can go further, but I doubt modern cpus really care about atomic ops on an integer
already hot in L1 cache.

2) Second problem : Potential OOM

About freeing old rules with call_rcu() and/or schedule_work(), this is going
to OOM pretty fast on small appliances with basic firewall setups loading
rules one by one, as done by original topic reporter.

We had reports from guys using linux with 4MB of available ram (French provider free.fr on
their applicance box), and we had to use SLAB_DESTROY_BY_RCU thing on conntrack
 to avoid OOM for their setups. We dont want to use call_rcu() and queue 100 or 200 vfree().


So I prefer your v3 version, even if I didnt tested yet.

Thank you

> 
> ---
>  include/linux/netfilter/x_tables.h |   11 +--
>  net/ipv4/netfilter/arp_tables.c    |  121 +++++++++++--------------------------
>  net/ipv4/netfilter/ip_tables.c     |  121 ++++++++++---------------------------
>  net/ipv6/netfilter/ip6_tables.c    |  118 +++++++++++-------------------------
>  net/netfilter/x_tables.c           |   45 +++++++------
>  5 files changed, 137 insertions(+), 279 deletions(-)
> 
> --- a/include/linux/netfilter/x_tables.h	2009-04-15 08:44:01.449318844 -0700
> +++ b/include/linux/netfilter/x_tables.h	2009-04-15 17:08:35.303217128 -0700
> @@ -354,9 +354,6 @@ struct xt_table
>  	/* What hooks you will enter on */
>  	unsigned int valid_hooks;
>  
> -	/* Lock for the curtain */
> -	struct mutex lock;
> -
>  	/* Man behind the curtain... */
>  	struct xt_table_info *private;
>  
> @@ -385,6 +382,12 @@ struct xt_table_info
>  	unsigned int hook_entry[NF_INET_NUMHOOKS];
>  	unsigned int underflow[NF_INET_NUMHOOKS];
>  
> +	/* Slow death march */
> +	union {
> +		struct rcu_head rcu;
> +		struct work_struct work;
> +	};
> +
>  	/* ipt_entry tables: one per CPU */
>  	/* Note : this field MUST be the last one, see XT_TABLE_INFO_SZ */
>  	void *entries[1];
> @@ -434,8 +437,6 @@ extern void xt_proto_fini(struct net *ne
>  
>  extern struct xt_table_info *xt_alloc_table_info(unsigned int size);
>  extern void xt_free_table_info(struct xt_table_info *info);
> -extern void xt_table_entry_swap_rcu(struct xt_table_info *old,
> -				    struct xt_table_info *new);
>  
>  /*
>   * This helper is performance critical and must be inlined
> --- a/net/ipv4/netfilter/ip_tables.c	2009-04-15 08:44:01.441318723 -0700
> +++ b/net/ipv4/netfilter/ip_tables.c	2009-04-15 17:09:49.600404319 -0700
> @@ -297,6 +297,8 @@ static void trace_packet(struct sk_buff 
>  }
>  #endif
>  
> +static DEFINE_PER_CPU(spinlock_t, ip_tables_lock);
> +
>  /* Returns one of the generic firewall policies, like NF_ACCEPT. */
>  unsigned int
>  ipt_do_table(struct sk_buff *skb,
> @@ -341,7 +343,7 @@ ipt_do_table(struct sk_buff *skb,
>  
>  	rcu_read_lock_bh();
>  	private = rcu_dereference(table->private);
> -	table_base = rcu_dereference(private->entries[smp_processor_id()]);
> +	table_base = private->entries[smp_processor_id()];
>  
>  	e = get_entry(table_base, private->hook_entry[hook]);
>  
> @@ -358,7 +360,9 @@ ipt_do_table(struct sk_buff *skb,
>  			if (IPT_MATCH_ITERATE(e, do_match, skb, &mtpar) != 0)
>  				goto no_match;
>  
> +			spin_lock(&__get_cpu_var(ip_tables_lock));
>  			ADD_COUNTER(e->counters, ntohs(ip->tot_len), 1);
> +			spin_unlock(&__get_cpu_var(ip_tables_lock));
>  
>  			t = ipt_get_target(e);
>  			IP_NF_ASSERT(t->u.kernel.target);
> @@ -436,9 +440,9 @@ ipt_do_table(struct sk_buff *skb,
>  			e = (void *)e + e->next_offset;
>  		}
>  	} while (!hotdrop);
> -
>  	rcu_read_unlock_bh();
>  
> +
>  #ifdef DEBUG_ALLOW_ALL
>  	return NF_ACCEPT;
>  #else
> @@ -902,75 +906,25 @@ get_counters(const struct xt_table_info 
>  	curcpu = raw_smp_processor_id();
>  
>  	i = 0;
> +	spin_lock_bh(&per_cpu(ip_tables_lock, curcpu));
>  	IPT_ENTRY_ITERATE(t->entries[curcpu],
>  			  t->size,
>  			  set_entry_to_counter,
>  			  counters,
>  			  &i);
> +	spin_unlock_bh(&per_cpu(ip_tables_lock, curcpu));
>  
>  	for_each_possible_cpu(cpu) {
>  		if (cpu == curcpu)
>  			continue;
>  		i = 0;
> +		spin_lock_bh(&per_cpu(ip_tables_lock, cpu));
>  		IPT_ENTRY_ITERATE(t->entries[cpu],
>  				  t->size,
>  				  add_entry_to_counter,
>  				  counters,
>  				  &i);
> -	}
> -
> -}
> -
> -/* We're lazy, and add to the first CPU; overflow works its fey magic
> - * and everything is OK. */
> -static int
> -add_counter_to_entry(struct ipt_entry *e,
> -		     const struct xt_counters addme[],
> -		     unsigned int *i)
> -{
> -	ADD_COUNTER(e->counters, addme[*i].bcnt, addme[*i].pcnt);
> -
> -	(*i)++;
> -	return 0;
> -}
> -
> -/* Take values from counters and add them back onto the current cpu */
> -static void put_counters(struct xt_table_info *t,
> -			 const struct xt_counters counters[])
> -{
> -	unsigned int i, cpu;
> -
> -	local_bh_disable();
> -	cpu = smp_processor_id();
> -	i = 0;
> -	IPT_ENTRY_ITERATE(t->entries[cpu],
> -			  t->size,
> -			  add_counter_to_entry,
> -			  counters,
> -			  &i);
> -	local_bh_enable();
> -}
> -
> -
> -static inline int
> -zero_entry_counter(struct ipt_entry *e, void *arg)
> -{
> -	e->counters.bcnt = 0;
> -	e->counters.pcnt = 0;
> -	return 0;
> -}
> -
> -static void
> -clone_counters(struct xt_table_info *newinfo, const struct xt_table_info *info)
> -{
> -	unsigned int cpu;
> -	const void *loc_cpu_entry = info->entries[raw_smp_processor_id()];
> -
> -	memcpy(newinfo, info, offsetof(struct xt_table_info, entries));
> -	for_each_possible_cpu(cpu) {
> -		memcpy(newinfo->entries[cpu], loc_cpu_entry, info->size);
> -		IPT_ENTRY_ITERATE(newinfo->entries[cpu], newinfo->size,
> -				  zero_entry_counter, NULL);
> +		spin_unlock_bh(&per_cpu(ip_tables_lock, cpu));
>  	}
>  }
>  
> @@ -979,7 +933,6 @@ static struct xt_counters * alloc_counte
>  	unsigned int countersize;
>  	struct xt_counters *counters;
>  	struct xt_table_info *private = table->private;
> -	struct xt_table_info *info;
>  
>  	/* We need atomic snapshot of counters: rest doesn't change
>  	   (other than comefrom, which userspace doesn't care
> @@ -988,30 +941,11 @@ static struct xt_counters * alloc_counte
>  	counters = vmalloc_node(countersize, numa_node_id());
>  
>  	if (counters == NULL)
> -		goto nomem;
> -
> -	info = xt_alloc_table_info(private->size);
> -	if (!info)
> -		goto free_counters;
> +		return ERR_PTR(-ENOMEM);
>  
> -	clone_counters(info, private);
> -
> -	mutex_lock(&table->lock);
> -	xt_table_entry_swap_rcu(private, info);
> -	synchronize_net();	/* Wait until smoke has cleared */
> -
> -	get_counters(info, counters);
> -	put_counters(private, counters);
> -	mutex_unlock(&table->lock);
> -
> -	xt_free_table_info(info);
> +	get_counters(private, counters);
>  
>  	return counters;
> -
> - free_counters:
> -	vfree(counters);
> - nomem:
> -	return ERR_PTR(-ENOMEM);
>  }
>  
>  static int
> @@ -1377,6 +1311,18 @@ do_replace(struct net *net, void __user 
>  	return ret;
>  }
>  
> +/* We're lazy, and add to the first CPU; overflow works its fey magic
> + * and everything is OK. */
> +static int
> +add_counter_to_entry(struct ipt_entry *e,
> +		     const struct xt_counters addme[],
> +		     unsigned int *i)
> +{
> +	ADD_COUNTER(e->counters, addme[*i].bcnt, addme[*i].pcnt);
> +
> +	(*i)++;
> +	return 0;
> +}
>  
>  static int
>  do_add_counters(struct net *net, void __user *user, unsigned int len, int compat)
> @@ -1386,7 +1332,7 @@ do_add_counters(struct net *net, void __
>  	struct xt_counters *paddc;
>  	unsigned int num_counters;
>  	const char *name;
> -	int size;
> +	int cpu, size;
>  	void *ptmp;
>  	struct xt_table *t;
>  	const struct xt_table_info *private;
> @@ -1437,25 +1383,25 @@ do_add_counters(struct net *net, void __
>  		goto free;
>  	}
>  
> -	mutex_lock(&t->lock);
>  	private = t->private;
>  	if (private->number != num_counters) {
>  		ret = -EINVAL;
>  		goto unlock_up_free;
>  	}
>  
> -	preempt_disable();
> -	i = 0;
>  	/* Choose the copy that is on our node */
> -	loc_cpu_entry = private->entries[raw_smp_processor_id()];
> +	cpu = raw_smp_processor_id();
> +	spin_lock_bh(&per_cpu(ip_tables_lock, cpu));
> +	loc_cpu_entry = private->entries[cpu];
> +	i = 0;
>  	IPT_ENTRY_ITERATE(loc_cpu_entry,
>  			  private->size,
>  			  add_counter_to_entry,
>  			  paddc,
>  			  &i);
> -	preempt_enable();
> +	spin_unlock_bh(&per_cpu(ip_tables_lock, cpu));
> +
>   unlock_up_free:
> -	mutex_unlock(&t->lock);
>  	xt_table_unlock(t);
>  	module_put(t->me);
>   free:
> @@ -2272,7 +2218,10 @@ static struct pernet_operations ip_table
>  
>  static int __init ip_tables_init(void)
>  {
> -	int ret;
> +	int cpu, ret;
> +
> +	for_each_possible_cpu(cpu)
> +		spin_lock_init(&per_cpu(ip_tables_lock, cpu));
>  
>  	ret = register_pernet_subsys(&ip_tables_net_ops);
>  	if (ret < 0)
> --- a/net/netfilter/x_tables.c	2009-04-15 08:44:01.424319035 -0700
> +++ b/net/netfilter/x_tables.c	2009-04-15 17:10:24.967344496 -0700
> @@ -66,6 +66,8 @@ static const char *const xt_prefix[NFPRO
>  	[NFPROTO_IPV6]   = "ip6",
>  };
>  
> +static void __xt_free_table_info(struct xt_table_info *);
> +
>  /* Registration hooks for targets. */
>  int
>  xt_register_target(struct xt_target *target)
> @@ -602,7 +604,7 @@ struct xt_table_info *xt_alloc_table_inf
>  							cpu_to_node(cpu));
>  
>  		if (newinfo->entries[cpu] == NULL) {
> -			xt_free_table_info(newinfo);
> +			__xt_free_table_info(newinfo);
>  			return NULL;
>  		}
>  	}
> @@ -611,7 +613,7 @@ struct xt_table_info *xt_alloc_table_inf
>  }
>  EXPORT_SYMBOL(xt_alloc_table_info);
>  
> -void xt_free_table_info(struct xt_table_info *info)
> +static void __xt_free_table_info(struct xt_table_info *info)
>  {
>  	int cpu;
>  
> @@ -623,21 +625,28 @@ void xt_free_table_info(struct xt_table_
>  	}
>  	kfree(info);
>  }
> -EXPORT_SYMBOL(xt_free_table_info);
>  
> -void xt_table_entry_swap_rcu(struct xt_table_info *oldinfo,
> -			     struct xt_table_info *newinfo)
> +static void __xt_free_table_info_wq(struct work_struct *arg)
>  {
> -	unsigned int cpu;
> +	struct xt_table_info *info
> +		= container_of(arg, struct xt_table_info, work);
> +	__xt_free_table_info(info);
> +}
>  
> -	for_each_possible_cpu(cpu) {
> -		void *p = oldinfo->entries[cpu];
> -		rcu_assign_pointer(oldinfo->entries[cpu], newinfo->entries[cpu]);
> -		newinfo->entries[cpu] = p;
> -	}
> +static void __xt_free_table_info_rcu(struct rcu_head *arg)
> +{
> +	struct xt_table_info *info
> +		= container_of(arg, struct xt_table_info, rcu);
>  
> +	INIT_WORK(&info->work, __xt_free_table_info_wq);
> +	schedule_work(&info->work);
>  }
> -EXPORT_SYMBOL_GPL(xt_table_entry_swap_rcu);
> +
> +void xt_free_table_info(struct xt_table_info *info)
> +{
> +	call_rcu(&info->rcu, __xt_free_table_info_rcu);
> +}
> +EXPORT_SYMBOL(xt_free_table_info);
>  
>  /* Find table by name, grabs mutex & ref.  Returns ERR_PTR() on error. */
>  struct xt_table *xt_find_table_lock(struct net *net, u_int8_t af,
> @@ -682,26 +691,21 @@ xt_replace_table(struct xt_table *table,
>  	      struct xt_table_info *newinfo,
>  	      int *error)
>  {
> -	struct xt_table_info *oldinfo, *private;
> +	struct xt_table_info *private;
>  
>  	/* Do the substitution. */
> -	mutex_lock(&table->lock);
>  	private = table->private;
>  	/* Check inside lock: is the old number correct? */
>  	if (num_counters != private->number) {
>  		duprintf("num_counters != table->private->number (%u/%u)\n",
>  			 num_counters, private->number);
> -		mutex_unlock(&table->lock);
>  		*error = -EAGAIN;
>  		return NULL;
>  	}
> -	oldinfo = private;
>  	rcu_assign_pointer(table->private, newinfo);
> -	newinfo->initial_entries = oldinfo->initial_entries;
> -	mutex_unlock(&table->lock);
> +	newinfo->initial_entries = private->initial_entries;
>  
> -	synchronize_net();
> -	return oldinfo;
> +	return private;
>  }
>  EXPORT_SYMBOL_GPL(xt_replace_table);
>  
> @@ -734,7 +738,6 @@ struct xt_table *xt_register_table(struc
>  
>  	/* Simplifies replace_table code. */
>  	table->private = bootstrap;
> -	mutex_init(&table->lock);
>  
>  	if (!xt_replace_table(table, 0, newinfo, &ret))
>  		goto unlock;


