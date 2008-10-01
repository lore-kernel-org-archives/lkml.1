Return-Path: <linux-kernel-owner+w=401wt.eu-S1754089AbYJAQLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbYJAQLi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 12:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbYJAQL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 12:11:27 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:37896 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837AbYJAQL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 12:11:26 -0400
Message-Id: <20081001160424.944735940@polymtl.ca>
References: <20081001160324.889716972@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 01 Oct 2008 12:03:25 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [patch 1/5] Markers reenable fast batch registration
Content-Disposition: inline; filename=markers-reenable-batch-registration.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Wed,  1 Oct 2008 16:10:56 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lai Jiangshan discovered a reentrancy issue with markers and fixed it by adding
synchronize_sched() calls at each registration/unregistraiton. It works, but it
removes the ability to do batch registration/unregistration and can cause
registration of ~100 markers to take about 30 seconds on a loaded machine
(synchronize_sched() is much slower on such workloads). This patch implements a
version of the fix which won't slow down marker batch
registration/unregistration. It also go back to the original non-synchronized
reg/unreg, and thus needs the following
markers-synchronize_marker_unregister.patch patch and friends.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>
---
 kernel/marker.c |   58 ++++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 52 insertions(+), 6 deletions(-)

Index: linux-2.6-lttng/kernel/marker.c
===================================================================
--- linux-2.6-lttng.orig/kernel/marker.c	2008-10-01 11:53:42.000000000 -0400
+++ linux-2.6-lttng/kernel/marker.c	2008-10-01 11:54:10.000000000 -0400
@@ -60,6 +60,9 @@ struct marker_entry {
 	struct marker_probe_closure single;
 	struct marker_probe_closure *multi;
 	int refcount;	/* Number of times armed. 0 if disarmed. */
+	struct rcu_head rcu;
+	void *oldptr;
+	unsigned char rcu_pending:1;
 	unsigned char ptype:1;
 	char name[0];	/* Contains name'\0'format'\0' */
 };
@@ -196,6 +199,16 @@ void marker_probe_cb_noarg(const struct 
 }
 EXPORT_SYMBOL_GPL(marker_probe_cb_noarg);
 
+static void free_old_closure(struct rcu_head *head)
+{
+	struct marker_entry *entry = container_of(head,
+		struct marker_entry, rcu);
+	kfree(entry->oldptr);
+	/* Make sure we free the data before setting the pending flag to 0 */
+	smp_wmb();
+	entry->rcu_pending = 0;
+}
+
 static void debug_print_probes(struct marker_entry *entry)
 {
 	int i;
@@ -404,6 +417,7 @@ static struct marker_entry *add_marker(c
 	e->multi = NULL;
 	e->ptype = 0;
 	e->refcount = 0;
+	e->rcu_pending = 0;
 	hlist_add_head(&e->hlist, head);
 	return e;
 }
@@ -433,6 +447,9 @@ static int remove_marker(const char *nam
 	if (e->single.func != __mark_empty_function)
 		return -EBUSY;
 	hlist_del(&e->hlist);
+	/* Make sure the call_rcu has been executed */
+	if (e->rcu_pending)
+		rcu_barrier_sched();
 	kfree(e);
 	return 0;
 }
@@ -462,8 +479,12 @@ static int marker_set_format(struct mark
 	e->multi = (*entry)->multi;
 	e->ptype = (*entry)->ptype;
 	e->refcount = (*entry)->refcount;
+	e->rcu_pending = 0;
 	hlist_add_before(&e->hlist, &(*entry)->hlist);
 	hlist_del(&(*entry)->hlist);
+	/* Make sure the call_rcu has been executed */
+	if ((*entry)->rcu_pending)
+		rcu_barrier_sched();
 	kfree(*entry);
 	*entry = e;
 	trace_mark(core_marker_format, "name %s format %s",
@@ -637,6 +658,12 @@ int marker_probe_register(const char *na
 			goto end;
 		}
 	}
+	/*
+	 * If we detect that a call_rcu is pending for this marker,
+	 * make sure it's executed now.
+	 */
+	if (entry->rcu_pending)
+		rcu_barrier_sched();
 	old = marker_entry_add_probe(entry, probe, probe_private);
 	if (IS_ERR(old)) {
 		ret = PTR_ERR(old);
@@ -644,11 +671,16 @@ int marker_probe_register(const char *na
 	}
 	mutex_unlock(&markers_mutex);
 	marker_update_probes();		/* may update entry */
-	synchronize_sched();
-	kfree(old);
 	mutex_lock(&markers_mutex);
 	entry = get_marker(name);
 	WARN_ON(!entry);
+	if (entry->rcu_pending)
+		rcu_barrier_sched();
+	entry->oldptr = old;
+	entry->rcu_pending = 1;
+	/* write rcu_pending before calling the RCU callback */
+	smp_wmb();
+	call_rcu_sched(&entry->rcu, free_old_closure);
 end:
 	mutex_unlock(&markers_mutex);
 	return ret;
@@ -678,15 +710,22 @@ int marker_probe_unregister(const char *
 	entry = get_marker(name);
 	if (!entry)
 		goto end;
+	if (entry->rcu_pending)
+		rcu_barrier_sched();
 	old = marker_entry_remove_probe(entry, probe, probe_private);
 	mutex_unlock(&markers_mutex);
 	marker_update_probes();		/* may update entry */
-	synchronize_sched();
-	kfree(old);
 	mutex_lock(&markers_mutex);
 	entry = get_marker(name);
 	if (!entry)
 		goto end;
+	if (entry->rcu_pending)
+		rcu_barrier_sched();
+	entry->oldptr = old;
+	entry->rcu_pending = 1;
+	/* write rcu_pending before calling the RCU callback */
+	smp_wmb();
+	call_rcu_sched(&entry->rcu, free_old_closure);
 	remove_marker(name);	/* Ignore busy error message */
 	ret = 0;
 end:
@@ -752,14 +791,21 @@ int marker_probe_unregister_private_data
 		ret = -ENOENT;
 		goto end;
 	}
+	if (entry->rcu_pending)
+		rcu_barrier_sched();
 	old = marker_entry_remove_probe(entry, NULL, probe_private);
 	mutex_unlock(&markers_mutex);
 	marker_update_probes();		/* may update entry */
-	synchronize_sched();
-	kfree(old);
 	mutex_lock(&markers_mutex);
 	entry = get_marker_from_private_data(probe, probe_private);
 	WARN_ON(!entry);
+	if (entry->rcu_pending)
+		rcu_barrier_sched();
+	entry->oldptr = old;
+	entry->rcu_pending = 1;
+	/* write rcu_pending before calling the RCU callback */
+	smp_wmb();
+	call_rcu_sched(&entry->rcu, free_old_closure);
 	remove_marker(entry->name);	/* Ignore busy error message */
 end:
 	mutex_unlock(&markers_mutex);

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
