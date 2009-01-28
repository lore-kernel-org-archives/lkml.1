Return-Path: <linux-kernel-owner+w=401wt.eu-S1757379AbZA1OCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379AbZA1OCi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 09:02:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755237AbZA1N5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 08:57:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:47088 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755247AbZA1N5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 08:57:30 -0500
Message-Id: <20090128135459.047759697@chello.nl>
References: <20090128135352.679025549@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 28 Jan 2009 14:54:10 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 18/21] lockdep: add comments to mark_lock_irq()
Content-Disposition: inline; filename=lockdep-mark_irq7.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

re-add some of the comments that got lost in the refactoring.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/lockdep.c |   37 ++++++++++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 7 deletions(-)

Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -2054,6 +2054,9 @@ static int exclusive_bit(int new_bit)
 	int state = new_bit & ~3;
 	int dir = new_bit & 2;
 
+	/*
+	 * keep state, bit flip the direction and strip read.
+	 */
 	return state | (dir ^ 2);
 }
 
@@ -2070,22 +2073,42 @@ mark_lock_irq(struct task_struct *curr, 
 	int read = new_bit & 1;
 	int dir = new_bit & 2;
 
+	/*
+	 * mark USED_IN has to look forwards -- to ensure no dependency
+	 * has ENABLED state, which would allow recursion deadlocks.
+	 *
+	 * mark ENABLED has to look backwards -- to ensure no dependee
+	 * has USED_IN state, which, again, would allow  recursion deadlocks.
+	 */
 	check_usage_f usage = dir ?
 		check_usage_backwards : check_usage_forwards;
 
+	/*
+	 * Validate that this particular lock does not have conflicting
+	 * usage states.
+	 */
 	if (!valid_state(curr, this, new_bit, excl_bit))
 		return 0;
 
-	if (!read && !valid_state(curr, this, new_bit, excl_bit + 1))
-		return 0;
-
-	if ((!read || (!dir || STRICT_READ_CHECKS)) &&
+	/*
+	 * Validate that the lock dependencies don't have conflicting usage
+	 * states.
+	 */
+	if ((!read || !dir || STRICT_READ_CHECKS) &&
 			!usage(curr, this, excl_bit, name))
 		return 0;
 
-	if ((!read && STRICT_READ_CHECKS) &&
-			!usage(curr, this, excl_bit + 1, rname))
-		return 0;
+	/*
+	 * Check for read in write conflicts
+	 */
+	if (!read) {
+	       	if (!valid_state(curr, this, new_bit, excl_bit + 1))
+			return 0;
+
+		if (STRICT_READ_CHECKS &&
+				!usage(curr, this, excl_bit + 1, rname))
+			return 0;
+	}
 
 	if (state_verbose(new_bit, hlock_class(this)))
 		return 2;

-- 

