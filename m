Return-Path: <linux-kernel-owner+w=401wt.eu-S1753082Ab0AHP1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082Ab0AHP1m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 10:27:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729Ab0AHP1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 10:27:41 -0500
Received: from mail2.picochip.com ([82.111.145.34]:35080 "EHLO
	thurne.picochip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752669Ab0AHP1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 10:27:39 -0500
From: Jamie Iles <jamie.iles@picochip.com>
To: linux-kernel@vger.kernel.org
Cc: Jamie Iles <jamie.iles@picochip.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH] sched/perf: make sure irqs are disabled for perf_event_task_sched_in()
Date: Fri,  8 Jan 2010 15:27:33 +0000
Message-Id: <1262964453-27370-1-git-send-email-jamie.iles@picochip.com>
X-Mailer: git-send-email 1.6.5.4
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (thurne.picochip.com [172.17.0.105]); Fri, 08 Jan 2010 15:27:10 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf_event_task_sched_in() expects interrupts to be disabled, but
on architectures with __ARCH_WANT_INTERRUPTS_ON_CTXSW defined, this
isn't true. If this is defined, disable irqs around the call in
finish_task_switch().

Signed-off-by: Jamie Iles <jamie.iles@picochip.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
---
 kernel/sched.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 22c14eb..78132b4 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2783,7 +2783,13 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	 */
 	prev_state = prev->state;
 	finish_arch_switch(prev);
+#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
+	local_irq_disable();
+#endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
 	perf_event_task_sched_in(current);
+#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
+	local_irq_enable();
+#endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
 	finish_lock_switch(rq, prev);
 
 	fire_sched_in_preempt_notifiers(current);
-- 
1.6.5.4

