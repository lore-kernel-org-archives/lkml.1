Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782Ab0CNKjJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 06:39:09 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:52892 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757313Ab0CNKiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 06:38:55 -0400
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, mitake@dcl.info.waseda.ac.jp,
       h.mitake@gmail.com, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jason Baron <jbaron@redhat.com>
Subject: [PATCH RFC 10/11] Adopt kernel/sched.c to lock monitor
Date: Sun, 14 Mar 2010 19:38:47 +0900
Message-Id: <1268563128-6486-11-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1268563128-6486-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1268563128-6486-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are some points of directly calling the macros spin_{acquire, release}()
and the function lock_set_subclass() in kernel/sched.c.

Now spinlock_t doesn't have struct lockdep_map,
so this patch fixes them with the rule of lock monitor.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Jason Baron <jbaron@redhat.com>
---
 kernel/sched.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 7266b91..6c8a52e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -891,7 +891,7 @@ static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
 	 * fix up the runqueue lock - which gets 'carried over' from
 	 * prev into current:
 	 */
-	spin_acquire(&rq->lock.dep_map, 0, 0, _THIS_IP_);
+	spin_acquire(&rq->lock.monitor, 0, 0, _THIS_IP_);
 
 	raw_spin_unlock_irq(&rq->lock);
 }
@@ -1803,7 +1803,7 @@ static inline void double_unlock_balance(struct rq *this_rq, struct rq *busiest)
 	__releases(busiest->lock)
 {
 	raw_spin_unlock(&busiest->lock);
-	lock_set_subclass(&this_rq->lock.dep_map, 0, _RET_IP_);
+	lock_set_subclass(&this_rq->lock.monitor.dep_map, 0, _RET_IP_);
 }
 #endif
 
@@ -2905,7 +2905,7 @@ context_switch(struct rq *rq, struct task_struct *prev,
 	 * do an early lockdep release here:
 	 */
 #ifndef __ARCH_WANT_UNLOCKED_CTXSW
-	spin_release(&rq->lock.dep_map, 1, _THIS_IP_);
+	spin_release(&rq->lock.monitor, 1, _THIS_IP_);
 #endif
 
 	/* Here we just switch the register state and the stack. */
@@ -6725,7 +6725,7 @@ SYSCALL_DEFINE0(sched_yield)
 	 * no need to preempt or enable interrupts:
 	 */
 	__release(rq->lock);
-	spin_release(&rq->lock.dep_map, 1, _THIS_IP_);
+	spin_release(&rq->lock.monitor, 1, _THIS_IP_);
 	do_raw_spin_unlock(&rq->lock);
 	preempt_enable_no_resched();
 
-- 
1.6.5.2

