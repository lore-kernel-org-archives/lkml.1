Return-Path: <linux-kernel-owner+w=401wt.eu-S935750AbYEVNKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935750AbYEVNKj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 09:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761113AbYEVNK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 09:10:29 -0400
Received: from tomts22.bellnexxia.net ([209.226.175.184]:48140 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753229AbYEVNK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 09:10:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArwEAIcNNUhMQWqh/2dsb2JhbACBVa4A
Date: Thu, 22 May 2008 09:10:26 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Paul McKenney <paulmck@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC PATCH] Markers Use RCU sched
Message-ID: <20080522131026.GA16156@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:08:05 up 83 days,  9:19,  4 users,  load average: 0.47, 0.45,
	0.45
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rcu_barrier_sched and call_rcu_sched has been introduced in 2.6.26 for the
Markers. Change the marker code to use them.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Paul McKenney <paulmck@us.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/marker.c |   25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

Index: linux-2.6-sched-devel/kernel/marker.c
===================================================================
--- linux-2.6-sched-devel.orig/kernel/marker.c	2008-05-22 05:33:07.000000000 -0400
+++ linux-2.6-sched-devel/kernel/marker.c	2008-05-22 05:35:45.000000000 -0400
@@ -442,7 +442,7 @@
 	hlist_del(&e->hlist);
 	/* Make sure the call_rcu has been executed */
 	if (e->rcu_pending)
-		rcu_barrier();
+		rcu_barrier_sched();
 	kfree(e);
 	return 0;
 }
@@ -477,7 +477,7 @@
 	hlist_del(&(*entry)->hlist);
 	/* Make sure the call_rcu has been executed */
 	if ((*entry)->rcu_pending)
-		rcu_barrier();
+		rcu_barrier_sched();
 	kfree(*entry);
 	*entry = e;
 	trace_mark(core_marker_format, "name %s format %s",
@@ -659,7 +659,7 @@
 	 * make sure it's executed now.
 	 */
 	if (entry->rcu_pending)
-		rcu_barrier();
+		rcu_barrier_sched();
 	old = marker_entry_add_probe(entry, probe, probe_private);
 	if (IS_ERR(old)) {
 		ret = PTR_ERR(old);
@@ -674,10 +674,7 @@
 	entry->rcu_pending = 1;
 	/* write rcu_pending before calling the RCU callback */
 	smp_wmb();
-#ifdef CONFIG_PREEMPT_RCU
-	synchronize_sched();	/* Until we have the call_rcu_sched() */
-#endif
-	call_rcu(&entry->rcu, free_old_closure);
+	call_rcu_sched(&entry->rcu, free_old_closure);
 end:
 	mutex_unlock(&markers_mutex);
 	return ret;
@@ -708,7 +705,7 @@
 	if (!entry)
 		goto end;
 	if (entry->rcu_pending)
-		rcu_barrier();
+		rcu_barrier_sched();
 	old = marker_entry_remove_probe(entry, probe, probe_private);
 	mutex_unlock(&markers_mutex);
 	marker_update_probes();		/* may update entry */
@@ -720,10 +717,7 @@
 	entry->rcu_pending = 1;
 	/* write rcu_pending before calling the RCU callback */
 	smp_wmb();
-#ifdef CONFIG_PREEMPT_RCU
-	synchronize_sched();	/* Until we have the call_rcu_sched() */
-#endif
-	call_rcu(&entry->rcu, free_old_closure);
+	call_rcu_sched(&entry->rcu, free_old_closure);
 	remove_marker(name);	/* Ignore busy error message */
 	ret = 0;
 end:
@@ -790,7 +784,7 @@
 		goto end;
 	}
 	if (entry->rcu_pending)
-		rcu_barrier();
+		rcu_barrier_sched();
 	old = marker_entry_remove_probe(entry, NULL, probe_private);
 	mutex_unlock(&markers_mutex);
 	marker_update_probes();		/* may update entry */
@@ -801,10 +795,7 @@
 	entry->rcu_pending = 1;
 	/* write rcu_pending before calling the RCU callback */
 	smp_wmb();
-#ifdef CONFIG_PREEMPT_RCU
-	synchronize_sched();	/* Until we have the call_rcu_sched() */
-#endif
-	call_rcu(&entry->rcu, free_old_closure);
+	call_rcu_sched(&entry->rcu, free_old_closure);
 	remove_marker(entry->name);	/* Ignore busy error message */
 end:
 	mutex_unlock(&markers_mutex);
-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
