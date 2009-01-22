Return-Path: <linux-kernel-owner+w=401wt.eu-S1758528AbZAVRqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758528AbZAVRqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 12:46:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756414AbZAVRnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 12:43:53 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44493 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755824AbZAVRnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 12:43:49 -0500
Message-Id: <20090122174054.030871274@chello.nl>
References: <20090122173701.674448070@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 22 Jan 2009 18:37:20 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC PATCH 19/19] lockdep: simplify check_prev_add_irq()
Content-Disposition: inline; filename=lockdep-check_prev_add_irq.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the manual state iteration thingy.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/lockdep.c |  150 +++++++++++++++++++++----------------------------------
 1 file changed, 59 insertions(+), 91 deletions(-)

Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -1268,68 +1268,81 @@ check_usage(struct task_struct *curr, st
 			bit_backwards, bit_forwards, irqclass);
 }
 
-static int
-check_prev_add_irq(struct task_struct *curr, struct held_lock *prev,
-		struct held_lock *next)
+static const char *state_names[] = {
+#define LOCKDEP_STATE(__STATE) \
+	STR(__STATE),
+#include "lockdep_states.h"
+#undef LOCKDEP_STATE
+};
+
+static const char *state_rnames[] = {
+#define LOCKDEP_STATE(__STATE) \
+	STR(__STATE)"-READ",
+#include "lockdep_states.h"
+#undef LOCKDEP_STATE
+};
+
+static inline const char *state_name(enum lock_usage_bit bit)
+{
+	return (bit & 1) ? state_rnames[bit >> 2] : state_names[bit >> 2];
+}
+
+static int exclusive_bit(int new_bit)
 {
 	/*
-	 * Prove that the new dependency does not connect a hardirq-safe
-	 * lock with a hardirq-unsafe lock - to achieve this we search
-	 * the backwards-subgraph starting at <prev>, and the
-	 * forwards-subgraph starting at <next>:
+	 * USED_IN
+	 * USED_IN_READ
+	 * ENABLED
+	 * ENABLED_READ
+	 *
+	 * bit 0 - write/read
+	 * bit 1 - used_in/enabled
+	 * bit 2+  state
 	 */
-	if (!check_usage(curr, prev, next, LOCK_USED_IN_HARDIRQ,
-					LOCK_ENABLED_HARDIRQ, "hard"))
-		return 0;
 
+	int state = new_bit & ~3;
+	int dir = new_bit & 2;
+
+	return state | (dir ^ 2);
+}
+
+static int check_irq_usage(struct task_struct *curr, struct held_lock *prev,
+			   struct held_lock *next, enum lock_usage_bit bit)
+{
 	/*
-	 * Prove that the new dependency does not connect a hardirq-safe-read
+	 * Prove that the new dependency does not connect a hardirq-safe
 	 * lock with a hardirq-unsafe lock - to achieve this we search
 	 * the backwards-subgraph starting at <prev>, and the
 	 * forwards-subgraph starting at <next>:
 	 */
-	if (!check_usage(curr, prev, next, LOCK_USED_IN_HARDIRQ_READ,
-					LOCK_ENABLED_HARDIRQ, "hard-read"))
+	if (!check_usage(curr, prev, next, bit,
+			   exclusive_bit(bit), state_name(bit)))
 		return 0;
 
-	/*
-	 * Prove that the new dependency does not connect a softirq-safe
-	 * lock with a softirq-unsafe lock - to achieve this we search
-	 * the backwards-subgraph starting at <prev>, and the
-	 * forwards-subgraph starting at <next>:
-	 */
-	if (!check_usage(curr, prev, next, LOCK_USED_IN_SOFTIRQ,
-					LOCK_ENABLED_SOFTIRQ, "soft"))
-		return 0;
-	/*
-	 * Prove that the new dependency does not connect a softirq-safe-read
-	 * lock with a softirq-unsafe lock - to achieve this we search
-	 * the backwards-subgraph starting at <prev>, and the
-	 * forwards-subgraph starting at <next>:
-	 */
-	if (!check_usage(curr, prev, next, LOCK_USED_IN_SOFTIRQ_READ,
-					LOCK_ENABLED_SOFTIRQ, "soft"))
-		return 0;
+	bit++; /* _READ */
 
 	/*
-	 * Prove that the new dependency does not connect a reclaim-fs-safe
-	 * lock with a reclaim-fs-unsafe lock - to achieve this we search
+	 * Prove that the new dependency does not connect a hardirq-safe-read
+	 * lock with a hardirq-unsafe lock - to achieve this we search
 	 * the backwards-subgraph starting at <prev>, and the
 	 * forwards-subgraph starting at <next>:
 	 */
-	if (!check_usage(curr, prev, next, LOCK_USED_IN_RECLAIM_FS,
-					LOCK_ENABLED_RECLAIM_FS, "reclaim-fs"))
+	if (!check_usage(curr, prev, next, bit,
+			   exclusive_bit(bit), state_name(bit)))
 		return 0;
 
-	/*
-	 * Prove that the new dependency does not connect a reclaim-fs-safe-read
-	 * lock with a reclaim-fs-unsafe lock - to achieve this we search
-	 * the backwards-subgraph starting at <prev>, and the
-	 * forwards-subgraph starting at <next>:
-	 */
-	if (!check_usage(curr, prev, next, LOCK_USED_IN_RECLAIM_FS_READ,
-					LOCK_ENABLED_RECLAIM_FS, "reclaim-fs-read"))
+	return 1;
+}
+
+static int
+check_prev_add_irq(struct task_struct *curr, struct held_lock *prev,
+		struct held_lock *next)
+{
+#define LOCKDEP_STATE(__STATE)						\
+	if (!check_irq_usage(curr, prev, next, LOCK_USED_IN_##__STATE))	\
 		return 0;
+#include "lockdep_states.h"
+#undef LOCKDEP_STATE
 
 	return 1;
 }
@@ -1984,30 +1997,6 @@ static int RECLAIM_FS_verbose(struct loc
 
 #define STRICT_READ_CHECKS	1
 
-static const char *state_names[] = {
-#define LOCKDEP_STATE(__STATE) \
-	STR(__STATE),
-#include "lockdep_states.h"
-#undef LOCKDEP_STATE
-};
-
-static inline const char *state_name(enum lock_usage_bit bit)
-{
-	return state_names[bit >> 2];
-}
-
-static const char *state_rnames[] = {
-#define LOCKDEP_STATE(__STATE) \
-	STR(__STATE)"-READ",
-#include "lockdep_states.h"
-#undef LOCKDEP_STATE
-};
-
-static inline const char *state_rname(enum lock_usage_bit bit)
-{
-	return state_rnames[bit >> 2];
-}
-
 static int (*state_verbose_f[])(struct lock_class *class) = {
 #define LOCKDEP_STATE(__STATE) \
 	__STATE##_verbose,
@@ -2021,34 +2010,12 @@ static inline int state_verbose(enum loc
 	return state_verbose_f[bit >> 2](class);
 }
 
-static int exclusive_bit(int new_bit)
-{
-	/*
-	 * USED_IN
-	 * USED_IN_READ
-	 * ENABLED
-	 * ENABLED_READ
-	 *
-	 * bit 0 - write/read
-	 * bit 1 - used_in/enabled
-	 * bit 2+  state
-	 */
-
-	int state = new_bit & ~3;
-	int dir = new_bit & 2;
-
-	return state | (dir ^ 2);
-}
-
 typedef int (*check_usage_f)(struct task_struct *, struct held_lock *,
 			     enum lock_usage_bit bit, const char *name);
 
 static int
 mark_lock_irq(struct task_struct *curr, struct held_lock *this, int new_bit)
 {
-	const char *name = state_name(new_bit);
-	const char *rname = state_rname(new_bit);
-
 	int excl_bit = exclusive_bit(new_bit);
 	int read = new_bit & 1;
 	int dir = new_bit & 2;
@@ -2063,11 +2030,12 @@ mark_lock_irq(struct task_struct *curr, 
 		return 0;
 
 	if ((!read || (!dir || STRICT_READ_CHECKS)) &&
-			!usage(curr, this, excl_bit, name))
+			!usage(curr, this, excl_bit, state_name(new_bit)))
 		return 0;
 
 	if ((!read && STRICT_READ_CHECKS) &&
-			!usage(curr, this, excl_bit + 1, rname))
+			!usage(curr, this, excl_bit + 1,
+				state_name(new_bit + 1)))
 		return 0;
 
 	if (state_verbose(new_bit, hlock_class(this)))

-- 

