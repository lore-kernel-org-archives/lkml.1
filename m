Return-Path: <linux-kernel-owner+w=401wt.eu-S1759122AbZAVRq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759122AbZAVRq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 12:46:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756617AbZAVRny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 12:43:54 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44495 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755897AbZAVRnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 12:43:49 -0500
Message-Id: <20090122174053.255718311@chello.nl>
References: <20090122173701.674448070@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 22 Jan 2009 18:37:13 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC PATCH 12/19] lockdep: further simplify mark_lock_irq() helpers
Content-Disposition: inline; filename=lockdep-mark_irq2.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

take away another parameter

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/lockdep.c |   47 +++++++++++++++++++++++++++++++----------------
 1 file changed, 31 insertions(+), 16 deletions(-)

Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -2025,14 +2025,35 @@ static inline const char *state_rname(en
 	return state_rnames[bit >> 2];
 }
 
+static int exclusive_bit(int new_bit)
+{
+	/*
+	 * USED_IN
+	 * USED_IN_READ
+	 * ENABLED
+	 * ENABLED_READ
+	 *
+	 * bit 0 - write/read
+	 * bit 1 - used_in/enabled
+	 * bit 2+  state
+	 */
+
+	int state = new_bit & ~3;
+	int dir = new_bit & 2;
+
+	return state | (dir ^ 2);
+}
+
 static int
 mark_lock_irq_used_in(struct task_struct *curr, struct held_lock *this,
-		      int new_bit, int excl_bit,
+		      int new_bit,
 		      int (*verbose)(struct lock_class *class))
 {
 	const char *name = state_name(new_bit);
 	const char *rname = state_rname(new_bit);
 
+	int excl_bit = exclusive_bit(new_bit);
+
 	if (!valid_state(curr, this, new_bit, excl_bit))
 		return 0;
 	if (!valid_state(curr, this, new_bit, excl_bit + 1))
@@ -2059,12 +2080,14 @@ mark_lock_irq_used_in(struct task_struct
 
 static int
 mark_lock_irq_used_in_read(struct task_struct *curr, struct held_lock *this,
-			   int new_bit, int excl_bit,
+			   int new_bit,
 			   int (*verbose)(struct lock_class *class))
 {
 	const char *name = state_name(new_bit);
 	const char *rname = state_rname(new_bit);
 
+	int excl_bit = exclusive_bit(new_bit);
+
 	if (!valid_state(curr, this, new_bit, excl_bit))
 		return 0;
 	/*
@@ -2081,12 +2104,14 @@ mark_lock_irq_used_in_read(struct task_s
 
 static int
 mark_lock_irq_enabled(struct task_struct *curr, struct held_lock *this,
-		      int new_bit, int excl_bit,
+		      int new_bit,
 		      int (*verbose)(struct lock_class *class))
 {
 	const char *name = state_name(new_bit);
 	const char *rname = state_rname(new_bit);
 
+	int excl_bit = exclusive_bit(new_bit);
+
 	if (!valid_state(curr, this, new_bit, excl_bit))
 		return 0;
 	if (!valid_state(curr, this, new_bit, excl_bit + 1))
@@ -2114,12 +2139,14 @@ mark_lock_irq_enabled(struct task_struct
 
 static int
 mark_lock_irq_enabled_read(struct task_struct *curr, struct held_lock *this,
-			   int new_bit, int excl_bit,
+			   int new_bit,
 			   int (*verbose)(struct lock_class *class))
 {
 	const char *name = state_name(new_bit);
 	const char *rname = state_rname(new_bit);
 
+	int excl_bit = exclusive_bit(new_bit);
+
 	if (!valid_state(curr, this, new_bit, excl_bit))
 		return 0;
 #if STRICT_READ_CHECKS
@@ -2144,54 +2171,42 @@ static int mark_lock_irq(struct task_str
 	switch(new_bit) {
 	case LOCK_USED_IN_HARDIRQ:
 		return mark_lock_irq_used_in(curr, this, new_bit,
-				LOCK_ENABLED_HARDIRQ,
 				hardirq_verbose);
 	case LOCK_USED_IN_SOFTIRQ:
 		return mark_lock_irq_used_in(curr, this, new_bit,
-				LOCK_ENABLED_SOFTIRQ,
 				softirq_verbose);
 	case LOCK_USED_IN_RECLAIM_FS:
 		return mark_lock_irq_used_in(curr, this, new_bit,
-				LOCK_ENABLED_RECLAIM_FS,
 				reclaim_verbose);
 
 	case LOCK_USED_IN_HARDIRQ_READ:
 		return mark_lock_irq_used_in_read(curr, this, new_bit,
-				LOCK_ENABLED_HARDIRQ,
 				hardirq_verbose);
 	case LOCK_USED_IN_SOFTIRQ_READ:
 		return mark_lock_irq_used_in_read(curr, this, new_bit,
-				LOCK_ENABLED_SOFTIRQ,
 				softirq_verbose);
 	case LOCK_USED_IN_RECLAIM_FS_READ:
 		return mark_lock_irq_used_in_read(curr, this, new_bit,
-				LOCK_ENABLED_RECLAIM_FS,
 				reclaim_verbose);
 
 	case LOCK_ENABLED_HARDIRQ:
 		return mark_lock_irq_enabled(curr, this, new_bit,
-				LOCK_USED_IN_HARDIRQ,
 				hardirq_verbose);
 	case LOCK_ENABLED_SOFTIRQ:
 		return mark_lock_irq_enabled(curr, this, new_bit,
-				LOCK_USED_IN_SOFTIRQ,
 				softirq_verbose);
 	case LOCK_ENABLED_RECLAIM_FS:
 		return mark_lock_irq_enabled(curr, this, new_bit,
-				LOCK_USED_IN_RECLAIM_FS,
 				reclaim_verbose);
 
 	case LOCK_ENABLED_HARDIRQ_READ:
 		return mark_lock_irq_enabled_read(curr, this, new_bit,
-				LOCK_USED_IN_HARDIRQ,
 				hardirq_verbose);
 	case LOCK_ENABLED_SOFTIRQ_READ:
 		return mark_lock_irq_enabled_read(curr, this, new_bit,
-				LOCK_USED_IN_SOFTIRQ,
 				softirq_verbose);
 	case LOCK_ENABLED_RECLAIM_FS_READ:
 		return mark_lock_irq_enabled_read(curr, this, new_bit,
-				LOCK_USED_IN_RECLAIM_FS,
 				reclaim_verbose);
 
 	default:

-- 

