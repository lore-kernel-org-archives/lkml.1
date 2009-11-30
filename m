Return-Path: <linux-kernel-owner+w=401wt.eu-S1751649AbZK3Lmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649AbZK3Lmn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 06:42:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751060AbZK3Lmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 06:42:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:51755 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbZK3Lmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 06:42:42 -0500
Message-ID: <4B13AF71.9010902@kernel.org>
Date: Mon, 30 Nov 2009 20:41:37 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH UPDATED 2.6.32-rc6] sched, kvm: fix race condition involving
 sched_in_preempt_notifers
References: <4AFD2801.7020900@kernel.org> <20091113095516.GD1364@elte.hu> <4AFEAB6D.60600@redhat.com> <4B138BC8.3090008@kernel.org> <4B13942E.3000002@redhat.com> <20091130100049.GA7054@elte.hu> <4B139A3F.4030505@redhat.com>
In-Reply-To: <4B139A3F.4030505@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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
Avi, thanks for spotting it.

 include/linux/preempt.h |    5 +++++
 kernel/sched.c          |    2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

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
index 3c91f11..e36c868 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2758,9 +2758,9 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	prev_state = prev->state;
 	finish_arch_switch(prev);
 	perf_event_task_sched_in(current, cpu_of(rq));
-	fire_sched_in_preempt_notifiers(current);
 	finish_lock_switch(rq, prev);
 
+	fire_sched_in_preempt_notifiers(current);
 	if (mm)
 		mmdrop(mm);
 	if (unlikely(prev_state == TASK_DEAD)) {
