Return-Path: <linux-kernel-owner+w=401wt.eu-S1753909AbZCRLgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbZCRLgu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 07:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756292AbZCRLgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 07:36:39 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40612 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756890AbZCRLgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 07:36:38 -0400
Date: Wed, 18 Mar 2009 11:35:59 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Gabor Kovacs <kgabor@bolyai.elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Lava dual parallel PCI card IRQ problem
Message-ID: <20090318113559.2771b3c7@lxorguk.ukuu.org.uk>
In-Reply-To: <200903171852.20408.kgabor@bolyai.elte.hu>
References: <200903130051.18119.kgabor@bolyai.elte.hu>
	<20090316105728.4380454c@lxorguk.ukuu.org.uk>
	<200903171852.20408.kgabor@bolyai.elte.hu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First cut to try

parport: Use the PCI IRQ if offered

From: Alan Cox <alan@lxorguk.ukuu.org.uk>

parport: Use the PCI IRQ if offered

From: Alan Cox <alan@lxorguk.ukuu.org.uk>


---

 drivers/parport/parport_cs.c     |    3 +-
 drivers/parport/parport_pc.c     |   58 ++++++++++++++++++++++++--------------
 drivers/parport/parport_serial.c |   20 ++++++++++---
 include/linux/parport_pc.h       |   11 ++++---
 4 files changed, 61 insertions(+), 31 deletions(-)


diff --git a/drivers/parport/parport_cs.c b/drivers/parport/parport_cs.c
index 0cd5fbc..8fdfa4f 100644
--- a/drivers/parport/parport_cs.c
+++ b/drivers/parport/parport_cs.c
@@ -43,6 +43,7 @@
 #include <linux/timer.h>
 #include <linux/ioport.h>
 #include <linux/major.h>
+#include <linux/interrupt.h>
 
 #include <linux/parport.h>
 #include <linux/parport_pc.h>
@@ -192,7 +193,7 @@ static int parport_config(struct pcmcia_device *link)
 
     p = parport_pc_probe_port(link->io.BasePort1, link->io.BasePort2,
 			      link->irq.AssignedIRQ, PARPORT_DMA_NONE,
-			      &link->dev);
+			      &link->dev, IRQF_SHARED);
     if (p == NULL) {
 	printk(KERN_NOTICE "parport_cs: parport_pc_probe_port() at "
 	       "0x%3x, irq %u failed\n", link->io.BasePort1,
diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
index 96f3bdf..ff01d01 100644
--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -2170,10 +2170,11 @@ static int parport_dma_probe (struct parport *p)
 static LIST_HEAD(ports_list);
 static DEFINE_SPINLOCK(ports_lock);
 
-struct parport *parport_pc_probe_port (unsigned long int base,
-				       unsigned long int base_hi,
-				       int irq, int dma,
-				       struct device *dev)
+struct parport *parport_pc_probe_port(unsigned long int base,
+				      unsigned long int base_hi,
+				      int irq, int dma,
+				      struct device *dev,
+				      int irqflags)
 {
 	struct parport_pc_private *priv;
 	struct parport_operations *ops;
@@ -2194,11 +2195,11 @@ struct parport *parport_pc_probe_port (unsigned long int base,
 		dev = &pdev->dev;
 	}
 
-	ops = kmalloc(sizeof (struct parport_operations), GFP_KERNEL);
+	ops = kmalloc(sizeof(struct parport_operations), GFP_KERNEL);
 	if (!ops)
 		goto out1;
 
-	priv = kmalloc (sizeof (struct parport_pc_private), GFP_KERNEL);
+	priv = kmalloc(sizeof(struct parport_pc_private), GFP_KERNEL);
 	if (!priv)
 		goto out2;
 
@@ -2325,8 +2326,8 @@ struct parport *parport_pc_probe_port (unsigned long int base,
 		EPP_res = NULL;
 	}
 	if (p->irq != PARPORT_IRQ_NONE) {
-		if (request_irq (p->irq, parport_irq_handler,
-				 0, p->name, p)) {
+		if (request_irq(p->irq, parport_irq_handler,
+				 irqflags, p->name, p)) {
 			printk (KERN_WARNING "%s: irq %d in use, "
 				"resorting to polled operation\n",
 				p->name, p->irq);
@@ -2530,7 +2531,7 @@ static int __devinit sio_ite_8872_probe (struct pci_dev *pdev, int autoirq,
 	 */
 	release_resource(base_res);
 	if (parport_pc_probe_port (ite8872_lpt, ite8872_lpthi,
-				   irq, PARPORT_DMA_NONE, &pdev->dev)) {
+				   irq, PARPORT_DMA_NONE, &pdev->dev, 0)) {
 		printk (KERN_INFO
 			"parport_pc: ITE 8872 parallel port: io=0x%X",
 			ite8872_lpt);
@@ -2713,7 +2714,7 @@ static int __devinit sio_via_probe (struct pci_dev *pdev, int autoirq,
 	}
 
 	/* finally, do the probe with values obtained */
-	if (parport_pc_probe_port (port1, port2, irq, dma, &pdev->dev)) {
+	if (parport_pc_probe_port (port1, port2, irq, dma, &pdev->dev, 0)) {
 		printk (KERN_INFO
 			"parport_pc: VIA parallel port: io=0x%X", port1);
 		if (irq != PARPORT_IRQ_NONE)
@@ -3018,6 +3019,7 @@ static int parport_pc_pci_probe (struct pci_dev *dev,
 	for (n = 0; n < cards[i].numports; n++) {
 		int lo = cards[i].addr[n].lo;
 		int hi = cards[i].addr[n].hi;
+		int irq;
 		unsigned long io_lo, io_hi;
 		io_lo = pci_resource_start (dev, lo);
 		io_hi = 0;
@@ -3028,13 +3030,26 @@ static int parport_pc_pci_probe (struct pci_dev *dev,
                                         "hi" as an offset (see SYBA
                                         def.) */
 		/* TODO: test if sharing interrupts works */
-		printk (KERN_DEBUG "PCI parallel port detected: %04x:%04x, "
-			"I/O at %#lx(%#lx)\n",
-			parport_pc_pci_tbl[i + last_sio].vendor,
-			parport_pc_pci_tbl[i + last_sio].device, io_lo, io_hi);
+		irq = dev->irq;
+		if (irq == IRQ_NONE) {
+			printk (KERN_DEBUG
+	"PCI parallel port detected: %04x:%04x, I/O at %#lx(%#lx)\n",
+				parport_pc_pci_tbl[i + last_sio].vendor,
+				parport_pc_pci_tbl[i + last_sio].device,
+				io_lo, io_hi);
+			irq = PARPORT_IRQ_NONE;
+		} else {
+			printk (KERN_DEBUG
+	"PCI parallel port detected: %04x:%04x, I/O at %#lx(%#lx), IRQ %d\n",
+				parport_pc_pci_tbl[i + last_sio].vendor,
+				parport_pc_pci_tbl[i + last_sio].device,
+				io_lo, io_hi, irq);
+			irq = PARPORT_IRQ_NONE;
+		}
 		data->ports[count] =
-			parport_pc_probe_port (io_lo, io_hi, PARPORT_IRQ_NONE,
-					       PARPORT_DMA_NONE, &dev->dev);
+			parport_pc_probe_port(io_lo, io_hi, irq,
+					       PARPORT_DMA_NONE, &dev->dev, 
+					       IRQF_SHARED);
 		if (data->ports[count])
 			count++;
 	}
@@ -3143,7 +3158,8 @@ static int parport_pc_pnp_probe(struct pnp_dev *dev, const struct pnp_device_id
 		dma = PARPORT_DMA_NONE;
 
 	dev_info(&dev->dev, "reported by %s\n", dev->protocol->name);
-	if (!(pdata = parport_pc_probe_port (io_lo, io_hi, irq, dma, &dev->dev)))
+	if (!(pdata = parport_pc_probe_port(io_lo, io_hi,
+					irq, dma, &dev->dev, 0)))
 		return -ENODEV;
 
 	pnp_set_drvdata(dev,pdata);
@@ -3192,11 +3208,11 @@ parport_pc_find_isa_ports (int autoirq, int autodma)
 {
 	int count = 0;
 
-	if (parport_pc_probe_port(0x3bc, 0x7bc, autoirq, autodma, NULL))
+	if (parport_pc_probe_port(0x3bc, 0x7bc, autoirq, autodma, NULL, 0))
 		count++;
-	if (parport_pc_probe_port(0x378, 0x778, autoirq, autodma, NULL))
+	if (parport_pc_probe_port(0x378, 0x778, autoirq, autodma, NULL, 0))
 		count++;
-	if (parport_pc_probe_port(0x278, 0x678, autoirq, autodma, NULL))
+	if (parport_pc_probe_port(0x278, 0x678, autoirq, autodma, NULL, 0))
 		count++;
 
 	return count;
@@ -3481,7 +3497,7 @@ static int __init parport_pc_init(void)
 			if ((io_hi[i]) == PARPORT_IOHI_AUTO)
 			       io_hi[i] = 0x400 + io[i];
 			parport_pc_probe_port(io[i], io_hi[i],
-						  irqval[i], dmaval[i], NULL);
+					  irqval[i], dmaval[i], NULL, 0);
 		}
 	} else
 		parport_pc_find_ports (irqval[0], dmaval[0]);
diff --git a/drivers/parport/parport_serial.c b/drivers/parport/parport_serial.c
index 032db81..030f5a6 100644
--- a/drivers/parport/parport_serial.c
+++ b/drivers/parport/parport_serial.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/pci.h>
+#include <linux/interrupt.h>
 #include <linux/parport.h>
 #include <linux/parport_pc.h>
 #include <linux/8250_pci.h>
@@ -291,6 +292,7 @@ static int __devinit parport_register (struct pci_dev *dev,
 		int lo = card->addr[n].lo;
 		int hi = card->addr[n].hi;
 		unsigned long io_lo, io_hi;
+		int irq;
 
 		if (priv->num_par == ARRAY_SIZE (priv->port)) {
 			printk (KERN_WARNING
@@ -309,10 +311,20 @@ static int __devinit parport_register (struct pci_dev *dev,
                                         "hi" as an offset (see SYBA
                                         def.) */
 		/* TODO: test if sharing interrupts works */
-		dev_dbg(&dev->dev, "PCI parallel port detected: I/O at "
-			"%#lx(%#lx)\n", io_lo, io_hi);
-		port = parport_pc_probe_port (io_lo, io_hi, PARPORT_IRQ_NONE,
-					      PARPORT_DMA_NONE, &dev->dev);
+		irq = dev->irq;
+		if (irq == IRQ_NONE) {
+			dev_dbg(&dev->dev,
+			"PCI parallel port detected: I/O at %#lx(%#lx)\n",
+				io_lo, io_hi);
+			irq = PARPORT_IRQ_NONE;
+		} else {
+			dev_dbg(&dev->dev,
+		"PCI parallel port detected: I/O at %#lx(%#lx), IRQ %d\n",
+				io_lo, io_hi, irq);
+			irq = PARPORT_IRQ_NONE;
+		}
+		port = parport_pc_probe_port (io_lo, io_hi, irq,
+			      PARPORT_DMA_NONE, &dev->dev, IRQF_SHARED);
 		if (port) {
 			priv->port[priv->num_par++] = port;
 			success = 1;
diff --git a/include/linux/parport_pc.h b/include/linux/parport_pc.h
index ea8c6d8..cc1767f 100644
--- a/include/linux/parport_pc.h
+++ b/include/linux/parport_pc.h
@@ -228,10 +228,11 @@ extern void parport_pc_release_resources(struct parport *p);
 extern int parport_pc_claim_resources(struct parport *p);
 
 /* PCMCIA code will want to get us to look at a port.  Provide a mechanism. */
-extern struct parport *parport_pc_probe_port (unsigned long base,
-					      unsigned long base_hi,
-					      int irq, int dma,
-					      struct device *dev);
-extern void parport_pc_unregister_port (struct parport *p);
+extern struct parport *parport_pc_probe_port(unsigned long base,
+					     unsigned long base_hi,
+					     int irq, int dma,
+					     struct device *dev,
+					     int irqflags);
+extern void parport_pc_unregister_port(struct parport *p);
 
 #endif
