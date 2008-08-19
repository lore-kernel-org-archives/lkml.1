Return-Path: <linux-kernel-owner+w=401wt.eu-S1756907AbYHSTeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbYHSTeq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 15:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbYHSTeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 15:34:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54422 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbYHSTef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 15:34:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: [PATCH] Revert "[CPUFREQ][2/2] preregister support for powernow-k8"
Date: Tue, 19 Aug 2008 21:37:54 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Langsdorf, Mark" <mark.langsdorf@amd.com>,
       "Dave Jones" <davej@redhat.com>, "LKML" <linux-kernel@vger.kernel.org>,
       kernel-testers@vger.kernel.org,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Arnold, Frank" <Frank.Arnold@amd.com>,
       "Torsten Kaiser" <just.for.lkml@googlemail.com>
References: <200808092321.16711.rjw@sisk.pl> <6453C3CB8E2B3646B0D020C112613273C5AC60@sausexmb4.amd.com>
In-Reply-To: <6453C3CB8E2B3646B0D020C112613273C5AC60@sausexmb4.amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808192137.55818.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Revert "[CPUFREQ][2/2] preregister support for powernow-k8"
    
Revert commit 34ae7f35a21694aa5cb8829dc5142c39d73d6ba0
("[CPUFREQ][2/2] preregister support for powernow-k8") that causes
regressions tracked as:
http://bugzilla.kernel.org/show_bug.cgi?id=11296 ,
http://bugzilla.kernel.org/show_bug.cgi?id=11339 .
Namely, my test box with the Asus M3A32-MVP mainboard and the AMD
Phenom 9850 CPU crashes during hibernation, suspend to RAM and ACPI
power off, apparently due to a failing CPU hotplug notifier.  In
turn, on the Torsten Kaiser's test system only one CPU is correctly
handled by cpufreq.  These problems go away after reverting
34ae7f35a21694aa5cb8829dc5142c39d73d6ba0, but unfortunately they are
quite difficult to debug.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |  109 +++++++++---------------------
 arch/x86/kernel/cpu/cpufreq/powernow-k8.h |    3 
 2 files changed, 37 insertions(+), 75 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ linux-2.6/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -737,63 +737,44 @@ static int find_psb_table(struct powerno
 #ifdef CONFIG_X86_POWERNOW_K8_ACPI
 static void powernow_k8_acpi_pst_values(struct powernow_k8_data *data, unsigned int index)
 {
-	if (!data->acpi_data->state_count || (cpu_family == CPU_HW_PSTATE))
+	if (!data->acpi_data.state_count || (cpu_family == CPU_HW_PSTATE))
 		return;
 
-	data->irt = (data->acpi_data->states[index].control >> IRT_SHIFT) & IRT_MASK;
-	data->rvo = (data->acpi_data->states[index].control >> RVO_SHIFT) & RVO_MASK;
-	data->exttype = (data->acpi_data->states[index].control >> EXT_TYPE_SHIFT) & EXT_TYPE_MASK;
-	data->plllock = (data->acpi_data->states[index].control >> PLL_L_SHIFT) & PLL_L_MASK;
-	data->vidmvs = 1 << ((data->acpi_data->states[index].control >> MVS_SHIFT) & MVS_MASK);
-	data->vstable = (data->acpi_data->states[index].control >> VST_SHIFT) & VST_MASK;
-}
-
-
-static struct acpi_processor_performance *acpi_perf_data;
-static int preregister_valid;
-
-static int powernow_k8_cpu_preinit_acpi(void)
-{
-	acpi_perf_data = alloc_percpu(struct acpi_processor_performance);
-	if (!acpi_perf_data)
-		return -ENODEV;
-
-	if (acpi_processor_preregister_performance(acpi_perf_data))
-		return -ENODEV;
-	else
-		preregister_valid = 1;
-	return 0;
+	data->irt = (data->acpi_data.states[index].control >> IRT_SHIFT) & IRT_MASK;
+	data->rvo = (data->acpi_data.states[index].control >> RVO_SHIFT) & RVO_MASK;
+	data->exttype = (data->acpi_data.states[index].control >> EXT_TYPE_SHIFT) & EXT_TYPE_MASK;
+	data->plllock = (data->acpi_data.states[index].control >> PLL_L_SHIFT) & PLL_L_MASK;
+	data->vidmvs = 1 << ((data->acpi_data.states[index].control >> MVS_SHIFT) & MVS_MASK);
+	data->vstable = (data->acpi_data.states[index].control >> VST_SHIFT) & VST_MASK;
 }
 
 static int powernow_k8_cpu_init_acpi(struct powernow_k8_data *data)
 {
 	struct cpufreq_frequency_table *powernow_table;
 	int ret_val;
-	int cpu = 0;
 
-	data->acpi_data = percpu_ptr(acpi_perf_data, cpu);
-	if (acpi_processor_register_performance(data->acpi_data, data->cpu)) {
+	if (acpi_processor_register_performance(&data->acpi_data, data->cpu)) {
 		dprintk("register performance failed: bad ACPI data\n");
 		return -EIO;
 	}
 
 	/* verify the data contained in the ACPI structures */
-	if (data->acpi_data->state_count <= 1) {
+	if (data->acpi_data.state_count <= 1) {
 		dprintk("No ACPI P-States\n");
 		goto err_out;
 	}
 
-	if ((data->acpi_data->control_register.space_id != ACPI_ADR_SPACE_FIXED_HARDWARE) ||
-		(data->acpi_data->status_register.space_id != ACPI_ADR_SPACE_FIXED_HARDWARE)) {
+	if ((data->acpi_data.control_register.space_id != ACPI_ADR_SPACE_FIXED_HARDWARE) ||
+		(data->acpi_data.status_register.space_id != ACPI_ADR_SPACE_FIXED_HARDWARE)) {
 		dprintk("Invalid control/status registers (%x - %x)\n",
-			data->acpi_data->control_register.space_id,
-			data->acpi_data->status_register.space_id);
+			data->acpi_data.control_register.space_id,
+			data->acpi_data.status_register.space_id);
 		goto err_out;
 	}
 
 	/* fill in data->powernow_table */
 	powernow_table = kmalloc((sizeof(struct cpufreq_frequency_table)
-		* (data->acpi_data->state_count + 1)), GFP_KERNEL);
+		* (data->acpi_data.state_count + 1)), GFP_KERNEL);
 	if (!powernow_table) {
 		dprintk("powernow_table memory alloc failure\n");
 		goto err_out;
@@ -806,12 +787,12 @@ static int powernow_k8_cpu_init_acpi(str
 	if (ret_val)
 		goto err_out_mem;
 
-	powernow_table[data->acpi_data->state_count].frequency = CPUFREQ_TABLE_END;
-	powernow_table[data->acpi_data->state_count].index = 0;
+	powernow_table[data->acpi_data.state_count].frequency = CPUFREQ_TABLE_END;
+	powernow_table[data->acpi_data.state_count].index = 0;
 	data->powernow_table = powernow_table;
 
 	/* fill in data */
-	data->numps = data->acpi_data->state_count;
+	data->numps = data->acpi_data.state_count;
 	if (first_cpu(per_cpu(cpu_core_map, data->cpu)) == data->cpu)
 		print_basics(data);
 	powernow_k8_acpi_pst_values(data, 0);
@@ -819,31 +800,16 @@ static int powernow_k8_cpu_init_acpi(str
 	/* notify BIOS that we exist */
 	acpi_processor_notify_smm(THIS_MODULE);
 
-	/* determine affinity, from ACPI if available */
-	if (preregister_valid) {
-		if ((data->acpi_data->shared_type == CPUFREQ_SHARED_TYPE_ALL) ||
-			(data->acpi_data->shared_type == CPUFREQ_SHARED_TYPE_ANY))
-			data->starting_core_affinity = data->acpi_data->shared_cpu_map;
-		else
-			data->starting_core_affinity = cpumask_of_cpu(data->cpu);
-	} else {
-	/* best guess from family if not */
-		if (cpu_family == CPU_HW_PSTATE)
-			data->starting_core_affinity = cpumask_of_cpu(data->cpu);
-		else
-			data->starting_core_affinity = per_cpu(cpu_core_map, data->cpu);
-	}
-
 	return 0;
 
 err_out_mem:
 	kfree(powernow_table);
 
 err_out:
-	acpi_processor_unregister_performance(data->acpi_data, data->cpu);
+	acpi_processor_unregister_performance(&data->acpi_data, data->cpu);
 
 	/* data->acpi_data.state_count informs us at ->exit() whether ACPI was used */
-	data->acpi_data->state_count = 0;
+	data->acpi_data.state_count = 0;
 
 	return -ENODEV;
 }
@@ -855,10 +821,10 @@ static int fill_powernow_table_pstate(st
 	rdmsr(MSR_PSTATE_CUR_LIMIT, hi, lo);
 	data->max_hw_pstate = (hi & HW_PSTATE_MAX_MASK) >> HW_PSTATE_MAX_SHIFT;
 
-	for (i = 0; i < data->acpi_data->state_count; i++) {
+	for (i = 0; i < data->acpi_data.state_count; i++) {
 		u32 index;
 
-		index = data->acpi_data->states[i].control & HW_PSTATE_MASK;
+		index = data->acpi_data.states[i].control & HW_PSTATE_MASK;
 		if (index > data->max_hw_pstate) {
 			printk(KERN_ERR PFX "invalid pstate %d - bad value %d.\n", i, index);
 			printk(KERN_ERR PFX "Please report to BIOS manufacturer\n");
@@ -874,7 +840,7 @@ static int fill_powernow_table_pstate(st
 
 		powernow_table[i].index = index;
 
-		powernow_table[i].frequency = data->acpi_data->states[i].core_frequency * 1000;
+		powernow_table[i].frequency = data->acpi_data.states[i].core_frequency * 1000;
 	}
 	return 0;
 }
@@ -883,16 +849,16 @@ static int fill_powernow_table_fidvid(st
 {
 	int i;
 	int cntlofreq = 0;
-	for (i = 0; i < data->acpi_data->state_count; i++) {
+	for (i = 0; i < data->acpi_data.state_count; i++) {
 		u32 fid;
 		u32 vid;
 
 		if (data->exttype) {
-			fid = data->acpi_data->states[i].status & EXT_FID_MASK;
-			vid = (data->acpi_data->states[i].status >> VID_SHIFT) & EXT_VID_MASK;
+			fid = data->acpi_data.states[i].status & EXT_FID_MASK;
+			vid = (data->acpi_data.states[i].status >> VID_SHIFT) & EXT_VID_MASK;
 		} else {
-			fid = data->acpi_data->states[i].control & FID_MASK;
-			vid = (data->acpi_data->states[i].control >> VID_SHIFT) & VID_MASK;
+			fid = data->acpi_data.states[i].control & FID_MASK;
+			vid = (data->acpi_data.states[i].control >> VID_SHIFT) & VID_MASK;
 		}
 
 		dprintk("   %d : fid 0x%x, vid 0x%x\n", i, fid, vid);
@@ -933,10 +899,10 @@ static int fill_powernow_table_fidvid(st
 				cntlofreq = i;
 		}
 
-		if (powernow_table[i].frequency != (data->acpi_data->states[i].core_frequency * 1000)) {
+		if (powernow_table[i].frequency != (data->acpi_data.states[i].core_frequency * 1000)) {
 			printk(KERN_INFO PFX "invalid freq entries %u kHz vs. %u kHz\n",
 				powernow_table[i].frequency,
-				(unsigned int) (data->acpi_data->states[i].core_frequency * 1000));
+				(unsigned int) (data->acpi_data.states[i].core_frequency * 1000));
 			powernow_table[i].frequency = CPUFREQ_ENTRY_INVALID;
 			continue;
 		}
@@ -946,12 +912,11 @@ static int fill_powernow_table_fidvid(st
 
 static void powernow_k8_cpu_exit_acpi(struct powernow_k8_data *data)
 {
-	if (data->acpi_data->state_count)
-		acpi_processor_unregister_performance(data->acpi_data, data->cpu);
+	if (data->acpi_data.state_count)
+		acpi_processor_unregister_performance(&data->acpi_data, data->cpu);
 }
 
 #else
-static int powernow_k8_cpu_preinit_acpi(void) { return -ENODEV; }
 static int powernow_k8_cpu_init_acpi(struct powernow_k8_data *data) { return -ENODEV; }
 static void powernow_k8_cpu_exit_acpi(struct powernow_k8_data *data) { return; }
 static void powernow_k8_acpi_pst_values(struct powernow_k8_data *data, unsigned int index) { return; }
@@ -1136,7 +1101,7 @@ static int powernowk8_verify(struct cpuf
 static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 {
 	struct powernow_k8_data *data;
-	cpumask_t oldmask = CPU_MASK_ALL;
+	cpumask_t oldmask;
 	int rc;
 
 	if (!cpu_online(pol->cpu))
@@ -1209,7 +1174,10 @@ static int __cpuinit powernowk8_cpu_init
 	/* run on any CPU again */
 	set_cpus_allowed_ptr(current, &oldmask);
 
-	pol->cpus = data->starting_core_affinity;
+	if (cpu_family == CPU_HW_PSTATE)
+		pol->cpus = cpumask_of_cpu(pol->cpu);
+	else
+		pol->cpus = per_cpu(cpu_core_map, pol->cpu);
 	data->available_cores = &(pol->cpus);
 
 	/* Take a crude guess here.
@@ -1332,7 +1300,6 @@ static int __cpuinit powernowk8_init(voi
 	}
 
 	if (supported_cpus == num_online_cpus()) {
-		powernow_k8_cpu_preinit_acpi();
 		printk(KERN_INFO PFX "Found %d %s "
 			"processors (%d cpu cores) (" VERSION ")\n",
 			num_online_nodes(),
@@ -1349,10 +1316,6 @@ static void __exit powernowk8_exit(void)
 	dprintk("exit\n");
 
 	cpufreq_unregister_driver(&cpufreq_amd64_driver);
-
-#ifdef CONFIG_X86_POWERNOW_K8_ACPI
-	free_percpu(acpi_perf_data);
-#endif
 }
 
 MODULE_AUTHOR("Paul Devriendt <paul.devriendt@amd.com> and Mark Langsdorf <mark.langsdorf@amd.com>");
Index: linux-2.6/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
+++ linux-2.6/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
@@ -33,13 +33,12 @@ struct powernow_k8_data {
 #ifdef CONFIG_X86_POWERNOW_K8_ACPI
 	/* the acpi table needs to be kept. it's only available if ACPI was
 	 * used to determine valid frequency/vid/fid states */
-	struct acpi_processor_performance *acpi_data;
+	struct acpi_processor_performance acpi_data;
 #endif
 	/* we need to keep track of associated cores, but let cpufreq
 	 * handle hotplug events - so just point at cpufreq pol->cpus
 	 * structure */
 	cpumask_t *available_cores;
-	cpumask_t starting_core_affinity;
 };
 
 
