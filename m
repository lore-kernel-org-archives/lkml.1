Return-Path: <linux-kernel-owner+w=401wt.eu-S1760054AbZAVRuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760054AbZAVRuA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 12:50:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757899AbZAVRoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 12:44:03 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44510 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757568AbZAVRn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 12:43:58 -0500
Message-Id: <20090122174052.846604730@chello.nl>
References: <20090122173701.674448070@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 22 Jan 2009 18:37:09 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC PATCH 08/19] lockdep: generate the state bit definitions
Content-Disposition: inline; filename=lockdep-generate8.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generate the state bit definitions from the lockdep_states.h file.

Also, move LOCK_USED to last, so that the 

 USED_IN
 USED_IN_READ
 ENABLED
 ENABLED_READ

states are nicely bit aligned -- we're going to use that property

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/lockdep_internals.h |   47 +++++++++++++++++++--------------------------
 1 file changed, 20 insertions(+), 27 deletions(-)

Index: linux-2.6/kernel/lockdep_internals.h
===================================================================
--- linux-2.6.orig/kernel/lockdep_internals.h
+++ linux-2.6/kernel/lockdep_internals.h
@@ -10,43 +10,36 @@
  * Lock-class usage-state bits:
  */
 enum lock_usage_bit {
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
+#define LOCKDEP_STATE(__STATE)		\
+	LOCK_USED_IN_##__STATE,		\
+	LOCK_USED_IN_##__STATE##_READ,	\
+	LOCK_ENABLED_##__STATE,		\
+	LOCK_ENABLED_##__STATE##_READ,
+#include "lockdep_states.h"
+#undef LOCKDEP_STATE
+	LOCK_USED,
 	LOCK_USAGE_STATES
 };
 
 /*
  * Usage-state bitmasks:
  */
-#define LOCKF_USED			(1 << LOCK_USED)
-#define LOCKF_USED_IN_HARDIRQ		(1 << LOCK_USED_IN_HARDIRQ)
-#define LOCKF_USED_IN_SOFTIRQ		(1 << LOCK_USED_IN_SOFTIRQ)
-#define LOCKF_USED_IN_RECLAIM_FS	(1 << LOCK_USED_IN_RECLAIM_FS)
-#define LOCKF_ENABLED_HARDIRQ		(1 << LOCK_ENABLED_HARDIRQ)
-#define LOCKF_ENABLED_SOFTIRQ		(1 << LOCK_ENABLED_SOFTIRQ)
-#define LOCKF_ENABLED_RECLAIM_FS	(1 << LOCK_ENABLED_RECLAIM_FS)
+#define __LOCKF(__STATE)	LOCKF_##__STATE = (1 << LOCK_##__STATE),
+
+enum {
+#define LOCKDEP_STATE(__STATE)						\
+	__LOCKF(USED_IN_##__STATE)					\
+	__LOCKF(USED_IN_##__STATE##_READ)				\
+	__LOCKF(ENABLED_##__STATE)					\
+	__LOCKF(ENABLED_##__STATE##_READ)
+#include "lockdep_states.h"
+#undef LOCKDEP_STATE
+	__LOCKF(USED)
+};
 
 #define LOCKF_ENABLED_IRQ (LOCKF_ENABLED_HARDIRQ | LOCKF_ENABLED_SOFTIRQ)
 #define LOCKF_USED_IN_IRQ (LOCKF_USED_IN_HARDIRQ | LOCKF_USED_IN_SOFTIRQ)
 
-#define LOCKF_USED_IN_HARDIRQ_READ	(1 << LOCK_USED_IN_HARDIRQ_READ)
-#define LOCKF_USED_IN_SOFTIRQ_READ	(1 << LOCK_USED_IN_SOFTIRQ_READ)
-#define LOCKF_USED_IN_RECLAIM_FS_READ	(1 << LOCK_USED_IN_RECLAIM_FS_READ)
-#define LOCKF_ENABLED_HARDIRQ_READ	(1 << LOCK_ENABLED_HARDIRQ_READ)
-#define LOCKF_ENABLED_SOFTIRQ_READ	(1 << LOCK_ENABLED_SOFTIRQ_READ)
-#define LOCKF_ENABLED_RECLAIM_FS_READ	(1 << LOCK_ENABLED_RECLAIM_FS_READ)
-
 #define LOCKF_ENABLED_IRQ_READ \
 		(LOCKF_ENABLED_HARDIRQ_READ | LOCKF_ENABLED_SOFTIRQ_READ)
 #define LOCKF_USED_IN_IRQ_READ \

-- 

