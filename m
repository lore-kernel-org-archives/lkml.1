Return-Path: <linux-kernel-owner+w=401wt.eu-S1752731AbZGAIs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbZGAIs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 04:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750917AbZGAIsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 04:48:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:42124 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbZGAIsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 04:48:17 -0400
Date: Wed, 1 Jul 2009 08:46:43 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, anton@samba.org,
       paulus@samba.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, anton@samba.org,
       acme@redhat.com, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1246419315-9968-4-git-send-email-fweisbec@gmail.com>
References: <1246419315-9968-4-git-send-email-fweisbec@gmail.com>
Subject: [tip:perfcounters/urgent] perf_counter tools: Various fixes for callchains
Message-ID: <tip-deac911cbdcb124fa0cee47c588e0cb0400b23b7@git.kernel.org>
Git-Commit-ID: deac911cbdcb124fa0cee47c588e0cb0400b23b7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Jul 2009 08:46:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  deac911cbdcb124fa0cee47c588e0cb0400b23b7
Gitweb:     http://git.kernel.org/tip/deac911cbdcb124fa0cee47c588e0cb0400b23b7
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Wed, 1 Jul 2009 05:35:15 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 1 Jul 2009 09:58:52 +0200

perf_counter tools: Various fixes for callchains

The symbol resolving has of course revealed some bugs in the
callchain tree handling. This patch fixes some of them,
including:

- inherit the children from the parents while splitting a node
- fix list range moving
- fix indexes setting in callchains
- create a child on the current node if the path doesn't match in
  the existent children (was only done on the root)
- compare using symbols when possible so that we can match a function
  using any ip inside by referring to its start address.

The practical effects are:

- remove double callchains
- fix upside down or any random order of callchains
- fix wrong paths
- fix bad hits and percentage accounts

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Anton Blanchard <anton@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1246419315-9968-4-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/util/callchain.c |  122 +++++++++++++++++++++++++++++++-----------
 1 files changed, 90 insertions(+), 32 deletions(-)

diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 6568cb1..440db12 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -4,6 +4,9 @@
  * Handle the callchains from the stream in an ad-hoc radix tree and then
  * sort them in an rbtree.
  *
+ * Using a radix for code path provides a fast retrieval and factorizes
+ * memory use. Also that lets us use the paths in a hierarchical graph view.
+ *
  */
 
 #include <stdlib.h>
@@ -14,7 +17,8 @@
 #include "callchain.h"
 
 
-static void rb_insert_callchain(struct rb_root *root, struct callchain_node *chain)
+static void
+rb_insert_callchain(struct rb_root *root, struct callchain_node *chain)
 {
 	struct rb_node **p = &root->rb_node;
 	struct rb_node *parent = NULL;
@@ -49,7 +53,12 @@ void sort_chain_to_rbtree(struct rb_root *rb_root, struct callchain_node *node)
 		rb_insert_callchain(rb_root, node);
 }
 
-static struct callchain_node *create_child(struct callchain_node *parent)
+/*
+ * Create a child for a parent. If inherit_children, then the new child
+ * will become the new parent of it's parent children
+ */
+static struct callchain_node *
+create_child(struct callchain_node *parent, bool inherit_children)
 {
 	struct callchain_node *new;
 
@@ -61,14 +70,27 @@ static struct callchain_node *create_child(struct callchain_node *parent)
 	new->parent = parent;
 	INIT_LIST_HEAD(&new->children);
 	INIT_LIST_HEAD(&new->val);
+
+	if (inherit_children) {
+		struct callchain_node *next;
+
+		list_splice(&parent->children, &new->children);
+		INIT_LIST_HEAD(&parent->children);
+
+		list_for_each_entry(next, &new->children, brothers)
+			next->parent = new;
+	}
 	list_add_tail(&new->brothers, &parent->children);
 
 	return new;
 }
 
+/*
+ * Fill the node with callchain values
+ */
 static void
-fill_node(struct callchain_node *node, struct ip_callchain *chain, int start,
-	  struct symbol **syms)
+fill_node(struct callchain_node *node, struct ip_callchain *chain,
+	  int start, struct symbol **syms)
 {
 	int i;
 
@@ -84,54 +106,80 @@ fill_node(struct callchain_node *node, struct ip_callchain *chain, int start,
 		call->sym = syms[i];
 		list_add_tail(&call->list, &node->val);
 	}
-	node->val_nr = i - start;
+	node->val_nr = chain->nr - start;
+	if (!node->val_nr)
+		printf("Warning: empty node in callchain tree\n");
 }
 
-static void add_child(struct callchain_node *parent, struct ip_callchain *chain,
-		      struct symbol **syms)
+static void
+add_child(struct callchain_node *parent, struct ip_callchain *chain,
+	  int start, struct symbol **syms)
 {
 	struct callchain_node *new;
 
-	new = create_child(parent);
-	fill_node(new, chain, parent->val_nr, syms);
+	new = create_child(parent, false);
+	fill_node(new, chain, start, syms);
 
 	new->hit = 1;
 }
 
+/*
+ * Split the parent in two parts (a new child is created) and
+ * give a part of its callchain to the created child.
+ * Then create another child to host the given callchain of new branch
+ */
 static void
 split_add_child(struct callchain_node *parent, struct ip_callchain *chain,
-		struct callchain_list *to_split, int idx, struct symbol **syms)
+		struct callchain_list *to_split, int idx_parents, int idx_local,
+		struct symbol **syms)
 {
 	struct callchain_node *new;
+	struct list_head *old_tail;
+	int idx_total = idx_parents + idx_local;
 
 	/* split */
-	new = create_child(parent);
-	list_move_tail(&to_split->list, &new->val);
-	new->hit = parent->hit;
-	parent->hit = 0;
-	parent->val_nr = idx;
+	new = create_child(parent, true);
+
+	/* split the callchain and move a part to the new child */
+	old_tail = parent->val.prev;
+	list_del_range(&to_split->list, old_tail);
+	new->val.next = &to_split->list;
+	new->val.prev = old_tail;
+	to_split->list.prev = &new->val;
+	old_tail->next = &new->val;
 
-	/* create the new one */
-	add_child(parent, chain, syms);
+	/* split the hits */
+	new->hit = parent->hit;
+	new->val_nr = parent->val_nr - idx_local;
+	parent->val_nr = idx_local;
+
+	/* create a new child for the new branch if any */
+	if (idx_total < chain->nr) {
+		parent->hit = 0;
+		add_child(parent, chain, idx_total, syms);
+	} else {
+		parent->hit = 1;
+	}
 }
 
 static int
 __append_chain(struct callchain_node *root, struct ip_callchain *chain,
 	       int start, struct symbol **syms);
 
-static int
+static void
 __append_chain_children(struct callchain_node *root, struct ip_callchain *chain,
-			struct symbol **syms)
+			struct symbol **syms, int start)
 {
 	struct callchain_node *rnode;
 
 	/* lookup in childrens */
 	list_for_each_entry(rnode, &root->children, brothers) {
-		int ret = __append_chain(rnode, chain, root->val_nr, syms);
+		int ret = __append_chain(rnode, chain, start, syms);
 		if (!ret)
-			return 0;
+			return;
 	}
-	return -1;
+	/* nothing in children, add to the current node */
+	add_child(root, chain, start, syms);
 }
 
 static int
@@ -142,14 +190,22 @@ __append_chain(struct callchain_node *root, struct ip_callchain *chain,
 	int i = start;
 	bool found = false;
 
-	/* lookup in the current node */
+	/*
+	 * Lookup in the current node
+	 * If we have a symbol, then compare the start to match
+	 * anywhere inside a function.
+	 */
 	list_for_each_entry(cnode, &root->val, list) {
-		if (cnode->ip != chain->ips[i++])
+		if (i == chain->nr)
+			break;
+		if (cnode->sym && syms[i]) {
+			if (cnode->sym->start != syms[i]->start)
+				break;
+		} else if (cnode->ip != chain->ips[i])
 			break;
 		if (!found)
 			found = true;
-		if (i == chain->nr)
-			break;
+		i++;
 	}
 
 	/* matches not, relay on the parent */
@@ -157,23 +213,25 @@ __append_chain(struct callchain_node *root, struct ip_callchain *chain,
 		return -1;
 
 	/* we match only a part of the node. Split it and add the new chain */
-	if (i < root->val_nr) {
-		split_add_child(root, chain, cnode, i, syms);
+	if (i - start < root->val_nr) {
+		split_add_child(root, chain, cnode, start, i - start, syms);
 		return 0;
 	}
 
 	/* we match 100% of the path, increment the hit */
-	if (i == root->val_nr) {
+	if (i - start == root->val_nr && i == chain->nr) {
 		root->hit++;
 		return 0;
 	}
 
-	return __append_chain_children(root, chain, syms);
+	/* We match the node and still have a part remaining */
+	__append_chain_children(root, chain, syms, i);
+
+	return 0;
 }
 
 void append_chain(struct callchain_node *root, struct ip_callchain *chain,
 		  struct symbol **syms)
 {
-	if (__append_chain_children(root, chain, syms) == -1)
-		add_child(root, chain, syms);
+	__append_chain_children(root, chain, syms, 0);
 }
