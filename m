Return-Path: <linux-kernel-owner+w=401wt.eu-S1754462AbZGJOuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462AbZGJOuK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 10:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753907AbZGJOt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 10:49:59 -0400
Received: from ey-out-1920.google.com ([74.125.78.145]:64965 "EHLO
	ey-out-1920.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbZGJOt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 10:49:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=uXtcBgG8KB8km5Unb5tgxR4k+AiK6kXxCVea2vC9NDMsnrrCimhe5aoMKG2Y8dLfmC
         ZZPBLRECWCDOM5cA5mlceiGyQPaiRJSSo2qcxFzgwdV/hFIEWK+siYz30zgkPA2wdX/H
         dyxn7n0yXW2meyjn9HRSuk6++bSHSOMW32yV8=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/2] sched: Drop the need_resched() loop from cond_resched()
Date: Fri, 10 Jul 2009 16:49:50 +0200
Message-Id: <1247237391-5352-1-git-send-email-fweisbec@gmail.com>
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
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 4d1e387..87ecac1 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6613,11 +6613,9 @@ static void __cond_resched(void)
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

