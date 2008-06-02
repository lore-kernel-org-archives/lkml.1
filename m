Return-Path: <linux-kernel-owner+w=401wt.eu-S1754785AbYFBUXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbYFBUXH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 16:23:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753714AbYFBUVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 16:21:51 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:17242 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbYFBUVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 16:21:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=q4KglpYQ4p8qvPHABiPZaoPPVGNtqo1IIJ+kzvq5+HpY9XKQh/8g6znJYsLHMuJQILOt+u6DMMQ/ehInIKy0IoZHLPmFdKqW8cqqM3jbC0lZIlXrdzX+/NOw1myP6myrowev7grPfSwPvdQ/baIGtK4w7oiwhtNugqgRPFkYp0g=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 02 Jun 2008 22:23:17 +0200
Message-Id: <20080602202317.7265.98458.sendpatchset@localhost.localdomain>
In-Reply-To: <20080602202253.7265.23590.sendpatchset@localhost.localdomain>
References: <20080602202253.7265.23590.sendpatchset@localhost.localdomain>
Subject: [PATCH 4/9] delkin_cb: use struct ide_port_info
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the driver to use struct ide_port_info - as a nice side-effect
this fixes racy setup of ->io_32bit/unmask settings (after ide_device_add()
call device can be already in use).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/delkin_cb.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

Index: b/drivers/ide/pci/delkin_cb.c
===================================================================
--- a/drivers/ide/pci/delkin_cb.c
+++ b/drivers/ide/pci/delkin_cb.c
@@ -47,13 +47,18 @@ static const struct ide_port_ops delkin_
 	.quirkproc		= ide_undecoded_slave,
 };
 
+static const struct ide_port_info delkin_cb_port_info = {
+	.port_ops		= &delkin_cb_port_ops,
+	.host_flags		= IDE_HFLAG_IO_32BIT | IDE_HFLAG_UNMASK_IRQS |
+				  IDE_HFLAG_NO_DMA,
+};
+
 static int __devinit
 delkin_cb_probe (struct pci_dev *dev, const struct pci_device_id *id)
 {
 	unsigned long base;
 	hw_regs_t hw;
 	ide_hwif_t *hwif = NULL;
-	ide_drive_t *drive;
 	int i, rc;
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
@@ -89,22 +94,16 @@ delkin_cb_probe (struct pci_dev *dev, co
 	i = hwif->index;
 
 	ide_init_port_hw(hwif, &hw);
-	hwif->port_ops = &delkin_cb_port_ops;
 
 	idx[0] = i;
 
-	ide_device_add(idx, NULL);
+	ide_device_add(idx, &delkin_cb_port_info);
 
 	if (!hwif->present)
 		goto out_disable;
 
 	pci_set_drvdata(dev, hwif);
 
-	drive = &hwif->drives[0];
-	if (drive->present) {
-		drive->io_32bit = 1;
-		drive->unmask   = 1;
-	}
 	return 0;
 
 out_disable:
