Return-Path: <linux-kernel-owner+w=401wt.eu-S1753711AbZKLRTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711AbZKLRTv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 12:19:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbZKLRTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 12:19:49 -0500
Received: from relay3.sgi.com ([192.48.152.1]:59159 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752955AbZKLRTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 12:19:46 -0500
Message-Id: <20091112171942.423844000@alcatraz.americas.sgi.com>
References: <20091112171934.584037000@alcatraz.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 12 Nov 2009 11:19:35 -0600
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
Subject: [PATCH 1/7] x86: Limit the number of processor bootup messages
Content-Disposition: inline; filename=limit_boot_cpu_messages
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With a large number of processors in a system there is an excessive amount
of messages sent to the system console.  It's estimated that with 4096
processors in a system, and the console baudrate set to 56K, the startup
messages will take about 84 minutes to clear the serial port.

This set of patches limits the number of repetitious messages which contain
no additional information.  Much of this information is obtainable from the
/proc and /sysfs.   Most of the messages are also sent to the kernel log
buffer as KERN_DEBUG messages so it can be used to examine more closely any
details specific to a processor.

The list of message transformations....

For system_state == SYSTEM_BOOTING:

[   18.669304] Booting Node   0, Processors  1 2 3 4 5 6 7 Ok.
[   19.321065] Booting Node   1, Processors  8 9 10 11 12 13 14 15 Ok.
[   20.065325] Booting Node   2, Processors  16 17 18 19 20 21 22 23 Ok.
..
[  117.153053] Booting Node  63, Processors  1016 1017 1018 1019 1020 1021 1022 1023 Ok.
[  117.952235] Brought up 1024 CPUs

Timing shows that with NO bootup messages, it takes only slightly less time
so printing adds very little overhead:

[   18.670219] Booting all processors
[  117.180248] Brought up 1024 CPUs

For Processor Information printout, the specifics of CPU0 are printed and
then at the end of the bootup sequence, a summary is printed:

[  117.957682] Processor Information for CPUS: 0-191,208-223,256-271,...
[  117.968034] Genuine Intel(R) CPU             0000 @ 2.13GHz stepping 04
[  117.977406] BogoMIPS: MIN 3989.01 (7978031) AVG 4266.62 (8533249) MAX 4537.51 (9075028)
[  117.984496] Processor Information for CPUS: 192-207,240-255,272-287,...
[  117.996032] Genuine Intel(R) CPU             0000 @ 2.13GHz stepping 03
[  118.001404] BogoMIPS: MIN 4021.49 (8042995) AVG 4265.91 (8531833) MAX 4479.79 (8959584)
[  118.012373] Processor Information for CPUS: 224-239,736-751
[  118.020032] Genuine Intel(R) CPU             0000 @ 1.87GHz stepping 03
[  118.028033] BogoMIPS: MIN 3733.92 (7467855) AVG 3746.96 (7493933) MAX 3939.52 (7879056)
[  118.036360] Processor Information for CPUS: 320-335,384-415,432-447,...
[  118.044032] Intel(R) Xeon(R) CPU           X7560  @ 2.27GHz stepping 05
[  118.053404] BogoMIPS: MIN 4244.65 (8489318) AVG 4532.45 (9064917) MAX 4666.80 (9333604)
[  118.060644] Total of 1024 processors activated (4386353.46 BogoMIPS).


The following lines have been removed:

	CPU: Physical Processor ID:
	CPU: Processor Core ID:
	CPU %d/0x%x -> Node %d

The following lines will only be printed if unusual (state):

	CPU %d is now offline  (system_state == RUNNING)

The following lines will only be printed in debug mode:

	Initializing CPU#%d

The following lines are only printed for the first cpu:

	CPU0: Hyper-Threading is disabled
	CPU0: Thermal monitoring enabled
	CPU0: <cache line sizes>


Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/cpu/addon_cpuid_features.c |    6 -
 arch/x86/kernel/cpu/amd.c                  |    2 
 arch/x86/kernel/cpu/common.c               |   20 +---
 arch/x86/kernel/cpu/intel.c                |    2 
 arch/x86/kernel/cpu/intel_cacheinfo.c      |   28 +++---
 arch/x86/kernel/cpu/mcheck/therm_throt.c   |    5 -
 arch/x86/kernel/smpboot.c                  |  118 +++++++++++++++++++++++++----
 7 files changed, 129 insertions(+), 52 deletions(-)

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
 
--- linux.orig/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ linux/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -488,21 +488,23 @@
 #endif
 	}
 
-	if (trace)
-		printk(KERN_INFO "CPU: Trace cache: %dK uops", trace);
-	else if (l1i)
-		printk(KERN_INFO "CPU: L1 I cache: %dK", l1i);
-
-	if (l1d)
-		printk(KERN_CONT ", L1 D cache: %dK\n", l1d);
-	else
-		printk(KERN_CONT "\n");
+	if (c->cpu_index == 0) {
+		if (trace)
+			pr_info("CPU0: Trace cache: %dK uops", trace);
+		else if (l1i)
+			pr_info("CPU0: L1 I cache: %dK", l1i);
+
+		if (l1d)
+			pr_cont(", L1 D cache: %dK\n", l1d);
+		else
+			pr_cont("\n");
 
-	if (l2)
-		printk(KERN_INFO "CPU: L2 cache: %dK\n", l2);
+		if (l2)
+			pr_info("CPU0: L2 cache: %dK\n", l2);
 
-	if (l3)
-		printk(KERN_INFO "CPU: L3 cache: %dK\n", l3);
+		if (l3)
+			pr_info("CPU0: L3 cache: %dK\n", l3);
+	}
 
 	c->x86_cache_size = l3 ? l3 : (l2 ? l2 : (l1i+l1d));
 
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
@@ -442,6 +442,84 @@
 		return c->llc_shared_map;
 }
 
+/* Summarize Processor Information */
+static void __init summarize_cpu_info(void)
+{
+	cpumask_var_t cpulist, cpusdone;
+	int cpu;
+	int err = 0;
+
+	if (!alloc_cpumask_var(&cpulist, GFP_KERNEL))
+		err = 1;
+	else if (!alloc_cpumask_var(&cpusdone, GFP_KERNEL)) {
+		free_cpumask_var(cpulist);
+		err = 1;
+	}
+	if (err) {
+		printk(KERN_INFO "Can't print processor summaries\n");
+		return;
+	}
+
+	cpumask_clear(cpusdone);
+	for (cpu = 0; cpu < nr_cpu_ids; cpu++) {
+		struct cpuinfo_x86 *c;
+		char buf[128];
+		int ncpu, len;
+		unsigned long minlpj, maxlpj, avglpj = 0;
+
+		/* skip if cpu has already been displayed */
+		if (cpumask_test_cpu(cpu, cpusdone))
+			continue;
+
+		c = &cpu_data(cpu);
+		minlpj = ULONG_MAX;
+		maxlpj = 0;
+
+		cpumask_clear(cpulist);
+
+		/* collate all cpus with same specifics */
+		for (ncpu = cpu; ncpu < nr_cpu_ids; ncpu++) {
+			struct cpuinfo_x86 *n = &cpu_data(ncpu);
+
+			if (c->x86 != n->x86 ||
+			    c->x86_vendor != n->x86_vendor ||
+			    c->x86_model  != n->x86_model  ||
+			    c->x86_mask   != n->x86_mask   ||
+			    strcmp(c->x86_model_id, n->x86_model_id))
+				continue;
+
+			cpumask_set_cpu(ncpu, cpulist);
+			cpumask_set_cpu(ncpu, cpusdone);
+
+			if (cpu_data(ncpu).loops_per_jiffy < minlpj)
+				minlpj = cpu_data(ncpu).loops_per_jiffy;
+
+			if (cpu_data(ncpu).loops_per_jiffy > maxlpj)
+				maxlpj = cpu_data(ncpu).loops_per_jiffy;
+
+			avglpj += cpu_data(ncpu).loops_per_jiffy;
+		}
+
+		len = cpulist_scnprintf(buf, sizeof(buf), cpulist);
+		printk(KERN_INFO
+			"Processor Information for CPUS: %s%s\n",
+				buf, (len == sizeof(buf)-1) ? "..." : "");
+
+		printk(KERN_INFO);
+		print_cpu_info(c);
+
+		avglpj /= cpumask_weight(cpulist);
+		printk(KERN_INFO "BogoMIPS: MIN %lu.%02lu (%lu) "
+			"AVG %lu.%02lu (%lu) MAX %lu.%02lu (%lu)\n",
+			minlpj/(500000/HZ), (minlpj/(5000/HZ)) % 100, minlpj,
+			avglpj/(500000/HZ), (avglpj/(5000/HZ)) % 100, avglpj,
+			maxlpj/(500000/HZ), (maxlpj/(5000/HZ)) % 100, maxlpj);
+	}
+
+	free_cpumask_var(cpusdone);
+	free_cpumask_var(cpulist);
+}
+
 static void impress_friends(void)
 {
 	int cpu;
@@ -737,8 +815,21 @@
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
+		pr_cont(" %d%s", cpu, cpu == (nr_cpu_ids - 1) ? " Ok.\n" : "");
+	} else
+#endif
+		pr_info("Booting Processor %d APIC 0x%x\n", cpu, apicid);
 
 	/*
 	 * This grunge runs the startup process for
@@ -787,21 +878,17 @@
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
@@ -1147,6 +1234,9 @@
 {
 	pr_debug("Boot done.\n");
 
+	/* print processor data summaries */
+	summarize_cpu_info();
+
 	impress_friends();
 #ifdef CONFIG_X86_IO_APIC
 	setup_ioapic_dest();
@@ -1300,14 +1390,16 @@
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
