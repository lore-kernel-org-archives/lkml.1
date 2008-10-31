Return-Path: <linux-kernel-owner+w=401wt.eu-S1753213AbYJaOL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbYJaOL0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 10:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbYJaOKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 10:10:45 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:49654 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127AbYJaOKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 10:10:44 -0400
Message-Id: <20081031140121.326462848@polymtl.ca>
References: <20081031140000.423846207@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 31 Oct 2008 10:00:01 -0400
From: mathieu.desnoyers@polymtl.ca
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 1/2] tracepoint: simplify for tracepoint using RCU
Content-Disposition: inline; filename=tracepoint-simplify-for-tracepoint-using-rcu.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Fri, 31 Oct 2008 14:10:21 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, unused memory is handled by struct tp_probes.

old code use these three field to handle unused memory.
struct tracepoint_entry {
	...
	struct rcu_head rcu;
	void *oldptr;
	unsigned char rcu_pending:1;
	...
};
in this way, unused memory is handled by struct tracepoint_entry.
it bring reenter bug(it was fixed) and tracepoint.c is filled
full of ".*rcu.*" code statements. this patch remove all these.

and:
  rcu_barrier_sched() is removed.
  Do not need regain tracepoints_mutex after tracepoint_update_probes()
  several little cleanup.

Mathieu Desnoyers :
Update patch to make sure it applies correctly on top of
tracepoint-check-if-the-probe-has-been-registered.patch

From: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 kernel/tracepoint.c |  111 +++++++++++++++++-----------------------------------
 1 file changed, 37 insertions(+), 74 deletions(-)
Index: linux-2.6-lttng/kernel/tracepoint.c
===================================================================
--- linux-2.6-lttng.orig/kernel/tracepoint.c	2008-10-30 20:12:13.000000000 -0400
+++ linux-2.6-lttng/kernel/tracepoint.c	2008-10-30 20:17:25.000000000 -0400
@@ -43,6 +43,7 @@ static DEFINE_MUTEX(tracepoints_mutex);
  */
 #define TRACEPOINT_HASH_BITS 6
 #define TRACEPOINT_TABLE_SIZE (1 << TRACEPOINT_HASH_BITS)
+static struct hlist_head tracepoint_table[TRACEPOINT_TABLE_SIZE];
 
 /*
  * Note about RCU :
@@ -54,40 +55,40 @@ struct tracepoint_entry {
 	struct hlist_node hlist;
 	void **funcs;
 	int refcount;	/* Number of times armed. 0 if disarmed. */
-	struct rcu_head rcu;
-	void *oldptr;
-	unsigned char rcu_pending:1;
 	char name[0];
 };
 
-static struct hlist_head tracepoint_table[TRACEPOINT_TABLE_SIZE];
+struct tp_probes {
+	struct rcu_head rcu;
+	void *probes[0];
+};
 
-static void free_old_closure(struct rcu_head *head)
+static inline void *allocate_probes(int count)
 {
-	struct tracepoint_entry *entry = container_of(head,
-		struct tracepoint_entry, rcu);
-	kfree(entry->oldptr);
-	/* Make sure we free the data before setting the pending flag to 0 */
-	smp_wmb();
-	entry->rcu_pending = 0;
+	struct tp_probes *p  = kmalloc(count * sizeof(void *)
+			+ sizeof(struct tp_probes), GFP_KERNEL);
+	return p == NULL ? NULL : p->probes;
 }
 
-static void tracepoint_entry_free_old(struct tracepoint_entry *entry, void *old)
+static void rcu_free_old_probes(struct rcu_head *head)
 {
-	if (!old)
-		return;
-	entry->oldptr = old;
-	entry->rcu_pending = 1;
-	/* write rcu_pending before calling the RCU callback */
-	smp_wmb();
-	call_rcu_sched(&entry->rcu, free_old_closure);
+	kfree(container_of(head, struct tp_probes, rcu));
+}
+
+static inline void release_probes(void *old)
+{
+	if (old) {
+		struct tp_probes *tp_probes = container_of(old,
+			struct tp_probes, probes[0]);
+		call_rcu(&tp_probes->rcu, rcu_free_old_probes);
+	}
 }
 
 static void debug_print_probes(struct tracepoint_entry *entry)
 {
 	int i;
 
-	if (!tracepoint_debug)
+	if (!tracepoint_debug || !entry->funcs)
 		return;
 
 	for (i = 0; entry->funcs[i]; i++)
@@ -111,12 +112,13 @@ tracepoint_entry_add_probe(struct tracep
 				return ERR_PTR(-EEXIST);
 	}
 	/* + 2 : one for new probe, one for NULL func */
-	new = kzalloc((nr_probes + 2) * sizeof(void *), GFP_KERNEL);
+	new = allocate_probes(nr_probes + 2);
 	if (new == NULL)
 		return ERR_PTR(-ENOMEM);
 	if (old)
 		memcpy(new, old, nr_probes * sizeof(void *));
 	new[nr_probes] = probe;
+	new[nr_probes + 1] = NULL;
 	entry->refcount = nr_probes + 1;
 	entry->funcs = new;
 	debug_print_probes(entry);
@@ -132,7 +134,7 @@ tracepoint_entry_remove_probe(struct tra
 	old = entry->funcs;
 
 	if (!old)
-		return NULL;
+		return ERR_PTR(-ENOENT);
 
 	debug_print_probes(entry);
 	/* (N -> M), (N > 1, M >= 0) probes */
@@ -151,13 +153,13 @@ tracepoint_entry_remove_probe(struct tra
 		int j = 0;
 		/* N -> M, (N > 1, M > 0) */
 		/* + 1 for NULL */
-		new = kzalloc((nr_probes - nr_del + 1)
-			* sizeof(void *), GFP_KERNEL);
+		new = allocate_probes(nr_probes - nr_del + 1);
 		if (new == NULL)
 			return ERR_PTR(-ENOMEM);
 		for (i = 0; old[i]; i++)
 			if ((probe && old[i] != probe))
 				new[j++] = old[i];
+		new[nr_probes - nr_del] = NULL;
 		entry->refcount = nr_probes - nr_del;
 		entry->funcs = new;
 	}
@@ -215,7 +217,6 @@ static struct tracepoint_entry *add_trac
 	memcpy(&e->name[0], name, name_len);
 	e->funcs = NULL;
 	e->refcount = 0;
-	e->rcu_pending = 0;
 	hlist_add_head(&e->hlist, head);
 	return e;
 }
@@ -224,32 +225,10 @@ static struct tracepoint_entry *add_trac
  * Remove the tracepoint from the tracepoint hash table. Must be called with
  * mutex_lock held.
  */
-static int remove_tracepoint(const char *name)
+static inline void remove_tracepoint(struct tracepoint_entry *e)
 {
-	struct hlist_head *head;
-	struct hlist_node *node;
-	struct tracepoint_entry *e;
-	int found = 0;
-	size_t len = strlen(name) + 1;
-	u32 hash = jhash(name, len-1, 0);
-
-	head = &tracepoint_table[hash & (TRACEPOINT_TABLE_SIZE - 1)];
-	hlist_for_each_entry(e, node, head, hlist) {
-		if (!strcmp(name, e->name)) {
-			found = 1;
-			break;
-		}
-	}
-	if (!found)
-		return -ENOENT;
-	if (e->refcount)
-		return -EBUSY;
 	hlist_del(&e->hlist);
-	/* Make sure the call_rcu_sched has been executed */
-	if (e->rcu_pending)
-		rcu_barrier_sched();
 	kfree(e);
-	return 0;
 }
 
 /*
@@ -343,25 +322,17 @@ int tracepoint_probe_register(const char
 			goto end;
 		}
 	}
-	/*
-	 * If we detect that a call_rcu_sched is pending for this tracepoint,
-	 * make sure it's executed now.
-	 */
-	if (entry->rcu_pending)
-		rcu_barrier_sched();
 	old = tracepoint_entry_add_probe(entry, probe);
 	if (IS_ERR(old)) {
+		if (!entry->refcount)
+			remove_tracepoint(entry);
 		ret = PTR_ERR(old);
 		goto end;
 	}
 	mutex_unlock(&tracepoints_mutex);
 	tracepoint_update_probes();		/* may update entry */
-	mutex_lock(&tracepoints_mutex);
-	entry = get_tracepoint(name);
-	WARN_ON(!entry);
-	if (entry->rcu_pending)
-		rcu_barrier_sched();
-	tracepoint_entry_free_old(entry, old);
+	release_probes(old);
+	return 0;
 end:
 	mutex_unlock(&tracepoints_mutex);
 	return ret;
@@ -388,25 +359,17 @@ int tracepoint_probe_unregister(const ch
 	entry = get_tracepoint(name);
 	if (!entry)
 		goto end;
-	if (entry->rcu_pending)
-		rcu_barrier_sched();
 	old = tracepoint_entry_remove_probe(entry, probe);
-	if (!old) {
-		printk(KERN_WARNING "Warning: Trying to unregister a probe"
-				    "that doesn't exist\n");
+	if (IS_ERR(old)) {
+		ret = PTR_ERR(old);
 		goto end;
 	}
+	if (!entry->refcount)
+		remove_tracepoint(entry);
 	mutex_unlock(&tracepoints_mutex);
 	tracepoint_update_probes();		/* may update entry */
-	mutex_lock(&tracepoints_mutex);
-	entry = get_tracepoint(name);
-	if (!entry)
-		goto end;
-	if (entry->rcu_pending)
-		rcu_barrier_sched();
-	tracepoint_entry_free_old(entry, old);
-	remove_tracepoint(name);	/* Ignore busy error message */
-	ret = 0;
+	release_probes(old);
+	return 0;
 end:
 	mutex_unlock(&tracepoints_mutex);
 	return ret;

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
