Return-Path: <linux-kernel-owner+w=401wt.eu-S1756239AbYJEQGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239AbYJEQGZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754820AbYJEQFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:05:17 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54842 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754700AbYJEQFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:05:13 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 05/76] 8250: Remove NR_IRQ usage
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:05:13 +0100
Message-ID: <20081005160509.1997.88329.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are plans afoot to make the IRQ ranges dynamic. In that situation we
don't want drivers having their own huge arrays for per IRQ data so use a hash


Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/serial/68328serial.c |   11 +-----
 drivers/serial/8250.c        |   74 +++++++++++++++++++++++++++++++++---------
 2 files changed, 60 insertions(+), 25 deletions(-)

diff --git a/drivers/serial/68328serial.c b/drivers/serial/68328serial.c
index 381b12a..277b78d 100644
--- a/drivers/serial/68328serial.c
+++ b/drivers/serial/68328serial.c
@@ -66,7 +66,6 @@
 #endif
 
 static struct m68k_serial m68k_soft[NR_PORTS];
-struct m68k_serial *IRQ_ports[NR_IRQS];
 
 static unsigned int uart_irqs[NR_PORTS] = UART_IRQ_DEFNS;
 
@@ -375,15 +374,11 @@ clear_and_return:
  */
 irqreturn_t rs_interrupt(int irq, void *dev_id)
 {
-	struct m68k_serial * info;
+	struct m68k_serial * info = dev_id;
 	m68328_uart *uart;
 	unsigned short rx;
 	unsigned short tx;
 
-	info = IRQ_ports[irq];
-	if(!info)
-	    return IRQ_NONE;
-
 	uart = &uart_addr[info->line];
 	rx = uart->urx.w;
 
@@ -1383,8 +1378,6 @@ rs68328_init(void)
 		   info->port, info->irq);
 	    printk(" is a builtin MC68328 UART\n");
 	    
-	    IRQ_ports[info->irq] = info;	/* waste of space */
-
 #ifdef CONFIG_M68VZ328
 		if (i > 0 )
 			PJSEL &= 0xCF;  /* PSW enable second port output */
@@ -1393,7 +1386,7 @@ rs68328_init(void)
 	    if (request_irq(uart_irqs[i],
 			    rs_interrupt,
 			    IRQF_DISABLED,
-			    "M68328_UART", NULL))
+			    "M68328_UART", info))
                 panic("Unable to attach 68328 serial interrupt\n");
 	}
 	local_irq_restore(flags);
diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 9ccc563..9f5e60d 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -39,7 +39,7 @@
 #include <linux/nmi.h>
 #include <linux/mutex.h>
 
-#include <asm/io.h>
+#include <linux/io.h>
 #include <asm/irq.h>
 
 #include "8250.h"
@@ -145,11 +145,15 @@ struct uart_8250_port {
 };
 
 struct irq_info {
-	spinlock_t		lock;
+	struct			hlist_node node;
+	int			irq;
+	spinlock_t		lock;	/* Protects list not the hash */
 	struct list_head	*head;
 };
 
-static struct irq_info irq_lists[NR_IRQS];
+#define NR_IRQ_HASH		32	/* Can be adjusted later */
+static struct hlist_head irq_lists[NR_IRQ_HASH];
+static DEFINE_MUTEX(hash_mutex);	/* Used to walk the hash */
 
 /*
  * Here we define the default xmit fifo size used for each type of UART.
@@ -266,7 +270,7 @@ static const struct serial8250_config uart_config[] = {
 	},
 };
 
-#if defined (CONFIG_SERIAL_8250_AU1X00)
+#if defined(CONFIG_SERIAL_8250_AU1X00)
 
 /* Au1x00 UART hardware has a weird register layout */
 static const u8 au_io_in_map[] = {
@@ -1535,15 +1539,43 @@ static void serial_do_unlink(struct irq_info *i, struct uart_8250_port *up)
 		BUG_ON(i->head != &up->list);
 		i->head = NULL;
 	}
-
 	spin_unlock_irq(&i->lock);
+	/* List empty so throw away the hash node */
+	if (i->head == NULL) {
+		hlist_del(&i->node);
+		kfree(i);
+	}
 }
 
 static int serial_link_irq_chain(struct uart_8250_port *up)
 {
-	struct irq_info *i = irq_lists + up->port.irq;
+	struct hlist_head *h;
+	struct hlist_node *n;
+	struct irq_info *i;
 	int ret, irq_flags = up->port.flags & UPF_SHARE_IRQ ? IRQF_SHARED : 0;
 
+	mutex_lock(&hash_mutex);
+
+	h = &irq_lists[up->port.irq % NR_IRQ_HASH];
+
+	hlist_for_each(n, h) {
+		i = hlist_entry(n, struct irq_info, node);
+		if (i->irq == up->port.irq)
+			break;
+	}
+
+	if (n == NULL) {
+		i = kzalloc(sizeof(struct irq_info), GFP_KERNEL);
+		if (i == NULL) {
+			mutex_unlock(&hash_mutex);
+			return -ENOMEM;
+		}
+		spin_lock_init(&i->lock);
+		i->irq = up->port.irq;
+		hlist_add_head(&i->node, h);
+	}
+	mutex_unlock(&hash_mutex);
+
 	spin_lock_irq(&i->lock);
 
 	if (i->head) {
@@ -1567,14 +1599,27 @@ static int serial_link_irq_chain(struct uart_8250_port *up)
 
 static void serial_unlink_irq_chain(struct uart_8250_port *up)
 {
-	struct irq_info *i = irq_lists + up->port.irq;
+	struct irq_info *i;
+	struct hlist_node *n;
+	struct hlist_head *h;
 
-	BUG_ON(i->head == NULL);
+	mutex_lock(&hash_mutex);
+
+	h = &irq_lists[up->port.irq % NR_IRQ_HASH];
+
+	hlist_for_each(n, h) {
+		i = hlist_entry(n, struct irq_info, node);
+		if (i->irq == up->port.irq)
+			break;
+	}
 
+	BUG_ON(n == NULL);
+	BUG_ON(i->head == NULL);
+	
 	if (list_empty(i->head))
 		free_irq(up->port.irq, i);
-
 	serial_do_unlink(i, up);
+	mutex_unlock(&hash_mutex);
 }
 
 /* Base timer interval for polling */
@@ -2950,7 +2995,7 @@ EXPORT_SYMBOL(serial8250_unregister_port);
 
 static int __init serial8250_init(void)
 {
-	int ret, i;
+	int ret;
 
 	if (nr_uarts > UART_NR)
 		nr_uarts = UART_NR;
@@ -2959,9 +3004,6 @@ static int __init serial8250_init(void)
 		"%d ports, IRQ sharing %sabled\n", nr_uarts,
 		share_irqs ? "en" : "dis");
 
-	for (i = 0; i < NR_IRQS; i++)
-		spin_lock_init(&irq_lists[i].lock);
-
 	ret = uart_register_driver(&serial8250_reg);
 	if (ret)
 		goto out;
@@ -2984,11 +3026,11 @@ static int __init serial8250_init(void)
 		goto out;
 
 	platform_device_del(serial8250_isa_devs);
- put_dev:
+put_dev:
 	platform_device_put(serial8250_isa_devs);
- unreg_uart_drv:
+unreg_uart_drv:
 	uart_unregister_driver(&serial8250_reg);
- out:
+out:
 	return ret;
 }
 

