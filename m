Return-Path: <linux-kernel-owner+w=401wt.eu-S1765382AbYBMA5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765382AbYBMA5i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 19:57:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756849AbYBMA5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 19:57:18 -0500
Received: from mail.vyatta.com ([216.93.170.194]:39675 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754364AbYBMA5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 19:57:14 -0500
X-Quarantine-ID: <TxJiF5V99slQ>
X-Amavis-Alert: BAD HEADER, Duplicate header field: "To"
X-Spam-Flag: NO
X-Spam-Score: -2.499
Message-Id: <20080213005122.879352336@vyatta.com>
References: <20080213005042.150212716@vyatta.com>
User-Agent: quilt/0.46-1
Date: Tue, 12 Feb 2008 16:50:46 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: David Miller <davem@davemloft.net>
To: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] hlist_for_each_entry_continue simplification
Content-Disposition: inline; filename=rcu-continue.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the users of hlist_for_each_entry_continue had to intialize pos
before use; change API so pos is a pure temporary variable which matches
the usage of other xxxx_for_each_entry routines.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

--- a/include/linux/list.h	2008-02-12 15:09:17.000000000 -0800
+++ b/include/linux/list.h	2008-02-12 15:09:53.000000000 -0800
@@ -944,7 +944,7 @@ static inline void hlist_add_after_rcu(s
  * @member:	the name of the hlist_node within the struct.
  */
 #define hlist_for_each_entry_continue(tpos, pos, member)		 \
-	for (pos = (pos)->next;						 \
+	for (pos = (tpos)->member.next;					 \
 	     pos && ({ prefetch(pos->next); 1;}) &&			 \
 		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
 	     pos = pos->next)
@@ -999,7 +999,7 @@ static inline void hlist_add_after_rcu(s
  * @member:	the name of the hlist_node within the struct.
  */
 #define hlist_for_each_entry_continue_rcu(tpos, pos, member)		\
-	for (pos = (pos)->next;						\
+	for (pos = (tpos)->member.next;					\
 	     rcu_dereference(pos) && ({ prefetch(pos->next); 1;}) &&	\
 		     ({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
 	     pos = pos->next)
--- a/include/net/sock.h	2008-02-12 15:09:17.000000000 -0800
+++ b/include/net/sock.h	2008-02-12 15:09:53.000000000 -0800
@@ -381,7 +381,7 @@ static __inline__ void sk_add_bind_node(
 	if (__sk && ({ node = &(__sk)->sk_node; 1; })) \
 		hlist_for_each_entry_from(__sk, node, sk_node)
 #define sk_for_each_continue(__sk, node) \
-	if (__sk && ({ node = &(__sk)->sk_node; 1; })) \
+	if (__sk) \
 		hlist_for_each_entry_continue(__sk, node, sk_node)
 #define sk_for_each_safe(__sk, node, tmp, list) \
 	hlist_for_each_entry_safe(__sk, node, tmp, list, sk_node)
--- a/net/ipv4/fib_hash.c	2008-02-12 15:09:17.000000000 -0800
+++ b/net/ipv4/fib_hash.c	2008-02-12 15:09:53.000000000 -0800
@@ -883,7 +883,7 @@ static struct fib_alias *fib_get_next(st
 
 	/* Advance FN. */
 	if (fn) {
-		struct hlist_node *node = &fn->fn_hash;
+		struct hlist_node *node;
 		hlist_for_each_entry_continue(fn, node, fn_hash) {
 			iter->fn = fn;
 
--- a/net/xfrm/xfrm_policy.c	2008-02-12 15:09:17.000000000 -0800
+++ b/net/xfrm/xfrm_policy.c	2008-02-12 15:09:53.000000000 -0800
@@ -577,7 +577,7 @@ int xfrm_policy_insert(int dir, struct x
 
 	read_lock_bh(&xfrm_policy_lock);
 	gc_list = NULL;
-	entry = &policy->bydst;
+
 	hlist_for_each_entry_continue(policy, entry, bydst) {
 		struct dst_entry *dst;
 
--- a/net/ipv4/fib_trie.c	2008-02-12 15:09:46.000000000 -0800
+++ b/net/ipv4/fib_trie.c	2008-02-12 15:12:21.000000000 -0800
@@ -2333,7 +2333,6 @@ static void *fib_trie_seq_next(struct se
 
 	/* walk rest of this hash chain */
 	h = tb->tb_id & (FIB_TABLE_HASHSZ - 1);
-	tb_node = &tb->tb_hlist;
 	hlist_for_each_entry_continue_rcu(tb, tb_node, tb_hlist) {
 		n = trie_get_first(iter, tb);
 		if (n)

-- 
Stephen Hemminger <shemminger@vyatta.com>

