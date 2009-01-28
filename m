Return-Path: <linux-kernel-owner+w=401wt.eu-S1757584AbZA1ODq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584AbZA1ODq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 09:03:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755186AbZA1N5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 08:57:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:47092 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466AbZA1N5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 08:57:32 -0500
Message-Id: <20090128135458.708438434@chello.nl>
References: <20090128135352.679025549@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 28 Jan 2009 14:54:07 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 15/21] lockdep: merge the !_READ mark_lock_irq() helpers
Content-Disposition: inline; filename=lockdep-mark_irq5.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two are also remakably similar

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/lockdep.c |   58 ++++++++++++++-----------------------------------------
 1 file changed, 15 insertions(+), 43 deletions(-)

Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -2057,31 +2057,39 @@ static int exclusive_bit(int new_bit)
 	return state | (dir ^ 2);
 }
 
+typedef int (*check_usage_f)(struct task_struct *, struct held_lock *,
+			     enum lock_usage_bit bit, const char *name);
+
 static int
-mark_lock_irq_used_in(struct task_struct *curr, struct held_lock *this,
+mark_lock_irq_write(struct task_struct *curr, struct held_lock *this,
 		      int new_bit)
 {
 	const char *name = state_name(new_bit);
 	const char *rname = state_rname(new_bit);
 
 	int excl_bit = exclusive_bit(new_bit);
+	int dir = new_bit & 2;
+
+	check_usage_f usage = dir ?
+		check_usage_backwards : check_usage_forwards;
 
 	if (!valid_state(curr, this, new_bit, excl_bit))
 		return 0;
 	if (!valid_state(curr, this, new_bit, excl_bit + 1))
 		return 0;
+
 	/*
 	 * just marked it hardirq-safe, check that this lock
 	 * took no hardirq-unsafe lock in the past:
 	 */
-	if (!check_usage_forwards(curr, this, excl_bit, name))
+	if (!usage(curr, this, excl_bit, name))
 		return 0;
 #if STRICT_READ_CHECKS
 	/*
 	 * just marked it hardirq-safe, check that this lock
 	 * took no hardirq-unsafe-read lock in the past:
 	 */
-	if (!check_usage_forwards(curr, this, excl_bit + 1, rname))
+	if (!usage(curr, this, excl_bit + 1, rname))
 		return 0;
 #endif
 	if (state_verbose(new_bit, hlock_class(this)))
@@ -2125,40 +2133,6 @@ mark_lock_irq_read(struct task_struct *c
 	return 1;
 }
 
-static int
-mark_lock_irq_enabled(struct task_struct *curr, struct held_lock *this,
-		      int new_bit)
-{
-	const char *name = state_name(new_bit);
-	const char *rname = state_rname(new_bit);
-
-	int excl_bit = exclusive_bit(new_bit);
-
-	if (!valid_state(curr, this, new_bit, excl_bit))
-		return 0;
-	if (!valid_state(curr, this, new_bit, excl_bit + 1))
-		return 0;
-	/*
-	 * just marked it hardirq-unsafe, check that no hardirq-safe
-	 * lock in the system ever took it in the past:
-	 */
-	if (!check_usage_backwards(curr, this, excl_bit, name))
-		return 0;
-#if STRICT_READ_CHECKS
-	/*
-	 * just marked it hardirq-unsafe, check that no
-	 * hardirq-safe-read lock in the system ever took
-	 * it in the past:
-	 */
-	if (!check_usage_backwards(curr, this, excl_bit + 1, rname))
-		return 0;
-#endif
-	if (state_verbose(new_bit, hlock_class(this)))
-		return 2;
-
-	return 1;
-}
-
 static int mark_lock_irq(struct task_struct *curr, struct held_lock *this,
 		enum lock_usage_bit new_bit)
 {
@@ -2168,7 +2142,10 @@ static int mark_lock_irq(struct task_str
 	case LOCK_USED_IN_HARDIRQ:
 	case LOCK_USED_IN_SOFTIRQ:
 	case LOCK_USED_IN_RECLAIM_FS:
-		return mark_lock_irq_used_in(curr, this, new_bit);
+	case LOCK_ENABLED_HARDIRQ:
+	case LOCK_ENABLED_SOFTIRQ:
+	case LOCK_ENABLED_RECLAIM_FS:
+		return mark_lock_irq_write(curr, this, new_bit);
 
 	case LOCK_USED_IN_HARDIRQ_READ:
 	case LOCK_USED_IN_SOFTIRQ_READ:
@@ -2178,11 +2155,6 @@ static int mark_lock_irq(struct task_str
 	case LOCK_ENABLED_RECLAIM_FS_READ:
 		return mark_lock_irq_read(curr, this, new_bit);
 
-	case LOCK_ENABLED_HARDIRQ:
-	case LOCK_ENABLED_SOFTIRQ:
-	case LOCK_ENABLED_RECLAIM_FS:
-		return mark_lock_irq_enabled(curr, this, new_bit);
-
 	default:
 		WARN_ON(1);
 		break;

-- 

