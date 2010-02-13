Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320Ab0BMBn0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 20:43:26 -0500
Received: from mga01.intel.com ([192.55.52.88]:22628 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754358Ab0BMBkU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 20:40:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,464,1262592000"; 
   d="scan'208,223";a="540400362"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       "Du, Alek" <alek.du@intel.com>, "Tang, Feng" <feng.tang@intel.com>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Date: Fri, 12 Feb 2010 17:40:19 -0800
Subject: [PATCH 5/9] x86/ioapic: improve handling of i8259a irq init
Thread-Topic: [PATCH 5/9] x86/ioapic: improve handling of i8259a irq init
Thread-Index: AcqsTX/3LYTpCEA1RgChmsC16Mh87Q==
Message-ID: <43F901BD926A4E43B106BF17856F07559FB80D01@orsmsx508.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ab3ae105e88342a26e4a1d46d6dcdff2fb7970fe Mon Sep 17 00:00:00 2001
From: Alek Du <alek.du@intel.com>
Date: Mon, 7 Sep 2009 16:25:45 +0800
Subject: [PATCH 5/9] x86/ioapic: improve handling of i8259a irq init

Since we already track the number of legacy vectors by nr_legacy_irqs, we
can avoid use static vector allocations -- we can use dynamic one.

Signed-off-by: Alek Du <alek.du@intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
---
 arch/x86/kernel/apic/io_apic.c |   23 ++++-------------------
 1 files changed, 4 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 53243ca..75265ab 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -140,27 +140,10 @@ static struct irq_pin_list *get_one_free_irq_2_pin(int node)
 
 /* irq_cfg is indexed by the sum of all RTEs in all I/O APICs. */
 #ifdef CONFIG_SPARSE_IRQ
-static struct irq_cfg irq_cfgx[] = {
+static struct irq_cfg irq_cfgx[NR_IRQS_LEGACY];
 #else
-static struct irq_cfg irq_cfgx[NR_IRQS] = {
+static struct irq_cfg irq_cfgx[NR_IRQS];
 #endif
-	[0]  = { .vector = IRQ0_VECTOR,  },
-	[1]  = { .vector = IRQ1_VECTOR,  },
-	[2]  = { .vector = IRQ2_VECTOR,  },
-	[3]  = { .vector = IRQ3_VECTOR,  },
-	[4]  = { .vector = IRQ4_VECTOR,  },
-	[5]  = { .vector = IRQ5_VECTOR,  },
-	[6]  = { .vector = IRQ6_VECTOR,  },
-	[7]  = { .vector = IRQ7_VECTOR,  },
-	[8]  = { .vector = IRQ8_VECTOR,  },
-	[9]  = { .vector = IRQ9_VECTOR,  },
-	[10] = { .vector = IRQ10_VECTOR, },
-	[11] = { .vector = IRQ11_VECTOR, },
-	[12] = { .vector = IRQ12_VECTOR, },
-	[13] = { .vector = IRQ13_VECTOR, },
-	[14] = { .vector = IRQ14_VECTOR, },
-	[15] = { .vector = IRQ15_VECTOR, },
-};
 
 void __init io_apic_disable_legacy(void)
 {
@@ -181,6 +164,8 @@ int __init arch_early_irq_init(void)
 	node= cpu_to_node(boot_cpu_id);
 
 	for (i = 0; i < count; i++) {
+		if (i < nr_legacy_irqs)
+			cfg[i].vector = IRQ0_VECTOR + i;
 		desc = irq_to_desc(i);
 		desc->chip_data = &cfg[i];
 		zalloc_cpumask_var_node(&cfg[i].domain, GFP_NOWAIT, node);
-- 
1.6.5.3

