Return-Path: <linux-kernel-owner+w=401wt.eu-S1755350AbYHJHiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbYHJHiL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 03:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753589AbYHJHhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 03:37:25 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:7020 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbYHJHhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 03:37:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=AR5ANjDUHO9eEYfOUKWjGJpqK1WLQSByTJ7gRr61HvIQ3XA+2JiySx+N+TyvsoGXrJ
         ByJH6ORByMFPo0yhF+kbqV1z4t+c/Q2DQ3MZOMht1dup1ZVKtB5/9OLaFU64VrOMqdfs
         8ohUdDmPVKce/qtgmKV61tqPBKolJ3USe/o/4=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@redhat.com>
Subject: [PATCH 02/43] 8250: Remove NR_IRQ usage
Date: Sun, 10 Aug 2008 00:35:51 -0700
Message-Id: <1218353792-3355-3-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218353792-3355-2-git-send-email-yhlu.kernel@gmail.com>
References: <1218353792-3355-1-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-2-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>

Works on my test box with a quick test.

From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
---
 drivers/serial/68328serial.c |   11 +-----
 drivers/serial/8250.c        |   67 ++++++++++++++++++++++++++++++++++-------
 2 files changed, 57 insertions(+), 21 deletions(-)

diff --git a/drivers/serial/68328serial.c b/drivers/serial/68328serial.c
index 381b12a..d935b2d 100644
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
+	struct m68k_serial *info = dev_id;
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
index 3a4d677..5da5cc0 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
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
@@ -1548,15 +1552,43 @@ static void serial_do_unlink(struct irq_info *i, struct uart_8250_port *up)
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
@@ -1580,14 +1612,28 @@ static int serial_link_irq_chain(struct uart_8250_port *up)
 
 static void serial_unlink_irq_chain(struct uart_8250_port *up)
 {
-	struct irq_info *i = irq_lists + up->port.irq;
+	struct irq_info *i;
+	struct hlist_node *n;
+	struct hlist_head *h;
 
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
+	BUG_ON(n == NULL);
 	BUG_ON(i->head == NULL);
 
 	if (list_empty(i->head))
 		free_irq(up->port.irq, i);
 
 	serial_do_unlink(i, up);
+	mutex_unlock(&hash_mutex);
 }
 
 /* Base timer interval for polling */
@@ -2955,7 +3001,7 @@ EXPORT_SYMBOL(serial8250_unregister_port);
 
 static int __init serial8250_init(void)
 {
-	int ret, i;
+	int ret;
 
 	if (nr_uarts > UART_NR)
 		nr_uarts = UART_NR;
@@ -2964,9 +3010,6 @@ static int __init serial8250_init(void)
 		"%d ports, IRQ sharing %sabled\n", nr_uarts,
 		share_irqs ? "en" : "dis");
 
-	for (i = 0; i < NR_IRQS; i++)
-		spin_lock_init(&irq_lists[i].lock);
-
 	ret = uart_register_driver(&serial8250_reg);
 	if (ret)
 		goto out;
@@ -2989,11 +3032,11 @@ static int __init serial8250_init(void)
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
 
-- 
1.5.4.5

