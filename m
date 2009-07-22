Return-Path: <linux-kernel-owner+w=401wt.eu-S1752908AbZGVPY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbZGVPY5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 11:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752685AbZGVPY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 11:24:57 -0400
Received: from www.tglx.de ([62.245.132.106]:50733 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670AbZGVPY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 11:24:56 -0400
Date: Wed, 22 Jul 2009 17:24:00 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       David Miller <davem@davemloft.net>
Subject: [GIT pull] hrtimer_tasklet infrastructure for 2.6.31
Message-ID: <alpine.LFD.2.00.0907221719430.2813@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-fixes-for-linus-2 git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus-2

This implements the generic infrastructure which is neccesary to keep
the softirq assumptions of hrtimer users intact. Network folks are
waiting for it.

Peter moved it to softirq.c as requested and we added the necessary
helper functions and documentation/comments.

Thanks,

	tglx

------------------>
Peter Zijlstra (1):
      softirq: introduce tasklet_hrtimer infrastructure


 include/linux/interrupt.h |   26 ++++++++++++++++++
 kernel/softirq.c          |   64 ++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 89 insertions(+), 1 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 2721f07..fd4c9c6 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -14,6 +14,7 @@
 #include <linux/irqflags.h>
 #include <linux/smp.h>
 #include <linux/percpu.h>
+#include <linux/hrtimer.h>
 
 #include <asm/atomic.h>
 #include <asm/ptrace.h>
@@ -517,6 +518,31 @@ extern void tasklet_kill_immediate(struct tasklet_struct *t, unsigned int cpu);
 extern void tasklet_init(struct tasklet_struct *t,
 			 void (*func)(unsigned long), unsigned long data);
 
+struct tasklet_hrtimer {
+	struct hrtimer		timer;
+	struct tasklet_struct	tasklet;
+	enum hrtimer_restart	(*function)(struct hrtimer *);
+};
+
+extern void
+tasklet_hrtimer_init(struct tasklet_hrtimer *ttimer,
+		     enum hrtimer_restart (*function)(struct hrtimer *),
+		     clockid_t which_clock, enum hrtimer_mode mode);
+
+static inline
+int tasklet_hrtimer_start(struct tasklet_hrtimer *ttimer, ktime_t time,
+			  const enum hrtimer_mode mode)
+{
+	return hrtimer_start(&ttimer->timer, time, mode);
+}
+
+static inline
+void tasklet_hrtimer_cancel(struct tasklet_hrtimer *ttimer)
+{
+	hrtimer_cancel(&ttimer->timer);
+	tasklet_kill(&ttimer->tasklet);
+}
+
 /*
  * Autoprobing for irqs:
  *
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 3a94905..eb5e131 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -345,7 +345,9 @@ void open_softirq(int nr, void (*action)(struct softirq_action *))
 	softirq_vec[nr].action = action;
 }
 
-/* Tasklets */
+/*
+ * Tasklets
+ */
 struct tasklet_head
 {
 	struct tasklet_struct *head;
@@ -493,6 +495,66 @@ void tasklet_kill(struct tasklet_struct *t)
 
 EXPORT_SYMBOL(tasklet_kill);
 
+/*
+ * tasklet_hrtimer
+ */
+
+/*
+ * The trampoline is called when the hrtimer expires. If this is
+ * called from the hrtimer interrupt then we schedule the tasklet as
+ * the timer callback function expects to run in softirq context. If
+ * it's called in softirq context anyway (i.e. high resolution timers
+ * disabled) then the hrtimer callback is called right away.
+ */
+static enum hrtimer_restart __hrtimer_tasklet_trampoline(struct hrtimer *timer)
+{
+	struct tasklet_hrtimer *ttimer =
+		container_of(timer, struct tasklet_hrtimer, timer);
+
+	if (hrtimer_is_hres_active(timer)) {
+		tasklet_hi_schedule(&ttimer->tasklet);
+		return HRTIMER_NORESTART;
+	}
+	return ttimer->function(timer);
+}
+
+/*
+ * Helper function which calls the hrtimer callback from
+ * tasklet/softirq context
+ */
+static void __tasklet_hrtimer_trampoline(unsigned long data)
+{
+	struct tasklet_hrtimer *ttimer = (void *)data;
+	enum hrtimer_restart restart;
+
+	restart = ttimer->function(&ttimer->timer);
+	if (restart != HRTIMER_NORESTART)
+		hrtimer_restart(&ttimer->timer);
+}
+
+/**
+ * tasklet_hrtimer_init - Init a tasklet/hrtimer combo for softirq callbacks
+ * @ttimer:	 tasklet_hrtimer which is initialized
+ * @function:	 hrtimer callback funtion which gets called from softirq context
+ * @which_clock: clock id (CLOCK_MONOTONIC/CLOCK_REALTIME)
+ * @mode:	 hrtimer mode (HRTIMER_MODE_ABS/HRTIMER_MODE_REL)
+ */
+void tasklet_hrtimer_init(struct tasklet_hrtimer *ttimer,
+			  enum hrtimer_restart (*function)(struct hrtimer *),
+			  clockid_t which_clock, enum hrtimer_mode mode)
+{
+	hrtimer_init(&ttimer->timer, which_clock, mode);
+	ttimer->timer.function = __hrtimer_tasklet_trampoline;
+	tasklet_init(&ttimer->tasklet, __tasklet_hrtimer_trampoline,
+		     (unsigned long)ttimer);
+	ttimer->function = function;
+}
+EXPORT_SYMBOL_GPL(tasklet_hrtimer_init);
+
+/*
+ * Remote softirq bits
+ */
+
 DEFINE_PER_CPU(struct list_head [NR_SOFTIRQS], softirq_work_list);
 EXPORT_PER_CPU_SYMBOL(softirq_work_list);
 
