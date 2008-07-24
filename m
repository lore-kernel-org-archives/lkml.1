Return-Path: <linux-kernel-owner+w=401wt.eu-S1754751AbYGXWPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbYGXWPo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 18:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbYGXWPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 18:15:36 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:34251 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbYGXWPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 18:15:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=jckZUfPmfq+l/bH0VgRGT13AnR9iVyeZTWDm3qvPt56aeplwMd9d+H1TIhEL921lUR
         UJ91gNGOwn7HX3RltZeNr4F3rQ8HsHyhsKW98th5rv/RI2zSDYT+ix9fSVXi9wWF8L57
         vffpJUS+8gvMAYPpL1Ea2e7/Ou06NMHkD0k/A=
Subject: [patch, rfc: 2/2] sched, hotplug: ensure a task is on the valid
	cpu after set_cpus_allowed_ptr()
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 25 Jul 2008 00:15:30 +0200
Message-Id: <1216937730.5368.16.camel@earth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: sched, hotplug: ensure a task is on the valid cpu after
set_cpus_allowed_ptr()

---
    sched, hotplug: ensure a task is on the valid cpu after set_cpus_allowed_ptr()
    
    The 'new_mask' may not include task_cpu(p) so we migrate 'p' on another 'cpu'.
    In case it can't be placed on this 'cpu' immediately, we submit a request
    to the migration thread and wait for its completion.
    
    Now, by the moment this request gets handled by the migration_thread,
    'cpu' may well be offline/non-active. As a result, 'p' continues
    running on its old cpu which is not in the 'new_mask'.
    
    Fix it: ensure 'p' ends up on a valid cpu.
    
    Theoreticaly (but unlikely), we may get an endless loop if someone cpu_down()'s
    a new cpu we have choosen on each iteration.
    
    Alternatively, we may introduce a special type of request to migration_thread,
    namely "move_to_any_allowed_cpu" (e.g. by specifying dest_cpu == -1).
    
    Note, any_active_cpu() instead of any_online_cpu() would be better here.
    
    Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>

diff --git a/kernel/sched.c b/kernel/sched.c
index b4ccc8b..c3bd78a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5774,21 +5774,23 @@ int set_cpus_allowed_ptr(struct task_struct *p, const cpumask_t *new_mask)
 	}
 
 	/* Can the task run on the task's current CPU? If so, we're done */
-	if (cpu_isset(task_cpu(p), *new_mask))
-		goto out;
+	while (!cpu_isset(task_cpu(p), p->cpus_allowed)) {
+		int cpu = any_online_cpu(p->cpus_allowed);
 
-	if (migrate_task(p, any_online_cpu(*new_mask), &req)) {
-		/* Need to wait for migration thread (might exit: take ref). */
-		struct task_struct *mt = rq->migration_thread;
+		if (migrate_task(p, cpu, &req)) {
+			/* Need to wait for migration thread (might exit: take ref). */
+			struct task_struct *mt = rq->migration_thread;
 
-		get_task_struct(mt);
-		task_rq_unlock(rq, &flags);
-		wake_up_process(mt);
-		put_task_struct(mt);
+			get_task_struct(mt);
+			task_rq_unlock(rq, &flags);
+			wake_up_process(mt);
+			put_task_struct(mt);
 
-		wait_for_completion(&req.done);
-		tlb_migrate_finish(p->mm);
-		return 0;
+			wait_for_completion(&req.done);
+			tlb_migrate_finish(p->mm);
+
+			rq = task_rq_lock(p, &flags);
+		}
 	}
 out:
 	task_rq_unlock(rq, &flags);


