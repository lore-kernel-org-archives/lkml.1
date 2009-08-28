Return-Path: <linux-kernel-owner+w=401wt.eu-S1753368AbZH1VxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbZH1VxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 17:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753357AbZH1VxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 17:53:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:1334 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752840AbZH1VxH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 17:53:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,292,1249282800"; 
   d="scan'208,223";a="545725338"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>
CC: LKML <linux-kernel@vger.kernel.org>, x86 team <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>
Date: Fri, 28 Aug 2009 14:53:08 -0700
Subject: [RFC PATCH 5/7] x86/apic: decouple legacy irq handling in ioapic
Thread-Topic: [RFC PATCH 5/7] x86/apic: decouple legacy irq handling in
 ioapic
Thread-Index: Acoir9vx9XaYijQEQY+7z9INN3fH8AFeQ24Q
Message-ID: <43F901BD926A4E43B106BF17856F07556A5EA876@orsmsx508.amr.corp.intel.com>
References: <20090821205008.518392436@linutronix.de>
 <20090821205601.878468441@linutronix.de> <4A8F1E4D.9080409@goop.org>
 <alpine.LFD.2.00.0908220034110.1769@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0908220034110.1769@localhost.localdomain>
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

>From b37e4a846402d0ef7b1c19ea17d2d3aee22e81c2 Mon Sep 17 00:00:00 2001
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
 arch/x86/kernel/apic/io_apic.c |   31 ++++++++++++++++++++++++-------
 1 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index a22b710..ccc746f 100644
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
@@ -1851,6 +1857,9 @@ __apicdebuginit(void) print_PIC(void)
 	unsigned int v;
 	unsigned long flags;
 
+	if (!platform_has(X86_PLATFORM_FEATURE_8259))
+		return;
+
 	if (apic_verbosity == APIC_QUIET)
 		return;
 
@@ -1914,6 +1923,8 @@ void __init enable_IO_APIC(void)
 		spin_unlock_irqrestore(&ioapic_lock, flags);
 		nr_ioapic_registers[apic] = reg_01.bits.entries+1;
 	}
+	if (!platform_has(X86_PLATFORM_FEATURE_8259))
+		return;
 	for(apic = 0; apic < nr_ioapics; apic++) {
 		int pin;
 		/* See if any of the pins is in ExtINT mode */
@@ -1968,6 +1979,8 @@ void disable_IO_APIC(void)
 	 */
 	clear_IO_APIC();
 
+	if (!platform_has(X86_PLATFORM_FEATURE_8259))
+		return;
 	/*
 	 * If the i8259 is routed through an IOAPIC
 	 * Put that IOAPIC in virtual wire mode
@@ -2198,7 +2211,7 @@ static unsigned int startup_ioapic_irq(unsigned int irq)
 	struct irq_cfg *cfg;
 
 	spin_lock_irqsave(&ioapic_lock, flags);
-	if (irq < NR_IRQS_LEGACY) {
+	if (is_i8259_legacy_irq(irq)) {
 		disable_8259A_irq(irq);
 		if (i8259A_irq_pending(irq))
 			was_pending = 1;
@@ -2709,7 +2722,7 @@ static inline void init_IO_APIC_traps(void)
 			 * so default to an old-fashioned 8259
 			 * interrupt if we can..
 			 */
-			if (irq < NR_IRQS_LEGACY)
+			if (is_i8259_legacy_irq(irq))
 				make_8259A_irq(irq);
 			else
 				/* Strange. Oh, well.. */
@@ -3052,9 +3065,13 @@ void __init setup_IO_APIC(void)
 
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
@@ -3907,7 +3924,7 @@ static int __io_apic_set_pci_routing(struct device *dev, int irq,
 	/*
 	 * IRQs < 16 are already in the irq_2_pin[] map
 	 */
-	if (irq >= NR_IRQS_LEGACY) {
+	if (!is_i8259_legacy_irq(irq)) {
 		cfg = desc->chip_data;
 		add_pin_to_irq_node(cfg, node, ioapic, pin);
 	}
-- 
1.5.6.5

