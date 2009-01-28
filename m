Return-Path: <linux-kernel-owner+w=401wt.eu-S1757969AbZA1OFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969AbZA1OFj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 09:05:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbZA1N5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 08:57:47 -0500
Received: from casper.infradead.org ([85.118.1.10]:47089 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252AbZA1N5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 08:57:30 -0500
Message-Id: <20090128135458.530134060@chello.nl>
References: <20090128135352.679025549@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 28 Jan 2009 14:54:05 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 13/21] lockdep: simplify mark_lock_irq() helpers #3
Content-Disposition: inline; filename=lockdep-mark_irq3.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kill another argument

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/lockdep.c |   65 ++++++++++++++++++++++---------------------------------
 1 file changed, 27 insertions(+), 38 deletions(-)

Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -1975,7 +1975,7 @@ void print_irqtrace_events(struct task_s
 	print_ip_sym(curr->softirq_disable_ip);
 }
 
-static int hardirq_verbose(struct lock_class *class)
+static int HARDIRQ_verbose(struct lock_class *class)
 {
 #if HARDIRQ_VERBOSE
 	return class_filter(class);
@@ -1983,7 +1983,7 @@ static int hardirq_verbose(struct lock_c
 	return 0;
 }
 
-static int softirq_verbose(struct lock_class *class)
+static int SOFTIRQ_verbose(struct lock_class *class)
 {
 #if SOFTIRQ_VERBOSE
 	return class_filter(class);
@@ -1991,7 +1991,7 @@ static int softirq_verbose(struct lock_c
 	return 0;
 }
 
-static int reclaim_verbose(struct lock_class *class)
+static int RECLAIM_FS_verbose(struct lock_class *class)
 {
 #if RECLAIM_VERBOSE
 	return class_filter(class);
@@ -2025,6 +2025,19 @@ static inline const char *state_rname(en
 	return state_rnames[bit >> 2];
 }
 
+static int (*state_verbose_f[])(struct lock_class *class) = {
+#define LOCKDEP_STATE(__STATE) \
+	__STATE##_verbose,
+#include "lockdep_states.h"
+#undef LOCKDEP_STATE
+};
+
+static inline int state_verbose(enum lock_usage_bit bit,
+				struct lock_class *class)
+{
+	return state_verbose_f[bit >> 2](class);
+}
+
 static int exclusive_bit(int new_bit)
 {
 	/*
@@ -2046,8 +2059,7 @@ static int exclusive_bit(int new_bit)
 
 static int
 mark_lock_irq_used_in(struct task_struct *curr, struct held_lock *this,
-		      int new_bit,
-		      int (*verbose)(struct lock_class *class))
+		      int new_bit)
 {
 	const char *name = state_name(new_bit);
 	const char *rname = state_rname(new_bit);
@@ -2072,7 +2084,7 @@ mark_lock_irq_used_in(struct task_struct
 	if (!check_usage_forwards(curr, this, excl_bit + 1, rname))
 		return 0;
 #endif
-	if (verbose(hlock_class(this)))
+	if (state_verbose(new_bit, hlock_class(this)))
 		return 2;
 
 	return 1;
@@ -2080,8 +2092,7 @@ mark_lock_irq_used_in(struct task_struct
 
 static int
 mark_lock_irq_used_in_read(struct task_struct *curr, struct held_lock *this,
-			   int new_bit,
-			   int (*verbose)(struct lock_class *class))
+			   int new_bit)
 {
 	const char *name = state_name(new_bit);
 	const char *rname = state_rname(new_bit);
@@ -2096,7 +2107,7 @@ mark_lock_irq_used_in_read(struct task_s
 	 */
 	if (!check_usage_forwards(curr, this, excl_bit, name))
 		return 0;
-	if (verbose(hlock_class(this)))
+	if (state_verbose(new_bit, hlock_class(this)))
 		return 2;
 
 	return 1;
@@ -2104,8 +2115,7 @@ mark_lock_irq_used_in_read(struct task_s
 
 static int
 mark_lock_irq_enabled(struct task_struct *curr, struct held_lock *this,
-		      int new_bit,
-		      int (*verbose)(struct lock_class *class))
+		      int new_bit)
 {
 	const char *name = state_name(new_bit);
 	const char *rname = state_rname(new_bit);
@@ -2131,7 +2141,7 @@ mark_lock_irq_enabled(struct task_struct
 	if (!check_usage_backwards(curr, this, excl_bit + 1, rname))
 		return 0;
 #endif
-	if (verbose(hlock_class(this)))
+	if (state_verbose(new_bit, hlock_class(this)))
 		return 2;
 
 	return 1;
@@ -2139,8 +2149,7 @@ mark_lock_irq_enabled(struct task_struct
 
 static int
 mark_lock_irq_enabled_read(struct task_struct *curr, struct held_lock *this,
-			   int new_bit,
-			   int (*verbose)(struct lock_class *class))
+			   int new_bit)
 {
 	const char *name = state_name(new_bit);
 	const char *rname = state_rname(new_bit);
@@ -2170,44 +2179,24 @@ static int mark_lock_irq(struct task_str
 
 	switch(new_bit) {
 	case LOCK_USED_IN_HARDIRQ:
-		return mark_lock_irq_used_in(curr, this, new_bit,
-				hardirq_verbose);
 	case LOCK_USED_IN_SOFTIRQ:
-		return mark_lock_irq_used_in(curr, this, new_bit,
-				softirq_verbose);
 	case LOCK_USED_IN_RECLAIM_FS:
-		return mark_lock_irq_used_in(curr, this, new_bit,
-				reclaim_verbose);
+		return mark_lock_irq_used_in(curr, this, new_bit);
 
 	case LOCK_USED_IN_HARDIRQ_READ:
-		return mark_lock_irq_used_in_read(curr, this, new_bit,
-				hardirq_verbose);
 	case LOCK_USED_IN_SOFTIRQ_READ:
-		return mark_lock_irq_used_in_read(curr, this, new_bit,
-				softirq_verbose);
 	case LOCK_USED_IN_RECLAIM_FS_READ:
-		return mark_lock_irq_used_in_read(curr, this, new_bit,
-				reclaim_verbose);
+		return mark_lock_irq_used_in_read(curr, this, new_bit);
 
 	case LOCK_ENABLED_HARDIRQ:
-		return mark_lock_irq_enabled(curr, this, new_bit,
-				hardirq_verbose);
 	case LOCK_ENABLED_SOFTIRQ:
-		return mark_lock_irq_enabled(curr, this, new_bit,
-				softirq_verbose);
 	case LOCK_ENABLED_RECLAIM_FS:
-		return mark_lock_irq_enabled(curr, this, new_bit,
-				reclaim_verbose);
+		return mark_lock_irq_enabled(curr, this, new_bit);
 
 	case LOCK_ENABLED_HARDIRQ_READ:
-		return mark_lock_irq_enabled_read(curr, this, new_bit,
-				hardirq_verbose);
 	case LOCK_ENABLED_SOFTIRQ_READ:
-		return mark_lock_irq_enabled_read(curr, this, new_bit,
-				softirq_verbose);
 	case LOCK_ENABLED_RECLAIM_FS_READ:
-		return mark_lock_irq_enabled_read(curr, this, new_bit,
-				reclaim_verbose);
+		return mark_lock_irq_enabled_read(curr, this, new_bit);
 
 	default:
 		WARN_ON(1);

-- 

