Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab0BTBGp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 20:06:45 -0500
Received: from mga11.intel.com ([192.55.52.93]:4896 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417Ab0BTBGo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 20:06:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,506,1262592000"; 
   d="scan'208";a="542270713"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       "Du, Alek" <alek.du@intel.com>, "Tang, Feng" <feng.tang@intel.com>,
       "H. Peter Anvin" <hpa@linux.intel.com>,
       "Pan, Jacob jun" <jacob.jun.pan@intel.com>
Date: Fri, 19 Feb 2010 17:06:41 -0800
Subject: RE: [PATCH 9/9] x86/apic: remove ioapic_disable_legacy
Thread-Topic: [PATCH 9/9] x86/apic: remove ioapic_disable_legacy
Thread-Index: AcqsTYkMZbB4yndrSeePEB93tdCxqQFejElQ
Message-ID: <43F901BD926A4E43B106BF17856F0755A30A7660@orsmsx508.amr.corp.intel.com>
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

A couple of corrections to this patch.
1. added missing commit message
2. removed change that exports static variable nr_irqs_gsi

new patch:

>From 66f107d47224e70a4755969a4b01e8fa3815a606 Mon Sep 17 00:00:00 2001
From: Jacob Pan <jacob.jun.pan@intel.com>
Date: Fri, 5 Feb 2010 04:06:56 -0800
Subject: [PATCH] x86/apic: remove ioapic_disable_legacy

ioapic_disable_legacy call is no longer needed for platforms do not have
legacy pic. the legacy pic abstraction has taken care it automatically.

this patch also initialize irq related static variables based on
information obtained from legacy_pic.

Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
---
 arch/x86/include/asm/io_apic.h |    2 --
 arch/x86/kernel/apic/io_apic.c |   10 +++++-----
 2 files changed, 5 insertions(+), 7 deletions(-)

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
index 1704cd8..3592a72 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -143,11 +143,6 @@ static struct irq_cfg irq_cfgx[NR_IRQS_LEGACY];
 static struct irq_cfg irq_cfgx[NR_IRQS];
 #endif
 
-void __init io_apic_disable_legacy(void)
-{
-	nr_irqs_gsi = 0;
-}
-
 int __init arch_early_irq_init(void)
 {
 	struct irq_cfg *cfg;
@@ -156,6 +151,11 @@ int __init arch_early_irq_init(void)
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





>-----Original Message-----
>From: Pan, Jacob jun
>Sent: Friday, February 12, 2010 5:41 PM
>To: linux-kernel@vger.kernel.org
>Cc: Ingo Molnar; 'Thomas Gleixner'; Arjan van de Ven; Barnes, Jesse; Du, Alek;
>Tang, Feng; H. Peter Anvin
>Subject: [PATCH 9/9] x86/apic: remove ioapic_disable_legacy
>
>From e25ea443d81dc037e6a1da33e23bc04b976b70da Mon Sep 17 00:00:00 2001
>From: Jacob Pan <jacob.jun.pan@intel.com>
>Date: Fri, 5 Feb 2010 04:06:56 -0800
>Subject: [PATCH 9/9] x86/apic: remove ioapic_disable_legacy
>
>Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
>---
> arch/x86/include/asm/io_apic.h |    2 --
> arch/x86/kernel/apic/io_apic.c |   12 ++++++------
> 2 files changed, 6 insertions(+), 8 deletions(-)
>
>diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
>index 7c7c16c..84fdd51 100644
>--- a/arch/x86/include/asm/io_apic.h
>+++ b/arch/x86/include/asm/io_apic.h
>@@ -143,8 +143,6 @@ extern int noioapicreroute;
> /* 1 if the timer IRQ uses the '8259A Virtual Wire' mode */
> extern int timer_through_8259;
>
>-extern void io_apic_disable_legacy(void);
>-
> /*
>  * If we use the IO-APIC for IRQ routing, disable automatic
>  * assignment of PCI IRQ's.
>diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
>index 1704cd8..5a7aab2 100644
>--- a/arch/x86/kernel/apic/io_apic.c
>+++ b/arch/x86/kernel/apic/io_apic.c
>@@ -95,7 +95,7 @@ struct mpc_intsrc mp_irqs[MAX_IRQ_SOURCES];
> int mp_irq_entries;
>
> /* GSI interrupts */
>-static int nr_irqs_gsi = NR_IRQS_LEGACY;
>+int nr_irqs_gsi = NR_IRQS_LEGACY;
>
> #if defined (CONFIG_MCA) || defined (CONFIG_EISA)
> int mp_bus_id_to_type[MAX_MP_BUSSES];
>@@ -143,11 +143,6 @@ static struct irq_cfg irq_cfgx[NR_IRQS_LEGACY];
> static struct irq_cfg irq_cfgx[NR_IRQS];
> #endif
>
>-void __init io_apic_disable_legacy(void)
>-{
>-	nr_irqs_gsi = 0;
>-}
>-
> int __init arch_early_irq_init(void)
> {
> 	struct irq_cfg *cfg;
>@@ -156,6 +151,11 @@ int __init arch_early_irq_init(void)
> 	int node;
> 	int i;
>
>+	if (!legacy_pic->nr_legacy_irqs) {
>+		nr_irqs_gsi = 0;
>+		io_apic_irqs = ~0UL;
>+	}
>+
> 	cfg = irq_cfgx;
> 	count = ARRAY_SIZE(irq_cfgx);
> 	node= cpu_to_node(boot_cpu_id);
>--
>1.6.5.3

