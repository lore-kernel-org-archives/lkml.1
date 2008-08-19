Return-Path: <linux-kernel-owner+w=401wt.eu-S1760310AbYHSVw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760310AbYHSVw7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 17:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759046AbYHSVus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 17:50:48 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:52929 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759570AbYHSVui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 17:50:38 -0400
From: Rodolfo Giometti <giometti@linux.it>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rodolfo Giometti <giometti@linux.it>
Date: Tue, 19 Aug 2008 23:50:11 +0200
Message-Id: <1219182612-13814-10-git-send-email-giometti@linux.it>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1219182612-13814-9-git-send-email-giometti@linux.it>
References: <>
 <1219182612-13814-1-git-send-email-giometti@linux.it>
 <1219182612-13814-2-git-send-email-giometti@linux.it>
 <1219182612-13814-3-git-send-email-giometti@linux.it>
 <1219182612-13814-4-git-send-email-giometti@linux.it>
 <1219182612-13814-5-git-send-email-giometti@linux.it>
 <1219182612-13814-6-git-send-email-giometti@linux.it>
 <1219182612-13814-7-git-send-email-giometti@linux.it>
 <1219182612-13814-8-git-send-email-giometti@linux.it>
 <1219182612-13814-9-git-send-email-giometti@linux.it>
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH 09/10] PPS: low level IRQ timestamps recording.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add low level IRQ timestamps recording for x86 (32 and 64 bits)
platforms and enable UART clients in order to use it.

This improves PPS precision. :)

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
---
 arch/x86/kernel/irq_32.c        |   18 ++++++++++++++++++
 arch/x86/kernel/irq_64.c        |   22 ++++++++++++++++++++--
 drivers/pps/Kconfig             |   12 ++++++++++++
 drivers/pps/clients/pps-ldisc.c |   18 ++++++++++++++++++
 include/linux/pps.h             |    1 +
 5 files changed, 69 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 1cf8c1f..3013d0d 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -15,6 +15,7 @@
 #include <linux/notifier.h>
 #include <linux/cpu.h>
 #include <linux/delay.h>
+#include <linux/pps.h>
 
 #include <asm/apic.h>
 #include <asm/uaccess.h>
@@ -25,6 +26,11 @@ EXPORT_PER_CPU_SYMBOL(irq_stat);
 DEFINE_PER_CPU(struct pt_regs *, irq_regs);
 EXPORT_PER_CPU_SYMBOL(irq_regs);
 
+#ifdef CONFIG_PPS_IRQ_EVENTS
+struct pps_ktime pps_irq_ts[NR_IRQS];
+EXPORT_SYMBOL(pps_irq_ts);
+#endif
+
 /*
  * 'what should we do if we get a hw irq event on an illegal vector'.
  * each architecture has to answer this themselves.
@@ -225,6 +231,12 @@ unsigned int do_IRQ(struct pt_regs *regs)
 	/* high bit used in ret_from_ code */
 	int overflow, irq = ~regs->orig_ax;
 	struct irq_desc *desc = irq_desc + irq;
+#ifdef CONFIG_PPS_IRQ_EVENTS
+	struct timespec __ts;
+
+	/* Get IRQ timestamps as soon as possible for the PPS layer */
+	getnstimeofday(&__ts);
+#endif
 
 	if (unlikely((unsigned)irq >= NR_IRQS)) {
 		printk(KERN_EMERG "%s: cannot handle IRQ %d\n",
@@ -232,6 +244,12 @@ unsigned int do_IRQ(struct pt_regs *regs)
 		BUG();
 	}
 
+#ifdef CONFIG_PPS_IRQ_EVENTS
+	/* Then, after sanity check, store the IRQ timestamp */
+	pps_irq_ts[irq].sec = __ts.tv_sec;
+	pps_irq_ts[irq].nsec = __ts.tv_nsec;
+#endif
+
 	old_regs = set_irq_regs(regs);
 	irq_enter();
 
diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index 1f78b23..1ea77a7 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -17,9 +17,15 @@
 #include <asm/io_apic.h>
 #include <asm/idle.h>
 #include <asm/smp.h>
+#include <linux/pps.h>
 
 atomic_t irq_err_count;
 
+#ifdef CONFIG_PPS_IRQ_EVENTS
+struct pps_ktime pps_irq_ts[NR_IRQS];
+EXPORT_SYMBOL(pps_irq_ts);
+#endif
+
 /*
  * 'what should we do if we get a hw irq event on an illegal vector'.
  * each architecture has to answer this themselves.
@@ -188,6 +194,12 @@ u64 arch_irq_stat(void)
 asmlinkage unsigned int do_IRQ(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
+#ifdef CONFIG_PPS_IRQ_EVENTS
+	struct timespec __ts;
+
+	/* Get IRQ timestamps as soon as possible for the PPS layer */
+	getnstimeofday(&__ts);
+#endif
 
 	/* high bit used in ret_from_ code  */
 	unsigned vector = ~regs->orig_ax;
@@ -201,9 +213,15 @@ asmlinkage unsigned int do_IRQ(struct pt_regs *regs)
 	stack_overflow_check(regs);
 #endif
 
-	if (likely(irq < NR_IRQS))
+	if (likely(irq < NR_IRQS)) {
+#ifdef CONFIG_PPS_IRQ_EVENTS
+		/* Then, after sanity check, store the IRQ timestamp */
+		pps_irq_ts[irq].sec = __ts.tv_sec;
+		pps_irq_ts[irq].nsec = __ts.tv_nsec;
+#endif
+
 		generic_handle_irq(irq);
-	else {
+	} else {
 		if (!disable_apic)
 			ack_APIC_irq();
 
diff --git a/drivers/pps/Kconfig b/drivers/pps/Kconfig
index 1afe4e0..7c0b094 100644
--- a/drivers/pps/Kconfig
+++ b/drivers/pps/Kconfig
@@ -22,6 +22,18 @@ config PPS
 	  To compile this driver as a module, choose M here: the module
 	  will be called pps_core.ko.
 
+config PPS_IRQ_EVENTS
+	bool "Use low level IRQ timestamps"
+	depends on PPS && (X86_32 || X86_64)
+	default yes
+	help
+	  Say Y here if you wish using low level IRQ timestamps to register
+	  PPS events.
+
+	  This should improve PPS resolution but it delays echo functions
+	  call. Note also that this function is not implemented on all
+	  platforms and PPS clients!
+
 config PPS_DEBUG
 	bool "PPS debugging messages"
 	depends on PPS
diff --git a/drivers/pps/clients/pps-ldisc.c b/drivers/pps/clients/pps-ldisc.c
index f1efa26..20d2c2e 100644
--- a/drivers/pps/clients/pps-ldisc.c
+++ b/drivers/pps/clients/pps-ldisc.c
@@ -26,6 +26,22 @@
 
 #define PPS_TTY_MAGIC		0x0001
 
+#ifdef CONFIG_PPS_IRQ_EVENTS
+
+static void pps_tty_dcd_change(struct uart_port *port, unsigned int status,
+				struct timespec *ts)
+{
+	int id = (int) port->info->port.tty->disc_data;
+
+	pps_event(id, &pps_irq_ts[port->irq],
+			status ? PPS_CAPTUREASSERT : PPS_CAPTURECLEAR, port);
+
+	pr_debug("[IRQev] PPS %s at %lu on source #%d\n",
+			status ? "assert" : "clear", jiffies, id);
+}
+
+#else
+
 static void pps_tty_dcd_change(struct uart_port *port, unsigned int status,
 				struct timespec *ts)
 {
@@ -53,6 +69,8 @@ static void pps_tty_dcd_change(struct uart_port *port, unsigned int status,
 			status ? "assert" : "clear", jiffies, id);
 }
 
+#endif /* CONFIG_PPS_IRQ_EVENTS */
+
 static int pps_tty_open(struct tty_struct *tty)
 {
 	struct pps_source_info info;
diff --git a/include/linux/pps.h b/include/linux/pps.h
index 53e171c..bb9a2e6 100644
--- a/include/linux/pps.h
+++ b/include/linux/pps.h
@@ -181,6 +181,7 @@ struct pps_device {
 
 extern spinlock_t pps_idr_lock;
 extern struct idr pps_idr;
+extern struct pps_ktime pps_irq_ts[];
 
 extern struct device_attribute pps_attrs[];
 
-- 
1.5.4.3

