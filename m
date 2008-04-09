Return-Path: <linux-kernel-owner+w=401wt.eu-S1759003AbYDIQ0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759003AbYDIQ0Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 12:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758078AbYDIQXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 12:23:50 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:59281 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758069AbYDIQXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 12:23:49 -0400
Message-Id: <20080409152049.513274847@polymtl.ca>
References: <20080409150829.855195878@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 09 Apr 2008 11:08:38 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Adrian Bunk <bunk@stusta.de>, Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>, akpm@osdl.org
Subject: [patch 09/17] Add all cpus option to stop machine run
Content-Disposition: inline; filename=add-all-cpus-option-to-stop-machine-run.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Wed,  9 Apr 2008 16:20:09 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-allow stop_mahcine_run() to call a function on all cpus. Calling 
 stop_machine_run() with a 'ALL_CPUS' invokes this new behavior.
 stop_machine_run() proceeds as normal until the calling cpu has
 invoked 'fn'. Then, we tell all the other cpus to call 'fn'.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: Adrian Bunk <bunk@stusta.de>
CC: Andi Kleen <andi@firstfloor.org>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Christoph Hellwig <hch@infradead.org>
CC: mingo@elte.hu
CC: akpm@osdl.org
---

 include/linux/stop_machine.h |    8 +++++++-
 kernel/stop_machine.c        |   31 ++++++++++++++++++++++++-------
 2 files changed, 31 insertions(+), 8 deletions(-)


Index: linux-2.6-lttng/include/linux/stop_machine.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/stop_machine.h	2008-02-27 13:20:14.000000000 -0500
+++ linux-2.6-lttng/include/linux/stop_machine.h	2008-02-29 08:32:32.000000000 -0500
@@ -8,11 +8,17 @@
 #include <asm/system.h>
 
 #if defined(CONFIG_STOP_MACHINE) && defined(CONFIG_SMP)
+
+#define ALL_CPUS ~0U
+
 /**
  * stop_machine_run: freeze the machine on all CPUs and run this function
  * @fn: the function to run
  * @data: the data ptr for the @fn()
- * @cpu: the cpu to run @fn() on (or any, if @cpu == NR_CPUS.
+ * @cpu: if @cpu == n, run @fn() on cpu n
+ *       if @cpu == NR_CPUS, run @fn() on any cpu
+ *       if @cpu == ALL_CPUS, run @fn() first on the calling cpu, and then
+ *       concurrently on all the other cpus
  *
  * Description: This causes a thread to be scheduled on every other cpu,
  * each of which disables interrupts, and finally interrupts are disabled
Index: linux-2.6-lttng/kernel/stop_machine.c
===================================================================
--- linux-2.6-lttng.orig/kernel/stop_machine.c	2008-02-27 13:20:14.000000000 -0500
+++ linux-2.6-lttng/kernel/stop_machine.c	2008-02-29 08:34:25.000000000 -0500
@@ -23,9 +23,17 @@ enum stopmachine_state {
 	STOPMACHINE_WAIT,
 	STOPMACHINE_PREPARE,
 	STOPMACHINE_DISABLE_IRQ,
+	STOPMACHINE_RUN,
 	STOPMACHINE_EXIT,
 };
 
+struct stop_machine_data {
+	int (*fn)(void *);
+	void *data;
+	struct completion done;
+	int run_all;
+} smdata;
+
 static enum stopmachine_state stopmachine_state;
 static unsigned int stopmachine_num_threads;
 static atomic_t stopmachine_thread_ack;
@@ -34,6 +42,7 @@ static int stopmachine(void *cpu)
 {
 	int irqs_disabled = 0;
 	int prepared = 0;
+	int ran = 0;
 
 	set_cpus_allowed(current, cpumask_of_cpu((int)(long)cpu));
 
@@ -58,6 +67,11 @@ static int stopmachine(void *cpu)
 			prepared = 1;
 			smp_mb(); /* Must read state first. */
 			atomic_inc(&stopmachine_thread_ack);
+		} else if (stopmachine_state == STOPMACHINE_RUN && !ran) {
+			smdata.fn(smdata.data);
+			ran = 1;
+			smp_mb(); /* Must read state first. */
+			atomic_inc(&stopmachine_thread_ack);
 		}
 		/* Yield in first stage: migration threads need to
 		 * help our sisters onto their CPUs. */
@@ -135,12 +149,10 @@ static void restart_machine(void)
 	preempt_enable_no_resched();
 }
 
-struct stop_machine_data
+static void run_other_cpus(void)
 {
-	int (*fn)(void *);
-	void *data;
-	struct completion done;
-};
+	stopmachine_set_state(STOPMACHINE_RUN);
+}
 
 static int do_stop(void *_smdata)
 {
@@ -150,6 +162,8 @@ static int do_stop(void *_smdata)
 	ret = stop_machine();
 	if (ret == 0) {
 		ret = smdata->fn(smdata->data);
+		if (smdata->run_all)
+			run_other_cpus();
 		restart_machine();
 	}
 
@@ -173,14 +187,17 @@ struct task_struct *__stop_machine_run(i
 	struct stop_machine_data smdata;
 	struct task_struct *p;
 
+	mutex_lock(&stopmachine_mutex);
+
 	smdata.fn = fn;
 	smdata.data = data;
+	smdata.run_all = (cpu == ALL_CPUS) ? 1 : 0;
 	init_completion(&smdata.done);
 
-	mutex_lock(&stopmachine_mutex);
+	smp_wmb(); /* make sure other cpus see smdata updates */
 
 	/* If they don't care which CPU fn runs on, bind to any online one. */
-	if (cpu == NR_CPUS)
+	if (cpu == NR_CPUS || cpu == ALL_CPUS)
 		cpu = raw_smp_processor_id();
 
 	p = kthread_create(do_stop, &smdata, "kstopmachine");

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
