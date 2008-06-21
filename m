Return-Path: <linux-kernel-owner+w=401wt.eu-S1755211AbYFUJ4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211AbYFUJ4f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 05:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754545AbYFUJ4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 05:56:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63494 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753802AbYFUJ4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 05:56:06 -0400
Message-ID: <485CCFC9.2070007@cn.fujitsu.com>
Date: Sat, 21 Jun 2008 17:54:17 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Luis Carlos Cobo <luisca@cozybit.com>,
       Steve Whitehouse <SteveW@ACM.org>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH]rcu,inet,fib_trie,route,radix-tree,DECnet,mac80211: fix meaningless
 rcu_dereference(local_var)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


rcu_dereference is provided for fetching an RCU-protected pointer.

And rcu_dereference(local_var) is meaningless and may causes bugs.


Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/inetdevice.h b/include/linux/inetdevice.h
index c6f51ad..da7aada 100644
--- a/include/linux/inetdevice.h
+++ b/include/linux/inetdevice.h
@@ -166,10 +166,7 @@ static __inline__ int bad_mask(__be32 mask, __be32 addr)
 
 static inline struct in_device *__in_dev_get_rcu(const struct net_device *dev)
 {
-	struct in_device *in_dev = dev->ip_ptr;
-	if (in_dev)
-		in_dev = rcu_dereference(in_dev);
-	return in_dev;
+	return rcu_dereference(dev->ip_ptr);
 }
 
 static __inline__ struct in_device *
diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index 169a2f8..bfae4e2 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -703,9 +703,9 @@ __lookup(struct radix_tree_node *slot, void **results, unsigned long index,
 	for (i = index & RADIX_TREE_MAP_MASK; i < RADIX_TREE_MAP_SIZE; i++) {
 		struct radix_tree_node *node;
 		index++;
-		node = slot->slots[i];
+		node = rcu_dereference(slot->slots[i]);
 		if (node) {
-			results[nr_found++] = rcu_dereference(node);
+			results[nr_found++] = node;
 			if (nr_found == max_items)
 				goto out;
 		}
@@ -815,7 +815,7 @@ __lookup_tag(struct radix_tree_node *slot, void **results, unsigned long index,
 				index++;
 				if (!tag_get(slot, tag, j))
 					continue;
-				node = slot->slots[j];
+				node = rcu_dereference(slot->slots[j]);
 				/*
 				 * Even though the tag was found set, we need to
 				 * recheck that we have a non-NULL node, because
@@ -827,7 +827,6 @@ __lookup_tag(struct radix_tree_node *slot, void **results, unsigned long index,
 				 * rely on its value remaining the same).
 				 */
 				if (node) {
-					node = rcu_dereference(node);
 					results[nr_found++] = node;
 					if (nr_found == max_items)
 						goto out;
diff --git a/net/decnet/dn_route.c b/net/decnet/dn_route.c
index f50e88b..d0b61f6 100644
--- a/net/decnet/dn_route.c
+++ b/net/decnet/dn_route.c
@@ -1658,27 +1658,27 @@ static struct dn_route *dn_rt_cache_get_first(struct seq_file *seq)
 
 	for(s->bucket = dn_rt_hash_mask; s->bucket >= 0; --s->bucket) {
 		rcu_read_lock_bh();
-		rt = dn_rt_hash_table[s->bucket].chain;
+		rt = rcu_dereference(dn_rt_hash_table[s->bucket].chain);
 		if (rt)
 			break;
 		rcu_read_unlock_bh();
 	}
-	return rcu_dereference(rt);
+	return rt;
 }
 
 static struct dn_route *dn_rt_cache_get_next(struct seq_file *seq, struct dn_route *rt)
 {
 	struct dn_rt_cache_iter_state *s = seq->private;
 
-	rt = rt->u.dst.dn_next;
+	rt = rcu_dereference(rt->u.dst.dn_next);
 	while(!rt) {
 		rcu_read_unlock_bh();
 		if (--s->bucket < 0)
 			break;
 		rcu_read_lock_bh();
-		rt = dn_rt_hash_table[s->bucket].chain;
+		rt = rcu_dereference(dn_rt_hash_table[s->bucket].chain);
 	}
-	return rcu_dereference(rt);
+	return rt;
 }
 
 static void *dn_rt_cache_seq_start(struct seq_file *seq, loff_t *pos)
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 4b02d14..3815328 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -174,9 +174,11 @@ static inline struct tnode *node_parent(struct node *node)
 
 static inline struct tnode *node_parent_rcu(struct node *node)
 {
-	struct tnode *ret = node_parent(node);
+	struct tnode *ret = (struct tnode *)(ACCESS_ONCE(node->parent)
+		& ~NODE_TYPE_MASK);
 
-	return rcu_dereference(ret);
+	smp_read_barrier_depends();
+	return ret;
 }
 
 /* Same as rcu_assign_pointer
@@ -197,9 +199,9 @@ static inline struct node *tnode_get_child(struct tnode *tn, unsigned int i)
 
 static inline struct node *tnode_get_child_rcu(struct tnode *tn, unsigned int i)
 {
-	struct node *ret = tnode_get_child(tn, i);
+	BUG_ON(i >= 1U << tn->bits);
 
-	return rcu_dereference(ret);
+	return rcu_dereference(tn->child[i]);
 }
 
 static inline int tnode_child_length(const struct tnode *tn)
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 96be336..d02346e 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -297,15 +297,15 @@ static struct rtable *__rt_cache_get_next(struct seq_file *seq,
 					  struct rtable *r)
 {
 	struct rt_cache_iter_state *st = seq->private;
-	r = r->u.dst.rt_next;
+	r = rcu_dereference(r->u.dst.rt_next);
 	while (!r) {
 		rcu_read_unlock_bh();
 		if (--st->bucket < 0)
 			break;
 		rcu_read_lock_bh();
-		r = rt_hash_table[st->bucket].chain;
+		r = rcu_dereference(rt_hash_table[st->bucket].chain);
 	}
-	return rcu_dereference(r);
+	return r;
 }
 
 static struct rtable *rt_cache_get_next(struct seq_file *seq,
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index af0cd1e..16e545b 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -830,7 +830,6 @@ void mesh_path_timer(unsigned long data)
 
 	rcu_read_lock();
 	mpath = (struct mesh_path *) data;
-	mpath = rcu_dereference(mpath);
 	if (!mpath)
 		goto endmpathtimer;
 	spin_lock_bh(&mpath->state_lock);





