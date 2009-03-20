Return-Path: <linux-kernel-owner+w=401wt.eu-S1757606AbZCTOgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606AbZCTOgD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 10:36:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbZCTOfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 10:35:53 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:50060 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751981AbZCTOfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 10:35:52 -0400
From: monstr@monstr.eu
To: tglx@linutronix.de
Cc: michal.simek@petalogix.com, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, john.williams@petalogix.com,
       Michal Simek <monstr@monstr.eu>
Subject: [PATCH 1/1] Update intc.c and irq code
Date: Fri, 20 Mar 2009 15:35:31 +0100
Message-Id: <1237559731-13063-1-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

This patch add support for use generic_handle_irq
instead of __do_IRQ. There were necessary to do
more changes in intc.c code -> especially changes
in irq_chip function

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/Kconfig       |    3 +
 arch/microblaze/kernel/intc.c |  169 +++++++++++++++++++++++++++++++++++++++++
 arch/microblaze/kernel/irq.c  |    2 +-
 3 files changed, 173 insertions(+), 1 deletions(-)
 create mode 100644 arch/microblaze/kernel/intc.c

diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index a2df3f8..cca0b3c 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -46,6 +46,9 @@ config GENERIC_TIME_VSYSCALL
 config GENERIC_CLOCKEVENTS
 	def_bool y
 
+config GENERIC_HARDIRQS_NO__DO_IRQ
+	def_bool y
+
 config PCI
 	depends on !MMU
 	def_bool n
diff --git a/arch/microblaze/kernel/intc.c b/arch/microblaze/kernel/intc.c
new file mode 100644
index 0000000..c48c2d0
--- /dev/null
+++ b/arch/microblaze/kernel/intc.c
@@ -0,0 +1,169 @@
+/*
+ * Copyright (C) 2007 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+#include <linux/init.h>
+#include <linux/irq.h>
+#include <asm/page.h>
+#include <linux/io.h>
+
+#include <asm/prom.h>
+#include <asm/irq.h>
+
+#ifdef CONFIG_SELFMOD_INTC
+#include <asm/selfmod.h>
+#define INTC_BASE	BARRIER_BASE_ADDR
+#else
+static unsigned int intc_baseaddr;
+#define INTC_BASE	intc_baseaddr
+#endif
+
+unsigned int nr_irq;
+
+/* No one else should require these constants, so define them locally here. */
+#define ISR 0x00			/* Interrupt Status Register */
+#define IPR 0x04			/* Interrupt Pending Register */
+#define IER 0x08			/* Interrupt Enable Register */
+#define IAR 0x0c			/* Interrupt Acknowledge Register */
+#define SIE 0x10			/* Set Interrupt Enable bits */
+#define CIE 0x14			/* Clear Interrupt Enable bits */
+#define IVR 0x18			/* Interrupt Vector Register */
+#define MER 0x1c			/* Master Enable Register */
+
+#define MER_ME (1<<0)
+#define MER_HIE (1<<1)
+
+static void intc_enable_or_unmask(unsigned int irq)
+{
+	pr_debug("enable_or_unmask: %d\n", irq);
+	out_be32(INTC_BASE + SIE, 1 << irq);
+}
+
+static void intc_disable_or_mask(unsigned int irq)
+{
+	pr_debug("disable: %d\n", irq);
+	out_be32(INTC_BASE + CIE, 1 << irq);
+}
+
+static void intc_ack(unsigned int irq)
+{
+	pr_debug("ack: %d\n", irq);
+	out_be32(INTC_BASE + IAR, 1 << irq);
+}
+
+static void intc_mask_ack(unsigned int irq)
+{
+	unsigned long mask = 1 << irq;
+	pr_debug("disable_and_ack: %d\n", irq);
+	out_be32(INTC_BASE + CIE, mask);
+	out_be32(INTC_BASE + IAR, mask);
+}
+
+static void intc_end(unsigned int irq)
+{
+	unsigned long mask = 1 << irq;
+	pr_debug("end: %d\n", irq);
+	if (!(irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS))) {
+		out_be32(INTC_BASE + SIE, mask);
+		/* ack level sensitive intr */
+		if (irq_desc[irq].status & IRQ_LEVEL)
+			out_be32(INTC_BASE + IAR, mask);
+	}
+}
+
+static struct irq_chip intc_dev = {
+	.name = "Xilinx INTC",
+	.unmask = intc_enable_or_unmask,
+	.mask = intc_disable_or_mask,
+	.ack = intc_ack,
+	.mask_ack = intc_mask_ack,
+	.end = intc_end,
+};
+
+unsigned int get_irq(struct pt_regs *regs)
+{
+	int irq;
+
+	/*
+	 * NOTE: This function is the one that needs to be improved in
+	 * order to handle multiple interrupt controllers. It currently
+	 * is hardcoded to check for interrupts only on the first INTC.
+	 */
+	irq = in_be32(INTC_BASE + IVR);
+	pr_debug("get_irq: %d\n", irq);
+
+	return irq;
+}
+
+void __init init_IRQ(void)
+{
+	u32 i, j, intr_type;
+	struct device_node *intc = NULL;
+#ifdef CONFIG_SELFMOD_INTC
+	unsigned int intc_baseaddr = 0;
+	static int arr_func[] = {
+				(int)&get_irq,
+				(int)&intc_enable,
+				(int)&intc_disable,
+				(int)&intc_disable_and_ack,
+				(int)&intc_end,
+				0
+			};
+#endif
+	static char *intc_list[] = {
+				"xlnx,xps-intc-1.00.a",
+				"xlnx,opb-intc-1.00.c",
+				"xlnx,opb-intc-1.00.b",
+				"xlnx,opb-intc-1.00.a",
+				NULL
+			};
+
+	for (j = 0; intc_list[j] != NULL; j++) {
+		intc = of_find_compatible_node(NULL, NULL, intc_list[j]);
+		if (intc)
+			break;
+	}
+
+	intc_baseaddr = *(int *) of_get_property(intc, "reg", NULL);
+	intc_baseaddr = (unsigned long) ioremap(intc_baseaddr, PAGE_SIZE);
+	nr_irq = *(int *) of_get_property(intc, "xlnx,num-intr-inputs", NULL);
+
+	intr_type =
+		*(int *) of_get_property(intc, "xlnx,kind-of-intr", NULL);
+	if (intr_type >= (1 << nr_irq))
+		printk(KERN_INFO " ERROR: Mishmash in king-of-intr param\n");
+
+#ifdef CONFIG_SELFMOD_INTC
+	selfmod_function((int *) arr_func, intc_baseaddr);
+#endif
+	printk(KERN_INFO "%s #0 at 0x%08x, num_irq=%d, edge=0x%x\n",
+		intc_list[j], intc_baseaddr, nr_irq, intr_type);
+
+	/*
+	 * Disable all external interrupts until they are
+	 * explicity requested.
+	 */
+	out_be32(intc_baseaddr + IER, 0);
+
+	/* Acknowledge any pending interrupts just in case. */
+	out_be32(intc_baseaddr + IAR, 0xffffffff);
+
+	/* Turn on the Master Enable. */
+	out_be32(intc_baseaddr + MER, MER_HIE | MER_ME);
+
+	for (i = 0; i < nr_irq; ++i) {
+		if (intr_type & (0x00000001 << i)) {
+			set_irq_chip_and_handler_name(i, &intc_dev,
+				handle_edge_irq, intc_dev.name);
+			irq_desc[i].status &= ~IRQ_LEVEL;
+		} else {
+			set_irq_chip_and_handler_name(i, &intc_dev,
+				handle_level_irq, intc_dev.name);
+			irq_desc[i].status |= IRQ_LEVEL;
+		}
+	}
+}
diff --git a/arch/microblaze/kernel/irq.c b/arch/microblaze/kernel/irq.c
index ff2d29f..29f0b3e 100644
--- a/arch/microblaze/kernel/irq.c
+++ b/arch/microblaze/kernel/irq.c
@@ -48,7 +48,7 @@ void do_IRQ(struct pt_regs *regs)
 	irq = get_irq(regs);
 next_irq:
 	BUG_ON(irq == -1U);
-	__do_IRQ(irq);
+	generic_handle_irq(irq);
 
 	irq = get_irq(regs);
 	if (irq != -1U) {
-- 
1.5.5.1

