Return-Path: <linux-kernel-owner+w=401wt.eu-S1762881AbZLLAQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762881AbZLLAQR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 19:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762841AbZLLAQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 19:16:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:53825 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762747AbZLLAQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 19:16:12 -0500
Date: Sat, 12 Dec 2009 00:15:53 GMT
From: tip-bot for Mike Travis <travis@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       travis@sgi.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       travis@sgi.com, tglx@linutronix.de
In-Reply-To: <4B219E28.8080601@sgi.com>
References: <4B219E28.8080601@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Limit the number of processor bootup messages
Message-ID: <tip-2eaad1fddd7450a48ad464229775f97fbfe8af36@git.kernel.org>
Git-Commit-ID: 2eaad1fddd7450a48ad464229775f97fbfe8af36
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2eaad1fddd7450a48ad464229775f97fbfe8af36
Gitweb:     http://git.kernel.org/tip/2eaad1fddd7450a48ad464229775f97fbfe8af36
Author:     Mike Travis <travis@sgi.com>
AuthorDate: Thu, 10 Dec 2009 17:19:36 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 11 Dec 2009 15:16:00 -0800

x86: Limit the number of processor bootup messages

When there are a large number of processors in a system, there
is an excessive amount of messages sent to the system console.
It's estimated that with 4096 processors in a system, and the
console baudrate set to 56K, the startup messages will take
about 84 minutes to clear the serial port.

This set of patches limits the number of repetitious messages
which contain no additional information.  Much of this information
is obtainable from the /proc and /sysfs.   Some of the messages
are also sent to the kernel log buffer as KERN_DEBUG messages so
dmesg can be used to examine more closely any details specific to
a problem.

The new cpu bootup sequence for system_state == SYSTEM_BOOTING:

Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 Ok.
Booting Node   1, Processors  #8 #9 #10 #11 #12 #13 #14 #15 Ok.
...
Booting Node   3, Processors  #56 #57 #58 #59 #60 #61 #62 #63 Ok.
Brought up 64 CPUs

After the system is running, a single line boot message is displayed
when CPU's are hotplugged on:

    Booting Node %d Processor %d APIC 0x%x

Status of the following lines:

    CPU: Physical Processor ID:		printed once (for boot cpu)
    CPU: Processor Core ID:		printed once (for boot cpu)
    CPU: Hyper-Threading is disabled	printed once (for boot cpu)
    CPU: Thermal monitoring enabled	printed once (for boot cpu)
    CPU %d/0x%x -> Node %d:		removed
    CPU %d is now offline:		only if system_state == RUNNING
    Initializing CPU#%d:		KERN_DEBUG

Signed-off-by: Mike Travis <travis@sgi.com>
LKML-Reference: <4B219E28.8080601@sgi.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/cpu/addon_cpuid_features.c |   15 +++++----
 arch/x86/kernel/cpu/amd.c                  |    2 -
 arch/x86/kernel/cpu/common.c               |    8 +++--
 arch/x86/kernel/cpu/intel.c                |    2 -
 arch/x86/kernel/cpu/mcheck/therm_throt.c   |    4 +-
 arch/x86/kernel/smpboot.c                  |   45 +++++++++++++++++++--------
 6 files changed, 47 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
index c965e52..468489b 100644
--- a/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -74,6 +74,7 @@ void __cpuinit detect_extended_topology(struct cpuinfo_x86 *c)
 	unsigned int eax, ebx, ecx, edx, sub_index;
 	unsigned int ht_mask_width, core_plus_mask_width;
 	unsigned int core_select_mask, core_level_siblings;
+	static bool printed;
 
 	if (c->cpuid_level < 0xb)
 		return;
@@ -127,12 +128,14 @@ void __cpuinit detect_extended_topology(struct cpuinfo_x86 *c)
 
 	c->x86_max_cores = (core_level_siblings / smp_num_siblings);
 
-
-	printk(KERN_INFO  "CPU: Physical Processor ID: %d\n",
-	       c->phys_proc_id);
-	if (c->x86_max_cores > 1)
-		printk(KERN_INFO  "CPU: Processor Core ID: %d\n",
-		       c->cpu_core_id);
+	if (!printed) {
+		printk(KERN_INFO  "CPU: Physical Processor ID: %d\n",
+		       c->phys_proc_id);
+		if (c->x86_max_cores > 1)
+			printk(KERN_INFO  "CPU: Processor Core ID: %d\n",
+			       c->cpu_core_id);
+		printed = 1;
+	}
 	return;
 #endif
 }
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 7128b37..8dc3ea1 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -375,8 +375,6 @@ static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
 			node = nearby_node(apicid);
 	}
 	numa_set_node(cpu, node);
-
-	printk(KERN_INFO "CPU %d/0x%x -> Node %d\n", cpu, apicid, node);
 #endif
 }
 
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index c1afa99..0ee9a32 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -427,6 +427,7 @@ void __cpuinit detect_ht(struct cpuinfo_x86 *c)
 #ifdef CONFIG_X86_HT
 	u32 eax, ebx, ecx, edx;
 	int index_msb, core_bits;
+	static bool printed;
 
 	if (!cpu_has(c, X86_FEATURE_HT))
 		return;
@@ -442,7 +443,7 @@ void __cpuinit detect_ht(struct cpuinfo_x86 *c)
 	smp_num_siblings = (ebx & 0xff0000) >> 16;
 
 	if (smp_num_siblings == 1) {
-		printk(KERN_INFO  "CPU: Hyper-Threading is disabled\n");
+		printk_once(KERN_INFO "CPU0: Hyper-Threading is disabled\n");
 		goto out;
 	}
 
@@ -469,11 +470,12 @@ void __cpuinit detect_ht(struct cpuinfo_x86 *c)
 				       ((1 << core_bits) - 1);
 
 out:
-	if ((c->x86_max_cores * smp_num_siblings) > 1) {
+	if (!printed && (c->x86_max_cores * smp_num_siblings) > 1) {
 		printk(KERN_INFO  "CPU: Physical Processor ID: %d\n",
 		       c->phys_proc_id);
 		printk(KERN_INFO  "CPU: Processor Core ID: %d\n",
 		       c->cpu_core_id);
+		printed = 1;
 	}
 #endif
 }
@@ -1115,7 +1117,7 @@ void __cpuinit cpu_init(void)
 	if (cpumask_test_and_set_cpu(cpu, cpu_initialized_mask))
 		panic("CPU#%d already initialized!\n", cpu);
 
-	printk(KERN_INFO "Initializing CPU#%d\n", cpu);
+	pr_debug("Initializing CPU#%d\n", cpu);
 
 	clear_in_cr4(X86_CR4_VME|X86_CR4_PVI|X86_CR4_TSD|X86_CR4_DE);
 
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index c900b73..9c31e8b 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -270,8 +270,6 @@ static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
 		node = cpu_to_node(cpu);
 	}
 	numa_set_node(cpu, node);
-
-	printk(KERN_INFO "CPU %d/0x%x -> Node %d\n", cpu, apicid, node);
 #endif
 }
 
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index 4fef985..1003ed4 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -339,8 +339,8 @@ void intel_init_thermal(struct cpuinfo_x86 *c)
 	l = apic_read(APIC_LVTTHMR);
 	apic_write(APIC_LVTTHMR, l & ~APIC_LVT_MASKED);
 
-	printk(KERN_INFO "CPU%d: Thermal monitoring enabled (%s)\n",
-	       cpu, tm2 ? "TM2" : "TM1");
+	printk_once(KERN_INFO "CPU0: Thermal monitoring enabled (%s)\n",
+		       tm2 ? "TM2" : "TM1");
 
 	/* enable thermal throttle processing */
 	atomic_set(&therm_throt_en, 1);
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 29e6744..678d0b8 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -671,6 +671,26 @@ static void __cpuinit do_fork_idle(struct work_struct *work)
 	complete(&c_idle->done);
 }
 
+/* reduce the number of lines printed when booting a large cpu count system */
+static void __cpuinit announce_cpu(int cpu, int apicid)
+{
+	static int current_node = -1;
+	int node = cpu_to_node(cpu);
+
+	if (system_state == SYSTEM_BOOTING) {
+		if (node != current_node) {
+			if (current_node > (-1))
+				pr_cont(" Ok.\n");
+			current_node = node;
+			pr_info("Booting Node %3d, Processors ", node);
+		}
+		pr_cont(" #%d%s", cpu, cpu == (nr_cpu_ids - 1) ? " Ok.\n" : "");
+		return;
+	} else
+		pr_info("Booting Node %d Processor %d APIC 0x%x\n",
+			node, cpu, apicid);
+}
+
 /*
  * NOTE - on most systems this is a PHYSICAL apic ID, but on multiquad
  * (ie clustered apic addressing mode), this is a LOGICAL apic ID.
@@ -737,9 +757,8 @@ do_rest:
 	/* start_ip had better be page-aligned! */
 	start_ip = setup_trampoline();
 
-	/* So we see what's up   */
-	printk(KERN_INFO "Booting processor %d APIC 0x%x ip 0x%lx\n",
-			  cpu, apicid, start_ip);
+	/* So we see what's up */
+	announce_cpu(cpu, apicid);
 
 	/*
 	 * This grunge runs the startup process for
@@ -788,21 +807,17 @@ do_rest:
 			udelay(100);
 		}
 
-		if (cpumask_test_cpu(cpu, cpu_callin_mask)) {
-			/* number CPUs logically, starting from 1 (BSP is 0) */
-			pr_debug("OK.\n");
-			printk(KERN_INFO "CPU%d: ", cpu);
-			print_cpu_info(&cpu_data(cpu));
-			pr_debug("CPU has booted.\n");
-		} else {
+		if (cpumask_test_cpu(cpu, cpu_callin_mask))
+			pr_debug("CPU%d: has booted.\n", cpu);
+		else {
 			boot_error = 1;
 			if (*((volatile unsigned char *)trampoline_base)
 					== 0xA5)
 				/* trampoline started but...? */
-				printk(KERN_ERR "Stuck ??\n");
+				pr_err("CPU%d: Stuck ??\n", cpu);
 			else
 				/* trampoline code not run */
-				printk(KERN_ERR "Not responding.\n");
+				pr_err("CPU%d: Not responding.\n", cpu);
 			if (apic->inquire_remote_apic)
 				apic->inquire_remote_apic(apicid);
 		}
@@ -1293,14 +1308,16 @@ void native_cpu_die(unsigned int cpu)
 	for (i = 0; i < 10; i++) {
 		/* They ack this in play_dead by setting CPU_DEAD */
 		if (per_cpu(cpu_state, cpu) == CPU_DEAD) {
-			printk(KERN_INFO "CPU %d is now offline\n", cpu);
+			if (system_state == SYSTEM_RUNNING)
+				pr_info("CPU %u is now offline\n", cpu);
+
 			if (1 == num_online_cpus())
 				alternatives_smp_switch(0);
 			return;
 		}
 		msleep(100);
 	}
-	printk(KERN_ERR "CPU %u didn't die...\n", cpu);
+	pr_err("CPU %u didn't die...\n", cpu);
 }
 
 void play_dead_common(void)
