Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab0BTSY7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 13:24:59 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:48027 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752402Ab0BTSY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 13:24:57 -0500
Date: Sat, 20 Feb 2010 18:24:53 +0000
From: Marc Zyngier <maz@misterjones.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "Joachim Eastwood" <Joachim.Eastwood@jotron.com>
Subject: [RFC][PATCH] genirq: Introduce IRQF_ALLOW_NESTED flag for
 request_irq()
Message-ID: <20100220182453.132993be@taxman.wild-wind.fr.eu.org>
Organization: Metropolis -- Nowhere
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 77.203.141.186
X-SA-Exim-Rcpt-To: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu, Joachim.Eastwood@jotron.com
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on inca-roads.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we enjoy threaded interrupts, we're starting to see irq_chip
implementations (wm831x, pca953x) that make use of threaded interrupts
for the controller, and nested interrupts for the client interrupt. It
all works very well, with one drawback:

Drivers requesting an IRQ must now know whether the handler will
run in a thread context of not, and call request_threaded_irq() or
request_irq() accordingly.

The problem is that the requesting driver sometimes doesn't know
about the nature of the interrupt, specially when the interrupt
controller is a discrete chip (typically a GPIO expander connected
over I2C) that can be connected to a wide variety of otherwise perfectly
supported hardware.

The following patch introduces the IRQF_ALLOW_NESTED flag, that acts
as a "contract" between the driver and the genirq framework. By using
this flag as part of the request_irq() call, the driver informs the genirq
framework that the handler will happily run either in hardirq or nested
context, without any ill effect.

The benefit of this is a single API for drivers. It still requires
the driver to be audited, and the flag added to the request_irq() call.

Of course, this goes against Linus choice of having separate APIs
for both cases. The only alternative I can imagine for this is to
use request_threaded_irq() with the same function provided for both the
handler and the threaded handler. Ugly...

This patch has been tested on ARM and Blackfin platforms.

Signed-off-by: Marc Zyngier <maz@misterjones.org>
Tested-by: Joachim Eastwood <joachim.eastwood@jotron.com>
---
 include/linux/interrupt.h |    3 +++
 kernel/irq/manage.c       |   12 +++++++++---
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 75f3f00..d166e24 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -52,6 +52,8 @@
  * IRQF_ONESHOT - Interrupt is not reenabled after the hardirq handler finished.
  *                Used by threaded interrupts which need to keep the
  *                irq line disabled until the threaded handler has been run.
+ * IRQF_ALLOW_NESTED - Handler can be either run as hardirq or nested
+ *		       interrupt.
  */
 #define IRQF_DISABLED		0x00000020
 #define IRQF_SAMPLE_RANDOM	0x00000040
@@ -62,6 +64,7 @@
 #define IRQF_NOBALANCING	0x00000800
 #define IRQF_IRQPOLL		0x00001000
 #define IRQF_ONESHOT		0x00002000
+#define IRQF_ALLOW_NESTED	0x00004000
 
 /*
  * Bits used by threaded handlers:
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index eb6078c..3635276 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -641,12 +641,18 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 
 	/*
 	 * Check whether the interrupt nests into another interrupt
-	 * thread.
+	 * thread. Nested interrupt must provide a thread function
+	 * unless it raises the IRQF_ALLOW_NESTED flag.
 	 */
 	nested = desc->status & IRQ_NESTED_THREAD;
 	if (nested) {
-		if (!new->thread_fn)
-			return -EINVAL;
+		if (!new->thread_fn) {
+			if (new->flags & IRQF_ALLOW_NESTED)
+				new->thread_fn = new->handler;
+			else
+				return -EINVAL;
+		}
+
 		/*
 		 * Replace the primary handler which was provided from
 		 * the driver for non nested interrupt handling by the
-- 
1.7.0



-- 
I'm the slime oozin' out from your TV set...
