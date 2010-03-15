Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935982Ab0COJMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 05:12:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935894Ab0COJMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 05:12:20 -0400
Date: Mon, 15 Mar 2010 10:10:14 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Ben Blum <bblum@google.com>, Jiri Slaby <jirislaby@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Miao Xie <miaox@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] move_task_off_dead_cpu: remove retry logic
Message-ID: <20100315091014.GA9138@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous patch preserved the retry logic, but it looks unneeded.

__migrate_task() can only fail if we raced with migration after we dropped
the lock, but in this case the caller of set_cpus_allowed/etc must initiate
migration itself if ->on_rq == T.

We already fixed p->cpus_allowed, the changes in active/online masks must
be visible to racer, it should migrate the task to online cpu correctly.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/sched.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- 34-rc1/kernel/sched.c~2_XXX_MTODC_DONT_RETRY	2010-03-15 09:40:31.000000000 +0100
+++ 34-rc1/kernel/sched.c	2010-03-15 09:40:44.000000000 +0100
@@ -5517,7 +5517,7 @@ static void move_task_off_dead_cpu(int d
 	struct rq *rq = cpu_rq(dead_cpu);
 	int needs_cpu, dest_cpu;
 	unsigned long flags;
-again:
+
 	local_irq_save(flags);
 
 	raw_spin_lock(&rq->lock);
@@ -5525,14 +5525,13 @@ again:
 	if (needs_cpu)
 		dest_cpu = select_fallback_rq(dead_cpu, p);
 	raw_spin_unlock(&rq->lock);
-
-	/* It can have affinity changed while we were choosing. */
+	/*
+	 * It can only fail if we race with set_cpus_allowed(),
+	 * in the racer should migrate the task anyway.
+	 */
 	if (needs_cpu)
-		needs_cpu = !__migrate_task(p, dead_cpu, dest_cpu);
+		__migrate_task(p, dead_cpu, dest_cpu);
 	local_irq_restore(flags);
-
-	if (unlikely(needs_cpu))
-		goto again;
 }
 
 /*

