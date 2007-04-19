Return-Path: <linux-kernel-owner+w=401wt.eu-S1030949AbXDSLYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030949AbXDSLYa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 07:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030973AbXDSLYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 07:24:30 -0400
Received: from mx12.go2.pl ([193.17.41.142]:46074 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030949AbXDSLY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 07:24:29 -0400
Date: Thu, 19 Apr 2007 13:30:04 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] lockdep: removed unused ip argument in mark_lock & mark_held_locks
Message-ID: <20070419113004.GA7825@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It looks like a remainder from designing... (or I miss something?)

PS: patched on 2.6.21-rc7 + today's lookup_chain_cache comment errata

Signed-off-by: Jarek Poplawski <jarkao@o2.pl>

---

diff -Nurp 2.6.21-rc7-/kernel/lockdep.c 2.6.21-rc7/kernel/lockdep.c
--- 2.6.21-rc7-/kernel/lockdep.c	2007-04-19 11:25:40.000000000 +0200
+++ 2.6.21-rc7/kernel/lockdep.c	2007-04-19 12:11:47.000000000 +0200
@@ -1578,7 +1578,7 @@ valid_state(struct task_struct *curr, st
  * Mark a lock with a usage bit, and validate the state transition:
  */
 static int mark_lock(struct task_struct *curr, struct held_lock *this,
-		     enum lock_usage_bit new_bit, unsigned long ip)
+		     enum lock_usage_bit new_bit)
 {
 	unsigned int new_mask = 1 << new_bit, ret = 1;
 
@@ -1601,14 +1601,6 @@ static int mark_lock(struct task_struct 
 
 	this->class->usage_mask |= new_mask;
 
-#ifdef CONFIG_TRACE_IRQFLAGS
-	if (new_bit == LOCK_ENABLED_HARDIRQS ||
-			new_bit == LOCK_ENABLED_HARDIRQS_READ)
-		ip = curr->hardirq_enable_ip;
-	else if (new_bit == LOCK_ENABLED_SOFTIRQS ||
-			new_bit == LOCK_ENABLED_SOFTIRQS_READ)
-		ip = curr->softirq_enable_ip;
-#endif
 	if (!save_trace(this->class->usage_traces + new_bit))
 		return 0;
 
@@ -1807,7 +1799,7 @@ static int mark_lock(struct task_struct 
  * Mark all held locks with a usage bit:
  */
 static int
-mark_held_locks(struct task_struct *curr, int hardirq, unsigned long ip)
+mark_held_locks(struct task_struct *curr, int hardirq)
 {
 	enum lock_usage_bit usage_bit;
 	struct held_lock *hlock;
@@ -1827,7 +1819,7 @@ mark_held_locks(struct task_struct *curr
 			else
 				usage_bit = LOCK_ENABLED_SOFTIRQS;
 		}
-		if (!mark_lock(curr, hlock, usage_bit, ip))
+		if (!mark_lock(curr, hlock, usage_bit))
 			return 0;
 	}
 
@@ -1880,7 +1872,7 @@ void trace_hardirqs_on(void)
 	 * We are going to turn hardirqs on, so set the
 	 * usage bit for all held locks:
 	 */
-	if (!mark_held_locks(curr, 1, ip))
+	if (!mark_held_locks(curr, 1))
 		return;
 	/*
 	 * If we have softirqs enabled, then set the usage
@@ -1888,7 +1880,7 @@ void trace_hardirqs_on(void)
 	 * this bit from being set before)
 	 */
 	if (curr->softirqs_enabled)
-		if (!mark_held_locks(curr, 0, ip))
+		if (!mark_held_locks(curr, 0))
 			return;
 
 	curr->hardirq_enable_ip = ip;
@@ -1956,7 +1948,7 @@ void trace_softirqs_on(unsigned long ip)
 	 * enabled too:
 	 */
 	if (curr->hardirqs_enabled)
-		mark_held_locks(curr, 0, ip);
+		mark_held_locks(curr, 0);
 }
 
 /*
@@ -2094,43 +2086,43 @@ static int __lock_acquire(struct lockdep
 		if (read) {
 			if (curr->hardirq_context)
 				if (!mark_lock(curr, hlock,
-						LOCK_USED_IN_HARDIRQ_READ, ip))
+						LOCK_USED_IN_HARDIRQ_READ))
 					return 0;
 			if (curr->softirq_context)
 				if (!mark_lock(curr, hlock,
-						LOCK_USED_IN_SOFTIRQ_READ, ip))
+						LOCK_USED_IN_SOFTIRQ_READ))
 					return 0;
 		} else {
 			if (curr->hardirq_context)
-				if (!mark_lock(curr, hlock, LOCK_USED_IN_HARDIRQ, ip))
+				if (!mark_lock(curr, hlock, LOCK_USED_IN_HARDIRQ))
 					return 0;
 			if (curr->softirq_context)
-				if (!mark_lock(curr, hlock, LOCK_USED_IN_SOFTIRQ, ip))
+				if (!mark_lock(curr, hlock, LOCK_USED_IN_SOFTIRQ))
 					return 0;
 		}
 	}
 	if (!hardirqs_off) {
 		if (read) {
 			if (!mark_lock(curr, hlock,
-					LOCK_ENABLED_HARDIRQS_READ, ip))
+					LOCK_ENABLED_HARDIRQS_READ))
 				return 0;
 			if (curr->softirqs_enabled)
 				if (!mark_lock(curr, hlock,
-						LOCK_ENABLED_SOFTIRQS_READ, ip))
+						LOCK_ENABLED_SOFTIRQS_READ))
 					return 0;
 		} else {
 			if (!mark_lock(curr, hlock,
-					LOCK_ENABLED_HARDIRQS, ip))
+					LOCK_ENABLED_HARDIRQS))
 				return 0;
 			if (curr->softirqs_enabled)
 				if (!mark_lock(curr, hlock,
-						LOCK_ENABLED_SOFTIRQS, ip))
+						LOCK_ENABLED_SOFTIRQS))
 					return 0;
 		}
 	}
 #endif
 	/* mark it as used: */
-	if (!mark_lock(curr, hlock, LOCK_USED, ip))
+	if (!mark_lock(curr, hlock, LOCK_USED))
 		return 0;
 out_calc_hash:
 	/*
