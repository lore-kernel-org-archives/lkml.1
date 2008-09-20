Return-Path: <linux-kernel-owner+w=401wt.eu-S1754607AbYITXV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607AbYITXV4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 19:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbYITXVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 19:21:46 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:15740 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbYITXVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 19:21:45 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: chris@pcburn.com
Subject: Re: Syba 8-Port Serial Card Unidentified By Kernel
Date: Sat, 20 Sep 2008 17:21:38 -0600
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, kyle@xtechgear.com, Ted.Wen@ite.com.tw,
       Michael@us.syba.com, Andrey Panin <pazke@donpac.ru>
References: <20071010095432.GC30345@pazke.donpac.ru> <200809181512.43523.bjorn.helgaas@hp.com> <48D3EEDD.70403@pcburn.com>
In-Reply-To: <48D3EEDD.70403@pcburn.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809201721.39048.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I intended to mask all the interrupts before configuring them, but
an editing mistake left the UART interrupts enabled.  Can you try
the patch below instead?

If this doesn't work, I'll have to add some debug and try to figure
out what is happening, but let's try the easy thing first.

Bjorn


diff --git a/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c
index c2f2393..dc59a1f 100644
--- a/drivers/serial/8250_pci.c
+++ b/drivers/serial/8250_pci.c
@@ -737,6 +737,55 @@ static void __devexit pci_ite887x_exit(struct pci_dev *dev)
 	release_region(ioport, ITE_887x_IOSIZE);
 }
 
+#define ITE_887x_IRR0  0
+#define ITE_887x_IRR1  1
+#define ITE_887x_IRR2  2
+#define ITE_887x_IMR0  4
+#define ITE_887x_IMR1  5
+#define ITE_887x_IMR2  6
+#define ITE_887x_IER0  8
+#define ITE_887x_IER1  9
+#define ITE_887x_IER2  10
+#define ITE_887x_ITR0  12
+#define ITE_887x_ITR1  13
+#define ITE_887x_ITR2  14
+
+static int pci_syba_ite887x_init(struct pci_dev *dev)
+{
+	u32 ddma_intc_base, intc_base;
+	struct resource *iobase;
+
+	pci_read_config_dword(dev, ITE_887x_INTCBAR, &ddma_intc_base);
+	intc_base = ddma_intc_base & 0xffff;
+
+	iobase = request_region(intc_base, ITE_887x_IOSIZE, "ite887x");
+	if (!iobase) {
+		dev_err(&dev->dev, "can't request INTC_Base at 0x%x\n",
+			intc_base);
+		return -ENODEV;
+	}
+
+	outb(0xff, intc_base + ITE_887x_IMR0);	/* mask external IRQ 0-7 */
+	outb(0xff, intc_base + ITE_887x_IMR1);	/* mask external IRQ 8-15 */
+	outb(0xff, intc_base + ITE_887x_IMR2);	/* mask internal interrupts */
+
+	outb(0xff, intc_base + ITE_887x_IER0);	/* IRQ 0-7 level-triggered */
+	outb(0x00, intc_base + ITE_887x_IER1);	/* IRQ 8-15 edge (unused) */
+	outb(0x00, intc_base + ITE_887x_IER2);	/* internal edge (unused) */
+
+	outb(0x00, intc_base + ITE_887x_ITR0);	/* clear SW-generated ints */
+	outb(0x00, intc_base + ITE_887x_ITR1);
+	outb(0x00, intc_base + ITE_887x_ITR2);
+
+	outb(0x00, intc_base + ITE_887x_IRR0);	/* clear any pending ints */
+	outb(0x00, intc_base + ITE_887x_IRR1);
+	outb(0x00, intc_base + ITE_887x_IRR2);
+
+	outb(0x00, intc_base + ITE_887x_IMR0);	/* unmask external IRQ 0-7 */
+
+	return 8;
+}
+
 static int
 pci_default_setup(struct serial_private *priv, struct pciserial_board *board,
 		  struct uart_port *port, int idx)
@@ -835,6 +884,18 @@ static struct pci_serial_quirk pci_serial_quirks[] __refdata = {
 		.exit		= __devexit_p(pci_ite887x_exit),
 	},
 	/*
+	 * Syba
+	 */
+	{
+		.vendor		= PCI_VENDOR_ID_PLX,
+		.device		= 0x9016,
+		.subvendor	= 0x544e,
+		.subdevice	= 0x0008,
+		.init		= pci_syba_ite887x_init,
+		.setup		= pci_default_setup,
+	/*	.exit		= __devexit_p(pci_ite887x_exit), */
+	},
+	/*
 	 * Panacom
 	 */
 	{
@@ -1085,6 +1146,8 @@ enum pci_board_num_t {
 	pbn_b0_5_115200,
 	pbn_b0_8_115200,
 
+	pbn_b0_8_460800,
+
 	pbn_b0_1_921600,
 	pbn_b0_2_921600,
 	pbn_b0_4_921600,
@@ -1226,6 +1289,12 @@ static struct pciserial_board pci_boards[] __devinitdata = {
 		.base_baud	= 115200,
 		.uart_offset	= 8,
 	},
+	[pbn_b0_8_460800] = {
+		.flags		= FL_BASE0,
+		.num_ports	= 8,
+		.base_baud	= 460800,
+		.uart_offset	= 8,
+	},
 	[pbn_b0_1_921600] = {
 		.flags		= FL_BASE0,
 		.num_ports	= 1,
@@ -2581,6 +2650,11 @@ static struct pci_device_id serial_pci_tbl[] = {
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b3_8_115200 },
 
+	/* Syba PCI8871-PR8 8-port serial card */
+	{	PCI_VENDOR_ID_PLX, 0x9016,
+		0x544e, 0x0008, 0, 0,
+		pbn_b0_8_460800 },
+
 	/*
 	 * Exar Corp. XR17C15[248] Dual/Quad/Octal UART
 	 */
