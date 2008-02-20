Return-Path: <linux-kernel-owner+w=401wt.eu-S1764171AbYBTAg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764171AbYBTAg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 19:36:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755489AbYBTAgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 19:36:31 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:37687 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189AbYBTAg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 19:36:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Aeg8n+DWYX4Slvq64Iz6AXV0txzI9mLHn9mlIqGylM71VrLj8bg+nFqK3duygkZGy8jm3EPMslxuvNxvA8FyyyyHpA/T7AJdPuMcwwoANEcgAnWT1XUOV/+u4U8mzzJT0YDylKBjLJ17nTtip6qXpXUq91uRk4cNr+3mD+zVbRY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] delkin_cb: fix resources handling
Date: Wed, 20 Feb 2008 01:46:24 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, Mark Lord <mlord@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802200146.24248.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tell IDE layer to not manage resources by setting hwif->mmio flag.

Cc: Mark Lord <mlord@pobox.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/delkin_cb.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: b/drivers/ide/pci/delkin_cb.c
===================================================================
--- a/drivers/ide/pci/delkin_cb.c
+++ b/drivers/ide/pci/delkin_cb.c
@@ -71,7 +71,6 @@ delkin_cb_probe (struct pci_dev *dev, co
 		if (setup[i])
 			outb(setup[i], base + i);
 	}
-	pci_release_regions(dev);	/* IDE layer handles regions itself */
 
 	memset(&hw, 0, sizeof(hw));
 	ide_std_init_ports(&hw, base + 0x10, base + 0x1e);
@@ -90,6 +89,7 @@ delkin_cb_probe (struct pci_dev *dev, co
 		ide_init_port_data(hwif, i);
 
 	ide_init_port_hw(hwif, &hw);
+	hwif->mmio = 1;
 	hwif->quirkproc = &ide_undecoded_slave;
 
 	idx[0] = i;
@@ -110,6 +110,7 @@ delkin_cb_probe (struct pci_dev *dev, co
 
 out_disable:
 	printk(KERN_ERR "delkin_cb: no IDE devices found\n");
+	pci_release_regions(dev);
 	pci_disable_device(dev);
 	return -ENODEV;
 }
@@ -122,6 +123,7 @@ delkin_cb_remove (struct pci_dev *dev)
 	if (hwif)
 		ide_unregister(hwif->index);
 
+	pci_release_regions(dev);
 	pci_disable_device(dev);
 }
 
