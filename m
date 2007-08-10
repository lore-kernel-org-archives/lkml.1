Return-Path: <linux-kernel-owner+w=401wt.eu-S1756535AbXHJVl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535AbXHJVl0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 17:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752361AbXHJVjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 17:39:16 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41100 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751355AbXHJVjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 17:39:13 -0400
Message-Id: <200708102138.l7ALcj4R010831@imap1.linux-foundation.org>
Subject: [patch 6/6] Add blacklisting capability to serial_pci to avoid misdetection of serial ports
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, schmidt@digadd.de,
       alan@lxorguk.ukuu.org.uk, bjorn.helgaas@hp.com,
       rmk+lkml@arm.linux.org.uk, yinghai.lu@sun.com
From: akpm@linux-foundation.org
Date: Fri, 10 Aug 2007 14:38:45 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Schmidt <schmidt@digadd.de>

The serial_pci driver tries to guess serial ports on unknown devices based
on the PCI class (modem or serial).  On certain softmodems (AC'97 modems)
this can lead to the recognition of non-existing serial ports.

This patch adds a blacklist of PCI IDs that are to be ignored by the driver.

[akpm@linux-foundation.org: cleanups]
Signed-off-by: Christian Schmidt <schmidt@digadd.de>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Yinghai Lu <yinghai.lu@sun.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_pci.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+)

diff -puN drivers/serial/8250_pci.c~add-blacklisting-capability-to-serial_pci-to-avoid-misdetection drivers/serial/8250_pci.c
--- a/drivers/serial/8250_pci.c~add-blacklisting-capability-to-serial_pci-to-avoid-misdetection
+++ a/drivers/serial/8250_pci.c
@@ -1652,6 +1652,10 @@ static struct pciserial_board pci_boards
 	},
 };
 
+static const struct pci_device_id softmodem_blacklist[] = {
+	{ PCI_VDEVICE ( AL, 0x5457 ), }, /* ALi Corporation M5457 AC'97 Modem */
+};
+
 /*
  * Given a complete unknown PCI device, try to use some heuristics to
  * guess what the configuration might be, based on the pitiful PCI
@@ -1660,6 +1664,7 @@ static struct pciserial_board pci_boards
 static int __devinit
 serial_pci_guess_board(struct pci_dev *dev, struct pciserial_board *board)
 {
+	const struct pci_device_id *blacklist;
 	int num_iomem, num_port, first_port = -1, i;
 	
 	/*
@@ -1674,6 +1679,18 @@ serial_pci_guess_board(struct pci_dev *d
 	    (dev->class & 0xff) > 6)
 		return -ENODEV;
 
+	/*
+	 * Do not access blacklisted devices that are known not to
+	 * feature serial ports.
+	 */
+	for (blacklist = softmodem_blacklist;
+	     blacklist < softmodem_blacklist + ARRAY_SIZE(softmodem_blacklist);
+	     blacklist++) {
+		if (dev->vendor == blacklist->vendor &&
+		    dev->device == blacklist->device)
+			return -ENODEV;
+	}
+
 	num_iomem = num_port = 0;
 	for (i = 0; i < PCI_NUM_BAR_RESOURCES; i++) {
 		if (pci_resource_flags(dev, i) & IORESOURCE_IO) {
_
