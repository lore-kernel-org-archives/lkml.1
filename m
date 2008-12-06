Return-Path: <linux-kernel-owner+w=401wt.eu-S1753368AbYLFQga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbYLFQga (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 11:36:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753177AbYLFQgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 11:36:17 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:55177 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbYLFQgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 11:36:16 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 6 Dec 2008 17:35:59 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: ohci1394: flush MMIO writes before delay in
 initialization
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.fa84003ee3873879@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

and replace busy-wait by msleep.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/ohci1394.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: linux/drivers/ieee1394/ohci1394.c
===================================================================
--- linux.orig/drivers/ieee1394/ohci1394.c
+++ linux/drivers/ieee1394/ohci1394.c
@@ -3199,15 +3199,16 @@ static int __devinit ohci1394_pci_probe(
 	/* Now enable LPS, which we need in order to start accessing
 	 * most of the registers.  In fact, on some cards (ALI M5251),
 	 * accessing registers in the SClk domain without LPS enabled
-	 * will lock up the machine.  Wait 50msec to make sure we have
-	 * full link enabled.  */
+	 * will lock up the machine. */
 	reg_write(ohci, OHCI1394_HCControlSet, OHCI1394_HCControl_LPS);
 
 	/* Disable and clear interrupts */
 	reg_write(ohci, OHCI1394_IntEventClear, 0xffffffff);
 	reg_write(ohci, OHCI1394_IntMaskClear, 0xffffffff);
 
-	mdelay(50);
+	/* Flush MMIO writes and wait to make sure we have full link enabled. */
+	reg_read(ohci, OHCI1394_Version);
+	msleep(50);
 
 	/* Determine the number of available IR and IT contexts. */
 	ohci->nb_iso_rcv_ctx =
@@ -3422,7 +3423,8 @@ static int ohci1394_pci_resume(struct pc
 	reg_write(ohci, OHCI1394_HCControlSet, OHCI1394_HCControl_LPS);
 	reg_write(ohci, OHCI1394_IntEventClear, 0xffffffff);
 	reg_write(ohci, OHCI1394_IntMaskClear, 0xffffffff);
-	mdelay(50);
+	reg_read(ohci, OHCI1394_Version);
+	msleep(50);
 
 	err = request_irq(dev->irq, ohci_irq_handler, IRQF_SHARED,
 			  OHCI1394_DRIVER_NAME, ohci);

-- 
Stefan Richter
-=====-==--- ==-- --==-
http://arcgraph.de/sr/

