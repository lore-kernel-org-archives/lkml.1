Return-Path: <linux-kernel-owner+w=401wt.eu-S1753353AbYIEMaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbYIEMaz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 08:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbYIEMar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 08:30:47 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:55276 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbYIEMaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 08:30:46 -0400
Date: Fri, 5 Sep 2008 18:00:04 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Dipankar Sarma <dipankar@in.ibm.com>
Subject: [PATCH] sched: Fix __load_balance_iterator() for cfq with only one
	task
Message-ID: <20080905123004.GD6238@in.ibm.com>
Reply-To: ego@in.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched: Fix __load_balance_iterator() for cfq with only one task.

From: Gautham R Shenoy <ego@in.ibm.com>

The __load_balance_iterator() returns a NULL when there's only one
sched_entity which is a task. It is caused by the following code-path.


	/* Skip over entities that are not tasks */
	do {
		se = list_entry(next, struct sched_entity, group_node);
		next = next->next;
	} while (next != &cfs_rq->tasks && !entity_is_task(se));

	if (next == &cfs_rq->tasks)
		return NULL;
	^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
      This will return NULL even when se is a task.

As a side-effect, there was a regression in sched_mc behavior since 2.6.25,
since iter_move_one_task() when it calls load_balance_start_fair(),
would not get any tasks to move!

Fix this by checking if the last entity was a task or not.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
---

 kernel/sched_fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index fb8994c..f1c96e3 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1451,7 +1451,7 @@ __load_balance_iterator(struct cfs_rq *cfs_rq, struct list_head *next)
 		next = next->next;
 	} while (next != &cfs_rq->tasks && !entity_is_task(se));
 
-	if (next == &cfs_rq->tasks)
+	if (next == &cfs_rq->tasks && !entity_is_task(se))
 		return NULL;
 
 	cfs_rq->balance_iterator = next;
-- 
Thanks and Regards
gautham
