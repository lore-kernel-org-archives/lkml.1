Return-Path: <linux-kernel-owner+w=401wt.eu-S932938AbZHDQAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938AbZHDQAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 12:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932824AbZHDQAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 12:00:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:51647 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932707AbZHDQAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 12:00:51 -0400
Message-ID: <4A785AFF.3050902@kernel.org>
Date: Tue, 04 Aug 2009 08:59:59 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: use online_mask for x2apic target_cpus
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


found one system with x2apic report:
[  302.859446] igbvf 0000:81:10.4: enabling device (0000 -> 0002)
[  302.874369] igbvf 0000:81:10.4: using 64bit DMA mask
[  302.879023] igbvf 0000:81:10.4: using 64bit consistent DMA mask
[  302.894386] igbvf 0000:81:10.4: enabling bus mastering
[  302.898171] igbvf 0000:81:10.4: setting latency timer to 64
[  302.914050] reserve_memtype added 0xefb08000-0xefb0c000, track uncached-minus, req uncached-minus, ret uncached-minus
[  302.933839] reserve_memtype added 0xefb28000-0xefb29000, track uncached-minus, req uncached-minus, ret uncached-minus
[  302.940367]   alloc irq_desc for 265 on node 4
[  302.956874]   alloc kstat_irqs on node 4
[  302.959452] alloc irq_2_iommu on node 0
[  302.974328] igbvf 0000:81:10.4: irq 265 for MSI/MSI-X
[  302.977778]   alloc irq_desc for 266 on node 4
[  302.980347]   alloc kstat_irqs on node 4
[  302.995312] free_memtype request 0xefb28000-0xefb29000
[  302.998816] igbvf 0000:81:10.4: Failed to initialize MSI-X interrupts.

it turns out that when trying to enable msi-x.
__assign_irq_vector(new, cfg_new, apic->target_cpus()) can not get vector
because for x2apic target-cpus return cpumask_of(0)

update that to online_mask like xapic.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/apic/x2apic_cluster.c |    8 +++++---
 arch/x86/kernel/apic/x2apic_phys.c    |    8 +++++---
 2 files changed, 10 insertions(+), 6 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/x2apic_cluster.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/x2apic_cluster.c
+++ linux-2.6/arch/x86/kernel/apic/x2apic_cluster.c
@@ -17,11 +17,13 @@ static int x2apic_acpi_madt_oem_check(ch
 	return x2apic_enabled();
 }
 
-/* Start with all IRQs pointing to boot CPU.  IRQ balancing will shift them. */
-
+/*
+ * need to use more than cpu 0, because we need more vectors when
+ * MSI-X are used.
+ */
 static const struct cpumask *x2apic_target_cpus(void)
 {
-	return cpumask_of(0);
+	return cpu_online_mask;
 }
 
 /*
Index: linux-2.6/arch/x86/kernel/apic/x2apic_phys.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/x2apic_phys.c
+++ linux-2.6/arch/x86/kernel/apic/x2apic_phys.c
@@ -27,11 +27,13 @@ static int x2apic_acpi_madt_oem_check(ch
 		return 0;
 }
 
-/* Start with all IRQs pointing to boot CPU.  IRQ balancing will shift them. */
-
+/*
+ * need to use more than cpu 0, because we need more vectors when
+ * MSI-X are used.
+ */
 static const struct cpumask *x2apic_target_cpus(void)
 {
-	return cpumask_of(0);
+	return cpu_online_mask;
 }
 
 static void x2apic_vector_allocation_domain(int cpu, struct cpumask *retmask)
