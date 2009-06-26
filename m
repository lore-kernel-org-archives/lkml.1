Return-Path: <linux-kernel-owner+w=401wt.eu-S1760483AbZFZO22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760483AbZFZO22 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 10:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759086AbZFZO2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 10:28:07 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:45522 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbZFZO2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 10:28:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Y07nmwc+Nuk9N+ye6uKJoIUX+mTiaNvlfTEkMkGJ0GuVWzGXi9AhRok3MoVTLXVsg+
         E0olibiKbkZnXs1OhqhZxDuqT32yU2qVv9EO/KDXx2L2MPLFFxxfP3popCkbjBFey7jl
         MwPXaC3zwLrwT3D9Jp/f+syQK+Krz7zlGNfOE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/2] perfcounter: prepare a small callchain framework
Date: Fri, 26 Jun 2009 16:28:00 +0200
Message-Id: <1246026481-8314-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1246026481-8314-1-git-send-email-fweisbec@gmail.com>
References: <1246026481-8314-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We plan to display the callchains depending on some user-configurable
parameters.
To gather the callchains stats from the recorded stream in a fast way,
this patch introduces an ad hoc radix tree adapted for callchains and also
a rbtree to sort these callchains once we have gathered every events
from the stream.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/Makefile         |    1 +
 tools/perf/builtin-report.c |    5 -
 tools/perf/perf.h           |    5 +
 tools/perf/util/callchain.c |  174 +++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/callchain.h |   33 ++++++++
 5 files changed, 213 insertions(+), 5 deletions(-)
 create mode 100644 tools/perf/util/callchain.c
 create mode 100644 tools/perf/util/callchain.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index d3887ed..1c1296d 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -329,6 +329,7 @@ LIB_OBJS += util/symbol.o
 LIB_OBJS += util/color.o
 LIB_OBJS += util/pager.o
 LIB_OBJS += util/header.o
+LIB_OBJS += util/callchain.o
 
 BUILTIN_OBJS += builtin-annotate.o
 BUILTIN_OBJS += builtin-help.o
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 681c223..28d1cb2 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -62,11 +62,6 @@ struct ip_event {
 	unsigned char __more_data[];
 };
 
-struct ip_callchain {
-	u64 nr;
-	u64 ips[0];
-};
-
 struct mmap_event {
 	struct perf_event_header header;
 	u32 pid, tid;
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 0f32a2e..ce39419 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -72,4 +72,9 @@ sys_perf_counter_open(struct perf_counter_attr *attr,
 #define MAX_COUNTERS			256
 #define MAX_NR_CPUS			256
 
+struct ip_callchain {
+	u64 nr;
+	u64 ips[0];
+};
+
 #endif
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
new file mode 100644
index 0000000..ad3c285
--- /dev/null
+++ b/tools/perf/util/callchain.c
@@ -0,0 +1,174 @@
+/*
+ * Copyright (C) 2009, Frederic Weisbecker <fweisbec@gmail.com>
+ *
+ * Handle the callchains from the stream in an ad-hoc radix tree and then
+ * sort them in an rbtree.
+ *
+ */
+
+#include <stdlib.h>
+#include <stdio.h>
+#include <stdbool.h>
+#include <errno.h>
+
+#include "callchain.h"
+
+
+static void rb_insert_callchain(struct rb_root *root, struct callchain_node *chain)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	struct callchain_node *rnode;
+
+	while (*p) {
+		parent = *p;
+		rnode = rb_entry(parent, struct callchain_node, rb_node);
+
+		if (rnode->hit < chain->hit)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+
+	rb_link_node(&chain->rb_node, parent, p);
+	rb_insert_color(&chain->rb_node, root);
+}
+
+/*
+ * Once we get every callchains from the stream, we can now
+ * sort them by hit
+ */
+void sort_chain_to_rbtree(struct rb_root *rb_root, struct callchain_node *node)
+{
+	struct callchain_node *child;
+
+	list_for_each_entry(child, &node->children, brothers)
+		sort_chain_to_rbtree(rb_root, child);
+
+	if (node->hit)
+		rb_insert_callchain(rb_root, node);
+}
+
+static struct callchain_node *create_child(struct callchain_node *parent)
+{
+	struct callchain_node *new;
+
+	new = malloc(sizeof(*new));
+	if (!new) {
+		perror("not enough memory to create child for code path tree");
+		return NULL;
+	}
+	new->parent = parent;
+	INIT_LIST_HEAD(&new->children);
+	INIT_LIST_HEAD(&new->val);
+	list_add_tail(&new->brothers, &parent->children);
+
+	return new;
+}
+
+static void
+fill_node(struct callchain_node *node, struct ip_callchain *chain, int start)
+{
+	int i;
+
+	for (i = start; i < chain->nr; i++) {
+		struct callchain_list *call;
+
+		call = malloc(sizeof(*chain));
+		if (!call) {
+			perror("not enough memory for the code path tree");
+			return;
+		}
+		call->ip = chain->ips[i];
+		list_add_tail(&call->list, &node->val);
+	}
+	node->val_nr = i - start;
+}
+
+static void add_child(struct callchain_node *parent, struct ip_callchain *chain)
+{
+	struct callchain_node *new;
+
+	new = create_child(parent);
+	fill_node(new, chain, parent->val_nr);
+
+	new->hit = 1;
+}
+
+static void
+split_add_child(struct callchain_node *parent, struct ip_callchain *chain,
+		struct callchain_list *to_split, int idx)
+{
+	struct callchain_node *new;
+
+	/* split */
+	new = create_child(parent);
+	list_move_tail(&to_split->list, &new->val);
+	new->hit = parent->hit;
+	parent->hit = 0;
+	parent->val_nr = idx;
+
+	/* create the new one */
+	add_child(parent, chain);
+}
+
+static int
+__append_chain(struct callchain_node *root, struct ip_callchain *chain,
+		int start);
+
+static int
+__append_chain_children(struct callchain_node *root, struct ip_callchain *chain)
+{
+	struct callchain_node *rnode;
+
+	/* lookup in childrens */
+	list_for_each_entry(rnode, &root->children, brothers) {
+		int ret = __append_chain(rnode, chain, root->val_nr);
+		if (!ret)
+			return 0;
+	}
+	return -1;
+}
+
+static int
+__append_chain(struct callchain_node *root, struct ip_callchain *chain,
+		int start)
+{
+	struct callchain_list *cnode;
+	int i = start;
+	bool found = false;
+
+	/* lookup in the current node */
+	list_for_each_entry(cnode, &root->val, list) {
+		if (cnode->ip != chain->ips[i++])
+			break;
+		if (!found)
+			found = true;
+		if (i == chain->nr)
+			break;
+	}
+
+	/* matches not, relay on the parent */
+	if (!found)
+		return -1;
+
+	/* we match only a part of the node. Split it and add the new chain */
+	if (i < root->val_nr) {
+		split_add_child(root, chain, cnode, i);
+		return 0;
+	}
+
+	/* we match 100% of the path, increment the hit */
+	if (i == root->val_nr) {
+		root->hit++;
+		return 0;
+	}
+
+	return __append_chain_children(root, chain);
+}
+
+void append_chain(struct callchain_node *root, struct ip_callchain *chain)
+{
+	if (__append_chain_children(root, chain) == -1)
+		add_child(root, chain);
+}
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
new file mode 100644
index 0000000..fa1cd2f
--- /dev/null
+++ b/tools/perf/util/callchain.h
@@ -0,0 +1,33 @@
+#ifndef __PERF_CALLCHAIN_H
+#define __PERF_CALLCHAIN_H
+
+#include "../perf.h"
+#include "list.h"
+#include "rbtree.h"
+
+
+struct callchain_node {
+	struct callchain_node	*parent;
+	struct list_head	brothers;
+	struct list_head 	children;
+	struct list_head 	val;
+	struct rb_node		rb_node;
+	int			val_nr;
+	int			hit;
+};
+
+struct callchain_list {
+	unsigned long		ip;
+	struct list_head	list;
+};
+
+static inline void callchain_init(struct callchain_node *node)
+{
+	INIT_LIST_HEAD(&node->brothers);
+	INIT_LIST_HEAD(&node->children);
+	INIT_LIST_HEAD(&node->val);
+}
+
+void append_chain(struct callchain_node *root, struct ip_callchain *chain);
+void sort_chain_to_rbtree(struct rb_root *rb_root, struct callchain_node *node);
+#endif
-- 
1.6.2.3

