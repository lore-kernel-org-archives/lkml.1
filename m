Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203Ab0AOBEc (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 20:04:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755991Ab0AOBDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 20:03:08 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:55699 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753495Ab0AOBDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 20:03:06 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 4/9] net: add checking to rcu_dereference() primitives
Date: Thu, 14 Jan 2010 17:02:41 -0800
Message-Id: <12635173663448-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20100115010157.GA28221@linux.vnet.ibm.com>
References: <20100115010157.GA28221@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Update rcu_dereference() primitives to use new lockdep-based checking.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 net/core/dev.c         |    2 +-
 net/core/filter.c      |    6 +++---
 net/core/sock.c        |    2 +-
 net/decnet/dn_route.c  |   14 +++++++-------
 net/ipv4/route.c       |   14 +++++++-------
 net/packet/af_packet.c |    2 +-
 6 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index be9924f..0d0ff82 100644
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
diff --git a/net/core/sock.c b/net/core/sock.c
index e1f6f22..9309cc9 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1073,7 +1073,7 @@ static void __sk_free(struct sock *sk)
 	if (sk->sk_destruct)
 		sk->sk_destruct(sk);
 
-	filter = rcu_dereference(sk->sk_filter);
+	filter = rcu_dereference_bh(sk->sk_filter);
 	if (filter) {
 		sk_filter_uncharge(sk, filter);
 		rcu_assign_pointer(sk->sk_filter, NULL);
diff --git a/net/decnet/dn_route.c b/net/decnet/dn_route.c
index a032840..af96613 100644
--- a/net/decnet/dn_route.c
+++ b/net/decnet/dn_route.c
@@ -1155,8 +1155,8 @@ static int __dn_route_output_key(struct dst_entry **pprt, const struct flowi *fl
 
 	if (!(flags & MSG_TRYHARD)) {
 		rcu_read_lock_bh();
-		for(rt = rcu_dereference(dn_rt_hash_table[hash].chain); rt;
-			rt = rcu_dereference(rt->u.dst.dn_next)) {
+		for(rt = rcu_dereference_bh(dn_rt_hash_table[hash].chain); rt;
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
index e446496..3476b3b 100644
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
@@ -2687,8 +2687,8 @@ int __ip_route_output_key(struct net *net, struct rtable **rp,
 	hash = rt_hash(flp->fl4_dst, flp->fl4_src, flp->oif, rt_genid(net));
 
 	rcu_read_lock_bh();
-	for (rth = rcu_dereference(rt_hash_table[hash].chain); rth;
-		rth = rcu_dereference(rth->u.dst.rt_next)) {
+	for (rth = rcu_dereference_bh(rt_hash_table[hash].chain); rth;
+		rth = rcu_dereference_bh(rth->u.dst.rt_next)) {
 		if (rth->fl.fl4_dst == flp->fl4_dst &&
 		    rth->fl.fl4_src == flp->fl4_src &&
 		    rth->fl.iif == 0 &&
@@ -3006,8 +3006,8 @@ int ip_rt_dump(struct sk_buff *skb,  struct netlink_callback *cb)
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
-- 
1.5.2.5

