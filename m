Return-Path: <linux-kernel-owner+w=401wt.eu-S1758020AbXK2ILV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020AbXK2ILV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 03:11:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbXK2ILJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 03:11:09 -0500
Received: from mga11.intel.com ([192.55.52.93]:2457 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722AbXK2ILH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 03:11:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,228,1194249600"; 
   d="scan'208";a="407445758"
Subject: RE: ACPI related Warning in 2.6.24-rc3-git2
From: Zhao Yakui <yakui.zhao@intel.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Lukas Hejtmanek <xhejtman@ics.muni.cz>,
       "Li, Shaohua" <shaohua.li@intel.com>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEE2B3AD7@orsmsx423.amr.corp.intel.com>
References: <20071127150557.GA4365@ics.muni.cz>
	 <200711271637.13036.rjw@sisk.pl>
	 <924EFEDD5F540B4284297C4DC59F3DEE2B3AD7@orsmsx423.amr.corp.intel.com>
Content-Type: text/plain
Date: Thu, 29 Nov 2007 16:22:43 +0800
Message-Id: <1196324563.4062.15.camel@yakui_zhao.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: ACPI : Delete the IRQ operation in throttling controll via PTC
>From : Zhao Yakui <yakui.zhao@intel.com>

The IRQ operation(enable/disable) should be avoided when throttling is
controlled via PTC method. It is replaced by the migration of task. 

Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>

---
 drivers/acpi/processor_throttling.c |   36
++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

Index: linux-2.6.24-rc3-git3/drivers/acpi/processor_throttling.c
===================================================================
--- linux-2.6.24-rc3-git3.orig/drivers/acpi/processor_throttling.c
+++ linux-2.6.24-rc3-git3/drivers/acpi/processor_throttling.c
@@ -29,6 +29,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/sched.h>
 #include <linux/cpufreq.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
@@ -413,7 +414,7 @@ static int acpi_throttling_rdmsr(struct 
 	} else {
 		msr_low = 0;
 		msr_high = 0;
-		rdmsr_on_cpu(cpu, MSR_IA32_THERM_CONTROL,
+		rdmsr_safe(MSR_IA32_THERM_CONTROL,
 			(u32 *)&msr_low , (u32 *) &msr_high);
 		msr = (msr_high << 32) | msr_low;
 		*value = (acpi_integer) msr;
@@ -438,7 +439,7 @@ static int acpi_throttling_wrmsr(struct 
 			"HARDWARE addr space,NOT supported yet\n");
 	} else {
 		msr = value;
-		wrmsr_on_cpu(cpu, MSR_IA32_THERM_CONTROL,
+		wrmsr_safe(MSR_IA32_THERM_CONTROL,
 			msr & 0xffffffff, msr >> 32);
 		ret = 0;
 	}
@@ -572,21 +573,32 @@ static int acpi_processor_get_throttling
 		return -ENODEV;
 
 	pr->throttling.state = 0;
-	local_irq_disable();
+
 	value = 0;
 	ret = acpi_read_throttling_status(pr, &value);
 	if (ret >= 0) {
 		state = acpi_get_throttling_state(pr, value);
 		pr->throttling.state = state;
 	}
-	local_irq_enable();
 
 	return 0;
 }
 
 static int acpi_processor_get_throttling(struct acpi_processor *pr)
 {
-	return pr->throttling.acpi_processor_get_throttling(pr);
+	cpumask_t saved_mask;
+	int ret;
+
+	/*
+	 * Migrate task to the cpu pointed by pr.
+	 */
+	saved_mask = current->cpus_allowed;
+	set_cpus_allowed(current, cpumask_of_cpu(pr->id));
+	ret = pr->throttling.acpi_processor_get_throttling(pr);
+	/* restore the previous state */
+	set_cpus_allowed(current, saved_mask);
+
+	return ret;
 }
 
 static int acpi_processor_get_fadt_info(struct acpi_processor *pr)
@@ -717,21 +729,29 @@ static int acpi_processor_set_throttling
 	if (state < pr->throttling_platform_limit)
 		return -EPERM;
 
-	local_irq_disable();
 	value = 0;
 	ret = acpi_get_throttling_value(pr, state, &value);
 	if (ret >= 0) {
 		acpi_write_throttling_state(pr, value);
 		pr->throttling.state = state;
 	}
-	local_irq_enable();
 
 	return 0;
 }
 
 int acpi_processor_set_throttling(struct acpi_processor *pr, int state)
 {
-	return pr->throttling.acpi_processor_set_throttling(pr, state);
+	cpumask_t saved_mask;
+	int ret;
+	/*
+	 * Migrate task to the cpu pointed by pr.
+	 */
+	saved_mask = current->cpus_allowed;
+	set_cpus_allowed(current, cpumask_of_cpu(pr->id));
+	ret = pr->throttling.acpi_processor_set_throttling(pr, state);
+	/* restore the previous state */
+	set_cpus_allowed(current, saved_mask);
+	return ret;
 }
 
 int acpi_processor_get_throttling_info(struct acpi_processor *pr)

On Wed, 2007-11-28 at 14:42 +0800, Pallipadi, Venkatesh wrote:
> Yakui,
> 
> Can you look at this. Seems to be coming from commit f79f06ab9f86
> FixedHW support tries to read MSR with interrupts disabled.
> 
> Thanks,
> Venki 
> 
> >-----Original Message-----
> >From: linux-kernel-owner@vger.kernel.org 
> >[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of 
> >Rafael J. Wysocki
> >Sent: Tuesday, November 27, 2007 7:37 AM
> >To: Lukas Hejtmanek
> >Cc: linux-kernel@vger.kernel.org; ACPI Devel Maling List; Len 
> >Brown; Alexey Starikovskiy
> >Subject: Re: ACPI related Warning in 2.6.24-rc3-git2
> >
> >On Tuesday, 27 of November 2007, Lukas Hejtmanek wrote:
> >> Hello,
> >> 
> >> in recent kernel, I got the following warnings while 
> >booting. It's ACPI
> >> related. Does anybode care? Lenovo ThinkPad T61 (6465CTO).
> >
> >Appropriate Ccs added.
> >
> >Did it happen before?
> >
> >> [   13.114814] Pid: 1, comm: swapper Not tainted 2.6.24-rc3-git2 #3
> >> [   13.114885] 
> >> [   13.114885] Call Trace:
> >> [   13.115020]  [<ffffffff80357ab6>] 
> >acpi_ut_update_ref_count+0x50/0x9d
> >> [   13.115095]  [<ffffffff8021e7ad>] 
> >smp_call_function_single+0xbd/0xd0
> >> [   13.115169]  [<ffffffff80331dbc>] _rdmsr_on_cpu+0x5c/0x60
> >> [   13.115241]  [<ffffffff803631c7>]
> >> acpi_processor_get_throttling_ptc+0xf3/0x158
> >> [   13.115323]  [<ffffffff80362f04>]
> >> acpi_processor_get_throttling_info+0x460/0x4af
> >> [   13.115406]  [<ffffffff80362264>] acpi_processor_start+0x54a/0x606
> >> [   13.115478]  [<ffffffff802abc38>] ifind+0x48/0xd0
> >> [   13.115550]  [<ffffffff8035a31e>] 
> >acpi_start_single_object+0x24/0x46
> >> [   13.115622]  [<ffffffff8035b716>] acpi_device_probe+0x7d/0x91
> >> [   13.115694]  [<ffffffff8038effc>] driver_probe_device+0x9c/0x1b0
> >> [   13.115766]  [<ffffffff8038f2c9>] __driver_attach+0xc9/0xd0
> >> [   13.115840]  [<ffffffff8038f200>] __driver_attach+0x0/0xd0
> >> [   13.115924]  [<ffffffff8038e1dd>] bus_for_each_dev+0x4d/0x80
> >> [   13.115994]  [<ffffffff8038e64c>] bus_add_driver+0xac/0x220
> >> [   13.116080]  [<ffffffff8064dd7c>] acpi_processor_init+0x8f/0xfc
> >> [   13.116153]  [<ffffffff806386f4>] kernel_init+0x154/0x330
> >> [   13.116225]  [<ffffffff8020d178>] child_rip+0xa/0x12
> >> [   13.116295]  [<ffffffff806385a0>] kernel_init+0x0/0x330
> >> [   13.116365]  [<ffffffff8020d16e>] child_rip+0x0/0x12
> >> [   13.116435] 
> >> [   13.116504] WARNING: at arch/x86/kernel/smp_64.c:397
> >> smp_call_function_mask()
> >> [   13.116577] Pid: 1, comm: swapper Not tainted 2.6.24-rc3-git2 #3
> >> [   13.116648] 
> >> [   13.116648] Call Trace:
> >> [   13.116779]  [<ffffffff80357ab6>] 
> >acpi_ut_update_ref_count+0x50/0x9d
> >> [   13.116851]  [<ffffffff8021e4af>] smp_call_function_mask+0x8f/0xa0
> >> [   13.116923]  [<ffffffff80331dbc>] _rdmsr_on_cpu+0x5c/0x60
> >> [   13.116994]  [<ffffffff803631c7>]
> >> acpi_processor_get_throttling_ptc+0xf3/0x158
> >> [   13.117077]  [<ffffffff80362f04>]
> >> acpi_processor_get_throttling_info+0x460/0x4af
> >> [   13.117169]  [<ffffffff80362264>] acpi_processor_start+0x54a/0x606
> >> [   13.117248]  [<ffffffff802abc38>] ifind+0x48/0xd0
> >> [   13.117330]  [<ffffffff8035a31e>] 
> >acpi_start_single_object+0x24/0x46
> >> [   13.117402]  [<ffffffff8035b716>] acpi_device_probe+0x7d/0x91
> >> [   13.117488]  [<ffffffff8038effc>] driver_probe_device+0x9c/0x1b0
> >> [   13.117559]  [<ffffffff8038f2c9>] __driver_attach+0xc9/0xd0
> >> [   13.117631]  [<ffffffff8038f200>] __driver_attach+0x0/0xd0
> >> [   13.117715]  [<ffffffff8038e1dd>] bus_for_each_dev+0x4d/0x80
> >> [   13.117786]  [<ffffffff8038e64c>] bus_add_driver+0xac/0x220
> >> [   13.117856]  [<ffffffff8064dd7c>] acpi_processor_init+0x8f/0xfc
> >> [   13.117941]  [<ffffffff806386f4>] kernel_init+0x154/0x330
> >> [   13.118018]  [<ffffffff8020d178>] child_rip+0xa/0x12
> >> [   13.118088]  [<ffffffff806385a0>] kernel_init+0x0/0x330
> >> [   13.118158]  [<ffffffff8020d16e>] child_rip+0x0/0x12
> >> [   13.118227] 
> >> [...]
> >> [   13.124714] WARNING: at arch/x86/kernel/smp_64.c:427
> >> smp_call_function_single()
> >> [   13.124798] Pid: 1, comm: swapper Not tainted 2.6.24-rc3-git2 #3
> >> [   13.125460] 
> >> [   13.125461] Call Trace:
> >> [   13.125592]  [<ffffffff80357ab6>] 
> >acpi_ut_update_ref_count+0x50/0x9d
> >> [   13.125665]  [<ffffffff8021e7ad>] 
> >smp_call_function_single+0xbd/0xd0
> >> [   13.125737]  [<ffffffff80331dbc>] _rdmsr_on_cpu+0x5c/0x60
> >> [   13.125807]  [<ffffffff803631c7>]
> >> acpi_processor_get_throttling_ptc+0xf3/0x158
> >> [   13.125903]  [<ffffffff80362f04>]
> >> acpi_processor_get_throttling_info+0x460/0x4af
> >> [   13.125999]  [<ffffffff80362264>] acpi_processor_start+0x54a/0x606
> >> [   13.126071]  [<ffffffff803625ed>] acpi_processor_add+0x24/0x6b
> >> [   13.126142]  [<ffffffff8035a31e>] 
> >acpi_start_single_object+0x24/0x46
> >> [   13.126214]  [<ffffffff8035b716>] acpi_device_probe+0x7d/0x91
> >> [   13.126285]  [<ffffffff8038effc>] driver_probe_device+0x9c/0x1b0
> >> [   13.126357]  [<ffffffff8038f2c9>] __driver_attach+0xc9/0xd0
> >> [   13.126441]  [<ffffffff8038f200>] __driver_attach+0x0/0xd0
> >> [   13.126518]  [<ffffffff8038e1dd>] bus_for_each_dev+0x4d/0x80
> >> [   13.126600]  [<ffffffff8038e64c>] bus_add_driver+0xac/0x220
> >> [   13.126670]  [<ffffffff8064dd7c>] acpi_processor_init+0x8f/0xfc
> >> [   13.126755]  [<ffffffff806386f4>] kernel_init+0x154/0x330
> >> [   13.126832]  [<ffffffff8020d178>] child_rip+0xa/0x12
> >> [   13.126916]  [<ffffffff806385a0>] kernel_init+0x0/0x330
> >> [   13.126986]  [<ffffffff8020d16e>] child_rip+0x0/0x12
> >> [   13.127059] 
> >> [   13.127124] WARNING: at arch/x86/kernel/smp_64.c:397
> >> smp_call_function_mask()
> >> [   13.127197] Pid: 1, comm: swapper Not tainted 2.6.24-rc3-git2 #3
> >> [   13.127267] 
> >> [   13.127268] Call Trace:
> >> [   13.127398]  [<ffffffff80357ab6>] 
> >acpi_ut_update_ref_count+0x50/0x9d
> >> [   13.127473]  [<ffffffff8021e4af>] smp_call_function_mask+0x8f/0xa0
> >> [   13.127545]  [<ffffffff80331dbc>] _rdmsr_on_cpu+0x5c/0x60
> >> [   13.127616]  [<ffffffff803631c7>]
> >> acpi_processor_get_throttling_ptc+0xf3/0x158
> >> [   13.127699]  [<ffffffff80362f04>]
> >> acpi_processor_get_throttling_info+0x460/0x4af
> >> [   13.127782]  [<ffffffff80362264>] acpi_processor_start+0x54a/0x606
> >> [   13.127861]  [<ffffffff803625ed>] acpi_processor_add+0x24/0x6b
> >> [   13.127933]  [<ffffffff8035a31e>] 
> >acpi_start_single_object+0x24/0x46
> >> [   13.128005]  [<ffffffff8035b716>] acpi_device_probe+0x7d/0x91
> >> [   13.128076]  [<ffffffff8038effc>] driver_probe_device+0x9c/0x1b0
> >> [   13.128147]  [<ffffffff8038f2c9>] __driver_attach+0xc9/0xd0
> >> [   13.128226]  [<ffffffff8038f200>] __driver_attach+0x0/0xd0
> >> [   13.128310]  [<ffffffff8038e1dd>] bus_for_each_dev+0x4d/0x80
> >> [   13.128381]  [<ffffffff8038e64c>] bus_add_driver+0xac/0x220
> >> [   13.128452]  [<ffffffff8064dd7c>] acpi_processor_init+0x8f/0xfc
> >> [   13.128523]  [<ffffffff806386f4>] kernel_init+0x154/0x330
> >> [   13.128594]  [<ffffffff8020d178>] child_rip+0xa/0x12
> >> [   13.128664]  [<ffffffff806385a0>] kernel_init+0x0/0x330
> >> [   13.128734]  [<ffffffff8020d16e>] child_rip+0x0/0x12
> >> 
> >> 
> >
> >
> >
> >-- 
> >"Premature optimization is the root of all evil." - Donald Knuth
> >-
> >To unsubscribe from this list: send the line "unsubscribe 
> >linux-kernel" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >Please read the FAQ at  http://www.tux.org/lkml/
> >
