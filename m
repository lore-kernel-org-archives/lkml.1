Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758794Ab0BYKLA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 05:11:00 -0500
Received: from hera.kernel.org ([140.211.167.34]:47743 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754200Ab0BYKK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 05:10:57 -0500
Date: Thu, 25 Feb 2010 10:10:19 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       eric.dumazet@gmail.com, davem@davemloft.net, paulmck@linux.vnet.ibm.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       eric.dumazet@gmail.com, davem@davemloft.net, paulmck@linux.vnet.ibm.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1266887105-1528-5-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1266887105-1528-5-git-send-email-paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] net: Add checking to rcu_dereference() primitives
Message-ID: <tip-a898def29e4119bc01ebe7ca97423181f4c0ea2d@git.kernel.org>
Git-Commit-ID: a898def29e4119bc01ebe7ca97423181f4c0ea2d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 25 Feb 2010 10:10:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a898def29e4119bc01ebe7ca97423181f4c0ea2d
Gitweb:     http://git.kernel.org/tip/a898def29e4119bc01ebe7ca97423181f4c0ea2d
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Mon, 22 Feb 2010 17:04:49 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 25 Feb 2010 09:41:03 +0100

net: Add checking to rcu_dereference() primitives

Update rcu_dereference() primitives to use new lockdep-based
checking. The rcu_dereference() in __in6_dev_get() may be
protected either by rcu_read_lock() or RTNL, per Eric Dumazet.
The rcu_dereference() in __sk_free() is protected by the fact
that it is never reached if an update could change it.  Check
for this by using rcu_dereference_check() to verify that the
struct sock's ->sk_wmem_alloc counter is zero.

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
LKML-Reference: <1266887105-1528-5-git-send-email-paulmck@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/rtnetlink.h |    3 +++
 include/net/addrconf.h    |    4 +++-
 net/core/dev.c            |    2 +-
 net/core/filter.c         |    6 +++---
 net/core/rtnetlink.c      |    8 ++++++++
 net/core/sock.c           |    3 ++-
 net/decnet/dn_route.c     |   14 +++++++-------
 net/ipv4/route.c          |   14 +++++++-------
 net/packet/af_packet.c    |    2 +-
 9 files changed, 35 insertions(+), 21 deletions(-)

diff --git a/include/linux/rtnetlink.h b/include/linux/rtnetlink.h
index 05330fc..5c52fa4 100644
--- a/include/linux/rtnetlink.h
+++ b/include/linux/rtnetlink.h
@@ -735,6 +735,9 @@ extern void rtnl_lock(void);
 extern void rtnl_unlock(void);
 extern int rtnl_trylock(void);
 extern int rtnl_is_locked(void);
+#ifdef CONFIG_PROVE_LOCKING
+extern int lockdep_rtnl_is_held(void);
+#endif /* #ifdef CONFIG_PROVE_LOCKING */
 
 extern void rtnetlink_init(void);
 extern void __rtnl_unlock(void);
diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index 0f7c378..45375b4 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -177,7 +177,9 @@ extern int unregister_inet6addr_notifier(struct notifier_block *nb);
 static inline struct inet6_dev *
 __in6_dev_get(struct net_device *dev)
 {
-	return rcu_dereference(dev->ip6_ptr);
+	return rcu_dereference_check(dev->ip6_ptr,
+				     rcu_read_lock_held() ||
+				     lockdep_rtnl_is_held());
 }
 
 static inline struct inet6_dev *
diff --git a/net/core/dev.c b/net/core/dev.c
index ec87421..bb1f1da 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2041,7 +2041,7 @@ gso:
 	rcu_read_lock_bh();
 
 	txq = dev_pick_tx(dev, skb);
-	q = rcu_dereference(txq->qdisc);
+	q = rcu_dereference_bh(txq->qdisc);
 
 #ifdef CONFIG_NET_CLS_ACT
 	skb->tc_verd = SET_TC_AT(skb->tc_verd, AT_EGRESS);
diff --git a/net/core/filter.c b/net/core/filter.c
index 08db7b9..3541aa4 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -86,7 +86,7 @@ int sk_filter(struct sock *sk, struct sk_buff *skb)
 		return err;
 
 	rcu_read_lock_bh();
-	filter = rcu_dereference(sk->sk_filter);
+	filter = rcu_dereference_bh(sk->sk_filter);
 	if (filter) {
 		unsigned int pkt_len = sk_run_filter(skb, filter->insns,
 				filter->len);
@@ -521,7 +521,7 @@ int sk_attach_filter(struct sock_fprog *fprog, struct sock *sk)
 	}
 
 	rcu_read_lock_bh();
-	old_fp = rcu_dereference(sk->sk_filter);
+	old_fp = rcu_dereference_bh(sk->sk_filter);
 	rcu_assign_pointer(sk->sk_filter, fp);
 	rcu_read_unlock_bh();
 
@@ -536,7 +536,7 @@ int sk_detach_filter(struct sock *sk)
 	struct sk_filter *filter;
 
 	rcu_read_lock_bh();
-	filter = rcu_dereference(sk->sk_filter);
+	filter = rcu_dereference_bh(sk->sk_filter);
 	if (filter) {
 		rcu_assign_pointer(sk->sk_filter, NULL);
 		sk_filter_delayed_uncharge(sk, filter);
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 794bcb8..4c7d3f6 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -89,6 +89,14 @@ int rtnl_is_locked(void)
 }
 EXPORT_SYMBOL(rtnl_is_locked);
 
+#ifdef CONFIG_PROVE_LOCKING
+int lockdep_rtnl_is_held(void)
+{
+	return lockdep_is_held(&rtnl_mutex);
+}
+EXPORT_SYMBOL(lockdep_rtnl_is_held);
+#endif /* #ifdef CONFIG_PROVE_LOCKING */
+
 static struct rtnl_link *rtnl_msg_handlers[NPROTO];
 
 static inline int rtm_msgindex(int msgtype)
diff --git a/net/core/sock.c b/net/core/sock.c
index e1f6f22..305cba4 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1073,7 +1073,8 @@ static void __sk_free(struct sock *sk)
 	if (sk->sk_destruct)
 		sk->sk_destruct(sk);
 
-	filter = rcu_dereference(sk->sk_filter);
+	filter = rcu_dereference_check(sk->sk_filter,
+				       atomic_read(&sk->sk_wmem_alloc) == 0);
 	if (filter) {
 		sk_filter_uncharge(sk, filter);
 		rcu_assign_pointer(sk->sk_filter, NULL);
diff --git a/net/decnet/dn_route.c b/net/decnet/dn_route.c
index a032840..a7bf03c 100644
--- a/net/decnet/dn_route.c
+++ b/net/decnet/dn_route.c
@@ -1155,8 +1155,8 @@ static int __dn_route_output_key(struct dst_entry **pprt, const struct flowi *fl
 
 	if (!(flags & MSG_TRYHARD)) {
 		rcu_read_lock_bh();
-		for(rt = rcu_dereference(dn_rt_hash_table[hash].chain); rt;
-			rt = rcu_dereference(rt->u.dst.dn_next)) {
+		for (rt = rcu_dereference_bh(dn_rt_hash_table[hash].chain); rt;
+			rt = rcu_dereference_bh(rt->u.dst.dn_next)) {
 			if ((flp->fld_dst == rt->fl.fld_dst) &&
 			    (flp->fld_src == rt->fl.fld_src) &&
 			    (flp->mark == rt->fl.mark) &&
@@ -1618,9 +1618,9 @@ int dn_cache_dump(struct sk_buff *skb, struct netlink_callback *cb)
 		if (h > s_h)
 			s_idx = 0;
 		rcu_read_lock_bh();
-		for(rt = rcu_dereference(dn_rt_hash_table[h].chain), idx = 0;
+		for(rt = rcu_dereference_bh(dn_rt_hash_table[h].chain), idx = 0;
 			rt;
-			rt = rcu_dereference(rt->u.dst.dn_next), idx++) {
+			rt = rcu_dereference_bh(rt->u.dst.dn_next), idx++) {
 			if (idx < s_idx)
 				continue;
 			skb_dst_set(skb, dst_clone(&rt->u.dst));
@@ -1654,12 +1654,12 @@ static struct dn_route *dn_rt_cache_get_first(struct seq_file *seq)
 
 	for(s->bucket = dn_rt_hash_mask; s->bucket >= 0; --s->bucket) {
 		rcu_read_lock_bh();
-		rt = dn_rt_hash_table[s->bucket].chain;
+		rt = rcu_dereference_bh(dn_rt_hash_table[s->bucket].chain);
 		if (rt)
 			break;
 		rcu_read_unlock_bh();
 	}
-	return rcu_dereference(rt);
+	return rt;
 }
 
 static struct dn_route *dn_rt_cache_get_next(struct seq_file *seq, struct dn_route *rt)
@@ -1674,7 +1674,7 @@ static struct dn_route *dn_rt_cache_get_next(struct seq_file *seq, struct dn_rou
 		rcu_read_lock_bh();
 		rt = dn_rt_hash_table[s->bucket].chain;
 	}
-	return rcu_dereference(rt);
+	return rcu_dereference_bh(rt);
 }
 
 static void *dn_rt_cache_seq_start(struct seq_file *seq, loff_t *pos)
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index d62b05d..4f11faa 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -287,12 +287,12 @@ static struct rtable *rt_cache_get_first(struct seq_file *seq)
 		if (!rt_hash_table[st->bucket].chain)
 			continue;
 		rcu_read_lock_bh();
-		r = rcu_dereference(rt_hash_table[st->bucket].chain);
+		r = rcu_dereference_bh(rt_hash_table[st->bucket].chain);
 		while (r) {
 			if (dev_net(r->u.dst.dev) == seq_file_net(seq) &&
 			    r->rt_genid == st->genid)
 				return r;
-			r = rcu_dereference(r->u.dst.rt_next);
+			r = rcu_dereference_bh(r->u.dst.rt_next);
 		}
 		rcu_read_unlock_bh();
 	}
@@ -314,7 +314,7 @@ static struct rtable *__rt_cache_get_next(struct seq_file *seq,
 		rcu_read_lock_bh();
 		r = rt_hash_table[st->bucket].chain;
 	}
-	return rcu_dereference(r);
+	return rcu_dereference_bh(r);
 }
 
 static struct rtable *rt_cache_get_next(struct seq_file *seq,
@@ -2689,8 +2689,8 @@ int __ip_route_output_key(struct net *net, struct rtable **rp,
 	hash = rt_hash(flp->fl4_dst, flp->fl4_src, flp->oif, rt_genid(net));
 
 	rcu_read_lock_bh();
-	for (rth = rcu_dereference(rt_hash_table[hash].chain); rth;
-		rth = rcu_dereference(rth->u.dst.rt_next)) {
+	for (rth = rcu_dereference_bh(rt_hash_table[hash].chain); rth;
+		rth = rcu_dereference_bh(rth->u.dst.rt_next)) {
 		if (rth->fl.fl4_dst == flp->fl4_dst &&
 		    rth->fl.fl4_src == flp->fl4_src &&
 		    rth->fl.iif == 0 &&
@@ -3008,8 +3008,8 @@ int ip_rt_dump(struct sk_buff *skb,  struct netlink_callback *cb)
 		if (!rt_hash_table[h].chain)
 			continue;
 		rcu_read_lock_bh();
-		for (rt = rcu_dereference(rt_hash_table[h].chain), idx = 0; rt;
-		     rt = rcu_dereference(rt->u.dst.rt_next), idx++) {
+		for (rt = rcu_dereference_bh(rt_hash_table[h].chain), idx = 0; rt;
+		     rt = rcu_dereference_bh(rt->u.dst.rt_next), idx++) {
 			if (!net_eq(dev_net(rt->u.dst.dev), net) || idx < s_idx)
 				continue;
 			if (rt_is_expired(rt))
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index f126d18..939471e 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -508,7 +508,7 @@ static inline unsigned int run_filter(struct sk_buff *skb, struct sock *sk,
 	struct sk_filter *filter;
 
 	rcu_read_lock_bh();
-	filter = rcu_dereference(sk->sk_filter);
+	filter = rcu_dereference_bh(sk->sk_filter);
 	if (filter != NULL)
 		res = sk_run_filter(skb, filter->insns, filter->len);
 	rcu_read_unlock_bh();
