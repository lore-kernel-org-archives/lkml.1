Return-Path: <linux-kernel-owner+w=401wt.eu-S1754346AbZGVM1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbZGVM1l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 08:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754190AbZGVM1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 08:27:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:41215 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187AbZGVM1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 08:27:40 -0400
Subject: [PATCH] softirq: tasklet_hrtimer
From: Peter Zijlstra <peterz@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, tglx@linutronix.de, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kaber@trash.net
In-Reply-To: <20090721.201855.32703627.davem@davemloft.net>
References: <1247588890.7500.186.camel@twins>
	 <alpine.LFD.2.01.0907140940440.13838@localhost.localdomain>
	 <1247832892.15751.35.camel@twins>
	 <20090721.201855.32703627.davem@davemloft.net>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 22 Jul 2009 14:28:44 +0200
Message-Id: <1248265724.27058.1366.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas, will you take this?

---
Subject: softirq: tasklet_hrtimer
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed Jul 22 14:18:35 CEST 2009

Stick tasklets and hrtimers together to provide an in-softirq hrtimer
experience.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/interrupt.h |   11 +++++++++++
 kernel/softirq.c          |   44 +++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 54 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/interrupt.h
===================================================================
--- linux-2.6.orig/include/linux/interrupt.h
+++ linux-2.6/include/linux/interrupt.h
@@ -14,6 +14,7 @@
 #include <linux/irqflags.h>
 #include <linux/smp.h>
 #include <linux/percpu.h>
+#include <linux/hrtimer.h>
 
 #include <asm/atomic.h>
 #include <asm/ptrace.h>
@@ -517,6 +518,16 @@ extern void tasklet_kill_immediate(struc
 extern void tasklet_init(struct tasklet_struct *t,
 			 void (*func)(unsigned long), unsigned long data);
 
+struct tasklet_hrtimer {
+	struct hrtimer 		timer;
+	struct tasklet_struct	tasklet;
+	enum hrtimer_restart	(*function)(struct hrtimer *);
+};
+
+void tasklet_hrtimer_init(struct tasklet_hrtimer *ttimer,
+			  enum hrtimer_restart (*function)(struct hrtimer *),
+			  clockid_t which_clock, enum hrtimer_mode mode);
+
 /*
  * Autoprobing for irqs:
  *
Index: linux-2.6/kernel/softirq.c
===================================================================
--- linux-2.6.orig/kernel/softirq.c
+++ linux-2.6/kernel/softirq.c
@@ -345,7 +345,9 @@ void open_softirq(int nr, void (*action)
 	softirq_vec[nr].action = action;
 }
 
-/* Tasklets */
+/*
+ * Tasklets
+ */
 struct tasklet_head
 {
 	struct tasklet_struct *head;
@@ -493,6 +495,46 @@ void tasklet_kill(struct tasklet_struct 
 
 EXPORT_SYMBOL(tasklet_kill);
 
+/*
+ * tasklet_hrtimer
+ */
+
+static enum hrtimer_restart __hrtimer_tasklet_trampoline(struct hrtimer *timer)
+{
+	struct tasklet_hrtimer *ttimer =
+		container_of(timer, struct tasklet_hrtimer, timer);
+
+	tasklet_hi_schedule(&ttimer->tasklet);
+
+	return HRTIMER_NORESTART;
+}
+
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
 

