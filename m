Return-Path: <linux-kernel-owner+w=401wt.eu-S1758158AbYLFC7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158AbYLFC7g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 21:59:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755320AbYLFC67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 21:58:59 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:36151 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879AbYLFC65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 21:58:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=dadgghaoCvNWsqHDdROh81Fd3a2Dkp1Ywoiyj3M1nwkJt3nSpvhtuwRbRiqVHxiztk
         J8DVE7Sc/yxpTUQ9vXRzjKPhyik+Ki/j4b5qS9Et6uorEH38FUBZDjEttlSKpiUVUege
         i9z45BWUHyqYuGttFQPsupR3Kga/Ej2jalLJk=
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 2/5] use NR_IRQS_LEGACY
Date: Fri,  5 Dec 2008 18:58:32 -0800
Message-Id: <1228532315-28799-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1228532315-28799-1-git-send-email-yinghai@kernel.org>
References: <1228532315-28799-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

impact: cleanup

instead of use hard code number

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/irq_vectors.h |    2 ++
 arch/x86/kernel/io_apic.c          |   10 +++++-----
 arch/x86/kernel/irqinit_32.c       |    2 +-
 arch/x86/kernel/irqinit_64.c       |    2 +-
 kernel/irq/handle.c                |    6 +++---
 5 files changed, 12 insertions(+), 10 deletions(-)

Index: linux-2.6/arch/x86/include/asm/irq_vectors.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/irq_vectors.h
+++ linux-2.6/arch/x86/include/asm/irq_vectors.h
@@ -101,6 +101,8 @@
 #define LAST_VM86_IRQ		15
 #define invalid_vm86_irq(irq)	((irq) < 3 || (irq) > 15)
 
+#define NR_IRQS_LEGACY		16
+
 #if defined(CONFIG_X86_IO_APIC) && !defined(CONFIG_X86_VOYAGER)
 
 #ifndef CONFIG_SPARSE_IRQ
Index: linux-2.6/arch/x86/kernel/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic.c
+++ linux-2.6/arch/x86/kernel/io_apic.c
@@ -847,7 +847,7 @@ EXPORT_SYMBOL(IO_APIC_get_PCI_irq_vector
  */
 static int EISA_ELCR(unsigned int irq)
 {
-	if (irq < 16) {
+	if (irq < NR_IRQS_LEGACY) {
 		unsigned int port = 0x4d0 + (irq >> 3);
 		return (inb(port) >> (irq & 7)) & 1;
 	}
@@ -1388,7 +1388,7 @@ static void setup_IO_APIC_irq(int apic,
 	}
 
 	ioapic_register_intr(irq, trigger);
-	if (irq < 16)
+	if (irq < NR_IRQS_LEGACY)
 		disable_8259A_irq(irq);
 
 	ioapic_write_entry(apic, pin, entry);
@@ -2080,7 +2080,7 @@ static unsigned int startup_ioapic_irq(u
 	struct irq_cfg *cfg;
 
 	spin_lock_irqsave(&ioapic_lock, flags);
-	if (irq < 16) {
+	if (irq < NR_IRQS_LEGACY) {
 		disable_8259A_irq(irq);
 		if (i8259A_irq_pending(irq))
 			was_pending = 1;
@@ -2504,7 +2504,7 @@ static inline void init_IO_APIC_traps(vo
 			 * so default to an old-fashioned 8259
 			 * interrupt if we can..
 			 */
-			if (irq < 16)
+			if (irq < NR_IRQS_LEGACY)
 				make_8259A_irq(irq);
 			else
 				/* Strange. Oh, well.. */
@@ -3794,7 +3794,7 @@ int io_apic_set_pci_routing (int ioapic,
 	/*
 	 * IRQs < 16 are already in the irq_2_pin[] map
 	 */
-	if (irq >= 16) {
+	if (irq >= NR_IRQS_LEGACY) {
 		cfg = desc->chip_data;
 		add_pin_to_irq_cpu(irq, cpu, ioapic, pin);
 	}
Index: linux-2.6/arch/x86/kernel/irqinit_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irqinit_32.c
+++ linux-2.6/arch/x86/kernel/irqinit_32.c
@@ -68,7 +68,7 @@ void __init init_ISA_irqs (void)
 	/*
 	 * 16 old-style INTA-cycle interrupts:
 	 */
-	for (i = 0; i < 16; i++) {
+	for (i = 0; i < NR_IRQS_LEGACY; i++) {
 		struct irq_desc *desc = irq_to_desc(i);
 
 		desc->status = IRQ_DISABLED;
Index: linux-2.6/arch/x86/kernel/irqinit_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irqinit_64.c
+++ linux-2.6/arch/x86/kernel/irqinit_64.c
@@ -76,7 +76,7 @@ void __init init_ISA_irqs(void)
 	init_bsp_APIC();
 	init_8259A(0);
 
-	for (i = 0; i < 16; i++) {
+	for (i = 0; i < NR_IRQS_LEGACY; i++) {
 		struct irq_desc *desc = irq_to_desc(i);
 
 		desc->status = IRQ_DISABLED;
Index: linux-2.6/kernel/irq/handle.c
===================================================================
--- linux-2.6.orig/kernel/irq/handle.c
+++ linux-2.6/kernel/irq/handle.c
@@ -117,8 +117,8 @@ static DEFINE_SPINLOCK(sparse_irq_lock);
 
 struct irq_desc *irq_desc_ptrs[NR_IRQS] __read_mostly;
 
-static struct irq_desc irq_desc_legacy[16] __cacheline_aligned_in_smp = {
-	[0 ... 15] = {
+static struct irq_desc irq_desc_legacy[NR_IRQS_LEGACY] __cacheline_aligned_in_smp = {
+	[0 ... NR_IRQS_LEGACY-1] = {
 		.irq	    = -1,
 		.status	    = IRQ_DISABLED,
 		.chip	    = &no_irq_chip,
@@ -132,7 +132,7 @@ static struct irq_desc irq_desc_legacy[1
 };
 
 /* FIXME: use bootmem alloc ...*/
-static unsigned int kstat_irqs_legacy[16][NR_CPUS];
+static unsigned int kstat_irqs_legacy[NR_IRQS_LEGACY][NR_CPUS];
 
 void __init early_irq_init(void)
 {
