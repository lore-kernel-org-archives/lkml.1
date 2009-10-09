Return-Path: <linux-kernel-owner+w=401wt.eu-S1760318AbZJIIb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760318AbZJIIb5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 04:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760253AbZJIIb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 04:31:56 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:50593 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760297AbZJIIbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 04:31:50 -0400
Subject: [PATCH v4 2/4] pSeries: Add hooks to put the CPU into an appropriate
	offline state
To: Nathan Fontenot <nfont@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       linuxppc-dev@lists.ozlabs.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
From: Gautham R Shenoy <ego@in.ibm.com>
Cc: Joel Schopp <jschopp@austin.ibm.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>
Date: Fri, 09 Oct 2009 14:00:55 +0530
Message-ID: <20091009083055.32381.80225.stgit@sofia.in.ibm.com>
In-Reply-To: <20091009082952.32381.32794.stgit@sofia.in.ibm.com>
References: <20091009082952.32381.32794.stgit@sofia.in.ibm.com>
User-Agent: StGit/0.14.3.384.g9ab0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a CPU is offlined on POWER currently, we call rtas_stop_self() and hand
the CPU back to the resource pool. This path is used for DLPAR which will
cause a change in the LPAR configuration which will be visible outside.

This patch changes the default state a CPU is put into when it is offlined.
On platforms which support ceding the processor to the hypervisor with
latency hint specifier value, during a cpu offline operation,
instead of calling rtas_stop_self(), we cede the vCPU to the hypervisor
while passing a latency hint specifier value. The Hypervisor can use this hint
to provide better energy savings. Also, during the offline
operation, the control of the vCPU remains with the LPAR as oppposed to
returning it to the resource pool.

The patch achieves this by creating an infrastructure to set the
preferred_offline_state() which can be either
- CPU_STATE_OFFLINE: which is the current behaviour of calling
  rtas_stop_self()

- CPU_STATE_INACTIVE: which cedes the vCPU to the hypervisor with the latency
  hint specifier.

The codepath which wants to perform a DLPAR operation can set the
preferred_offline_state() of a CPU to CPU_STATE_OFFLINE before invoking
cpu_down().

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>
---
 arch/powerpc/platforms/pseries/hotplug-cpu.c    |  157 ++++++++++++++++++++++-
 arch/powerpc/platforms/pseries/offline_states.h |   18 +++
 arch/powerpc/platforms/pseries/smp.c            |   19 +++
 3 files changed, 185 insertions(+), 9 deletions(-)
 create mode 100644 arch/powerpc/platforms/pseries/offline_states.h

diff --git a/arch/powerpc/platforms/pseries/hotplug-cpu.c b/arch/powerpc/platforms/pseries/hotplug-cpu.c
index ebff6d9..8a47db4 100644
--- a/arch/powerpc/platforms/pseries/hotplug-cpu.c
+++ b/arch/powerpc/platforms/pseries/hotplug-cpu.c
@@ -30,6 +30,7 @@
 #include <asm/pSeries_reconfig.h>
 #include "xics.h"
 #include "plpar_wrappers.h"
+#include "offline_states.h"
 
 /* This version can't take the spinlock, because it never returns */
 static struct rtas_args rtas_stop_self_args = {
@@ -39,6 +40,37 @@ static struct rtas_args rtas_stop_self_args = {
 	.rets = &rtas_stop_self_args.args[0],
 };
 
+static DEFINE_PER_CPU(enum cpu_state_vals, preferred_offline_state) =
+							CPU_STATE_OFFLINE;
+static DEFINE_PER_CPU(enum cpu_state_vals, current_state) = CPU_STATE_OFFLINE;
+
+static enum cpu_state_vals default_offline_state = CPU_STATE_OFFLINE;
+
+enum cpu_state_vals get_cpu_current_state(int cpu)
+{
+	return per_cpu(current_state, cpu);
+}
+
+void set_cpu_current_state(int cpu, enum cpu_state_vals state)
+{
+	per_cpu(current_state, cpu) = state;
+}
+
+enum cpu_state_vals get_preferred_offline_state(int cpu)
+{
+	return per_cpu(preferred_offline_state, cpu);
+}
+
+void set_preferred_offline_state(int cpu, enum cpu_state_vals state)
+{
+	per_cpu(preferred_offline_state, cpu) = state;
+}
+
+void set_default_offline_state(int cpu)
+{
+	per_cpu(preferred_offline_state, cpu) = default_offline_state;
+}
+
 static void rtas_stop_self(void)
 {
 	struct rtas_args *args = &rtas_stop_self_args;
@@ -56,11 +88,66 @@ static void rtas_stop_self(void)
 
 static void pseries_mach_cpu_die(void)
 {
+	unsigned int cpu = smp_processor_id();
+	unsigned int hwcpu = hard_smp_processor_id();
+	u8 cede_latency_hint = 0;
+
 	local_irq_disable();
 	idle_task_exit();
 	xics_teardown_cpu();
-	unregister_slb_shadow(hard_smp_processor_id(), __pa(get_slb_shadow()));
-	rtas_stop_self();
+
+	if (get_preferred_offline_state(cpu) == CPU_STATE_INACTIVE) {
+		set_cpu_current_state(cpu, CPU_STATE_INACTIVE);
+		cede_latency_hint = 2;
+
+		get_lppaca()->idle = 1;
+		if (!get_lppaca()->shared_proc)
+			get_lppaca()->donate_dedicated_cpu = 1;
+
+		printk(KERN_INFO
+			"cpu %u (hwid %u) ceding for offline with hint %d\n",
+			cpu, hwcpu, cede_latency_hint);
+		while (get_preferred_offline_state(cpu) == CPU_STATE_INACTIVE) {
+			extended_cede_processor(cede_latency_hint);
+			printk(KERN_INFO "cpu %u (hwid %u) returned from cede.\n",
+				cpu, hwcpu);
+			printk(KERN_INFO
+			"Decrementer value = %x Timebase value = %llx\n",
+			get_dec(), get_tb());
+		}
+
+		printk(KERN_INFO "cpu %u (hwid %u) got prodded to go online\n",
+			cpu, hwcpu);
+
+		if (!get_lppaca()->shared_proc)
+			get_lppaca()->donate_dedicated_cpu = 0;
+		get_lppaca()->idle = 0;
+	}
+
+	if (get_preferred_offline_state(cpu) == CPU_STATE_ONLINE) {
+		unregister_slb_shadow(hwcpu, __pa(get_slb_shadow()));
+
+		/*
+		 * NOTE: Calling start_secondary() here for now to
+		 * start new context.
+		 * However, need to do it cleanly by resetting the
+		 * stack pointer.
+		 */
+		start_secondary();
+		goto out_bug;
+
+	}
+
+	if (get_preferred_offline_state(cpu) == CPU_STATE_OFFLINE) {
+
+		set_cpu_current_state(cpu, CPU_STATE_OFFLINE);
+		unregister_slb_shadow(hard_smp_processor_id(),
+					__pa(get_slb_shadow()));
+		rtas_stop_self();
+		goto out_bug;
+	}
+
+out_bug:
 	/* Should never get here... */
 	BUG();
 	for(;;);
@@ -109,15 +196,28 @@ static int pseries_cpu_disable(void)
 static void pseries_cpu_die(unsigned int cpu)
 {
 	int tries;
-	int cpu_status;
+	int cpu_status = 1;
 	unsigned int pcpu = get_hard_smp_processor_id(cpu);
 
-	for (tries = 0; tries < 25; tries++) {
-		cpu_status = query_cpu_stopped(pcpu);
-		if (cpu_status == 0 || cpu_status == -1)
-			break;
-		cpu_relax();
+	if (get_preferred_offline_state(cpu) == CPU_STATE_INACTIVE) {
+		cpu_status = 1;
+		for (tries = 0; tries < 1000; tries++) {
+			if (get_cpu_current_state(cpu) == CPU_STATE_INACTIVE) {
+				cpu_status = 0;
+				break;
+			}
+			cpu_relax();
+		}
+	} else if (get_preferred_offline_state(cpu) == CPU_STATE_OFFLINE) {
+
+		for (tries = 0; tries < 25; tries++) {
+			cpu_status = query_cpu_stopped(pcpu);
+			if (cpu_status == 0 || cpu_status == -1)
+				break;
+			cpu_relax();
+		}
 	}
+
 	if (cpu_status != 0) {
 		printk("Querying DEAD? cpu %i (%i) shows %i\n",
 		       cpu, pcpu, cpu_status);
@@ -252,10 +352,41 @@ static struct notifier_block pseries_smp_nb = {
 	.notifier_call = pseries_smp_notifier,
 };
 
+#define MAX_CEDE_LATENCY_LEVELS		4
+#define	CEDE_LATENCY_PARAM_LENGTH	10
+#define CEDE_LATENCY_PARAM_MAX_LENGTH	\
+	(MAX_CEDE_LATENCY_LEVELS * CEDE_LATENCY_PARAM_LENGTH * sizeof(char))
+#define CEDE_LATENCY_TOKEN		45
+
+static char cede_parameters[CEDE_LATENCY_PARAM_MAX_LENGTH];
+
+static int parse_cede_parameters(void)
+{
+	int call_status;
+
+	memset(cede_parameters, 0, CEDE_LATENCY_PARAM_MAX_LENGTH);
+	call_status = rtas_call(rtas_token("ibm,get-system-parameter"), 3, 1,
+				NULL,
+				CEDE_LATENCY_TOKEN,
+				__pa(cede_parameters),
+				CEDE_LATENCY_PARAM_MAX_LENGTH);
+
+	if (call_status != 0)
+		printk(KERN_INFO "CEDE_LATENCY: \
+			%s %s Error calling get-system-parameter(0x%x)\n",
+			__FILE__, __func__, call_status);
+	else
+		printk(KERN_INFO "CEDE_LATENCY: \
+			get-system-parameter successful.\n");
+
+	return call_status;
+}
+
 static int __init pseries_cpu_hotplug_init(void)
 {
 	struct device_node *np;
 	const char *typep;
+	int cpu;
 
 	for_each_node_by_name(np, "interrupt-controller") {
 		typep = of_get_property(np, "compatible", NULL);
@@ -283,8 +414,16 @@ static int __init pseries_cpu_hotplug_init(void)
 	smp_ops->cpu_die = pseries_cpu_die;
 
 	/* Processors can be added/removed only on LPAR */
-	if (firmware_has_feature(FW_FEATURE_LPAR))
+	if (firmware_has_feature(FW_FEATURE_LPAR)) {
 		pSeries_reconfig_notifier_register(&pseries_smp_nb);
+		cpu_maps_update_begin();
+		if (parse_cede_parameters() == 0) {
+			default_offline_state = CPU_STATE_INACTIVE;
+			for_each_online_cpu(cpu)
+				set_default_offline_state(cpu);
+		}
+		cpu_maps_update_done();
+	}
 
 	return 0;
 }
diff --git a/arch/powerpc/platforms/pseries/offline_states.h b/arch/powerpc/platforms/pseries/offline_states.h
new file mode 100644
index 0000000..22574e0
--- /dev/null
+++ b/arch/powerpc/platforms/pseries/offline_states.h
@@ -0,0 +1,18 @@
+#ifndef _OFFLINE_STATES_H_
+#define _OFFLINE_STATES_H_
+
+/* Cpu offline states go here */
+enum cpu_state_vals {
+	CPU_STATE_OFFLINE,
+	CPU_STATE_INACTIVE,
+	CPU_STATE_ONLINE,
+	CPU_MAX_OFFLINE_STATES
+};
+
+extern enum cpu_state_vals get_cpu_current_state(int cpu);
+extern void set_cpu_current_state(int cpu, enum cpu_state_vals state);
+extern enum cpu_state_vals get_preferred_offline_state(int cpu);
+extern void set_preferred_offline_state(int cpu, enum cpu_state_vals state);
+extern void set_default_offline_state(int cpu);
+extern int start_secondary(void);
+#endif
diff --git a/arch/powerpc/platforms/pseries/smp.c b/arch/powerpc/platforms/pseries/smp.c
index 440000c..8868c01 100644
--- a/arch/powerpc/platforms/pseries/smp.c
+++ b/arch/powerpc/platforms/pseries/smp.c
@@ -48,6 +48,7 @@
 #include "plpar_wrappers.h"
 #include "pseries.h"
 #include "xics.h"
+#include "offline_states.h"
 
 
 /*
@@ -84,6 +85,9 @@ static inline int __devinit smp_startup_cpu(unsigned int lcpu)
 	/* Fixup atomic count: it exited inside IRQ handler. */
 	task_thread_info(paca[lcpu].__current)->preempt_count	= 0;
 
+	if (get_cpu_current_state(lcpu) == CPU_STATE_INACTIVE)
+		goto out;
+
 	/* 
 	 * If the RTAS start-cpu token does not exist then presume the
 	 * cpu is already spinning.
@@ -98,6 +102,7 @@ static inline int __devinit smp_startup_cpu(unsigned int lcpu)
 		return 0;
 	}
 
+out:
 	return 1;
 }
 
@@ -111,12 +116,16 @@ static void __devinit smp_xics_setup_cpu(int cpu)
 		vpa_init(cpu);
 
 	cpu_clear(cpu, of_spin_map);
+	set_cpu_current_state(cpu, CPU_STATE_ONLINE);
+	set_default_offline_state(cpu);
 
 }
 #endif /* CONFIG_XICS */
 
 static void __devinit smp_pSeries_kick_cpu(int nr)
 {
+	long rc;
+	unsigned long hcpuid;
 	BUG_ON(nr < 0 || nr >= NR_CPUS);
 
 	if (!smp_startup_cpu(nr))
@@ -128,6 +137,16 @@ static void __devinit smp_pSeries_kick_cpu(int nr)
 	 * the processor will continue on to secondary_start
 	 */
 	paca[nr].cpu_start = 1;
+
+	set_preferred_offline_state(nr, CPU_STATE_ONLINE);
+
+	if (get_cpu_current_state(nr) == CPU_STATE_INACTIVE) {
+		hcpuid = get_hard_smp_processor_id(nr);
+		rc = plpar_hcall_norets(H_PROD, hcpuid);
+		if (rc != H_SUCCESS)
+			panic("Error: Prod to wake up processor %d Ret= %ld\n",
+				nr, rc);
+	}
 }
 
 static int smp_pSeries_cpu_bootable(unsigned int nr)

