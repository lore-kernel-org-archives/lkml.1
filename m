Return-Path: <linux-kernel-owner+w=401wt.eu-S1755630Ab0AMKco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630Ab0AMKco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:32:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754965Ab0AMKcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:32:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:34362 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754921Ab0AMKcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:32:39 -0500
Date: Wed, 13 Jan 2010 10:30:50 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <12626570512265-git-send-email->
References: <12626570512265-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] net: Add checking to rcu_dereference() primitives
Message-ID: <tip-98830349af1e2795ad6bc1894962b50079bafb59@git.kernel.org>
Git-Commit-ID: 98830349af1e2795ad6bc1894962b50079bafb59
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jan 2010 10:30:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  98830349af1e2795ad6bc1894962b50079bafb59
Gitweb:     http://git.kernel.org/tip/98830349af1e2795ad6bc1894962b50079bafb59
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Mon, 4 Jan 2010 18:04:07 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 13 Jan 2010 09:42:46 +0100

net: Add checking to rcu_dereference() primitives

Update rcu_dereference() primitives to use new lockdep-based
checking.

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
LKML-Reference: <12626570512265-git-send-email->
[ v2: fix build error ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
