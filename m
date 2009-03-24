Return-Path: <linux-kernel-owner+w=401wt.eu-S1759161AbZCXKWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759161AbZCXKWF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 06:22:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757763AbZCXKVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 06:21:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46147 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758404AbZCXKVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 06:21:49 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/4] pata_artop: Serializing support
To: jeff@garzik.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Date: Tue, 24 Mar 2009 10:21:49 +0000
Message-ID: <20090324102139.9152.87330.stgit@localhost.localdomain>
In-Reply-To: <20090324101952.9152.30261.stgit@localhost.localdomain>
References: <20090324101952.9152.30261.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>

Enable both ports on the 6210 and serialize them

Signed-off-by: Alan Cox <alan@redhat.com>
---

 block/blk-settings.c     |    2 +-
 drivers/ata/pata_artop.c |   33 +++++++++++++++++++++++++++------
 2 files changed, 28 insertions(+), 7 deletions(-)


diff --git a/block/blk-settings.c b/block/blk-settings.c
index 59fd05d..69c42ad 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -431,7 +431,7 @@ EXPORT_SYMBOL(blk_queue_segment_boundary);
  *
  * description:
  *    set required memory and length alignment for direct dma transactions.
- *    this is used when buiding direct io requests for the queue.
+ *    this is used when building direct io requests for the queue.
  *
  **/
 void blk_queue_dma_alignment(struct request_queue *q, int mask)
diff --git a/drivers/ata/pata_artop.c b/drivers/ata/pata_artop.c
index 6b3092c..eee4287 100644
--- a/drivers/ata/pata_artop.c
+++ b/drivers/ata/pata_artop.c
@@ -12,7 +12,6 @@
  *		performance Alessandro Zummo <alessandro.zummo@towertech.it>
  *
  *	TODO
- *	850 serialization once the core supports it
  *	Investigate no_dsc on 850R
  *	Clock detect
  */
@@ -29,7 +28,7 @@
 #include <linux/ata.h>
 
 #define DRV_NAME	"pata_artop"
-#define DRV_VERSION	"0.4.4"
+#define DRV_VERSION	"0.4.5"
 
 /*
  *	The ARTOP has 33 Mhz and "over clocked" timing tables. Until we
@@ -283,6 +282,31 @@ static void artop6260_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 	pci_write_config_byte(pdev, 0x44 + ap->port_no, ultra);
 }
 
+/**
+ *	artop_6210_qc_defer	-	implement serialization
+ *	@qc: command
+ *
+ *	Issue commands per host on this chip.
+ */
+
+static int artop6210_qc_defer(struct ata_queued_cmd *qc)
+{
+	struct ata_host *host = qc->ap->host;
+	struct ata_port *alt = host->ports[1 ^ qc->ap->port_no];
+	int rc;
+
+	/* First apply the usual rules */
+	rc = ata_std_qc_defer(qc);
+	if (rc != 0)
+		return rc;
+
+	/* Now apply serialization rules. Only allow a command if the
+	   other channel state machine is idle */
+	if (alt && alt->qc_active)
+		return	ATA_DEFER_PORT;
+	return 0;
+}
+
 static struct scsi_host_template artop_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
@@ -293,6 +317,7 @@ static struct ata_port_operations artop6210_ops = {
 	.set_piomode		= artop6210_set_piomode,
 	.set_dmamode		= artop6210_set_dmamode,
 	.prereset		= artop6210_pre_reset,
+	.qc_defer		= artop6210_qc_defer,
 };
 
 static struct ata_port_operations artop6260_ops = {
@@ -362,12 +387,8 @@ static int artop_init_one (struct pci_dev *pdev, const struct pci_device_id *id)
 
 	if (id->driver_data == 0) {	/* 6210 variant */
 		ppi[0] = &info_6210;
-		ppi[1] = &ata_dummy_port_info;
 		/* BIOS may have left us in UDMA, clear it before libata probe */
 		pci_write_config_byte(pdev, 0x54, 0);
-		/* For the moment (also lacks dsc) */
-		printk(KERN_WARNING "ARTOP 6210 requires serialize functionality not yet supported by libata.\n");
-		printk(KERN_WARNING "Secondary ATA ports will not be activated.\n");
 	}
 	else if (id->driver_data == 1)	/* 6260 */
 		ppi[0] = &info_626x;

