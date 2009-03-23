Return-Path: <linux-kernel-owner+w=401wt.eu-S1757849AbZCWIun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757849AbZCWIun (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 04:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755083AbZCWIud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 04:50:33 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:41800 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754656AbZCWIuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 04:50:32 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqsEAHPoxknCTtAn/2dsb2JhbACBUM8CgjQMgT4GhzYC
Date: Mon, 23 Mar 2009 09:50:24 +0100
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org, linux-parport@lists.infradead.org,
       chripell@fsfe.org
Subject: Re: [PATCH] parport netmos 9845 & 9855 1P4S fixes
Message-ID: <20090323085024.GA8897@frolo.macqel>
References: <20090319181120.GA18034@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090319181120.GA18034@frolo.macqel>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list,

Sorry for the resend.  I had forgotten to cc Christian Pellegrin,
and have rephrased somewhat the comment.

Christian, can you verify that the patch below works for your
netmos 9855 2P2S board ?

Philippe

--

netmos serial/parallel adapters come in different flavour differing only
by the number of parallel and serial ports, which are encoded in the
subdevice ID.

Last fix of Christian Pellegrin for 9855 2P2S broke support for 9855 1P4S,
and works only by side-effect for the first parallel port of a 2P2S,
as this first parallel port is found by reading the second addr entry of
(struct parport_pc_pci) cards[netmos_9855], which is not initialized, and
hence has value 0, which happens to be the BAR of the first parallel port.

netmos_9xx5_combo entry in (struct parport_pc_pci) cards[], which is used
for a 9845 1P4S must also be fixed for the parallel port support when there
are 4 serial ports because this entry currently gives 2 as BAR index for
the parallel port.  Actually, in this case, BAR 2 is the 3rd serial port
while the parallel port is at BAR 4.

I fixed 9845 1P4S and 9855 1P4S support, while preserving 9855 2P2S support,
- by creating a netmos_9855_2p entry and using it for 9855 boards with
2 parallel ports : 9855 2P2S and 9855 2P0S boards,
- and by allowing netmos_parallel_init to change not only the number of
parallel ports (0 or 1), but making it also change the BAR index of the
parallel port when the serial ports are before the parallel port.

PS: the netmos_9855_2p entry in
(struct pciserial_board) pci_parport_serial_boards[] is needed because
netmos_parallel_init has no clean way to replace FL_BASE2 by FL_BASE4
in the description of the serial ports in function of the number of
parallel ports on the card.

Tested with a 9845 1P4S and a 9855 1P4S board.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>

diff --git a/drivers/parport/parport_serial.c b/drivers/parport/parport_serial.c
--- a/drivers/parport/parport_serial.c
+++ b/drivers/parport/parport_serial.c
@@ -30,6 +30,7 @@ enum parport_pc_pci_cards {
 	titan_210l,
 	netmos_9xx5_combo,
 	netmos_9855,
+	netmos_9855_2p,
 	avlab_1s1p,
 	avlab_1s2p,
 	avlab_2s1p,
@@ -62,7 +63,7 @@ struct parport_pc_pci {
 				struct parport_pc_pci *card, int failed);
 };
 
-static int __devinit netmos_parallel_init(struct pci_dev *dev, struct parport_pc_pci *card, int autoirq, int autodma)
+static int __devinit netmos_parallel_init(struct pci_dev *dev, struct parport_pc_pci *par, int autoirq, int autodma)
 {
 	/* the rule described below doesn't hold for this device */
 	if (dev->device == PCI_DEVICE_ID_NETMOS_9835 &&
@@ -74,9 +75,17 @@ static int __devinit netmos_parallel_ini
 	 * and serial ports.  The form is 0x00PS, where <P> is the number of
 	 * parallel ports and <S> is the number of serial ports.
 	 */
-	card->numports = (dev->subsystem_device & 0xf0) >> 4;
-	if (card->numports > ARRAY_SIZE(card->addr))
-		card->numports = ARRAY_SIZE(card->addr);
+	par->numports = (dev->subsystem_device & 0xf0) >> 4;
+	if (par->numports > ARRAY_SIZE(par->addr))
+		par->numports = ARRAY_SIZE(par->addr);
+	/*
+	 * This function is currently only called for cards with up to
+	 * one parallel port.
+	 * Parallel port BAR is either before or after serial ports BARS;
+	 * hence, lo should be either 0 or equal to the number of serial ports.
+	 */
+	if (par->addr[0].lo != 0)
+		par->addr[0].lo = dev->subsystem_device & 0xf;
 	return 0;
 }
 
@@ -84,7 +93,8 @@ static struct parport_pc_pci cards[] __d
 	/* titan_110l */		{ 1, { { 3, -1 }, } },
 	/* titan_210l */		{ 1, { { 3, -1 }, } },
 	/* netmos_9xx5_combo */		{ 1, { { 2, -1 }, }, netmos_parallel_init },
-	/* netmos_9855 */		{ 1, { { 2, -1 }, }, netmos_parallel_init },
+	/* netmos_9855 */		{ 1, { { 0, -1 }, }, netmos_parallel_init },
+	/* netmos_9855_2p */		{ 2, { { 0, -1 }, { 2, -1 }, } },
 	/* avlab_1s1p     */		{ 1, { { 1, 2}, } },
 	/* avlab_1s2p     */		{ 2, { { 1, 2}, { 3, 4 },} },
 	/* avlab_2s1p     */		{ 1, { { 2, 3}, } },
@@ -109,6 +119,10 @@ static struct pci_device_id parport_seri
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, netmos_9xx5_combo },
 	{ PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9845,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, netmos_9xx5_combo },
+	{ PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9855,
+	  0x1000, 0x0020, 0, 0, netmos_9855_2p },
+	{ PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9855,
+	  0x1000, 0x0022, 0, 0, netmos_9855_2p },
 	{ PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9855,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, netmos_9855 },
 	/* PCI_VENDOR_ID_AVLAB/Intek21 has another bunch of cards ...*/
@@ -192,6 +206,12 @@ static struct pciserial_board pci_parpor
 		.uart_offset	= 8,
 	},
 	[netmos_9855] = {
+		.flags		= FL_BASE2 | FL_BASE_BARS,
+		.num_ports	= 1,
+		.base_baud	= 115200,
+		.uart_offset	= 8,
+	},
+	[netmos_9855_2p] = {
 		.flags		= FL_BASE4 | FL_BASE_BARS,
 		.num_ports	= 1,
 		.base_baud	= 115200,
