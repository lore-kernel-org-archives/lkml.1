Return-Path: <linux-kernel-owner+w=401wt.eu-S1755285AbZLBD6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbZLBD6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 22:58:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755096AbZLBD50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 22:57:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:56248 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755004AbZLBD5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 22:57:22 -0500
From: Tejun Heo <tj@kernel.org>
To: tglx@linutronix.de, mingo@elte.hu, avi@redhat.com, peterz@infradead.org,
       efault@gmx.de, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/7] sched: revert 498657a478c60be092208422fefa9c7b248729c2
Date: Wed,  2 Dec 2009 12:56:46 +0900
Message-Id: <1259726212-30259-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1259726212-30259-1-git-send-email-tj@kernel.org>
References: <1259726212-30259-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

498657a478c60be092208422fefa9c7b248729c2 incorrectly assumed that
preempt wasn't disabled around context_switch() and thus was fixing
imaginary problem.  It also broke kvm because it depended on
->sched_in() to be called with irq enabled so that it can do smp calls
from there.

Revert the incorrect commit and add comment describing different
contexts under with the two callbacks are invoked.

Avi: spotted transposed in/out in the added comment.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>
---
 include/linux/preempt.h |    5 +++++
 kernel/sched.c          |    2 +-
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index 72b1a10..2e681d9 100644
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -105,6 +105,11 @@ struct preempt_notifier;
  * @sched_out: we've just been preempted
  *    notifier: struct preempt_notifier for the task being preempted
  *    next: the task that's kicking us out
+ *
+ * Please note that sched_in and out are called under different
+ * contexts.  sched_out is called with rq lock held and irq disabled
+ * while sched_in is called without rq lock and irq enabled.  This
+ * difference is intentional and depended upon by its users.
  */
 struct preempt_ops {
 	void (*sched_in)(struct preempt_notifier *notifier, int cpu);
diff --git a/kernel/sched.c b/kernel/sched.c
index b3d4e2b..1031cae 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2768,9 +2768,9 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	prev_state = prev->state;
 	finish_arch_switch(prev);
 	perf_event_task_sched_in(current, cpu_of(rq));
-	fire_sched_in_preempt_notifiers(current);
 	finish_lock_switch(rq, prev);
 
+	fire_sched_in_preempt_notifiers(current);
 	if (mm)
 		mmdrop(mm);
 	if (unlikely(prev_state == TASK_DEAD)) {
-- 
1.6.4.2

