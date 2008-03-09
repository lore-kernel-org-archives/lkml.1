Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbYCIPZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbYCIPZu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 11:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbYCIPYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 11:24:42 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:14145 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288AbYCIPYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 11:24:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=XXYco+lzXYnd2zEItN2DPJN4FSfQU64scBh6TU/jmEcOfjxyUk1C9kmW0k3NFaNlU/8FHNeX3LVckY/2p+4E6Oi574AcFrIiVSC1/usSl7NAv11NxRPT0a51OVna+x1K40avLwNcbKOj13LPXbjb9W29+1miNpwqjR6wCctxZy0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 4/7] icside: use ->init_dma method
Date: Sun, 9 Mar 2008 16:30:55 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803091630.55246.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add 'const struct ide_port_info *d' argument to icside_dma_init().

* Make icside_dma_init() return an error value and add icside_dma_off_init()
  (->init_dma implementation for case when DMA cannot be enabled).

* Convert the driver to use ->init_dma method.

Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/icside.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

Index: b/drivers/ide/arm/icside.c
===================================================================
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -384,7 +384,7 @@ static void icside_dma_lost_irq(ide_driv
 	printk(KERN_ERR "%s: IRQ lost\n", drive->name);
 }
 
-static void icside_dma_init(ide_hwif_t *hwif)
+static int icside_dma_init(ide_hwif_t *hwif, const struct ide_port_info *d)
 {
 	hwif->dmatable_cpu	= NULL;
 	hwif->dmatable_dma	= 0;
@@ -397,11 +397,16 @@ static void icside_dma_init(ide_hwif_t *
 	hwif->ide_dma_test_irq	= icside_dma_test_irq;
 	hwif->dma_timeout	= icside_dma_timeout;
 	hwif->dma_lost_irq	= icside_dma_lost_irq;
+
+	return 0;
 }
-#else
-#define icside_dma_init(hwif)	(0)
 #endif
 
+static int icside_dma_off_init(ide_hwif_t *hwif, const struct ide_port_info *d)
+{
+	return -EOPNOTSUPP;
+}
+
 static ide_hwif_t *
 icside_setup(void __iomem *base, struct cardinfo *info, struct expansion_card *ec)
 {
@@ -468,9 +473,9 @@ icside_register_v5(struct icside_state *
 }
 
 static const struct ide_port_info icside_v6_port_info __initdata = {
+	.init_dma		= icside_dma_off_init,
 	.port_ops		= &icside_v6_no_dma_port_ops,
 	.host_flags		= IDE_HFLAG_SERIALIZE |
-				  IDE_HFLAG_NO_DMA | /* no SFF-style DMA */
 				  IDE_HFLAG_NO_AUTOTUNE,
 	.mwdma_mask		= ATA_MWDMA2,
 	.swdma_mask		= ATA_SWDMA2,
@@ -543,11 +548,9 @@ icside_register_v6(struct icside_state *
 	mate->select_data = sel | 1;
 
 	if (ec->dma != NO_DMA && !request_dma(ec->dma, hwif->name)) {
-		icside_dma_init(hwif);
-		icside_dma_init(mate);
+		d.init_dma = icside_dma_init;
 		d.port_ops = &icside_v6_dma_port_ops;
-	} else
-		d.mwdma_mask = d.swdma_mask = 0;
+	}
 
 	idx[0] = hwif->index;
 	idx[1] = mate->index;
