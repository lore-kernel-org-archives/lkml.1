Return-Path: <linux-kernel-owner+w=401wt.eu-S1756503AbYBPRTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503AbYBPRTY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 12:19:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754445AbYBPRTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 12:19:16 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:33380 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923AbYBPRTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 12:19:16 -0500
Date: Sat, 16 Feb 2008 20:23:01 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] cleanup_workqueue_thread: remove the unneeded "cpu" parameter
Message-ID: <20080216172301.GA18527@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cleanup_workqueue_thread() doesn't need the second argument, remove it.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/workqueue.c~2_CWT_CPU	2008-02-16 19:33:03.000000000 +0300
+++ 25/kernel/workqueue.c	2008-02-16 20:02:51.000000000 +0300
@@ -770,7 +770,7 @@ struct workqueue_struct *__create_workqu
 }
 EXPORT_SYMBOL_GPL(__create_workqueue_key);
 
-static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
+static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq)
 {
 	/*
 	 * Our caller is either destroy_workqueue() or CPU_DEAD,
@@ -806,7 +806,6 @@ static void cleanup_workqueue_thread(str
 void destroy_workqueue(struct workqueue_struct *wq)
 {
 	const cpumask_t *cpu_map = wq_cpu_map(wq);
-	struct cpu_workqueue_struct *cwq;
 	int cpu;
 
 	get_online_cpus();
@@ -814,10 +813,8 @@ void destroy_workqueue(struct workqueue_
 	list_del(&wq->list);
 	spin_unlock(&workqueue_lock);
 
-	for_each_cpu_mask(cpu, *cpu_map) {
-		cwq = per_cpu_ptr(wq->cpu_wq, cpu);
-		cleanup_workqueue_thread(cwq, cpu);
-	}
+	for_each_cpu_mask(cpu, *cpu_map)
+		cleanup_workqueue_thread(per_cpu_ptr(wq->cpu_wq, cpu));
 	put_online_cpus();
 
 	free_percpu(wq->cpu_wq);
@@ -858,7 +855,7 @@ static int __devinit workqueue_cpu_callb
 		case CPU_UP_CANCELED:
 			start_workqueue_thread(cwq, -1);
 		case CPU_DEAD:
-			cleanup_workqueue_thread(cwq, cpu);
+			cleanup_workqueue_thread(cwq);
 			break;
 		}
 	}

