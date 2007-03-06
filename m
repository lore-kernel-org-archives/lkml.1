Return-Path: <linux-kernel-owner+w=401wt.eu-S1030708AbXCFXYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030708AbXCFXYc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 18:24:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030707AbXCFXYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 18:24:32 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:32849 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030706AbXCFXYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 18:24:31 -0500
Date: Tue, 6 Mar 2007 16:24:48 -0700
From: Dave Jiang <djiang@mvista.com>
To: linux-kernel@vger.kernel.org
Cc: mgreer@mvista.com, akpm@osdl.org, djiang@mvista.com
Subject: [PATCH] MPSC serial driver tx locking
Message-ID: <20070306232448.GA2736@blade.az.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The MPSC serial driver assumes that interrupt is always on to pick up
the DMA transmit ops that aren't submitted while the DMA engine is active.
However when irqs are off for a period of time such as operations under kernel
crash dump console messages do not show up due to additional DMA ops are being
dropped. This makes console writes to process through all the tx DMAs
queued up before submitting a new request.

Also, the current locking mechanism does not protect the hardware
registers and ring buffer when a printk is done during the serial write
operations. The additional per port transmit lock provides a finer granular
locking and protects registers being clobbered while printks are nested within
UART writes.

Signed-off-by: Dave Jiang <djiang@mvista.com>
Signed-off-by: Mark A. Greer <mgreer@mvista.com>

---

 drivers/serial/mpsc.c |   25 ++++++++++++++++++++++++-
 1 files changed, 24 insertions(+), 1 deletions(-)

---

diff --git a/drivers/serial/mpsc.c b/drivers/serial/mpsc.c
index 3d2fcc5..d09f209 100644
--- a/drivers/serial/mpsc.c
+++ b/drivers/serial/mpsc.c
@@ -183,6 +183,7 @@ struct mpsc_port_info {
 	u8 *txb_p;		/* Phys addr of txb */
 	int txr_head;		/* Where new data goes */
 	int txr_tail;		/* Where sent data comes off */
+	spinlock_t tx_lock;	/* transmit lock */
 
 	/* Mirrored values of regs we can't read (if 'mirror_regs' set) */
 	u32 MPSC_MPCR_m;
@@ -1212,6 +1213,9 @@ mpsc_tx_intr(struct mpsc_port_info *pi)
 {
 	struct mpsc_tx_desc *txre;
 	int rc = 0;
+	unsigned long iflags;
+
+	spin_lock_irqsave(&pi->tx_lock, iflags);
 
 	if (!mpsc_sdma_tx_active(pi)) {
 		txre = (struct mpsc_tx_desc *)(pi->txr +
@@ -1248,6 +1252,7 @@ mpsc_tx_intr(struct mpsc_port_info *pi)
 		mpsc_sdma_start_tx(pi);	/* start next desc if ready */
 	}
 
+	spin_unlock_irqrestore(&pi->tx_lock, iflags);
 	return rc;
 }
 
@@ -1338,11 +1343,16 @@ static void
 mpsc_start_tx(struct uart_port *port)
 {
 	struct mpsc_port_info *pi = (struct mpsc_port_info *)port;
+	unsigned long iflags;
+
+	spin_lock_irqsave(&pi->tx_lock, iflags);
 
 	mpsc_unfreeze(pi);
 	mpsc_copy_tx_data(pi);
 	mpsc_sdma_start_tx(pi);
 
+	spin_unlock_irqrestore(&pi->tx_lock, iflags);
+
 	pr_debug("mpsc_start_tx[%d]\n", port->line);
 	return;
 }
@@ -1625,6 +1635,16 @@ mpsc_console_write(struct console *co, const char *s, uint count)
 	struct mpsc_port_info *pi = &mpsc_ports[co->index];
 	u8 *bp, *dp, add_cr = 0;
 	int i;
+	unsigned long iflags;
+
+	spin_lock_irqsave(&pi->tx_lock, iflags);
+
+	while (pi->txr_head != pi->txr_tail) {
+		while (mpsc_sdma_tx_active(pi))
+			udelay(100);
+		mpsc_sdma_intr_ack(pi);
+		mpsc_tx_intr(pi);
+	}
 
 	while (mpsc_sdma_tx_active(pi))
 		udelay(100);
@@ -1668,6 +1688,7 @@ mpsc_console_write(struct console *co, const char *s, uint count)
 		pi->txr_tail = (pi->txr_tail + 1) & (MPSC_TXR_ENTRIES - 1);
 	}
 
+	spin_unlock_irqrestore(&pi->tx_lock, iflags);
 	return;
 }
 
@@ -2005,7 +2026,8 @@ mpsc_drv_probe(struct platform_device *dev)
 		if (!(rc = mpsc_drv_map_regs(pi, dev))) {
 			mpsc_drv_get_platform_data(pi, dev, dev->id);
 
-			if (!(rc = mpsc_make_ready(pi)))
+			if (!(rc = mpsc_make_ready(pi))) {
+				spin_lock_init(&pi->tx_lock);
 				if (!(rc = uart_add_one_port(&mpsc_reg,
 					&pi->port)))
 					rc = 0;
@@ -2014,6 +2036,7 @@ mpsc_drv_probe(struct platform_device *dev)
 						(struct uart_port *)pi);
 					mpsc_drv_unmap_regs(pi);
 				}
+			}
 			else
 				mpsc_drv_unmap_regs(pi);
 		}
