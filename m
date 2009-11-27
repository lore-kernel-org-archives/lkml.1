Return-Path: <linux-kernel-owner+w=401wt.eu-S1752839AbZK0V3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbZK0V3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 16:29:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752664AbZK0V3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 16:29:41 -0500
Received: from relay2.sgi.com ([192.48.179.30]:48322 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752527AbZK0V3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 16:29:40 -0500
Message-ID: <4B1044C8.3030208@sgi.com>
Date: Fri, 27 Nov 2009 13:29:44 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
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
Subject: [PATCH] x86: Limit the number of processor bootup messages
References: <20091118002211.709343000@alcatraz.americas.sgi.com> <20091118002219.163869000@alcatraz.americas.sgi.com> <20091126091559.GG1389@elte.hu>
In-Reply-To: <20091126091559.GG1389@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> +++ linux/arch/x86/kernel/smpboot.c
>> @@ -671,6 +671,27 @@
>>  	complete(&c_idle->done);
>>  }
>>  
>> +/* reduce the number of lines printed when booting a large cpu count system */
>> +static void __cpuinit announce_cpu(int cpu, int apicid)
>> +{
>> +	if (system_state == SYSTEM_BOOTING) {
>> +#ifdef CONFIG_NUMA
>> +		static int current_node = -1;
>> +		int node = cpu_to_node(cpu);
>> +
>> +		if (node != current_node) {
>> +			if (current_node > (-1))
>> +				pr_cont(" Ok.\n");
>> +			current_node = node;
>> +			pr_info("Booting Node %3d, Processors ", node);
>> +		}
>> +		pr_cont(" #%d%s", cpu, cpu == (nr_cpu_ids - 1) ? " Ok.\n" : "");
>> +		return;
>> +#endif
>> +	}
> 
> That's pretty ugly. (the #ifdef is at the wrong nesting level to begin 
> with)
> 
> Also, cannot we print out the same thing with no #ifdef variances? Users 
> of UP systems wont be confused by a 'Node 0, CPU 0' message and in 5 
> years most x86 people will be running NUMA systems.
> 
> 	Ingo

Sure thing, though note that the above is only for secondary processors.
Boot CPU is still displayed as it was before (except for the cache line
size removal in other patches.)

---
 arch/x86/kernel/cpu/addon_cpuid_features.c |   15 +++++----
 arch/x86/kernel/cpu/amd.c                  |    2 -
 arch/x86/kernel/cpu/common.c               |   12 ++++---
 arch/x86/kernel/cpu/intel.c                |    2 -
 arch/x86/kernel/cpu/mcheck/therm_throt.c   |    8 +++--
 arch/x86/kernel/smpboot.c                  |   45 +++++++++++++++++++----------
 6 files changed, 53 insertions(+), 31 deletions(-)

--- linux.orig/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ linux/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -74,6 +74,7 @@
 	unsigned int eax, ebx, ecx, edx, sub_index;
 	unsigned int ht_mask_width, core_plus_mask_width;
 	unsigned int core_select_mask, core_level_siblings;
+	static bool printed;
 
 	if (c->cpuid_level < 0xb)
 		return;
@@ -127,12 +128,14 @@
 
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
@@ -432,6 +432,7 @@
 #ifdef CONFIG_X86_HT
 	u32 eax, ebx, ecx, edx;
 	int index_msb, core_bits;
+	static bool printed;
 
 	if (!cpu_has(c, X86_FEATURE_HT))
 		return;
@@ -446,9 +447,9 @@
 
 	smp_num_siblings = (ebx & 0xff0000) >> 16;
 
-	if (smp_num_siblings == 1) {
-		printk(KERN_INFO  "CPU: Hyper-Threading is disabled\n");
-		goto out;
+	if (smp_num_siblings == 1 && c->cpu_index == 0) {
+		pr_info("CPU0: Hyper-Threading is disabled\n");
+		return;
 	}
 
 	if (smp_num_siblings <= 1)
@@ -474,11 +475,12 @@
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
@@ -1115,7 +1117,7 @@
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
@@ -259,6 +259,7 @@
 	unsigned int cpu = smp_processor_id();
 	int tm2 = 0;
 	u32 l, h;
+	static bool printed;
 
 	/* Thermal monitoring depends on ACPI and clock modulation*/
 	if (!cpu_has(c, X86_FEATURE_ACPI) || !cpu_has(c, X86_FEATURE_ACC))
@@ -312,8 +313,11 @@
 	l = apic_read(APIC_LVTTHMR);
 	apic_write(APIC_LVTTHMR, l & ~APIC_LVT_MASKED);
 
-	printk(KERN_INFO "CPU%d: Thermal monitoring enabled (%s)\n",
-	       cpu, tm2 ? "TM2" : "TM1");
+	if (!printed) {
+		printk(KERN_INFO "CPU0: Thermal monitoring enabled (%s)\n",
+		       tm2 ? "TM2" : "TM1");
+		printed = true;
+	}
 
 	/* enable thermal throttle processing */
 	atomic_set(&therm_throt_en, 1);
--- linux.orig/arch/x86/kernel/smpboot.c
+++ linux/arch/x86/kernel/smpboot.c
@@ -671,6 +671,26 @@
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
@@ -736,9 +756,8 @@
 	/* start_ip had better be page-aligned! */
 	start_ip = setup_trampoline();
 
-	/* So we see what's up   */
-	printk(KERN_INFO "Booting processor %d APIC 0x%x ip 0x%lx\n",
-			  cpu, apicid, start_ip);
+	/* So we see what's up */
+	announce_cpu(cpu, apicid);
 
 	/*
 	 * This grunge runs the startup process for
@@ -787,21 +806,17 @@
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
@@ -1300,14 +1315,16 @@
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

