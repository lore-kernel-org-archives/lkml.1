Return-Path: <linux-kernel-owner+w=401wt.eu-S1760286AbYAFQwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760286AbYAFQwz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 11:52:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758247AbYAFQvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 11:51:18 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:18967 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759473AbYAFQvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 11:51:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Pw/7MxJk0VPDq9jJGizyo4yDDyuxzhC/aKrq5oXUxI5aXcjMLlyut8rhr/eY3qhrSqX6FQ7jkAUUSh93z3FzvZoxxRIjR3yDv8M3Zn3AQPqn03yIcAkR1nzkKJrUJbWLvwQInBtLUO/itWP75kdxV3LqSg6+uy73pYVoKk7/qfs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 06 Jan 2008 18:03:03 +0100
Message-Id: <20080106170303.6861.43285.sendpatchset@localhost.localdomain>
In-Reply-To: <20080106170220.6861.4814.sendpatchset@localhost.localdomain>
References: <20080106170220.6861.4814.sendpatchset@localhost.localdomain>
Subject: [PATCH 6/8] ide: separate PCI specific init from generic init in ide_pci_setup_ports()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Setup ->mate and ->channel in ide_pci_setup_ports() instead of
  in ide_hwif_configure().

* Make 'port' parameter for ide_hwif_configure() 'unsigned int'.

* Separate PCI specific init from generic init in ide_pci_setup_ports().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
+28 bytes
 drivers/ide/setup-pci.c |   29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -337,7 +337,8 @@ static int ide_pci_check_iomem(struct pc
  *	ide_hwif_configure	-	configure an IDE interface
  *	@dev: PCI device holding interface
  *	@d: IDE port info
- *	@mate: Paired interface if any
+ *	@port: port number
+ *	@irq: PCI IRQ
  *
  *	Perform the initial set up for the hardware interface structure. This
  *	is done per interface port rather than per PCI device. There may be
@@ -346,7 +347,9 @@ static int ide_pci_check_iomem(struct pc
  *	Returns the new hardware interface structure, or NULL on a failure
  */
 
-static ide_hwif_t *ide_hwif_configure(struct pci_dev *dev, const struct ide_port_info *d, ide_hwif_t *mate, int port, int irq)
+static ide_hwif_t *ide_hwif_configure(struct pci_dev *dev,
+				      const struct ide_port_info *d,
+				      unsigned int port, int irq)
 {
 	unsigned long ctl = 0, base = 0;
 	ide_hwif_t *hwif;
@@ -392,12 +395,7 @@ static ide_hwif_t *ide_hwif_configure(st
 
 	hwif->dev = &dev->dev;
 	hwif->cds = d;
-	hwif->channel = port;
 
-	if (mate) {
-		hwif->mate = mate;
-		mate->mate = hwif;
-	}
 	return hwif;
 }
 
@@ -525,10 +523,25 @@ void ide_pci_setup_ports(struct pci_dev 
 			continue;	/* port not enabled */
 		}
 
-		if ((hwif = ide_hwif_configure(dev, d, mate, port, pciirq)) == NULL)
+		hwif = ide_hwif_configure(dev, d, port, pciirq);
+		if (hwif == NULL)
 			continue;
 
 		*(idx + port) = hwif->index;
+	}
+
+	for (port = 0; port < channels; ++port) {
+		if (*(idx + port) == 0xff)
+			continue;
+
+		hwif = &ide_hwifs[*(idx + port)];
+
+		if (mate) {
+			hwif->mate = mate;
+			mate->mate = hwif;
+		}
+
+		hwif->channel = port;
 
 		if (d->init_iops)
 			d->init_iops(hwif);
