Return-Path: <linux-kernel-owner+w=401wt.eu-S1753535AbYI2IDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbYI2IDI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 04:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbYI2ICy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 04:02:54 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57977 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751611AbYI2ICx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 04:02:53 -0400
Message-ID: <48E08B05.7030802@cn.fujitsu.com>
Date: Mon, 29 Sep 2008 16:00:05 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] markers: fix unregister bug and reenter bug
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


unregister bug:

codes using makers are typically calling marker_probe_unregister()
and then destroying the data that marker_probe_func needs(or
unloading this module). This is bug when the corresponding
marker_probe_func is still running(on other cpus),
it is using the destroying/ed data.

we should call synchronize_sched() after marker_update_probes().

reenter bug:

marker_probe_register(), marker_probe_unregister() and
marker_probe_unregister_private_data() are not reentrant safe
functions. these 3 functions release markers_mutex and then
require it again and do "entry->oldptr = old; ...", but entry->oldptr
maybe is using now for these 3 functions may reenter when markers_mutex
is released.

we use synchronize_sched() instead of call_rcu_sched() to fix
this bug. actually we can do:
"
if (entry->rcu_pending)
		rcu_barrier_sched();
"
after require markers_mutex again. but synchronize_sched()
is better and simpler. For these 3 functions are not critical path.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/marker.c b/kernel/marker.c
index 7d1faec..9f76c4a 100644
--- a/kernel/marker.c
+++ b/kernel/marker.c
@@ -60,9 +60,6 @@ struct marker_entry {
 	struct marker_probe_closure single;
 	struct marker_probe_closure *multi;
 	int refcount;	/* Number of times armed. 0 if disarmed. */
-	struct rcu_head rcu;
-	void *oldptr;
-	unsigned char rcu_pending:1;
 	unsigned char ptype:1;
 	char name[0];	/* Contains name'\0'format'\0' */
 };
@@ -199,16 +196,6 @@ void marker_probe_cb_noarg(const struct marker *mdata, void *call_private, ...)
 }
 EXPORT_SYMBOL_GPL(marker_probe_cb_noarg);
 
-static void free_old_closure(struct rcu_head *head)
-{
-	struct marker_entry *entry = container_of(head,
-		struct marker_entry, rcu);
-	kfree(entry->oldptr);
-	/* Make sure we free the data before setting the pending flag to 0 */
-	smp_wmb();
-	entry->rcu_pending = 0;
-}
-
 static void debug_print_probes(struct marker_entry *entry)
 {
 	int i;
@@ -417,7 +404,6 @@ static struct marker_entry *add_marker(const char *name, const char *format)
 	e->multi = NULL;
 	e->ptype = 0;
 	e->refcount = 0;
-	e->rcu_pending = 0;
 	hlist_add_head(&e->hlist, head);
 	return e;
 }
@@ -447,9 +433,6 @@ static int remove_marker(const char *name)
 	if (e->single.func != __mark_empty_function)
 		return -EBUSY;
 	hlist_del(&e->hlist);
-	/* Make sure the call_rcu has been executed */
-	if (e->rcu_pending)
-		rcu_barrier_sched();
 	kfree(e);
 	return 0;
 }
@@ -479,12 +462,8 @@ static int marker_set_format(struct marker_entry **entry, const char *format)
 	e->multi = (*entry)->multi;
 	e->ptype = (*entry)->ptype;
 	e->refcount = (*entry)->refcount;
-	e->rcu_pending = 0;
 	hlist_add_before(&e->hlist, &(*entry)->hlist);
 	hlist_del(&(*entry)->hlist);
-	/* Make sure the call_rcu has been executed */
-	if ((*entry)->rcu_pending)
-		rcu_barrier_sched();
 	kfree(*entry);
 	*entry = e;
 	trace_mark(core_marker_format, "name %s format %s",
@@ -658,12 +637,6 @@ int marker_probe_register(const char *name, const char *format,
 			goto end;
 		}
 	}
-	/*
-	 * If we detect that a call_rcu is pending for this marker,
-	 * make sure it's executed now.
-	 */
-	if (entry->rcu_pending)
-		rcu_barrier_sched();
 	old = marker_entry_add_probe(entry, probe, probe_private);
 	if (IS_ERR(old)) {
 		ret = PTR_ERR(old);
@@ -671,14 +644,11 @@ int marker_probe_register(const char *name, const char *format,
 	}
 	mutex_unlock(&markers_mutex);
 	marker_update_probes();		/* may update entry */
+	synchronize_sched();
+	kfree(old);
 	mutex_lock(&markers_mutex);
 	entry = get_marker(name);
 	WARN_ON(!entry);
-	entry->oldptr = old;
-	entry->rcu_pending = 1;
-	/* write rcu_pending before calling the RCU callback */
-	smp_wmb();
-	call_rcu_sched(&entry->rcu, free_old_closure);
 end:
 	mutex_unlock(&markers_mutex);
 	return ret;
@@ -708,20 +678,15 @@ int marker_probe_unregister(const char *name,
 	entry = get_marker(name);
 	if (!entry)
 		goto end;
-	if (entry->rcu_pending)
-		rcu_barrier_sched();
 	old = marker_entry_remove_probe(entry, probe, probe_private);
 	mutex_unlock(&markers_mutex);
 	marker_update_probes();		/* may update entry */
+	synchronize_sched();
+	kfree(old);
 	mutex_lock(&markers_mutex);
 	entry = get_marker(name);
 	if (!entry)
 		goto end;
-	entry->oldptr = old;
-	entry->rcu_pending = 1;
-	/* write rcu_pending before calling the RCU callback */
-	smp_wmb();
-	call_rcu_sched(&entry->rcu, free_old_closure);
 	remove_marker(name);	/* Ignore busy error message */
 	ret = 0;
 end:
@@ -787,19 +752,14 @@ int marker_probe_unregister_private_data(marker_probe_func *probe,
 		ret = -ENOENT;
 		goto end;
 	}
-	if (entry->rcu_pending)
-		rcu_barrier_sched();
 	old = marker_entry_remove_probe(entry, NULL, probe_private);
 	mutex_unlock(&markers_mutex);
 	marker_update_probes();		/* may update entry */
+	synchronize_sched();
+	kfree(old);
 	mutex_lock(&markers_mutex);
 	entry = get_marker_from_private_data(probe, probe_private);
 	WARN_ON(!entry);
-	entry->oldptr = old;
-	entry->rcu_pending = 1;
-	/* write rcu_pending before calling the RCU callback */
-	smp_wmb();
-	call_rcu_sched(&entry->rcu, free_old_closure);
 	remove_marker(entry->name);	/* Ignore busy error message */
 end:
 	mutex_unlock(&markers_mutex);


