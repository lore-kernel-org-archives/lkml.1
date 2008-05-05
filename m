Return-Path: <linux-kernel-owner+w=401wt.eu-S1759545AbYEEOtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759545AbYEEOtu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 10:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755539AbYEEOtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 10:49:41 -0400
Received: from nds154-200.nds.lab.novell.com ([151.155.154.200]:56493 "EHLO
	lsg.lab.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752032AbYEEOtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 10:49:41 -0400
X-Greylist: delayed 1097 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 May 2008 10:49:41 EDT
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH] sched: fix SCHED_OTHER balance iterator to include all tasks
To: mingo@elte.hu, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, Gregory Haskins <ghaskins@novell.com>,
       David Bahi <dbahi@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Date: Mon, 05 May 2008 08:31:22 -0600
Message-ID: <20080505142739.24888.31658.stgit@lsg>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,
 The follow patch applies to sched-devel.  I know the original function was
 somehow trying to protect against dequeueing by pre-iterating.  I am not sure
 if I captured the intent properly in that regard.  What I can say is that the
 old algorithm would miss tasks, and that is now fixed.  It may need further
 adjustment if I missed the pre-iterating operation.

Hi Peter,
 I was wrong earlier when I mentioned there might be a problem with
 entity_is_task().  I think this was the root cause of what I was seeing.
 Sorry for the red-herring.

Regards,
-Greg

-----------------------
sched: fix SCHED_OTHER balance iterator to include all tasks

The currently logic inadvertently skips the last task on the run-queue,
resulting in missed balance opportunities.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
Signed-off-by: David Bahi <dbahi@novell.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>
---

 kernel/sched_fair.c |   19 +++++++------------
 1 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 87b7300..e8c289a 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1700,23 +1700,18 @@ __load_balance_iterator(struct cfs_rq *cfs_rq, struct list_head *next)
 	struct task_struct *p = NULL;
 	struct sched_entity *se;
 
-	if (next == &cfs_rq->tasks)
-		return NULL;
-
-	/* Skip over entities that are not tasks */
-	do {
+	while (next != &cfs_rq->tasks) {
 		se = list_entry(next, struct sched_entity, group_node);
 		next = next->next;
-	} while (next != &cfs_rq->tasks && !entity_is_task(se));
 
-	if (next == &cfs_rq->tasks)
-		return NULL;
+		/* Skip over entities that are not tasks */
+		if (entity_is_task(se)) {
+			p = task_of(se);
+			break;
+		}
+	}
 
 	cfs_rq->balance_iterator = next;
-
-	if (entity_is_task(se))
-		p = task_of(se);
-
 	return p;
 }
 

