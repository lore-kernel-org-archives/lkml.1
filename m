Return-Path: <linux-kernel-owner+w=401wt.eu-S1755242AbXIVVdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbXIVVdH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 17:33:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbXIVVc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 17:32:56 -0400
Received: from mail.gmx.net ([213.165.64.20]:57893 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751767AbXIVVcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 17:32:55 -0400
X-Authenticated: #2360897
X-Provags-ID: V01U2FsdGVkX19rCHM3aGlrCHCsTM+G8JFRzRO1P7Hpih6UgsQ0+h
	drJzcrRTOo7/AH
Date: Sat, 22 Sep 2007 23:32:53 +0200
From: Bernhard Walle <bernhard.walle@gmx.de>
To: linux-parport@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: [RFC] IRQ sharing for PCI parport cards
Message-ID: <20070922213253.GA6397@mail1.bwalle.de>
Mail-Followup-To: linux-parport@lists.infradead.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

currently, the parport_pc driver doesn't use IRQs automatically for
PCI devices. However, why is it not possible? It's no problem to find
out the corresponding IRQ, and it should also be possible to use IRQ
sharing. The following patch implements this.

Could somebody tell me what's wrong with that approach? _If_ it would
be that simple, I'm sure that sombody would have implemented this
already.

At least it works here.


Thanks,
   Bernhard

---
 drivers/parport/parport_cs.c     |    2 +-
 drivers/parport/parport_pc.c     |   39 +++++++++++++++++++++++++--------------
 drivers/parport/parport_serial.c |    2 +-
 include/linux/parport_pc.h       |    6 +++++-
 4 files changed, 32 insertions(+), 17 deletions(-)

--- a/drivers/parport/parport_cs.c
+++ b/drivers/parport/parport_cs.c
@@ -200,7 +200,7 @@ static int parport_config(struct pcmcia_
 
     p = parport_pc_probe_port(link->io.BasePort1, link->io.BasePort2,
 			      link->irq.AssignedIRQ, PARPORT_DMA_NONE,
-			      &link->dev);
+			      &link->dev, 0);
     if (p == NULL) {
 	printk(KERN_NOTICE "parport_cs: parport_pc_probe_port() at "
 	       "0x%3x, irq %u failed\n", link->io.BasePort1,
--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -274,8 +274,14 @@ static int clear_epp_timeout(struct parp
 
 static irqreturn_t parport_pc_interrupt(int irq, void *dev_id)
 {
-	parport_generic_irq(irq, (struct parport *) dev_id);
-	/* FIXME! Was it really ours? */
+	struct parport *pb = dev_id;
+
+	/* for shared interrupt handlers */
+	if (parport_pc_read_status(pb) & (1<<2))
+		return IRQ_NONE;
+
+	parport_generic_irq(irq, pb);
+
 	return IRQ_HANDLED;
 }
 
@@ -2149,7 +2155,8 @@ static DEFINE_SPINLOCK(ports_lock);
 struct parport *parport_pc_probe_port (unsigned long int base,
 				       unsigned long int base_hi,
 				       int irq, int dma,
-				       struct device *dev)
+				       struct device *dev,
+				       unsigned int flags)
 {
 	struct parport_pc_private *priv;
 	struct parport_operations *ops;
@@ -2301,8 +2308,10 @@ struct parport *parport_pc_probe_port (u
 		EPP_res = NULL;
 	}
 	if (p->irq != PARPORT_IRQ_NONE) {
+		unsigned int irq_flags = flags & PARPORT_PC_SHARE_IRQ
+			? IRQF_SHARED : 0;
 		if (request_irq (p->irq, parport_pc_interrupt,
-				 0, p->name, p)) {
+				irq_flags, p->name, p)) {
 			printk (KERN_WARNING "%s: irq %d in use, "
 				"resorting to polled operation\n",
 				p->name, p->irq);
@@ -2506,7 +2515,7 @@ static int __devinit sio_ite_8872_probe 
 	 */
 	release_resource(base_res);
 	if (parport_pc_probe_port (ite8872_lpt, ite8872_lpthi,
-				   irq, PARPORT_DMA_NONE, &pdev->dev)) {
+				   irq, PARPORT_DMA_NONE, &pdev->dev, 0)) {
 		printk (KERN_INFO
 			"parport_pc: ITE 8872 parallel port: io=0x%X",
 			ite8872_lpt);
@@ -2689,7 +2698,7 @@ static int __devinit sio_via_probe (stru
 	}
 
 	/* finally, do the probe with values obtained */
-	if (parport_pc_probe_port (port1, port2, irq, dma, &pdev->dev)) {
+	if (parport_pc_probe_port (port1, port2, irq, dma, &pdev->dev, 0)) {
 		printk (KERN_INFO
 			"parport_pc: VIA parallel port: io=0x%X", port1);
 		if (irq != PARPORT_IRQ_NONE)
@@ -2980,14 +2989,16 @@ static int parport_pc_pci_probe (struct 
 			io_lo += hi; /* Reinterpret the meaning of
                                         "hi" as an offset (see SYBA
                                         def.) */
-		/* TODO: test if sharing interrupts works */
 		printk (KERN_DEBUG "PCI parallel port detected: %04x:%04x, "
 			"I/O at %#lx(%#lx)\n",
 			parport_pc_pci_tbl[i + last_sio].vendor,
 			parport_pc_pci_tbl[i + last_sio].device, io_lo, io_hi);
+		/* according to PCI spec, IRQ sharing must be supported */
 		data->ports[count] =
-			parport_pc_probe_port (io_lo, io_hi, PARPORT_IRQ_NONE,
-					       PARPORT_DMA_NONE, &dev->dev);
+			parport_pc_probe_port (io_lo, io_hi, dev->irq,
+					       PARPORT_DMA_NONE,
+					       &dev->dev,
+					       PARPORT_PC_SHARE_IRQ);
 		if (data->ports[count])
 			count++;
 	}
@@ -3095,7 +3106,7 @@ static int parport_pc_pnp_probe(struct p
 		dma = PARPORT_DMA_NONE;
 
 	dev_info(&dev->dev, "reported by %s\n", dev->protocol->name);
-	if (!(pdata = parport_pc_probe_port (io_lo, io_hi, irq, dma, &dev->dev)))
+	if (!(pdata = parport_pc_probe_port (io_lo, io_hi, irq, dma, &dev->dev, 0)))
 		return -ENODEV;
 
 	pnp_set_drvdata(dev,pdata);
@@ -3141,11 +3152,11 @@ parport_pc_find_isa_ports (int autoirq, 
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
@@ -3429,7 +3440,7 @@ static int __init parport_pc_init(void)
 			if ((io_hi[i]) == PARPORT_IOHI_AUTO)
 			       io_hi[i] = 0x400 + io[i];
 			parport_pc_probe_port(io[i], io_hi[i],
-						  irqval[i], dmaval[i], NULL);
+						  irqval[i], dmaval[i], NULL, 0);
 		}
 	} else
 		parport_pc_find_ports (irqval[0], dmaval[0]);
--- a/drivers/parport/parport_serial.c
+++ b/drivers/parport/parport_serial.c
@@ -305,7 +305,7 @@ static int __devinit parport_register (s
 		dev_dbg(&dev->dev, "PCI parallel port detected: I/O at "
 			"%#lx(%#lx)\n", io_lo, io_hi);
 		port = parport_pc_probe_port (io_lo, io_hi, PARPORT_IRQ_NONE,
-					      PARPORT_DMA_NONE, &dev->dev);
+					      PARPORT_DMA_NONE, &dev->dev, 0);
 		if (port) {
 			priv->port[priv->num_par++] = port;
 			success = 1;
--- a/include/linux/parport_pc.h
+++ b/include/linux/parport_pc.h
@@ -227,11 +227,15 @@ extern void parport_pc_release_resources
 
 extern int parport_pc_claim_resources(struct parport *p);
 
+/* flags for parport_pc_probe_port */
+#define PARPORT_PC_SHARE_IRQ		(1<<0)
+
 /* PCMCIA code will want to get us to look at a port.  Provide a mechanism. */
 extern struct parport *parport_pc_probe_port (unsigned long base,
 					      unsigned long base_hi,
 					      int irq, int dma,
-					      struct device *dev);
+					      struct device *dev,
+					      unsigned int flags);
 extern void parport_pc_unregister_port (struct parport *p);
 
 #endif
