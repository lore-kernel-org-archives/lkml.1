Return-Path: <linux-kernel-owner+w=401wt.eu-S1763409AbXJEPpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763409AbXJEPpP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 11:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763536AbXJEPog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 11:44:36 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:36255
	"EHLO ghaskins-t60p.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1763422AbXJEPoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 11:44:32 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 2/2] SERIAL_CONSOLE: Add support for running console rx
	interrupts directly
To: mingo@elte.hu, tglx@linutronix.de, rostedt@goodmis.org
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       ghaskins@novell.com
Date: Fri, 05 Oct 2007 11:42:14 -0400
Message-ID: <20071005154214.24349.22023.stgit@ghaskins-t60p.haskins.net>
In-Reply-To: <20071005153517.24349.62653.stgit@ghaskins-t60p.haskins.net>
References: <20071005153517.24349.62653.stgit@ghaskins-t60p.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows serial console interrupts to be optionally handled in
interrupt context directly instead of dispatching a thread.  It is only
applicable when IRQs are threaded, and is thus predicated on PREEMPT_HARDIRQS.

This modification can be useful for allowing tools like sysrq to get
through more reliably.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 drivers/char/sysrq.c        |    8 +
 drivers/serial/8250.c       |  239 ++++++++++++++++++++++++++++++++++---------
 drivers/serial/8250.h       |    6 +
 drivers/serial/Kconfig      |   16 +++
 include/linux/serial_core.h |    8 +
 5 files changed, 223 insertions(+), 54 deletions(-)

diff --git a/drivers/char/sysrq.c b/drivers/char/sysrq.c
index 37d670d..40d6fcf 100644
--- a/drivers/char/sysrq.c
+++ b/drivers/char/sysrq.c
@@ -325,8 +325,14 @@ static struct sysrq_key_op sysrq_unrt_op = {
 	.enable_mask	= SYSRQ_ENABLE_RTNICE,
 };
 
+#ifdef CONFIG_SERIAL_8250_CONSOLE_RAWIRQ
+#define DEFINE_SYSRQ_SPINLOCK DEFINE_RAW_SPINLOCK
+#else
+#define DEFINE_SYSRQ_SPINLOCK DEFINE_SPINLOCK
+#endif
+
 /* Key Operations table and lock */
-static DEFINE_SPINLOCK(sysrq_key_table_lock);
+static DEFINE_SYSRQ_SPINLOCK(sysrq_key_table_lock);
 
 static struct sysrq_key_op *sysrq_key_table[36] = {
 	&sysrq_loglevel_op,		/* 0 */
diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index e443098..85af4d2 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -53,6 +53,8 @@
  */
 static unsigned int share_irqs = SERIAL8250_SHARE_IRQS;
 
+static unsigned int raw_irqs = SERIAL_8250_CONSOLE_RAWIRQ;
+
 static unsigned int nr_uarts = CONFIG_SERIAL_8250_RUNTIME_UARTS;
 
 /*
@@ -116,6 +118,21 @@ static unsigned long probe_rsa[PORT_RSA_MAX];
 static unsigned int probe_rsa_count;
 #endif /* CONFIG_SERIAL_8250_RSA  */
 
+struct uart_8250_char {
+	unsigned int status;
+	unsigned int overrun;
+	unsigned int ch;
+};
+
+#define SERIAL8250_RINGSIZE 1024
+
+struct uart_8250_ring {
+	unsigned int          head;
+	unsigned int          tail;
+	unsigned int          count;
+	struct uart_8250_char data[SERIAL8250_RINGSIZE];
+};
+
 struct uart_8250_port {
 	struct uart_port	port;
 	struct timer_list	timer;		/* "no irq" timer */
@@ -145,10 +162,21 @@ struct uart_8250_port {
 	 */
 	void			(*pm)(struct uart_port *port,
 				      unsigned int state, unsigned int old);
+
+	void                    (*rx_char)(struct uart_8250_port *up,
+					   unsigned int status,
+					   unsigned int overrun,
+					   unsigned int ch);
+	void                    (*rx_kick)(struct uart_8250_port *up);
+
+#ifdef CONFIG_SERIAL_8250_CONSOLE_RAWIRQ
+	struct tasklet_struct   rx_task;
+	struct uart_8250_ring   ring;
+#endif
 };
 
 struct irq_info {
-	spinlock_t		lock;
+	uart_spinlock_t		lock;
 	struct list_head	*head;
 };
 
@@ -1311,6 +1339,137 @@ static void serial8250_enable_ms(struct uart_port *port)
 }
 
 static void
+serial8250_direct_rx_char(struct uart_8250_port *up, unsigned int lsr,
+			  unsigned int overrun, unsigned int ch)
+{
+	char flag = TTY_NORMAL;
+	char xmit = 1;
+	unsigned long flags;
+	
+	spin_lock_irqsave(&up->port.lock, flags);
+	
+	up->port.icount.rx++;
+	
+#ifdef CONFIG_SERIAL_8250_CONSOLE
+	/*
+	 * Recover the break flag from console xmit
+	 */
+	if (up->port.line == up->port.cons->index) {
+		lsr |= up->lsr_break_flag;
+		up->lsr_break_flag = 0;
+	}
+#endif
+	
+	if (unlikely(lsr & (UART_LSR_BI | UART_LSR_PE |
+			    UART_LSR_FE | UART_LSR_OE))) {
+		/*
+		 * For statistics only
+		 */
+		if (lsr & UART_LSR_BI) {
+			lsr &= ~(UART_LSR_FE | UART_LSR_PE);
+			up->port.icount.brk++;
+			/*
+			 * We do the SysRQ and SAK checking
+			 * here because otherwise the break
+			 * may get masked by ignore_status_mask
+			 * or read_status_mask.
+			 */
+			if (uart_handle_break(&up->port))
+				xmit = 0;
+		} else if (lsr & UART_LSR_PE)
+			up->port.icount.parity++;
+		else if (lsr & UART_LSR_FE)
+			up->port.icount.frame++;
+		if (lsr & UART_LSR_OE)
+			up->port.icount.overrun++;
+		
+		/*
+		 * Mask off conditions which should be ignored.
+		 */
+		lsr &= up->port.read_status_mask;
+		
+		if (lsr & UART_LSR_BI) {
+			DEBUG_INTR("handling break....");
+			flag = TTY_BREAK;
+		} else if (lsr & UART_LSR_PE)
+			flag = TTY_PARITY;
+		else if (lsr & UART_LSR_FE)
+			flag = TTY_FRAME;
+	}
+	
+	spin_unlock_irqrestore(&up->port.lock, flags);
+	
+	if (xmit)
+		uart_insert_char(&up->port, lsr, UART_LSR_OE, ch, flag);
+}
+
+static void
+serial8250_direct_rx_kick(struct uart_8250_port *up)
+{
+	tty_flip_buffer_push(up->port.info->tty);
+}
+
+#ifdef CONFIG_SERIAL_8250_CONSOLE_RAWIRQ
+static void raw_rx_handler(unsigned long data)
+{
+	struct uart_8250_port *up   = (struct uart_8250_port *)data;
+	struct uart_8250_ring *ring = &up->ring;
+	unsigned long flags;
+	
+	spin_lock_irqsave(&up->port.lock, flags);
+	
+	while(ring->count) {
+		struct uart_8250_char c = ring->data[ring->tail];
+		
+		ring->tail++;
+		ring->tail %= SERIAL8250_RINGSIZE;
+		ring->count--;
+		
+		spin_unlock_irqrestore(&up->port.lock, flags);
+		
+		serial8250_direct_rx_char(up, c.status, c.overrun, c.ch);
+		
+		spin_lock_irqsave(&up->port.lock, flags);
+	}
+	
+	spin_unlock_irqrestore(&up->port.lock, flags);
+	
+	serial8250_direct_rx_kick(up);
+}
+
+static void
+serial8250_raw_rx_char(struct uart_8250_port *up, unsigned int status,
+		       unsigned int overrun, unsigned int ch)
+{
+	struct uart_8250_ring *ring = &up->ring;
+	struct uart_8250_char *c;
+	
+	spin_lock_bh(&up->port.lock);
+	
+	if (ring->count == SERIAL8250_RINGSIZE)
+		goto out;
+	
+	c = &ring->data[ring->head];
+	c->status  = status;
+	c->overrun = overrun;
+	c->ch      = ch;
+	
+	ring->head++;
+	ring->head %= SERIAL8250_RINGSIZE;
+	ring->count++;
+	
+ out:
+	spin_unlock_bh(&up->port.lock);
+}
+
+static void
+serial8250_raw_rx_kick(struct uart_8250_port *up)
+{
+	tasklet_schedule(&up->rx_task);
+}
+#endif
+
+static void
 receive_chars(struct uart_8250_port *up, unsigned int *status)
 {
 	struct tty_struct *tty = up->port.info->tty;
@@ -1319,59 +1478,19 @@ receive_chars(struct uart_8250_port *up, unsigned int *status)
 	char flag;
 
 	do {
-		ch = __serial_inp(up, UART_RX);
-		flag = TTY_NORMAL;
-		up->port.icount.rx++;
-
-		lsr |= up->lsr_saved_flags;
-		up->lsr_saved_flags = 0;
-
-		if (unlikely(lsr & UART_LSR_BRK_ERROR_BITS)) {
-			/*
-			 * For statistics only
-			 */
-			if (lsr & UART_LSR_BI) {
-				lsr &= ~(UART_LSR_FE | UART_LSR_PE);
-				up->port.icount.brk++;
-				/*
-				 * We do the SysRQ and SAK checking
-				 * here because otherwise the break
-				 * may get masked by ignore_status_mask
-				 * or read_status_mask.
-				 */
-				if (uart_handle_break(&up->port))
-					goto ignore_char;
-			} else if (lsr & UART_LSR_PE)
-				up->port.icount.parity++;
-			else if (lsr & UART_LSR_FE)
-				up->port.icount.frame++;
-			if (lsr & UART_LSR_OE)
-				up->port.icount.overrun++;
+		ch = serial_inp(up, UART_RX);
 
-			/*
-			 * Mask off conditions which should be ignored.
-			 */
-			lsr &= up->port.read_status_mask;
-
-			if (lsr & UART_LSR_BI) {
-				DEBUG_INTR("handling break....");
-				flag = TTY_BREAK;
-			} else if (lsr & UART_LSR_PE)
-				flag = TTY_PARITY;
-			else if (lsr & UART_LSR_FE)
-				flag = TTY_FRAME;
-		}
 		if (uart_handle_sysrq_char(&up->port, ch))
 			goto ignore_char;
 
-		uart_insert_char(&up->port, lsr, UART_LSR_OE, ch, flag);
+		up->rx_char(up, lsr, UART_LSR_OE, ch);
 
 	ignore_char:
-		lsr = __serial_inp(up, UART_LSR);
+		lsr = serial_inp(up, UART_LSR);
 	} while ((lsr & UART_LSR_DR) && (max_count-- > 0));
-	spin_unlock(&up->port.lock);
-	tty_flip_buffer_push(tty);
-	spin_lock(&up->port.lock);
+
+	up->rx_kick(up);
+
 	*status = lsr;
 }
 
@@ -1445,14 +1564,15 @@ serial8250_handle_port(struct uart_8250_port *up)
 	unsigned int status;
 	unsigned long flags;
 
-	spin_lock_irqsave(&up->port.lock, flags);
-
-	status = __serial_inp(up, UART_LSR);
+	status = serial_inp(up, UART_LSR);
 
 	DEBUG_INTR("status = %x...", status);
 
 	if (status & UART_LSR_DR)
 		receive_chars(up, &status);
+
+	spin_lock_irqsave(&up->port.lock, flags);
+
 	check_modem_status(up);
 	if (status & UART_LSR_THRE)
 		transmit_chars(up);
@@ -1568,6 +1688,9 @@ static int serial_link_irq_chain(struct uart_8250_port *up)
 	struct irq_info *i = irq_lists + up->port.irq;
 	int ret, irq_flags = up->port.flags & UPF_SHARE_IRQ ? IRQF_SHARED : 0;
 
+	if (raw_irqs)
+		irq_flags |= IRQF_NODELAY;
+
 	spin_lock_irq(&i->lock);
 
 	if (i->head) {
@@ -2851,6 +2974,18 @@ int serial8250_register_port(struct uart_port *port)
 		if (port->dev)
 			uart->port.dev = port->dev;
 
+#ifdef CONFIG_SERIAL_8250_CONSOLE_RAWIRQ
+		tasklet_init(&uart->rx_task, raw_rx_handler,
+			     (unsigned long)uart);
+		memset(&uart->ring, 0, sizeof(uart->ring));
+		uart->rx_char = serial8250_raw_rx_char;
+		uart->rx_kick = serial8250_raw_rx_kick;
+#else
+		uart->rx_char = serial8250_direct_rx_char;
+		uart->rx_kick = serial8250_direct_rx_kick;
+
+#endif
+
 		ret = uart_add_one_port(&serial8250_reg, &uart->port);
 		if (ret == 0)
 			ret = uart->port.line;
@@ -2894,8 +3029,8 @@ static int __init serial8250_init(void)
 		nr_uarts = UART_NR;
 
 	printk(KERN_INFO "Serial: 8250/16550 driver $Revision: 1.90 $ "
-		"%d ports, IRQ sharing %sabled\n", nr_uarts,
-		share_irqs ? "en" : "dis");
+		"%d ports, IRQ: sharing=%sabled, mode=%s\n", nr_uarts,
+		share_irqs ? "en" : "dis", raw_irqs ? "raw" : "normal");
 
 	for (i = 0; i < NR_IRQS; i++)
 		spin_lock_init(&irq_lists[i].lock);
diff --git a/drivers/serial/8250.h b/drivers/serial/8250.h
index 91bd28f..2f5aacf 100644
--- a/drivers/serial/8250.h
+++ b/drivers/serial/8250.h
@@ -61,6 +61,12 @@ struct serial8250_config {
 #define SERIAL8250_SHARE_IRQS 0
 #endif
 
+#ifdef CONFIG_SERIAL_8250_CONSOLE_RAWIRQ
+#define SERIAL_8250_CONSOLE_RAWIRQ 1
+#else
+#define SERIAL_8250_CONSOLE_RAWIRQ 0
+#endif
+
 #if defined(__alpha__) && !defined(CONFIG_PCI)
 /*
  * Digital did something really horribly wrong with the OUT1 and OUT2
diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index 81b52b7..3f095f2 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -78,6 +78,22 @@ config FIX_EARLYCON_MEM
 	depends on X86
 	default y
 
+config SERIAL_8250_CONSOLE_RAWIRQ
+       bool "Disable serial console IRQ threading"
+       depends on SERIAL_8250_CONSOLE=y && PREEMPT_HARDIRQS
+       default n
+       ---help---
+        If you say Y here, serial console interrupts will be handled in
+        interrupt context directly instead of dispatching a thread.  This can
+        be useful for allowing tools like sysrq to get through more reliably.
+
+        Enabling this option may have a detrimental effect on latency
+        sensitive workloads.  It should only be used when sysrq is needed to
+        break into systems where threaded-irqs are not being serviced in a
+        timely manner.
+
+        If unsure, say N
+
 config SERIAL_8250_GSC
 	tristate
 	depends on SERIAL_8250 && GSC
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 09d17b0..b2b9d43 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -225,8 +225,14 @@ struct uart_icount {
 
 typedef unsigned int __bitwise__ upf_t;
 
+#ifdef CONFIG_SERIAL_8250_CONSOLE_RAWIRQ
+typedef raw_spinlock_t uart_spinlock_t;
+#else
+typedef spinlock_t uart_spinlock_t;
+#endif
+
 struct uart_port {
-	spinlock_t		lock;			/* port lock */
+	uart_spinlock_t		lock;			/* port lock */
 	unsigned int		iobase;			/* in/out[bwl] */
 	unsigned char __iomem	*membase;		/* read/write[bwl] */
 	unsigned int		irq;			/* irq number */

