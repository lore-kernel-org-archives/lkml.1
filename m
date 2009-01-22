Return-Path: <linux-kernel-owner+w=401wt.eu-S1758395AbZAVRoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758395AbZAVRoj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 12:44:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755952AbZAVRnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 12:43:50 -0500
Received: from casper.infradead.org ([85.118.1.10]:37905 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492AbZAVRns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 12:43:48 -0500
Message-Id: <20090122174053.144605709@chello.nl>
References: <20090122173701.674448070@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 22 Jan 2009 18:37:12 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC PATCH 11/19] lockdep: simplify the mark_lock_irq() helpers
Content-Disposition: inline; filename=lockdep-mark_irq1.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to unify them, take some arguments away

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/lockdep.c |   60 ++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 44 insertions(+), 16 deletions(-)

Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -2001,12 +2001,38 @@ static int reclaim_verbose(struct lock_c
 
 #define STRICT_READ_CHECKS	1
 
+static const char *state_names[] = {
+#define LOCKDEP_STATE(__STATE) \
+	STR(__STATE),
+#include "lockdep_states.h"
+#undef LOCKDEP_STATE
+};
+
+static inline const char *state_name(enum lock_usage_bit bit)
+{
+	return state_names[bit >> 2];
+}
+
+static const char *state_rnames[] = {
+#define LOCKDEP_STATE(__STATE) \
+	STR(__STATE)"-READ",
+#include "lockdep_states.h"
+#undef LOCKDEP_STATE
+};
+
+static inline const char *state_rname(enum lock_usage_bit bit)
+{
+	return state_rnames[bit >> 2];
+}
+
 static int
 mark_lock_irq_used_in(struct task_struct *curr, struct held_lock *this,
 		      int new_bit, int excl_bit,
-		      const char *name, const char *rname,
 		      int (*verbose)(struct lock_class *class))
 {
+	const char *name = state_name(new_bit);
+	const char *rname = state_rname(new_bit);
+
 	if (!valid_state(curr, this, new_bit, excl_bit))
 		return 0;
 	if (!valid_state(curr, this, new_bit, excl_bit + 1))
@@ -2034,9 +2060,11 @@ mark_lock_irq_used_in(struct task_struct
 static int
 mark_lock_irq_used_in_read(struct task_struct *curr, struct held_lock *this,
 			   int new_bit, int excl_bit,
-			   const char *name, const char *rname,
 			   int (*verbose)(struct lock_class *class))
 {
+	const char *name = state_name(new_bit);
+	const char *rname = state_rname(new_bit);
+
 	if (!valid_state(curr, this, new_bit, excl_bit))
 		return 0;
 	/*
@@ -2054,9 +2082,11 @@ mark_lock_irq_used_in_read(struct task_s
 static int
 mark_lock_irq_enabled(struct task_struct *curr, struct held_lock *this,
 		      int new_bit, int excl_bit,
-		      const char *name, const char *rname,
 		      int (*verbose)(struct lock_class *class))
 {
+	const char *name = state_name(new_bit);
+	const char *rname = state_rname(new_bit);
+
 	if (!valid_state(curr, this, new_bit, excl_bit))
 		return 0;
 	if (!valid_state(curr, this, new_bit, excl_bit + 1))
@@ -2085,9 +2115,11 @@ mark_lock_irq_enabled(struct task_struct
 static int
 mark_lock_irq_enabled_read(struct task_struct *curr, struct held_lock *this,
 			   int new_bit, int excl_bit,
-			   const char *name, const char *rname,
 			   int (*verbose)(struct lock_class *class))
 {
+	const char *name = state_name(new_bit);
+	const char *rname = state_rname(new_bit);
+
 	if (!valid_state(curr, this, new_bit, excl_bit))
 		return 0;
 #if STRICT_READ_CHECKS
@@ -2113,57 +2145,53 @@ static int mark_lock_irq(struct task_str
 	case LOCK_USED_IN_HARDIRQ:
 		return mark_lock_irq_used_in(curr, this, new_bit,
 				LOCK_ENABLED_HARDIRQ,
-				"hard", "hard-read", hardirq_verbose);
+				hardirq_verbose);
 	case LOCK_USED_IN_SOFTIRQ:
 		return mark_lock_irq_used_in(curr, this, new_bit,
 				LOCK_ENABLED_SOFTIRQ,
-				"soft", "soft-read", softirq_verbose);
+				softirq_verbose);
 	case LOCK_USED_IN_RECLAIM_FS:
 		return mark_lock_irq_used_in(curr, this, new_bit,
 				LOCK_ENABLED_RECLAIM_FS,
-				"reclaim-fs", "reclaim-fs-read",
 				reclaim_verbose);
 
 	case LOCK_USED_IN_HARDIRQ_READ:
 		return mark_lock_irq_used_in_read(curr, this, new_bit,
 				LOCK_ENABLED_HARDIRQ,
-				"hard", "hard-read", hardirq_verbose);
+				hardirq_verbose);
 	case LOCK_USED_IN_SOFTIRQ_READ:
 		return mark_lock_irq_used_in_read(curr, this, new_bit,
 				LOCK_ENABLED_SOFTIRQ,
-				"soft", "soft-read", softirq_verbose);
+				softirq_verbose);
 	case LOCK_USED_IN_RECLAIM_FS_READ:
 		return mark_lock_irq_used_in_read(curr, this, new_bit,
 				LOCK_ENABLED_RECLAIM_FS,
-				"reclaim-fs", "reclaim-fs-read",
 				reclaim_verbose);
 
 	case LOCK_ENABLED_HARDIRQ:
 		return mark_lock_irq_enabled(curr, this, new_bit,
 				LOCK_USED_IN_HARDIRQ,
-				"hard", "hard-read", hardirq_verbose);
+				hardirq_verbose);
 	case LOCK_ENABLED_SOFTIRQ:
 		return mark_lock_irq_enabled(curr, this, new_bit,
 				LOCK_USED_IN_SOFTIRQ,
-				"soft", "soft-read", softirq_verbose);
+				softirq_verbose);
 	case LOCK_ENABLED_RECLAIM_FS:
 		return mark_lock_irq_enabled(curr, this, new_bit,
 				LOCK_USED_IN_RECLAIM_FS,
-				"reclaim-fs", "reclaim-fs-read",
 				reclaim_verbose);
 
 	case LOCK_ENABLED_HARDIRQ_READ:
 		return mark_lock_irq_enabled_read(curr, this, new_bit,
 				LOCK_USED_IN_HARDIRQ,
-				"hard", "hard-read", hardirq_verbose);
+				hardirq_verbose);
 	case LOCK_ENABLED_SOFTIRQ_READ:
 		return mark_lock_irq_enabled_read(curr, this, new_bit,
 				LOCK_USED_IN_SOFTIRQ,
-				"soft", "soft-read", softirq_verbose);
+				softirq_verbose);
 	case LOCK_ENABLED_RECLAIM_FS_READ:
 		return mark_lock_irq_enabled_read(curr, this, new_bit,
 				LOCK_USED_IN_RECLAIM_FS,
-				"reclaim-fs", "reclaim-fs-read",
 				reclaim_verbose);
 
 	default:

-- 

