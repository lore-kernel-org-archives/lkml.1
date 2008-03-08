Return-Path: <linux-kernel-owner+w=401wt.eu-S1755074AbYCHVW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074AbYCHVW3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 16:22:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbYCHVVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 16:21:41 -0500
Received: from gv-out-0910.google.com ([216.239.58.185]:48365 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbYCHVVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 16:21:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=QQgHOrXqi8lBSUUlDglVeym0PfZ7ZniQu/kxogvwZDihNbIp2honfbEqxd5Tpq+oaQxzX+f1VQfM0YjeKlTtNvLiBCt4jk0xvNnjytdVvV3bMr99YPtvDrdDUwnUMDUymslwJwMPBj6+reSLcPmhW6fOSx9Z6RKUe9rO99uYPQI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 4/7] ide: move ide_setup_dma() call out from ->init_dma method
Date: Sat, 8 Mar 2008 22:31:57 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803082231.57531.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/alim15x3.c |    1 -
 drivers/ide/pci/hpt366.c   |    2 --
 drivers/ide/setup-pci.c    |    7 +++----
 3 files changed, 3 insertions(+), 7 deletions(-)

Index: b/drivers/ide/pci/alim15x3.c
===================================================================
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -734,7 +734,6 @@ static void __devinit init_dma_ali15x3 (
 {
 	if (!hwif->channel)
 		outb(inb(dmabase + 2) & 0x60, dmabase + 2);
-	ide_setup_dma(hwif, dmabase);
 }
 
 static const struct ide_port_ops ali_port_ops = {
Index: b/drivers/ide/pci/hpt366.c
===================================================================
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -1348,8 +1348,6 @@ static void __devinit init_dma_hpt366(id
 		outb(dma_new, dmabase + 2);
 
 	local_irq_restore(flags);
-
-	ide_setup_dma(hwif, dmabase);
 }
 
 static void __devinit hpt374_init(struct pci_dev *dev, struct pci_dev *dev2)
Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -360,11 +360,10 @@ void ide_hwif_setup_dma(ide_hwif_t *hwif
 			}
 		}
 		if (dma_base) {
-			if (d->init_dma) {
+			if (d->init_dma)
 				d->init_dma(hwif, dma_base);
-			} else {
-				ide_setup_dma(hwif, dma_base);
-			}
+
+			ide_setup_dma(hwif, dma_base);
 		} else {
 			printk(KERN_INFO "%s: %s Bus-Master DMA disabled "
 				"(BIOS)\n", hwif->name, d->name);
