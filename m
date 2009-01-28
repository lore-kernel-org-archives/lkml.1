Return-Path: <linux-kernel-owner+w=401wt.eu-S1755464AbZA1OEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbZA1OEJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 09:04:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbZA1N5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 08:57:42 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60385 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277AbZA1N5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 08:57:32 -0500
Message-Id: <20090128135459.457120451@chello.nl>
References: <20090128135352.679025549@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 28 Jan 2009 14:54:13 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 21/21] lockdep: simplify check_prev_add_irq()
Content-Disposition: inline; filename=lockdep-check_prev_add_irq.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the manual state iteration thingy.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/lockdep.c |  154 +++++++++++++++++++++----------------------------------
 1 file changed, 61 insertions(+), 93 deletions(-)

Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -1268,68 +1268,84 @@ check_usage(struct task_struct *curr, st
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
 {
-	/*
-	 * Prove that the new dependency does not connect a hardirq-safe
-	 * lock with a hardirq-unsafe lock - to achieve this we search
-	 * the backwards-subgraph starting at <prev>, and the
-	 * forwards-subgraph starting at <next>:
-	 */
-	if (!check_usage(curr, prev, next, LOCK_USED_IN_HARDIRQ,
-					LOCK_ENABLED_HARDIRQ, "hard"))
-		return 0;
+	return (bit & 1) ? state_rnames[bit >> 2] : state_names[bit >> 2];
+}
 
+static int exclusive_bit(int new_bit)
+{
 	/*
-	 * Prove that the new dependency does not connect a hardirq-safe-read
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
-	if (!check_usage(curr, prev, next, LOCK_USED_IN_HARDIRQ_READ,
-					LOCK_ENABLED_HARDIRQ, "hard-read"))
-		return 0;
+
+	int state = new_bit & ~3;
+	int dir = new_bit & 2;
 
 	/*
-	 * Prove that the new dependency does not connect a softirq-safe
-	 * lock with a softirq-unsafe lock - to achieve this we search
-	 * the backwards-subgraph starting at <prev>, and the
-	 * forwards-subgraph starting at <next>:
+	 * keep state, bit flip the direction and strip read.
 	 */
-	if (!check_usage(curr, prev, next, LOCK_USED_IN_SOFTIRQ,
-					LOCK_ENABLED_SOFTIRQ, "soft"))
-		return 0;
+	return state | (dir ^ 2);
+}
+
+static int check_irq_usage(struct task_struct *curr, struct held_lock *prev,
+			   struct held_lock *next, enum lock_usage_bit bit)
+{
 	/*
-	 * Prove that the new dependency does not connect a softirq-safe-read
-	 * lock with a softirq-unsafe lock - to achieve this we search
+	 * Prove that the new dependency does not connect a hardirq-safe
+	 * lock with a hardirq-unsafe lock - to achieve this we search
 	 * the backwards-subgraph starting at <prev>, and the
 	 * forwards-subgraph starting at <next>:
 	 */
-	if (!check_usage(curr, prev, next, LOCK_USED_IN_SOFTIRQ_READ,
-					LOCK_ENABLED_SOFTIRQ, "soft"))
+	if (!check_usage(curr, prev, next, bit,
+			   exclusive_bit(bit), state_name(bit)))
 		return 0;
 
+	bit++; /* _READ */
+
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
@@ -1984,30 +2000,6 @@ static int RECLAIM_FS_verbose(struct loc
 
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
@@ -2021,37 +2013,12 @@ static inline int state_verbose(enum loc
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
-	/*
-	 * keep state, bit flip the direction and strip read.
-	 */
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
@@ -2078,7 +2045,7 @@ mark_lock_irq(struct task_struct *curr, 
 	 * states.
 	 */
 	if ((!read || !dir || STRICT_READ_CHECKS) &&
-			!usage(curr, this, excl_bit, name))
+			!usage(curr, this, excl_bit, state_name(new_bit)))
 		return 0;
 
 	/*
@@ -2089,7 +2056,8 @@ mark_lock_irq(struct task_struct *curr, 
 			return 0;
 
 		if (STRICT_READ_CHECKS &&
-				!usage(curr, this, excl_bit + 1, rname))
+			!usage(curr, this, excl_bit + 1,
+				state_name(new_bit + 1)))
 			return 0;
 	}
 

-- 

