Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017AbZFFVym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbZFFVym (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 17:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbZFFVyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 17:54:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:33867 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442AbZFFVye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 17:54:34 -0400
Message-ID: <4A2AE570.2010307@kernel.org>
Date: Sat, 06 Jun 2009 14:53:52 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/6] x86/cpufreq: use cpumask_copy instead of =
References: <4A2835D8.6040903@kernel.org> <200906051428.08299.rusty@rustcorp.com.au> <4A28B3A9.3010505@kernel.org> <200906052311.57762.rusty@rustcorp.com.au> <4A2A356B.6090102@redhat.com> <4A2A38B9.7030809@kernel.org> <4A2A3969.5030101@redhat.com> <4A2A4B80.1010605@kernel.org> <4A2AE4AC.60805@kernel.org>
In-Reply-To: <4A2AE4AC.60805@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


so later could use nr_cpumask_bits in cpumask_size when MAXSMP is used

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |   52 ++++++++++++++++++++----------
 1 file changed, 35 insertions(+), 17 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ linux-2.6/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -512,12 +512,15 @@ static int core_voltage_post_transition(
 
 static int check_supported_cpu(unsigned int cpu)
 {
-	cpumask_t oldmask;
+	cpumask_var_t oldmask;
 	u32 eax, ebx, ecx, edx;
 	unsigned int rc = 0;
 
-	oldmask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+	if (!alloc_cpumask_var(&oldmask, GFP_KERNEL))
+		return rc;
+
+	cpumask_copy(oldmask, &current->cpus_allowed);
+	set_cpus_allowed_ptr(current, cpumask_of(cpu));
 
 	if (smp_processor_id() != cpu) {
 		printk(KERN_ERR PFX "limiting to cpu %u failed\n", cpu);
@@ -565,7 +568,9 @@ static int check_supported_cpu(unsigned
 	rc = 1;
 
 out:
-	set_cpus_allowed_ptr(current, &oldmask);
+	set_cpus_allowed_ptr(current, oldmask);
+	free_cpumask_var(oldmask);
+
 	return rc;
 }
 
@@ -1144,7 +1149,7 @@ static int transition_frequency_pstate(s
 static int powernowk8_target(struct cpufreq_policy *pol,
 		unsigned targfreq, unsigned relation)
 {
-	cpumask_t oldmask;
+	cpumask_var_t oldmask;
 	struct powernow_k8_data *data = per_cpu(powernow_data, pol->cpu);
 	u32 checkfid;
 	u32 checkvid;
@@ -1154,12 +1159,15 @@ static int powernowk8_target(struct cpuf
 	if (!data)
 		return -EINVAL;
 
+	if (!alloc_cpumask_var(&oldmask, GFP_KERNEL))
+		return -EINVAL;
+
 	checkfid = data->currfid;
 	checkvid = data->currvid;
 
 	/* only run on specific CPU from here on */
-	oldmask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(pol->cpu));
+	cpumask_copy(oldmask, &current->cpus_allowed);
+	set_cpus_allowed_ptr(current, cpumask_of(pol->cpu));
 
 	if (smp_processor_id() != pol->cpu) {
 		printk(KERN_ERR PFX "limiting to cpu %u failed\n", pol->cpu);
@@ -1219,7 +1227,8 @@ static int powernowk8_target(struct cpuf
 	ret = 0;
 
 err_out:
-	set_cpus_allowed_ptr(current, &oldmask);
+	set_cpus_allowed_ptr(current, oldmask);
+	free_cpumask_var(oldmask);
 	return ret;
 }
 
@@ -1242,7 +1251,7 @@ static const char ACPI_PSS_BIOS_BUG_MSG[
 static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 {
 	struct powernow_k8_data *data;
-	cpumask_t oldmask;
+	cpumask_var_t oldmask;
 	int rc;
 
 	if (!cpu_online(pol->cpu))
@@ -1251,6 +1260,9 @@ static int __cpuinit powernowk8_cpu_init
 	if (!check_supported_cpu(pol->cpu))
 		return -ENODEV;
 
+	if (!alloc_cpumask_var(&oldmask, GFP_KERNEL))
+		return -ENOMEM;
+
 	data = kzalloc(sizeof(struct powernow_k8_data), GFP_KERNEL);
 	if (!data) {
 		printk(KERN_ERR PFX "unable to alloc powernow_k8_data");
@@ -1288,8 +1300,8 @@ static int __cpuinit powernowk8_cpu_init
 		pol->cpuinfo.transition_latency = get_transition_latency(data);
 
 	/* only run on specific CPU from here on */
-	oldmask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(pol->cpu));
+	cpumask_copy(oldmask, &current->cpus_allowed);
+	set_cpus_allowed_ptr(current, cpumask_of(pol->cpu));
 
 	if (smp_processor_id() != pol->cpu) {
 		printk(KERN_ERR PFX "limiting to cpu %u failed\n", pol->cpu);
@@ -1308,7 +1320,7 @@ static int __cpuinit powernowk8_cpu_init
 		fidvid_msr_init();
 
 	/* run on any CPU again */
-	set_cpus_allowed_ptr(current, &oldmask);
+	set_cpus_allowed_ptr(current, oldmask);
 
 	if (cpu_family == CPU_HW_PSTATE)
 		cpumask_copy(pol->cpus, cpumask_of(pol->cpu));
@@ -1346,7 +1358,8 @@ static int __cpuinit powernowk8_cpu_init
 	return 0;
 
 err_out_unmask:
-	set_cpus_allowed_ptr(current, &oldmask);
+	set_cpus_allowed_ptr(current, oldmask);
+	free_cpumask_var(oldmask);
 	powernow_k8_cpu_exit_acpi(data);
 
 err_out:
@@ -1374,7 +1387,7 @@ static int __devexit powernowk8_cpu_exit
 static unsigned int powernowk8_get(unsigned int cpu)
 {
 	struct powernow_k8_data *data;
-	cpumask_t oldmask = current->cpus_allowed;
+	cpumask_var_t oldmask;
 	unsigned int khz = 0;
 	unsigned int first;
 
@@ -1384,11 +1397,15 @@ static unsigned int powernowk8_get(unsig
 	if (!data)
 		return -EINVAL;
 
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+	if (!alloc_cpumask_var(&oldmask, GFP_KERNEL))
+		return -ENOMEM;
+
+	cpumask_copy(oldmask, &current->cpus_allowed);
+	set_cpus_allowed_ptr(current, cpumask_of(cpu));
 	if (smp_processor_id() != cpu) {
 		printk(KERN_ERR PFX
 			"limiting to CPU %d failed in powernowk8_get\n", cpu);
-		set_cpus_allowed_ptr(current, &oldmask);
+		set_cpus_allowed_ptr(current, oldmask);
 		return 0;
 	}
 
@@ -1403,7 +1420,8 @@ static unsigned int powernowk8_get(unsig
 
 
 out:
-	set_cpus_allowed_ptr(current, &oldmask);
+	set_cpus_allowed_ptr(current, oldmask);
+	free_cpumask_var(oldmask);
 	return khz;
 }
 
