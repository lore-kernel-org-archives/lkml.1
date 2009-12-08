Return-Path: <linux-kernel-owner+w=401wt.eu-S965914AbZLHTlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965914AbZLHTlR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 14:41:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965879AbZLHTlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 14:41:11 -0500
Received: from tomts43.bellnexxia.net ([209.226.175.110]:51915 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965878AbZLHTlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 14:41:09 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao4FAFM3HkuuWOw8/2dsb2JhbACBTNglhDIEgWg
Date: Tue, 8 Dec 2009 14:36:12 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: "David S. Miller" <davem@davemloft.net>,
       Robert Olsson <robert.olsson@its.uu.se>,
       Jens Laas <jens.laas@data.slu.se>, Hans Liss <hans.liss@its.uu.se>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org
Subject: [PATCH] fib-trie: code cleanup (v2)
Message-ID: <20091208193612.GF1653@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 14:34:00 up 6 days, 10:24,  4 users,  load average: 0.47, 0.28,
	0.20
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Here is a standard janitor-style cleanup patch for the fib_trie code. I thought
that while I was looking at how it works by pure interest, I could as well
cleanup the coding style.

- Standardize spacing around operations (-, +, <<, >>, ...).
- White-space removal.

Then the checkpath checks:

WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>

ERROR: do not use assignment in if condition
fib_route_get_idx contained a if() with an assignment.
Leaving as-is on purpose, otherwise we have to duplicate code.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Robert Olsson <robert.olsson@its.uu.se>
CC: Jens Laas <jens.laas@data.slu.se>
CC: Hans Liss <hans.liss@its.uu.se>
CC: David S. Miller <davem@davemloft.net>
CC: Stephen Hemminger <shemminger@osdl.org>
CC: Paul E. McKenney <paulmck@us.ibm.com>
CC: Patrick McHardy <kaber@trash.net>
---
 net/ipv4/fib_trie.c |  145 ++++++++++++++++++++++++++--------------------------
 1 file changed, 73 insertions(+), 72 deletions(-)

Index: linux-2.6-lttng/net/ipv4/fib_trie.c
===================================================================
--- linux-2.6-lttng.orig/net/ipv4/fib_trie.c	2009-12-08 13:42:14.000000000 -0500
+++ linux-2.6-lttng/net/ipv4/fib_trie.c	2009-12-08 14:35:08.000000000 -0500
@@ -50,7 +50,7 @@
 
 #define VERSION "0.409"
 
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <asm/system.h>
 #include <linux/bitops.h>
 #include <linux/types.h>
@@ -91,8 +91,20 @@ typedef unsigned int t_key;
 #define NODE_TYPE_MASK	0x1UL
 #define NODE_TYPE(node) ((node)->parent & NODE_TYPE_MASK)
 
-#define IS_TNODE(n) (!(n->parent & T_LEAF))
-#define IS_LEAF(n) (n->parent & T_LEAF)
+#define IS_TNODE(n) (!((n)->parent & T_LEAF))
+#define IS_LEAF(n) ((n)->parent & T_LEAF)
+
+/*
+ * synchronize_rcu after call_rcu for that many pages; it should be especially
+ * useful before resizing the root node with PREEMPT_NONE configs; the value was
+ * obtained experimentally, aiming to avoid visible slowdown.
+ */
+static const int sync_pages = 128;
+
+static const int halve_threshold = 25;
+static const int inflate_threshold = 50;
+static const int halve_threshold_root = 15;
+static const int inflate_threshold_root = 30;
 
 struct node {
 	unsigned long parent;
@@ -166,13 +178,6 @@ static struct tnode *halve(struct trie *
 static struct tnode *tnode_free_head;
 static size_t tnode_free_size;
 
-/*
- * synchronize_rcu after call_rcu for that many pages; it should be especially
- * useful before resizing the root node with PREEMPT_NONE configs; the value was
- * obtained experimentally, aiming to avoid visible slowdown.
- */
-static const int sync_pages = 128;
-
 static struct kmem_cache *fn_alias_kmem __read_mostly;
 static struct kmem_cache *trie_leaf_kmem __read_mostly;
 
@@ -218,7 +223,7 @@ static inline int tnode_child_length(con
 
 static inline t_key mask_pfx(t_key k, unsigned short l)
 {
-	return (l == 0) ? 0 : k >> (KEYLENGTH-l) << (KEYLENGTH-l);
+	return (l == 0) ? 0 : k >> (KEYLENGTH - l) << (KEYLENGTH - l);
 }
 
 static inline t_key tkey_extract_bits(t_key a, int offset, int bits)
@@ -249,7 +254,7 @@ static inline int tkey_mismatch(t_key a,
 
 	if (!diff)
 		return 0;
-	while ((diff << i) >> (KEYLENGTH-1) == 0)
+	while ((diff << i) >> (KEYLENGTH - 1) == 0)
 		i++;
 	return i;
 }
@@ -322,11 +327,6 @@ static inline void check_tnode(const str
 	WARN_ON(tn && tn->pos+tn->bits > 32);
 }
 
-static const int halve_threshold = 25;
-static const int inflate_threshold = 50;
-static const int halve_threshold_root = 15;
-static const int inflate_threshold_root = 30;
-
 static void __alias_free_mem(struct rcu_head *head)
 {
 	struct fib_alias *fa = container_of(head, struct fib_alias, rcu);
@@ -408,7 +408,7 @@ static void tnode_free_flush(void)
 {
 	struct tnode *tn;
 
-	while ((tn = tnode_free_head)) {
+	while ( (tn = tnode_free_head) ) {
 		tnode_free_head = tn->tnode_free;
 		tn->tnode_free = NULL;
 		tnode_free(tn);
@@ -432,7 +432,7 @@ static struct leaf *leaf_new(void)
 
 static struct leaf_info *leaf_info_new(int plen)
 {
-	struct leaf_info *li = kmalloc(sizeof(struct leaf_info),  GFP_KERNEL);
+	struct leaf_info *li = kmalloc(sizeof(struct leaf_info), GFP_KERNEL);
 	if (li) {
 		li->plen = plen;
 		INIT_LIST_HEAD(&li->falh);
@@ -451,7 +451,7 @@ static struct tnode *tnode_new(t_key key
 		tn->bits = bits;
 		tn->key = key;
 		tn->full_children = 0;
-		tn->empty_children = 1<<bits;
+		tn->empty_children = 1 << bits;
 	}
 
 	pr_debug("AT %p s=%u %lu\n", tn, (unsigned int) sizeof(struct tnode),
@@ -489,7 +489,7 @@ static void tnode_put_child_reorg(struct
 	struct node *chi = tn->child[i];
 	int isfull;
 
-	BUG_ON(i >= 1<<tn->bits);
+	BUG_ON(i >= 1 << tn->bits);
 
 	/* update emptyChildren */
 	if (n == NULL && chi != NULL)
@@ -604,17 +604,16 @@ static struct node *resize(struct trie *
 
 	/* Keep root node larger  */
 
-	if (!node_parent((struct node*) tn)) {
+	if (!node_parent((struct node *) tn)) {
 		inflate_threshold_use = inflate_threshold_root;
 		halve_threshold_use = halve_threshold_root;
-	}
-	else {
+	} else {
 		inflate_threshold_use = inflate_threshold;
 		halve_threshold_use = halve_threshold;
 	}
 
 	max_work = MAX_WORK;
-	while ((tn->full_children > 0 &&  max_work-- &&
+	while ((tn->full_children > 0 && max_work-- &&
 		50 * (tn->full_children + tnode_child_length(tn)
 		      - tn->empty_children)
 		>= inflate_threshold_use * tnode_child_length(tn))) {
@@ -634,7 +633,7 @@ static struct node *resize(struct trie *
 	check_tnode(tn);
 
 	/* Return if at least one inflate is run */
-	if( max_work != MAX_WORK)
+	if (max_work != MAX_WORK)
 		return (struct node *) tn;
 
 	/*
@@ -643,7 +642,7 @@ static struct node *resize(struct trie *
 	 */
 
 	max_work = MAX_WORK;
-	while (tn->bits > 1 &&  max_work-- &&
+	while (tn->bits > 1 && max_work-- &&
 	       100 * (tnode_child_length(tn) - tn->empty_children) <
 	       halve_threshold_use * tnode_child_length(tn)) {
 
@@ -710,12 +709,12 @@ static struct tnode *inflate(struct trie
 			struct tnode *left, *right;
 			t_key m = ~0U << (KEYLENGTH - 1) >> inode->pos;
 
-			left = tnode_new(inode->key&(~m), inode->pos + 1,
+			left = tnode_new(inode->key & (~m), inode->pos + 1,
 					 inode->bits - 1);
 			if (!left)
 				goto nomem;
 
-			right = tnode_new(inode->key|m, inode->pos + 1,
+			right = tnode_new(inode->key | m, inode->pos + 1,
 					  inode->bits - 1);
 
 			if (!right) {
@@ -723,8 +722,8 @@ static struct tnode *inflate(struct trie
 				goto nomem;
 			}
 
-			put_child(t, tn, 2*i, (struct node *) left);
-			put_child(t, tn, 2*i+1, (struct node *) right);
+			put_child(t, tn, 2 * i, (struct node *) left);
+			put_child(t, tn, 2 * i + 1, (struct node *) right);
 		}
 	}
 
@@ -745,9 +744,9 @@ static struct tnode *inflate(struct trie
 			if (tkey_extract_bits(node->key,
 					      oldtnode->pos + oldtnode->bits,
 					      1) == 0)
-				put_child(t, tn, 2*i, node);
+				put_child(t, tn, 2 * i, node);
 			else
-				put_child(t, tn, 2*i+1, node);
+				put_child(t, tn, 2 * i + 1, node);
 			continue;
 		}
 
@@ -755,8 +754,8 @@ static struct tnode *inflate(struct trie
 		inode = (struct tnode *) node;
 
 		if (inode->bits == 1) {
-			put_child(t, tn, 2*i, inode->child[0]);
-			put_child(t, tn, 2*i+1, inode->child[1]);
+			put_child(t, tn, 2 * i, inode->child[0]);
+			put_child(t, tn, 2 * i + 1, inode->child[1]);
 
 			tnode_free_safe(inode);
 			continue;
@@ -785,13 +784,13 @@ static struct tnode *inflate(struct trie
 		 *   bit to zero.
 		 */
 
-		left = (struct tnode *) tnode_get_child(tn, 2*i);
-		put_child(t, tn, 2*i, NULL);
+		left = (struct tnode *) tnode_get_child(tn, 2 * i);
+		put_child(t, tn, 2 * i, NULL);
 
 		BUG_ON(!left);
 
-		right = (struct tnode *) tnode_get_child(tn, 2*i+1);
-		put_child(t, tn, 2*i+1, NULL);
+		right = (struct tnode *) tnode_get_child(tn, 2 * i + 1);
+		put_child(t, tn, 2 * i + 1, NULL);
 
 		BUG_ON(!right);
 
@@ -800,8 +799,8 @@ static struct tnode *inflate(struct trie
 			put_child(t, left, j, inode->child[j]);
 			put_child(t, right, j, inode->child[j + size]);
 		}
-		put_child(t, tn, 2*i, resize(t, left));
-		put_child(t, tn, 2*i+1, resize(t, right));
+		put_child(t, tn, 2 * i, resize(t, left));
+		put_child(t, tn, 2 * i + 1, resize(t, right));
 
 		tnode_free_safe(inode);
 	}
@@ -845,7 +844,7 @@ static struct tnode *halve(struct trie *
 
 	for (i = 0; i < olen; i += 2) {
 		left = tnode_get_child(oldtnode, i);
-		right = tnode_get_child(oldtnode, i+1);
+		right = tnode_get_child(oldtnode, i + 1);
 
 		/* Two nonempty children */
 		if (left && right) {
@@ -856,7 +855,7 @@ static struct tnode *halve(struct trie *
 			if (!newn)
 				goto nomem;
 
-			put_child(t, tn, i/2, (struct node *)newn);
+			put_child(t, tn, i / 2, (struct node *)newn);
 		}
 
 	}
@@ -865,27 +864,27 @@ static struct tnode *halve(struct trie *
 		struct tnode *newBinNode;
 
 		left = tnode_get_child(oldtnode, i);
-		right = tnode_get_child(oldtnode, i+1);
+		right = tnode_get_child(oldtnode, i + 1);
 
 		/* At least one of the children is empty */
 		if (left == NULL) {
 			if (right == NULL)    /* Both are empty */
 				continue;
-			put_child(t, tn, i/2, right);
+			put_child(t, tn, i / 2, right);
 			continue;
 		}
 
 		if (right == NULL) {
-			put_child(t, tn, i/2, left);
+			put_child(t, tn, i / 2, left);
 			continue;
 		}
 
 		/* Two nonempty children */
-		newBinNode = (struct tnode *) tnode_get_child(tn, i/2);
-		put_child(t, tn, i/2, NULL);
+		newBinNode = (struct tnode *) tnode_get_child(tn, i / 2);
+		put_child(t, tn, i / 2, NULL);
 		put_child(t, newBinNode, 0, left);
 		put_child(t, newBinNode, 1, right);
-		put_child(t, tn, i/2, resize(t, newBinNode));
+		put_child(t, tn, i / 2, resize(t, newBinNode));
 	}
 	tnode_free_safe(oldtnode);
 	return tn;
@@ -1147,7 +1146,7 @@ static struct list_head *fib_insert_node
 
 		missbit = tkey_extract_bits(key, newpos, 1);
 		put_child(t, tn, missbit, (struct node *)l);
-		put_child(t, tn, 1-missbit, n);
+		put_child(t, tn, 1 - missbit, n);
 
 		if (tp) {
 			cindex = tkey_extract_bits(key, tp->pos, tp->bits);
@@ -1324,8 +1323,7 @@ static int fn_trie_insert(struct fib_tab
 		}
 	}
 
-	list_add_tail_rcu(&new_fa->fa_list,
-			  (fa ? &fa->fa_list : fa_head));
+	list_add_tail_rcu(&new_fa->fa_list, (fa ? &fa->fa_list : fa_head));
 
 	rt_cache_flush(cfg->fc_nlinfo.nl_net, -1);
 	rtmsg_fib(RTM_NEWROUTE, htonl(key), new_fa, plen, tb->tb_id,
@@ -1463,9 +1461,9 @@ static int fn_trie_lookup(struct fib_tab
 		/* NOTA BENE: Checking only skipped bits
 		   for the new node here */
 
-		if (current_prefix_length < pos+bits) {
+		if (current_prefix_length < pos + bits) {
 			if (tkey_extract_bits(cn->key, current_prefix_length,
-						cn->pos - current_prefix_length)
+					      cn->pos - current_prefix_length)
 			    || !(cn->child[0]))
 				goto backtrace;
 		}
@@ -1504,7 +1502,7 @@ static int fn_trie_lookup(struct fib_tab
 
 		node_prefix = mask_pfx(cn->key, cn->pos);
 		key_prefix = mask_pfx(key, cn->pos);
-		pref_mismatch = key_prefix^node_prefix;
+		pref_mismatch = key_prefix ^ node_prefix;
 		mp = 0;
 
 		/*
@@ -1513,11 +1511,12 @@ static int fn_trie_lookup(struct fib_tab
 		 * state.directly.
 		 */
 		if (pref_mismatch) {
-			while (!(pref_mismatch & (1<<(KEYLENGTH-1)))) {
+			while (!(pref_mismatch & (1 << (KEYLENGTH - 1)))) {
 				mp++;
 				pref_mismatch = pref_mismatch << 1;
 			}
-			key_prefix = tkey_extract_bits(cn->key, mp, cn->pos-mp);
+			key_prefix = tkey_extract_bits(cn->key, mp,
+						       cn->pos - mp);
 
 			if (key_prefix != 0)
 				goto backtrace;
@@ -1526,7 +1525,7 @@ static int fn_trie_lookup(struct fib_tab
 				current_prefix_length = mp;
 		}
 
-		pn = (struct tnode *)n; /* Descend */
+		pn = (struct tnode *) n; /* Descend */
 		chopped_off = 0;
 		continue;
 
@@ -1535,7 +1534,7 @@ backtrace:
 
 		/* As zero don't change the child key (cindex) */
 		while ((chopped_off <= pn->bits)
-		       && !(cindex & (1<<(chopped_off-1))))
+		       && !(cindex & (1 << (chopped_off - 1))))
 			chopped_off++;
 
 		/* Decrease current_... with bits chopped off */
@@ -1549,7 +1548,7 @@ backtrace:
 		 */
 
 		if (chopped_off <= pn->bits) {
-			cindex &= ~(1 << (chopped_off-1));
+			cindex &= ~(1 << (chopped_off - 1));
 		} else {
 			struct tnode *parent = node_parent_rcu((struct node *) pn);
 			if (!parent)
@@ -1868,7 +1867,7 @@ static void fn_trie_select_default(struc
 	}
 
 	if (!fib_detect_death(fi, order, &last_resort, &last_idx,
-				tb->tb_default)) {
+			      tb->tb_default)) {
 		fib_result_assign(res, fi);
 		tb->tb_default = order;
 		goto out;
@@ -1986,7 +1985,7 @@ static int fn_trie_dump(struct fib_table
 		++count;
 		l = trie_nextleaf(l);
 		memset(&cb->args[4], 0,
-		       sizeof(cb->args) - 4*sizeof(cb->args[0]));
+		       sizeof(cb->args) - 4 * sizeof(cb->args[0]));
 	}
 	cb->args[3] = count;
 	rcu_read_unlock();
@@ -2059,7 +2058,7 @@ static struct node *fib_trie_get_next(st
 	pr_debug("get_next iter={node=%p index=%d depth=%d}\n",
 		 iter->tnode, iter->index, iter->depth);
 rescan:
-	while (cindex < (1<<tn->bits)) {
+	while (cindex < (1 << tn->bits)) {
 		struct node *n = tnode_get_child_rcu(tn, cindex);
 
 		if (n) {
@@ -2145,7 +2144,7 @@ static void trie_collect_stats(struct tr
 			if (tn->bits < MAX_STAT_DEPTH)
 				s->nodesizes[tn->bits]++;
 
-			for (i = 0; i < (1<<tn->bits); i++)
+			for (i = 0; i < (1 << tn->bits); i++)
 				if (!tn->child[i])
 					s->nullpointers++;
 		}
@@ -2161,7 +2160,7 @@ static void trie_show_stats(struct seq_f
 	unsigned i, max, pointers, bytes, avdepth;
 
 	if (stat->leaves)
-		avdepth = stat->totdepth*100 / stat->leaves;
+		avdepth = stat->totdepth * 100 / stat->leaves;
 	else
 		avdepth = 0;
 
@@ -2179,14 +2178,14 @@ static void trie_show_stats(struct seq_f
 	bytes += sizeof(struct tnode) * stat->tnodes;
 
 	max = MAX_STAT_DEPTH;
-	while (max > 0 && stat->nodesizes[max-1] == 0)
+	while (max > 0 && stat->nodesizes[max - 1] == 0)
 		max--;
 
 	pointers = 0;
 	for (i = 1; i <= max; i++)
 		if (stat->nodesizes[i] != 0) {
 			seq_printf(seq, "  %u: %u",  i, stat->nodesizes[i]);
-			pointers += (1<<i) * stat->nodesizes[i];
+			pointers += (1 << i) * stat->nodesizes[i];
 		}
 	seq_putc(seq, '\n');
 	seq_printf(seq, "\tPointers: %u\n", pointers);
@@ -2355,7 +2354,8 @@ static void fib_trie_seq_stop(struct seq
 
 static void seq_indent(struct seq_file *seq, int n)
 {
-	while (n-- > 0) seq_puts(seq, "   ");
+	while (n-- > 0)
+		seq_puts(seq, "   ");
 }
 
 static inline const char *rtn_scope(char *buf, size_t len, enum rt_scope_t s)
@@ -2408,7 +2408,7 @@ static int fib_trie_seq_show(struct seq_
 		struct tnode *tn = (struct tnode *) n;
 		__be32 prf = htonl(mask_pfx(tn->key, tn->pos));
 
-		seq_indent(seq, iter->depth-1);
+		seq_indent(seq, iter->depth - 1);
 		seq_printf(seq, "  +-- %pI4/%d %d %d %d\n",
 			   &prf, tn->pos, tn->bits, tn->full_children,
 			   tn->empty_children);
@@ -2428,7 +2428,7 @@ static int fib_trie_seq_show(struct seq_
 			list_for_each_entry_rcu(fa, &li->falh, fa_list) {
 				char buf1[32], buf2[32];
 
-				seq_indent(seq, iter->depth+1);
+				seq_indent(seq, iter->depth + 1);
 				seq_printf(seq, "  /%d %s %s", li->plen,
 					   rtn_scope(buf1, sizeof(buf1),
 						     fa->fa_scope),
@@ -2546,7 +2546,8 @@ static void fib_route_seq_stop(struct se
 static unsigned fib_flag_trans(int type, __be32 mask, const struct fib_info *fi)
 {
 	static unsigned type2flags[RTN_MAX + 1] = {
-		[7] = RTF_REJECT, [8] = RTF_REJECT,
+		[7] = RTF_REJECT,
+		[8] = RTF_REJECT,
 	};
 	unsigned flags = type2flags[type];
 
@@ -2561,7 +2562,7 @@ static unsigned fib_flag_trans(int type,
 /*
  *	This outputs /proc/net/route.
  *	The format of the file is not supposed to be changed
- * 	and needs to be same as fib_hash output to avoid breaking
+ *	and needs to be same as fib_hash output to avoid breaking
  *	legacy utilities
  */
 static int fib_route_seq_show(struct seq_file *seq, void *v)

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
