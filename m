Return-Path: <linux-kernel-owner+w=401wt.eu-S1756226AbYJEQhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbYJEQhY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759986AbYJEQfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:35:42 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35281 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758325AbYJEQfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:35:41 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 02/19] pcmcia: IRQ_TYPE_EXCLUSIVE is long obsoleted
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:35:41 +0100
Message-ID: <20081005163526.3799.57100.stgit@localhost.localdomain>
In-Reply-To: <20081005163302.3799.61899.stgit@localhost.localdomain>
References: <20081005163302.3799.61899.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch more drivers to dynamic sharing after checking their IRQ handlers
use dev_id and are robust

Signed-off-by: Alan Cox <alan@redhat.com>

---

 drivers/bluetooth/bluecard_cs.c   |    2 +-
 drivers/bluetooth/bt3c_cs.c       |    6 ++++--
 drivers/bluetooth/btuart_cs.c     |    6 ++++--
 drivers/bluetooth/dtl1_cs.c       |    7 +++++--
 drivers/char/pcmcia/synclink_cs.c |    2 +-
 drivers/parport/parport_cs.c      |    2 +-
 6 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/bluetooth/bluecard_cs.c b/drivers/bluetooth/bluecard_cs.c
index bcf5792..3b330a0 100644
--- a/drivers/bluetooth/bluecard_cs.c
+++ b/drivers/bluetooth/bluecard_cs.c
@@ -867,7 +867,7 @@ static int bluecard_probe(struct pcmcia_device *link)
 
 	link->io.Attributes1 = IO_DATA_PATH_WIDTH_8;
 	link->io.NumPorts1 = 8;
-	link->irq.Attributes = IRQ_TYPE_EXCLUSIVE | IRQ_HANDLE_PRESENT;
+	link->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING | IRQ_HANDLE_PRESENT;
 	link->irq.IRQInfo1 = IRQ_LEVEL_ID;
 
 	link->irq.Handler = bluecard_interrupt;
diff --git a/drivers/bluetooth/bt3c_cs.c b/drivers/bluetooth/bt3c_cs.c
index 2705847..eddc379 100644
--- a/drivers/bluetooth/bt3c_cs.c
+++ b/drivers/bluetooth/bt3c_cs.c
@@ -343,6 +343,7 @@ static irqreturn_t bt3c_interrupt(int irq, void *dev_inst)
 	bt3c_info_t *info = dev_inst;
 	unsigned int iobase;
 	int iir;
+	irqreturn_t r = IRQ_NONE;
 
 	BUG_ON(!info->hdev);
 
@@ -374,11 +375,12 @@ static irqreturn_t bt3c_interrupt(int irq, void *dev_inst)
 
 			outb(iir, iobase + CONTROL);
 		}
+		r = IRQ_HANDLED;
 	}
 
 	spin_unlock(&(info->lock));
 
-	return IRQ_HANDLED;
+	return r;
 }
 
 
@@ -657,7 +659,7 @@ static int bt3c_probe(struct pcmcia_device *link)
 
 	link->io.Attributes1 = IO_DATA_PATH_WIDTH_8;
 	link->io.NumPorts1 = 8;
-	link->irq.Attributes = IRQ_TYPE_EXCLUSIVE | IRQ_HANDLE_PRESENT;
+	link->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING | IRQ_HANDLE_PRESENT;
 	link->irq.IRQInfo1 = IRQ_LEVEL_ID;
 
 	link->irq.Handler = bt3c_interrupt;
diff --git a/drivers/bluetooth/btuart_cs.c b/drivers/bluetooth/btuart_cs.c
index 68d1d25..1de13ed 100644
--- a/drivers/bluetooth/btuart_cs.c
+++ b/drivers/bluetooth/btuart_cs.c
@@ -293,6 +293,7 @@ static irqreturn_t btuart_interrupt(int irq, void *dev_inst)
 	unsigned int iobase;
 	int boguscount = 0;
 	int iir, lsr;
+	irqreturn_t r = IRQ_NONE;
 
 	BUG_ON(!info->hdev);
 
@@ -302,6 +303,7 @@ static irqreturn_t btuart_interrupt(int irq, void *dev_inst)
 
 	iir = inb(iobase + UART_IIR) & UART_IIR_ID;
 	while (iir) {
+		r = IRQ_HANDLED;
 
 		/* Clear interrupt */
 		lsr = inb(iobase + UART_LSR);
@@ -335,7 +337,7 @@ static irqreturn_t btuart_interrupt(int irq, void *dev_inst)
 
 	spin_unlock(&(info->lock));
 
-	return IRQ_HANDLED;
+	return r;
 }
 
 
@@ -586,7 +588,7 @@ static int btuart_probe(struct pcmcia_device *link)
 
 	link->io.Attributes1 = IO_DATA_PATH_WIDTH_8;
 	link->io.NumPorts1 = 8;
-	link->irq.Attributes = IRQ_TYPE_EXCLUSIVE | IRQ_HANDLE_PRESENT;
+	link->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING | IRQ_HANDLE_PRESENT;
 	link->irq.IRQInfo1 = IRQ_LEVEL_ID;
 
 	link->irq.Handler = btuart_interrupt;
diff --git a/drivers/bluetooth/dtl1_cs.c b/drivers/bluetooth/dtl1_cs.c
index dae45cd..9b7756b 100644
--- a/drivers/bluetooth/dtl1_cs.c
+++ b/drivers/bluetooth/dtl1_cs.c
@@ -297,6 +297,7 @@ static irqreturn_t dtl1_interrupt(int irq, void *dev_inst)
 	unsigned char msr;
 	int boguscount = 0;
 	int iir, lsr;
+	irqreturn_t r = IRQ_NONE;
 
 	BUG_ON(!info->hdev);
 
@@ -307,6 +308,7 @@ static irqreturn_t dtl1_interrupt(int irq, void *dev_inst)
 	iir = inb(iobase + UART_IIR) & UART_IIR_ID;
 	while (iir) {
 
+		r = IRQ_HANDLED;
 		/* Clear interrupt */
 		lsr = inb(iobase + UART_LSR);
 
@@ -343,11 +345,12 @@ static irqreturn_t dtl1_interrupt(int irq, void *dev_inst)
 		info->ri_latch = msr & UART_MSR_RI;
 		clear_bit(XMIT_WAITING, &(info->tx_state));
 		dtl1_write_wakeup(info);
+		r = IRQ_HANDLED;
 	}
 
 	spin_unlock(&(info->lock));
 
-	return IRQ_HANDLED;
+	return r;
 }
 
 
@@ -568,7 +571,7 @@ static int dtl1_probe(struct pcmcia_device *link)
 
 	link->io.Attributes1 = IO_DATA_PATH_WIDTH_8;
 	link->io.NumPorts1 = 8;
-	link->irq.Attributes = IRQ_TYPE_EXCLUSIVE | IRQ_HANDLE_PRESENT;
+	link->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING | IRQ_HANDLE_PRESENT;
 	link->irq.IRQInfo1 = IRQ_LEVEL_ID;
 
 	link->irq.Handler = dtl1_interrupt;
diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index c240562..e580f30 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -554,7 +554,7 @@ static int mgslpc_probe(struct pcmcia_device *link)
     /* Initialize the struct pcmcia_device structure */
 
     /* Interrupt setup */
-    link->irq.Attributes = IRQ_TYPE_EXCLUSIVE;
+    link->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING;
     link->irq.IRQInfo1   = IRQ_LEVEL_ID;
     link->irq.Handler = NULL;
 
diff --git a/drivers/parport/parport_cs.c b/drivers/parport/parport_cs.c
index 00e1d96..f89c2b7 100644
--- a/drivers/parport/parport_cs.c
+++ b/drivers/parport/parport_cs.c
@@ -112,7 +112,7 @@ static int parport_probe(struct pcmcia_device *link)
 
     link->io.Attributes1 = IO_DATA_PATH_WIDTH_8;
     link->io.Attributes2 = IO_DATA_PATH_WIDTH_8;
-    link->irq.Attributes = IRQ_TYPE_EXCLUSIVE;
+    link->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING;
     link->irq.IRQInfo1 = IRQ_LEVEL_ID;
     link->conf.Attributes = CONF_ENABLE_IRQ;
     link->conf.IntType = INT_MEMORY_AND_IO;

