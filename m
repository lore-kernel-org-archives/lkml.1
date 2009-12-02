Return-Path: <linux-kernel-owner+w=401wt.eu-S1755459AbZLBRVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbZLBRVN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 12:21:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755327AbZLBRVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 12:21:11 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:42307 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755137AbZLBRTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 12:19:11 -0500
From: Rodolfo Giometti <giometti@linux.it>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Rodolfo Giometti <giometti@linux.it>
Date: Wed,  2 Dec 2009 18:18:47 +0100
Message-Id: <1259774329-29663-10-git-send-email-giometti@linux.it>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1259774329-29663-9-git-send-email-giometti@linux.it>
References: <1259774329-29663-1-git-send-email-giometti@linux.it>
 <1259774329-29663-2-git-send-email-giometti@linux.it>
 <1259774329-29663-3-git-send-email-giometti@linux.it>
 <1259774329-29663-4-git-send-email-giometti@linux.it>
 <1259774329-29663-5-git-send-email-giometti@linux.it>
 <1259774329-29663-6-git-send-email-giometti@linux.it>
 <1259774329-29663-7-git-send-email-giometti@linux.it>
 <1259774329-29663-8-git-send-email-giometti@linux.it>
 <1259774329-29663-9-git-send-email-giometti@linux.it>
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH 09/11] pps: low level IRQ timestamps recording.
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add low level IRQ timestamps recording for x86 (32 and 64 bits)
platforms and enable UART clients in order to use it.

This improves PPS precision. :)

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
---
 arch/x86/kernel/irq_32.c    |    2 +
 arch/x86/kernel/irq_64.c    |    2 +
 drivers/pps/Kconfig         |   12 +++++++++++
 include/linux/irqnr.h       |    4 +++
 include/linux/serial_core.h |    5 ++++
 kernel/irq/handle.c         |   46 +++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 71 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 7d35d0f..0e34854 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -199,6 +199,8 @@ bool handle_irq(unsigned irq, struct pt_regs *regs)
 
 	overflow = check_stack_overflow();
 
+	irq_save_ts(irq);
+
 	desc = irq_to_desc(irq);
 	if (unlikely(!desc))
 		return false;
diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index 977d8b4..afbdba0 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -54,6 +54,8 @@ bool handle_irq(unsigned irq, struct pt_regs *regs)
 
 	stack_overflow_check(regs);
 
+	irq_save_ts(irq);
+
 	desc = irq_to_desc(irq);
 	if (unlikely(!desc))
 		return false;
diff --git a/drivers/pps/Kconfig b/drivers/pps/Kconfig
index 1afe4e0..6e8a2aa 100644
--- a/drivers/pps/Kconfig
+++ b/drivers/pps/Kconfig
@@ -22,6 +22,18 @@ config PPS
 	  To compile this driver as a module, choose M here: the module
 	  will be called pps_core.ko.
 
+config PPS_IRQ_EVENTS
+	bool "Use low level IRQ timestamps"
+	depends on PPS && (X86_32 || X86_64)
+	default no
+	help
+	  Say Y here if you wish using low level IRQ timestamps to register
+	  PPS events.
+
+	  This should improve PPS resolution but it delays echo functions
+	  call. Note also that this function may not be supported by some
+	  PPS clients!
+
 config PPS_DEBUG
 	bool "PPS debugging messages"
 	depends on PPS
diff --git a/include/linux/irqnr.h b/include/linux/irqnr.h
index 7bf89bc..4a7f4e8 100644
--- a/include/linux/irqnr.h
+++ b/include/linux/irqnr.h
@@ -25,6 +25,7 @@
 
 extern int nr_irqs;
 extern struct irq_desc *irq_to_desc(unsigned int irq);
+extern struct timespec *irq_to_ts(unsigned int irq);
 
 # define for_each_irq_desc(irq, desc)					\
 	for (irq = 0, desc = irq_to_desc(irq); irq < nr_irqs;		\
@@ -49,6 +50,9 @@ extern struct irq_desc *irq_to_desc(unsigned int irq);
 
 #endif /* CONFIG_GENERIC_HARDIRQS */
 
+extern struct timespec *irq_to_ts(unsigned int irq);
+extern void irq_save_ts(unsigned int irq);
+
 #define for_each_irq_nr(irq)                   \
        for (irq = 0; irq < nr_irqs; irq++)
 
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 4bfb046..5ffd720 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -189,6 +189,7 @@
 #include <linux/tty.h>
 #include <linux/mutex.h>
 #include <linux/sysrq.h>
+#include <linux/irqnr.h>
 
 struct uart_port;
 struct serial_struct;
@@ -492,7 +493,11 @@ uart_handle_dcd_change(struct uart_port *uport, unsigned int status)
 	struct timespec ts;
 
 	if (ld && ld->ops->dcd_change)
+#ifdef CONFIG_PPS_IRQ_EVENTS
+		ts = *(irq_to_ts(uport->irq));
+#else
 		getnstimeofday(&ts);
+#endif
 
 	uport->icount.dcd++;
 #ifdef CONFIG_HARD_PPS
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 17c71bb..5c6d71b 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -133,6 +133,7 @@ static void init_one_irq_desc(int irq, struct irq_desc *desc, int node)
 DEFINE_SPINLOCK(sparse_irq_lock);
 
 struct irq_desc **irq_desc_ptrs __read_mostly;
+struct timespec *irq_ts __read_mostly;
 
 static struct irq_desc irq_desc_legacy[NR_IRQS_LEGACY] __cacheline_aligned_in_smp = {
 	[0 ... NR_IRQS_LEGACY-1] = {
@@ -167,6 +168,9 @@ int __init early_irq_init(void)
 	/* allocate irq_desc_ptrs array based on nr_irqs */
 	irq_desc_ptrs = kcalloc(nr_irqs, sizeof(void *), GFP_NOWAIT);
 
+	/* allocate irq_ts array based on nr_irqs */
+	irq_ts = kcalloc(nr_irqs, sizeof(struct timespec), GFP_NOWAIT);
+
 	/* allocate based on nr_cpu_ids */
 	kstat_irqs_legacy = kzalloc_node(NR_IRQS_LEGACY * nr_cpu_ids *
 					  sizeof(int), GFP_NOWAIT, node);
@@ -197,6 +201,26 @@ struct irq_desc *irq_to_desc(unsigned int irq)
 	return NULL;
 }
 
+void irq_save_ts(unsigned int irq)
+{
+#ifdef CONFIG_PPS_IRQ_EVENTS
+	if (irq_desc_ptrs && irq < nr_irqs)
+		getnstimeofday(&irq_ts[irq]);
+#endif
+}
+
+struct timespec *irq_to_ts(unsigned int irq)
+{
+	if (irq >= nr_irqs) {
+		WARN(1, "irq (%d) >= nr_irqs (%d) in irq_to_ts\n",
+			irq, nr_irqs);
+		return NULL;
+	}
+
+	return &irq_ts[irq];
+}
+EXPORT_SYMBOL(irq_to_ts);
+
 struct irq_desc * __ref irq_to_desc_alloc_node(unsigned int irq, int node)
 {
 	struct irq_desc *desc;
@@ -251,6 +275,8 @@ struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
 	}
 };
 
+struct timespec irq_ts[NR_IRQS] __cacheline_aligned_in_smp;
+
 static unsigned int kstat_irqs_all[NR_IRQS][NR_CPUS];
 int __init early_irq_init(void)
 {
@@ -279,6 +305,26 @@ struct irq_desc *irq_to_desc(unsigned int irq)
 	return (irq < NR_IRQS) ? irq_desc + irq : NULL;
 }
 
+void irq_save_ts(unsigned int irq)
+{
+#ifdef CONFIG_PPS_IRQ_EVENTS
+	if (irq < NR_IRQS)
+		getnstimeofday(&irq_ts[irq]);
+#endif
+}
+
+struct timespec *irq_to_ts(unsigned int irq)
+{
+	if (irq >= NR_IRQS) {
+		WARN(1, "irq (%d) >= nr_irqs (%d) in irq_to_ts\n",
+			irq, nr_irqs);
+		return NULL;
+	}
+
+	return &irq_ts[irq];
+}
+EXPORT_SYMBOL(irq_to_ts);
+
 struct irq_desc *irq_to_desc_alloc_node(unsigned int irq, int node)
 {
 	return irq_to_desc(irq);
-- 
1.6.3.3

