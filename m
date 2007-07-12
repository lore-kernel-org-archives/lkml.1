Return-Path: <linux-kernel-owner+w=401wt.eu-S1763411AbXGLBBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763411AbXGLBBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 21:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761779AbXGLBBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 21:01:03 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:41772 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761186AbXGLBBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 21:01:01 -0400
Date: Wed, 11 Jul 2007 18:00:58 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, dipankar@in.ibm.com, josht@linux.vnet.ibm.com,
       akpm@linux-foundation.org
Subject: [PATCH] Immunize rcu_dereference() against crazy compiler writers
Message-ID: <20070712010058.GA30869@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Turns out that compiler writers are a bit more aggressive about optimizing
than one might expect.  This patch prevents a number of such optimizations
from messing up rcu_deference().  This is not merely a theoretical
problem, as evidenced by the rmb() in mce_log().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 rcupdate.h |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff -urpNa -X dontdiff linux-2.6.22/include/linux/rcupdate.h linux-2.6.22-volrcud/include/linux/rcupdate.h
--- linux-2.6.22/include/linux/rcupdate.h	2007-07-08 16:32:17.000000000 -0700
+++ linux-2.6.22-volrcud/include/linux/rcupdate.h	2007-07-11 17:21:09.000000000 -0700
@@ -217,6 +217,18 @@ extern int rcu_needs_cpu(int cpu);
 		local_bh_enable(); \
 	} while(0)
 
+/*
+ * Prevent the compiler from merging or refetching accesses.  The compiler
+ * is also forbidden from reordering successive instances of ACCESS_ONCE(),
+ * but only when the compiler is aware of some particular ordering.  One way
+ * to make the compiler aware of ordering is to put the two invocations of 
+ * ACCESS_ONCE() in different C statements.
+ *
+ * This macro does absolutely -nothing- to prevent the CPU from reordering,
+ * merging, or refetching absolutely anything at any time.
+ */
+#define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
+
 /**
  * rcu_dereference - fetch an RCU-protected pointer in an
  * RCU read-side critical section.  This pointer may later
@@ -228,7 +240,7 @@ extern int rcu_needs_cpu(int cpu);
  */
 
 #define rcu_dereference(p)     ({ \
-				typeof(p) _________p1 = p; \
+				typeof(p) _________p1 = ACCESS_ONCE(p); \
 				smp_read_barrier_depends(); \
 				(_________p1); \
 				})
