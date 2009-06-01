Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbZFAFih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbZFAFih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 01:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459AbZFAFiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 01:38:06 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:58764 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbZFAFiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 01:38:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rx5fSVkl4Lo7VR8O3m09JRL2EETiQ03QnL+IPnUU1Cw7wDmjo8/I5waVYHwk/Yq+Mw
         HB48NlkcMWSxVl2ORbPVDM0u0qkoOxYQSErFX+IWcdXltouTAAu3iHQ8DIZQfEmAousx
         UtuAMIGH5HJ0RrMpbM12R+VNFajs7etEnNhBQ=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>
Subject: [RFC PATCH 1/2] tracing/stat: introduce new hashlist mode
Date: Mon,  1 Jun 2009 07:37:58 +0200
Message-Id: <1243834679-19132-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1243834679-19132-1-git-send-email-fweisbec@gmail.com>
References: <1243834679-19132-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Until now, the stat tracing was only able to gather the pointers
to entries from a tracer, sort them and eventually pass these
pointers to the tracer output handler.

It has two drawbacks:

- if the tracer concurrently releases a pointer, this one may be
  dereference later in the output callback. There are ways to keep
  track of these pointers but it ends up with extra code from the
  tracers.

- the tracer has to handle its entries itself, through its own
  hashlist, list or whatever.

This patch introduces a new mode for the stat tracers. Those can now
ask the tracing stat Api to handle their entries, which includes the
memory allocation, the access, the synchronization, the lookup, etc...

This is done through an internal hashlist that is built according
to the number and size of entries provided by the tracer.

A tracer can choose between this new mode and the old one by using
the HASH_NODES flag in struct tracer_stat.

Instead of providing a pair of iterator callbacks, they just need
to fill up the hlist_size and node_size fields.

Then using a unique id for each stat entries (usually a simple address
to a traced thing), they can access to an entry using the two new pairs:

- get_stat_entry() which retrieve the entry and locks it against
  concurrent updates
- put_stat_entry() which unlocks the entry

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_stat.c |  329 ++++++++++++++++++++++++++++++++++++++++++++-
 kernel/trace/trace_stat.h |   27 ++++-
 2 files changed, 353 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
index e4821c6..7321bc9 100644
--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -12,11 +12,46 @@
 #include <linux/list.h>
 #include <linux/rbtree.h>
 #include <linux/debugfs.h>
+#include <linux/log2.h>
+#include <linux/hash.h>
 #include "trace_stat.h"
 #include "trace.h"
 
 
 /*
+ * Hash list which handles the entries from a tracer
+ *
+ * @hlist is of size tracer->hlist_size entries
+ * @free_entries is a list of rooms that can be picked for new entries
+ * @lock synchronize concurrent hlist writers
+ * @barriers synchronize lookup on free_entries so that we don't have
+ * concurrent lookup for a same stat. It induces rare loss of hits.
+ */
+struct stat_hlist {
+	struct hlist_head	*hlist;
+	struct hlist_head	free_entries;
+	raw_spinlock_t		lock;
+	atomic_t		*barriers;
+};
+
+/*
+ * A stat atom which handles a stat entry inside the hash list
+ *
+ * @id is the identifier, usually a pointer to the traced thing
+ * @hnode is the node inside the hlist or free_entries
+ * @lock synchronize concurrent updates from the tracer for this entry
+ * @irqflags because we want the entry to be update-able in every context
+ * @stat are the actual data to update from the tracer
+ */
+struct stat_entry {
+	unsigned long 		id;
+	struct hlist_node	hnode;
+	raw_spinlock_t		lock;
+	unsigned long		irqflags;
+	char			stat[];
+};
+
+/*
  * List of stat red-black nodes from a tracer
  * We use a such tree to sort quickly the stat
  * entries from the tracer.
@@ -42,6 +77,210 @@ static DEFINE_MUTEX(all_stat_sessions_mutex);
 /* The root directory for all stat files */
 static struct dentry		*stat_dir;
 
+static unsigned long
+stat_entry_hash(struct tracer_stat *tracer, unsigned long id)
+{
+	int bits;
+	unsigned long hash;
+
+	bits = ilog2(tracer->hlist_size);
+	hash = hash_ptr((void *)id, bits);
+
+	return hash;
+}
+
+/* Find the entry if it is already in the hashlist */
+static struct stat_entry *
+stat_find_entry(struct hlist_head *hlist, unsigned long id)
+{
+	struct hlist_node *node;
+	struct stat_entry *entry = NULL;
+
+	hlist_for_each_entry_rcu(entry, node, hlist, hnode) {
+		if (entry->id == id)
+			return entry;
+	}
+
+	return NULL;
+}
+
+/* Pick a free entry to introduce a new stat node in the hash list */
+static struct stat_entry *
+stat_find_free_entry(struct stat_hlist *stat_hlist, unsigned long hash,
+		     unsigned long id)
+{
+	struct hlist_head *hlist;
+	struct hlist_node *node;
+	struct stat_entry *entry;
+	unsigned long flags;
+
+	hlist = &stat_hlist->hlist[hash];
+
+	/* Don't allow multiple free entries requests for the same stat entry */
+	if (atomic_inc_return(&stat_hlist->barriers[hash]) != 1)
+		goto end;
+
+	/*
+	 * Someone else might have already picked a new free entry for this
+	 * between the time we failed to get it with stat_find_entry() and
+	 * the time we hit the barrier
+	 */
+	entry = stat_find_entry(hlist, id);
+	if (entry)
+		goto end;
+
+	raw_local_irq_save(flags);
+	__raw_spin_lock(&stat_hlist->lock);
+
+	node = stat_hlist->free_entries.first;
+	if (!node) {
+		entry = NULL;
+		goto end_unlock;
+	}
+
+	hlist_del_rcu(node);
+	entry = hlist_entry(node, struct stat_entry, hnode);
+	entry->id = id;
+	hlist_add_head_rcu(node, hlist);
+end_unlock:
+	__raw_spin_unlock(&stat_hlist->lock);
+	raw_local_irq_restore(flags);
+end:
+	atomic_dec(&stat_hlist->barriers[hash]);
+
+	return entry;
+}
+
+/**
+ * get_stat_entry - Find the entry which matches id as an identifier.
+ * If it is not yet in the hlist, then we create a new one and zeroe it out
+ * It must be followed by a call to put_stat_entry()
+ *
+ * @tracer is the stat tracer which requests the entry
+ * @id is a unique identifier for this entry. Usually an address.
+ * @is_first is a passed variable which will be true if the entry has just
+ *           been created.
+ *
+ * @return a pointer to the entry
+ */
+void *get_stat_entry(struct tracer_stat *tracer, unsigned long id,
+			bool *is_first)
+{
+	struct stat_entry *entry;
+	struct hlist_head *hlist;
+	unsigned long hash;
+
+	hlist = tracer->entries->hlist;
+	hash = stat_entry_hash(tracer, id);
+
+	/* Is it on the hashlist ? */
+	entry = stat_find_entry(&hlist[hash], id);
+	if (entry) {
+		*is_first = false;
+		goto end_lock;
+	}
+
+	/* If not we pick a new entry */
+	entry = stat_find_free_entry(tracer->entries, hash, id);
+	if (!entry)
+		return NULL;
+	*is_first = true;
+
+	/* Lock to disallow concurrent updates */
+end_lock:
+	raw_local_irq_save(entry->irqflags);
+	__raw_spin_lock(&entry->lock);
+
+	return entry->stat;
+}
+
+/**
+ * put_stat_entry - Release the lock for this entry.
+ *
+ * @raw_entry is the entry returned by get_stat_entry()
+ */
+void put_stat_entry(void *raw_entry)
+{
+	struct stat_entry *entry;
+
+	if (!raw_entry)
+		return;
+
+	entry = container_of(raw_entry, struct stat_entry, stat);
+	raw_local_irq_restore(entry->irqflags);
+	__raw_spin_unlock(&entry->lock);
+}
+
+/**
+ * drop_stat_entry - Erase an entry from the hashlist if present
+ * This entry will not be freed but can be reused just after.
+ * The worst race that can happen is a mixup of its values. It should
+ * be harmless.
+ *
+ * @tracer is the tracer in charge of this stat entry
+ * @id is the unique identifier of the entry
+ */
+void drop_stat_entry(struct tracer_stat *tracer, unsigned long id)
+{
+	unsigned long flags;
+	struct hlist_head *hlist;
+	struct stat_entry *entry;
+	struct hlist_head *free_entries;
+	unsigned long hash;
+
+	hlist = tracer->entries->hlist;
+	hash = stat_entry_hash(tracer, id);
+	entry = stat_find_entry(&hlist[hash], id);
+	if (!entry)
+		return;
+
+	free_entries = &tracer->entries->free_entries;
+
+	raw_local_irq_save(flags);
+	__raw_spin_lock(&tracer->entries->lock);
+
+	hlist_del_rcu(&entry->hnode);
+	hlist_add_head_rcu(&entry->hnode, free_entries);
+	memset(entry->stat, 0, tracer->node_size);
+
+	__raw_spin_unlock(&tracer->entries->lock);
+	raw_local_irq_restore(flags);
+}
+
+
+static void stat_release_hlist(struct hlist_head *hlist)
+{
+	struct stat_entry *entry;
+	struct hlist_node *node, *next;
+
+	hlist_for_each_entry_safe(entry, node, next, hlist, hnode) {
+		hlist_del(node);
+		kfree(entry);
+	}
+}
+
+/* release all entries from the hlist if any */
+static void stat_release_entries(struct tracer_stat *trace)
+{
+	int i;
+
+	if (!trace->entries)
+		return;
+
+	stat_release_hlist(&trace->entries->free_entries);
+	if (!trace->entries->hlist)
+		return;
+
+	for (i = 0; i < trace->hlist_size; i++) {
+		struct hlist_head *hlist;
+
+		hlist = &trace->entries->hlist[i];
+		stat_release_hlist(hlist);
+	}
+	kfree(trace->entries->hlist);
+	kfree(trace->entries);
+}
+
 /*
  * Iterate through the rbtree using a post order traversal path
  * to release the next node.
@@ -85,6 +324,7 @@ static void reset_stat_session(struct stat_session *session)
 
 static void destroy_session(struct stat_session *session)
 {
+	stat_release_entries(session->ts);
 	debugfs_remove(session->file);
 	reset_stat_session(session);
 	mutex_destroy(&session->stat_mutex);
@@ -136,6 +376,27 @@ static int dummy_cmp(void *p1, void *p2)
 	return -1;
 }
 
+
+/*
+ * If we are using an internal hlist, then we don't use any iterator
+ * callback but a direct hlist walk
+ */
+static void
+stat_seq_init_from_hash(struct tracer_stat *ts, struct rb_root *root)
+{
+	int i, ret;
+	struct hlist_node *node;
+	struct stat_entry *entry;
+	struct hlist_head *hlist = ts->entries->hlist;
+
+	for (i = 0; i < ts->hlist_size; i++) {
+		hlist_for_each_entry_rcu(entry, node, &hlist[i], hnode) {
+			ret = insert_stat(root, entry->stat, ts->stat_cmp);
+			if (ret)
+				return;
+		}
+	}
+}
 /*
  * Initialize the stat rbtree at each trace_stat file opening.
  * All of these copies and sorting are required on all opening
@@ -155,6 +416,11 @@ static int stat_seq_init(struct stat_session *session)
 	if (!ts->stat_cmp)
 		ts->stat_cmp = dummy_cmp;
 
+	if (session->ts->flags & HASH_NODES) {
+		stat_seq_init_from_hash(ts, root);
+		goto exit;
+	}
+
 	stat = ts->stat_start(ts);
 	if (!stat)
 		goto exit;
@@ -322,6 +588,45 @@ static int init_stat_file(struct stat_session *session)
 	return 0;
 }
 
+static int init_stat_hash(struct stat_session *session)
+{
+	struct tracer_stat *trace = session->ts;
+	struct stat_hlist *entries;
+	struct stat_entry *entry;
+	int i;
+
+	if (trace->hlist_size <= 0 || trace->node_size <= 0)
+		return -EINVAL;
+
+	trace->entries = kzalloc(sizeof(*trace->entries), GFP_KERNEL);
+	if (!trace->entries)
+		return -ENOMEM;
+
+	entries = trace->entries;
+
+	entries->hlist = kzalloc(sizeof(*entries->hlist) * trace->hlist_size,
+			       GFP_KERNEL);
+	if (!entries->hlist)
+		return -ENOMEM;
+
+	entries->barriers = kzalloc(sizeof(atomic_t) * trace->hlist_size,
+				GFP_KERNEL);
+	if (!entries->barriers)
+		return -ENOMEM;
+
+	INIT_HLIST_HEAD(&entries->free_entries);
+
+	for (i = 0; i < trace->hlist_size; i++) {
+		entry = kzalloc(sizeof(*entry) + trace->node_size, GFP_KERNEL);
+		if (!entry)
+			return -ENOMEM;
+
+		hlist_add_head(&entry->hnode, &entries->free_entries);
+	}
+
+	return 0;
+}
+
 int register_stat_tracer(struct tracer_stat *trace)
 {
 	struct stat_session *session, *node;
@@ -330,7 +635,15 @@ int register_stat_tracer(struct tracer_stat *trace)
 	if (!trace)
 		return -EINVAL;
 
-	if (!trace->stat_start || !trace->stat_next || !trace->stat_show)
+	/*
+	 * If we don't use the internal hlist, we need the start and
+	 * next iterators
+	 */
+	if (!(trace->flags & HASH_NODES) &&
+				(!trace->stat_start || !trace->stat_next))
+		return -EINVAL;
+
+	if (!trace->stat_show)
 		return -EINVAL;
 
 	/* Already registered? */
@@ -363,7 +676,19 @@ int register_stat_tracer(struct tracer_stat *trace)
 	list_add_tail(&session->session_list, &all_stat_sessions);
 	mutex_unlock(&all_stat_sessions_mutex);
 
-	return 0;
+	if (!(trace->flags & HASH_NODES))
+		return 0;
+
+	ret = init_stat_hash(session);
+	if (!ret)
+		return 0;
+
+	mutex_lock(&all_stat_sessions_mutex);
+	list_del(&session->session_list);
+	mutex_unlock(&all_stat_sessions_mutex);
+	destroy_session(session);
+
+	return ret;
 }
 
 void unregister_stat_tracer(struct tracer_stat *trace)
diff --git a/kernel/trace/trace_stat.h b/kernel/trace/trace_stat.h
index 915bf2e..a0e3288 100644
--- a/kernel/trace/trace_stat.h
+++ b/kernel/trace/trace_stat.h
@@ -3,6 +3,17 @@
 
 #include <linux/seq_file.h>
 
+struct stat_hlist;
+
+/*
+ * Pick this flag if you want the stat tracing to allocate and find
+ * your entries through a hashlist.
+ *
+ * Otherwise you must handle your entries yourself and just
+ * provide a stat_start()/stat_next() iterator pair.
+ */
+#define HASH_NODES	1
+
 /*
  * If you want to provide a stat file (one-shot statistics), fill
  * an iterator with stat_start/stat_next and a stat_show callbacks.
@@ -11,9 +22,10 @@
 struct tracer_stat {
 	/* The name of your stat file */
 	const char		*name;
-	/* Iteration over statistic entries */
+	/* Iteration over statistic entries (unneeded with HASH_NODES) */
 	void			*(*stat_start)(struct tracer_stat *trace);
 	void			*(*stat_next)(void *prev, int idx);
+
 	/* Compare two entries for stats sorting */
 	int			(*stat_cmp)(void *p1, void *p2);
 	/* Print a stat entry */
@@ -23,6 +35,14 @@ struct tracer_stat {
 	/* Hooks on file operations */
 	void			(*file_open)(void);
 	void			(*file_release)(void);
+	/* Number of entries on the hash list */
+	int			hlist_size;
+	/* Size of the datas in a stat entry */
+	int			node_size;
+	/* Hash list, used internally */
+	struct stat_hlist	*entries;
+	/* HASH_NODES or 0 */
+	int			flags;
 };
 
 /*
@@ -31,4 +51,9 @@ struct tracer_stat {
 extern int register_stat_tracer(struct tracer_stat *trace);
 extern void unregister_stat_tracer(struct tracer_stat *trace);
 
+extern void *get_stat_entry(struct tracer_stat *tracer, unsigned long id,
+				bool *is_first);
+extern void put_stat_entry(void *raw_entry);
+extern void drop_stat_entry(struct tracer_stat *tracer, unsigned long id);
+
 #endif /* __TRACE_STAT_H */
-- 
1.6.2.3

