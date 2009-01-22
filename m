Return-Path: <linux-kernel-owner+w=401wt.eu-S1758599AbZAVRqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758599AbZAVRqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 12:46:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756561AbZAVRny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 12:43:54 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44494 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838AbZAVRnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 12:43:49 -0500
Message-Id: <20090122174052.502411141@chello.nl>
References: <20090122173701.674448070@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 22 Jan 2009 18:37:06 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC PATCH 05/19] lockdep: simplify mark_held_locks
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
@@ -2077,11 +2077,19 @@ static int mark_lock_irq(struct task_str
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
@@ -2096,27 +2104,9 @@ mark_held_locks(struct task_struct *curr
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

