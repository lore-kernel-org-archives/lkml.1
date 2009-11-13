Return-Path: <linux-kernel-owner+w=401wt.eu-S1755169AbZKMJ3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbZKMJ3f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 04:29:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754820AbZKMJ3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 04:29:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:33414 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754730AbZKMJ32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 04:29:28 -0500
Message-ID: <4AFD26F5.809@kernel.org>
Date: Fri, 13 Nov 2009 18:29:25 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 2.6.32-rc6] workqueue: fix race condition in schedule_on_each_cpu()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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
Cc: Ingo Molnar <mingo@redhat.com>
---
Andi, Oleg, this patch tested fine on my machine but it would be great
if you guys can ack it.  Ingo, upon ack, can you please route this
patch?

Thanks.

 kernel/workqueue.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

Index: work/kernel/workqueue.c
===================================================================
--- work.orig/kernel/workqueue.c
+++ work/kernel/workqueue.c
@@ -692,31 +692,29 @@ int schedule_on_each_cpu(work_func_t fun
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
