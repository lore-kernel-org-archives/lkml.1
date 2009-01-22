Return-Path: <linux-kernel-owner+w=401wt.eu-S1759330AbZAVRro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759330AbZAVRro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 12:47:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756805AbZAVRn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 12:43:56 -0500
Received: from casper.infradead.org ([85.118.1.10]:37910 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755668AbZAVRnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 12:43:49 -0500
Message-Id: <20090122174052.262128471@chello.nl>
References: <20090122173701.674448070@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 22 Jan 2009 18:37:04 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC PATCH 03/19] lockdep: sanitize reclaim bit names
Content-Disposition: inline; filename=lockdep-generate2.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s/HELD_OVER/ENABLED/g

so that its similar to the hard and soft-irq names.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/lockdep.h |    8 ++++----
 kernel/lockdep.c        |   38 +++++++++++++++++++-------------------
 2 files changed, 23 insertions(+), 23 deletions(-)

Index: linux-2.6/include/linux/lockdep.h
===================================================================
--- linux-2.6.orig/include/linux/lockdep.h
+++ linux-2.6/include/linux/lockdep.h
@@ -30,13 +30,13 @@ enum lock_usage_bit
 	LOCK_USED_IN_RECLAIM_FS,
 	LOCK_ENABLED_SOFTIRQ,
 	LOCK_ENABLED_HARDIRQ,
-	LOCK_HELD_OVER_RECLAIM_FS,
+	LOCK_ENABLED_RECLAIM_FS,
 	LOCK_USED_IN_HARDIRQ_READ,
 	LOCK_USED_IN_SOFTIRQ_READ,
 	LOCK_USED_IN_RECLAIM_FS_READ,
 	LOCK_ENABLED_SOFTIRQ_READ,
 	LOCK_ENABLED_HARDIRQ_READ,
-	LOCK_HELD_OVER_RECLAIM_FS_READ,
+	LOCK_ENABLED_RECLAIM_FS_READ,
 	LOCK_USAGE_STATES
 };
 
@@ -49,7 +49,7 @@ enum lock_usage_bit
 #define LOCKF_USED_IN_RECLAIM_FS	(1 << LOCK_USED_IN_RECLAIM_FS)
 #define LOCKF_ENABLED_HARDIRQ		(1 << LOCK_ENABLED_HARDIRQ)
 #define LOCKF_ENABLED_SOFTIRQ		(1 << LOCK_ENABLED_SOFTIRQ)
-#define LOCKF_HELD_OVER_RECLAIM_FS	(1 << LOCK_HELD_OVER_RECLAIM_FS)
+#define LOCKF_ENABLED_RECLAIM_FS	(1 << LOCK_ENABLED_RECLAIM_FS)
 
 #define LOCKF_ENABLED_IRQ (LOCKF_ENABLED_HARDIRQ | LOCKF_ENABLED_SOFTIRQ)
 #define LOCKF_USED_IN_IRQ (LOCKF_USED_IN_HARDIRQ | LOCKF_USED_IN_SOFTIRQ)
@@ -59,7 +59,7 @@ enum lock_usage_bit
 #define LOCKF_USED_IN_RECLAIM_FS_READ	(1 << LOCK_USED_IN_RECLAIM_FS_READ)
 #define LOCKF_ENABLED_HARDIRQ_READ	(1 << LOCK_ENABLED_HARDIRQ_READ)
 #define LOCKF_ENABLED_SOFTIRQ_READ	(1 << LOCK_ENABLED_SOFTIRQ_READ)
-#define LOCKF_HELD_OVER_RECLAIM_FS_READ	(1 << LOCK_HELD_OVER_RECLAIM_FS_READ)
+#define LOCKF_ENABLED_RECLAIM_FS_READ	(1 << LOCK_ENABLED_RECLAIM_FS_READ)
 
 #define LOCKF_ENABLED_IRQ_READ \
 		(LOCKF_ENABLED_HARDIRQ_READ | LOCKF_ENABLED_SOFTIRQ_READ)
Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -458,8 +458,8 @@ static const char *usage_str[] =
 	[LOCK_ENABLED_HARDIRQ_READ] =	"hardirq-on-R",
 	[LOCK_USED_IN_RECLAIM_FS] =	"in-reclaim-W",
 	[LOCK_USED_IN_RECLAIM_FS_READ] = "in-reclaim-R",
-	[LOCK_HELD_OVER_RECLAIM_FS] =	"ov-reclaim-W",
-	[LOCK_HELD_OVER_RECLAIM_FS_READ] = "ov-reclaim-R",
+	[LOCK_ENABLED_RECLAIM_FS] =	"ov-reclaim-W",
+	[LOCK_ENABLED_RECLAIM_FS_READ] = "ov-reclaim-R",
 };
 
 const char * __get_key_name(struct lockdep_subclass_key *key, char *str)
@@ -504,14 +504,14 @@ get_usage_chars(struct lock_class *class
 	if (class->usage_mask & LOCKF_USED_IN_RECLAIM_FS)
 		*c5 = '+';
 	else
-		if (class->usage_mask & LOCKF_HELD_OVER_RECLAIM_FS)
+		if (class->usage_mask & LOCKF_ENABLED_RECLAIM_FS)
 			*c5 = '-';
 
-	if (class->usage_mask & LOCKF_HELD_OVER_RECLAIM_FS_READ)
+	if (class->usage_mask & LOCKF_ENABLED_RECLAIM_FS_READ)
 		*c6 = '-';
 	if (class->usage_mask & LOCKF_USED_IN_RECLAIM_FS_READ) {
 		*c6 = '+';
-		if (class->usage_mask & LOCKF_HELD_OVER_RECLAIM_FS_READ)
+		if (class->usage_mask & LOCKF_ENABLED_RECLAIM_FS_READ)
 			*c6 = '?';
 	}
 
@@ -1335,7 +1335,7 @@ check_prev_add_irq(struct task_struct *c
 	 * forwards-subgraph starting at <next>:
 	 */
 	if (!check_usage(curr, prev, next, LOCK_USED_IN_RECLAIM_FS,
-					LOCK_HELD_OVER_RECLAIM_FS, "reclaim-fs"))
+					LOCK_ENABLED_RECLAIM_FS, "reclaim-fs"))
 		return 0;
 
 	/*
@@ -1345,7 +1345,7 @@ check_prev_add_irq(struct task_struct *c
 	 * forwards-subgraph starting at <next>:
 	 */
 	if (!check_usage(curr, prev, next, LOCK_USED_IN_RECLAIM_FS_READ,
-					LOCK_HELD_OVER_RECLAIM_FS, "reclaim-fs-read"))
+					LOCK_ENABLED_RECLAIM_FS, "reclaim-fs-read"))
 		return 0;
 
 	return 1;
@@ -2058,17 +2058,17 @@ static int mark_lock_irq(struct task_str
 			ret = 2;
 		break;
 	case LOCK_USED_IN_RECLAIM_FS:
-		if (!valid_state(curr, this, new_bit, LOCK_HELD_OVER_RECLAIM_FS))
+		if (!valid_state(curr, this, new_bit, LOCK_ENABLED_RECLAIM_FS))
 			return 0;
 		if (!valid_state(curr, this, new_bit,
-				 LOCK_HELD_OVER_RECLAIM_FS_READ))
+				 LOCK_ENABLED_RECLAIM_FS_READ))
 			return 0;
 		/*
 		 * just marked it reclaim-fs-safe, check that this lock
 		 * took no reclaim-fs-unsafe lock in the past:
 		 */
 		if (!check_usage_forwards(curr, this,
-					  LOCK_HELD_OVER_RECLAIM_FS, "reclaim-fs"))
+					  LOCK_ENABLED_RECLAIM_FS, "reclaim-fs"))
 			return 0;
 #if STRICT_READ_CHECKS
 		/*
@@ -2076,7 +2076,7 @@ static int mark_lock_irq(struct task_str
 		 * took no reclaim-fs-unsafe-read lock in the past:
 		 */
 		if (!check_usage_forwards(curr, this,
-				LOCK_HELD_OVER_RECLAIM_FS_READ, "reclaim-fs-read"))
+				LOCK_ENABLED_RECLAIM_FS_READ, "reclaim-fs-read"))
 			return 0;
 #endif
 		if (reclaim_verbose(hlock_class(this)))
@@ -2109,14 +2109,14 @@ static int mark_lock_irq(struct task_str
 			ret = 2;
 		break;
 	case LOCK_USED_IN_RECLAIM_FS_READ:
-		if (!valid_state(curr, this, new_bit, LOCK_HELD_OVER_RECLAIM_FS))
+		if (!valid_state(curr, this, new_bit, LOCK_ENABLED_RECLAIM_FS))
 			return 0;
 		/*
 		 * just marked it reclaim-fs-read-safe, check that this lock
 		 * took no reclaim-fs-unsafe lock in the past:
 		 */
 		if (!check_usage_forwards(curr, this,
-					  LOCK_HELD_OVER_RECLAIM_FS, "reclaim-fs"))
+					  LOCK_ENABLED_RECLAIM_FS, "reclaim-fs"))
 			return 0;
 		if (reclaim_verbose(hlock_class(this)))
 			ret = 2;
@@ -2173,7 +2173,7 @@ static int mark_lock_irq(struct task_str
 		if (softirq_verbose(hlock_class(this)))
 			ret = 2;
 		break;
-	case LOCK_HELD_OVER_RECLAIM_FS:
+	case LOCK_ENABLED_RECLAIM_FS:
 		if (!valid_state(curr, this, new_bit, LOCK_USED_IN_RECLAIM_FS))
 			return 0;
 		if (!valid_state(curr, this, new_bit,
@@ -2229,7 +2229,7 @@ static int mark_lock_irq(struct task_str
 		if (softirq_verbose(hlock_class(this)))
 			ret = 2;
 		break;
-	case LOCK_HELD_OVER_RECLAIM_FS_READ:
+	case LOCK_ENABLED_RECLAIM_FS_READ:
 		if (!valid_state(curr, this, new_bit, LOCK_USED_IN_RECLAIM_FS))
 			return 0;
 #if STRICT_READ_CHECKS
@@ -2288,9 +2288,9 @@ mark_held_locks(struct task_struct *curr
 
 		case RECLAIM_FS:
 			if (hlock->read)
-				usage_bit = LOCK_HELD_OVER_RECLAIM_FS_READ;
+				usage_bit = LOCK_ENABLED_RECLAIM_FS_READ;
 			else
-				usage_bit = LOCK_HELD_OVER_RECLAIM_FS;
+				usage_bit = LOCK_ENABLED_RECLAIM_FS;
 			break;
 
 		default:
@@ -2641,8 +2641,8 @@ static int mark_lock(struct task_struct 
 	case LOCK_ENABLED_SOFTIRQ_READ:
 	case LOCK_USED_IN_RECLAIM_FS:
 	case LOCK_USED_IN_RECLAIM_FS_READ:
-	case LOCK_HELD_OVER_RECLAIM_FS:
-	case LOCK_HELD_OVER_RECLAIM_FS_READ:
+	case LOCK_ENABLED_RECLAIM_FS:
+	case LOCK_ENABLED_RECLAIM_FS_READ:
 		ret = mark_lock_irq(curr, this, new_bit);
 		if (!ret)
 			return 0;

-- 

