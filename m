Return-Path: <linux-kernel-owner+w=401wt.eu-S1757595AbYGZTxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595AbYGZTxA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 15:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754527AbYGZTwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 15:52:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40838 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754474AbYGZTwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 15:52:51 -0400
Date: Sat, 26 Jul 2008 21:52:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] tracing fixes
Message-ID: <20080726195237.GA2406@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull the latest tracing-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-fixes-for-linus

Thanks,

	Ingo

------------------>
Ingo Molnar (2):
      ftrace: remove latency-tracer leftover
      ftrace: fix modular build

Steven Rostedt (3):
      ftrace: fix 4d3702b6 (post-v2.6.26): WARNING: at kernel/lockdep.c:2731 check_flags (ftrace)
      ftrace: only trace preempt off with preempt tracer
      ftrace: disable tracing on acpi idle calls


 drivers/acpi/processor_idle.c     |    6 ++++++
 kernel/trace/trace.c              |    3 ---
 kernel/trace/trace_irqsoff.c      |    8 ++++++--
 kernel/trace/trace_sched_wakeup.c |   27 ++++++++++++++++-----------
 4 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index d592dbb..b7f2963 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -272,6 +272,8 @@ static atomic_t c3_cpu_count;
 /* Common C-state entry for C2, C3, .. */
 static void acpi_cstate_enter(struct acpi_processor_cx *cstate)
 {
+	/* Don't trace irqs off for idle */
+	stop_critical_timings();
 	if (cstate->entry_method == ACPI_CSTATE_FFH) {
 		/* Call into architectural FFH based C-state */
 		acpi_processor_ffh_cstate_enter(cstate);
@@ -284,6 +286,7 @@ static void acpi_cstate_enter(struct acpi_processor_cx *cstate)
 		   gets asserted in time to freeze execution properly. */
 		unused = inl(acpi_gbl_FADT.xpm_timer_block.address);
 	}
+	start_critical_timings();
 }
 #endif /* !CONFIG_CPU_IDLE */
 
@@ -1418,6 +1421,8 @@ static inline void acpi_idle_update_bm_rld(struct acpi_processor *pr,
  */
 static inline void acpi_idle_do_entry(struct acpi_processor_cx *cx)
 {
+	/* Don't trace irqs off for idle */
+	stop_critical_timings();
 	if (cx->entry_method == ACPI_CSTATE_FFH) {
 		/* Call into architectural FFH based C-state */
 		acpi_processor_ffh_cstate_enter(cx);
@@ -1432,6 +1437,7 @@ static inline void acpi_idle_do_entry(struct acpi_processor_cx *cx)
 		   gets asserted in time to freeze execution properly. */
 		unused = inl(acpi_gbl_FADT.xpm_timer_block.address);
 	}
+	start_critical_timings();
 }
 
 /**
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 868e121..fc20e09 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1203,9 +1203,6 @@ static void *s_next(struct seq_file *m, void *v, loff_t *pos)
 
 	iter->pos = *pos;
 
-	if (last_ent && !ent)
-		seq_puts(m, "\n\nvim:ft=help\n");
-
 	return ent;
 }
 
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 421d6fe..ece6cfb 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -253,12 +253,14 @@ void start_critical_timings(void)
 	if (preempt_trace() || irq_trace())
 		start_critical_timing(CALLER_ADDR0, CALLER_ADDR1);
 }
+EXPORT_SYMBOL_GPL(start_critical_timings);
 
 void stop_critical_timings(void)
 {
 	if (preempt_trace() || irq_trace())
 		stop_critical_timing(CALLER_ADDR0, CALLER_ADDR1);
 }
+EXPORT_SYMBOL_GPL(stop_critical_timings);
 
 #ifdef CONFIG_IRQSOFF_TRACER
 #ifdef CONFIG_PROVE_LOCKING
@@ -337,12 +339,14 @@ EXPORT_SYMBOL(trace_hardirqs_off_caller);
 #ifdef CONFIG_PREEMPT_TRACER
 void trace_preempt_on(unsigned long a0, unsigned long a1)
 {
-	stop_critical_timing(a0, a1);
+	if (preempt_trace())
+		stop_critical_timing(a0, a1);
 }
 
 void trace_preempt_off(unsigned long a0, unsigned long a1)
 {
-	start_critical_timing(a0, a1);
+	if (preempt_trace())
+		start_critical_timing(a0, a1);
 }
 #endif /* CONFIG_PREEMPT_TRACER */
 
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 3c8d61d..e303ccb 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -26,7 +26,8 @@ static struct task_struct	*wakeup_task;
 static int			wakeup_cpu;
 static unsigned			wakeup_prio = -1;
 
-static DEFINE_SPINLOCK(wakeup_lock);
+static raw_spinlock_t wakeup_lock =
+	(raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
 
 static void __wakeup_reset(struct trace_array *tr);
 
@@ -56,7 +57,8 @@ wakeup_tracer_call(unsigned long ip, unsigned long parent_ip)
 	if (unlikely(disabled != 1))
 		goto out;
 
-	spin_lock_irqsave(&wakeup_lock, flags);
+	local_irq_save(flags);
+	__raw_spin_lock(&wakeup_lock);
 
 	if (unlikely(!wakeup_task))
 		goto unlock;
@@ -71,7 +73,8 @@ wakeup_tracer_call(unsigned long ip, unsigned long parent_ip)
 	trace_function(tr, data, ip, parent_ip, flags);
 
  unlock:
-	spin_unlock_irqrestore(&wakeup_lock, flags);
+	__raw_spin_unlock(&wakeup_lock);
+	local_irq_restore(flags);
 
  out:
 	atomic_dec(&data->disabled);
@@ -145,7 +148,8 @@ wakeup_sched_switch(void *private, void *rq, struct task_struct *prev,
 	if (likely(disabled != 1))
 		goto out;
 
-	spin_lock_irqsave(&wakeup_lock, flags);
+	local_irq_save(flags);
+	__raw_spin_lock(&wakeup_lock);
 
 	/* We could race with grabbing wakeup_lock */
 	if (unlikely(!tracer_enabled || next != wakeup_task))
@@ -174,7 +178,8 @@ wakeup_sched_switch(void *private, void *rq, struct task_struct *prev,
 
 out_unlock:
 	__wakeup_reset(tr);
-	spin_unlock_irqrestore(&wakeup_lock, flags);
+	__raw_spin_unlock(&wakeup_lock);
+	local_irq_restore(flags);
 out:
 	atomic_dec(&tr->data[cpu]->disabled);
 }
@@ -209,8 +214,6 @@ static void __wakeup_reset(struct trace_array *tr)
 	struct trace_array_cpu *data;
 	int cpu;
 
-	assert_spin_locked(&wakeup_lock);
-
 	for_each_possible_cpu(cpu) {
 		data = tr->data[cpu];
 		tracing_reset(data);
@@ -229,9 +232,11 @@ static void wakeup_reset(struct trace_array *tr)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&wakeup_lock, flags);
+	local_irq_save(flags);
+	__raw_spin_lock(&wakeup_lock);
 	__wakeup_reset(tr);
-	spin_unlock_irqrestore(&wakeup_lock, flags);
+	__raw_spin_unlock(&wakeup_lock);
+	local_irq_restore(flags);
 }
 
 static void
@@ -252,7 +257,7 @@ wakeup_check_start(struct trace_array *tr, struct task_struct *p,
 		goto out;
 
 	/* interrupts should be off from try_to_wake_up */
-	spin_lock(&wakeup_lock);
+	__raw_spin_lock(&wakeup_lock);
 
 	/* check for races. */
 	if (!tracer_enabled || p->prio >= wakeup_prio)
@@ -274,7 +279,7 @@ wakeup_check_start(struct trace_array *tr, struct task_struct *p,
 		       CALLER_ADDR1, CALLER_ADDR2, flags);
 
 out_locked:
-	spin_unlock(&wakeup_lock);
+	__raw_spin_unlock(&wakeup_lock);
 out:
 	atomic_dec(&tr->data[cpu]->disabled);
 }
