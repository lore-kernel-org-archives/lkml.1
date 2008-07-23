Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbYGWWRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbYGWWRY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 18:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbYGWWRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 18:17:16 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:35646 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753928AbYGWWRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 18:17:16 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq8EAOpIh0hMRKxB/2dsb2JhbACBWrIi
Date: Wed, 23 Jul 2008 18:17:14 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Markers : fix markers read barrier for multiple probes
Message-ID: <20080723221714.GA1561@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:12:46 up 49 days,  2:53,  5 users,  load average: 0.59, 0.86,
	0.67
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul pointed out two incorrect read barriers in the marker handler code in the
path where multiple probes are connected. Those are ordering reads of "ptype"
(single or multi probe marker), "multi" array pointer, and "multi" array data
access.

It should be ordered like this :

read ptype
smp_rmb()
read multi array pointer
smp_read_barrier_depends()
access data referenced by multi array pointer

The code with a single probe connected (optimized case, does not have to
allocate an array) has correct memory ordering.

It applies to kernel 2.6.26.x, 2.6.25.x and linux-next.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
---
 kernel/marker.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

Index: linux-2.6.26-rc7-lttng/kernel/marker.c
===================================================================
--- linux-2.6.26-rc7-lttng.orig/kernel/marker.c	2008-06-25 18:09:49.000000000 -0400
+++ linux-2.6.26-rc7-lttng/kernel/marker.c	2008-06-25 18:10:57.000000000 -0400
@@ -127,6 +127,11 @@
 		struct marker_probe_closure *multi;
 		int i;
 		/*
+		 * Read mdata->ptype before mdata->multi.
+		 */
+		smp_rmb();
+		multi = mdata->multi;
+		/*
 		 * multi points to an array, therefore accessing the array
 		 * depends on reading multi. However, even in this case,
 		 * we must insure that the pointer is read _before_ the array
@@ -134,7 +139,6 @@
 		 * in the fast path, so put the explicit barrier here.
 		 */
 		smp_read_barrier_depends();
-		multi = mdata->multi;
 		for (i = 0; multi[i].func; i++) {
 			va_start(args, fmt);
 			multi[i].func(multi[i].probe_private, call_private, fmt,
@@ -177,6 +181,11 @@
 		struct marker_probe_closure *multi;
 		int i;
 		/*
+		 * Read mdata->ptype before mdata->multi.
+		 */
+		smp_rmb();
+		multi = mdata->multi;
+		/*
 		 * multi points to an array, therefore accessing the array
 		 * depends on reading multi. However, even in this case,
 		 * we must insure that the pointer is read _before_ the array
@@ -184,7 +193,6 @@
 		 * in the fast path, so put the explicit barrier here.
 		 */
 		smp_read_barrier_depends();
-		multi = mdata->multi;
 		for (i = 0; multi[i].func; i++)
 			multi[i].func(multi[i].probe_private, call_private, fmt,
 				&args);
-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
