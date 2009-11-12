Return-Path: <linux-kernel-owner+w=401wt.eu-S1760044AbZKLD6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760044AbZKLD6d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 22:58:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759978AbZKLD6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 22:58:32 -0500
Received: from mga09.intel.com ([134.134.136.24]:30742 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759950AbZKLD6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 22:58:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,726,1249282800"; 
   d="scan'208";a="568771324"
Subject: [PATCH resend] iop13xx: workaround errata that causes uart interrupts
	to be missed
To: alan@lxorguk.ukuu.org.uk
From: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 11 Nov 2009 20:58:36 -0700
Message-ID: <20091112035728.18068.39520.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGit/0.14.3.289.g7daff
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reading the uart iir register sometimes results in the interrupt being
cleared without being reported.  Use the the system interrupt pending
register as a fallback.

This converts locations in the code that only care about the interrupt
pending bit to use the iir_int_status() macro.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

Hi Alan,

Looking for an acked-by or advice on how to get this hack upstream.  I
have been carrying it for a while out of tree [1], but that is getting
tiresome.  Russell pointed me at you as the gatekeeper of 8250.c, but
feel free to redirect me if someone else is looking after this file
these days.

Thanks,
Dan

[1]: http://git.kernel.org/?p=linux/kernel/git/djbw/xscaleiop.git;a=commitdiff;h=a7d124f5 

 drivers/serial/8250.c |   38 +++++++++++++++++++++++++++++++++++---
 1 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index b1ae774..2c440d1 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -547,6 +547,38 @@ serial_out_sync(struct uart_8250_port *up, int offset, int value)
 	(up->port.serial_in(&(up)->port, (offset)))
 #define serial_out(up, offset, value)	\
 	(up->port.serial_out(&(up)->port, (offset), (value)))
+
+#ifndef CONFIG_ARCH_IOP13XX
+#define iir_int_status(up) serial_in((up), UART_IIR)
+#else
+/* A silicon issue on IOP13XX causes IIR reads to return UART_IIR_NO_INT
+ * even if an interrupt is pending. Use the system interrupt pending
+ * register to check for servicing as a workaround.
+ */
+#include <mach/irqs.h>
+static unsigned int iir_int_status(struct uart_8250_port *up)
+{
+	unsigned long membase = (unsigned long) up->port.membase;
+	unsigned long ipnd, iir;
+
+	ipnd = read_intpnd_1();
+	iir = UART_IIR_NO_INT;
+
+	if (membase == IOP13XX_UART0_VIRT) {
+		if (ipnd & (1 << (IRQ_IOP13XX_UART0 - 32)))
+			iir &= ~UART_IIR_NO_INT;
+	} else if (membase == IOP13XX_UART1_VIRT) {
+		if (ipnd & (1 << (IRQ_IOP13XX_UART1 - 32)))
+			iir &= ~UART_IIR_NO_INT;
+	} else
+		BUG();
+
+	/* clear the interrupt via the LSR */
+	mem_serial_in(&up->port, UART_LSR);
+	return iir;
+}
+#endif
+
 /*
  * We used to support using pause I/O for certain machines.  We
  * haven't supported this for a while, but just in case it's badly
@@ -1572,7 +1604,7 @@ static irqreturn_t serial8250_interrupt(int irq, void *dev_id)
 
 		up = list_entry(l, struct uart_8250_port, list);
 
-		iir = serial_in(up, UART_IIR);
+		iir = iir_int_status(up);
 		if (!(iir & UART_IIR_NO_INT)) {
 			serial8250_handle_port(up);
 
@@ -1732,7 +1764,7 @@ static void serial8250_timeout(unsigned long data)
 	struct uart_8250_port *up = (struct uart_8250_port *)data;
 	unsigned int iir;
 
-	iir = serial_in(up, UART_IIR);
+	iir = iir_int_status(up);
 	if (!(iir & UART_IIR_NO_INT))
 		serial8250_handle_port(up);
 	mod_timer(&up->timer, jiffies + poll_timeout(up->port.timeout));
@@ -1753,7 +1785,7 @@ static void serial8250_backup_timeout(unsigned long data)
 		serial_out(up, UART_IER, 0);
 	}
 
-	iir = serial_in(up, UART_IIR);
+	iir = iir_int_status(up);
 
 	/*
 	 * This should be a safe test for anyone who doesn't trust the

