Return-Path: <linux-kernel-owner+w=401wt.eu-S1765740AbYBMBD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765740AbYBMBD4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 20:03:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756983AbYBMBCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 20:02:17 -0500
Received: from mail.vyatta.com ([216.93.170.194]:39826 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753524AbYBMBCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 20:02:10 -0500
X-Spam-Flag: NO
X-Spam-Score: -2.499
Message-Id: <20080213005122.805195833@vyatta.com>
References: <20080213005042.150212716@vyatta.com>
User-Agent: quilt/0.46-1
Date: Tue, 12 Feb 2008 16:50:45 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] fib_trie: print statistics for multiple tables
Content-Disposition: inline; filename=fib-trie-tables.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make /proc/net/fib_trie and /proc/net/fib_triestat handle
multiple (alternate) route tables. Need hliist_for_each_entry_continue_rcu
as well. 

Notes:
 * this usage of seq_file doesn't need/want SEQ_START_TOKEN
 * add hlist_for_each_entry_continue_rcu since it needs it

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
---
 include/linux/list.h |   13 ++++
 net/ipv4/fib_trie.c  |  186 ++++++++++++++++++++++++++++----------------------
 2 files changed, 117 insertions(+), 82 deletions(-)

--- a/include/linux/list.h	2008-02-12 14:46:49.000000000 -0800
+++ b/include/linux/list.h	2008-02-12 15:09:17.000000000 -0800
@@ -991,6 +991,19 @@ static inline void hlist_add_after_rcu(s
 		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
 	     pos = pos->next)
 
+
+/**
+ * hlist_for_each_entry_continue_rcu - iterate over rcu hlist after current point
+ * @tpos:	the type * to use as a loop cursor.
+ * @pos:	the &struct hlist_node to use as a loop cursor.
+ * @member:	the name of the hlist_node within the struct.
+ */
+#define hlist_for_each_entry_continue_rcu(tpos, pos, member)		\
+	for (pos = (pos)->next;						\
+	     rcu_dereference(pos) && ({ prefetch(pos->next); 1;}) &&	\
+		     ({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
+	     pos = pos->next)
+
 #else
 #warning "don't include kernel headers in userspace"
 #endif /* __KERNEL__ */
--- a/net/ipv4/fib_trie.c	2008-02-12 14:56:58.000000000 -0800
+++ b/net/ipv4/fib_trie.c	2008-02-12 15:09:46.000000000 -0800
@@ -2026,14 +2026,13 @@ struct fib_table *fib_hash_table(u32 id)
 /* Depth first Trie walk iterator */
 struct fib_trie_iter {
 	struct seq_net_private p;
-	struct trie *trie_local, *trie_main;
+	struct fib_table *tb;
 	struct tnode *tnode;
-	struct trie *trie;
 	unsigned index;
 	unsigned depth;
 };
 
-static struct node *fib_trie_get_next(struct fib_trie_iter *iter)
+static struct node *trie_get_next(struct fib_trie_iter *iter)
 {
 	struct tnode *tn = iter->tnode;
 	unsigned cindex = iter->index;
@@ -2078,37 +2077,33 @@ rescan:
 	return NULL;
 }
 
-static struct node *fib_trie_get_first(struct fib_trie_iter *iter,
-				       struct trie *t)
+static struct node *trie_get_first(struct fib_trie_iter *iter, struct fib_table *tb)
 {
-	struct node *n ;
+	struct trie *t = (struct trie *) tb->tb_data;
+	struct node *n;
 
+	iter->tb = tb;
 	if (!t)
 		return NULL;
 
 	n = rcu_dereference(t->trie);
-
-	if (!iter)
+	if (!n)
 		return NULL;
 
-	if (n) {
-		if (IS_TNODE(n)) {
-			iter->tnode = (struct tnode *) n;
-			iter->trie = t;
-			iter->index = 0;
-			iter->depth = 1;
-		} else {
-			iter->tnode = NULL;
-			iter->trie  = t;
-			iter->index = 0;
-			iter->depth = 0;
-		}
-		return n;
+	if (IS_TNODE(n)) {
+		iter->tnode = (struct tnode *) n;
+		iter->index = 0;
+		iter->depth = 1;
+	} else {
+		iter->tnode = NULL;
+		iter->index = 0;
+		iter->depth = 0;
 	}
-	return NULL;
+
+	return n;
 }
 
-static void trie_collect_stats(struct trie *t, struct trie_stat *s)
+static void trie_collect_stats(struct fib_table *tb, struct trie_stat *s)
 {
 	struct node *n;
 	struct fib_trie_iter iter;
@@ -2116,8 +2111,7 @@ static void trie_collect_stats(struct tr
 	memset(s, 0, sizeof(*s));
 
 	rcu_read_lock();
-	for (n = fib_trie_get_first(&iter, t); n;
-	     n = fib_trie_get_next(&iter)) {
+	for (n = trie_get_first(&iter, tb); n; n = trie_get_next(&iter)) {
 		if (IS_LEAF(n)) {
 			struct leaf *l = (struct leaf *)n;
 			struct leaf_info *li;
@@ -2206,36 +2200,53 @@ static void trie_show_usage(struct seq_f
 }
 #endif /*  CONFIG_IP_FIB_TRIE_STATS */
 
-static void fib_trie_show(struct seq_file *seq, const char *name,
-			  struct trie *trie)
+static void fib_table_print(struct seq_file *seq, struct fib_table *tb)
+{
+	if (tb->tb_id == RT_TABLE_LOCAL)
+		seq_puts(seq, "Local:\n");
+	else if (tb->tb_id == RT_TABLE_MAIN)
+		seq_puts(seq, "Main:\n");
+	else
+		seq_printf(seq, "Id %d:\n", tb->tb_id);
+}
+
+static void fib_trie_show(struct seq_file *seq, struct fib_table *tb)
 {
+	struct trie *t = (struct trie *) tb->tb_data;
 	struct trie_stat stat;
 
-	trie_collect_stats(trie, &stat);
-	seq_printf(seq, "%s:\n", name);
+	if (!t)
+		return;
+
+	fib_table_print(seq, tb);
+
+	trie_collect_stats(tb, &stat);
 	trie_show_stats(seq, &stat);
 #ifdef CONFIG_IP_FIB_TRIE_STATS
-	trie_show_usage(seq, &trie->stats);
+	trie_show_usage(seq, &t->stats);
 #endif
 }
 
 static int fib_triestat_seq_show(struct seq_file *seq, void *v)
 {
 	struct net *net = (struct net *)seq->private;
-	struct fib_table *tb;
+	unsigned int h;
 
 	seq_printf(seq,
 		   "Basic info: size of leaf:"
 		   " %Zd bytes, size of tnode: %Zd bytes.\n",
 		   sizeof(struct leaf), sizeof(struct tnode));
 
-	tb = fib_get_table(net, RT_TABLE_LOCAL);
-	if (tb)
-		fib_trie_show(seq, "Local", (struct trie *) tb->tb_data);
-
-	tb = fib_get_table(net, RT_TABLE_MAIN);
-	if (tb)
-		fib_trie_show(seq, "Main", (struct trie *) tb->tb_data);
+	for (h = 0; h < FIB_TABLE_HASHSZ; h++) {
+		struct hlist_head *head = &net->ipv4.fib_table_hash[h];
+		struct hlist_node *node;
+		struct fib_table *tb;
+
+		hlist_for_each_entry_rcu(tb, node, head, tb_hlist) {
+			fib_trie_show(seq, tb);
+
+		}
+	}
 
 	return 0;
 }
@@ -2271,23 +2282,29 @@ static const struct file_operations fib_
 	.release = fib_triestat_seq_release,
 };
 
-static struct node *fib_trie_get_idx(struct fib_trie_iter *iter,
-				      loff_t pos)
+static struct node *fib_trie_get_idx(struct fib_trie_iter *iter, loff_t pos)
 {
+	struct net *net = iter->p.net;
 	loff_t idx = 0;
-	struct node *n;
+	unsigned int h;
 
-	for (n = fib_trie_get_first(iter, iter->trie_local);
-	     n; ++idx, n = fib_trie_get_next(iter)) {
-		if (pos == idx)
-			return n;
-	}
+	for (h = 0; h < FIB_TABLE_HASHSZ; h++) {
+		struct hlist_head *head = &net->ipv4.fib_table_hash[h];
+		struct hlist_node *node;
+		struct fib_table *tb;
 
-	for (n = fib_trie_get_first(iter, iter->trie_main);
-	     n; ++idx, n = fib_trie_get_next(iter)) {
-		if (pos == idx)
-			return n;
+		hlist_for_each_entry_rcu(tb, node, head, tb_hlist) {
+			struct node *n;
+
+			for (n = trie_get_first(iter, tb);
+			     n; n = trie_get_next(iter))
+				if (pos == idx++) {
+					iter->tb = tb;
+					return n;
+				}
+		}
 	}
+
 	return NULL;
 }
 
@@ -2295,43 +2312,49 @@ static void *fib_trie_seq_start(struct s
 	__acquires(RCU)
 {
 	struct fib_trie_iter *iter = seq->private;
-	struct fib_table *tb;
 
-	if (!iter->trie_local) {
-		tb = fib_get_table(iter->p.net, RT_TABLE_LOCAL);
-		if (tb)
-			iter->trie_local = (struct trie *) tb->tb_data;
-	}
-	if (!iter->trie_main) {
-		tb = fib_get_table(iter->p.net, RT_TABLE_MAIN);
-		if (tb)
-			iter->trie_main = (struct trie *) tb->tb_data;
-	}
 	rcu_read_lock();
-	if (*pos == 0)
-		return SEQ_START_TOKEN;
-	return fib_trie_get_idx(iter, *pos - 1);
+	return fib_trie_get_idx(iter, *pos);
 }
 
 static void *fib_trie_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
 	struct fib_trie_iter *iter = seq->private;
-	void *l = v;
+	struct net *net = iter->p.net;
+	struct fib_table *tb = iter->tb;
+	struct hlist_node *tb_node;
+	unsigned int h;
+	struct node *n;
 
 	++*pos;
-	if (v == SEQ_START_TOKEN)
-		return fib_trie_get_idx(iter, 0);
+	n = trie_get_next(iter);
+	if (n)
+		return n;
 
-	v = fib_trie_get_next(iter);
-	BUG_ON(v == l);
-	if (v)
-		return v;
-
-	/* continue scan in next trie */
-	if (iter->trie == iter->trie_local)
-		return fib_trie_get_first(iter, iter->trie_main);
+	/* walk rest of this hash chain */
+	h = tb->tb_id & (FIB_TABLE_HASHSZ - 1);
+	tb_node = &tb->tb_hlist;
+	hlist_for_each_entry_continue_rcu(tb, tb_node, tb_hlist) {
+		n = trie_get_first(iter, tb);
+		if (n)
+			goto found;
+	}
+
+	/* new hash chain */
+	while (++h < FIB_TABLE_HASHSZ) {
+		struct hlist_head *head = &net->ipv4.fib_table_hash[h];
+		hlist_for_each_entry_rcu(tb, tb_node, head, tb_hlist) {
+			n = trie_get_first(iter, tb);
+			if (n)
+				goto found;
+		}
+	}
 
 	return NULL;
+
+found:
+	iter->tb = tb;
+	return n;
 }
 
 static void fib_trie_seq_stop(struct seq_file *seq, void *v)
@@ -2399,15 +2422,8 @@ static int fib_trie_seq_show(struct seq_
 	const struct fib_trie_iter *iter = seq->private;
 	struct node *n = v;
 
-	if (v == SEQ_START_TOKEN)
-		return 0;
-
-	if (!node_parent_rcu(n)) {
-		if (iter->trie == iter->trie_local)
-			seq_puts(seq, "<local>:\n");
-		else
-			seq_puts(seq, "<main>:\n");
-	}
+	if (!node_parent_rcu(n))
+		fib_table_print(seq, iter->tb);
 
 	if (IS_TNODE(n)) {
 		struct tnode *tn = (struct tnode *) n;

-- 
Stephen Hemminger <shemminger@vyatta.com>

