Return-Path: <linux-kernel-owner+w=401wt.eu-S1758254AbZEKMkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254AbZEKMkG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 08:40:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756788AbZEKMjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 08:39:33 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:38108 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757679AbZEKMjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 08:39:32 -0400
From: Gautham R Shenoy <ego@in.ibm.com>
Subject: [RFC/PATCH PATCH 2/6] lockdep: Remove strict read checks.
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul E McKenney <paulmck@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 11 May 2009 18:09:35 +0530
Message-ID: <20090511123935.31159.74518.stgit@sofia.in.ibm.com>
In-Reply-To: <20090511122936.31159.44531.stgit@sofia.in.ibm.com>
References: <20090511122936.31159.44531.stgit@sofia.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Read locks would cause IRQ inversion problems only when they're being taken in
a IRQ context. So, except for this case, skip the strict read checks for every
other case.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---

 kernel/lockdep.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 8d3c2b5..597479a 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -1986,8 +1986,6 @@ static int RECLAIM_FS_verbose(struct lock_class *class)
 	return 0;
 }
 
-#define STRICT_READ_CHECKS	1
-
 static int (*state_verbose_f[])(struct lock_class *class) = {
 #define LOCKDEP_STATE(__STATE) \
 	__STATE##_verbose,
@@ -2032,9 +2030,13 @@ mark_lock_irq(struct task_struct *curr, struct held_lock *this,
 	/*
 	 * Validate that the lock dependencies don't have conflicting usage
 	 * states.
+	 *
+	 * Skip the part if it's a read_lock with LOCK_ENABLED_XXX.
+	 * We'll do that check when a write variant of the same lock is taken,
+	 * or we take the read variant of lock in the LOCK_USED_IN_XXX state.
 	 */
-	if ((!read || !dir || STRICT_READ_CHECKS) &&
-			!usage(curr, this, excl_bit, state_name(new_bit & ~1)))
+	if (!(read && dir) && !usage(curr, this, excl_bit,
+					state_name(new_bit & ~1)))
 		return 0;
 
 	/*
@@ -2044,8 +2046,7 @@ mark_lock_irq(struct task_struct *curr, struct held_lock *this,
 		if (!valid_state(curr, this, new_bit, excl_bit + 1))
 			return 0;
 
-		if (STRICT_READ_CHECKS &&
-			!usage(curr, this, excl_bit + 1,
+		if (!usage(curr, this, excl_bit + 1,
 				state_name(new_bit + 1)))
 			return 0;
 	}

