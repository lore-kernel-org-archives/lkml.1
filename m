Return-Path: <linux-kernel-owner+w=401wt.eu-S1756664AbYCaNQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664AbYCaNQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 09:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754948AbYCaNQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 09:16:13 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:63815 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753582AbYCaNQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 09:16:12 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvoEACqB8EdMQWoK/2dsb2JhbACBWqdMghw
Date: Mon, 31 Mar 2008 09:16:09 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH for 2.6.25] Markers - use synchronize_sched()
Message-ID: <20080331131609.GA22207@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:13:43 up 31 days,  9:24,  6 users,  load average: 1.36, 0.75,
	0.56
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use synchronize_sched before calling call_rcu in CONFIG_PREEMPT_RCU until we
have call_rcu_sched and rcu_barrier_sched in mainline. It will slow down the
marker operations in CONFIG_PREEMPT_RCU, but it fixes the current race against
the preempt_disable/enable() protected code paths.

Paul, is this ok ? It would be good to get this in for 2.6.25 final.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/marker.c |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux-2.6-lttng/kernel/marker.c
===================================================================
--- linux-2.6-lttng.orig/kernel/marker.c	2008-03-31 08:22:24.000000000 -0400
+++ linux-2.6-lttng/kernel/marker.c	2008-03-31 08:43:30.000000000 -0400
@@ -671,6 +671,9 @@ int marker_probe_register(const char *na
 	entry->rcu_pending = 1;
 	/* write rcu_pending before calling the RCU callback */
 	smp_wmb();
+#ifdef CONFIG_PREEMPT_RCU
+	synchronize_sched();	/* Until we have the call_rcu_sched() */
+#endif
 	call_rcu(&entry->rcu, free_old_closure);
 end:
 	mutex_unlock(&markers_mutex);
@@ -714,6 +717,9 @@ int marker_probe_unregister(const char *
 	entry->rcu_pending = 1;
 	/* write rcu_pending before calling the RCU callback */
 	smp_wmb();
+#ifdef CONFIG_PREEMPT_RCU
+	synchronize_sched();	/* Until we have the call_rcu_sched() */
+#endif
 	call_rcu(&entry->rcu, free_old_closure);
 	remove_marker(name);	/* Ignore busy error message */
 	ret = 0;
@@ -792,6 +798,9 @@ int marker_probe_unregister_private_data
 	entry->rcu_pending = 1;
 	/* write rcu_pending before calling the RCU callback */
 	smp_wmb();
+#ifdef CONFIG_PREEMPT_RCU
+	synchronize_sched();	/* Until we have the call_rcu_sched() */
+#endif
 	call_rcu(&entry->rcu, free_old_closure);
 	remove_marker(entry->name);	/* Ignore busy error message */
 end:
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
