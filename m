Return-Path: <linux-kernel-owner+w=401wt.eu-S1753458AbZCLI4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbZCLI4j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 04:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754294AbZCLI4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 04:56:23 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:42799 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527AbZCLI4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 04:56:22 -0400
Message-ID: <49B8CE2B.8070402@davidnewall.com>
Date: Thu, 12 Mar 2009 19:26:11 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=_hawking.rebel.net.au-32300-1236848178-0001-2"
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] (latest tip) make dequeue_task less confusing
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hawking.rebel.net.au-32300-1236848178-0001-2
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit

The dequeue_patch function in kernel/sched.c is complicated by 
including a sleep parameter.  This parameter is always zero 
except in one instance.  This patch clarifies the task of 
dequeue_patch by removing the sleep parameter and moving the 
code that handles non-zero sleep to that one place where it is 
needed.


--=_hawking.rebel.net.au-32300-1236848178-0001-2
Content-Type: text/x-patch; name="sched.patch"; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sched.patch"

--- kernel/sched.c	2009-03-12 18:41:41.000000000 +1030
+++ kernel/sched.c.dn	2009-03-12 18:45:18.000000000 +1030
@@ -1791,21 +1791,10 @@
 	p->se.on_rq = 1;
 }
 
-static void dequeue_task(struct rq *rq, struct task_struct *p, int sleep)
+static void dequeue_task(struct rq *rq, struct task_struct *p)
 {
-	if (sleep) {
-		if (p->se.last_wakeup) {
-			update_avg(&p->se.avg_overlap,
-				p->se.sum_exec_runtime - p->se.last_wakeup);
-			p->se.last_wakeup = 0;
-		} else {
-			update_avg(&p->se.avg_wakeup,
-				sysctl_sched_wakeup_granularity);
-		}
-	}
-
 	sched_info_dequeued(p);
-	p->sched_class->dequeue_task(rq, p, sleep);
+	p->sched_class->dequeue_task(rq, p, 0);
 	p->se.on_rq = 0;
 }
 
@@ -1875,7 +1864,22 @@
 	if (task_contributes_to_load(p))
 		rq->nr_uninterruptible++;
 
-	dequeue_task(rq, p, sleep);
+	if (sleep) {
+		if (p->se.last_wakeup) {
+			update_avg(&p->se.avg_overlap,
+				p->se.sum_exec_runtime - p->se.last_wakeup);
+			p->se.last_wakeup = 0;
+		} else {
+			update_avg(&p->se.avg_wakeup,
+				sysctl_sched_wakeup_granularity);
+		}
+	}
+
+	/*dequeue_task(rq, p, sleep);*/
+	sched_info_dequeued(p);
+	p->sched_class->dequeue_task(rq, p, sleep);
+	p->se.on_rq = 0;
+
 	dec_nr_running(rq);
 }
 
@@ -5323,7 +5327,7 @@
 	on_rq = p->se.on_rq;
 	running = task_current(rq, p);
 	if (on_rq)
-		dequeue_task(rq, p, 0);
+		dequeue_task(rq, p);
 	if (running)
 		p->sched_class->put_prev_task(rq, p);
 
@@ -5372,7 +5376,7 @@
 	}
 	on_rq = p->se.on_rq;
 	if (on_rq)
-		dequeue_task(rq, p, 0);
+		dequeue_task(rq, p);
 
 	p->static_prio = NICE_TO_PRIO(nice);
 	set_load_weight(p);
@@ -9189,7 +9193,7 @@
 	on_rq = tsk->se.on_rq;
 
 	if (on_rq)
-		dequeue_task(rq, tsk, 0);
+		dequeue_task(rq, tsk);
 	if (unlikely(running))
 		tsk->sched_class->put_prev_task(rq, tsk);
 


--=_hawking.rebel.net.au-32300-1236848178-0001-2--
