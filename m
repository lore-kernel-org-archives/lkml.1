Return-Path: <linux-kernel-owner+w=401wt.eu-S1752502AbXLITRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502AbXLITRA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 14:17:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750965AbXLITQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 14:16:53 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:27084 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbXLITQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 14:16:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=d6iir5F3GdoD9KFCJVlimc8tCG7SWj9AE3kB8auM5UsAXGW4BOobKppYCnfUEzVL085mn0xJIeCf1qP7UQc6VnIGJ4ld0hd75vJtEGqNyK/7OD1VgHgYSQL4msaBkI09T5KrIIpEv4dqNnfpAAhZbKDslAjaSPDMYV6mybXvH9I=
Subject: [PATCH, cleaun-up git-sched 2/3] get rid of 'new_cpu' in
	try_to_wake_up()
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <srostedt@redhat.com>,
       Gregory Haskins <ghaskins@novell.com>,
       LKML Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 09 Dec 2007 20:16:44 +0100
Message-Id: <1197227804.6991.29.camel@earth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Adamushko <dmitry.adamushko@gmail.com>

Clean-up try_to_wake_up().

Get rid of the 'new_cpu' variable in try_to_wake_up() [ that's, one #ifdef section less ].
Also remove a few redundant blank lines.

Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>

---
diff --git a/kernel/sched.c b/kernel/sched.c
index 91f4ea5..285003b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1553,9 +1553,6 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state, int sync)
 	unsigned long flags;
 	long old_state;
 	struct rq *rq;
-#ifdef CONFIG_SMP
-	int new_cpu;
-#endif
 
 	rq = task_rq_lock(p, &flags);
 	old_state = p->state;
@@ -1573,9 +1570,9 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state, int sync)
 	if (unlikely(task_running(rq, p)))
 		goto out_activate;
 
-	new_cpu = p->sched_class->select_task_rq(p, sync);
-	if (new_cpu != cpu) {
-		set_task_cpu(p, new_cpu);
+	cpu = p->sched_class->select_task_rq(p, sync);
+	if (cpu != orig_cpu) {
+		set_task_cpu(p, cpu);
 		task_rq_unlock(rq, &flags);
 		/* might preempt at this point */
 		rq = task_rq_lock(p, &flags);
@@ -1602,10 +1599,8 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state, int sync)
 			}
 		}
 	}
-
 #endif
 
-
 out_activate:
 #endif /* CONFIG_SMP */
 	schedstat_inc(p, se.nr_wakeups);


