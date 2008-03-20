Return-Path: <linux-kernel-owner+w=401wt.eu-S1760135AbYCTAqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760135AbYCTAqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:46:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967850AbYCTAoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 20:44:00 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:58477 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967842AbYCTAn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 20:43:57 -0400
Message-Id: <20080320002834.740774785@polymtl.ca>
References: <20080320002737.918213455@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 19 Mar 2008 20:27:39 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@osdl.org>,
       Mike Mason <mmlnx@us.ibm.com>, Dipankar Sarma <dipankar@in.ibm.com>,
       David Smith <dsmith@redhat.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Adrian Bunk <adrian.bunk@movial.fi>
Subject: [patch 2/4] Markers - Update preempt_disable. call_rcu, rcu_barrier comments.
Content-Disposition: inline; filename=markers-update-preempt-disable-call-rcu-rcu-barrier-comments.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu, 20 Mar 2008 00:28:36 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add comments requested by Andrew.
Updated comments about synchronize_sched(). Since we use call_rcu and
rcu_barrier now, these comments were out of sync with the code.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Christoph Hellwig <hch@infradead.org>
CC: Andrew Morton <akpm@osdl.org>
CC: Mike Mason <mmlnx@us.ibm.com>
CC: Dipankar Sarma <dipankar@in.ibm.com>
CC: David Smith <dsmith@redhat.com>
CC: "Paul E. McKenney" <paulmck@us.ibm.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Adrian Bunk <adrian.bunk@movial.fi>
---
 kernel/marker.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

Index: linux-2.6-lttng/kernel/marker.c
===================================================================
--- linux-2.6-lttng.orig/kernel/marker.c	2008-03-19 18:26:47.000000000 -0400
+++ linux-2.6-lttng/kernel/marker.c	2008-03-19 18:30:26.000000000 -0400
@@ -104,9 +104,9 @@ void marker_probe_cb(const struct marker
 	char ptype;
 
 	/*
-	 * disabling preemption to make sure the teardown of the callbacks can
-	 * be done correctly when they are in modules and they insure RCU read
-	 * coherency.
+	 * preempt_disable does two things : disabling preemption to make sure
+	 * the teardown of the callbacks can be done correctly when they are in
+	 * modules and they insure RCU read coherency.
 	 */
 	preempt_disable();
 	ptype = ACCESS_ONCE(mdata->ptype);
@@ -551,9 +551,9 @@ static int set_marker(struct marker_entr
 
 /*
  * Disable a marker and its probe callback.
- * Note: only after a synchronize_sched() issued after setting elem->call to the
- * empty function insures that the original callback is not used anymore. This
- * insured by preemption disabling around the call site.
+ * Note: only waiting an RCU period after setting elem->call to the empty
+ * function insures that the original callback is not used anymore. This insured
+ * by preempt_disable around the call site.
  */
 static void disable_marker(struct marker *elem)
 {
@@ -565,8 +565,8 @@ static void disable_marker(struct marker
 	elem->ptype = 0;	/* single probe */
 	/*
 	 * Leave the private data and id there, because removal is racy and
-	 * should be done only after a synchronize_sched(). These are never used
-	 * until the next initialization anyway.
+	 * should be done only after an RCU period. These are never used until
+	 * the next initialization anyway.
 	 */
 }
 
@@ -601,9 +601,6 @@ void marker_update_probe_range(struct ma
 
 /*
  * Update probes, removing the faulty probes.
- * Issues a synchronize_sched() when no reference to the module passed
- * as parameter is found in the probes so the probe module can be
- * safely unloaded from now on.
  *
  * Internal callback only changed before the first probe is connected to it.
  * Single probe private data can only be changed on 0 -> 1 and 2 -> 1

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
