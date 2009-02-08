Return-Path: <linux-kernel-owner+w=401wt.eu-S1753410AbZBHBOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbZBHBOb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 20:14:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240AbZBHBOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 20:14:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:51320 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbZBHBOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 20:14:23 -0500
Message-ID: <498E319C.6070005@kernel.org>
Date: Sat, 07 Feb 2009 17:13:00 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: use NR_IRQS_LEGACY to replace 16
References: <498CCEDB.8050708@kernel.org>
In-Reply-To: <498CCEDB.8050708@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: cleanup

also could kill platform_legacy_irq

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/hw_irq.h |    4 +---
 arch/x86/kernel/io_apic.c     |    8 ++++----
 2 files changed, 5 insertions(+), 7 deletions(-)

Index: linux-2.6/arch/x86/include/asm/hw_irq.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/hw_irq.h
+++ linux-2.6/arch/x86/include/asm/hw_irq.h
@@ -25,8 +25,6 @@
 #include <asm/irq.h>
 #include <asm/sections.h>
 
-#define platform_legacy_irq(irq)	((irq) < 16)
-
 /* Interrupt handlers registered during init_IRQ */
 extern void apic_timer_interrupt(void);
 extern void error_interrupt(void);
@@ -60,7 +58,7 @@ extern void make_8259A_irq(unsigned int
 extern void init_8259A(int aeoi);
 
 /* IOAPIC */
-#define IO_APIC_IRQ(x) (((x) >= 16) || ((1<<(x)) & io_apic_irqs))
+#define IO_APIC_IRQ(x) (((x) >= NR_IRQS_LEGACY) || ((1<<(x)) & io_apic_irqs))
 extern unsigned long io_apic_irqs;
 
 extern void init_VISWS_APIC_irqs(void);
Index: linux-2.6/arch/x86/kernel/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic.c
+++ linux-2.6/arch/x86/kernel/io_apic.c
@@ -3168,6 +3168,7 @@ static int __init ioapic_init_sysfs(void
 
 device_initcall(ioapic_init_sysfs);
 
+static int nr_irqs_gsi = NR_IRQS_LEGACY;
 /*
  * Dynamic irq allocate and deallocation
  */
@@ -3182,11 +3183,11 @@ unsigned int create_irq_nr(unsigned int
 	struct irq_desc *desc_new = NULL;
 
 	irq = 0;
+	if (irq_want < nr_irqs_gsi)
+		irq_want = nr_irqs_gsi;
+
 	spin_lock_irqsave(&vector_lock, flags);
 	for (new = irq_want; new < nr_irqs; new++) {
-		if (platform_legacy_irq(new))
-			continue;
-
 		desc_new = irq_to_desc_alloc_cpu(new, cpu);
 		if (!desc_new) {
 			printk(KERN_INFO "can not get irq_desc for %d\n", new);
@@ -3211,7 +3212,6 @@ unsigned int create_irq_nr(unsigned int
 	return irq;
 }
 
-static int nr_irqs_gsi = NR_IRQS_LEGACY;
 int create_irq(void)
 {
 	unsigned int irq_want;
