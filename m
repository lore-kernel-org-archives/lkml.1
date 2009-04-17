Return-Path: <linux-kernel-owner+w=401wt.eu-S1751897AbZDQT0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897AbZDQT0e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 15:26:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751126AbZDQT0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 15:26:25 -0400
Received: from mxout10.netvision.net.il ([194.90.6.38]:15952 "EHLO
	mxout10.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbZDQT0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 15:26:24 -0400
X-Greylist: delayed 900 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Apr 2009 15:26:24 EDT
Date: Sat, 18 Apr 2009 01:11:19 +0300
From: raz ben yehuda <raziebe@013.net>
Subject: Subject: PATCH : offline scheduler
To: linux-acpi <linux-acpi@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Message-id: <1240006279.7801.0.camel@raz>
MIME-version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3)
Content-type: text/plain
Content-transfer-encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len Hello 
offsched is a platform aimed to assign a service to an off-lined processor.
Motivation is explained in: 
http://sos-linux.svn.sourceforge.net/viewvc/sos-linux/offsched/trunk/Documentation/OFFSCHED.pdf
Currently I have implemented two services:

HYBRID REAL TIME LINUX 
Implemented as a A 1us timer. This timer shows how a true real time system may co-exist with a 
regular linux server. This way there is no enforcement of a real time system requirements on the
entire kernel. Full documentation is at:
http://sos-linux.svn.sourceforge.net/viewvc/sos-linux/offsched/trunk/Documentation/OFFSCHED-RT.pdf

RTOP
This piece of software send system statistics to a remove server.
The user benefit is that even if the machine is un-accessible (remotely or locally) 
RTOP still sends system statistics to a remote server. I have showed in a small paper what RTOP is:
http://sos-linux.svn.sourceforge.net/viewvc/sos-linux/offsched/trunk/Documentation/OFFSCHED-RTOP.pdf

The patch is mostly a facility for offsched. The exporting of tasklist_lock is because RTOP is implemented as a driver
and it must lock the tasks list.
This is the 4-th post. I will be grateful for your reply.

Signed-off-by: Raz Ben Yehuda <raziebe@013.net.il>

arch/x86/kernel/process.c |   42 ++++++++++++++++++++++++++++++++++++++++++
arch/x86/kernel/smpboot.c |   11 +++++++----
include/linux/cpu.h       |   20 ++++++++++++++++++++
include/linux/sched.h     |    2 +-
kernel/cpu.c              |    1 +
kernel/fork.c             |    6 ++++++
6 files changed, 77 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index ca98915..123b32d 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -613,3 +613,45 @@ static int __init idle_setup(char *str)
 }
 early_param("idle", idle_setup);
 
+#ifdef CONFIG_HOTPLUG_CPU
+struct hotplug_cpu{
+	long flags;
+	void (*hotplug_cpu_dead)(void);
+};
+
+#define CPU_OFFSCHED 31
+
+DEFINE_PER_CPU(struct hotplug_cpu, offschedcpu);
+
+void unregister_offsched(int cpuid)
+{
+	struct hotplug_cpu *cpu = &per_cpu(offschedcpu, cpuid);
+	cpu->hotplug_cpu_dead = NULL;
+	clear_bit(CPU_OFFSCHED, &cpu->flags);
+}
+EXPORT_SYMBOL_GPL(unregister_offsched);
+
+int is_offsched(int cpuid)
+{
+	struct hotplug_cpu *cpu = &per_cpu(offschedcpu, cpuid);
+	return test_bit(CPU_OFFSCHED, &cpu->flags);
+}
+
+int register_offsched(void (*offsched_callback)(void), int cpuid)
+{
+	struct hotplug_cpu *cpu = &per_cpu(offschedcpu, cpuid);
+	if (is_offsched(cpuid))
+		return -1;
+	cpu->hotplug_cpu_dead = offsched_callback;
+	set_bit(CPU_OFFSCHED, &cpu->flags);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(register_offsched);
+
+void run_offsched(void)
+{
+	int cpuid = raw_smp_processor_id();
+	struct hotplug_cpu *cpu = &per_cpu(offschedcpu, cpuid);
+	cpu->hotplug_cpu_dead();
+}
+#endif
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 58d24ef..25e70e0 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -686,8 +686,8 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu)
 	};
 
 	INIT_WORK(&c_idle.work, do_fork_idle);
-
-	alternatives_smp_switch(1);
+	if (!is_offsched(cpu))
+		alternatives_smp_switch(1);
 
 	c_idle.idle = get_idle_for_cpu(cpu);
 
@@ -1283,8 +1283,9 @@ void native_cpu_die(unsigned int cpu)
 	for (i = 0; i < 10; i++) {
 		/* They ack this in play_dead by setting CPU_DEAD */
 		if (per_cpu(cpu_state, cpu) == CPU_DEAD) {
-			printk(KERN_INFO "CPU %d is now offline\n", cpu);
-			if (1 == num_online_cpus())
+			printk(KERN_INFO "CPU %d is now offline %s\n", cpu,
+				is_offsched(cpu) ? "and OFFSCHED" : "");
+			if (1 == num_online_cpus() && !is_offsched(cpu))
 				alternatives_smp_switch(0);
 			return;
 		}
@@ -1313,6 +1314,8 @@ void play_dead_common(void)
 void native_play_dead(void)
 {
 	play_dead_common();
+	if (is_offsched(raw_smp_processor_id()))
+		run_offsched();
 	wbinvd_halt();
 }
 
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 2643d84..f2048ca 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -43,6 +43,7 @@ extern int sched_create_sysfs_power_savings_entries(struct sysdev_class *cls);
 
 #ifdef CONFIG_HOTPLUG_CPU
 extern void unregister_cpu(struct cpu *cpu);
+extern void unregister_offsched(int cpuid);
 #endif
 struct notifier_block;
 
@@ -51,6 +52,9 @@ struct notifier_block;
 #ifdef CONFIG_HOTPLUG_CPU
 extern int register_cpu_notifier(struct notifier_block *nb);
 extern void unregister_cpu_notifier(struct notifier_block *nb);
+extern int register_offsched(void (*hotplug_cpu_dead)(void), int cpuid);
+extern int is_offsched(int cpuid);
+extern void run_offsched(void);
 #else
 
 #ifndef MODULE
@@ -60,11 +64,27 @@ static inline int register_cpu_notifier(struct notifier_block *nb)
 {
 	return 0;
 }
+
+static inline int register_offsched(void (*hotplug_cpu_dead)(void), int cpuid);
+{
+	return 0;
+}
 #endif
 
 static inline void unregister_cpu_notifier(struct notifier_block *nb)
 {
 }
+
+static inline void unregister_offsched(int cpuid)
+{
+}
+static inline int is_offsched(int cpuid)
+{
+	return 0;
+}
+static inline void run_offsched(void)
+{
+}
 #endif
 
 int cpu_up(unsigned int cpu);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index b4c38bc..8039ee7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1999,7 +1999,7 @@ struct task_struct *fork_idle(int);
 
 extern void set_task_comm(struct task_struct *tsk, char *from);
 extern char *get_task_comm(char *to, struct task_struct *tsk);
-
+extern rwlock_t *get_tasklist_lock(void);
 #ifdef CONFIG_SMP
 extern unsigned long wait_task_inactive(struct task_struct *, long match_state);
 #else
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 395b697..e67190d 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -373,6 +373,7 @@ out:
 	cpu_maps_update_done();
 	return err;
 }
+EXPORT_SYMBOL(cpu_up);
 
 #ifdef CONFIG_PM_SLEEP_SMP
 static cpumask_var_t frozen_cpus;
diff --git a/kernel/fork.c b/kernel/fork.c
index b9e2edd..4de4142 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -85,6 +85,12 @@ __cacheline_aligned DEFINE_RWLOCK(tasklist_lock);  /* outer */
 
 DEFINE_TRACE(sched_process_fork);
 
+rwlock_t	*get_tasklist_lock(void)
+{
+	return &tasklist_lock;
+}
+EXPORT_SYMBOL_GPL(get_tasklist_lock);
+
 int nr_processes(void)
 {
 	int cpu;



