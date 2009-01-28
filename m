Return-Path: <linux-kernel-owner+w=401wt.eu-S1755927AbZA1OCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbZA1OCz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 09:02:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755366AbZA1N5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 08:57:40 -0500
Received: from casper.infradead.org ([85.118.1.10]:47090 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186AbZA1N5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 08:57:31 -0500
Message-Id: <20090128135458.250139192@chello.nl>
References: <20090128135352.679025549@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 28 Jan 2009 14:54:02 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 10/21] lockdep: split up mark_lock_irq()
Content-Disposition: inline; filename=lockdep-mark_irq.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

split mark_lock_irq() into 4 simple helper functions

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/lockdep.c |  372 +++++++++++++++++++++----------------------------------
 1 file changed, 147 insertions(+), 225 deletions(-)

Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -2001,6 +2001,109 @@ static int reclaim_verbose(struct lock_c
 
 #define STRICT_READ_CHECKS	1
 
+static int
+mark_lock_irq_used_in(struct task_struct *curr, struct held_lock *this,
+		      int new_bit, int excl_bit,
+		      const char *name, const char *rname,
+		      int (*verbose)(struct lock_class *class))
+{
+	if (!valid_state(curr, this, new_bit, excl_bit))
+		return 0;
+	if (!valid_state(curr, this, new_bit, excl_bit + 1))
+		return 0;
+	/*
+	 * just marked it hardirq-safe, check that this lock
+	 * took no hardirq-unsafe lock in the past:
+	 */
+	if (!check_usage_forwards(curr, this, excl_bit, name))
+		return 0;
+#if STRICT_READ_CHECKS
+	/*
+	 * just marked it hardirq-safe, check that this lock
+	 * took no hardirq-unsafe-read lock in the past:
+	 */
+	if (!check_usage_forwards(curr, this, excl_bit + 1, rname))
+		return 0;
+#endif
+	if (verbose(hlock_class(this)))
+		return 2;
+
+	return 1;
+}
+
+static int
+mark_lock_irq_used_in_read(struct task_struct *curr, struct held_lock *this,
+			   int new_bit, int excl_bit,
+			   const char *name, const char *rname,
+			   int (*verbose)(struct lock_class *class))
+{
+	if (!valid_state(curr, this, new_bit, excl_bit))
+		return 0;
+	/*
+	 * just marked it hardirq-read-safe, check that this lock
+	 * took no hardirq-unsafe lock in the past:
+	 */
+	if (!check_usage_forwards(curr, this, excl_bit, name))
+		return 0;
+	if (verbose(hlock_class(this)))
+		return 2;
+
+	return 1;
+}
+
+static int
+mark_lock_irq_enabled(struct task_struct *curr, struct held_lock *this,
+		      int new_bit, int excl_bit,
+		      const char *name, const char *rname,
+		      int (*verbose)(struct lock_class *class))
+{
+	if (!valid_state(curr, this, new_bit, excl_bit))
+		return 0;
+	if (!valid_state(curr, this, new_bit, excl_bit + 1))
+		return 0;
+	/*
+	 * just marked it hardirq-unsafe, check that no hardirq-safe
+	 * lock in the system ever took it in the past:
+	 */
+	if (!check_usage_backwards(curr, this, excl_bit, name))
+		return 0;
+#if STRICT_READ_CHECKS
+	/*
+	 * just marked it hardirq-unsafe, check that no
+	 * hardirq-safe-read lock in the system ever took
+	 * it in the past:
+	 */
+	if (!check_usage_backwards(curr, this, excl_bit + 1, rname))
+		return 0;
+#endif
+	if (verbose(hlock_class(this)))
+		return 2;
+
+	return 1;
+}
+
+static int
+mark_lock_irq_enabled_read(struct task_struct *curr, struct held_lock *this,
+			   int new_bit, int excl_bit,
+			   const char *name, const char *rname,
+			   int (*verbose)(struct lock_class *class))
+{
+	if (!valid_state(curr, this, new_bit, excl_bit))
+		return 0;
+#if STRICT_READ_CHECKS
+	/*
+	 * just marked it hardirq-read-unsafe, check that no
+	 * hardirq-safe lock in the system ever took it in the past:
+	 */
+	if (!check_usage_backwards(curr, this, excl_bit, name))
+		return 0;
+#endif
+	if (verbose(hlock_class(this)))
+		return 2;
+
+	return 1;
+}
+
 static int mark_lock_irq(struct task_struct *curr, struct held_lock *this,
 		enum lock_usage_bit new_bit)
 {
@@ -2008,242 +2111,61 @@ static int mark_lock_irq(struct task_str
 
 	switch(new_bit) {
 	case LOCK_USED_IN_HARDIRQ:
-		if (!valid_state(curr, this, new_bit, LOCK_ENABLED_HARDIRQ))
-			return 0;
-		if (!valid_state(curr, this, new_bit,
-				 LOCK_ENABLED_HARDIRQ_READ))
-			return 0;
-		/*
-		 * just marked it hardirq-safe, check that this lock
-		 * took no hardirq-unsafe lock in the past:
-		 */
-		if (!check_usage_forwards(curr, this,
-					  LOCK_ENABLED_HARDIRQ, "hard"))
-			return 0;
-#if STRICT_READ_CHECKS
-		/*
-		 * just marked it hardirq-safe, check that this lock
-		 * took no hardirq-unsafe-read lock in the past:
-		 */
-		if (!check_usage_forwards(curr, this,
-				LOCK_ENABLED_HARDIRQ_READ, "hard-read"))
-			return 0;
-#endif
-		if (hardirq_verbose(hlock_class(this)))
-			ret = 2;
-		break;
+		return mark_lock_irq_used_in(curr, this, new_bit,
+				LOCK_ENABLED_HARDIRQ,
+				"hard", "hard-read", hardirq_verbose);
 	case LOCK_USED_IN_SOFTIRQ:
-		if (!valid_state(curr, this, new_bit, LOCK_ENABLED_SOFTIRQ))
-			return 0;
-		if (!valid_state(curr, this, new_bit,
-				 LOCK_ENABLED_SOFTIRQ_READ))
-			return 0;
-		/*
-		 * just marked it softirq-safe, check that this lock
-		 * took no softirq-unsafe lock in the past:
-		 */
-		if (!check_usage_forwards(curr, this,
-					  LOCK_ENABLED_SOFTIRQ, "soft"))
-			return 0;
-#if STRICT_READ_CHECKS
-		/*
-		 * just marked it softirq-safe, check that this lock
-		 * took no softirq-unsafe-read lock in the past:
-		 */
-		if (!check_usage_forwards(curr, this,
-				LOCK_ENABLED_SOFTIRQ_READ, "soft-read"))
-			return 0;
-#endif
-		if (softirq_verbose(hlock_class(this)))
-			ret = 2;
-		break;
+		return mark_lock_irq_used_in(curr, this, new_bit,
+				LOCK_ENABLED_SOFTIRQ,
+				"soft", "soft-read", softirq_verbose);
 	case LOCK_USED_IN_RECLAIM_FS:
-		if (!valid_state(curr, this, new_bit, LOCK_ENABLED_RECLAIM_FS))
-			return 0;
-		if (!valid_state(curr, this, new_bit,
-				 LOCK_ENABLED_RECLAIM_FS_READ))
-			return 0;
-		/*
-		 * just marked it reclaim-fs-safe, check that this lock
-		 * took no reclaim-fs-unsafe lock in the past:
-		 */
-		if (!check_usage_forwards(curr, this,
-					  LOCK_ENABLED_RECLAIM_FS, "reclaim-fs"))
-			return 0;
-#if STRICT_READ_CHECKS
-		/*
-		 * just marked it reclaim-fs-safe, check that this lock
-		 * took no reclaim-fs-unsafe-read lock in the past:
-		 */
-		if (!check_usage_forwards(curr, this,
-				LOCK_ENABLED_RECLAIM_FS_READ, "reclaim-fs-read"))
-			return 0;
-#endif
-		if (reclaim_verbose(hlock_class(this)))
-			ret = 2;
-		break;
+		return mark_lock_irq_used_in(curr, this, new_bit,
+				LOCK_ENABLED_RECLAIM_FS,
+				"reclaim-fs", "reclaim-fs-read",
+				reclaim_verbose);
+
 	case LOCK_USED_IN_HARDIRQ_READ:
-		if (!valid_state(curr, this, new_bit, LOCK_ENABLED_HARDIRQ))
-			return 0;
-		/*
-		 * just marked it hardirq-read-safe, check that this lock
-		 * took no hardirq-unsafe lock in the past:
-		 */
-		if (!check_usage_forwards(curr, this,
-					  LOCK_ENABLED_HARDIRQ, "hard"))
-			return 0;
-		if (hardirq_verbose(hlock_class(this)))
-			ret = 2;
-		break;
+		return mark_lock_irq_used_in_read(curr, this, new_bit,
+				LOCK_ENABLED_HARDIRQ,
+				"hard", "hard-read", hardirq_verbose);
 	case LOCK_USED_IN_SOFTIRQ_READ:
-		if (!valid_state(curr, this, new_bit, LOCK_ENABLED_SOFTIRQ))
-			return 0;
-		/*
-		 * just marked it softirq-read-safe, check that this lock
-		 * took no softirq-unsafe lock in the past:
-		 */
-		if (!check_usage_forwards(curr, this,
-					  LOCK_ENABLED_SOFTIRQ, "soft"))
-			return 0;
-		if (softirq_verbose(hlock_class(this)))
-			ret = 2;
-		break;
+		return mark_lock_irq_used_in_read(curr, this, new_bit,
+				LOCK_ENABLED_SOFTIRQ,
+				"soft", "soft-read", softirq_verbose);
 	case LOCK_USED_IN_RECLAIM_FS_READ:
-		if (!valid_state(curr, this, new_bit, LOCK_ENABLED_RECLAIM_FS))
-			return 0;
-		/*
-		 * just marked it reclaim-fs-read-safe, check that this lock
-		 * took no reclaim-fs-unsafe lock in the past:
-		 */
-		if (!check_usage_forwards(curr, this,
-					  LOCK_ENABLED_RECLAIM_FS, "reclaim-fs"))
-			return 0;
-		if (reclaim_verbose(hlock_class(this)))
-			ret = 2;
-		break;
+		return mark_lock_irq_used_in_read(curr, this, new_bit,
+				LOCK_ENABLED_RECLAIM_FS,
+				"reclaim-fs", "reclaim-fs-read",
+				reclaim_verbose);
+
 	case LOCK_ENABLED_HARDIRQ:
-		if (!valid_state(curr, this, new_bit, LOCK_USED_IN_HARDIRQ))
-			return 0;
-		if (!valid_state(curr, this, new_bit,
-				 LOCK_USED_IN_HARDIRQ_READ))
-			return 0;
-		/*
-		 * just marked it hardirq-unsafe, check that no hardirq-safe
-		 * lock in the system ever took it in the past:
-		 */
-		if (!check_usage_backwards(curr, this,
-					   LOCK_USED_IN_HARDIRQ, "hard"))
-			return 0;
-#if STRICT_READ_CHECKS
-		/*
-		 * just marked it hardirq-unsafe, check that no
-		 * hardirq-safe-read lock in the system ever took
-		 * it in the past:
-		 */
-		if (!check_usage_backwards(curr, this,
-				   LOCK_USED_IN_HARDIRQ_READ, "hard-read"))
-			return 0;
-#endif
-		if (hardirq_verbose(hlock_class(this)))
-			ret = 2;
-		break;
+		return mark_lock_irq_enabled(curr, this, new_bit,
+				LOCK_USED_IN_HARDIRQ,
+				"hard", "hard-read", hardirq_verbose);
 	case LOCK_ENABLED_SOFTIRQ:
-		if (!valid_state(curr, this, new_bit, LOCK_USED_IN_SOFTIRQ))
-			return 0;
-		if (!valid_state(curr, this, new_bit,
-				 LOCK_USED_IN_SOFTIRQ_READ))
-			return 0;
-		/*
-		 * just marked it softirq-unsafe, check that no softirq-safe
-		 * lock in the system ever took it in the past:
-		 */
-		if (!check_usage_backwards(curr, this,
-					   LOCK_USED_IN_SOFTIRQ, "soft"))
-			return 0;
-#if STRICT_READ_CHECKS
-		/*
-		 * just marked it softirq-unsafe, check that no
-		 * softirq-safe-read lock in the system ever took
-		 * it in the past:
-		 */
-		if (!check_usage_backwards(curr, this,
-				   LOCK_USED_IN_SOFTIRQ_READ, "soft-read"))
-			return 0;
-#endif
-		if (softirq_verbose(hlock_class(this)))
-			ret = 2;
-		break;
+		return mark_lock_irq_enabled(curr, this, new_bit,
+				LOCK_USED_IN_SOFTIRQ,
+				"soft", "soft-read", softirq_verbose);
 	case LOCK_ENABLED_RECLAIM_FS:
-		if (!valid_state(curr, this, new_bit, LOCK_USED_IN_RECLAIM_FS))
-			return 0;
-		if (!valid_state(curr, this, new_bit,
-				 LOCK_USED_IN_RECLAIM_FS_READ))
-			return 0;
-		/*
-		 * just marked it reclaim-fs-unsafe, check that no reclaim-fs-safe
-		 * lock in the system ever took it in the past:
-		 */
-		if (!check_usage_backwards(curr, this,
-					   LOCK_USED_IN_RECLAIM_FS, "reclaim-fs"))
-			return 0;
-#if STRICT_READ_CHECKS
-		/*
-		 * just marked it softirq-unsafe, check that no
-		 * softirq-safe-read lock in the system ever took
-		 * it in the past:
-		 */
-		if (!check_usage_backwards(curr, this,
-				   LOCK_USED_IN_RECLAIM_FS_READ, "reclaim-fs-read"))
-			return 0;
-#endif
-		if (reclaim_verbose(hlock_class(this)))
-			ret = 2;
-		break;
+		return mark_lock_irq_enabled(curr, this, new_bit,
+				LOCK_USED_IN_RECLAIM_FS,
+				"reclaim-fs", "reclaim-fs-read",
+				reclaim_verbose);
+
 	case LOCK_ENABLED_HARDIRQ_READ:
-		if (!valid_state(curr, this, new_bit, LOCK_USED_IN_HARDIRQ))
-			return 0;
-#if STRICT_READ_CHECKS
-		/*
-		 * just marked it hardirq-read-unsafe, check that no
-		 * hardirq-safe lock in the system ever took it in the past:
-		 */
-		if (!check_usage_backwards(curr, this,
-					   LOCK_USED_IN_HARDIRQ, "hard"))
-			return 0;
-#endif
-		if (hardirq_verbose(hlock_class(this)))
-			ret = 2;
-		break;
+		return mark_lock_irq_enabled_read(curr, this, new_bit,
+				LOCK_USED_IN_HARDIRQ,
+				"hard", "hard-read", hardirq_verbose);
 	case LOCK_ENABLED_SOFTIRQ_READ:
-		if (!valid_state(curr, this, new_bit, LOCK_USED_IN_SOFTIRQ))
-			return 0;
-#if STRICT_READ_CHECKS
-		/*
-		 * just marked it softirq-read-unsafe, check that no
-		 * softirq-safe lock in the system ever took it in the past:
-		 */
-		if (!check_usage_backwards(curr, this,
-					   LOCK_USED_IN_SOFTIRQ, "soft"))
-			return 0;
-#endif
-		if (softirq_verbose(hlock_class(this)))
-			ret = 2;
-		break;
+		return mark_lock_irq_enabled_read(curr, this, new_bit,
+				LOCK_USED_IN_SOFTIRQ,
+				"soft", "soft-read", softirq_verbose);
 	case LOCK_ENABLED_RECLAIM_FS_READ:
-		if (!valid_state(curr, this, new_bit, LOCK_USED_IN_RECLAIM_FS))
-			return 0;
-#if STRICT_READ_CHECKS
-		/*
-		 * just marked it reclaim-fs-read-unsafe, check that no
-		 * reclaim-fs-safe lock in the system ever took it in the past:
-		 */
-		if (!check_usage_backwards(curr, this,
-					   LOCK_USED_IN_RECLAIM_FS, "reclaim-fs"))
-			return 0;
-#endif
-		if (reclaim_verbose(hlock_class(this)))
-			ret = 2;
-		break;
+		return mark_lock_irq_enabled_read(curr, this, new_bit,
+				LOCK_USED_IN_RECLAIM_FS,
+				"reclaim-fs", "reclaim-fs-read",
+				reclaim_verbose);
+
 	default:
 		WARN_ON(1);
 		break;

-- 

