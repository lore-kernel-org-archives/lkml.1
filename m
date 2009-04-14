Return-Path: <linux-kernel-owner+w=401wt.eu-S1755497AbZDNPwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbZDNPwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 11:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753937AbZDNPvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 11:51:42 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:52506 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581AbZDNPvl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 11:51:41 -0400
Message-ID: <49E4B0A5.70404@cosmosbay.com>
Date: Tue, 14 Apr 2009 17:49:57 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: Patrick McHardy <kaber@trash.net>, paulmck@linux.vnet.ibm.com,
       David Miller <davem@davemloft.net>, paulus@samba.org, mingo@elte.hu,
       torvalds@linux-foundation.org, laijs@cn.fujitsu.com,
       jeff.chua.linux@gmail.com, jengelh@medozas.de, r000n@r000n.net,
       linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
       netdev@vger.kernel.org, benh@kernel.crashing.org
Subject: Re: [PATCH] netfilter: use per-cpu spinlock rather than RCU
References: <20090411174801.GG6822@linux.vnet.ibm.com>	<18913.53699.544083.320542@cargo.ozlabs.ibm.com>	<20090412173108.GO6822@linux.vnet.ibm.com>	<20090412.181330.23529546.davem@davemloft.net>	<20090413040413.GQ6822@linux.vnet.ibm.com>	<20090413095309.631cf395@nehalam>	<49E48136.5060700@trash.net>	<49E49C65.8060808@cosmosbay.com> <20090414074554.7fa73e2f@nehalam>
In-Reply-To: <20090414074554.7fa73e2f@nehalam>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 14 Apr 2009 17:50:01 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger a écrit :
> On Tue, 14 Apr 2009 16:23:33 +0200
> Eric Dumazet <dada1@cosmosbay.com> wrote:
> 
>> Patrick McHardy a écrit :
>>> Stephen Hemminger wrote:
>>>> This is an alternative version of ip/ip6/arp tables locking using
>>>> per-cpu locks.  This avoids the overhead of synchronize_net() during
>>>> update but still removes the expensive rwlock in earlier versions.
>>>>
>>>> The idea for this came from an earlier version done by Eric Duzamet.
>>>> Locking is done per-cpu, the fast path locks on the current cpu
>>>> and updates counters.  The slow case involves acquiring the locks on
>>>> all cpu's.
>>>>
>>>> The mutex that was added for 2.6.30 in xt_table is unnecessary since
>>>> there already is a mutex for xt[af].mutex that is held.
>>>>
>>>> Tested basic functionality (add/remove/list), but don't have test cases
>>>> for stress, ip6tables or arptables.
>>> Thanks Stephen, I'll do some testing with ip6tables.
>> Here is the patch I cooked on top of Stephen one to get proper locking.
> 
> I see no demonstrated problem with locking in my version.

Yes, I did not crash any machine around there, should we wait for a bug report ? :)

> The reader/writer race is already handled. On replace the race of
> 
> CPU 0                          CPU 1
>                            lock (iptables(1))
>                            refer to oldinfo
> swap in new info
> foreach CPU
>    lock iptables(i)
>    (spin)                  unlock(iptables(1))
>    read oldinfo
>    unlock
> ...
> 
> The point is my locking works, you just seem to feel more comfortable with
> a global "stop all CPU's" solution.

Oh right, I missed that xt_replace_table() was *followed* by a get_counters()
call, but I am pretty sure something is needed in xt_replace_table().

A memory barrier at least (smp_wmb())

As soon as we do "table->private = newinfo;", other cpus might fetch incorrect
values for newinfo->fields.

In the past, we had a write_lock_bh()/write_unlock_bh() pair that was
doing this for us.
Then we had rcu_assign_pointer() that also had this memory barrier implied.

Even if vmalloc() calls we do before calling xt_replace_table() probably
already force barriers, add one for reference, just in case we change callers
logic to call kmalloc() instead of vmalloc() or whatever...

> 
>> In the "iptables -L" case, we freeze updates on all cpus to get previous
>> RCU behavior (not sure it is mandatory, but anyway...)
> 
> No, it isn't. Because the code in get_counters will fetch all CPU's.

Previous to RCU conversion, we had a rwlock.

Doing a write_lock_bh() on it while reading counters (iptables -L)
*did* stop all cpus from doing their read_lock_bh() and counters updates.

After RCU and your last patch, an "iptables -L" locks each table one by one.

This is correct, since a cpu wont update its table while we are fetching it,
but we lost previous "rwlock freeze all" behavior, and some apps/users could
complain about it, this is why I said "not sure it is mandatory"...

Here is an updated patch ontop of yours, with the smp_wmb() in xt_replace_table() :

Thank you

 include/linux/netfilter/x_tables.h |    5 ++
 net/ipv4/netfilter/arp_tables.c    |   20 +++------
 net/ipv4/netfilter/ip_tables.c     |   24 ++++-------
 net/ipv6/netfilter/ip6_tables.c    |   24 ++++-------
 net/netfilter/x_tables.c           |   57 ++++++++++++++++++++++++++-
 5 files changed, 86 insertions(+), 44 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 1ff1a76..a5840a4 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -426,6 +426,11 @@ extern struct xt_table *xt_find_table_lock(struct net *net, u_int8_t af,
 					   const char *name);
 extern void xt_table_unlock(struct xt_table *t);
 
+extern void xt_tlock_lockall(void);
+extern void xt_tlock_unlockall(void);
+extern void xt_tlock_lock(void);
+extern void xt_tlock_unlock(void);
+
 extern int xt_proto_init(struct net *net, u_int8_t af);
 extern void xt_proto_fini(struct net *net, u_int8_t af);
 
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index c60cc11..b561e1e 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -231,8 +231,6 @@ static inline struct arpt_entry *get_entry(void *base, unsigned int offset)
 	return (struct arpt_entry *)(base + offset);
 }
 
-static DEFINE_PER_CPU(spinlock_t, arp_tables_lock);
-
 unsigned int arpt_do_table(struct sk_buff *skb,
 			   unsigned int hook,
 			   const struct net_device *in,
@@ -256,7 +254,7 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 	outdev = out ? out->name : nulldevname;
 
 	local_bh_disable();
-	spin_lock(&__get_cpu_var(arp_tables_lock));
+	xt_tlock_lock();
 	private = table->private;
 	table_base = private->entries[smp_processor_id()];
 
@@ -331,7 +329,7 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 			e = (void *)e + e->next_offset;
 		}
 	} while (!hotdrop);
-	spin_unlock(&__get_cpu_var(arp_tables_lock));
+	xt_tlock_unlock();
 	local_bh_enable();
 
 	if (hotdrop)
@@ -709,33 +707,31 @@ static void get_counters(const struct xt_table_info *t,
 {
 	unsigned int cpu;
 	unsigned int i = 0;
-	unsigned int curcpu = raw_smp_processor_id();
+	unsigned int curcpu;
 
+	xt_tlock_lockall();
 	/* Instead of clearing (by a previous call to memset())
 	 * the counters and using adds, we set the counters
 	 * with data used by 'current' CPU
-	 * We dont care about preemption here.
 	 */
-	spin_lock_bh(&per_cpu(arp_tables_lock, curcpu));
+	curcpu = smp_processor_id();
 	ARPT_ENTRY_ITERATE(t->entries[curcpu],
 			   t->size,
 			   set_entry_to_counter,
 			   counters,
 			   &i);
-	spin_unlock_bh(&per_cpu(arp_tables_lock, curcpu));
 
 	for_each_possible_cpu(cpu) {
 		if (cpu == curcpu)
 			continue;
 		i = 0;
-		spin_lock_bh(&per_cpu(arp_tables_lock, cpu));
 		ARPT_ENTRY_ITERATE(t->entries[cpu],
 				   t->size,
 				   add_entry_to_counter,
 				   counters,
 				   &i);
-		spin_unlock_bh(&per_cpu(arp_tables_lock, cpu));
 	}
+	xt_tlock_unlockall();
 }
 
 static struct xt_counters *alloc_counters(struct xt_table *table)
@@ -1181,14 +1177,14 @@ static int do_add_counters(struct net *net, void __user *user, unsigned int len,
 	/* Choose the copy that is on our node */
 	local_bh_disable();
 	curcpu = smp_processor_id();
-	spin_lock(&__get_cpu_var(arp_tables_lock));
+	xt_tlock_lock();
 	loc_cpu_entry = private->entries[curcpu];
 	ARPT_ENTRY_ITERATE(loc_cpu_entry,
 			   private->size,
 			   add_counter_to_entry,
 			   paddc,
 			   &i);
-	spin_unlock(&__get_cpu_var(arp_tables_lock));
+	xt_tlock_unlock();
 	local_bh_enable();
  unlock_up_free:
 
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index cb3b779..81d173e 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -297,7 +297,6 @@ static void trace_packet(struct sk_buff *skb,
 }
 #endif
 
-static DEFINE_PER_CPU(spinlock_t, ip_tables_lock);
 
 /* Returns one of the generic firewall policies, like NF_ACCEPT. */
 unsigned int
@@ -342,7 +341,7 @@ ipt_do_table(struct sk_buff *skb,
 	IP_NF_ASSERT(table->valid_hooks & (1 << hook));
 
 	local_bh_disable();
-	spin_lock(&__get_cpu_var(ip_tables_lock));
+	xt_tlock_lock();
 	private = table->private;
 	table_base = private->entries[smp_processor_id()];
 
@@ -439,7 +438,7 @@ ipt_do_table(struct sk_buff *skb,
 			e = (void *)e + e->next_offset;
 		}
 	} while (!hotdrop);
-	spin_unlock(&__get_cpu_var(ip_tables_lock));
+	xt_tlock_unlock();
 	local_bh_enable();
 
 #ifdef DEBUG_ALLOW_ALL
@@ -895,34 +894,32 @@ get_counters(const struct xt_table_info *t,
 {
 	unsigned int cpu;
 	unsigned int i = 0;
-	unsigned int curcpu = raw_smp_processor_id();
+	unsigned int curcpu;
 
+	xt_tlock_lockall();
 	/* Instead of clearing (by a previous call to memset())
 	 * the counters and using adds, we set the counters
 	 * with data used by 'current' CPU
-	 * We dont care about preemption here.
 	 */
-	spin_lock_bh(&per_cpu(ip_tables_lock, curcpu));
+	curcpu = smp_processor_id();
 	IPT_ENTRY_ITERATE(t->entries[curcpu],
 			  t->size,
 			  set_entry_to_counter,
 			  counters,
 			  &i);
-	spin_unlock_bh(&per_cpu(ip_tables_lock, curcpu));
 
 	for_each_possible_cpu(cpu) {
 		if (cpu == curcpu)
 			continue;
 
 		i = 0;
-		spin_lock_bh(&per_cpu(ip_tables_lock, cpu));
 		IPT_ENTRY_ITERATE(t->entries[cpu],
 				  t->size,
 				  add_entry_to_counter,
 				  counters,
 				  &i);
-		spin_unlock_bh(&per_cpu(ip_tables_lock, cpu));
 	}
+	xt_tlock_unlockall();
 }
 
 static struct xt_counters * alloc_counters(struct xt_table *table)
@@ -1393,14 +1390,14 @@ do_add_counters(struct net *net, void __user *user, unsigned int len, int compat
 	local_bh_disable();
 	/* Choose the copy that is on our node */
 	curcpu = smp_processor_id();
-	spin_lock(&__get_cpu_var(ip_tables_lock));
+	xt_tlock_lock();
 	loc_cpu_entry = private->entries[curcpu];
 	IPT_ENTRY_ITERATE(loc_cpu_entry,
 			  private->size,
 			  add_counter_to_entry,
 			  paddc,
 			  &i);
-	spin_unlock(&__get_cpu_var(ip_tables_lock));
+	xt_tlock_unlock();
 	local_bh_enable();
 
  unlock_up_free:
@@ -2220,10 +2217,7 @@ static struct pernet_operations ip_tables_net_ops = {
 
 static int __init ip_tables_init(void)
 {
-	int cpu, ret;
-
-	for_each_possible_cpu(cpu)
-		spin_lock_init(&per_cpu(ip_tables_lock, cpu));
+	int ret;
 
 	ret = register_pernet_subsys(&ip_tables_net_ops);
 	if (ret < 0)
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index ac46ca4..d6ba69e 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -329,7 +329,6 @@ static void trace_packet(struct sk_buff *skb,
 }
 #endif
 
-static DEFINE_PER_CPU(spinlock_t, ip6_tables_lock);
 
 /* Returns one of the generic firewall policies, like NF_ACCEPT. */
 unsigned int
@@ -368,7 +367,7 @@ ip6t_do_table(struct sk_buff *skb,
 	IP_NF_ASSERT(table->valid_hooks & (1 << hook));
 
 	local_bh_disable();
-	spin_lock(&__get_cpu_var(ip6_tables_lock));
+	xt_tlock_lock();
 	private = table->private;
 	table_base = private->entries[smp_processor_id()];
 
@@ -469,7 +468,7 @@ ip6t_do_table(struct sk_buff *skb,
 #ifdef CONFIG_NETFILTER_DEBUG
 	((struct ip6t_entry *)table_base)->comefrom = NETFILTER_LINK_POISON;
 #endif
-	spin_unlock(&__get_cpu_var(ip6_tables_lock));
+	xt_tlock_unlock();
 	local_bh_enable();
 
 #ifdef DEBUG_ALLOW_ALL
@@ -925,33 +924,31 @@ get_counters(const struct xt_table_info *t,
 {
 	unsigned int cpu;
 	unsigned int i = 0;
-	unsigned int curcpu = raw_smp_processor_id();
+	unsigned int curcpu;
 
+	xt_tlock_lockall();
 	/* Instead of clearing (by a previous call to memset())
 	 * the counters and using adds, we set the counters
 	 * with data used by 'current' CPU
-	 * We dont care about preemption here.
 	 */
-	spin_lock_bh(&per_cpu(ip6_tables_lock, curcpu));
+	curcpu = smp_processor_id();
 	IP6T_ENTRY_ITERATE(t->entries[curcpu],
 			   t->size,
 			   set_entry_to_counter,
 			   counters,
 			   &i);
-	spin_unlock_bh(&per_cpu(ip6_tables_lock, curcpu));
 
 	for_each_possible_cpu(cpu) {
 		if (cpu == curcpu)
 			continue;
 		i = 0;
-		spin_lock_bh(&per_cpu(ip6_tables_lock, cpu));
 		IP6T_ENTRY_ITERATE(t->entries[cpu],
 				  t->size,
 				  add_entry_to_counter,
 				  counters,
 				  &i);
-		spin_unlock_bh(&per_cpu(ip6_tables_lock, cpu));
 	}
+	xt_tlock_unlockall();
 }
 
 static struct xt_counters *alloc_counters(struct xt_table *table)
@@ -1423,14 +1420,14 @@ do_add_counters(struct net *net, void __user *user, unsigned int len,
 	local_bh_disable();
 	/* Choose the copy that is on our node */
 	curcpu = smp_processor_id();
-	spin_lock(&__get_cpu_var(ip6_tables_lock));
+	xt_tlock_lock();
 	loc_cpu_entry = private->entries[curcpu];
 	IP6T_ENTRY_ITERATE(loc_cpu_entry,
 			  private->size,
 			  add_counter_to_entry,
 			  paddc,
 			  &i);
-	spin_unlock(&__get_cpu_var(ip6_tables_lock));
+	xt_tlock_unlock();
 	local_bh_enable();
 
  unlock_up_free:
@@ -2248,10 +2245,7 @@ static struct pernet_operations ip6_tables_net_ops = {
 
 static int __init ip6_tables_init(void)
 {
-	int cpu, ret;
-
-	for_each_possible_cpu(cpu)
-		spin_lock_init(&per_cpu(ip6_tables_lock, cpu));
+	int ret;
 
 	ret = register_pernet_subsys(&ip6_tables_net_ops);
 	if (ret < 0)
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 0d94020..3cf19bf 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -680,9 +680,13 @@ xt_replace_table(struct xt_table *table,
 		return NULL;
 	}
 	oldinfo = private;
+	/*
+	 * make sure all newinfo fields are committed to memory before changing
+	 * table->private, since other cpus have no synchronization with us.
+	 */
+	smp_wmb();
 	table->private = newinfo;
 	newinfo->initial_entries = oldinfo->initial_entries;
-
 	return oldinfo;
 }
 EXPORT_SYMBOL_GPL(xt_replace_table);
@@ -1126,9 +1130,58 @@ static struct pernet_operations xt_net_ops = {
 	.init = xt_net_init,
 };
 
+static DEFINE_PER_CPU(spinlock_t, xt_tables_lock);
+
+void xt_tlock_lockall(void)
+{
+	int cpu;
+
+	local_bh_disable();
+	preempt_disable();
+	for_each_possible_cpu(cpu) {
+		spin_lock(&per_cpu(xt_tables_lock, cpu));
+		/*
+		 * avoid preempt counter overflow
+		 */
+		preempt_enable_no_resched();
+	}
+}
+EXPORT_SYMBOL(xt_tlock_lockall);
+
+void xt_tlock_unlockall(void)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		preempt_disable();
+		spin_unlock(&per_cpu(xt_tables_lock, cpu));
+	}
+	preempt_enable();
+	local_bh_enable();
+}
+EXPORT_SYMBOL(xt_tlock_unlockall);
+
+/*
+ * preemption should be disabled by caller
+ */
+void xt_tlock_lock(void)
+{
+	spin_lock(&__get_cpu_var(xt_tables_lock));
+}
+EXPORT_SYMBOL(xt_tlock_lock);
+
+void xt_tlock_unlock(void)
+{
+	spin_unlock(&__get_cpu_var(xt_tables_lock));
+}
+EXPORT_SYMBOL(xt_tlock_unlock);
+
 static int __init xt_init(void)
 {
-	int i, rv;
+	int i, rv, cpu;
+
+	for_each_possible_cpu(cpu)
+		spin_lock_init(&per_cpu(xt_tables_lock, cpu));
 
 	xt = kmalloc(sizeof(struct xt_af) * NFPROTO_NUMPROTO, GFP_KERNEL);
 	if (!xt)


