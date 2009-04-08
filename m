Return-Path: <linux-kernel-owner+w=401wt.eu-S1755297AbZDHWcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297AbZDHWcW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 18:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754028AbZDHWcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 18:32:12 -0400
Received: from smtp-out.google.com ([216.239.33.17]:1340 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973AbZDHWcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 18:32:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:subject:message-id:user-agent:mime-version:content-type;
	b=cBeq658E5rD5ufAW2uBi19RXwMF/bIrulnsVwo2oetbfR29vFyd2ROBdhMkR7hows
	TPihTcAvXOvbhiT6IggKg==
Date: Wed, 8 Apr 2009 15:29:43 -0700 (PDT)
From: Paul Turner <pjt@google.com>
To: mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: sched: remove redundant hierarchy walk in check_preempt_wakeup
Message-ID: <alpine.DEB.1.00.0904081520320.30317@kitami.corp.google.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, Peter,

In check_preempt_wakeup we walk up until both entities are queued on the
same cfs_rq.  After the iteration of vruntime vs wall-clock pre-emption 
changes the current check now checks at every level of the tree above 
this.  However, unless I'm missing something at this point they should
have a common parent.

Thanks,

- Paul

--

sched: remove redundant hierarchy walk in check_preempt_wakeup

Under group scheduling we traverse up until we are at common siblings to make
the wakeup comparison on.

At this point however, they should have the same parent so continuing to check
up the tree is redundant.

Signed-off-by: Paul Turner <pjt@google.com>
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
-- 
1.5.4.3

	
