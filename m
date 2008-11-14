Return-Path: <linux-kernel-owner+w=401wt.eu-S1755092AbYKNVh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092AbYKNVh1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 16:37:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755873AbYKNVey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 16:34:54 -0500
Received: from science.horizon.com ([192.35.100.1]:14872 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755804AbYKNVev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 16:34:51 -0500
Message-ID: <20081114213449.14960.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
Date: Fri, 14 Nov 2008 16:34:49 -0500
To: linux-kernel@vger.kernel.org
Cc: linux@horizon.com
Subject: [RFC 2/2] serial/8250.c: Use self-adjusting list for port poll
 order.
References: <20081113150308.3590.qmail@science.horizon.com>
 <20081114053042.11532.qmail@science.horizon.com>
 <20081114053314.12093.qmail@science.horizon.com>
In-Reply-To: <20081114053314.12093.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I posted this to linux-serial yesterday, but it has attracted no comment
yet, so I'm submitting it to a wider audience.  It boots and runs on
amd64 with a standard (non-shared) serial port, but I haven't subjected
it to detailed testing.  Comments about the code style and general idea
are requested.

This is the interesting patch.  It changes the uart_8250_port list to
a self-adjusting one.  Busy ports move to the front, and idle ones
migrate to the end.  This reduces overall polling effort when there is
a mix of busy and idle ports.

Any time you're dealing with an edge-sensitive interrupt, it is essential
that the interrupt is turned off before returning from the handler.
With a level-sensitive one, you'll just loop back into the handler,
but an edge-sensitive one will never respond again.

When there are multiple independent sources, that means that you have to
poll them all repeatedly until everyone reports idle.  Since interrupts don't
go away by themselves, that means that there was an instant, just before
the final pass started, when there were no active interrupt sources.

Now on modern computers even PCI bus reads are painfully slow, and
super-I/O chips connected via the "LPC bus" low-pin count emulated ISA
bus (basically a 4-bit/33 MHz bus which acts like a 16-bit/8.33 MHz
ISA bus) are truly agonizing.

We can't get around the need to poll every port sharing the same IRQ line,
but if we can predict which ports will be busy and poll them first,
we can start the final verification pass as early as possible.

This code does that by using the previous poll cycles as a hint.
If a port is idle, it will migrate to the end of the list and
only have to be checked once.

Part 1 changed the list to singly-linked to make the list shuffling easier.

Comments?  Please?

---
 drivers/serial/8250.c |   49 ++++++++++++++++++++++++++++++++++---------------
 1 files changed, 34 insertions(+), 15 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 7f66335..96e784f 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -1469,18 +1469,27 @@ serial8250_handle_port(struct uart_8250_port *up)
  * "end" points to the beginning of the most recent run of idle ports.
  * It is NULL if the current port is not idle.  The loop ends when we
  * are about to check end again.
+ *
+ * Optimization: this will finish sooner if we can check all busy
+ * ports first, starting the final verify-idle pass as soon as possible.
+ * To achieve this, busy ports are moved to the front of the list.
+ * *tailp marks the boundary between the front and the back of the list;
+ * when a port is found to be busy, it is removed from between *upp
+ * and upp->next, and reinserted at *tailp.
  */
 static irqreturn_t serial8250_interrupt(int irq, void *dev_id)
 {
 	struct irq_info *i = dev_id;
-	struct uart_8250_port *up, *end = NULL;
+	struct uart_8250_port *up, **upp, *end = NULL, **tailp;
 	int pass_counter = 0, handled = 0;
 
 	DEBUG_INTR("serial8250_interrupt(%d)...", irq);
 
+	tailp = upp = &i->head;
+
 	spin_lock(&i->lock);
 
-	up = i->head;
+	up = *upp;
 	do {
 		unsigned int iir;
 
@@ -1491,7 +1500,7 @@ static irqreturn_t serial8250_interrupt(int irq, void *dev_id)
 					"irq%d\n", irq);
 				break;
 			}
-			up = i->head;
+			tailp = upp = &i->head;
 			continue;
 		}
 
@@ -1499,11 +1508,8 @@ static irqreturn_t serial8250_interrupt(int irq, void *dev_id)
 		if (!(iir & UART_IIR_NO_INT)) {
 			serial8250_handle_port(up);
 
-			handled = 1;
-
-			end = NULL;
-		} else if (up->port.iotype == UPIO_DWAPB &&
-			  (iir & UART_IIR_BUSY) == UART_IIR_BUSY) {
+		} else if ((iir & UART_IIR_BUSY) == UART_IIR_BUSY &&
+			   up->port.iotype == UPIO_DWAPB) {
 			/* The DesignWare APB UART has an Busy Detect (0x07)
 			 * interrupt meaning an LCR write attempt occured
 			 * while the UART was busy. The interrupt must
@@ -1513,14 +1519,27 @@ static irqreturn_t serial8250_interrupt(int irq, void *dev_id)
 			status = *(volatile u32 *)up->port.private_data;
 			serial_out(up, UART_LCR, up->lcr);
 
-			handled = 1;
-
-			end = NULL;
-		} else if (end == NULL)
-			end = up;
+		} else {
+			/* Port does not have interrupt asserted. */
+			if (end == NULL)
+				end = up;	/* Start of run of idle ports */
+			upp = &up->next;	/* Do not move anything */
+			continue;
+		}
 
-		up = up->next;
-	} while (up != end);
+		/* up had activity */
+		handled = 1;
+		end = NULL;
+		/* Move to front of list; append after *tailp */
+		if (tailp != upp) {
+			*upp = up->next;
+			up->next = *tailp;
+			*tailp = up;
+			tailp = &up->next;
+		} else {
+			tailp = upp = &up->next;
+		}
+	} while ((up = *upp) != end);
 
 	spin_unlock(&i->lock);
 
-- 
1.5.6.5
