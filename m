Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933023Ab0BQNe0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 08:34:26 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38914 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932349Ab0BQNeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 08:34:24 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [RFC 1/4] libata: cache device select
To: jeff@garzik.org.com, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Date: Wed, 17 Feb 2010 13:10:25 +0000
Message-ID: <20100217130847.16338.55586.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid the device select overhead on every qc_issue (> 10uS) by caching the
currently selected device. This shows up on profiles under load. Best case
this costs us 10uS for the delay, worst case with a dumb interface it's
costing us about *1mS* a command.

I believe the logic here is sufficient, but would welcome some second reviews
as its not something you want to get wrong !


Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/ata/libata-sff.c |    8 ++++++--
 include/linux/libata.h   |    1 +
 2 files changed, 7 insertions(+), 2 deletions(-)


diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 63d9c6a..cf0332a 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -469,6 +469,7 @@ void ata_sff_dev_select(struct ata_port *ap, unsigned int device)
 
 	iowrite8(tmp, ap->ioaddr.device_addr);
 	ata_sff_pause(ap);	/* needed; also flushes, for mmio */
+	ap->sff_selected = device;
 }
 EXPORT_SYMBOL_GPL(ata_sff_dev_select);
 
@@ -1538,7 +1539,8 @@ unsigned int ata_sff_qc_issue(struct ata_queued_cmd *qc)
 	}
 
 	/* select the device */
-	ata_dev_select(ap, qc->dev->devno, 1, 0);
+	if (qc->dev->devno != ap->sff_selected)
+        	ata_dev_select(ap, qc->dev->devno, 1, 0);
 
 	/* start the command */
 	switch (qc->tf.protocol) {
@@ -1925,6 +1927,8 @@ int ata_sff_prereset(struct ata_link *link, unsigned long deadline)
 	struct ata_eh_context *ehc = &link->eh_context;
 	int rc;
 
+	link->ap->sff_selected = -1;	/* Unknown */
+
 	rc = ata_std_prereset(link, deadline);
 	if (rc)
 		return rc;
@@ -2687,7 +2691,7 @@ void ata_bus_reset(struct ata_port *ap)
 		iowrite8(ap->ctl, ioaddr->ctl_addr);
 		ap->last_ctl = ap->ctl;
 	}
-
+	ap->sff_selected = -1;
 	DPRINTK("EXIT\n");
 	return;
 
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 5fb8884..a85adc2 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -725,6 +725,7 @@ struct ata_port {
 
 #ifdef CONFIG_ATA_SFF
 	struct ata_ioports	ioaddr;	/* ATA cmd/ctl/dma register blocks */
+	int			sff_selected;	/* Cache of selected device */
 #endif /* CONFIG_ATA_SFF */
 
 	u8			ctl;	/* cache of ATA control register */

