Return-Path: <linux-kernel-owner+w=401wt.eu-S1752581AbYI3Ftu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbYI3Ftu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 01:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbYI3Ftm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 01:49:42 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:34854 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbYI3Ftl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 01:49:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArgEAKBX4UhMQWq+/2dsb2JhbACBZLl/gWc
Date: Tue, 30 Sep 2008 01:49:39 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Tracepoint use rcu sched
Message-ID: <20080930054939.GB16961@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 01:47:44 up 117 days, 10:28,  8 users,  load average: 0.11, 0.28,
	0.35
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make tracepoints use rcu sched. (cleanup)

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@elte.hu>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
---
 kernel/tracepoint.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

Index: linux-2.6-lttng/kernel/tracepoint.c
===================================================================
--- linux-2.6-lttng.orig/kernel/tracepoint.c	2008-09-30 01:36:26.000000000 -0400
+++ linux-2.6-lttng/kernel/tracepoint.c	2008-09-30 01:37:29.000000000 -0400
@@ -82,10 +82,7 @@ static void tracepoint_entry_free_old(st
 	entry->rcu_pending = 1;
 	/* write rcu_pending before calling the RCU callback */
 	smp_wmb();
-#ifdef CONFIG_PREEMPT_RCU
-	synchronize_sched();	/* Until we have the call_rcu_sched() */
-#endif
-	call_rcu(&entry->rcu, free_old_closure);
+	call_rcu_sched(&entry->rcu, free_old_closure);
 }
 
 static void debug_print_probes(struct tracepoint_entry *entry)
@@ -247,9 +244,9 @@ static int remove_tracepoint(const char 
 	if (e->refcount)
 		return -EBUSY;
 	hlist_del(&e->hlist);
-	/* Make sure the call_rcu has been executed */
+	/* Make sure the call_rcu_sched has been executed */
 	if (e->rcu_pending)
-		rcu_barrier();
+		rcu_barrier_sched();
 	kfree(e);
 	return 0;
 }
@@ -349,11 +346,11 @@ int tracepoint_probe_register(const char
 		}
 	}
 	/*
-	 * If we detect that a call_rcu is pending for this tracepoint,
+	 * If we detect that a call_rcu_sched is pending for this tracepoint,
 	 * make sure it's executed now.
 	 */
 	if (entry->rcu_pending)
-		rcu_barrier();
+		rcu_barrier_sched();
 	old = tracepoint_entry_add_probe(entry, probe);
 	if (IS_ERR(old)) {
 		ret = PTR_ERR(old);
@@ -392,7 +389,7 @@ int tracepoint_probe_unregister(const ch
 	if (!entry)
 		goto end;
 	if (entry->rcu_pending)
-		rcu_barrier();
+		rcu_barrier_sched();
 	old = tracepoint_entry_remove_probe(entry, probe);
 	mutex_unlock(&tracepoints_mutex);
 	tracepoint_update_probes();		/* may update entry */
-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
