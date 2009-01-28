Return-Path: <linux-kernel-owner+w=401wt.eu-S1754104AbZA1N6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbZA1N6k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 08:58:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755238AbZA1N5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 08:57:30 -0500
Received: from casper.infradead.org ([85.118.1.10]:47078 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167AbZA1N52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 08:57:28 -0500
Message-Id: <20090128135457.796031542@chello.nl>
References: <20090128135352.679025549@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 28 Jan 2009 14:53:57 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 05/21] lockdep: simplify mark_held_locks
Content-Disposition: inline; filename=lockdep-generate5.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove the explicit state iteration

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/lockdep.c |   38 ++++++++++++++------------------------
 1 file changed, 14 insertions(+), 24 deletions(-)

Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -2253,11 +2253,19 @@ static int mark_lock_irq(struct task_str
 }
 
 enum mark_type {
-	HARDIRQ,
-	SOFTIRQ,
-	RECLAIM_FS,
+#define LOCKDEP_STATE(__STATE)	__STATE,
+#include "lockdep_states.h"
+#undef LOCKDEP_STATE
 };
 
+#define MARK_HELD_CASE(__STATE)						\
+	case __STATE:							\
+		if (hlock->read)					\
+			usage_bit = LOCK_ENABLED_##__STATE##_READ;	\
+		else							\
+			usage_bit = LOCK_ENABLED_##__STATE;		\
+		break;
+
 /*
  * Mark all held locks with a usage bit:
  */
@@ -2272,27 +2280,9 @@ mark_held_locks(struct task_struct *curr
 		hlock = curr->held_locks + i;
 
 		switch (mark) {
-		case HARDIRQ:
-			if (hlock->read)
-				usage_bit = LOCK_ENABLED_HARDIRQ_READ;
-			else
-				usage_bit = LOCK_ENABLED_HARDIRQ;
-			break;
-
-		case SOFTIRQ:
-			if (hlock->read)
-				usage_bit = LOCK_ENABLED_SOFTIRQ_READ;
-			else
-				usage_bit = LOCK_ENABLED_SOFTIRQ;
-			break;
-
-		case RECLAIM_FS:
-			if (hlock->read)
-				usage_bit = LOCK_ENABLED_RECLAIM_FS_READ;
-			else
-				usage_bit = LOCK_ENABLED_RECLAIM_FS;
-			break;
-
+#define LOCKDEP_STATE(__STATE) MARK_HELD_CASE(__STATE)
+#include "lockdep_states.h"
+#undef LOCKDEP_STATE
 		default:
 			BUG();
 		}

-- 

