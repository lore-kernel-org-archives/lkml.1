Return-Path: <linux-kernel-owner+w=401wt.eu-S1757208AbYBPUNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208AbYBPUNt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 15:13:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759080AbYBPUMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 15:12:31 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:13719 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758787AbYBPUM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 15:12:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Z0ZE5wfnmK/H+6EMp0drHUiETuNVVbIzZZpDzXvlkfdij293gkBjVjeKAlf/R7poEJZg47en1vpUZzgNhgKq1rWvlfzbsosi0qJkMRal9CJF3GYXHXFQ8HFf+u8xbOss1sPCJm71nXnl76zoj4mAyP+5sgDO3dJF/bH01tLiFOY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 16 Feb 2008 21:27:01 +0100
Message-Id: <20080216202701.25536.54484.sendpatchset@localhost.localdomain>
In-Reply-To: <20080216202634.25536.78915.sendpatchset@localhost.localdomain>
References: <20080216202634.25536.78915.sendpatchset@localhost.localdomain>
Subject: [PATCH 5/9] scc_pata: store 'hwif' pointer in struct scc_ports
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace 'unsigned char hwif_id' by 'ide_hwif_t *hwif' in struct scc_ports.
This allows us to remove ide_hwifs[] usage from scc_remove().

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/scc_pata.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: b/drivers/ide/pci/scc_pata.c
===================================================================
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -65,7 +65,7 @@
 
 static struct scc_ports {
 	unsigned long ctl, dma;
-	unsigned char hwif_id;  /* for removing hwif from system */
+	ide_hwif_t *hwif;  /* for removing port from system */
 } scc_ports[MAX_HWIFS];
 
 /* PIO transfer mode  table */
@@ -664,7 +664,7 @@ static void __devinit init_hwif_scc(ide_
 {
 	struct scc_ports *ports = ide_get_hwifdata(hwif);
 
-	ports->hwif_id = hwif->index;
+	ports->hwif = hwif;
 
 	hwif->dma_command = hwif->dma_base;
 	hwif->dma_status = hwif->dma_base + 0x04;
@@ -726,7 +726,7 @@ static int __devinit scc_init_one(struct
 static void __devexit scc_remove(struct pci_dev *dev)
 {
 	struct scc_ports *ports = pci_get_drvdata(dev);
-	ide_hwif_t *hwif = &ide_hwifs[ports->hwif_id];
+	ide_hwif_t *hwif = ports->hwif;
 	unsigned long ctl_base = pci_resource_start(dev, 0);
 	unsigned long dma_base = pci_resource_start(dev, 1);
 	unsigned long ctl_size = pci_resource_len(dev, 0);
