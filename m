Return-Path: <linux-kernel-owner+w=401wt.eu-S1756179AbZFENnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179AbZFENnF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 09:43:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755982AbZFENmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 09:42:21 -0400
Received: from ozlabs.org ([203.10.76.45]:33593 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755984AbZFENmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 09:42:18 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] cpumask: alloc blank cpumask left over
Date: Fri, 5 Jun 2009 23:11:57 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <4A2835D8.6040903@kernel.org> <200906051428.08299.rusty@rustcorp.com.au> <4A28B3A9.3010505@kernel.org>
In-Reply-To: <4A28B3A9.3010505@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906052311.57762.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Jun 2009 03:26:57 pm Yinghai Lu wrote:
> Rusty Russell wrote:
> > On Fri, 5 Jun 2009 06:31:31 am Yinghai Lu wrote:
> >> avoid suprise when MAXSMP is enabled
> >>
> >> Signed-off-by: Yinghai Lu <yinghai.lu@kernel.org>
> >
> > I understand the temptation, but two questions arise:
> > 1) Shouldn't we actually audit to see if any of these are currently
> > problems,
>
> those are defined as static cpumask_var_t, and if MAXSMP is not used, they
> are cleared already

OK, here's what I've got in my tree.  Ingo, I think this should go in the
current -rc to avoid nasty bugs.

BTW, the original alloc_cpumask_var did zero; that was dropped after arguments
over efficiency and fitting with other interfaces, but I clearly had the old
semantics in my head for a while.

Thanks,
Rusty.

Subject: cpumask: alloc zeroed cpumask for static cpumask_var_ts
Date: Thu, 04 Jun 2009 14:01:31 -0700
From: Yinghai Lu <yinghai@kernel.org>

These are defined as static cpumask_var_t so if MAXSMP is not used,
they are cleared already.  Avoid suprises when MAXSMP is enabled.

Signed-off-by: Yinghai Lu <yinghai.lu@kernel.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c       |    2 +-
 arch/x86/kernel/cpu/cpufreq/powernow-k7.c        |    2 +-
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c        |    3 ++-
 arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c |    3 ++-
 arch/x86/kernel/cpu/mcheck/mce_64.c              |    2 +-
 arch/x86/kernel/tlb_uv.c                         |    3 ++-
 drivers/acpi/processor_core.c                    |    3 ++-
 drivers/cpufreq/cpufreq.c                        |    3 ++-
 kernel/sched_cpupri.c                            |    2 +-
 kernel/sched_rt.c                                |    3 ++-
 kernel/smp.c                                     |    5 +++--
 11 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -552,7 +552,7 @@ static int __init acpi_cpufreq_early_ini
 	for_each_possible_cpu(i) {
 		if (!alloc_cpumask_var_node(
 			&per_cpu_ptr(acpi_perf_data, i)->shared_cpu_map,
-			GFP_KERNEL, cpu_to_node(i))) {
+			GFP_KERNEL | __GFP_ZERO, cpu_to_node(i))) {
 
 			/* Freeing a NULL pointer is OK: alloc_percpu zeroes. */
 			free_acpi_perf_data();
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k7.c b/arch/x86/kernel/cpu/cpufreq/powernow-k7.c
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k7.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k7.c
@@ -323,7 +323,7 @@ static int powernow_acpi_init(void)
 	}
 
 	if (!alloc_cpumask_var(&acpi_processor_perf->shared_cpu_map,
-								GFP_KERNEL)) {
+			       GFP_KERNEL | __GFP_ZERO)) {
 		retval = -ENOMEM;
 		goto err05;
 	}
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -886,7 +886,8 @@ static int powernow_k8_cpu_init_acpi(str
 	/* notify BIOS that we exist */
 	acpi_processor_notify_smm(THIS_MODULE);
 
-	if (!alloc_cpumask_var(&data->acpi_data.shared_cpu_map, GFP_KERNEL)) {
+	if (!alloc_cpumask_var(&data->acpi_data.shared_cpu_map,
+			       GFP_KERNEL | __GFP_ZERO)) {
 		printk(KERN_ERR PFX
 				"unable to alloc powernow_k8_data cpumask\n");
 		ret_val = -ENOMEM;
diff --git a/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c b/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
+++ b/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
@@ -471,7 +471,8 @@ static int centrino_target (struct cpufr
 
 	if (unlikely(!alloc_cpumask_var(&saved_mask, GFP_KERNEL)))
 		return -ENOMEM;
-	if (unlikely(!alloc_cpumask_var(&covered_cpus, GFP_KERNEL))) {
+	if (unlikely(!alloc_cpumask_var(&covered_cpus,
+					 GFP_KERNEL | __GFP_ZERO))) {
 		free_cpumask_var(saved_mask);
 		return -ENOMEM;
 	}
diff --git a/arch/x86/kernel/cpu/mcheck/mce_64.c b/arch/x86/kernel/cpu/mcheck/mce_64.c
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -1163,7 +1163,7 @@ static __init int mce_init_device(void)
 	if (!mce_available(&boot_cpu_data))
 		return -EIO;
 
-	alloc_cpumask_var(&mce_device_initialized, GFP_KERNEL);
+	alloc_cpumask_var(&mce_device_initialized, GFP_KERNEL | __GFP_ZERO);
 
 	err = mce_init_banks();
 	if (err)
diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -833,7 +833,8 @@ static int __init uv_bau_init(void)
 
 	for_each_possible_cpu(cur_cpu)
 		alloc_cpumask_var_node(&per_cpu(uv_flush_tlb_mask, cur_cpu),
-				       GFP_KERNEL, cpu_to_node(cur_cpu));
+				       GFP_KERNEL | __GFP_ZERO,
+				       cpu_to_node(cur_cpu));
 
 	uv_bau_retry_limit = 1;
 	uv_nshift = uv_hub_info->n_val;
diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -844,7 +844,8 @@ static int acpi_processor_add(struct acp
 	if (!pr)
 		return -ENOMEM;
 
-	if (!alloc_cpumask_var(&pr->throttling.shared_cpu_map, GFP_KERNEL)) {
+	if (!alloc_cpumask_var(&pr->throttling.shared_cpu_map,
+			       GFP_KERNEL | __GFP_ZERO)) {
 		kfree(pr);
 		return -ENOMEM;
 	}
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -808,7 +808,8 @@ static int cpufreq_add_dev(struct sys_de
 		ret = -ENOMEM;
 		goto nomem_out;
 	}
-	if (!alloc_cpumask_var(&policy->related_cpus, GFP_KERNEL)) {
+	if (!alloc_cpumask_var(&policy->related_cpus,
+			       GFP_KERNEL | __GFP_ZERO)) {
 		free_cpumask_var(policy->cpus);
 		kfree(policy);
 		ret = -ENOMEM;
diff --git a/kernel/sched_cpupri.c b/kernel/sched_cpupri.c
--- a/kernel/sched_cpupri.c
+++ b/kernel/sched_cpupri.c
@@ -165,7 +165,7 @@ int __init_refok cpupri_init(struct cpup
 		vec->count = 0;
 		if (bootmem)
 			alloc_bootmem_cpumask_var(&vec->mask);
-		else if (!alloc_cpumask_var(&vec->mask, GFP_KERNEL))
+		else if (!alloc_cpumask_var(&vec->mask, GFP_KERNEL | __GFP_ZERO))
 			goto cleanup;
 	}
 
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1592,7 +1592,8 @@ static inline void init_sched_rt_class(v
 
 	for_each_possible_cpu(i)
 		alloc_cpumask_var_node(&per_cpu(local_cpu_mask, i),
-					GFP_KERNEL, cpu_to_node(i));
+					GFP_KERNEL | __GFP_ZERO,
+					cpu_to_node(i));
 }
 #endif /* CONFIG_SMP */
 
diff --git a/kernel/smp.c b/kernel/smp.c
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -52,8 +52,9 @@ hotplug_cfd(struct notifier_block *nfb, 
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
-		if (!alloc_cpumask_var_node(&cfd->cpumask, GFP_KERNEL,
-				cpu_to_node(cpu)))
+		if (!alloc_cpumask_var_node(&cfd->cpumask,
+					    GFP_KERNEL | __GFP_ZERO,
+					    cpu_to_node(cpu)))
 			return NOTIFY_BAD;
 		break;
 

