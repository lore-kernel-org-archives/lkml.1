Return-Path: <linux-kernel-owner+w=401wt.eu-S1753480AbZIOMH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbZIOMH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 08:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753349AbZIOMHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 08:07:24 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:46853 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361AbZIOMHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 08:07:11 -0400
Subject: [PATCH v3 3/3] cpu: Implement cpu-offline-state callbacks for pSeries.
To: Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Balbir Singh <balbir@in.ibm.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
From: Gautham R Shenoy <ego@in.ibm.com>
Cc: Arun R Bharadwaj <arun@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org,
       linux-kernel@vger.kernel.org, "Darrick J. Wong" <djwong@us.ibm.com>
Date: Tue, 15 Sep 2009 17:37:11 +0530
Message-ID: <20090915120711.20523.16685.stgit@sofia.in.ibm.com>
In-Reply-To: <20090915120629.20523.79019.stgit@sofia.in.ibm.com>
References: <20090915120629.20523.79019.stgit@sofia.in.ibm.com>
User-Agent: StGit/0.14.3.384.g9ab0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements the callbacks to handle the reads/writes into the sysfs
interfaces

/sys/devices/system/cpu/cpu<number>/available_hotplug_states
and
/sys/devices/system/cpu/cpu<number>/current_hotplug_state

Currently, the patch defines two states which the processor can go to when it
is offlined. They are

- offline: The current behaviour when the cpu is offlined.
  The CPU would call make an rtas_stop_self() call and hand over the
  CPU back to the resource pool, thereby effectively deallocating
  that vCPU from the LPAR.

- inactive: This is expected to cede the processor to the hypervisor with a
  latency hint specifier value. Hypervisor may use this hint to provide
  better energy savings. In this state, the control of the vCPU will continue
  to be with the LPAR.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---
 arch/powerpc/platforms/pseries/Makefile         |    2 
 arch/powerpc/platforms/pseries/hotplug-cpu.c    |   88 +++++++++++++-
 arch/powerpc/platforms/pseries/offline_driver.c |  148 +++++++++++++++++++++++
 arch/powerpc/platforms/pseries/offline_driver.h |   20 +++
 arch/powerpc/platforms/pseries/smp.c            |   17 +++
 5 files changed, 267 insertions(+), 8 deletions(-)
 create mode 100644 arch/powerpc/platforms/pseries/offline_driver.c
 create mode 100644 arch/powerpc/platforms/pseries/offline_driver.h

diff --git a/arch/powerpc/platforms/pseries/Makefile b/arch/powerpc/platforms/pseries/Makefile
index 790c0b8..3a569c7 100644
--- a/arch/powerpc/platforms/pseries/Makefile
+++ b/arch/powerpc/platforms/pseries/Makefile
@@ -17,7 +17,7 @@ obj-$(CONFIG_KEXEC)	+= kexec.o
 obj-$(CONFIG_PCI)	+= pci.o pci_dlpar.o
 obj-$(CONFIG_PSERIES_MSI)	+= msi.o
 
-obj-$(CONFIG_HOTPLUG_CPU)	+= hotplug-cpu.o
+obj-$(CONFIG_HOTPLUG_CPU)	+= hotplug-cpu.o offline_driver.o
 obj-$(CONFIG_MEMORY_HOTPLUG)	+= hotplug-memory.o
 
 obj-$(CONFIG_HVC_CONSOLE)	+= hvconsole.o
diff --git a/arch/powerpc/platforms/pseries/hotplug-cpu.c b/arch/powerpc/platforms/pseries/hotplug-cpu.c
index a20ead8..1e06bb1 100644
--- a/arch/powerpc/platforms/pseries/hotplug-cpu.c
+++ b/arch/powerpc/platforms/pseries/hotplug-cpu.c
@@ -30,6 +30,7 @@
 #include <asm/pSeries_reconfig.h>
 #include "xics.h"
 #include "plpar_wrappers.h"
+#include "offline_driver.h"
 
 /* This version can't take the spinlock, because it never returns */
 static struct rtas_args rtas_stop_self_args = {
@@ -54,13 +55,74 @@ static void rtas_stop_self(void)
 	panic("Alas, I survived.\n");
 }
 
+static void cede_on_offline(u8 cede_latency_hint)
+{
+	unsigned int cpu = smp_processor_id();
+	unsigned int hwcpu = hard_smp_processor_id();
+	u8 old_cede_latency_hint;
+
+	old_cede_latency_hint = get_cede_latency_hint();
+	get_lppaca()->idle = 1;
+	if (!get_lppaca()->shared_proc)
+		get_lppaca()->donate_dedicated_cpu = 1;
+
+	printk(KERN_INFO "cpu %u (hwid %u) ceding for offline with hint %d\n",
+			cpu, hwcpu, cede_latency_hint);
+	while (get_preferred_offline_state(cpu) != CPU_STATE_ONLINE) {
+		extended_cede_processor(cede_latency_hint);
+		printk(KERN_INFO "cpu %u (hwid %u) returned from cede.\n",
+			cpu, hwcpu);
+		printk(KERN_INFO
+			"Decrementer value = %x Timebase value = %llx\n",
+			get_dec(), get_tb());
+	}
+
+	printk(KERN_INFO "cpu %u (hwid %u) got prodded to go online\n",
+		cpu, hwcpu);
+
+	if (!get_lppaca()->shared_proc)
+		get_lppaca()->donate_dedicated_cpu = 0;
+	get_lppaca()->idle = 0;
+
+	/* Reset the cede_latency specifier value */
+	set_cede_latency_hint(old_cede_latency_hint);
+
+	unregister_slb_shadow(hwcpu, __pa(get_slb_shadow()));
+
+	/*
+	 * NOTE: Calling start_secondary() here for now to start
+	 * a new context.
+	 *
+	 * However, need to do it cleanly by resetting the stack
+	 * pointer.
+	 */
+	start_secondary();
+}
+
 static void pseries_mach_cpu_die(void)
 {
+	unsigned int cpu = smp_processor_id();
+	u8 cede_latency_hint = 0;
+
 	local_irq_disable();
 	idle_task_exit();
 	xics_teardown_cpu();
-	unregister_slb_shadow(hard_smp_processor_id(), __pa(get_slb_shadow()));
-	rtas_stop_self();
+
+	if (get_preferred_offline_state(cpu) == CPU_STATE_OFFLINE) {
+
+		set_cpu_current_state(cpu, CPU_STATE_OFFLINE);
+		unregister_slb_shadow(hard_smp_processor_id(),
+					__pa(get_slb_shadow()));
+		rtas_stop_self();
+		goto out_bug;
+	} else if (get_preferred_offline_state(cpu) == CPU_STATE_INACTIVE) {
+		set_cpu_current_state(cpu, CPU_STATE_INACTIVE);
+		cede_latency_hint = 2;
+		cede_on_offline(cede_latency_hint);
+
+	}
+
+out_bug:
 	/* Should never get here... */
 	BUG();
 	for(;;);
@@ -112,11 +174,23 @@ static void pseries_cpu_die(unsigned int cpu)
 	int cpu_status;
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
+	} else {
+
+		for (tries = 0; tries < 25; tries++) {
+			cpu_status = query_cpu_stopped(pcpu);
+			if (cpu_status == 0 || cpu_status == -1)
+				break;
+			cpu_relax();
+		}
 	}
 	if (cpu_status != 0) {
 		printk("Querying DEAD? cpu %i (%i) shows %i\n",
diff --git a/arch/powerpc/platforms/pseries/offline_driver.c b/arch/powerpc/platforms/pseries/offline_driver.c
new file mode 100644
index 0000000..ca15b6b
--- /dev/null
+++ b/arch/powerpc/platforms/pseries/offline_driver.c
@@ -0,0 +1,148 @@
+#include "offline_driver.h"
+#include <linux/cpu.h>
+#include <linux/percpu-defs.h>
+
+struct cpu_hotplug_state {
+	enum cpu_state_vals state_val;
+	const char *state_name;
+	int available;
+} pSeries_cpu_hotplug_states[] = {
+	{CPU_STATE_OFFLINE, "offline", 1},
+	{CPU_STATE_INACTIVE, "inactive", 1},
+	{CPU_STATE_ONLINE, "online", 1},
+	{CPU_MAX_HOTPLUG_STATES, "", 0},
+};
+
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
+static const char *get_cpu_hotplug_state_name(enum cpu_state_vals state_val)
+{
+	return pSeries_cpu_hotplug_states[state_val].state_name;
+}
+
+static bool cpu_hotplug_state_available(enum cpu_state_vals state_val)
+{
+	return pSeries_cpu_hotplug_states[state_val].available;
+}
+
+ssize_t pSeries_read_available_states(unsigned int cpu, char *buf)
+{
+	int state;
+	ssize_t ret = 0;
+
+	for (state = CPU_STATE_OFFLINE; state < CPU_MAX_HOTPLUG_STATES;
+								state++) {
+		if (!cpu_hotplug_state_available(state))
+			continue;
+
+		if (ret >= (ssize_t) ((PAGE_SIZE / sizeof(char))
+					- (CPU_STATES_LEN + 2)))
+			goto out;
+		ret += scnprintf(&buf[ret], CPU_STATES_LEN, "%s ",
+				get_cpu_hotplug_state_name(state));
+	}
+
+out:
+	ret += sprintf(&buf[ret], "\n");
+	return ret;
+}
+
+ssize_t pSeries_read_current_state(unsigned int cpu, char *buf)
+{
+	int state = get_cpu_current_state(cpu);
+
+	return scnprintf(buf, CPU_STATES_LEN, "%s\n",
+				get_cpu_hotplug_state_name(state));
+}
+
+ssize_t pSeries_write_current_state(unsigned int cpu, const char *buf)
+{
+	int ret;
+	char state_name[CPU_STATES_LEN];
+	int i;
+	struct sys_device *dev = get_cpu_sysdev(cpu);
+	ret = sscanf(buf, "%15s", state_name);
+
+	if (ret != 1) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	for (i = CPU_STATE_OFFLINE; i < CPU_MAX_HOTPLUG_STATES; i++)
+		if (!strnicmp(state_name,
+				get_cpu_hotplug_state_name(i),
+				CPU_STATES_LEN))
+			break;
+
+	if (i == CPU_MAX_HOTPLUG_STATES) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	if (i == get_cpu_current_state(cpu)) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	if (i == CPU_STATE_ONLINE) {
+		ret = cpu_up(cpu);
+		if (!ret)
+			kobject_uevent(&dev->kobj, KOBJ_ONLINE);
+		goto out_unlock;
+	}
+
+	if (get_cpu_current_state(cpu) != CPU_STATE_ONLINE) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	set_preferred_offline_state(cpu, i);
+	ret = cpu_down(cpu);
+	if (!ret)
+		kobject_uevent(&dev->kobj, KOBJ_OFFLINE);
+
+out_unlock:
+	return ret;
+}
+
+struct cpu_offline_driver pSeries_offline_driver = {
+	.read_available_states = pSeries_read_available_states,
+	.read_current_state = pSeries_read_current_state,
+	.write_current_state = pSeries_write_current_state,
+};
+
+static int pseries_hotplug_driver_init(void)
+{
+	return register_cpu_offline_driver(&pSeries_offline_driver);
+}
+
+arch_initcall(pseries_hotplug_driver_init);
diff --git a/arch/powerpc/platforms/pseries/offline_driver.h b/arch/powerpc/platforms/pseries/offline_driver.h
new file mode 100644
index 0000000..b4674df
--- /dev/null
+++ b/arch/powerpc/platforms/pseries/offline_driver.h
@@ -0,0 +1,20 @@
+#ifndef _OFFLINE_DRIVER_H_
+#define _OFFLINE_DRIVER_H_
+
+#define CPU_STATES_LEN	16
+
+/* Cpu offline states go here */
+enum cpu_state_vals {
+	CPU_STATE_OFFLINE,
+	CPU_STATE_INACTIVE,
+	CPU_STATE_ONLINE,
+	CPU_MAX_HOTPLUG_STATES
+};
+
+extern enum cpu_state_vals get_cpu_current_state(int cpu);
+extern void set_cpu_current_state(int cpu, enum cpu_state_vals state);
+extern enum cpu_state_vals get_preferred_offline_state(int cpu);
+extern void set_preferred_offline_state(int cpu, enum cpu_state_vals state);
+extern int start_secondary(void);
+extern void set_default_offline_state(int cpu);
+#endif
diff --git a/arch/powerpc/platforms/pseries/smp.c b/arch/powerpc/platforms/pseries/smp.c
index 1f8f6cf..48f8ae5 100644
--- a/arch/powerpc/platforms/pseries/smp.c
+++ b/arch/powerpc/platforms/pseries/smp.c
@@ -48,6 +48,7 @@
 #include "plpar_wrappers.h"
 #include "pseries.h"
 #include "xics.h"
+#include "offline_driver.h"
 
 
 /*
@@ -86,6 +87,9 @@ static inline int __devinit smp_startup_cpu(unsigned int lcpu)
 	/* Fixup atomic count: it exited inside IRQ handler. */
 	task_thread_info(paca[lcpu].__current)->preempt_count	= 0;
 
+	if (get_cpu_current_state(lcpu) != CPU_STATE_OFFLINE)
+		goto out;
+
 	/* 
 	 * If the RTAS start-cpu token does not exist then presume the
 	 * cpu is already spinning.
@@ -100,6 +104,7 @@ static inline int __devinit smp_startup_cpu(unsigned int lcpu)
 		return 0;
 	}
 
+out:
 	return 1;
 }
 
@@ -113,12 +118,15 @@ static void __devinit smp_xics_setup_cpu(int cpu)
 		vpa_init(cpu);
 
 	cpu_clear(cpu, of_spin_map);
+	set_cpu_current_state(cpu, CPU_STATE_ONLINE);
+	set_default_offline_state(cpu);
 
 }
 #endif /* CONFIG_XICS */
 
 static void __devinit smp_pSeries_kick_cpu(int nr)
 {
+	long rc;
 	BUG_ON(nr < 0 || nr >= NR_CPUS);
 
 	if (!smp_startup_cpu(nr))
@@ -130,6 +138,15 @@ static void __devinit smp_pSeries_kick_cpu(int nr)
 	 * the processor will continue on to secondary_start
 	 */
 	paca[nr].cpu_start = 1;
+
+	set_preferred_offline_state(nr, CPU_STATE_ONLINE);
+
+	if (get_cpu_current_state(nr) != CPU_STATE_OFFLINE) {
+		rc = plpar_hcall_norets(H_PROD, nr);
+		if (rc != H_SUCCESS)
+			panic("Error: Prod to wake up processor %d Ret= %ld\n",
+				nr, rc);
+	}
 }
 
 static int smp_pSeries_cpu_bootable(unsigned int nr)

