Return-Path: <linux-kernel-owner+w=401wt.eu-S1756908AbZEPFTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908AbZEPFTh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 01:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407AbZEPFSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 01:18:50 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:45481 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbZEPFSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 01:18:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xirFj7C6x+JEm/iAZ7jjvwyWoRsDm/SsNcQVjubhYnYLr9k2Big1EW0pEx0fWEGHK8
         5elXj268R2bg6d6kUiUmyFpvJvzKdXfv0cf5iwwcwrHqud0MlTNwwoDGXgK82UKUfkKO
         IcEVWQcqvhrJW8jCXSAlFWrES6EZJTM0OrgP4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 2/2] tracing/stat: replace linked list by an rbtree for sorting
Date: Sat, 16 May 2009 07:18:44 +0200
Message-Id: <1242451124-5466-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1242451124-5466-1-git-send-email-fweisbec@gmail.com>
References: <1242451124-5466-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the stat tracing framework prepares the entries from a tracer
to output them to the user, it starts by computing a linear sort
through a linked list to give the entries ordered by relevance
to the user.

This is quite ugly and causes a small latency when we begin to
read the file.

This patch changes that by turning the linked list into a red-black
tree. Athough the whole iteration using the start and next tracer
callbacks while opening the file remain the same, it is now much
more fast and scalable.

The rbtree guarantees O(log(n)) insertions whereas a linked
list with linear sorting brought us a O(n) despair. Now the
(visible) latency has disapeared.

[ Impact: kill the latency while starting to read a stat tracer file ]

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_stat.c |  140 ++++++++++++++++++++++++++++++++-------------
 1 files changed, 100 insertions(+), 40 deletions(-)

diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
index 3b6816b..0bd0fc8 100644
--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -1,7 +1,7 @@
 /*
  * Infrastructure for statistic tracing (histogram output).
  *
- * Copyright (C) 2008 Frederic Weisbecker <fweisbec@gmail.com>
+ * Copyright (C) 2008-2009 Frederic Weisbecker <fweisbec@gmail.com>
  *
  * Based on the code from trace_branch.c which is
  * Copyright (C) 2008 Steven Rostedt <srostedt@redhat.com>
@@ -10,14 +10,19 @@
 
 
 #include <linux/list.h>
+#include <linux/rbtree.h>
 #include <linux/debugfs.h>
 #include "trace_stat.h"
 #include "trace.h"
 
 
-/* List of stat entries from a tracer */
-struct trace_stat_list {
-	struct list_head	list;
+/*
+ * List of stat red-black nodes from a tracer
+ * We use a such tree to sort quickly the stat
+ * entries from the tracer.
+ */
+struct stat_node {
+	struct rb_node		node;
 	void			*stat;
 };
 
@@ -25,7 +30,7 @@ struct trace_stat_list {
 struct stat_session {
 	struct list_head	session_list;
 	struct tracer_stat	*ts;
-	struct list_head	stat_list;
+	struct rb_root		stat_root;
 	struct mutex		stat_mutex;
 	struct dentry		*file;
 };
@@ -37,15 +42,45 @@ static DEFINE_MUTEX(all_stat_sessions_mutex);
 /* The root directory for all stat files */
 static struct dentry		*stat_dir;
 
+/*
+ * Iterate through the rbtree using a post order traversal path
+ * to release the next node.
+ * It won't necessary release one at each iteration
+ * but it will at least advance closer to the next one
+ * to be released.
+ */
+static struct rb_node *release_next(struct rb_node *node)
+{
+	struct stat_node *snode;
+	struct rb_node *parent = rb_parent(node);
+
+	if (node->rb_left)
+		return node->rb_left;
+	else if (node->rb_right)
+		return node->rb_right;
+	else {
+		if (!parent)
+			return NULL;
+		if (parent->rb_left == node)
+			parent->rb_left = NULL;
+		else
+			parent->rb_right = NULL;
+
+		snode = container_of(node, struct stat_node, node);
+		kfree(snode);
+
+		return parent;
+	}
+}
 
 static void reset_stat_session(struct stat_session *session)
 {
-	struct trace_stat_list *node, *next;
+	struct rb_node *node = session->stat_root.rb_node;
 
-	list_for_each_entry_safe(node, next, &session->stat_list, list)
-		kfree(node);
+	while (node)
+		node = release_next(node);
 
-	INIT_LIST_HEAD(&session->stat_list);
+	session->stat_root = RB_ROOT;
 }
 
 static void destroy_session(struct stat_session *session)
@@ -56,6 +91,35 @@ static void destroy_session(struct stat_session *session)
 	kfree(session);
 }
 
+typedef int (*cmp_stat_t)(void *, void *);
+
+static void
+insert_stat(struct rb_root *root, struct stat_node *data, cmp_stat_t cmp)
+{
+	struct rb_node **new = &(root->rb_node), *parent = NULL;
+
+	/*
+	 * Figure out where to put new node
+	 * This is a descendent sorting
+	 */
+	while (*new) {
+		struct stat_node *this;
+		int result;
+
+		this = container_of(*new, struct stat_node, node);
+		result = cmp(data->stat, this->stat);
+
+		parent = *new;
+		if (result >= 0)
+			new = &((*new)->rb_left);
+		else
+			new = &((*new)->rb_right);
+	}
+
+	rb_link_node(&data->node, parent, new);
+	rb_insert_color(&data->node, root);
+}
+
 /*
  * For tracers that don't provide a stat_cmp callback.
  * This one will force an immediate insertion on tail of
@@ -73,8 +137,9 @@ static int dummy_cmp(void *p1, void *p2)
  */
 static int stat_seq_init(struct stat_session *session)
 {
-	struct trace_stat_list *iter_entry, *new_entry;
 	struct tracer_stat *ts = session->ts;
+	struct stat_node *new_entry;
+	struct rb_root *root;
 	void *stat;
 	int ret = 0;
 	int i;
@@ -93,15 +158,13 @@ static int stat_seq_init(struct stat_session *session)
 	 * The first entry. Actually this is the second, but the first
 	 * one (the stat_list head) is pointless.
 	 */
-	new_entry = kmalloc(sizeof(struct trace_stat_list), GFP_KERNEL);
+	new_entry = kzalloc(sizeof(*new_entry), GFP_KERNEL);
 	if (!new_entry) {
 		ret = -ENOMEM;
 		goto exit;
 	}
-
-	INIT_LIST_HEAD(&new_entry->list);
-
-	list_add(&new_entry->list, &session->stat_list);
+	root = &session->stat_root;
+	insert_stat(root, new_entry, dummy_cmp);
 
 	new_entry->stat = stat;
 
@@ -116,31 +179,17 @@ static int stat_seq_init(struct stat_session *session)
 		if (!stat)
 			break;
 
-		new_entry = kmalloc(sizeof(struct trace_stat_list), GFP_KERNEL);
+		new_entry = kzalloc(sizeof(*new_entry), GFP_KERNEL);
 		if (!new_entry) {
 			ret = -ENOMEM;
 			goto exit_free_list;
 		}
 
-		INIT_LIST_HEAD(&new_entry->list);
 		new_entry->stat = stat;
 
-		list_for_each_entry_reverse(iter_entry, &session->stat_list,
-				list) {
-
-			/* Insertion with a descendent sorting */
-			if (ts->stat_cmp(iter_entry->stat,
-					new_entry->stat) >= 0) {
-
-				list_add(&new_entry->list, &iter_entry->list);
-				break;
-			}
-		}
-
-		/* The current larger value */
-		if (list_empty(&new_entry->list))
-			list_add(&new_entry->list, &session->stat_list);
+		insert_stat(root, new_entry, ts->stat_cmp);
 	}
+
 exit:
 	mutex_unlock(&session->stat_mutex);
 	return ret;
@@ -155,25 +204,38 @@ exit_free_list:
 static void *stat_seq_start(struct seq_file *s, loff_t *pos)
 {
 	struct stat_session *session = s->private;
+	struct rb_node *node;
+	int i;
 
 	/* Prevent from tracer switch or stat_list modification */
 	mutex_lock(&session->stat_mutex);
 
 	/* If we are in the beginning of the file, print the headers */
-	if (!*pos && session->ts->stat_headers)
+	if (!*pos && session->ts->stat_headers) {
+		(*pos)++;
 		return SEQ_START_TOKEN;
+	}
 
-	return seq_list_start(&session->stat_list, *pos);
+	node = rb_first(&session->stat_root);
+	for (i = 0; node && i < *pos; i++)
+		node = rb_next(node);
+
+	(*pos)++;
+
+	return node;
 }
 
 static void *stat_seq_next(struct seq_file *s, void *p, loff_t *pos)
 {
 	struct stat_session *session = s->private;
+	struct rb_node *node = p;
+
+	(*pos)++;
 
 	if (p == SEQ_START_TOKEN)
-		return seq_list_start(&session->stat_list, *pos);
+		return rb_first(&session->stat_root);
 
-	return seq_list_next(p, &session->stat_list, pos);
+	return rb_next(node);
 }
 
 static void stat_seq_stop(struct seq_file *s, void *p)
@@ -185,7 +247,7 @@ static void stat_seq_stop(struct seq_file *s, void *p)
 static int stat_seq_show(struct seq_file *s, void *v)
 {
 	struct stat_session *session = s->private;
-	struct trace_stat_list *l = list_entry(v, struct trace_stat_list, list);
+	struct stat_node *l = container_of(v, struct stat_node, node);
 
 	if (v == SEQ_START_TOKEN)
 		return session->ts->stat_headers(s);
@@ -286,15 +348,13 @@ int register_stat_tracer(struct tracer_stat *trace)
 	mutex_unlock(&all_stat_sessions_mutex);
 
 	/* Init the session */
-	session = kmalloc(sizeof(struct stat_session), GFP_KERNEL);
+	session = kzalloc(sizeof(*session), GFP_KERNEL);
 	if (!session)
 		return -ENOMEM;
 
 	session->ts = trace;
 	INIT_LIST_HEAD(&session->session_list);
-	INIT_LIST_HEAD(&session->stat_list);
 	mutex_init(&session->stat_mutex);
-	session->file = NULL;
 
 	ret = init_stat_file(session);
 	if (ret) {
-- 
1.6.2.3

