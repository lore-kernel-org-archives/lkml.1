Return-Path: <linux-kernel-owner+w=401wt.eu-S1759631AbXEaKFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759631AbXEaKFM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 06:05:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757913AbXEaKE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 06:04:59 -0400
Received: from pollux.ds.pg.gda.pl ([153.19.208.7]:3568 "EHLO
	pollux.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755754AbXEaKE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 06:04:57 -0400
Date: Thu, 31 May 2007 11:04:53 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-mips@linux-mips.org, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] zs: Updates to fix issues raised
Message-ID: <Pine.LNX.4.64N.0705311023100.7856@blysk.ds.pg.gda.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 This is a set of fixes to the initial revision of the zs driver port to 
the serial subsystem.  They include an update to the recovery delay, and 
the race on interrupt handler registration.  As well as a number of style 
fixes throughout.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
Andrew,

 It looks like port_sem is not enough to protect against a race in the 
startup() call -- while the serial API spec refers to it as "an overall 
semaphore" as opposed to "per-port" as it documents the other locks, the 
actual code contradicts it. ;-)  I had to resist the temptation to use 
scc->zlock here as it leads to a spinlock recursion and hence a deadlock.  
The reason is with CONFIG_DEBUG_SHIRQ a call to zs_interrupt() is made 
from beneath request_irq() even though local interrupts are disabled.  
I'm not sure if it is intentional, a design limitation or a bug.  Anyway, 
using an atomic counter is better as it makes the duration of interrupts 
being disabled shorter.

 In the end I have not added the CON_BOOT flag, because this is a 
full-featured console driver, not an early one.  I have not updated 
printk() calls in zs_dump() either -- I figured out adding pr_info("") 
calls before the loops would add little value.  I fixed the other instance 
though.

 Removing "inline" clauses reduced the text size by about 50% ;-) and 
branches are essentially free on the R3000 and not that horribly expensive 
on the R4000/R4400 either -- which exhaust the possible CPU configurations 
for this driver at the moment (one day this driver could be used for DEC 
3000 AXP systems as well as they reuse the same setup of these bits).

 Please apply.

  Maciej

patch-2.6.22-rc2-serial-zs-fix-4
diff -up --recursive --new-file linux-2.6.22-rc2.macro/drivers/serial/zs.c linux-2.6.22-rc2/drivers/serial/zs.c
--- linux-2.6.22-rc2.macro/drivers/serial/zs.c	2007-05-29 12:42:14.000000000 +0000
+++ linux-2.6.22-rc2/drivers/serial/zs.c	2007-05-30 22:25:42.000000000 +0000
@@ -47,11 +47,13 @@
 #define SUPPORT_SYSRQ
 #endif
 
+#include <linux/bug.h>
 #include <linux/console.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/io.h>
 #include <linux/ioport.h>
 #include <linux/irqflags.h>
 #include <linux/kernel.h>
@@ -62,8 +64,7 @@
 #include <linux/sysrq.h>
 #include <linux/tty.h>
 
-#include <asm/bug.h>
-#include <asm/io.h>
+#include <asm/atomic.h>
 #include <asm/system.h>
 
 #include <asm/dec/interrupts.h>
@@ -86,11 +87,10 @@ static char zs_version[] __initdata = "0
 #define ZS_CHAN_B	1		/* Index of the channel B.  */
 #define ZS_CHAN_IO_SIZE 8		/* IOMEM space size.  */
 #define ZS_CHAN_IO_STRIDE 4		/* Register alignment.  */
-#define ZS_CHAN_IO_OFFSET 1		/* The SCC resides on the high byte						   of the 16-bit IOBUS.  */
+#define ZS_CHAN_IO_OFFSET 1		/* The SCC resides on the high byte
+					   of the 16-bit IOBUS.  */
 #define ZS_CLOCK        7372800 	/* Z85C30 PCLK input clock rate.  */
 
-#define RECOVERY_DELAY  udelay(2)
-
 #define to_zport(uport) container_of(uport, struct zs_port, port)
 
 struct zs_parms {
@@ -126,53 +126,59 @@ static u8 zs_init_regs[ZS_NUM_REGS] __in
 /*
  * Reading and writing Z85C30 registers.
  */
-static inline u8 read_zsreg(struct zs_port *zport, int reg)
+static void recovery_delay(void)
+{
+	udelay(2);
+}
+
+static u8 read_zsreg(struct zs_port *zport, int reg)
 {
-	volatile void __iomem *control = zport->port.membase +
-					 ZS_CHAN_IO_OFFSET;
+	void __iomem *control = zport->port.membase + ZS_CHAN_IO_OFFSET;
 	u8 retval;
 
 	if (reg != 0) {
 		writeb(reg & 0xf, control);
-		fast_iob(); RECOVERY_DELAY;
+		fast_iob();
+		recovery_delay();
 	}
 	retval = readb(control);
-	RECOVERY_DELAY;
+	recovery_delay();
 	return retval;
 }
 
-static inline void write_zsreg(struct zs_port *zport, int reg, u8 value)
+static void write_zsreg(struct zs_port *zport, int reg, u8 value)
 {
-	volatile void __iomem *control = zport->port.membase +
-					 ZS_CHAN_IO_OFFSET;
+	void __iomem *control = zport->port.membase + ZS_CHAN_IO_OFFSET;
 
 	if (reg != 0) {
 		writeb(reg & 0xf, control);
-		fast_iob(); RECOVERY_DELAY;
+		fast_iob(); recovery_delay();
 	}
 	writeb(value, control);
-	fast_iob(); RECOVERY_DELAY;
+	fast_iob();
+	recovery_delay();
 	return;
 }
 
-static inline u8 read_zsdata(struct zs_port *zport)
+static u8 read_zsdata(struct zs_port *zport)
 {
-	volatile void __iomem *data = zport->port.membase +
-				      ZS_CHAN_IO_STRIDE + ZS_CHAN_IO_OFFSET;
+	void __iomem *data = zport->port.membase +
+			     ZS_CHAN_IO_STRIDE + ZS_CHAN_IO_OFFSET;
 	u8 retval;
 
 	retval = readb(data);
-	RECOVERY_DELAY;
+	recovery_delay();
 	return retval;
 }
 
-static inline void write_zsdata(struct zs_port *zport, u8 value)
+static void write_zsdata(struct zs_port *zport, u8 value)
 {
-	volatile void __iomem *data = zport->port.membase +
-				      ZS_CHAN_IO_STRIDE + ZS_CHAN_IO_OFFSET;
+	void __iomem *data = zport->port.membase +
+			     ZS_CHAN_IO_STRIDE + ZS_CHAN_IO_OFFSET;
 
 	writeb(value, data);
-	fast_iob(); RECOVERY_DELAY;
+	fast_iob();
+	recovery_delay();
 	return;
 }
 
@@ -196,7 +202,7 @@ void zs_dump(void)
 #endif
 
 
-static inline void zs_spin_lock_cond_irq(spinlock_t* lock, int irq)
+static void zs_spin_lock_cond_irq(spinlock_t *lock, int irq)
 {
 	if (irq)
 		spin_lock_irq(lock);
@@ -204,7 +210,7 @@ static inline void zs_spin_lock_cond_irq
 		spin_lock(lock);
 }
 
-static inline void zs_spin_unlock_cond_irq(spinlock_t* lock, int irq)
+static void zs_spin_unlock_cond_irq(spinlock_t *lock, int irq)
 {
 	if (irq)
 		spin_unlock_irq(lock);
@@ -235,7 +241,7 @@ static int zs_transmit_drain(struct zs_p
 }
 
 
-static inline void load_zsregs(struct zs_port *zport, u8 *regs, int irq)
+static void load_zsregs(struct zs_port *zport, u8 *regs, int irq)
 {
 	zs_transmit_drain(zport, irq);
 	/* Load 'em up.  */
@@ -288,8 +294,8 @@ static unsigned int zs_tx_empty(struct u
 	return status & ALL_SNT ? TIOCSER_TEMT : 0;
 }
 
-static inline unsigned int zs_raw_get_ab_mctrl(struct zs_port *zport_a,
-					       struct zs_port *zport_b)
+static unsigned int zs_raw_get_ab_mctrl(struct zs_port *zport_a,
+					struct zs_port *zport_b)
 {
 	u8 status_a, status_b;
 	unsigned int mctrl;
@@ -728,18 +734,20 @@ static int zs_startup(struct uart_port *
 	struct zs_port *zport = to_zport(uport);
 	struct zs_scc *scc = zport->scc;
 	unsigned long flags;
+	int irq_guard;
 	int ret;
 
-	if (!scc->irq_guard) {
+	irq_guard = atomic_add_return(1, &scc->irq_guard);
+	if (irq_guard == 1) {
 		ret = request_irq(zport->port.irq, zs_interrupt,
 				  IRQF_SHARED, "scc", scc);
 		if (ret) {
+			atomic_add(-1, &scc->irq_guard);
 			printk(KERN_ERR "zs: can't get irq %d\n",
 			       zport->port.irq);
 			return ret;
 		}
 	}
-	scc->irq_guard++;
 
 	spin_lock_irqsave(&scc->zlock, flags);
 
@@ -780,6 +788,7 @@ static void zs_shutdown(struct uart_port
 	struct zs_port *zport = to_zport(uport);
 	struct zs_scc *scc = zport->scc;
 	unsigned long flags;
+	int irq_guard;
 
 	spin_lock_irqsave(&scc->zlock, flags);
 
@@ -790,8 +799,8 @@ static void zs_shutdown(struct uart_port
 
 	spin_unlock_irqrestore(&scc->zlock, flags);
 
-	scc->irq_guard--;
-	if (!scc->irq_guard)
+	irq_guard = atomic_add_return(-1, &scc->irq_guard);
+	if (!irq_guard)
 		free_irq(zport->port.irq, scc);
 }
 
@@ -1203,7 +1212,7 @@ static int __init zs_init(void)
 {
 	int i, ret;
 
-	printk("%s%s\n", zs_name, zs_version);
+	pr_info("%s%s\n", zs_name, zs_version);
 
 	/* Find out how many Z85C30 SCCs we have.  */
 	ret = zs_probe_sccs();
diff -up --recursive --new-file linux-2.6.22-rc2.macro/drivers/serial/zs.h linux-2.6.22-rc2/drivers/serial/zs.h
--- linux-2.6.22-rc2.macro/drivers/serial/zs.h	2007-05-29 12:34:38.000000000 +0000
+++ linux-2.6.22-rc2/drivers/serial/zs.h	2007-05-30 21:28:27.000000000 +0000
@@ -39,7 +39,7 @@ struct zs_port {
 struct zs_scc {
 	struct zs_port	zport[2];
 	spinlock_t	zlock;
-	int		irq_guard;
+	atomic_t	irq_guard;
 	int		initialised;
 };
 	
