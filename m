Return-Path: <linux-kernel-owner+w=401wt.eu-S1757457AbYHOCXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457AbYHOCXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 22:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbYHOCVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 22:21:35 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:17420 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820AbYHOCVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 22:21:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Y17N+EJMpJS6qbiq3lwNcgprRs0Rtpt3aDV2Tdn3p3zIv6CPxRhFnLIqC1q9/TWdtQ
         czJfuMaejgzTrgml/bdUeeedX+Q7vEAZBplU5sNnsO8bhlFXHfmjP826s5RsXDbFxJV0
         pjuJ+0c7fhM+FearLhvgUwgUGHzz60KS+WnVg=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 6/7] x86: ordering functions in io_apic_32.c
Date: Thu, 14 Aug 2008 19:20:31 -0700
Message-Id: <1218766832-20476-7-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218766832-20476-6-git-send-email-yhlu.kernel@gmail.com>
References: <no>
 <1218766832-20476-1-git-send-email-yhlu.kernel@gmail.com>
 <1218766832-20476-2-git-send-email-yhlu.kernel@gmail.com>
 <1218766832-20476-3-git-send-email-yhlu.kernel@gmail.com>
 <1218766832-20476-4-git-send-email-yhlu.kernel@gmail.com>
 <1218766832-20476-5-git-send-email-yhlu.kernel@gmail.com>
 <1218766832-20476-6-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

try to make functions in the same order to io_apic_64.c

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/io_apic_32.c |  176 ++++++++++++++++++++++--------------------
 1 files changed, 93 insertions(+), 83 deletions(-)

diff --git a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.c
index e0f85b5..5639404 100644
--- a/arch/x86/kernel/io_apic_32.c
+++ b/arch/x86/kernel/io_apic_32.c
@@ -1029,23 +1029,6 @@ static int pin_2_irq(int idx, int apic, int pin)
 	return irq;
 }
 
-static inline int IO_APIC_irq_trigger(int irq)
-{
-	int apic, idx, pin;
-
-	for (apic = 0; apic < nr_ioapics; apic++) {
-		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
-			idx = find_irq_entry(apic, pin, mp_INT);
-			if ((idx != -1) && (irq == pin_2_irq(idx, apic, pin)))
-				return irq_trigger(idx);
-		}
-	}
-	/*
-	 * nonexistent IRQs are edge default
-	 */
-	return 0;
-}
-
 void lock_vector_lock(void)
 {
 	/* Used to the online set of cpus does not change
@@ -1190,6 +1173,23 @@ static struct irq_chip ioapic_chip;
 #define IOAPIC_EDGE	0
 #define IOAPIC_LEVEL	1
 
+static inline int IO_APIC_irq_trigger(int irq)
+{
+	int apic, idx, pin;
+
+	for (apic = 0; apic < nr_ioapics; apic++) {
+		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
+			idx = find_irq_entry(apic, pin, mp_INT);
+			if ((idx != -1) && (irq == pin_2_irq(idx, apic, pin)))
+				return irq_trigger(idx);
+		}
+	}
+	/*
+	 * nonexistent IRQs are edge default
+	 */
+	return 0;
+}
+
 static void ioapic_register_intr(int irq, unsigned long trigger)
 {
 	struct irq_desc *desc;
@@ -1926,55 +1926,6 @@ static unsigned int startup_ioapic_irq(unsigned int irq)
 	return was_pending;
 }
 
-static void irq_complete_move(unsigned int irq);
-static void ack_ioapic_irq(unsigned int irq, struct irq_desc *desc)
-{
-	irq_complete_move(irq);
-	move_native_irq(irq, desc);
-	ack_APIC_irq();
-}
-
-static void ack_ioapic_quirk_irq(unsigned int irq, struct irq_desc *desc)
-{
-	unsigned long v;
-	int i;
-
-	irq_complete_move(irq);
-	move_native_irq(irq, desc);
-/*
- * It appears there is an erratum which affects at least version 0x11
- * of I/O APIC (that's the 82093AA and cores integrated into various
- * chipsets).  Under certain conditions a level-triggered interrupt is
- * erroneously delivered as edge-triggered one but the respective IRR
- * bit gets set nevertheless.  As a result the I/O unit expects an EOI
- * message but it will never arrive and further interrupts are blocked
- * from the source.  The exact reason is so far unknown, but the
- * phenomenon was observed when two consecutive interrupt requests
- * from a given source get delivered to the same CPU and the source is
- * temporarily disabled in between.
- *
- * A workaround is to simulate an EOI message manually.  We achieve it
- * by setting the trigger mode to edge and then to level when the edge
- * trigger mode gets detected in the TMR of a local APIC for a
- * level-triggered interrupt.  We mask the source for the time of the
- * operation to prevent an edge-triggered interrupt escaping meanwhile.
- * The idea is from Manfred Spraul.  --macro
- */
-	i = irq_cfg(irq)->vector;
-
-	v = apic_read(APIC_TMR + ((i & ~0x1f) >> 1));
-
-	ack_APIC_irq();
-
-	if (!(v & (1 << (i & 0x1f)))) {
-		atomic_inc(&irq_mis_count);
-		spin_lock(&ioapic_lock);
-		__mask_and_edge_IO_APIC_irq(irq);
-		__unmask_and_level_IO_APIC_irq(irq);
-		spin_unlock(&ioapic_lock);
-	}
-}
-
 static int ioapic_retrigger_irq(unsigned int irq)
 {
 	send_IPI_self(irq_cfg(irq)->vector);
@@ -2040,13 +1991,61 @@ static void irq_complete_move(unsigned int irq)
 static inline void irq_complete_move(unsigned int irq) {}
 #endif
 
+static void ack_apic_edge(unsigned int irq, struct irq_desc *desc)
+{
+	irq_complete_move(irq);
+	move_native_irq(irq, desc);
+	ack_APIC_irq();
+}
+
+static void ack_apic_level(unsigned int irq, struct irq_desc *desc)
+{
+	unsigned long v;
+	int i;
+
+	irq_complete_move(irq);
+	move_native_irq(irq, desc);
+/*
+ * It appears there is an erratum which affects at least version 0x11
+ * of I/O APIC (that's the 82093AA and cores integrated into various
+ * chipsets).  Under certain conditions a level-triggered interrupt is
+ * erroneously delivered as edge-triggered one but the respective IRR
+ * bit gets set nevertheless.  As a result the I/O unit expects an EOI
+ * message but it will never arrive and further interrupts are blocked
+ * from the source.  The exact reason is so far unknown, but the
+ * phenomenon was observed when two consecutive interrupt requests
+ * from a given source get delivered to the same CPU and the source is
+ * temporarily disabled in between.
+ *
+ * A workaround is to simulate an EOI message manually.  We achieve it
+ * by setting the trigger mode to edge and then to level when the edge
+ * trigger mode gets detected in the TMR of a local APIC for a
+ * level-triggered interrupt.  We mask the source for the time of the
+ * operation to prevent an edge-triggered interrupt escaping meanwhile.
+ * The idea is from Manfred Spraul.  --macro
+ */
+	i = irq_cfg(irq)->vector;
+
+	v = apic_read(APIC_TMR + ((i & ~0x1f) >> 1));
+
+	ack_APIC_irq();
+
+	if (!(v & (1 << (i & 0x1f)))) {
+		atomic_inc(&irq_mis_count);
+		spin_lock(&ioapic_lock);
+		__mask_and_edge_IO_APIC_irq(irq);
+		__unmask_and_level_IO_APIC_irq(irq);
+		spin_unlock(&ioapic_lock);
+	}
+}
+
 static struct irq_chip ioapic_chip __read_mostly = {
 	.name 		= "IO-APIC",
 	.startup 	= startup_ioapic_irq,
 	.mask	 	= mask_IO_APIC_irq,
 	.unmask	 	= unmask_IO_APIC_irq,
-	.ack 		= ack_ioapic_irq,
-	.eoi 		= ack_ioapic_quirk_irq,
+	.ack 		= ack_apic_edge,
+	.eoi 		= ack_apic_level,
 #ifdef CONFIG_SMP
 	.set_affinity 	= set_ioapic_affinity_irq,
 #endif
@@ -2094,11 +2093,6 @@ static inline void init_IO_APIC_traps(void)
  * The local APIC irq-chip implementation:
  */
 
-static void ack_lapic_irq(unsigned int irq, struct irq_desc *desc)
-{
-	ack_APIC_irq();
-}
-
 static void mask_lapic_irq(unsigned int irq)
 {
 	unsigned long v;
@@ -2115,6 +2109,11 @@ static void unmask_lapic_irq(unsigned int irq)
 	apic_write(APIC_LVT0, v & ~APIC_LVT_MASKED);
 }
 
+static void ack_lapic_irq(unsigned int irq, struct irq_desc *desc)
+{
+	ack_APIC_irq();
+}
+
 static struct irq_chip lapic_chip __read_mostly = {
 	.name		= "local-APIC",
 	.mask		= mask_lapic_irq,
@@ -2631,13 +2630,31 @@ static struct irq_chip msi_chip = {
 	.name		= "PCI-MSI",
 	.unmask		= unmask_msi_irq,
 	.mask		= mask_msi_irq,
-	.ack		= ack_ioapic_irq,
+	.ack		= ack_apic_edge,
 #ifdef CONFIG_SMP
 	.set_affinity	= set_msi_irq_affinity,
 #endif
 	.retrigger	= ioapic_retrigger_irq,
 };
 
+
+static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc, int irq)
+{
+	int ret;
+	struct msi_msg msg;
+
+	ret = msi_compose_msg(dev, irq, &msg);
+	if (ret < 0)
+		return ret;
+
+	set_irq_msi(irq, desc);
+	write_msi_msg(irq, &msg);
+
+	set_irq_chip_and_handler_name(irq, &msi_chip, handle_edge_irq, "edge");
+
+	return 0;
+}
+
 static unsigned int build_irq_for_pci_dev(struct pci_dev *dev)
 {
 	unsigned int irq;
@@ -2663,17 +2680,10 @@ int arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc)
 	if (irq == 0)
 		return -1;
 
-	ret = msi_compose_msg(dev, irq, &msg);
 	if (ret < 0) {
 		destroy_irq(irq);
 		return ret;
-	}
-
-	set_irq_msi(irq, desc);
-	write_msi_msg(irq, &msg);
-
-	set_irq_chip_and_handler_name(irq, &msi_chip, handle_edge_irq,
-				      "edge");
+        }
 
 	return 0;
 }
@@ -2732,7 +2742,7 @@ static struct irq_chip ht_irq_chip = {
 	.name		= "PCI-HT",
 	.mask		= mask_ht_irq,
 	.unmask		= unmask_ht_irq,
-	.ack		= ack_ioapic_irq,
+	.ack		= ack_apic_edge,
 #ifdef CONFIG_SMP
 	.set_affinity	= set_ht_irq_affinity,
 #endif
-- 
1.5.4.5

