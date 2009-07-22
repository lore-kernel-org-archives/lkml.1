Return-Path: <linux-kernel-owner+w=401wt.eu-S1752399AbZGVPEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399AbZGVPEI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 11:04:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768AbZGVPEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 11:04:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:57346 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbZGVPEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 11:04:06 -0400
Date: Wed, 22 Jul 2009 15:03:34 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, peterz@infradead.org, tglx@linutronix.de,
       davem@davemloft.net
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, peterz@infradead.org, tglx@linutronix.de,
       davem@davemloft.net
In-Reply-To: <1248265724.27058.1366.camel@twins>
References: <1248265724.27058.1366.camel@twins>
Subject: [tip:core/urgent] softirq: introduce tasklet_hrtimer infrastructure
Message-ID: <tip-9ba5f005c994ad28e266a0cd14ef29354be382c9@git.kernel.org>
Git-Commit-ID: 9ba5f005c994ad28e266a0cd14ef29354be382c9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 22 Jul 2009 15:03:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9ba5f005c994ad28e266a0cd14ef29354be382c9
Gitweb:     http://git.kernel.org/tip/9ba5f005c994ad28e266a0cd14ef29354be382c9
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 22 Jul 2009 14:18:35 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 22 Jul 2009 17:01:17 +0200

softirq: introduce tasklet_hrtimer infrastructure

commit ca109491f (hrtimer: removing all ur callback modes) moved all
hrtimer callbacks into hard interrupt context when high resolution
timers are active. That breaks code which relied on the assumption
that the callback happens in softirq context.

Provide a generic infrastructure which combines tasklets and hrtimers
together to provide an in-softirq hrtimer experience.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: torvalds@linux-foundation.org
Cc: kaber@trash.net
Cc: David Miller <davem@davemloft.net>
LKML-Reference: <1248265724.27058.1366.camel@twins>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


---
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
 
