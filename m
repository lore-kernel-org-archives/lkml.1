Return-Path: <linux-kernel-owner+w=401wt.eu-S1762890AbXGEWPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762890AbXGEWPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 18:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755473AbXGEWPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 18:15:46 -0400
Received: from echo.digadd.de ([195.47.195.234]:49475 "EHLO mx2.digadd.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753092AbXGEWPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 18:15:45 -0400
Message-ID: <468D6E49.90102@digadd.de>
Date: Fri, 06 Jul 2007 01:18:49 +0300
From: "Christian P. Schmidt" <charlie@digadd.de>
User-Agent: Thunderbird 2.0.0.4 (X11/20070619)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [patch] Add blacklisting capability to serial_pci to avoid misdetection
 of serial ports
X-Enigmail-Version: 0.95.2
Content-Type: multipart/mixed;
 boundary="------------090200080002080403000606"
X-Spam-Score: -4.4 (----)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090200080002080403000606
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

From: Christian Schmidt <schmidt@digadd.de>

The serial_pci driver tries to guess serial ports on unknown devices
based on the PCI class (modem or serial). On certain softmodems (AC'97
modems) this can lead to the recognition of non-existing serial ports.

This patch adds a blacklist of PCI IDs that are to be ignored by the driver.

The patch applies against both 2.6.21.5 and 2.6.22-rc7.

Signed-off-by: Christian Schmidt <schmidt@digadd.de>


--------------090200080002080403000606
Content-Type: text/plain;
 name="8250_pci.blacklist.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="8250_pci.blacklist.patch"

--- linux-2.6.21.5.orig/drivers/serial/8250_pci.c	2007-04-26 06:08:32.000000000 +0300
+++ linux-2.6.21.5/drivers/serial/8250_pci.c	2007-07-05 17:26:32.000000000 +0300
@@ -1513,6 +1513,11 @@
 	},
 };
 
+static const struct pci_device_id softmodem_blacklist[] = {
+     { PCI_VDEVICE ( AL, 0x5457 ), }, /* ALi Corporation M5457 AC'97 Modem */
+     { }
+};
+
 /*
  * Given a complete unknown PCI device, try to use some heuristics to
  * guess what the configuration might be, based on the pitiful PCI
@@ -1521,6 +1526,7 @@
 static int __devinit
 serial_pci_guess_board(struct pci_dev *dev, struct pciserial_board *board)
 {
+        const struct pci_device_id * blacklist;
 	int num_iomem, num_port, first_port = -1, i;
 	
 	/*
@@ -1535,6 +1541,16 @@
 	    (dev->class & 0xff) > 6)
 		return -ENODEV;
 
+	/*
+	 * Do not access blacklisted devices that are known not to
+	 * feature serial ports.
+	 */
+	for (blacklist = softmodem_blacklist; blacklist->vendor; blacklist++) {
+	        if ((dev->vendor == blacklist->vendor) &&
+	            (dev->device == blacklist->device))
+		        return -ENODEV;
+	}
+	
 	num_iomem = num_port = 0;
 	for (i = 0; i < PCI_NUM_BAR_RESOURCES; i++) {
 		if (pci_resource_flags(dev, i) & IORESOURCE_IO) {

--------------090200080002080403000606--
