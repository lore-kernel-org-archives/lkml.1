Return-Path: <linux-kernel-owner+w=401wt.eu-S1760248AbYB1QiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760248AbYB1QiX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 11:38:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754517AbYB1QiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 11:38:13 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48439 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753159AbYB1QiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 11:38:12 -0500
Date: Thu, 28 Feb 2008 11:33:03 -0500
From: Jason Baron <jbaron@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [patch 1/2] add ALL_CPUS option to stop_machine_run()
Message-ID: <20080228163303.GA6195@redhat.com>
References: <20080202210828.840735763@polymtl.ca> <20080202211204.268876860@polymtl.ca> <20080226225242.GA15926@redhat.com> <20080227190519.GA14335@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080227190519.GA14335@Krystal>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-allow stop_mahcine_run() to call a function on all cpus. Calling 
 stop_machine_run() with a 'ALL_CPUS' invokes this new behavior.
 stop_machine_run() proceeds as normal until the calling cpu has
 invoked 'fn'. Then, we tell all the other cpus to call 'fn'.

Signed-off-by: Jason Baron <jbaron@redhat.com>


---

 include/linux/stop_machine.h |    8 +++++++-
 kernel/stop_machine.c        |   33 +++++++++++++++++++++++----------
 2 files changed, 30 insertions(+), 11 deletions(-)


diff --git a/include/linux/stop_machine.h b/include/linux/stop_machine.h
index 5bfc553..18af011 100644
--- a/include/linux/stop_machine.h
+++ b/include/linux/stop_machine.h
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
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 51b5ee5..c75b4f4 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
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
@@ -35,6 +43,7 @@ static int stopmachine(void *cpu)
 {
 	int irqs_disabled = 0;
 	int prepared = 0;
+	int ran = 0;
 
 	set_cpus_allowed(current, cpumask_of_cpu((int)(long)cpu));
 
@@ -59,6 +68,11 @@ static int stopmachine(void *cpu)
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
@@ -136,12 +150,10 @@ static void restart_machine(void)
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
@@ -151,6 +163,8 @@ static int do_stop(void *_smdata)
 	ret = stop_machine();
 	if (ret == 0) {
 		ret = smdata->fn(smdata->data);
+		if (smdata->run_all)
+			run_other_cpus();
 		restart_machine();
 	}
 
@@ -170,17 +184,16 @@ static int do_stop(void *_smdata)
 struct task_struct *__stop_machine_run(int (*fn)(void *), void *data,
 				       unsigned int cpu)
 {
-	struct stop_machine_data smdata;
 	struct task_struct *p;
 
+	down(&stopmachine_mutex);
 	smdata.fn = fn;
 	smdata.data = data;
+	smdata.run_all = (cpu == ALL_CPUS) ? 1 : 0;
 	init_completion(&smdata.done);
-
-	down(&stopmachine_mutex);
-
+	smp_wmb(); /* make sure other cpus see smdata updates */
 	/* If they don't care which CPU fn runs on, bind to any online one. */
-	if (cpu == NR_CPUS)
+	if (cpu == NR_CPUS || cpu == ALL_CPUS)
 		cpu = raw_smp_processor_id();
 
 	p = kthread_create(do_stop, &smdata, "kstopmachine");

