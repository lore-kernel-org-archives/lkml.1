Return-Path: <linux-kernel-owner+w=401wt.eu-S1756801AbYLKL3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801AbYLKL3Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 06:29:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755554AbYLKL2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 06:28:18 -0500
Received: from relay2.sgi.com ([192.48.179.30]:54799 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755160AbYLKL2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 06:28:11 -0500
Message-Id: <20081211112807.004085000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.47-1
Date: Thu, 11 Dec 2008 03:28:09 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] cpumask: use maxcpus=NUM to extend the cpu limit as well as restrict the limit
References: <20081211112806.499831000@polaris-admin.engr.sgi.com>
Content-Disposition: inline; filename=x86:use-maxcpus.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: allow adding additional cpus.

Use maxcpus=NUM kernel parameter to extend the number of possible cpus as well
as (currently) limit them.  Any cpus >= number of present cpus will disabled.

The ability to HOTPLUG ON cpus that are "possible" but not "present" is
dealt with in a later patch.

Based on:
  git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
+ git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git/cpus4096
+ git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-ingo.git

Signed-off-by: Mike Travis <travis@sgi.com>
---
 Documentation/kernel-parameters.txt |    6 +++++-
 arch/x86/kernel/alternative.c       |    2 +-
 arch/x86/kernel/apic.c              |   12 +++++++++---
 arch/x86/kernel/smpboot.c           |   18 ++++++++++++++----
 arch/x86/kernel/visws_quirks.c      |    4 ++--
 include/linux/smp.h                 |   19 ++++++++++++++++++-
 init/main.c                         |   14 ++++++--------
 7 files changed, 55 insertions(+), 20 deletions(-)

--- linux-2.6-for-ingo.orig/Documentation/kernel-parameters.txt
+++ linux-2.6-for-ingo/Documentation/kernel-parameters.txt
@@ -1201,7 +1201,11 @@ and is between 256 and 4096 characters. 
 			should make use of.  maxcpus=n : n >= 0 limits the
 			kernel to using 'n' processors.  n=0 is a special case,
 			it is equivalent to "nosmp", which also disables
-			the IO APIC.
+			the IO APIC.  On [X86] maxcpus can also be used to
+			extend the number of possible cpus to overcome ACPI
+			tables that do not indicate disabled cpus, as well as
+			allow for additional cpus to be HOT PLUGGED in.
+			Format: <0-NR_CPUS>
 
 	max_addr=nn[KMG]	[KNL,BOOT,ia64] All physical memory greater than
 			or equal to this physical address is ignored.
--- linux-2.6-for-ingo.orig/arch/x86/kernel/alternative.c
+++ linux-2.6-for-ingo/arch/x86/kernel/alternative.c
@@ -444,7 +444,7 @@ void __init alternative_instructions(voi
 					    _text, _etext);
 
 		/* Only switch to UP mode if we don't immediately boot others */
-		if (num_present_cpus() == 1 || setup_max_cpus <= 1)
+		if (num_present_cpus() == 1 || maxcpus() <= 1)
 			alternatives_smp_switch(0);
 	}
 #endif
--- linux-2.6-for-ingo.orig/arch/x86/kernel/apic.c
+++ linux-2.6-for-ingo/arch/x86/kernel/apic.c
@@ -1845,9 +1845,15 @@ void __cpuinit generic_processor_info(in
 	}
 	apic_version[apicid] = version;
 
-	if (num_processors >= NR_CPUS) {
-		printk(KERN_WARNING "WARNING: NR_CPUS limit of %i reached."
-			"  Processor ignored.\n", NR_CPUS);
+	if (num_processors >= maxcpus()) {
+		int max = maxcpus();
+		int thiscpu = max + disabled_cpus;
+
+		printk(KERN_WARNING
+			"ACPI: NR_CPUS/maxcpus limit of %i reached."
+			"  Processor %d/0x%x ignored.\n", max, thiscpu, apicid);
+
+		disabled_cpus++;
 		return;
 	}
 
--- linux-2.6-for-ingo.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6-for-ingo/arch/x86/kernel/smpboot.c
@@ -1266,7 +1266,7 @@ void __init native_smp_cpus_done(unsigne
  *
  * Three ways to find out the number of additional hotplug CPUs:
  * - If the BIOS specified disabled CPUs in ACPI/mptables use that.
- * - The user can overwrite it with additional_cpus=NUM
+ * - The user can overwrite it with maxcpus=NUM
  * - Otherwise don't reserve additional CPUs.
  * We do this because additional CPUs waste a lot of memory.
  * -AK
@@ -1279,9 +1279,19 @@ __init void prefill_possible_map(void)
 	if (!num_processors)
 		num_processors = 1;
 
-	possible = num_processors + disabled_cpus;
-	if (possible > NR_CPUS)
-		possible = NR_CPUS;
+	if (setup_max_cpus == -1)	/* not specified */
+		possible = num_processors + disabled_cpus;
+	else if (setup_max_cpus == 0)	/* UP mode forced */
+		possible = 1;
+	else				/* user specified */
+		possible = setup_max_cpus;
+
+	if (possible > CONFIG_NR_CPUS) {
+		printk(KERN_WARNING
+			"%d Processors exceeds NR_CPUS limit of %d\n",
+			possible, CONFIG_NR_CPUS);
+		possible = CONFIG_NR_CPUS;
+	}
 
 	printk(KERN_INFO "SMP: Allowing %d CPUs, %d hotplug CPUs\n",
 		possible, max_t(int, possible - num_processors, 0));
--- linux-2.6-for-ingo.orig/arch/x86/kernel/visws_quirks.c
+++ linux-2.6-for-ingo/arch/x86/kernel/visws_quirks.c
@@ -228,8 +228,8 @@ static int __init visws_find_smp_config(
 		ncpus = CO_CPU_MAX;
 	}
 
-	if (ncpus > setup_max_cpus)
-		ncpus = setup_max_cpus;
+	if (ncpus > maxcpus())
+		ncpus = maxcpus();
 
 #ifdef CONFIG_X86_LOCAL_APIC
 	smp_found_config = 1;
--- linux-2.6-for-ingo.orig/include/linux/smp.h
+++ linux-2.6-for-ingo/include/linux/smp.h
@@ -112,7 +112,18 @@ int on_each_cpu(void (*func) (void *info
  */
 void smp_prepare_boot_cpu(void);
 
-extern unsigned int setup_max_cpus;
+extern int setup_max_cpus;
+static inline int maxcpus(void)
+{
+	int maxcpus = setup_max_cpus;
+
+	if (maxcpus == -1 || maxcpus > CONFIG_NR_CPUS)
+		maxcpus = CONFIG_NR_CPUS;
+	else if (maxcpus == 0)
+		maxcpus = 1;
+
+	return maxcpus;
+}
 
 #else /* !SMP */
 
@@ -149,6 +160,12 @@ static inline void smp_send_reschedule(i
 static inline void init_call_single_data(void)
 {
 }
+
+static inline int maxcpus(void)
+{
+	return 1;
+}
+
 #endif /* !SMP */
 
 /*
--- linux-2.6-for-ingo.orig/init/main.c
+++ linux-2.6-for-ingo/init/main.c
@@ -132,7 +132,7 @@ static char *ramdisk_execute_command;
 
 #ifdef CONFIG_SMP
 /* Setup configured maximum number of CPUs to activate */
-unsigned int __initdata setup_max_cpus = NR_CPUS;
+int setup_max_cpus = -1;
 
 /*
  * Setup routine for controlling SMP activation
@@ -157,7 +157,7 @@ static int __init nosmp(char *str)
 
 early_param("nosmp", nosmp);
 
-static int __init maxcpus(char *str)
+static int __init set_maxcpus(char *str)
 {
 	get_option(&str, &setup_max_cpus);
 	if (setup_max_cpus == 0)
@@ -166,9 +166,7 @@ static int __init maxcpus(char *str)
 	return 0;
 }
 
-early_param("maxcpus", maxcpus);
-#else
-#define setup_max_cpus NR_CPUS
+early_param("maxcpus", set_maxcpus);
 #endif
 
 /*
@@ -425,7 +423,7 @@ static void __init smp_init(void)
 
 	/* FIXME: This should be done in userspace --RR */
 	for_each_present_cpu(cpu) {
-		if (num_online_cpus() >= setup_max_cpus)
+		if (num_online_cpus() >= maxcpus())
 			break;
 		if (!cpu_online(cpu))
 			cpu_up(cpu);
@@ -433,7 +431,7 @@ static void __init smp_init(void)
 
 	/* Any cleanup work */
 	printk(KERN_INFO "Brought up %ld CPUs\n", (long)num_online_cpus());
-	smp_cpus_done(setup_max_cpus);
+	smp_cpus_done(maxcpus());
 }
 
 #endif
@@ -857,7 +855,7 @@ static int __init kernel_init(void * unu
 
 	cad_pid = task_pid(current);
 
-	smp_prepare_cpus(setup_max_cpus);
+	smp_prepare_cpus(maxcpus());
 
 	do_pre_smp_initcalls();
 	start_boot_trace();

