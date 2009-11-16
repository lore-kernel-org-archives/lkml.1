Return-Path: <linux-kernel-owner+w=401wt.eu-S1753835AbZKPRRC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbZKPRRC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 12:17:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753805AbZKPRQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 12:16:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:33336 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753626AbZKPRQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 12:16:37 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       torvalds@linux-foundation.org, avi@redhat.com, peterz@infradead.org,
       andi@firstfloor.org, fweisbec@gmail.com
Cc: Tejun Heo <tj@kernel.org>, Andi Kleen <ak@linux.intel.com>,
       Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 01/21] workqueue: fix race condition in schedule_on_each_cpu()
Date: Tue, 17 Nov 2009 02:15:06 +0900
Message-Id: <1258391726-30264-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1258391726-30264-1-git-send-email-tj@kernel.org>
References: <1258391726-30264-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 65a64464349883891e21e74af16c05d6e1eeb4e9 which allows
schedule_on_each_cpu() to be called from keventd added a race
condition.  schedule_on_each_cpu() may race with cpu hotplug and end
up executing the function twice on a cpu.

Fix it by moving direct execution into the section protected with
get/put_online_cpus().  While at it, update code such that direct
execution is done after works have been scheduled for all other cpus
and drop unnecessary cpu != orig test from flush loop.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 kernel/workqueue.c |   28 +++++++++++++---------------
 1 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 1232814..67e526b 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -692,31 +692,29 @@ int schedule_on_each_cpu(work_func_t func)
 	if (!works)
 		return -ENOMEM;
 
+	get_online_cpus();
+
 	/*
-	 * when running in keventd don't schedule a work item on itself.
-	 * Can just call directly because the work queue is already bound.
-	 * This also is faster.
-	 * Make this a generic parameter for other workqueues?
+	 * When running in keventd don't schedule a work item on
+	 * itself.  Can just call directly because the work queue is
+	 * already bound.  This also is faster.
 	 */
-	if (current_is_keventd()) {
+	if (current_is_keventd())
 		orig = raw_smp_processor_id();
-		INIT_WORK(per_cpu_ptr(works, orig), func);
-		func(per_cpu_ptr(works, orig));
-	}
 
-	get_online_cpus();
 	for_each_online_cpu(cpu) {
 		struct work_struct *work = per_cpu_ptr(works, cpu);
 
-		if (cpu == orig)
-			continue;
 		INIT_WORK(work, func);
-		schedule_work_on(cpu, work);
-	}
-	for_each_online_cpu(cpu) {
 		if (cpu != orig)
-			flush_work(per_cpu_ptr(works, cpu));
+			schedule_work_on(cpu, work);
 	}
+	if (orig >= 0)
+		func(per_cpu_ptr(works, orig));
+
+	for_each_online_cpu(cpu)
+		flush_work(per_cpu_ptr(works, cpu));
+
 	put_online_cpus();
 	free_percpu(works);
 	return 0;
-- 
1.6.4.2

