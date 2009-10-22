Return-Path: <linux-kernel-owner+w=401wt.eu-S1753841AbZJVGDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbZJVGDo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 02:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753590AbZJVGDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 02:03:37 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39469 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbZJVGCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 02:02:30 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: fengguang.wu@intel.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] HWPOISON: Allow schedule_on_each_cpu() from keventd
Date: Thu, 22 Oct 2009 08:02:31 +0200
Message-Id: <1256191352-6903-8-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1256191352-6903-7-git-send-email-andi@firstfloor.org>
References: <i>
 <1256191352-6903-1-git-send-email-andi@firstfloor.org>
 <1256191352-6903-2-git-send-email-andi@firstfloor.org>
 <1256191352-6903-3-git-send-email-andi@firstfloor.org>
 <1256191352-6903-4-git-send-email-andi@firstfloor.org>
 <1256191352-6903-5-git-send-email-andi@firstfloor.org>
 <1256191352-6903-6-git-send-email-andi@firstfloor.org>
 <1256191352-6903-7-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Right now when calling schedule_on_each_cpu() from keventd there
is a deadlock because it tries to schedule a work item on the current CPU
too. This happens via lru_add_drain_all() in hwpoison.

Just call the function for the current CPU in this case. This is actually
faster too.

Debugging with Fengguang Wu & Max Asbock

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 kernel/workqueue.c |   21 +++++++++++++++++++--
 1 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index addfe2d..f61a2fe 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -667,21 +667,38 @@ EXPORT_SYMBOL(schedule_delayed_work_on);
 int schedule_on_each_cpu(work_func_t func)
 {
 	int cpu;
+	int orig = -1;
 	struct work_struct *works;
 
 	works = alloc_percpu(struct work_struct);
 	if (!works)
 		return -ENOMEM;
 
+	/*
+	 * when running in keventd don't schedule a work item on itself.
+	 * Can just call directly because the work queue is already bound.
+	 * This also is faster.
+	 * Make this a generic parameter for other workqueues?
+	 */
+	if (current_is_keventd()) {
+		orig = raw_smp_processor_id();
+		INIT_WORK(per_cpu_ptr(works, orig), func);
+		func(per_cpu_ptr(works, orig));
+	}
+
 	get_online_cpus();
 	for_each_online_cpu(cpu) {
 		struct work_struct *work = per_cpu_ptr(works, cpu);
 
+		if (cpu == orig)
+			continue;
 		INIT_WORK(work, func);
 		schedule_work_on(cpu, work);
 	}
-	for_each_online_cpu(cpu)
-		flush_work(per_cpu_ptr(works, cpu));
+	for_each_online_cpu(cpu) {
+		if (cpu != orig)
+			flush_work(per_cpu_ptr(works, cpu));
+	}
 	put_online_cpus();
 	free_percpu(works);
 	return 0;
-- 
1.6.0.2

