Return-Path: <linux-kernel-owner+w=401wt.eu-S1753395AbZK3LEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbZK3LEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 06:04:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752375AbZK3LEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 06:04:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:47288 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274AbZK3LEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 06:04:33 -0500
Message-ID: <4B13A654.8030306@kernel.org>
Date: Mon, 30 Nov 2009 20:02:44 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
CC: Avi Kivity <avi@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mm-commits@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       the arch/x86 maintainers <x86@kernel.org>
Subject: [PATCH tip/sched/urgent] sched: revert 498657a478c60be092208422fefa9c7b248729c2
References: <200911250111.nAP1BFg5030254@imap1.linux-foundation.org>  <4B0FEA3E.5050108@gmail.com> <1259335036.6483.440.camel@laptop> <alpine.LFD.2.00.0911271730330.24119@localhost.localdomain> <4B1113C0.30505@redhat.com> <4B138950.9040905@kernel.org> <alpine.LFD.2.00.0911301055000.24119@localhost.localdomain> <4B13A24E.1080100@kernel.org>
In-Reply-To: <4B13A24E.1080100@kernel.org>
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

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>
---
Again, my apologies for the unnecessary fuss.  I for some reason was
thinking schedule_tail() is always called after context_switch() and
the ifdefed preemption enable there led me to think that at that point
preemption was enabled once lock switch is over.

Thank you.

 include/linux/preempt.h |    4 ++++
 kernel/sched.c          |    2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index 72b1a10..736892c 100644
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -105,6 +105,10 @@ struct preempt_notifier;
  * @sched_out: we've just been preempted
  *    notifier: struct preempt_notifier for the task being preempted
  *    next: the task that's kicking us out
+ *
+ * Please note that sched_in and out are called under different
+ * contexts.  sched_in is called with rq lock held and irq disabled
+ * while sched_out is called without rq lock and irq enabled.
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
