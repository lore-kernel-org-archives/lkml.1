Return-Path: <linux-kernel-owner+w=401wt.eu-S1758141AbZKTARJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141AbZKTARJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 19:17:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758103AbZKTARH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 19:17:07 -0500
Received: from mga03.intel.com ([143.182.124.21]:25704 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758101AbZKTARD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 19:17:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,773,1249282800"; 
   d="scan'208,223";a="213647438"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>
Date: Thu, 19 Nov 2009 16:17:06 -0800
Subject: [PATCH 3/3] x86/apic: remove io_apic_disable_legacy
Thread-Topic: [PATCH 3/3] x86/apic: remove io_apic_disable_legacy
Thread-Index: Acppdssux6ucV+arTXuQs5O4VfYqKA==
Message-ID: <43F901BD926A4E43B106BF17856F07558A00D910@orsmsx508.amr.corp.intel.com>
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

>From 8a484e0e5ac3f972e3ed842a9899a4dc1610253a Mon Sep 17 00:00:00 2001
From: Jacob Pan <jacob.jun.pan@intel.com>
Date: Thu, 19 Nov 2009 07:48:16 -0800
Subject: [PATCH] x86/apic: remove io_apic_disable_legacy

Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
---
 arch/x86/include/asm/io_apic.h |    2 --
 arch/x86/kernel/apic/io_apic.c |   13 ++++++-------
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 7c7c16c..84fdd51 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -143,8 +143,6 @@ extern int noioapicreroute;
 /* 1 if the timer IRQ uses the '8259A Virtual Wire' mode */
 extern int timer_through_8259;
 
-extern void io_apic_disable_legacy(void);
-
 /*
  * If we use the IO-APIC for IRQ routing, disable automatic
  * assignment of PCI IRQ's.
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 35aa616..6b417b1 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -97,7 +97,7 @@ struct mpc_intsrc mp_irqs[MAX_IRQ_SOURCES];
 int mp_irq_entries;
 
 /* GSI interrupts */
-static int nr_irqs_gsi = NR_IRQS_LEGACY;
+int nr_irqs_gsi = NR_IRQS_LEGACY;
 
 #if defined (CONFIG_MCA) || defined (CONFIG_EISA)
 int mp_bus_id_to_type[MAX_MP_BUSSES];
@@ -176,12 +176,6 @@ static struct irq_cfg irq_cfgx[NR_IRQS] = {
 	[15] = { .vector = IRQ15_VECTOR, },
 };
 
-void __init io_apic_disable_legacy(void)
-{
-	nr_legacy_irqs = 0;
-	nr_irqs_gsi = 0;
-}
-
 int __init arch_early_irq_init(void)
 {
 	struct irq_cfg *cfg;
@@ -190,6 +184,11 @@ int __init arch_early_irq_init(void)
 	int node;
 	int i;
 
+	if (!legacy_pic->nr_legacy_irqs) {
+		nr_irqs_gsi = 0;
+		io_apic_irqs = ~0UL;
+	}
+
 	cfg = irq_cfgx;
 	count = ARRAY_SIZE(irq_cfgx);
 	node= cpu_to_node(boot_cpu_id);
-- 
1.5.6.5

