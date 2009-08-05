Return-Path: <linux-kernel-owner+w=401wt.eu-S934555AbZHEO0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934555AbZHEO0Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 10:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934160AbZHEO0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 10:26:15 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:33178 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934535AbZHEO0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 10:26:11 -0400
Subject: [PATCH 3/3] pSeries: cpu: Cede CPU during a deactivate-offline
To: Joel Schopp <jschopp@austin.ibm.com>, len.brown@intel.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Balbir Singh <balbir@in.ibm.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, shaohua.li@intel.com,
       Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "Darrick J. Wong" <djwong@us.ibm.com>
From: Gautham R Shenoy <ego@in.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Wed, 05 Aug 2009 19:56:08 +0530
Message-ID: <20090805142608.553.70914.stgit@sofia.in.ibm.com>
In-Reply-To: <20090805142311.553.78286.stgit@sofia.in.ibm.com>
References: <20090805142311.553.78286.stgit@sofia.in.ibm.com>
User-Agent: StGit/0.14.3.384.g9ab0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implements the pSeries specific code bits to put the CPU into
rtas_stop_self() state or H_CEDE state depending on the
preferred_offline_state value for that CPU.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---
 arch/powerpc/platforms/pseries/hotplug-cpu.c    |   70 +++++++++++++++++++++--
 arch/powerpc/platforms/pseries/offline_driver.h |    3 +
 arch/powerpc/platforms/pseries/plpar_wrappers.h |    6 ++
 arch/powerpc/platforms/pseries/smp.c            |   18 ++++++
 4 files changed, 88 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/hotplug-cpu.c b/arch/powerpc/platforms/pseries/hotplug-cpu.c
index f15de99..5b47d6c 100644
--- a/arch/powerpc/platforms/pseries/hotplug-cpu.c
+++ b/arch/powerpc/platforms/pseries/hotplug-cpu.c
@@ -41,6 +41,8 @@ struct cpu_offline_state {
 };
 
 DEFINE_PER_CPU(enum cpu_state_vals, preferred_offline_state) = CPU_DEALLOCATE;
+DEFINE_PER_CPU(enum cpu_state_vals, cpu_current_state);
+DEFINE_PER_CPU(int, cpu_offline_ack);
 
 ssize_t pSeries_show_available_states(struct sys_device *dev,
 			struct sysdev_attribute *attr, char *buf)
@@ -148,8 +150,47 @@ static void pseries_mach_cpu_die(void)
 	local_irq_disable();
 	idle_task_exit();
 	xics_teardown_cpu();
-	unregister_slb_shadow(hard_smp_processor_id(), __pa(get_slb_shadow()));
-	rtas_stop_self();
+	if (__get_cpu_var(preferred_offline_state) == CPU_DEACTIVATE) {
+
+		__get_cpu_var(cpu_offline_ack) = 1;
+		get_lppaca()->idle = 1;
+		if (!get_lppaca()->shared_proc)
+			get_lppaca()->donate_dedicated_cpu = 1;
+
+		printk(KERN_INFO "cpu %u (hwid %u) ceding\n",
+			smp_processor_id(), hard_smp_processor_id());
+
+		while (__get_cpu_var(cpu_current_state)	== CPU_DEACTIVATE) {
+			cede_processor();
+			printk(KERN_INFO "cpu %u (hwid %u) Returned from cede.\
+				Decrementer value: %x. Timebase value:%llx \n",
+			       smp_processor_id(), hard_smp_processor_id(),
+			       get_dec(), get_tb());
+		}
+
+		printk(KERN_INFO "cpu %u (hwid %u) Received online PROD \n",
+		       smp_processor_id(), hard_smp_processor_id());
+
+		if (!get_lppaca()->shared_proc)
+			get_lppaca()->donate_dedicated_cpu = 0;
+		get_lppaca()->idle = 0;
+
+		unregister_slb_shadow(hard_smp_processor_id(),
+						__pa(get_slb_shadow()));
+
+		/**
+		 * NOTE: Calling start_secondary() here, is not a very nice
+		 * way of beginning a new context.
+		 *
+		 * We need to reset the stack-pointer.
+		 * Find a cleaner way to do this.
+		 */
+		start_secondary(NULL);
+	} else {
+		unregister_slb_shadow(hard_smp_processor_id(),
+						__pa(get_slb_shadow()));
+		rtas_stop_self();
+	}
 	/* Should never get here... */
 	BUG();
 	for(;;);
@@ -192,6 +233,10 @@ static int pseries_cpu_disable(void)
 
 	/* FIXME: abstract this to not be platform specific later on */
 	xics_migrate_irqs_away();
+	__get_cpu_var(cpu_current_state) =
+		__get_cpu_var(preferred_offline_state);
+
+	__get_cpu_var(cpu_offline_ack) = 0;
 	return 0;
 }
 
@@ -201,11 +246,22 @@ static void pseries_cpu_die(unsigned int cpu)
 	int cpu_status;
 	unsigned int pcpu = get_hard_smp_processor_id(cpu);
 
-	for (tries = 0; tries < 25; tries++) {
-		cpu_status = query_cpu_stopped(pcpu);
-		if (cpu_status == 0 || cpu_status == -1)
-			break;
-		cpu_relax();
+	if (per_cpu(preferred_offline_state, cpu) == CPU_DEACTIVATE) {
+		/* Wait for some Ack */
+		for (tries = 0; tries < 10000; tries++) {
+			cpu_status = !per_cpu(cpu_offline_ack, cpu);
+			if (!cpu_status)
+				break;
+			cpu_relax();
+		}
+
+	} else {
+		for (tries = 0; tries < 25; tries++) {
+			cpu_status = query_cpu_stopped(pcpu);
+			if (cpu_status == 0 || cpu_status == -1)
+				break;
+			cpu_relax();
+		}
 	}
 	if (cpu_status != 0) {
 		printk("Querying DEAD? cpu %i (%i) shows %i\n",
diff --git a/arch/powerpc/platforms/pseries/offline_driver.h b/arch/powerpc/platforms/pseries/offline_driver.h
index bdae76a..571e085 100644
--- a/arch/powerpc/platforms/pseries/offline_driver.h
+++ b/arch/powerpc/platforms/pseries/offline_driver.h
@@ -12,5 +12,6 @@ enum cpu_state_vals {
 };
 
 DECLARE_PER_CPU(enum cpu_state_vals, preferred_offline_state);
-
+DECLARE_PER_CPU(enum cpu_state_vals, cpu_current_state);
+extern int start_secondary(void *unused);
 #endif
diff --git a/arch/powerpc/platforms/pseries/plpar_wrappers.h b/arch/powerpc/platforms/pseries/plpar_wrappers.h
index a24a6b2..ab7f5ab 100644
--- a/arch/powerpc/platforms/pseries/plpar_wrappers.h
+++ b/arch/powerpc/platforms/pseries/plpar_wrappers.h
@@ -14,6 +14,12 @@ static inline long cede_processor(void)
 	return plpar_hcall_norets(H_CEDE);
 }
 
+static inline long prod_processor(unsigned long cpu)
+{
+	unsigned long hcpuid = get_hard_smp_processor_id(cpu);
+	return plpar_hcall_norets(H_PROD, hcpuid);
+}
+
 static inline long vpa_call(unsigned long flags, unsigned long cpu,
 		unsigned long vpa)
 {
diff --git a/arch/powerpc/platforms/pseries/smp.c b/arch/powerpc/platforms/pseries/smp.c
index 1f8f6cf..15d96a2 100644
--- a/arch/powerpc/platforms/pseries/smp.c
+++ b/arch/powerpc/platforms/pseries/smp.c
@@ -48,6 +48,7 @@
 #include "plpar_wrappers.h"
 #include "pseries.h"
 #include "xics.h"
+#include "offline_driver.h"
 
 
 /*
@@ -86,7 +87,10 @@ static inline int __devinit smp_startup_cpu(unsigned int lcpu)
 	/* Fixup atomic count: it exited inside IRQ handler. */
 	task_thread_info(paca[lcpu].__current)->preempt_count	= 0;
 
-	/* 
+	if (per_cpu(preferred_offline_state, lcpu) == CPU_DEACTIVATE)
+		goto out;
+
+	/*
 	 * If the RTAS start-cpu token does not exist then presume the
 	 * cpu is already spinning.
 	 */
@@ -100,6 +104,7 @@ static inline int __devinit smp_startup_cpu(unsigned int lcpu)
 		return 0;
 	}
 
+out:
 	return 1;
 }
 
@@ -119,6 +124,7 @@ static void __devinit smp_xics_setup_cpu(int cpu)
 
 static void __devinit smp_pSeries_kick_cpu(int nr)
 {
+	long rc;
 	BUG_ON(nr < 0 || nr >= NR_CPUS);
 
 	if (!smp_startup_cpu(nr))
@@ -130,6 +136,16 @@ static void __devinit smp_pSeries_kick_cpu(int nr)
 	 * the processor will continue on to secondary_start
 	 */
 	paca[nr].cpu_start = 1;
+
+	per_cpu(cpu_current_state, nr) = CPU_STATE_ONLINE;
+	if (per_cpu(preferred_offline_state, nr) == CPU_DEACTIVATE) {
+
+		printk(KERN_INFO "Prodding processor %d to go online\n", nr);
+		rc = prod_processor(nr);
+		if (rc != H_SUCCESS)
+			panic("Prod to wake up processor %d returned \
+				with error code: %ld. Dying\n", nr, rc);
+	}
 }
 
 static int smp_pSeries_cpu_bootable(unsigned int nr)

