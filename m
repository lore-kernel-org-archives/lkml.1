Return-Path: <linux-kernel-owner+w=401wt.eu-S967935AbYCTAo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967935AbYCTAo7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967845AbYCTAn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 20:43:57 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:58477 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967844AbYCTAnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 20:43:55 -0400
Message-Id: <20080320002835.068766481@polymtl.ca>
References: <20080320002737.918213455@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 19 Mar 2008 20:27:40 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@osdl.org>,
       Mike Mason <mmlnx@us.ibm.com>, Dipankar Sarma <dipankar@in.ibm.com>,
       David Smith <dsmith@redhat.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Adrian Bunk <adrian.bunk@movial.fi>
Subject: [patch 3/4] Markers - Remove ACCESS_ONCE
Content-Disposition: inline; filename=markers-remove-access-once.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu, 20 Mar 2008 00:28:37 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Paul pointed out, the ACCESS_ONCE are not needed because we already have the
explicit surrounding memory barriers.

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
 kernel/marker.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux-2.6-lttng/kernel/marker.c
===================================================================
--- linux-2.6-lttng.orig/kernel/marker.c	2008-03-19 18:30:26.000000000 -0400
+++ linux-2.6-lttng/kernel/marker.c	2008-03-19 18:32:16.000000000 -0400
@@ -109,13 +109,13 @@ void marker_probe_cb(const struct marker
 	 * modules and they insure RCU read coherency.
 	 */
 	preempt_disable();
-	ptype = ACCESS_ONCE(mdata->ptype);
+	ptype = mdata->ptype;
 	if (likely(!ptype)) {
 		marker_probe_func *func;
 		/* Must read the ptype before ptr. They are not data dependant,
 		 * so we put an explicit smp_rmb() here. */
 		smp_rmb();
-		func = ACCESS_ONCE(mdata->single.func);
+		func = mdata->single.func;
 		/* Must read the ptr before private data. They are not data
 		 * dependant, so we put an explicit smp_rmb() here. */
 		smp_rmb();
@@ -133,7 +133,7 @@ void marker_probe_cb(const struct marker
 		 * in the fast path, so put the explicit barrier here.
 		 */
 		smp_read_barrier_depends();
-		multi = ACCESS_ONCE(mdata->multi);
+		multi = mdata->multi;
 		for (i = 0; multi[i].func; i++) {
 			va_start(args, fmt);
 			multi[i].func(multi[i].probe_private, call_private, fmt,
@@ -161,13 +161,13 @@ void marker_probe_cb_noarg(const struct 
 	char ptype;
 
 	preempt_disable();
-	ptype = ACCESS_ONCE(mdata->ptype);
+	ptype = mdata->ptype;
 	if (likely(!ptype)) {
 		marker_probe_func *func;
 		/* Must read the ptype before ptr. They are not data dependant,
 		 * so we put an explicit smp_rmb() here. */
 		smp_rmb();
-		func = ACCESS_ONCE(mdata->single.func);
+		func = mdata->single.func;
 		/* Must read the ptr before private data. They are not data
 		 * dependant, so we put an explicit smp_rmb() here. */
 		smp_rmb();
@@ -183,7 +183,7 @@ void marker_probe_cb_noarg(const struct 
 		 * in the fast path, so put the explicit barrier here.
 		 */
 		smp_read_barrier_depends();
-		multi = ACCESS_ONCE(mdata->multi);
+		multi = mdata->multi;
 		for (i = 0; multi[i].func; i++)
 			multi[i].func(multi[i].probe_private, call_private, fmt,
 				&args);

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
