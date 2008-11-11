Return-Path: <linux-kernel-owner+w=401wt.eu-S1752238AbYKKT6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbYKKT6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 14:58:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751381AbYKKT6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 14:58:21 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45064 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbYKKT6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 14:58:20 -0500
Date: Tue, 11 Nov 2008 21:59:05 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] workqueues: kill cpu_singlethread_map, use get_cpu_mask()
	instead
Message-ID: <20081111205905.GA915@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have cpu_bit_bitmap[] we don't need cpu_singlethread_map, we
can use get_cpu_mask(singlethread_cpu) directly.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- K-28/kernel/workqueue.c~WQ_KILL_ST_MAP	2008-11-11 21:06:20.000000000 +0100
+++ K-28/kernel/workqueue.c	2008-11-11 21:37:46.000000000 +0100
@@ -73,7 +73,6 @@ static DEFINE_SPINLOCK(workqueue_lock);
 static LIST_HEAD(workqueues);
 
 static int singlethread_cpu __read_mostly;
-static cpumask_t cpu_singlethread_map __read_mostly;
 /*
  * _cpu_down() first removes CPU from cpu_online_map, then CPU_DEAD
  * flushes cwq->worklist. This means that flush_workqueue/wait_on_work
@@ -92,7 +91,7 @@ static inline int is_single_threaded(str
 static const cpumask_t *wq_cpu_map(struct workqueue_struct *wq)
 {
 	return is_single_threaded(wq)
-		? &cpu_singlethread_map : &cpu_populated_map;
+		? get_cpu_mask(singlethread_cpu) : &cpu_populated_map;
 }
 
 static
@@ -980,7 +979,6 @@ void __init init_workqueues(void)
 {
 	cpu_populated_map = cpu_online_map;
 	singlethread_cpu = first_cpu(cpu_possible_map);
-	cpu_singlethread_map = cpumask_of_cpu(singlethread_cpu);
 	hotcpu_notifier(workqueue_cpu_callback, 0);
 	keventd_wq = create_workqueue("events");
 	BUG_ON(!keventd_wq);

