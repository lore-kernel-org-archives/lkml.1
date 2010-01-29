Return-Path: <linux-kernel-owner+w=401wt.eu-S1754457Ab0A2TrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457Ab0A2TrS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 14:47:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754217Ab0A2TrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 14:47:17 -0500
Received: from mga14.intel.com ([143.182.124.37]:19478 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132Ab0A2TrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 14:47:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="238373700"
Message-Id: <20100129194330.207790269@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Fri, 29 Jan 2010 11:42:20 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yinghai@kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, lizf@cn.fujitsu.com
Subject: [patch 1/2] x86, irq: update the vector domain for legacy irqs handled by io-apic
Content-Disposition: inline; filename=update_legacyirq_cfg_domains_handled_by_ioapic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the recent change of not reserving IRQ0_VECTOR..IRQ15_VECTOR's on all
cpu's, we start with irq 0..15 getting directed to (and handled on) cpu-0.

In the logical flat mode, once the AP's are online (and before irqbalance
comes into picture), kernel intends to handle these IRQ's on any cpu (as the
logical flat mode allows to specify multiple cpu's for the irq destination and
the chipset based routing can deliver to the interrupt to any one of
the specified cpu's). This was broken with our recent change, which was ending
up using only cpu 0 as the destination, even when the kernel was specifying to
use all online cpu's for the logical flat mode case.

Fix this by updating vector allocation domain (cfg->domain) for legacy irqs,
when the IO-APIC handles them.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Tested-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
---

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 0cc7022..a18bab0 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1428,6 +1428,14 @@ static void setup_IO_APIC_irq(int apic_id, int pin, unsigned int irq, struct irq
 
 	cfg = desc->chip_data;
 
+	/*
+ 	 * For legacy irqs, cfg->domain starts with cpu 0 for legacy
+ 	 * controllers like 8259. Now that IO-APIC can handle this irq, update
+ 	 * the cfg->domain.
+ 	 */
+	if (irq < nr_legacy_irqs && cpumask_test_cpu(0, cfg->domain))
+		apic->vector_allocation_domain(0, cfg->domain);
+
 	if (assign_irq_vector(irq, cfg, apic->target_cpus()))
 		return;
 


