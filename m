Return-Path: <linux-kernel-owner+w=401wt.eu-S1756558AbZGPG2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558AbZGPG2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 02:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754012AbZGPG2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 02:28:20 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:59564 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbZGPG2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 02:28:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=IOGnDOcOAtjDplhVqEp01yOnVfFFB+cxO+NX1wB7jhot3vEhuKdAR90/r+ZdmanL+e
         vW03LAq6JU8e4jvj6MWz4j8Qn4VUSi+Uzs9Mq+6Npap0JxGMcctwF0RGD99ZS+Bp3GCf
         m0AnzgMzGDRIworUMv4fPVGQoghupodoDq8XE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/7] sched: Drop the need_resched() loop from cond_resched()
Date: Thu, 16 Jul 2009 02:28:08 -0400
Message-Id: <1247725694-6082-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The schedule() function is a loop that reschedules the current task
while the TIF_NEED_RESCHED flag is set:

void schedule(void)
{
need_resched:
	/* schedule code */
	if (need_resched())
		goto need_resched;
}

And cond_resched() repeat this loop:

do {
	add_preempt_count(PREEMPT_ACTIVE);
	schedule();
	sub_preempt_count(PREEMPT_ACTIVE);
} while(need_resched());

This loop is needless because schedule() already did the check and
nothing can set TIF_NEED_RESCHED between schedule() exit and the loop
check in need_resched().

Then remove this needless loop.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 75d2c1d..264b163 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6618,11 +6618,9 @@ static void __cond_resched(void)
 	 * PREEMPT_ACTIVE, which could trigger a second
 	 * cond_resched() call.
 	 */
-	do {
-		add_preempt_count(PREEMPT_ACTIVE);
-		schedule();
-		sub_preempt_count(PREEMPT_ACTIVE);
-	} while (need_resched());
+	add_preempt_count(PREEMPT_ACTIVE);
+	schedule();
+	sub_preempt_count(PREEMPT_ACTIVE);
 }
 
 int __sched _cond_resched(void)
-- 
1.6.2.3

