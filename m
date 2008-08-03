Return-Path: <linux-kernel-owner+w=401wt.eu-S1757716AbYHCPdE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757716AbYHCPdE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 11:33:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756101AbYHCPcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 11:32:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57765 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755915AbYHCPcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 11:32:53 -0400
Date: Sun, 3 Aug 2008 16:14:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH 21/25] serial: change remove NR_IRQS in 8250.c v2
Message-ID: <20080803161447.791705bb@lxorguk.ukuu.org.uk>
In-Reply-To: <1217732365-16595-22-git-send-email-yhlu.kernel@gmail.com>
References: <1217732365-16595-1-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-8-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-9-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-10-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-11-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-12-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-13-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-14-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-15-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-16-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-17-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-18-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-19-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-20-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-21-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-22-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  2 Aug 2008 19:59:21 -0700
Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> use small array with index to handle irq locking for serial port
> hope 32 slot is enough


Untested alternative approach

8250: Remove NR_IRQ usage

From: Alan Cox <alan@redhat.com>


---

 drivers/serial/68328serial.c |   11 ++---------
 drivers/serial/8250.c        |   41 ++++++++++++++++++++++++++++++++++-------
 2 files changed, 36 insertions(+), 16 deletions(-)


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
index a97f1ae..7165e88 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -145,11 +145,14 @@ struct uart_8250_port {
 };
 
 struct irq_info {
-	spinlock_t		lock;
+	struct			irq_info *next;
+	int			irq;
+	spinlock_t		lock;	/* Protects list not the hash */
 	struct list_head	*head;
 };
 
-static struct irq_info irq_lists[NR_IRQS];
+static struct irq_info *irq_lists[NR_IRQ_HASH];
+static DEFINE_SPINLOCK(hash_lock);	/* Used to walk the hash */
 
 /*
  * Here we define the default xmit fifo size used for each type of UART.
@@ -1541,9 +1544,28 @@ static void serial_do_unlink(struct irq_info *i, struct uart_8250_port *up)
 
 static int serial_link_irq_chain(struct uart_8250_port *up)
 {
-	struct irq_info *i = irq_lists + up->port.irq;
+	struct irq_info **list, *i; 
 	int ret, irq_flags = up->port.flags & UPF_SHARE_IRQ ? IRQF_SHARED : 0;
 
+	spin_lock(&hash_lock);
+
+	list = &irq_lists[up->port.irq % NR_IRQ_HASH];
+	i = * list;
+
+	while(i != NULL && i->irq != up->port.irq)
+		i = i->next;
+	if (i == NULL) {
+		i = kzalloc(sizeof(struct irq_info), GFP_KERNEL);
+		if (i == NULL) {
+			spin_unlock(&hash_lock);
+			return -ENOMEM;
+		}
+		spin_lock_init(&i->lock);
+		i->next = *list;
+		*list = i;
+	}
+	spin_unlock(&hash_lock);
+
 	spin_lock_irq(&i->lock);
 
 	if (i->head) {
@@ -1567,8 +1589,16 @@ static int serial_link_irq_chain(struct uart_8250_port *up)
 
 static void serial_unlink_irq_chain(struct uart_8250_port *up)
 {
-	struct irq_info *i = irq_lists + up->port.irq;
+	struct irq_info *i;
+
+	spin_lock(&hash_lock);
 
+	i = irq_lists[up->port.irq % NR_IRQ_HASH];
+	while(i != NULL && i->irq != up->port.irq)
+		i = i->next;
+	spin_unlock(&hash_lock);
+
+	BUG_ON(i == NULL);
 	BUG_ON(i->head == NULL);
 
 	if (list_empty(i->head))
@@ -2951,9 +2981,6 @@ static int __init serial8250_init(void)
 		"%d ports, IRQ sharing %sabled\n", nr_uarts,
 		share_irqs ? "en" : "dis");
 
-	for (i = 0; i < NR_IRQS; i++)
-		spin_lock_init(&irq_lists[i].lock);
-
 	ret = uart_register_driver(&serial8250_reg);
 	if (ret)
 		goto out;
