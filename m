Return-Path: <linux-kernel-owner+w=401wt.eu-S1758736AbZAVRpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736AbZAVRpr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 12:45:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756288AbZAVRnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 12:43:52 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44492 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810AbZAVRnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 12:43:49 -0500
Message-Id: <20090122174053.696189652@chello.nl>
References: <20090122173701.674448070@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 22 Jan 2009 18:37:17 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC PATCH 16/19] lockdep: fully reduce mark_lock_irq()
Content-Disposition: inline; filename=lockdep-mark_irq6.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now what its only two functions, they again look rather similar.

XXX: reinstate comments!!

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/lockdep.c |   86 +++++--------------------------------------------------
 1 file changed, 8 insertions(+), 78 deletions(-)

Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -2060,13 +2060,13 @@ typedef int (*check_usage_f)(struct task
 			     enum lock_usage_bit bit, const char *name);
 
 static int
-mark_lock_irq_write(struct task_struct *curr, struct held_lock *this,
-		      int new_bit)
+mark_lock_irq(struct task_struct *curr, struct held_lock *this, int new_bit)
 {
 	const char *name = state_name(new_bit);
 	const char *rname = state_rname(new_bit);
 
 	int excl_bit = exclusive_bit(new_bit);
+	int read = new_bit & 1;
 	int dir = new_bit & 2;
 
 	check_usage_f usage = dir ?
@@ -2074,57 +2074,17 @@ mark_lock_irq_write(struct task_struct *
 
 	if (!valid_state(curr, this, new_bit, excl_bit))
 		return 0;
-	if (!valid_state(curr, this, new_bit, excl_bit + 1))
-		return 0;
 
-	/*
-	 * just marked it hardirq-safe, check that this lock
-	 * took no hardirq-unsafe lock in the past:
-	 */
-	if (!usage(curr, this, excl_bit, name))
-		return 0;
-#if STRICT_READ_CHECKS
-	/*
-	 * just marked it hardirq-safe, check that this lock
-	 * took no hardirq-unsafe-read lock in the past:
-	 */
-	if (!usage(curr, this, excl_bit + 1, rname))
+	if (!read && !valid_state(curr, this, new_bit, excl_bit + 1))
 		return 0;
-#endif
-	if (state_verbose(new_bit, hlock_class(this)))
-		return 2;
 
-	return 1;
-}
-
-static int
-mark_lock_irq_read(struct task_struct *curr, struct held_lock *this,
-			   int new_bit)
-{
-	const char *name = state_name(new_bit);
-	const char *rname = state_rname(new_bit);
-
-	int excl_bit = exclusive_bit(new_bit);
-	int dir = new_bit & 2;
-
-	if (!valid_state(curr, this, new_bit, excl_bit))
+	if ((!read || (!dir || STRICT_READ_CHECKS)) &&
+			!usage(curr, this, excl_bit, name))
 		return 0;
 
-	if (!dir) {
-		/*
-		 * just marked it hardirq-read-safe, check that this lock
-		 * took no hardirq-unsafe lock in the past:
-		 */
-		if (!check_usage_forwards(curr, this, excl_bit, name))
-			return 0;
-	} else if (STRICT_READ_CHECKS) {
-		/*
-		 * just marked it hardirq-read-unsafe, check that no
-		 * hardirq-safe lock in the system ever took it in the past:
-		 */
-		if (!check_usage_backwards(curr, this, excl_bit, name))
-			return 0;
-	}
+	if ((!read && STRICT_READ_CHECKS) &&
+			!usage(curr, this, excl_bit + 1, rname))
+		return 0;
 
 	if (state_verbose(new_bit, hlock_class(this)))
 		return 2;
@@ -2132,36 +2092,6 @@ mark_lock_irq_read(struct task_struct *c
 	return 1;
 }
 
-static int mark_lock_irq(struct task_struct *curr, struct held_lock *this,
-		enum lock_usage_bit new_bit)
-{
-	int ret = 1;
-
-	switch(new_bit) {
-	case LOCK_USED_IN_HARDIRQ:
-	case LOCK_USED_IN_SOFTIRQ:
-	case LOCK_USED_IN_RECLAIM_FS:
-	case LOCK_ENABLED_HARDIRQ:
-	case LOCK_ENABLED_SOFTIRQ:
-	case LOCK_ENABLED_RECLAIM_FS:
-		return mark_lock_irq_write(curr, this, new_bit);
-
-	case LOCK_USED_IN_HARDIRQ_READ:
-	case LOCK_USED_IN_SOFTIRQ_READ:
-	case LOCK_USED_IN_RECLAIM_FS_READ:
-	case LOCK_ENABLED_HARDIRQ_READ:
-	case LOCK_ENABLED_SOFTIRQ_READ:
-	case LOCK_ENABLED_RECLAIM_FS_READ:
-		return mark_lock_irq_read(curr, this, new_bit);
-
-	default:
-		WARN_ON(1);
-		break;
-	}
-
-	return ret;
-}
-
 enum mark_type {
 #define LOCKDEP_STATE(__STATE)	__STATE,
 #include "lockdep_states.h"

-- 

