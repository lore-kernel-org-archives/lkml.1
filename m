Return-Path: <linux-kernel-owner+w=401wt.eu-S1754586Ab0A2Tr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab0A2Tr2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 14:47:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754275Ab0A2TrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 14:47:18 -0500
Received: from mga14.intel.com ([143.182.124.37]:19478 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754192Ab0A2TrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 14:47:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="238373701"
Message-Id: <20100129194330.283696385@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Fri, 29 Jan 2010 11:42:21 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yinghai@kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, lizf@cn.fujitsu.com
Subject: [patch 2/2] x86, irq: move __setup_vector_irq() before the first irq enable in cpu online path
References: <20100129194330.207790269@sbs-t61.sc.intel.com>
Content-Disposition: inline; filename=move_setup_vector_irq_before_first_enable_irq_during_cpu_online.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lowest priority delivery of logical flat mode is broken on some systems,
such that even when IO-APIC RTE says deliver the interrupt to a particular CPU,
interrupt subsystem delivers the interrupt to totally different CPU.

For example, this behavior was observed on a P4 based system with SiS chipset
which was reported by Li Zefan. We have been handling this kind of behavior by
making sure that in logical flat mode, we assign the same vector to irq
mappings on all the 8 possible logical cpu's.

But we have been doing this initial assignment (__setup_vector_irq()) a little
late (before which interrupts were already enabled for a short duration).

Move the __setup_vector_irq() before the first irq enable point in the
cpu online path to avoid the issue of not handling some interrupts that
wrongly hit the cpu which is still coming online.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Tested-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
---

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 0cc7022..f99104c 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1256,11 +1256,16 @@ static void __clear_irq_vector(int irq, struct irq_cfg *cfg)
 void __setup_vector_irq(int cpu)
 {
 	/* Initialize vector_irq on a new cpu */
-	/* This function must be called with vector_lock held */
 	int irq, vector;
 	struct irq_cfg *cfg;
 	struct irq_desc *desc;
 
+	/*
+ 	 * vector_lock will make sure that we don't run into irq vector
+ 	 * assignments that might be happening on another cpu in parallel,
+ 	 * while we setup our initial vector to irq mappings.
+ 	 */
+	spin_lock(&vector_lock);
 	/* Mark the inuse vectors */
 	for_each_irq_desc(irq, desc) {
 		cfg = desc->chip_data;
@@ -1279,6 +1284,7 @@ void __setup_vector_irq(int cpu)
 		if (!cpumask_test_cpu(cpu, cfg->domain))
 			per_cpu(vector_irq, cpu)[vector] = -1;
 	}
+	spin_unlock(&vector_lock);
 }
 
 static struct irq_chip ioapic_chip;
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 678d0b8..d685049 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -241,6 +241,11 @@ static void __cpuinit smp_callin(void)
 	map_cpu_to_logical_apicid();
 
 	notify_cpu_starting(cpuid);
+
+	/*
+ 	 * Need to setup vector mappings before we enable interrupts.
+ 	 */
+	__setup_vector_irq(smp_processor_id());
 	/*
 	 * Get our bogomips.
 	 *
@@ -315,7 +320,6 @@ notrace static void __cpuinit start_secondary(void *unused)
 	 */
 	ipi_call_lock();
 	lock_vector_lock();
-	__setup_vector_irq(smp_processor_id());
 	set_cpu_online(smp_processor_id(), true);
 	unlock_vector_lock();
 	ipi_call_unlock();


