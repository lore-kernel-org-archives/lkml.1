Return-Path: <linux-kernel-owner+w=401wt.eu-S1756201AbZA1N67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201AbZA1N67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 08:58:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbZA1N5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 08:57:31 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60372 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186AbZA1N52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 08:57:28 -0500
Message-Id: <20090128135457.973981949@chello.nl>
References: <20090128135352.679025549@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 28 Jan 2009 14:53:59 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 07/21] lockdep: move state bit definitions around
Content-Disposition: inline; filename=lockdep-generate7.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For convenience later.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/lockdep.h    |   49 +++------------------------------------------
 kernel/lockdep_internals.h |   46 ++++++++++++++++++++++++++++++++++++++++++
 kernel/lockdep_states.h    |    6 +++++
 3 files changed, 56 insertions(+), 45 deletions(-)

Index: linux-2.6/kernel/lockdep_internals.h
===================================================================
--- linux-2.6.orig/kernel/lockdep_internals.h
+++ linux-2.6/kernel/lockdep_internals.h
@@ -7,6 +7,52 @@
  */
 
 /*
+ * Lock-class usage-state bits:
+ */
+enum lock_usage_bit {
+	LOCK_USED = 0,
+	LOCK_USED_IN_HARDIRQ,
+	LOCK_USED_IN_SOFTIRQ,
+	LOCK_USED_IN_RECLAIM_FS,
+	LOCK_ENABLED_SOFTIRQ,
+	LOCK_ENABLED_HARDIRQ,
+	LOCK_ENABLED_RECLAIM_FS,
+	LOCK_USED_IN_HARDIRQ_READ,
+	LOCK_USED_IN_SOFTIRQ_READ,
+	LOCK_USED_IN_RECLAIM_FS_READ,
+	LOCK_ENABLED_SOFTIRQ_READ,
+	LOCK_ENABLED_HARDIRQ_READ,
+	LOCK_ENABLED_RECLAIM_FS_READ,
+	LOCK_USAGE_STATES
+};
+
+/*
+ * Usage-state bitmasks:
+ */
+#define LOCKF_USED			(1 << LOCK_USED)
+#define LOCKF_USED_IN_HARDIRQ		(1 << LOCK_USED_IN_HARDIRQ)
+#define LOCKF_USED_IN_SOFTIRQ		(1 << LOCK_USED_IN_SOFTIRQ)
+#define LOCKF_USED_IN_RECLAIM_FS	(1 << LOCK_USED_IN_RECLAIM_FS)
+#define LOCKF_ENABLED_HARDIRQ		(1 << LOCK_ENABLED_HARDIRQ)
+#define LOCKF_ENABLED_SOFTIRQ		(1 << LOCK_ENABLED_SOFTIRQ)
+#define LOCKF_ENABLED_RECLAIM_FS	(1 << LOCK_ENABLED_RECLAIM_FS)
+
+#define LOCKF_ENABLED_IRQ (LOCKF_ENABLED_HARDIRQ | LOCKF_ENABLED_SOFTIRQ)
+#define LOCKF_USED_IN_IRQ (LOCKF_USED_IN_HARDIRQ | LOCKF_USED_IN_SOFTIRQ)
+
+#define LOCKF_USED_IN_HARDIRQ_READ	(1 << LOCK_USED_IN_HARDIRQ_READ)
+#define LOCKF_USED_IN_SOFTIRQ_READ	(1 << LOCK_USED_IN_SOFTIRQ_READ)
+#define LOCKF_USED_IN_RECLAIM_FS_READ	(1 << LOCK_USED_IN_RECLAIM_FS_READ)
+#define LOCKF_ENABLED_HARDIRQ_READ	(1 << LOCK_ENABLED_HARDIRQ_READ)
+#define LOCKF_ENABLED_SOFTIRQ_READ	(1 << LOCK_ENABLED_SOFTIRQ_READ)
+#define LOCKF_ENABLED_RECLAIM_FS_READ	(1 << LOCK_ENABLED_RECLAIM_FS_READ)
+
+#define LOCKF_ENABLED_IRQ_READ \
+		(LOCKF_ENABLED_HARDIRQ_READ | LOCKF_ENABLED_SOFTIRQ_READ)
+#define LOCKF_USED_IN_IRQ_READ \
+		(LOCKF_USED_IN_HARDIRQ_READ | LOCKF_USED_IN_SOFTIRQ_READ)
+
+/*
  * MAX_LOCKDEP_ENTRIES is the maximum number of lock dependencies
  * we track.
  *
Index: linux-2.6/include/linux/lockdep.h
===================================================================
--- linux-2.6.orig/include/linux/lockdep.h
+++ linux-2.6/include/linux/lockdep.h
@@ -20,51 +20,10 @@ struct lockdep_map;
 #include <linux/stacktrace.h>
 
 /*
- * Lock-class usage-state bits:
+ * We'd rather not expose kernel/lockdep_states.h this wide, but we do need
+ * the total number of states... :-(
  */
-enum lock_usage_bit
-{
-	LOCK_USED = 0,
-	LOCK_USED_IN_HARDIRQ,
-	LOCK_USED_IN_SOFTIRQ,
-	LOCK_USED_IN_RECLAIM_FS,
-	LOCK_ENABLED_SOFTIRQ,
-	LOCK_ENABLED_HARDIRQ,
-	LOCK_ENABLED_RECLAIM_FS,
-	LOCK_USED_IN_HARDIRQ_READ,
-	LOCK_USED_IN_SOFTIRQ_READ,
-	LOCK_USED_IN_RECLAIM_FS_READ,
-	LOCK_ENABLED_SOFTIRQ_READ,
-	LOCK_ENABLED_HARDIRQ_READ,
-	LOCK_ENABLED_RECLAIM_FS_READ,
-	LOCK_USAGE_STATES
-};
-
-/*
- * Usage-state bitmasks:
- */
-#define LOCKF_USED			(1 << LOCK_USED)
-#define LOCKF_USED_IN_HARDIRQ		(1 << LOCK_USED_IN_HARDIRQ)
-#define LOCKF_USED_IN_SOFTIRQ		(1 << LOCK_USED_IN_SOFTIRQ)
-#define LOCKF_USED_IN_RECLAIM_FS	(1 << LOCK_USED_IN_RECLAIM_FS)
-#define LOCKF_ENABLED_HARDIRQ		(1 << LOCK_ENABLED_HARDIRQ)
-#define LOCKF_ENABLED_SOFTIRQ		(1 << LOCK_ENABLED_SOFTIRQ)
-#define LOCKF_ENABLED_RECLAIM_FS	(1 << LOCK_ENABLED_RECLAIM_FS)
-
-#define LOCKF_ENABLED_IRQ (LOCKF_ENABLED_HARDIRQ | LOCKF_ENABLED_SOFTIRQ)
-#define LOCKF_USED_IN_IRQ (LOCKF_USED_IN_HARDIRQ | LOCKF_USED_IN_SOFTIRQ)
-
-#define LOCKF_USED_IN_HARDIRQ_READ	(1 << LOCK_USED_IN_HARDIRQ_READ)
-#define LOCKF_USED_IN_SOFTIRQ_READ	(1 << LOCK_USED_IN_SOFTIRQ_READ)
-#define LOCKF_USED_IN_RECLAIM_FS_READ	(1 << LOCK_USED_IN_RECLAIM_FS_READ)
-#define LOCKF_ENABLED_HARDIRQ_READ	(1 << LOCK_ENABLED_HARDIRQ_READ)
-#define LOCKF_ENABLED_SOFTIRQ_READ	(1 << LOCK_ENABLED_SOFTIRQ_READ)
-#define LOCKF_ENABLED_RECLAIM_FS_READ	(1 << LOCK_ENABLED_RECLAIM_FS_READ)
-
-#define LOCKF_ENABLED_IRQ_READ \
-		(LOCKF_ENABLED_HARDIRQ_READ | LOCKF_ENABLED_SOFTIRQ_READ)
-#define LOCKF_USED_IN_IRQ_READ \
-		(LOCKF_USED_IN_HARDIRQ_READ | LOCKF_USED_IN_SOFTIRQ_READ)
+#define XXX_LOCK_USAGE_STATES		(1+3*4)
 
 #define MAX_LOCKDEP_SUBCLASSES		8UL
 
@@ -105,7 +64,7 @@ struct lock_class {
 	 * IRQ/softirq usage tracking bits:
 	 */
 	unsigned long			usage_mask;
-	struct stack_trace		usage_traces[LOCK_USAGE_STATES];
+	struct stack_trace		usage_traces[XXX_LOCK_USAGE_STATES];
 
 	/*
 	 * These fields represent a directed graph of lock dependencies,
Index: linux-2.6/kernel/lockdep_states.h
===================================================================
--- linux-2.6.orig/kernel/lockdep_states.h
+++ linux-2.6/kernel/lockdep_states.h
@@ -1,3 +1,9 @@
+/*
+ * Lockdep states,
+ *
+ * please update XXX_LOCK_USAGE_STATES in include/linux/lockdep.h whenever
+ * you add one, or come up with a nice dynamic solution.
+ */
 LOCKDEP_STATE(HARDIRQ)
 LOCKDEP_STATE(SOFTIRQ)
 LOCKDEP_STATE(RECLAIM_FS)

-- 

