Return-Path: <linux-kernel-owner+w=401wt.eu-S1755592AbYGHH42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592AbYGHH42 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 03:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbYGHH4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 03:56:23 -0400
Received: from ozlabs.org ([203.10.76.45]:48419 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbYGHH4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 03:56:22 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] stop_machine: add ALL_CPUS option
Date: Tue, 8 Jul 2008 17:56:02 +1000
User-Agent: KMail/1.9.9
Cc: Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
References: <200807081750.55536.rusty@rustcorp.com.au>
In-Reply-To: <200807081750.55536.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807081756.02838.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

-allow stop_mahcine_run() to call a function on all cpus. Calling
 stop_machine_run() with a 'ALL_CPUS' invokes this new behavior.
 stop_machine_run() proceeds as normal until the calling cpu has
 invoked 'fn'. Then, we tell all the other cpus to call 'fn'.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
CC: Adrian Bunk <bunk@stusta.de>
CC: Andi Kleen <andi@firstfloor.org>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Christoph Hellwig <hch@infradead.org>
CC: mingo@elte.hu
CC: akpm@osdl.org
---
 include/linux/stop_machine.h |    8 +++++++-
 kernel/stop_machine.c        |   32 +++++++++++++++++++++++++-------
 2 files changed, 32 insertions(+), 8 deletions(-)

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
index 0101aee..bab5d2a 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -22,9 +22,17 @@ enum stopmachine_state {
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
@@ -33,6 +41,7 @@ static int stopmachine(void *cpu)
 {
 	int irqs_disabled = 0;
 	int prepared = 0;
+	int ran = 0;
 
 	set_cpus_allowed_ptr(current, &cpumask_of_cpu((int)(long)cpu));
 
@@ -57,6 +66,11 @@ static int stopmachine(void *cpu)
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
@@ -134,11 +148,10 @@ static void restart_machine(void)
 	preempt_enable_no_resched();
 }
 
-struct stop_machine_data {
-	int (*fn)(void *);
-	void *data;
-	struct completion done;
-};
+static void run_other_cpus(void)
+{
+	stopmachine_set_state(STOPMACHINE_RUN);
+}
 
 static int do_stop(void *_smdata)
 {
@@ -148,6 +161,8 @@ static int do_stop(void *_smdata)
 	ret = stop_machine();
 	if (ret == 0) {
 		ret = smdata->fn(smdata->data);
+		if (smdata->run_all)
+			run_other_cpus();
 		restart_machine();
 	}
 
@@ -171,14 +186,17 @@ struct task_struct *__stop_machine_run(int (*fn)(void *), void *data,
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
