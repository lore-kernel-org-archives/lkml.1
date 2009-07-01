Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbZGAItU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbZGAItU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 04:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbZGAItD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 04:49:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:42150 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138AbZGAItB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 04:49:01 -0400
Date: Wed, 1 Jul 2009 08:46:31 GMT
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
In-Reply-To: <1246419315-9968-3-git-send-email-fweisbec@gmail.com>
References: <1246419315-9968-3-git-send-email-fweisbec@gmail.com>
Subject: [tip:perfcounters/urgent] perf_counter tools: Resolve symbols in callchains
Message-ID: <tip-4424961ad6621a02c6b4c9093e801002c1bb9f65@git.kernel.org>
Git-Commit-ID: 4424961ad6621a02c6b4c9093e801002c1bb9f65
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Jul 2009 08:46:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4424961ad6621a02c6b4c9093e801002c1bb9f65
Gitweb:     http://git.kernel.org/tip/4424961ad6621a02c6b4c9093e801002c1bb9f65
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Wed, 1 Jul 2009 05:35:14 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 1 Jul 2009 09:58:26 +0200

perf_counter tools: Resolve symbols in callchains

This patch resolves the names, when possible, of each ip
present in the callchains while using the -c option with perf
report.

Example:

5.40%  [k] __d_lookup
             5.37%
                perf_callchain
                perf_counter_overflow
                intel_pmu_handle_irq
                perf_counter_nmi_handler
                notifier_call_chain
                atomic_notifier_call_chain
                notify_die
                do_nmi
                nmi
                do_lookup
                __link_path_walk
                path_walk
                do_path_lookup
                user_path_at
                sys_faccessat
                sys_access
                system_call_fastpath
                0x7fb609846f77

             0.01%
                perf_callchain
                perf_counter_overflow
                intel_pmu_handle_irq
                perf_counter_nmi_handler
                notifier_call_chain
                atomic_notifier_call_chain
                notify_die
                do_nmi
                nmi
                do_lookup
                __link_path_walk
                path_walk
                do_path_lookup
                user_path_at
                sys_faccessat

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Anton Blanchard <anton@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1246419315-9968-3-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-report.c |  102 ++++++++++++++++++++++++++++---------------
 tools/perf/util/callchain.c |   33 ++++++++------
 tools/perf/util/callchain.h |    5 ++-
 3 files changed, 90 insertions(+), 50 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 3f5d8ea..1977930 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -794,8 +794,15 @@ callchain__fprintf(FILE *fp, struct callchain_node *self, u64 total_samples)
 	ret += callchain__fprintf(fp, self->parent, total_samples);
 
 
-	list_for_each_entry(chain, &self->val, list)
-		ret += fprintf(fp, "                %p\n", (void *)chain->ip);
+	list_for_each_entry(chain, &self->val, list) {
+		if (chain->ip >= PERF_CONTEXT_MAX)
+			continue;
+		if (chain->sym)
+			ret += fprintf(fp, "                %s\n", chain->sym->name);
+		else
+			ret += fprintf(fp, "                %p\n",
+					(void *)chain->ip);
+	}
 
 	return ret;
 }
@@ -930,6 +937,55 @@ static int call__match(struct symbol *sym)
 	return 0;
 }
 
+static struct symbol **
+resolve_callchain(struct thread *thread, struct map *map,
+		    struct ip_callchain *chain, struct hist_entry *entry)
+{
+	int i;
+	struct symbol **syms;
+	u64 context = PERF_CONTEXT_MAX;
+
+	if (callchain) {
+		syms = calloc(chain->nr, sizeof(*syms));
+		if (!syms) {
+			fprintf(stderr, "Can't allocate memory for symbols\n");
+			exit(-1);
+		}
+	}
+
+	for (i = 0; i < chain->nr; i++) {
+		u64 ip = chain->ips[i];
+		struct dso *dso = NULL;
+		struct symbol *sym;
+
+		if (ip >= PERF_CONTEXT_MAX) {
+			context = ip;
+			continue;
+		}
+
+		switch (context) {
+		case PERF_CONTEXT_KERNEL:
+			dso = kernel_dso;
+			break;
+		default:
+			break;
+		}
+
+		sym = resolve_symbol(thread, NULL, &dso, &ip);
+
+		if (sym) {
+			if (sort__has_parent && call__match(sym) &&
+			    !entry->parent)
+				entry->parent = sym;
+			if (!callchain)
+				break;
+			syms[i] = sym;
+		}
+	}
+
+	return syms;
+}
+
 /*
  * collect histogram counts
  */
@@ -942,6 +998,7 @@ hist_entry__add(struct thread *thread, struct map *map, struct dso *dso,
 	struct rb_node **p = &hist.rb_node;
 	struct rb_node *parent = NULL;
 	struct hist_entry *he;
+	struct symbol **syms = NULL;
 	struct hist_entry entry = {
 		.thread	= thread,
 		.map	= map,
@@ -955,39 +1012,11 @@ hist_entry__add(struct thread *thread, struct map *map, struct dso *dso,
 	};
 	int cmp;
 
-	if (sort__has_parent && chain) {
-		u64 context = PERF_CONTEXT_MAX;
-		int i;
-
-		for (i = 0; i < chain->nr; i++) {
-			u64 ip = chain->ips[i];
-			struct dso *dso = NULL;
-			struct symbol *sym;
-
-			if (ip >= PERF_CONTEXT_MAX) {
-				context = ip;
-				continue;
-			}
-
-			switch (context) {
 			case PERF_CONTEXT_HV:
 				dso = hypervisor_dso;
 				break;
-			case PERF_CONTEXT_KERNEL:
-				dso = kernel_dso;
-				break;
-			default:
-				break;
-			}
-
-			sym = resolve_symbol(thread, NULL, &dso, &ip);
-
-			if (sym && call__match(sym)) {
-				entry.parent = sym;
-				break;
-			}
-		}
-	}
+	if ((sort__has_parent || callchain) && chain)
+		syms = resolve_callchain(thread, map, chain, &entry);
 
 	while (*p != NULL) {
 		parent = *p;
@@ -997,8 +1026,10 @@ hist_entry__add(struct thread *thread, struct map *map, struct dso *dso,
 
 		if (!cmp) {
 			he->count += count;
-			if (callchain)
-				append_chain(&he->callchain, chain);
+			if (callchain) {
+				append_chain(&he->callchain, chain, syms);
+				free(syms);
+			}
 			return 0;
 		}
 
@@ -1014,7 +1045,8 @@ hist_entry__add(struct thread *thread, struct map *map, struct dso *dso,
 	*he = entry;
 	if (callchain) {
 		callchain_init(&he->callchain);
-		append_chain(&he->callchain, chain);
+		append_chain(&he->callchain, chain, syms);
+		free(syms);
 	}
 	rb_link_node(&he->rb_node, parent, p);
 	rb_insert_color(&he->rb_node, &hist);
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index bbf7813..6568cb1 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -67,7 +67,8 @@ static struct callchain_node *create_child(struct callchain_node *parent)
 }
 
 static void
-fill_node(struct callchain_node *node, struct ip_callchain *chain, int start)
+fill_node(struct callchain_node *node, struct ip_callchain *chain, int start,
+	  struct symbol **syms)
 {
 	int i;
 
@@ -80,24 +81,26 @@ fill_node(struct callchain_node *node, struct ip_callchain *chain, int start)
 			return;
 		}
 		call->ip = chain->ips[i];
+		call->sym = syms[i];
 		list_add_tail(&call->list, &node->val);
 	}
 	node->val_nr = i - start;
 }
 
-static void add_child(struct callchain_node *parent, struct ip_callchain *chain)
+static void add_child(struct callchain_node *parent, struct ip_callchain *chain,
+		      struct symbol **syms)
 {
 	struct callchain_node *new;
 
 	new = create_child(parent);
-	fill_node(new, chain, parent->val_nr);
+	fill_node(new, chain, parent->val_nr, syms);
 
 	new->hit = 1;
 }
 
 static void
 split_add_child(struct callchain_node *parent, struct ip_callchain *chain,
-		struct callchain_list *to_split, int idx)
+		struct callchain_list *to_split, int idx, struct symbol **syms)
 {
 	struct callchain_node *new;
 
@@ -109,21 +112,22 @@ split_add_child(struct callchain_node *parent, struct ip_callchain *chain,
 	parent->val_nr = idx;
 
 	/* create the new one */
-	add_child(parent, chain);
+	add_child(parent, chain, syms);
 }
 
 static int
 __append_chain(struct callchain_node *root, struct ip_callchain *chain,
-		int start);
+	       int start, struct symbol **syms);
 
 static int
-__append_chain_children(struct callchain_node *root, struct ip_callchain *chain)
+__append_chain_children(struct callchain_node *root, struct ip_callchain *chain,
+			struct symbol **syms)
 {
 	struct callchain_node *rnode;
 
 	/* lookup in childrens */
 	list_for_each_entry(rnode, &root->children, brothers) {
-		int ret = __append_chain(rnode, chain, root->val_nr);
+		int ret = __append_chain(rnode, chain, root->val_nr, syms);
 		if (!ret)
 			return 0;
 	}
@@ -132,7 +136,7 @@ __append_chain_children(struct callchain_node *root, struct ip_callchain *chain)
 
 static int
 __append_chain(struct callchain_node *root, struct ip_callchain *chain,
-		int start)
+	       int start, struct symbol **syms)
 {
 	struct callchain_list *cnode;
 	int i = start;
@@ -154,7 +158,7 @@ __append_chain(struct callchain_node *root, struct ip_callchain *chain,
 
 	/* we match only a part of the node. Split it and add the new chain */
 	if (i < root->val_nr) {
-		split_add_child(root, chain, cnode, i);
+		split_add_child(root, chain, cnode, i, syms);
 		return 0;
 	}
 
@@ -164,11 +168,12 @@ __append_chain(struct callchain_node *root, struct ip_callchain *chain,
 		return 0;
 	}
 
-	return __append_chain_children(root, chain);
+	return __append_chain_children(root, chain, syms);
 }
 
-void append_chain(struct callchain_node *root, struct ip_callchain *chain)
+void append_chain(struct callchain_node *root, struct ip_callchain *chain,
+		  struct symbol **syms)
 {
-	if (__append_chain_children(root, chain) == -1)
-		add_child(root, chain);
+	if (__append_chain_children(root, chain, syms) == -1)
+		add_child(root, chain, syms);
 }
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index fa1cd2f..c942daa 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -4,6 +4,7 @@
 #include "../perf.h"
 #include "list.h"
 #include "rbtree.h"
+#include "symbol.h"
 
 
 struct callchain_node {
@@ -18,6 +19,7 @@ struct callchain_node {
 
 struct callchain_list {
 	unsigned long		ip;
+	struct symbol		*sym;
 	struct list_head	list;
 };
 
@@ -28,6 +30,7 @@ static inline void callchain_init(struct callchain_node *node)
 	INIT_LIST_HEAD(&node->val);
 }
 
-void append_chain(struct callchain_node *root, struct ip_callchain *chain);
+void append_chain(struct callchain_node *root, struct ip_callchain *chain,
+		  struct symbol **syms);
 void sort_chain_to_rbtree(struct rb_root *rb_root, struct callchain_node *node);
 #endif
