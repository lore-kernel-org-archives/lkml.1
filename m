Return-Path: <linux-kernel-owner+w=401wt.eu-S1754268AbYKNVYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbYKNVYQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 16:24:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbYKNVYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 16:24:00 -0500
Received: from science.horizon.com ([192.35.100.1]:13021 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751259AbYKNVX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 16:23:59 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Nov 2008 16:23:58 EST
Message-ID: <20081114211717.10873.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
Date: Fri, 14 Nov 2008 16:17:17 -0500
To: linux-kernel@vger.kernel.org
Cc: linux@horizon.com
Subject: [RFC 1/2] serial/8250.c: Change to singly linked handler chain.
References: <20081113150308.3590.qmail@science.horizon.com>
 <20081114053042.11532.qmail@science.horizon.com>
In-Reply-To: <20081114053042.11532.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I posted this to linux-serial yesterday, but it has attracted no comment
yet, so I'm submitting it to a wider audience.

This is a prerequisite to the interesting patch 2/2.  This boots and
runs, but only on a single-port interrupt, so that's not very good
testing.  It's out here for style comments.

This just converts the list of struct uart_8250_port attached to a single
IRQ from doubly linked to singly.  It should have no behavior differences.


---
 drivers/serial/8250.c |   93 +++++++++++++++++++++++++++----------------------
 1 files changed, 51 insertions(+), 42 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 18caa95..7f66335 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -116,7 +116,7 @@ static unsigned int probe_rsa_count;
 struct uart_8250_port {
 	struct uart_port	port;
 	struct timer_list	timer;		/* "no irq" timer */
-	struct list_head	list;		/* ports on this IRQ */
+	struct uart_8250_port	*next;		/* ports on this IRQ */
 	unsigned short		capabilities;	/* port capabilities */
 	unsigned short		bugs;		/* port bugs */
 	unsigned int		tx_loadsz;	/* transmit fifo load size */
@@ -146,7 +146,7 @@ struct uart_8250_port {
 
 struct irq_info {
 	spinlock_t		lock;
-	struct list_head	*head;
+	struct uart_8250_port	*head;
 };
 
 static struct irq_info irq_lists[NR_IRQS];
@@ -1458,23 +1458,39 @@ serial8250_handle_port(struct uart_8250_port *up)
  *
  * This means we need to loop through all ports. checking that they
  * don't have an interrupt pending.
+ *
+ * Fencepost consideration: serial8250_handle_port only polls each
+ * interrupt source once; it does not itself loop until the port
+ * has deasserted the interrupt line.  Therefore, it is necessary to
+ * loop here until each port has had its IIR read in the idle state.
+ * "end" points to the beginning of the most recent run of idle ports.
+ * It is NULL if the current port is not idle.  The loop ends when we
+ * are about to check end again.
  */
 static irqreturn_t serial8250_interrupt(int irq, void *dev_id)
 {
 	struct irq_info *i = dev_id;
-	struct list_head *l, *end = NULL;
+	struct uart_8250_port *up, *end = NULL;
 	int pass_counter = 0, handled = 0;
 
 	DEBUG_INTR("serial8250_interrupt(%d)...", irq);
 
 	spin_lock(&i->lock);
 
-	l = i->head;
+	up = i->head;
 	do {
-		struct uart_8250_port *up;
 		unsigned int iir;
 
-		up = list_entry(l, struct uart_8250_port, list);
+		if (up == NULL) {
+			if (pass_counter++ > PASS_LIMIT) {
+				/* If we hit this, we're dead. */
+				printk(KERN_ERR "serial8250: too much work for "
+					"irq%d\n", irq);
+				break;
+			}
+			up = i->head;
+			continue;
+		}
 
 		iir = serial_in(up, UART_IIR);
 		if (!(iir & UART_IIR_NO_INT)) {
@@ -1486,9 +1505,10 @@ static irqreturn_t serial8250_interrupt(int irq, void *dev_id)
 		} else if (up->port.iotype == UPIO_DWAPB &&
 			  (iir & UART_IIR_BUSY) == UART_IIR_BUSY) {
 			/* The DesignWare APB UART has an Busy Detect (0x07)
-			 * interrupt meaning an LCR write attempt occured while the
-			 * UART was busy. The interrupt must be cleared by reading
-			 * the UART status register (USR) and the LCR re-written. */
+			 * interrupt meaning an LCR write attempt occured
+			 * while the UART was busy. The interrupt must
+			 * be cleared by reading the UART status register
+			 * (USR) and re-writing the LCR. */
 			unsigned int status;
 			status = *(volatile u32 *)up->port.private_data;
 			serial_out(up, UART_LCR, up->lcr);
@@ -1497,17 +1517,10 @@ static irqreturn_t serial8250_interrupt(int irq, void *dev_id)
 
 			end = NULL;
 		} else if (end == NULL)
-			end = l;
+			end = up;
 
-		l = l->next;
-
-		if (l == i->head && pass_counter++ > PASS_LIMIT) {
-			/* If we hit this, we're dead. */
-			printk(KERN_ERR "serial8250: too much work for "
-				"irq%d\n", irq);
-			break;
-		}
-	} while (l != end);
+		up = up->next;
+	} while (up != end);
 
 	spin_unlock(&i->lock);
 
@@ -1525,39 +1538,35 @@ static irqreturn_t serial8250_interrupt(int irq, void *dev_id)
  */
 static void serial_do_unlink(struct irq_info *i, struct uart_8250_port *up)
 {
+	struct uart_8250_port *p, **pptr = &i->head;
+
 	spin_lock_irq(&i->lock);
 
-	if (!list_empty(i->head)) {
-		if (i->head == &up->list)
-			i->head = i->head->next;
-		list_del(&up->list);
-	} else {
-		BUG_ON(i->head != &up->list);
-		i->head = NULL;
+	while ((p = *pptr) != up) {
+		BUG_ON(p == NULL);
+		pptr = &p->next;
 	}
 
+	*pptr = up->next;
+
 	spin_unlock_irq(&i->lock);
 }
 
 static int serial_link_irq_chain(struct uart_8250_port *up)
 {
 	struct irq_info *i = irq_lists + up->port.irq;
-	int ret, irq_flags = up->port.flags & UPF_SHARE_IRQ ? IRQF_SHARED : 0;
+	int ret = 0;
+	struct uart_8250_port *head;
 
 	spin_lock_irq(&i->lock);
+	up->next = head = i->head;
+	i->head = up;
+	spin_unlock_irq(&i->lock);
 
-	if (i->head) {
-		list_add(&up->list, i->head);
-		spin_unlock_irq(&i->lock);
-
-		ret = 0;
-	} else {
-		INIT_LIST_HEAD(&up->list);
-		i->head = &up->list;
-		spin_unlock_irq(&i->lock);
-
+	if (!head) {
+		int irq_flag = up->port.flags & UPF_SHARE_IRQ ? IRQF_SHARED : 0;
 		ret = request_irq(up->port.irq, serial8250_interrupt,
-				  irq_flags, "serial", i);
+				  irq_flag, "serial", i);
 		if (ret < 0)
 			serial_do_unlink(i, up);
 	}
@@ -1570,8 +1579,8 @@ static void serial_unlink_irq_chain(struct uart_8250_port *up)
 	struct irq_info *i = irq_lists + up->port.irq;
 
 	BUG_ON(i->head == NULL);
-
-	if (list_empty(i->head))
+	serial_do_unlink(i, up);
+	if (i->head == NULL);
 		free_irq(up->port.irq, i);
 
 	serial_do_unlink(i, up);
-- 
1.5.6.5
