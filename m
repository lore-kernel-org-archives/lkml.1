Return-Path: <linux-kernel-owner+w=401wt.eu-S1759730AbZDIHK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759730AbZDIHK3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 03:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbZDIHKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 03:10:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:36738 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbZDIHKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 03:10:13 -0400
Date: Thu, 9 Apr 2009 07:09:31 GMT
From: Paul Turner <pjt@google.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <alpine.DEB.1.00.0904081520320.30317@kitami.corp.google.com>
References: <alpine.DEB.1.00.0904081520320.30317@kitami.corp.google.com>
Subject: [tip:sched/core] sched: remove redundant hierarchy walk in check_preempt_wakeup
Message-ID: <tip-002f128b473fb82f454654be5081b0919ee01ab2@git.kernel.org>
Git-Commit-ID: 002f128b473fb82f454654be5081b0919ee01ab2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 09 Apr 2009 07:09:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  002f128b473fb82f454654be5081b0919ee01ab2
Gitweb:     http://git.kernel.org/tip/002f128b473fb82f454654be5081b0919ee01ab2
Author:     Paul Turner <pjt@google.com>
AuthorDate: Wed, 8 Apr 2009 15:29:43 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 9 Apr 2009 08:19:08 +0200

sched: remove redundant hierarchy walk in check_preempt_wakeup

Impact: micro-optimization

Under group scheduling we traverse up until we are at common siblings
to make the wakeup comparison on.

At this point however, they should have the same parent so continuing
to check up the tree is redundant.

Signed-off-by: Paul Turner <pjt@google.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <alpine.DEB.1.00.0904081520320.30317@kitami.corp.google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched_fair.c |   13 +++----------
 1 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 3816f21..5f9650e 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1487,17 +1487,10 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int sync)
 
 	find_matching_se(&se, &pse);
 
-	while (se) {
-		BUG_ON(!pse);
+	BUG_ON(!pse);
 
-		if (wakeup_preempt_entity(se, pse) == 1) {
-			resched_task(curr);
-			break;
-		}
-
-		se = parent_entity(se);
-		pse = parent_entity(pse);
-	}
+	if (wakeup_preempt_entity(se, pse) == 1)
+		resched_task(curr);
 }
 
 static struct task_struct *pick_next_task_fair(struct rq *rq)
