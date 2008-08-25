Return-Path: <linux-kernel-owner+w=401wt.eu-S1752295AbYHYUSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295AbYHYUSE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 16:18:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753212AbYHYURm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 16:17:42 -0400
Received: from 75-130-108-43.dhcp.oxfr.ma.charter.com ([75.130.108.43]:36222
	"EHLO dev.haskins.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753005AbYHYURl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 16:17:41 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 1/5] sched: only try to push a task on wakeup if it is
	migratable
To: mingo@elte.hu
Cc: srostedt@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, npiggin@suse.de,
       gregory.haskins@gmail.com
Date: Mon, 25 Aug 2008 16:15:24 -0400
Message-ID: <20080825201523.23217.39632.stgit@dev.haskins.net>
In-Reply-To: <20080825200852.23217.13842.stgit@dev.haskins.net>
References: <20080825200852.23217.13842.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no sense in wasting time trying to push a task away that
cannot move anywhere else.  We gain no benefit from trying to push
other tasks at this point, so if the task being woken up is non
migratable, just skip the whole operation.  This reduces overhead
in the wakeup path for certain tasks.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched_rt.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 6163e4c..196c024 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1229,14 +1229,16 @@ static void post_schedule_rt(struct rq *rq)
 }
 
 /*
- * If we are not running and we are not going to reschedule soon, we should
- * try to push tasks away now
+ * If we are not running, we are not going to reschedule soon,
+ * and we have tasks that could be pushed, we should try to push tasks
+ * away now
  */
 static void task_wake_up_rt(struct rq *rq, struct task_struct *p)
 {
 	if (!task_running(rq, p) &&
 	    !test_tsk_need_resched(rq->curr) &&
-	    rq->rt.overloaded)
+	    rq->rt.overloaded &&
+	    p->rt.nr_cpus_allowed > 1)
 		push_rt_tasks(rq);
 }
 

