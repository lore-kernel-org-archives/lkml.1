Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935994Ab0COJM2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 05:12:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935985Ab0COJMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 05:12:24 -0400
Date: Mon, 15 Mar 2010 10:10:10 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Ben Blum <bblum@google.com>, Jiri Slaby <jirislaby@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Miao Xie <miaox@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] move_task_off_dead_cpu: take rq->lock around
	select_fallback_rq()
Message-ID: <20100315091010.GA9131@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move_task_off_dead_cpu()->select_fallback_rq() reads/updates ->cpus_allowed
lockless. We can race with set_cpus_allowed() running in parallel.

Change it to take rq->lock around select_fallback_rq(). Note that it is not
trivial to move this spin_lock() into select_fallback_rq(), we must recheck
the task was not migrated after we take the lock and other callers do not
need this lock.

To avoid the races with other callers of select_fallback_rq() which rely on
TASK_WAKING, we also check p->state != TASK_WAKING and do nothing otherwise.
The owner of TASK_WAKING must update ->cpus_allowed and choose the correct
CPU anyway, and the subsequent __migrate_task() is just meaningless because
p->se.on_rq must be false.

Alternatively, we could change select_task_rq() to take rq->lock right
after it calls sched_class->select_task_rq(), but this looks a bit ugly.

Also, change it to not assume irqs are disabled and absorb __migrate_task_irq().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/sched.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- 34-rc1/kernel/sched.c~2_MTODC_TAKE_RQ_LOCK	2010-03-15 09:40:16.000000000 +0100
+++ 34-rc1/kernel/sched.c	2010-03-15 09:40:31.000000000 +0100
@@ -5509,29 +5509,29 @@ static int migration_thread(void *data)
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-
-static int __migrate_task_irq(struct task_struct *p, int src_cpu, int dest_cpu)
-{
-	int ret;
-
-	local_irq_disable();
-	ret = __migrate_task(p, src_cpu, dest_cpu);
-	local_irq_enable();
-	return ret;
-}
-
 /*
  * Figure out where task on dead CPU should go, use force if necessary.
  */
 static void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
 {
-	int dest_cpu;
-
+	struct rq *rq = cpu_rq(dead_cpu);
+	int needs_cpu, dest_cpu;
+	unsigned long flags;
 again:
-	dest_cpu = select_fallback_rq(dead_cpu, p);
+	local_irq_save(flags);
+
+	raw_spin_lock(&rq->lock);
+	needs_cpu = (task_cpu(p) == dead_cpu) && (p->state != TASK_WAKING);
+	if (needs_cpu)
+		dest_cpu = select_fallback_rq(dead_cpu, p);
+	raw_spin_unlock(&rq->lock);
 
 	/* It can have affinity changed while we were choosing. */
-	if (unlikely(!__migrate_task_irq(p, dead_cpu, dest_cpu)))
+	if (needs_cpu)
+		needs_cpu = !__migrate_task(p, dead_cpu, dest_cpu);
+	local_irq_restore(flags);
+
+	if (unlikely(needs_cpu))
 		goto again;
 }
 

