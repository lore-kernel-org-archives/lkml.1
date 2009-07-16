Return-Path: <linux-kernel-owner+w=401wt.eu-S932367AbZGPKzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367AbZGPKzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 06:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755374AbZGPKzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 06:55:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:51507 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755180AbZGPKzj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 06:55:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,410,1243839600"; 
   d="scan'208,223";a="430730486"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>
Date: Thu, 16 Jul 2009 03:55:37 -0700
Subject: [PATCH v2 9/10] x86/apic: RFC decouple legacy irq handling in ioapic
Thread-Topic: [PATCH v2 9/10] x86/apic: RFC decouple legacy irq handling in
 ioapic
Thread-Index: AcoGA/NvO9xVwivsRqeu86MTzi7G7w==
Message-ID: <43F901BD926A4E43B106BF17856F0755643EBDFB@orsmsx508.amr.corp.intel.com>
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

>From aa83317bdaca4c42e5aece29d3afb563a7558947 Mon Sep 17 00:00:00 2001
From: Jacob Pan <jacob.jun.pan@intel.com>
Date: Wed, 15 Jul 2009 11:29:42 -0700
Subject: [PATCH] x86/apic: RFC decouple legacy irq handling in ioapic

This patch uses platform feature flags to separate i8259/PIC from ioapic.
A cleaner solution might be adding abstraction for device interrupt
controller and moving apic initialization earlier so that
platforms with legacy replace devices can boot without the constriant of
PIC, PIT, etc. Such change obviously introduces risk.

The intention of this patch is also to show what kind of changes are needed
for non-pc x86 platform such as Moorestown MID. perhpas we can take a phased
approach.

Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
---
 arch/x86/kernel/apic/apic.c    |    3 +++
 arch/x86/kernel/apic/io_apic.c |   29 +++++++++++++++++++++++------
 2 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 8c7c042..c2b67d4 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -49,6 +49,7 @@
 #include <asm/mtrr.h>
 #include <asm/smp.h>
 #include <asm/mce.h>
+#include <asm/platform_feature.h>
 
 unsigned int num_processors;
 
@@ -1115,6 +1116,8 @@ void __init init_bsp_APIC(void)
 	value |= SPURIOUS_APIC_VECTOR;
 	apic_write(APIC_SPIV, value);
 
+	if (!platform_has(X86_PLATFORM_FEATURE_8259))
+		return;
 	/*
 	 * Set up the virtual wire mode.
 	 */
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index bff8990..645c8eb 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -62,7 +62,7 @@
 #include <asm/hw_irq.h>
 #include <asm/uv/uv_hub.h>
 #include <asm/uv/uv_irq.h>
-
+#include <asm/platform_feature.h>
 #include <asm/apic.h>
 
 #define __apicdebuginit(type) static type __init
@@ -1447,6 +1447,12 @@ int setup_ioapic_entry(int apic_id, int irq,
 	return 0;
 }
 
+static inline int is_i8259_legacy_irq(int irq)
+{
+	return ((irq < NR_IRQS_LEGACY)
+		&& platform_has(X86_PLATFORM_FEATURE_8259));
+}
+
 static void setup_IO_APIC_irq(int apic_id, int pin, unsigned int irq, struct irq_desc *desc,
 			      int trigger, int polarity)
 {
@@ -1480,7 +1486,7 @@ static void setup_IO_APIC_irq(int apic_id, int pin, unsigned int irq, struct irq
 	}
 
 	ioapic_register_intr(irq, desc, trigger);
-	if (irq < NR_IRQS_LEGACY)
+	if (is_i8259_legacy_irq(irq))
 		disable_8259A_irq(irq);
 
 	ioapic_write_entry(apic_id, pin, entry);
@@ -1857,6 +1863,9 @@ __apicdebuginit(void) print_PIC(void)
 	unsigned int v;
 	unsigned long flags;
 
+	if (!platform_has(X86_PLATFORM_FEATURE_8259))
+		return;
+
 	if (apic_verbosity == APIC_QUIET)
 		return;
 
@@ -1920,6 +1929,8 @@ void __init enable_IO_APIC(void)
 		spin_unlock_irqrestore(&ioapic_lock, flags);
 		nr_ioapic_registers[apic] = reg_01.bits.entries+1;
 	}
+	if (!platform_has(X86_PLATFORM_FEATURE_8259))
+		return;
 	for(apic = 0; apic < nr_ioapics; apic++) {
 		int pin;
 		/* See if any of the pins is in ExtINT mode */
@@ -1974,6 +1985,8 @@ void disable_IO_APIC(void)
 	 */
 	clear_IO_APIC();
 
+	if (!platform_has(X86_PLATFORM_FEATURE_8259))
+		return;
 	/*
 	 * If the i8259 is routed through an IOAPIC
 	 * Put that IOAPIC in virtual wire mode
@@ -2205,7 +2218,7 @@ static unsigned int startup_ioapic_irq(unsigned int irq)
 	struct irq_cfg *cfg;
 
 	spin_lock_irqsave(&ioapic_lock, flags);
-	if (irq < NR_IRQS_LEGACY) {
+	if (is_i8259_legacy_irq(irq)) {
 		disable_8259A_irq(irq);
 		if (i8259A_irq_pending(irq))
 			was_pending = 1;
@@ -2716,7 +2729,7 @@ static inline void init_IO_APIC_traps(void)
 			 * so default to an old-fashioned 8259
 			 * interrupt if we can..
 			 */
-			if (irq < NR_IRQS_LEGACY)
+			if (is_i8259_legacy_irq(irq))
 				make_8259A_irq(irq);
 			else
 				/* Strange. Oh, well.. */
@@ -3059,9 +3072,13 @@ void __init setup_IO_APIC(void)
 
 	/*
 	 * calling enable_IO_APIC() is moved to setup_local_APIC for BP
+	 * For platforms that do not have legacy IRQs, IOAPIC IRQ can be any
+	 * number.
 	 */
-
-	io_apic_irqs = ~PIC_IRQS;
+	if (!platform_has(X86_PLATFORM_FEATURE_8259))
+		io_apic_irqs = ~0;
+	else
+		io_apic_irqs = ~PIC_IRQS;
 
 	apic_printk(APIC_VERBOSE, "ENABLING IO-APIC IRQs\n");
 	/*
-- 
1.5.6.5

