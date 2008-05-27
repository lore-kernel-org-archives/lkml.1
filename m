Return-Path: <linux-kernel-owner+w=401wt.eu-S1757769AbYE0NFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769AbYE0NFO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 09:05:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757123AbYE0NFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 09:05:01 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:63207 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756950AbYE0NFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 09:05:00 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlAFAKSfO0hMQWqh/2dsb2JhbACBVawF
Date: Tue, 27 May 2008 09:04:57 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul McKenney <paulmck@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH for 2.6.26] Markers Use RCU sched
Message-ID: <20080527130457.GA6814@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:44:29 up 88 days,  8:55,  4 users,  load average: 0.27, 0.60,
	0.60
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rcu_barrier_sched and call_rcu_sched has been introduced in 2.6.26 for the
Markers. Change the marker code to use them.

It can be seen as a fix since the marker code was using an ugly,
temporary, #ifdef hack to work around CONFIG_PREEMPT_RCU.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Paul McKenney <paulmck@us.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/marker.c |   25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

Index: linux-2.6-lttng/kernel/marker.c
===================================================================
--- linux-2.6-lttng.orig/kernel/marker.c	2008-05-27 05:32:09.000000000 -0400
+++ linux-2.6-lttng/kernel/marker.c	2008-05-27 05:34:22.000000000 -0400
@@ -443,7 +443,7 @@
 	hlist_del(&e->hlist);
 	/* Make sure the call_rcu has been executed */
 	if (e->rcu_pending)
-		rcu_barrier();
+		rcu_barrier_sched();
 	kfree(e);
 	return 0;
 }
@@ -478,7 +478,7 @@
 	hlist_del(&(*entry)->hlist);
 	/* Make sure the call_rcu has been executed */
 	if ((*entry)->rcu_pending)
-		rcu_barrier();
+		rcu_barrier_sched();
 	kfree(*entry);
 	*entry = e;
 	trace_mark(core_marker_format, "name %s format %s",
@@ -657,7 +657,7 @@
 	 * make sure it's executed now.
 	 */
 	if (entry->rcu_pending)
-		rcu_barrier();
+		rcu_barrier_sched();
 	old = marker_entry_add_probe(entry, probe, probe_private);
 	if (IS_ERR(old)) {
 		ret = PTR_ERR(old);
@@ -672,10 +672,7 @@
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
@@ -706,7 +703,7 @@
 	if (!entry)
 		goto end;
 	if (entry->rcu_pending)
-		rcu_barrier();
+		rcu_barrier_sched();
 	old = marker_entry_remove_probe(entry, probe, probe_private);
 	mutex_unlock(&markers_mutex);
 	marker_update_probes();		/* may update entry */
@@ -718,10 +715,7 @@
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
@@ -788,7 +782,7 @@
 		goto end;
 	}
 	if (entry->rcu_pending)
-		rcu_barrier();
+		rcu_barrier_sched();
 	old = marker_entry_remove_probe(entry, NULL, probe_private);
 	mutex_unlock(&markers_mutex);
 	marker_update_probes();		/* may update entry */
@@ -799,10 +793,7 @@
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
