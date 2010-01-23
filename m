Return-Path: <linux-kernel-owner+w=401wt.eu-S1756436Ab0AWA0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436Ab0AWA0p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 19:26:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756426Ab0AWA0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 19:26:41 -0500
Received: from mga14.intel.com ([143.182.124.37]:22411 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754333Ab0AWA01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 19:26:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="235917452"
Subject: x86, irq: update the vector domain for legacy irqs handled by
 io-apic
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>
Cc: Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 22 Jan 2010 16:25:17 -0800
Message-Id: <1264206317.2874.9.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
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
 


