Return-Path: <linux-kernel-owner+w=401wt.eu-S1753367AbYLMXuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbYLMXuq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 18:50:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751879AbYLMXug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 18:50:36 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:39159 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbYLMXuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 18:50:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=RcoqrXfCXJ0UwU7ghvX/HEkdacvnD3RucPfqKv5/skI8U0Rgwdiqfbnza+cJKoPmg8
         2hCvBRfHa+ivdICoRvfMubOq4ReWBoAKLTz3qzAoARMSCmcXjzb04Wl3wQn2Ewxs+dY7
         O+MG4gMwIVv/7G4XUL6KppprlpOBMmanhwUv8=
Message-ID: <49444A44.3030206@gmail.com>
Date: Sun, 14 Dec 2008 00:50:28 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Gregory Haskins <ghaskins@novell.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] rt/workqueue: fix an early crash and some warnings
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix early crash and build warnings

While building the broken/rt/workqueue topic, I got various warnings:

kernel/workqueue.c: In function ‘delayed_work_timer_fn’:
kernel/workqueue.c:214: attention : passing argument 3 of ‘__queue_work’ makes integer from pointer without a cast

This one is the cause of an early crash: the adress of the priority is passed instead of its
value, hence the following BUG_ON() triggering on sched.c:rt_mutex_setprio()

BUG_ON(prio < 0 || prio > MAX_PRIO)

Various warnings are displayed because of confusion between common linked-list and priority
sorted linked-list:

kernel/workqueue.c: In function ‘flush_work’:
kernel/workqueue.c:527: attention : passing argument 1 of ‘list_empty’ from incompatible pointer type
kernel/workqueue.c:535: attention : assignment from incompatible pointer type
kernel/workqueue.c:539: attention : assignment from incompatible pointer type

This patch fixes them (hopefully correctly).

broken/rt/workqueue boots correctly now.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index f0c32ff..b704c40 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -211,7 +211,7 @@ static void delayed_work_timer_fn(unsigned long __data)
 	struct workqueue_struct *wq = cwq->wq;
 
 	__queue_work(wq_per_cpu(wq, smp_processor_id()),
-		     &dwork->work, &dwork->prio);
+		     &dwork->work, dwork->prio);
 }
 
 /**
@@ -511,7 +511,7 @@ EXPORT_SYMBOL_GPL(flush_workqueue);
 int flush_work(struct work_struct *work)
 {
 	struct cpu_workqueue_struct *cwq;
-	struct list_head *prev;
+	struct plist_head *prev;
 	struct wq_barrier barr;
 
 	might_sleep();
@@ -524,7 +524,7 @@ int flush_work(struct work_struct *work)
 
 	prev = NULL;
 	spin_lock_irq(&cwq->lock);
-	if (!list_empty(&work->entry)) {
+	if (!plist_node_empty(&work->entry)) {
 		/*
 		 * See the comment near try_to_grab_pending()->smp_rmb().
 		 * If it was re-queued under us we are not going to wait.
@@ -532,7 +532,7 @@ int flush_work(struct work_struct *work)
 		smp_rmb();
 		if (unlikely(cwq != get_wq_data(work)))
 			goto out;
-		prev = &work->entry;
+		prev = &work->entry.plist;
 	} else {
 		if (cwq->current_work != work)
 			goto out;
-- 
1.6.0.4

