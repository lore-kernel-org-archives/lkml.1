Return-Path: <linux-kernel-owner+w=401wt.eu-S1755923AbYFBUWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbYFBUWq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 16:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753387AbYFBUVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 16:21:45 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:17008 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbYFBUVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 16:21:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=bcYyx4xDbpvs3a2UxcgbmXatgY+A5V5FJ3mcP3z/e0DC1gggViz1yQgBS/372fokJzCdYSCp+n1Db5fE+HKTwvQzVnzkoaseiLgYWqxnK9LGaR9TAsvXEhMSqr+sBFPtoIcnpf8LeOnUbaVa6qQc0n725KsuQhziC4WQQrpEQm4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 02 Jun 2008 22:23:09 +0200
Message-Id: <20080602202309.7265.47071.sendpatchset@localhost.localdomain>
In-Reply-To: <20080602202253.7265.23590.sendpatchset@localhost.localdomain>
References: <20080602202253.7265.23590.sendpatchset@localhost.localdomain>
Subject: [PATCH 3/9] delkin_cb: set proper hwif->gendev.parent value
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hwif->dev was set too late (after ide_device_add() call)
so hwif->gendev.parent was not initialized properly.

Fix it by setting hw.dev and letting ide_init_port_hw()
do the rest.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/delkin_cb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: b/drivers/ide/pci/delkin_cb.c
===================================================================
--- a/drivers/ide/pci/delkin_cb.c
+++ b/drivers/ide/pci/delkin_cb.c
@@ -79,6 +79,7 @@ delkin_cb_probe (struct pci_dev *dev, co
 	memset(&hw, 0, sizeof(hw));
 	ide_std_init_ports(&hw, base + 0x10, base + 0x1e);
 	hw.irq = dev->irq;
+	hw.dev = &dev->dev;
 	hw.chipset = ide_pci;		/* this enables IRQ sharing */
 
 	hwif = ide_find_port();
@@ -98,7 +99,7 @@ delkin_cb_probe (struct pci_dev *dev, co
 		goto out_disable;
 
 	pci_set_drvdata(dev, hwif);
-	hwif->dev = &dev->dev;
+
 	drive = &hwif->drives[0];
 	if (drive->present) {
 		drive->io_32bit = 1;
