Return-Path: <linux-kernel-owner+w=401wt.eu-S940745AbXHIOrD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940745AbXHIOrD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 10:47:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936423AbXHIOqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 10:46:53 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:48089 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937428AbXHIOqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 10:46:52 -0400
Date: Thu, 9 Aug 2007 18:46:54 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jay Estabrook <jay.estabrook@hp.com>, Richard Henderson <rth@twiddle.net>,
       Oliver Falk <oliver@linux-kernel.at>, linux-kernel@vger.kernel.org
Subject: [patch] alpha: -Werror fixes for sys_titan.c
Message-ID: <20070809184654.B25669@jurassic.park.msu.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jay Estabrook <jay.estabrook@hp.com>

Files:

arch/alpha/kernel/sys_titan.c

This code corrects the usage of the request_irq() routine.


Signed-off-by: Jay Estabrook <jay.estabrook@hp.com>
Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

---

diff -Naurp a/arch/alpha/kernel/sys_titan.c b/arch/alpha/kernel/sys_titan.c
--- a/arch/alpha/kernel/sys_titan.c	2007-07-08 19:32:17.000000000 -0400
+++ b/arch/alpha/kernel/sys_titan.c	2007-08-01 12:18:58.000000000 -0400
@@ -271,6 +271,19 @@ titan_dispatch_irqs(u64 mask)
  * Titan Family
  */
 static void __init
+titan_request_irq(unsigned int irq, irq_handler_t handler,
+		  unsigned long irqflags, const char *devname,
+		  void *dev_id)
+{
+	int err;
+	err = request_irq(irq, handler, irqflags, devname, dev_id);
+	if (err) {
+		printk("titan_request_irq for IRQ %d returned %d; ignoring\n",
+		       irq, err);
+	}
+}
+
+static void __init
 titan_late_init(void)
 {
 	/*
@@ -278,15 +291,15 @@ titan_late_init(void)
 	 * all reported to the kernel as machine checks, so the handler
 	 * is a nop so it can be called to count the individual events.
 	 */
-	request_irq(63+16, titan_intr_nop, IRQF_DISABLED,
+	titan_request_irq(63+16, titan_intr_nop, IRQF_DISABLED,
 		    "CChip Error", NULL);
-	request_irq(62+16, titan_intr_nop, IRQF_DISABLED,
+	titan_request_irq(62+16, titan_intr_nop, IRQF_DISABLED,
 		    "PChip 0 H_Error", NULL);
-	request_irq(61+16, titan_intr_nop, IRQF_DISABLED,
+	titan_request_irq(61+16, titan_intr_nop, IRQF_DISABLED,
 		    "PChip 1 H_Error", NULL);
-	request_irq(60+16, titan_intr_nop, IRQF_DISABLED,
+	titan_request_irq(60+16, titan_intr_nop, IRQF_DISABLED,
 		    "PChip 0 C_Error", NULL);
-	request_irq(59+16, titan_intr_nop, IRQF_DISABLED,
+	titan_request_irq(59+16, titan_intr_nop, IRQF_DISABLED,
 		    "PChip 1 C_Error", NULL);
 
 	/* 
@@ -345,9 +358,9 @@ privateer_init_pci(void)
 	 * Hook a couple of extra err interrupts that the
 	 * common titan code won't.
 	 */
-	request_irq(53+16, titan_intr_nop, IRQF_DISABLED,
+	titan_request_irq(53+16, titan_intr_nop, IRQF_DISABLED,
 		    "NMI", NULL);
-	request_irq(50+16, titan_intr_nop, IRQF_DISABLED,
+	titan_request_irq(50+16, titan_intr_nop, IRQF_DISABLED,
 		    "Temperature Warning", NULL);
 
 	/*
