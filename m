Return-Path: <linux-kernel-owner+w=401wt.eu-S1754137AbZKPVH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbZKPVH0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 16:07:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753945AbZKPVHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 16:07:25 -0500
Received: from relay3.sgi.com ([192.48.152.1]:48372 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751869AbZKPVHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 16:07:23 -0500
Message-Id: <20091116210726.585624000@alcatraz.americas.sgi.com>
References: <20091116210718.412792000@alcatraz.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 16 Nov 2009 15:07:19 -0600
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] x86: Limit the number of processor bootup messages
Content-Disposition: inline; filename=limit_boot_cpu_messages
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

The list of message transformations....

For system_state == SYSTEM_BOOTING:

Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 Ok.
Booting Node   1, Processors  #8 #9 #10 #11 #12 #13 #14 #15 Ok.
..
Booting Node   3, Processors  #56 #57 #58 #59 #60 #61 #62 #63 Ok.
Brought up 64 CPUs

The following lines have been removed:

	CPU: Physical Processor ID:
	CPU: Processor Core ID:
	CPU %d/0x%x -> Node %d

The following lines will only be printed if unusual (state):

	CPU %d is now offline  (system_state == RUNNING)

The following lines will only be printed in debug mode:

	Initializing CPU#%d

The following lines are only printed for the first (boot) cpu:

	CPU0: Hyper-Threading is disabled
	CPU0: Thermal monitoring enabled

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/cpu/addon_cpuid_features.c |    6 ----
 arch/x86/kernel/cpu/amd.c                  |    2 -
 arch/x86/kernel/cpu/common.c               |   20 ++++-----------
 arch/x86/kernel/cpu/intel.c                |    2 -
 arch/x86/kernel/cpu/mcheck/therm_throt.c   |    5 ++-
 arch/x86/kernel/smpboot.c                  |   37 ++++++++++++++++++-----------
 6 files changed, 33 insertions(+), 39 deletions(-)

--- linux.orig/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ linux/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -127,12 +127,6 @@
 
 	c->x86_max_cores = (core_level_siblings / smp_num_siblings);
 
-
-	printk(KERN_INFO  "CPU: Physical Processor ID: %d\n",
-	       c->phys_proc_id);
-	if (c->x86_max_cores > 1)
-		printk(KERN_INFO  "CPU: Processor Core ID: %d\n",
-		       c->cpu_core_id);
 	return;
 #endif
 }
--- linux.orig/arch/x86/kernel/cpu/amd.c
+++ linux/arch/x86/kernel/cpu/amd.c
@@ -375,8 +375,6 @@
 			node = nearby_node(apicid);
 	}
 	numa_set_node(cpu, node);
-
-	printk(KERN_INFO "CPU %d/0x%x -> Node %d\n", cpu, apicid, node);
 #endif
 }
 
--- linux.orig/arch/x86/kernel/cpu/common.c
+++ linux/arch/x86/kernel/cpu/common.c
@@ -437,7 +437,7 @@
 		return;
 
 	if (cpu_has(c, X86_FEATURE_CMP_LEGACY))
-		goto out;
+		return;
 
 	if (cpu_has(c, X86_FEATURE_XTOPOLOGY))
 		return;
@@ -446,13 +446,13 @@
 
 	smp_num_siblings = (ebx & 0xff0000) >> 16;
 
-	if (smp_num_siblings == 1) {
-		printk(KERN_INFO  "CPU: Hyper-Threading is disabled\n");
-		goto out;
+	if (smp_num_siblings == 1 && c->cpu_index == 0) {
+		pr_info("CPU0: Hyper-Threading is disabled\n");
+		return;
 	}
 
 	if (smp_num_siblings <= 1)
-		goto out;
+		return;
 
 	if (smp_num_siblings > nr_cpu_ids) {
 		pr_warning("CPU: Unsupported number of siblings %d",
@@ -472,14 +472,6 @@
 
 	c->cpu_core_id = apic->phys_pkg_id(c->initial_apicid, index_msb) &
 				       ((1 << core_bits) - 1);
-
-out:
-	if ((c->x86_max_cores * smp_num_siblings) > 1) {
-		printk(KERN_INFO  "CPU: Physical Processor ID: %d\n",
-		       c->phys_proc_id);
-		printk(KERN_INFO  "CPU: Processor Core ID: %d\n",
-		       c->cpu_core_id);
-	}
 #endif
 }
 
@@ -1115,7 +1107,7 @@
 	if (cpumask_test_and_set_cpu(cpu, cpu_initialized_mask))
 		panic("CPU#%d already initialized!\n", cpu);
 
-	printk(KERN_INFO "Initializing CPU#%d\n", cpu);
+	pr_debug("Initializing CPU#%d\n", cpu);
 
 	clear_in_cr4(X86_CR4_VME|X86_CR4_PVI|X86_CR4_TSD|X86_CR4_DE);
 
--- linux.orig/arch/x86/kernel/cpu/intel.c
+++ linux/arch/x86/kernel/cpu/intel.c
@@ -266,8 +266,6 @@
 	if (node == NUMA_NO_NODE || !node_online(node))
 		node = first_node(node_online_map);
 	numa_set_node(cpu, node);
-
-	printk(KERN_INFO "CPU %d/0x%x -> Node %d\n", cpu, apicid, node);
 #endif
 }
 
--- linux.orig/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ linux/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -312,8 +312,9 @@
 	l = apic_read(APIC_LVTTHMR);
 	apic_write(APIC_LVTTHMR, l & ~APIC_LVT_MASKED);
 
-	printk(KERN_INFO "CPU%d: Thermal monitoring enabled (%s)\n",
-	       cpu, tm2 ? "TM2" : "TM1");
+	if (cpu == 0)
+		printk(KERN_INFO "CPU0: Thermal monitoring enabled (%s)\n",
+		       tm2 ? "TM2" : "TM1");
 
 	/* enable thermal throttle processing */
 	atomic_set(&therm_throt_en, 1);
--- linux.orig/arch/x86/kernel/smpboot.c
+++ linux/arch/x86/kernel/smpboot.c
@@ -737,8 +737,21 @@
 	start_ip = setup_trampoline();
 
 	/* So we see what's up   */
-	printk(KERN_INFO "Booting processor %d APIC 0x%x ip 0x%lx\n",
-			  cpu, apicid, start_ip);
+#ifdef CONFIG_NUMA
+	if (system_state == SYSTEM_BOOTING) {
+		static int current_node = -1;
+		int node = cpu_to_node(cpu);
+
+		if (node != current_node) {
+			if (current_node > (-1))
+				pr_cont(" Ok.\n");
+			current_node = node;
+			pr_info("Booting Node %3d, Processors ", node);
+		}
+		pr_cont(" #%d%s", cpu, cpu == (nr_cpu_ids - 1) ? " Ok.\n" : "");
+	} else
+#endif
+		pr_info("Booting Processor %d APIC 0x%x\n", cpu, apicid);
 
 	/*
 	 * This grunge runs the startup process for
@@ -787,21 +800,17 @@
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
@@ -1300,14 +1309,16 @@
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

-- 
