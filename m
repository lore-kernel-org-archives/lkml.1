Return-Path: <linux-kernel-owner+w=401wt.eu-S1754926AbZA1N6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926AbZA1N6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 08:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754085AbZA1N53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 08:57:29 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60371 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755180AbZA1N52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 08:57:28 -0500
Message-Id: <20090128135458.063167381@chello.nl>
References: <20090128135352.679025549@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 28 Jan 2009 14:54:00 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 08/21] lockdep: generate the state bit definitions
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

