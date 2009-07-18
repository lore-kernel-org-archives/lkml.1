Return-Path: <linux-kernel-owner+w=401wt.eu-S1752527AbZGROWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbZGROWR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 10:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbZGROWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 10:22:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:53888 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408AbZGROWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 10:22:15 -0400
Date: Sat, 18 Jul 2009 14:21:31 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1247725694-6082-1-git-send-email-fweisbec@gmail.com>
References: <1247725694-6082-1-git-send-email-fweisbec@gmail.com>
Subject: [tip:sched/core] sched: Drop the need_resched() loop from cond_resched()
Message-ID: <tip-e7aaaa6934636d7a6cadd9e2a05250fbb6a34f65@git.kernel.org>
Git-Commit-ID: e7aaaa6934636d7a6cadd9e2a05250fbb6a34f65
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 18 Jul 2009 14:21:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e7aaaa6934636d7a6cadd9e2a05250fbb6a34f65
Gitweb:     http://git.kernel.org/tip/e7aaaa6934636d7a6cadd9e2a05250fbb6a34f65
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Thu, 16 Jul 2009 15:44:29 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 18 Jul 2009 15:51:38 +0200

sched: Drop the need_resched() loop from cond_resched()

The schedule() function is a loop that reschedules the current
task while the TIF_NEED_RESCHED flag is set:

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

This loop is needless because schedule() already did the check
and nothing can set TIF_NEED_RESCHED between schedule() exit
and the loop check in need_resched().

Then remove this needless loop.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1247725694-6082-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 03f7e3f..4c5ee84 100644
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
