Return-Path: <linux-kernel-owner+w=401wt.eu-S1945971AbXEAVr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945971AbXEAVr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 17:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945974AbXEAVr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 17:47:58 -0400
Received: from mail.screens.ru ([213.234.233.54]:50102 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945971AbXEAVr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 17:47:57 -0400
Date: Wed, 2 May 2007 01:47:37 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ego@in.ibm.com, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] workqueues: shift kthread_bind() from CPU_UP_PREPARE to CPU_ONLINE
Message-ID: <20070501214737.GA183@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

CPU_UP_PREPARE binds cwq->thread to the new CPU. So CPU_UP_CANCELED tries to
wake up the task which is bound to the failed CPU.

With this patch we don't bind cwq->thread until CPU becomes online. The first
wake_up() after kthread_create() is a bit special, make a simple helper for
that.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- OLD/kernel/workqueue.c~2_BIND	2007-05-01 22:18:15.000000000 +0400
+++ OLD/kernel/workqueue.c	2007-05-02 00:17:01.000000000 +0400
@@ -631,15 +631,21 @@ static int create_workqueue_thread(struc
 
 	cwq->thread = p;
 	cwq->should_stop = 0;
-	if (!is_single_threaded(wq))
-		kthread_bind(p, cpu);
-
-	if (is_single_threaded(wq) || cpu_online(cpu))
-		wake_up_process(p);
 
 	return 0;
 }
 
+static void start_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
+{
+	struct task_struct *p = cwq->thread;
+
+	if (p != NULL) {
+		if (cpu >= 0)
+			kthread_bind(p, cpu);
+		wake_up_process(p);
+	}
+}
+
 struct workqueue_struct *__create_workqueue(const char *name,
 					    int singlethread, int freezeable)
 {
@@ -665,6 +671,7 @@ struct workqueue_struct *__create_workqu
 	if (singlethread) {
 		cwq = init_cpu_workqueue(wq, singlethread_cpu);
 		err = create_workqueue_thread(cwq, singlethread_cpu);
+		start_workqueue_thread(cwq, -1);
 	} else {
 		mutex_lock(&workqueue_mutex);
 		list_add(&wq->list, &workqueues);
@@ -674,6 +681,7 @@ struct workqueue_struct *__create_workqu
 			if (err || !cpu_online(cpu))
 				continue;
 			err = create_workqueue_thread(cwq, cpu);
+			start_workqueue_thread(cwq, cpu);
 		}
 		mutex_unlock(&workqueue_mutex);
 	}
@@ -773,12 +781,11 @@ static int __devinit workqueue_cpu_callb
 			return NOTIFY_BAD;
 
 		case CPU_ONLINE:
-			wake_up_process(cwq->thread);
+			start_workqueue_thread(cwq, cpu);
 			break;
 
 		case CPU_UP_CANCELED:
-			if (cwq->thread)
-				wake_up_process(cwq->thread);
+			start_workqueue_thread(cwq, -1);
 		case CPU_DEAD:
 			cleanup_workqueue_thread(cwq, cpu);
 			break;

