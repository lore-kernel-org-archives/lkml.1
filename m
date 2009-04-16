Return-Path: <linux-kernel-owner+w=401wt.eu-S1756566AbZDPQMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566AbZDPQMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 12:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755237AbZDPQMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 12:12:00 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:48025 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbZDPQL4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 12:11:56 -0400
Message-ID: <49E75876.10509@cosmosbay.com>
Date: Thu, 16 Apr 2009 18:10:30 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Patrick McHardy <kaber@trash.net>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeff.chua.linux@gmail.com,
       paulus@samba.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       jengelh@medozas.de, r000n@r000n.net, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       benh@kernel.crashing.org
Subject: [PATCH] netfilter: use per-cpu recursive spinlock  (v6)
References: <49E5BDF7.8090502@trash.net> <20090415135526.2afc4d18@nehalam> <49E64C91.5020708@cosmosbay.com> <20090415.164811.19905145.davem@davemloft.net> <20090415170111.6e1ca264@nehalam> <alpine.LFD.2.00.0904151705120.4042@localhost.localdomain> <20090415174551.529d241c@nehalam> <49E6BBA9.2030701@cosmosbay.com> <49E7384B.5020707@trash.net> <20090416144748.GB6924@linux.vnet.ibm.com>
In-Reply-To: <20090416144748.GB6924@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 16 Apr 2009 18:10:33 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney a écrit :

> Well, we don't really need an rwlock, especially given that we really
> don't want two "readers" incrementing the same counter concurrently.
> 
> A safer approach would be to maintain a flag in the task structure
> tracking which (if any) of the per-CPU locks you hold.  Also maintain
> a recursion-depth counter.  If the flag says you don't already hold
> the lock, set it and acquire the lock.  Either way, increment the
> recursion-depth counter:
> 
> 	if (current->netfilter_lock_held != cur_cpu) {
> 		BUG_ON(current->netfilter_lock_held != CPU_NONE);
> 		spin_lock(per_cpu(..., cur_cpu));
> 		current->netfilter_lock_held = cur_cpu;
> 	}
> 	current->netfilter_lock_nesting++;
> 
> And reverse the process to unlock:
> 
> 	if (--current->netfilter_lock_nesting == 0) {
> 		spin_unlock(per_cpu(..., cur_cpu));
> 		current->netfilter_lock_held = CPU_NONE;
> 	}
> 

Yes, you are right, we can avoid rwlock, but use a 'recursive' lock
or spin_trylock()

We can use one counter close to the spinlock, 
no need to add one or two fields to every "thread_info"

struct rec_lock {
	spinlock_t lock;
	int        count;
};
static DEFINE_PER_CPU(struct rec_lock, ip_tables_lock);


I also considered using regular spinlocks and spin_trylock() to "detect"
the recurse case without a global counter.

lock :
local_bh_disable();
int locked = spin_trylock(&__get_cpu_var(arp_tables_lock);

unlock:

if (likely(locked))
	spin_unlock(&__get_cpu_var(arp_tables_lock));
local_bh_enable();

But we would lose some runtime features, I dont feel comfortable about
this trylock version. What others people think ?


Here is the resulting patch, based on Stephen v4

(Not sure we *need* recursive spinlock for the arp_tables, but it seems
better to have an uniform implementation)


[PATCH] netfilter: use per-cpu recursive spinlock (v6)

Yet another alternative version of ip/ip6/arp tables locking using
per-cpu locks.  This avoids the overhead of synchronize_net() during
update but still removes the expensive rwlock in earlier versions.

The idea for this came from an earlier version done by Eric Dumazet.
Locking is done per-cpu, the fast path locks on the current cpu
and updates counters.  The slow case involves acquiring the locks on
all cpu's.

The mutex that was added for 2.6.30 in xt_table is unnecessary since
there already is a mutex for xt[af].mutex that is held.

We have to use recursive spinlocks because netfilter can sometimes
nest several calls to ipt_do_table() for a given cpu.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com
Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
---
 include/linux/netfilter/x_tables.h |    5 -
 net/ipv4/netfilter/arp_tables.c    |  131 +++++++++------------------
 net/ipv4/netfilter/ip_tables.c     |  130 +++++++++-----------------
 net/ipv6/netfilter/ip6_tables.c    |  127 +++++++++-----------------
 net/netfilter/x_tables.c           |   26 -----
 5 files changed, 138 insertions(+), 281 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 7b1a652..1ff1a76 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -354,9 +354,6 @@ struct xt_table
 	/* What hooks you will enter on */
 	unsigned int valid_hooks;
 
-	/* Lock for the curtain */
-	struct mutex lock;
-
 	/* Man behind the curtain... */
 	struct xt_table_info *private;
 
@@ -434,8 +431,6 @@ extern void xt_proto_fini(struct net *net, u_int8_t af);
 
 extern struct xt_table_info *xt_alloc_table_info(unsigned int size);
 extern void xt_free_table_info(struct xt_table_info *info);
-extern void xt_table_entry_swap_rcu(struct xt_table_info *old,
-				    struct xt_table_info *new);
 
 /*
  * This helper is performance critical and must be inlined
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 5ba533d..9f935f2 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -231,6 +231,12 @@ static inline struct arpt_entry *get_entry(void *base, unsigned int offset)
 	return (struct arpt_entry *)(base + offset);
 }
 
+struct rec_lock {
+	spinlock_t lock;
+	int	   count; /* recursion count */
+};
+static DEFINE_PER_CPU(struct rec_lock, arp_tables_lock);
+
 unsigned int arpt_do_table(struct sk_buff *skb,
 			   unsigned int hook,
 			   const struct net_device *in,
@@ -246,6 +252,7 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 	void *table_base;
 	const struct xt_table_info *private;
 	struct xt_target_param tgpar;
+	struct rec_lock *rl;
 
 	if (!pskb_may_pull(skb, arp_hdr_len(skb->dev)))
 		return NF_DROP;
@@ -255,7 +262,12 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 
 	rcu_read_lock_bh();
 	private = rcu_dereference(table->private);
-	table_base = rcu_dereference(private->entries[smp_processor_id()]);
+
+	rl = &__get_cpu_var(arp_tables_lock);
+	if (likely(rl->count++ == 0))
+		spin_lock(&rl->lock);
+
+	table_base = private->entries[smp_processor_id()];
 
 	e = get_entry(table_base, private->hook_entry[hook]);
 	back = get_entry(table_base, private->underflow[hook]);
@@ -273,6 +285,7 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 
 			hdr_len = sizeof(*arp) + (2 * sizeof(struct in_addr)) +
 				(2 * skb->dev->addr_len);
+
 			ADD_COUNTER(e->counters, hdr_len, 1);
 
 			t = arpt_get_target(e);
@@ -328,7 +341,8 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 			e = (void *)e + e->next_offset;
 		}
 	} while (!hotdrop);
-
+	if (likely(--rl->count == 0))
+		spin_unlock(&rl->lock);
 	rcu_read_unlock_bh();
 
 	if (hotdrop)
@@ -716,74 +730,25 @@ static void get_counters(const struct xt_table_info *t,
 	curcpu = raw_smp_processor_id();
 
 	i = 0;
+	spin_lock_bh(&per_cpu(arp_tables_lock, curcpu).lock);
 	ARPT_ENTRY_ITERATE(t->entries[curcpu],
 			   t->size,
 			   set_entry_to_counter,
 			   counters,
 			   &i);
+	spin_unlock_bh(&per_cpu(arp_tables_lock, curcpu).lock);
 
 	for_each_possible_cpu(cpu) {
 		if (cpu == curcpu)
 			continue;
 		i = 0;
+		spin_lock_bh(&per_cpu(arp_tables_lock, cpu).lock);
 		ARPT_ENTRY_ITERATE(t->entries[cpu],
 				   t->size,
 				   add_entry_to_counter,
 				   counters,
 				   &i);
-	}
-}
-
-
-/* We're lazy, and add to the first CPU; overflow works its fey magic
- * and everything is OK. */
-static int
-add_counter_to_entry(struct arpt_entry *e,
-		     const struct xt_counters addme[],
-		     unsigned int *i)
-{
-	ADD_COUNTER(e->counters, addme[*i].bcnt, addme[*i].pcnt);
-
-	(*i)++;
-	return 0;
-}
-
-/* Take values from counters and add them back onto the current cpu */
-static void put_counters(struct xt_table_info *t,
-			 const struct xt_counters counters[])
-{
-	unsigned int i, cpu;
-
-	local_bh_disable();
-	cpu = smp_processor_id();
-	i = 0;
-	ARPT_ENTRY_ITERATE(t->entries[cpu],
-			  t->size,
-			  add_counter_to_entry,
-			  counters,
-			  &i);
-	local_bh_enable();
-}
-
-static inline int
-zero_entry_counter(struct arpt_entry *e, void *arg)
-{
-	e->counters.bcnt = 0;
-	e->counters.pcnt = 0;
-	return 0;
-}
-
-static void
-clone_counters(struct xt_table_info *newinfo, const struct xt_table_info *info)
-{
-	unsigned int cpu;
-	const void *loc_cpu_entry = info->entries[raw_smp_processor_id()];
-
-	memcpy(newinfo, info, offsetof(struct xt_table_info, entries));
-	for_each_possible_cpu(cpu) {
-		memcpy(newinfo->entries[cpu], loc_cpu_entry, info->size);
-		ARPT_ENTRY_ITERATE(newinfo->entries[cpu], newinfo->size,
-				  zero_entry_counter, NULL);
+		spin_unlock_bh(&per_cpu(arp_tables_lock, cpu).lock);
 	}
 }
 
@@ -792,7 +757,6 @@ static struct xt_counters *alloc_counters(struct xt_table *table)
 	unsigned int countersize;
 	struct xt_counters *counters;
 	struct xt_table_info *private = table->private;
-	struct xt_table_info *info;
 
 	/* We need atomic snapshot of counters: rest doesn't change
 	 * (other than comefrom, which userspace doesn't care
@@ -802,30 +766,11 @@ static struct xt_counters *alloc_counters(struct xt_table *table)
 	counters = vmalloc_node(countersize, numa_node_id());
 
 	if (counters == NULL)
-		goto nomem;
-
-	info = xt_alloc_table_info(private->size);
-	if (!info)
-		goto free_counters;
-
-	clone_counters(info, private);
+		return ERR_PTR(-ENOMEM);
 
-	mutex_lock(&table->lock);
-	xt_table_entry_swap_rcu(private, info);
-	synchronize_net();	/* Wait until smoke has cleared */
-
-	get_counters(info, counters);
-	put_counters(private, counters);
-	mutex_unlock(&table->lock);
-
-	xt_free_table_info(info);
+	get_counters(private, counters);
 
 	return counters;
-
- free_counters:
-	vfree(counters);
- nomem:
-	return ERR_PTR(-ENOMEM);
 }
 
 static int copy_entries_to_user(unsigned int total_size,
@@ -1165,6 +1110,19 @@ static int do_replace(struct net *net, void __user *user, unsigned int len)
 	return ret;
 }
 
+/* We're lazy, and add to the first CPU; overflow works its fey magic
+ * and everything is OK. */
+static int
+add_counter_to_entry(struct arpt_entry *e,
+		     const struct xt_counters addme[],
+		     unsigned int *i)
+{
+	ADD_COUNTER(e->counters, addme[*i].bcnt, addme[*i].pcnt);
+
+	(*i)++;
+	return 0;
+}
+
 static int do_add_counters(struct net *net, void __user *user, unsigned int len,
 			   int compat)
 {
@@ -1173,7 +1131,7 @@ static int do_add_counters(struct net *net, void __user *user, unsigned int len,
 	struct xt_counters *paddc;
 	unsigned int num_counters;
 	const char *name;
-	int size;
+	int cpu, size;
 	void *ptmp;
 	struct xt_table *t;
 	const struct xt_table_info *private;
@@ -1224,25 +1182,25 @@ static int do_add_counters(struct net *net, void __user *user, unsigned int len,
 		goto free;
 	}
 
-	mutex_lock(&t->lock);
 	private = t->private;
 	if (private->number != num_counters) {
 		ret = -EINVAL;
 		goto unlock_up_free;
 	}
 
-	preempt_disable();
-	i = 0;
 	/* Choose the copy that is on our node */
-	loc_cpu_entry = private->entries[smp_processor_id()];
+	cpu = raw_smp_processor_id();
+	spin_lock_bh(&per_cpu(arp_tables_lock, cpu).lock);
+	loc_cpu_entry = private->entries[cpu];
+	i = 0;
 	ARPT_ENTRY_ITERATE(loc_cpu_entry,
 			   private->size,
 			   add_counter_to_entry,
 			   paddc,
 			   &i);
-	preempt_enable();
+	spin_unlock_bh(&per_cpu(arp_tables_lock, cpu).lock);
+
  unlock_up_free:
-	mutex_unlock(&t->lock);
 
 	xt_table_unlock(t);
 	module_put(t->me);
@@ -1923,7 +1881,10 @@ static struct pernet_operations arp_tables_net_ops = {
 
 static int __init arp_tables_init(void)
 {
-	int ret;
+	int cpu, ret;
+
+	for_each_possible_cpu(cpu)
+		spin_lock_init(&per_cpu(arp_tables_lock, cpu).lock);
 
 	ret = register_pernet_subsys(&arp_tables_net_ops);
 	if (ret < 0)
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 810c0b6..1368b6d 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -297,6 +297,12 @@ static void trace_packet(struct sk_buff *skb,
 }
 #endif
 
+struct rec_lock {
+	spinlock_t lock;
+	int	   count; /* recursion count */
+};
+static DEFINE_PER_CPU(struct rec_lock, ip_tables_lock);
+
 /* Returns one of the generic firewall policies, like NF_ACCEPT. */
 unsigned int
 ipt_do_table(struct sk_buff *skb,
@@ -317,6 +323,7 @@ ipt_do_table(struct sk_buff *skb,
 	struct xt_table_info *private;
 	struct xt_match_param mtpar;
 	struct xt_target_param tgpar;
+	struct rec_lock *rl;
 
 	/* Initialization */
 	ip = ip_hdr(skb);
@@ -341,7 +348,12 @@ ipt_do_table(struct sk_buff *skb,
 
 	rcu_read_lock_bh();
 	private = rcu_dereference(table->private);
-	table_base = rcu_dereference(private->entries[smp_processor_id()]);
+
+	rl = &__get_cpu_var(ip_tables_lock);
+	if (likely(rl->count++ == 0))
+		spin_lock(&rl->lock);
+
+	table_base = private->entries[smp_processor_id()];
 
 	e = get_entry(table_base, private->hook_entry[hook]);
 
@@ -436,7 +448,8 @@ ipt_do_table(struct sk_buff *skb,
 			e = (void *)e + e->next_offset;
 		}
 	} while (!hotdrop);
-
+	if (likely(--rl->count == 0))
+		spin_unlock(&rl->lock);
 	rcu_read_unlock_bh();
 
 #ifdef DEBUG_ALLOW_ALL
@@ -902,75 +915,25 @@ get_counters(const struct xt_table_info *t,
 	curcpu = raw_smp_processor_id();
 
 	i = 0;
+	spin_lock_bh(&per_cpu(ip_tables_lock, curcpu).lock);
 	IPT_ENTRY_ITERATE(t->entries[curcpu],
 			  t->size,
 			  set_entry_to_counter,
 			  counters,
 			  &i);
+	spin_unlock_bh(&per_cpu(ip_tables_lock, curcpu).lock);
 
 	for_each_possible_cpu(cpu) {
 		if (cpu == curcpu)
 			continue;
 		i = 0;
+		spin_lock_bh(&per_cpu(ip_tables_lock, cpu).lock);
 		IPT_ENTRY_ITERATE(t->entries[cpu],
 				  t->size,
 				  add_entry_to_counter,
 				  counters,
 				  &i);
-	}
-
-}
-
-/* We're lazy, and add to the first CPU; overflow works its fey magic
- * and everything is OK. */
-static int
-add_counter_to_entry(struct ipt_entry *e,
-		     const struct xt_counters addme[],
-		     unsigned int *i)
-{
-	ADD_COUNTER(e->counters, addme[*i].bcnt, addme[*i].pcnt);
-
-	(*i)++;
-	return 0;
-}
-
-/* Take values from counters and add them back onto the current cpu */
-static void put_counters(struct xt_table_info *t,
-			 const struct xt_counters counters[])
-{
-	unsigned int i, cpu;
-
-	local_bh_disable();
-	cpu = smp_processor_id();
-	i = 0;
-	IPT_ENTRY_ITERATE(t->entries[cpu],
-			  t->size,
-			  add_counter_to_entry,
-			  counters,
-			  &i);
-	local_bh_enable();
-}
-
-
-static inline int
-zero_entry_counter(struct ipt_entry *e, void *arg)
-{
-	e->counters.bcnt = 0;
-	e->counters.pcnt = 0;
-	return 0;
-}
-
-static void
-clone_counters(struct xt_table_info *newinfo, const struct xt_table_info *info)
-{
-	unsigned int cpu;
-	const void *loc_cpu_entry = info->entries[raw_smp_processor_id()];
-
-	memcpy(newinfo, info, offsetof(struct xt_table_info, entries));
-	for_each_possible_cpu(cpu) {
-		memcpy(newinfo->entries[cpu], loc_cpu_entry, info->size);
-		IPT_ENTRY_ITERATE(newinfo->entries[cpu], newinfo->size,
-				  zero_entry_counter, NULL);
+		spin_unlock_bh(&per_cpu(ip_tables_lock, cpu).lock);
 	}
 }
 
@@ -979,7 +942,6 @@ static struct xt_counters * alloc_counters(struct xt_table *table)
 	unsigned int countersize;
 	struct xt_counters *counters;
 	struct xt_table_info *private = table->private;
-	struct xt_table_info *info;
 
 	/* We need atomic snapshot of counters: rest doesn't change
 	   (other than comefrom, which userspace doesn't care
@@ -988,30 +950,11 @@ static struct xt_counters * alloc_counters(struct xt_table *table)
 	counters = vmalloc_node(countersize, numa_node_id());
 
 	if (counters == NULL)
-		goto nomem;
-
-	info = xt_alloc_table_info(private->size);
-	if (!info)
-		goto free_counters;
-
-	clone_counters(info, private);
-
-	mutex_lock(&table->lock);
-	xt_table_entry_swap_rcu(private, info);
-	synchronize_net();	/* Wait until smoke has cleared */
+		return ERR_PTR(-ENOMEM);
 
-	get_counters(info, counters);
-	put_counters(private, counters);
-	mutex_unlock(&table->lock);
-
-	xt_free_table_info(info);
+	get_counters(private, counters);
 
 	return counters;
-
- free_counters:
-	vfree(counters);
- nomem:
-	return ERR_PTR(-ENOMEM);
 }
 
 static int
@@ -1377,6 +1320,18 @@ do_replace(struct net *net, void __user *user, unsigned int len)
 	return ret;
 }
 
+/* We're lazy, and add to the first CPU; overflow works its fey magic
+ * and everything is OK. */
+static int
+add_counter_to_entry(struct ipt_entry *e,
+		     const struct xt_counters addme[],
+		     unsigned int *i)
+{
+	ADD_COUNTER(e->counters, addme[*i].bcnt, addme[*i].pcnt);
+
+	(*i)++;
+	return 0;
+}
 
 static int
 do_add_counters(struct net *net, void __user *user, unsigned int len, int compat)
@@ -1386,7 +1341,7 @@ do_add_counters(struct net *net, void __user *user, unsigned int len, int compat
 	struct xt_counters *paddc;
 	unsigned int num_counters;
 	const char *name;
-	int size;
+	int cpu, size;
 	void *ptmp;
 	struct xt_table *t;
 	const struct xt_table_info *private;
@@ -1437,25 +1392,25 @@ do_add_counters(struct net *net, void __user *user, unsigned int len, int compat
 		goto free;
 	}
 
-	mutex_lock(&t->lock);
 	private = t->private;
 	if (private->number != num_counters) {
 		ret = -EINVAL;
 		goto unlock_up_free;
 	}
 
-	preempt_disable();
-	i = 0;
 	/* Choose the copy that is on our node */
-	loc_cpu_entry = private->entries[raw_smp_processor_id()];
+	cpu = raw_smp_processor_id();
+	spin_lock_bh(&per_cpu(ip_tables_lock, cpu).lock);
+	loc_cpu_entry = private->entries[cpu];
+	i = 0;
 	IPT_ENTRY_ITERATE(loc_cpu_entry,
 			  private->size,
 			  add_counter_to_entry,
 			  paddc,
 			  &i);
-	preempt_enable();
+	spin_unlock_bh(&per_cpu(ip_tables_lock, cpu).lock);
+
  unlock_up_free:
-	mutex_unlock(&t->lock);
 	xt_table_unlock(t);
 	module_put(t->me);
  free:
@@ -2272,7 +2227,10 @@ static struct pernet_operations ip_tables_net_ops = {
 
 static int __init ip_tables_init(void)
 {
-	int ret;
+	int cpu, ret;
+
+	for_each_possible_cpu(cpu)
+		spin_lock_init(&per_cpu(ip_tables_lock, cpu).lock);
 
 	ret = register_pernet_subsys(&ip_tables_net_ops);
 	if (ret < 0)
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 800ae85..5b03479 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -329,6 +329,12 @@ static void trace_packet(struct sk_buff *skb,
 }
 #endif
 
+struct rec_lock {
+	spinlock_t lock;
+	int	   count; /* recursion count */
+};
+static DEFINE_PER_CPU(struct rec_lock, ip6_tables_lock);
+
 /* Returns one of the generic firewall policies, like NF_ACCEPT. */
 unsigned int
 ip6t_do_table(struct sk_buff *skb,
@@ -347,6 +353,7 @@ ip6t_do_table(struct sk_buff *skb,
 	struct xt_table_info *private;
 	struct xt_match_param mtpar;
 	struct xt_target_param tgpar;
+	struct rec_lock *rl;
 
 	/* Initialization */
 	indev = in ? in->name : nulldevname;
@@ -367,7 +374,12 @@ ip6t_do_table(struct sk_buff *skb,
 
 	rcu_read_lock_bh();
 	private = rcu_dereference(table->private);
-	table_base = rcu_dereference(private->entries[smp_processor_id()]);
+
+	rl = &__get_cpu_var(ip_tables_lock);
+	if (likely(rl->count++ == 0))
+		spin_lock(&rl->lock);
+
+	table_base = private->entries[smp_processor_id()];
 
 	e = get_entry(table_base, private->hook_entry[hook]);
 
@@ -467,6 +479,8 @@ ip6t_do_table(struct sk_buff *skb,
 	((struct ip6t_entry *)table_base)->comefrom = NETFILTER_LINK_POISON;
 #endif
 	rcu_read_unlock_bh();
+	if (likely(--rl->count == 0))
+		spin_unlock(&rl->lock);
 
 #ifdef DEBUG_ALLOW_ALL
 	return NF_ACCEPT;
@@ -931,73 +945,25 @@ get_counters(const struct xt_table_info *t,
 	curcpu = raw_smp_processor_id();
 
 	i = 0;
+	spin_lock_bh(&per_cpu(ip6_tables_lock, curcpu).lock);
 	IP6T_ENTRY_ITERATE(t->entries[curcpu],
 			   t->size,
 			   set_entry_to_counter,
 			   counters,
 			   &i);
+	spin_unlock_bh(&per_cpu(ip6_tables_lock, curcpu).lock);
 
 	for_each_possible_cpu(cpu) {
 		if (cpu == curcpu)
 			continue;
 		i = 0;
+		spin_lock_bh(&per_cpu(ip6_tables_lock, cpu).lock);
 		IP6T_ENTRY_ITERATE(t->entries[cpu],
 				  t->size,
 				  add_entry_to_counter,
 				  counters,
 				  &i);
-	}
-}
-
-/* We're lazy, and add to the first CPU; overflow works its fey magic
- * and everything is OK. */
-static int
-add_counter_to_entry(struct ip6t_entry *e,
-		     const struct xt_counters addme[],
-		     unsigned int *i)
-{
-	ADD_COUNTER(e->counters, addme[*i].bcnt, addme[*i].pcnt);
-
-	(*i)++;
-	return 0;
-}
-
-/* Take values from counters and add them back onto the current cpu */
-static void put_counters(struct xt_table_info *t,
-			 const struct xt_counters counters[])
-{
-	unsigned int i, cpu;
-
-	local_bh_disable();
-	cpu = smp_processor_id();
-	i = 0;
-	IP6T_ENTRY_ITERATE(t->entries[cpu],
-			   t->size,
-			   add_counter_to_entry,
-			   counters,
-			   &i);
-	local_bh_enable();
-}
-
-static inline int
-zero_entry_counter(struct ip6t_entry *e, void *arg)
-{
-	e->counters.bcnt = 0;
-	e->counters.pcnt = 0;
-	return 0;
-}
-
-static void
-clone_counters(struct xt_table_info *newinfo, const struct xt_table_info *info)
-{
-	unsigned int cpu;
-	const void *loc_cpu_entry = info->entries[raw_smp_processor_id()];
-
-	memcpy(newinfo, info, offsetof(struct xt_table_info, entries));
-	for_each_possible_cpu(cpu) {
-		memcpy(newinfo->entries[cpu], loc_cpu_entry, info->size);
-		IP6T_ENTRY_ITERATE(newinfo->entries[cpu], newinfo->size,
-				   zero_entry_counter, NULL);
+		spin_unlock_bh(&per_cpu(ip6_tables_lock, cpu).lock);
 	}
 }
 
@@ -1006,7 +972,6 @@ static struct xt_counters *alloc_counters(struct xt_table *table)
 	unsigned int countersize;
 	struct xt_counters *counters;
 	struct xt_table_info *private = table->private;
-	struct xt_table_info *info;
 
 	/* We need atomic snapshot of counters: rest doesn't change
 	   (other than comefrom, which userspace doesn't care
@@ -1015,30 +980,11 @@ static struct xt_counters *alloc_counters(struct xt_table *table)
 	counters = vmalloc_node(countersize, numa_node_id());
 
 	if (counters == NULL)
-		goto nomem;
-
-	info = xt_alloc_table_info(private->size);
-	if (!info)
-		goto free_counters;
-
-	clone_counters(info, private);
-
-	mutex_lock(&table->lock);
-	xt_table_entry_swap_rcu(private, info);
-	synchronize_net();	/* Wait until smoke has cleared */
+		return ERR_PTR(-ENOMEM);
 
-	get_counters(info, counters);
-	put_counters(private, counters);
-	mutex_unlock(&table->lock);
-
-	xt_free_table_info(info);
+	get_counters(private, counters);
 
 	return counters;
-
- free_counters:
-	vfree(counters);
- nomem:
-	return ERR_PTR(-ENOMEM);
 }
 
 static int
@@ -1405,6 +1351,19 @@ do_replace(struct net *net, void __user *user, unsigned int len)
 	return ret;
 }
 
+/* We're lazy, and add to the first CPU; overflow works its fey magic
+ * and everything is OK. */
+static int
+add_counter_to_entry(struct ip6t_entry *e,
+		     const struct xt_counters addme[],
+		     unsigned int *i)
+{
+	ADD_COUNTER(e->counters, addme[*i].bcnt, addme[*i].pcnt);
+
+	(*i)++;
+	return 0;
+}
+
 static int
 do_add_counters(struct net *net, void __user *user, unsigned int len,
 		int compat)
@@ -1465,25 +1424,26 @@ do_add_counters(struct net *net, void __user *user, unsigned int len,
 		goto free;
 	}
 
-	mutex_lock(&t->lock);
 	private = t->private;
 	if (private->number != num_counters) {
 		ret = -EINVAL;
 		goto unlock_up_free;
 	}
 
-	preempt_disable();
-	i = 0;
+	local_bh_disable();
 	/* Choose the copy that is on our node */
-	loc_cpu_entry = private->entries[raw_smp_processor_id()];
+	spin_lock(&__get_cpu_var(ip6_tables_lock).lock);
+	loc_cpu_entry = private->entries[smp_processor_id()];
+	i = 0;
 	IP6T_ENTRY_ITERATE(loc_cpu_entry,
 			  private->size,
 			  add_counter_to_entry,
 			  paddc,
 			  &i);
-	preempt_enable();
+	spin_unlock(&__get_cpu_var(ip6_tables_lock).lock);
+	local_bh_enable();
+
  unlock_up_free:
-	mutex_unlock(&t->lock);
 	xt_table_unlock(t);
 	module_put(t->me);
  free:
@@ -2298,7 +2258,10 @@ static struct pernet_operations ip6_tables_net_ops = {
 
 static int __init ip6_tables_init(void)
 {
-	int ret;
+	int cpu, ret;
+
+	for_each_possible_cpu(cpu)
+		spin_lock_init(&per_cpu(ip6_tables_lock, cpu).lock);
 
 	ret = register_pernet_subsys(&ip6_tables_net_ops);
 	if (ret < 0)
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 509a956..adc1b11 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -625,20 +625,6 @@ void xt_free_table_info(struct xt_table_info *info)
 }
 EXPORT_SYMBOL(xt_free_table_info);
 
-void xt_table_entry_swap_rcu(struct xt_table_info *oldinfo,
-			     struct xt_table_info *newinfo)
-{
-	unsigned int cpu;
-
-	for_each_possible_cpu(cpu) {
-		void *p = oldinfo->entries[cpu];
-		rcu_assign_pointer(oldinfo->entries[cpu], newinfo->entries[cpu]);
-		newinfo->entries[cpu] = p;
-	}
-
-}
-EXPORT_SYMBOL_GPL(xt_table_entry_swap_rcu);
-
 /* Find table by name, grabs mutex & ref.  Returns ERR_PTR() on error. */
 struct xt_table *xt_find_table_lock(struct net *net, u_int8_t af,
 				    const char *name)
@@ -682,26 +668,21 @@ xt_replace_table(struct xt_table *table,
 	      struct xt_table_info *newinfo,
 	      int *error)
 {
-	struct xt_table_info *oldinfo, *private;
+	struct xt_table_info *private;
 
 	/* Do the substitution. */
-	mutex_lock(&table->lock);
 	private = table->private;
 	/* Check inside lock: is the old number correct? */
 	if (num_counters != private->number) {
 		duprintf("num_counters != table->private->number (%u/%u)\n",
 			 num_counters, private->number);
-		mutex_unlock(&table->lock);
 		*error = -EAGAIN;
 		return NULL;
 	}
-	oldinfo = private;
 	rcu_assign_pointer(table->private, newinfo);
-	newinfo->initial_entries = oldinfo->initial_entries;
-	mutex_unlock(&table->lock);
+	newinfo->initial_entries = private->initial_entries;
 
-	synchronize_net();
-	return oldinfo;
+	return private;
 }
 EXPORT_SYMBOL_GPL(xt_replace_table);
 
@@ -734,7 +715,6 @@ struct xt_table *xt_register_table(struct net *net, struct xt_table *table,
 
 	/* Simplifies replace_table code. */
 	table->private = bootstrap;
-	mutex_init(&table->lock);
 
 	if (!xt_replace_table(table, 0, newinfo, &ret))
 		goto unlock;

