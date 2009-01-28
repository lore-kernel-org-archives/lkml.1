Return-Path: <linux-kernel-owner+w=401wt.eu-S1755252AbZA1OAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252AbZA1OAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 09:00:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755298AbZA1N5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 08:57:35 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60374 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225AbZA1N52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 08:57:28 -0500
Message-Id: <20090128135458.618245476@chello.nl>
References: <20090128135352.679025549@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 28 Jan 2009 14:54:06 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 14/21] lockdep: merge the _READ mark_lock_irq() helpers
Content-Disposition: inline; filename=lockdep-mark_irq4.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The _READ helpers show remarkable similarity, merge them.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/lockdep.c |   61 ++++++++++++++++++++-----------------------------------
 1 file changed, 23 insertions(+), 38 deletions(-)

Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -2091,22 +2091,34 @@ mark_lock_irq_used_in(struct task_struct
 }
 
 static int
-mark_lock_irq_used_in_read(struct task_struct *curr, struct held_lock *this,
+mark_lock_irq_read(struct task_struct *curr, struct held_lock *this,
 			   int new_bit)
 {
 	const char *name = state_name(new_bit);
 	const char *rname = state_rname(new_bit);
 
 	int excl_bit = exclusive_bit(new_bit);
+	int dir = new_bit & 2;
 
 	if (!valid_state(curr, this, new_bit, excl_bit))
 		return 0;
-	/*
-	 * just marked it hardirq-read-safe, check that this lock
-	 * took no hardirq-unsafe lock in the past:
-	 */
-	if (!check_usage_forwards(curr, this, excl_bit, name))
-		return 0;
+
+	if (!dir) {
+		/*
+		 * just marked it hardirq-read-safe, check that this lock
+		 * took no hardirq-unsafe lock in the past:
+		 */
+		if (!check_usage_forwards(curr, this, excl_bit, name))
+			return 0;
+	} else if (STRICT_READ_CHECKS) {
+		/*
+		 * just marked it hardirq-read-unsafe, check that no
+		 * hardirq-safe lock in the system ever took it in the past:
+		 */
+		if (!check_usage_backwards(curr, this, excl_bit, name))
+			return 0;
+	}
+
 	if (state_verbose(new_bit, hlock_class(this)))
 		return 2;
 
@@ -2147,31 +2159,6 @@ mark_lock_irq_enabled(struct task_struct
 	return 1;
 }
 
-static int
-mark_lock_irq_enabled_read(struct task_struct *curr, struct held_lock *this,
-			   int new_bit)
-{
-	const char *name = state_name(new_bit);
-	const char *rname = state_rname(new_bit);
-
-	int excl_bit = exclusive_bit(new_bit);
-
-	if (!valid_state(curr, this, new_bit, excl_bit))
-		return 0;
-#if STRICT_READ_CHECKS
-	/*
-	 * just marked it hardirq-read-unsafe, check that no
-	 * hardirq-safe lock in the system ever took it in the past:
-	 */
-	if (!check_usage_backwards(curr, this, excl_bit, name))
-		return 0;
-#endif
-	if (verbose(hlock_class(this)))
-		return 2;
-
-	return 1;
-}
-
 static int mark_lock_irq(struct task_struct *curr, struct held_lock *this,
 		enum lock_usage_bit new_bit)
 {
@@ -2186,18 +2173,16 @@ static int mark_lock_irq(struct task_str
 	case LOCK_USED_IN_HARDIRQ_READ:
 	case LOCK_USED_IN_SOFTIRQ_READ:
 	case LOCK_USED_IN_RECLAIM_FS_READ:
-		return mark_lock_irq_used_in_read(curr, this, new_bit);
+	case LOCK_ENABLED_HARDIRQ_READ:
+	case LOCK_ENABLED_SOFTIRQ_READ:
+	case LOCK_ENABLED_RECLAIM_FS_READ:
+		return mark_lock_irq_read(curr, this, new_bit);
 
 	case LOCK_ENABLED_HARDIRQ:
 	case LOCK_ENABLED_SOFTIRQ:
 	case LOCK_ENABLED_RECLAIM_FS:
 		return mark_lock_irq_enabled(curr, this, new_bit);
 
-	case LOCK_ENABLED_HARDIRQ_READ:
-	case LOCK_ENABLED_SOFTIRQ_READ:
-	case LOCK_ENABLED_RECLAIM_FS_READ:
-		return mark_lock_irq_enabled_read(curr, this, new_bit);
-
 	default:
 		WARN_ON(1);
 		break;

-- 

