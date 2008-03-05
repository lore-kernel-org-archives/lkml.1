Return-Path: <linux-kernel-owner+w=401wt.eu-S933061AbYCEM6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933061AbYCEM6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 07:58:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762005AbYCEM6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 07:58:01 -0500
Received: from havoc.gtf.org ([69.61.125.42]:49513 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756597AbYCEM57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 07:57:59 -0500
Date: Wed, 5 Mar 2008 07:57:52 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20080305125752.GA28494@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ahci.c             |   14 +++++++++++++-
 drivers/ata/pata_hpt366.c      |    6 +++---
 drivers/ata/pata_hpt37x.c      |    6 +++---
 drivers/ata/pata_serverworks.c |    2 +-
 4 files changed, 20 insertions(+), 8 deletions(-)

Alan Cox (1):
      pata_hpt*, pata_serverworks: fix UDMA masking

Jeff Garzik (1):
      ahci: work around ATI SB600 h/w quirk

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 1db93b6..8a49835 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -186,6 +186,7 @@ enum {
 	AHCI_HFLAG_NO_MSI		= (1 << 5), /* no PCI MSI */
 	AHCI_HFLAG_NO_PMP		= (1 << 6), /* no PMP */
 	AHCI_HFLAG_NO_HOTPLUG		= (1 << 7), /* ignore PxSERR.DIAG.N */
+	AHCI_HFLAG_SECT255		= (1 << 8), /* max 255 sectors */
 
 	/* ap->flags bits */
 
@@ -255,6 +256,7 @@ static void ahci_vt8251_error_handler(struct ata_port *ap);
 static void ahci_p5wdh_error_handler(struct ata_port *ap);
 static void ahci_post_internal_cmd(struct ata_queued_cmd *qc);
 static int ahci_port_resume(struct ata_port *ap);
+static void ahci_dev_config(struct ata_device *dev);
 static unsigned int ahci_fill_sg(struct ata_queued_cmd *qc, void *cmd_tbl);
 static void ahci_fill_cmd_slot(struct ahci_port_priv *pp, unsigned int tag,
 			       u32 opts);
@@ -294,6 +296,8 @@ static const struct ata_port_operations ahci_ops = {
 	.check_altstatus	= ahci_check_status,
 	.dev_select		= ata_noop_dev_select,
 
+	.dev_config		= ahci_dev_config,
+
 	.tf_read		= ahci_tf_read,
 
 	.qc_defer		= sata_pmp_qc_defer_cmd_switch,
@@ -425,7 +429,7 @@ static const struct ata_port_info ahci_port_info[] = {
 	/* board_ahci_sb600 */
 	{
 		AHCI_HFLAGS	(AHCI_HFLAG_IGN_SERR_INTERNAL |
-				 AHCI_HFLAG_32BIT_ONLY | AHCI_HFLAG_NO_PMP),
+				 AHCI_HFLAG_SECT255 | AHCI_HFLAG_NO_PMP),
 		.flags		= AHCI_FLAG_COMMON,
 		.link_flags	= AHCI_LFLAG_COMMON,
 		.pio_mask	= 0x1f, /* pio0-4 */
@@ -1176,6 +1180,14 @@ static void ahci_init_controller(struct ata_host *host)
 	VPRINTK("HOST_CTL 0x%x\n", tmp);
 }
 
+static void ahci_dev_config(struct ata_device *dev)
+{
+	struct ahci_host_priv *hpriv = dev->link->ap->host->private_data;
+
+	if (hpriv->flags & AHCI_HFLAG_SECT255)
+		dev->max_sectors = 255;
+}
+
 static unsigned int ahci_dev_classify(struct ata_port *ap)
 {
 	void __iomem *port_mmio = ahci_port_base(ap);
diff --git a/drivers/ata/pata_hpt366.c b/drivers/ata/pata_hpt366.c
index 0713872..a742efa 100644
--- a/drivers/ata/pata_hpt366.c
+++ b/drivers/ata/pata_hpt366.c
@@ -27,7 +27,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_hpt366"
-#define DRV_VERSION	"0.6.1"
+#define DRV_VERSION	"0.6.2"
 
 struct hpt_clock {
 	u8	xfer_speed;
@@ -180,9 +180,9 @@ static unsigned long hpt366_filter(struct ata_device *adev, unsigned long mask)
 		if (hpt_dma_blacklisted(adev, "UDMA",  bad_ata33))
 			mask &= ~ATA_MASK_UDMA;
 		if (hpt_dma_blacklisted(adev, "UDMA3", bad_ata66_3))
-			mask &= ~(0x07 << ATA_SHIFT_UDMA);
+			mask &= ~(0xF8 << ATA_SHIFT_UDMA);
 		if (hpt_dma_blacklisted(adev, "UDMA4", bad_ata66_4))
-			mask &= ~(0x0F << ATA_SHIFT_UDMA);
+			mask &= ~(0xF0 << ATA_SHIFT_UDMA);
 	}
 	return ata_pci_default_filter(adev, mask);
 }
diff --git a/drivers/ata/pata_hpt37x.c b/drivers/ata/pata_hpt37x.c
index 68eb349..9a10878 100644
--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -24,7 +24,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_hpt37x"
-#define DRV_VERSION	"0.6.9"
+#define DRV_VERSION	"0.6.11"
 
 struct hpt_clock {
 	u8	xfer_speed;
@@ -281,7 +281,7 @@ static unsigned long hpt370_filter(struct ata_device *adev, unsigned long mask)
 		if (hpt_dma_blacklisted(adev, "UDMA", bad_ata33))
 			mask &= ~ATA_MASK_UDMA;
 		if (hpt_dma_blacklisted(adev, "UDMA100", bad_ata100_5))
-			mask &= ~(0x1F << ATA_SHIFT_UDMA);
+			mask &= ~(0xE0 << ATA_SHIFT_UDMA);
 	}
 	return ata_pci_default_filter(adev, mask);
 }
@@ -297,7 +297,7 @@ static unsigned long hpt370a_filter(struct ata_device *adev, unsigned long mask)
 {
 	if (adev->class == ATA_DEV_ATA) {
 		if (hpt_dma_blacklisted(adev, "UDMA100", bad_ata100_5))
-			mask &= ~ (0x1F << ATA_SHIFT_UDMA);
+			mask &= ~(0xE0 << ATA_SHIFT_UDMA);
 	}
 	return ata_pci_default_filter(adev, mask);
 }
diff --git a/drivers/ata/pata_serverworks.c b/drivers/ata/pata_serverworks.c
index 9c523fb..a589c0f 100644
--- a/drivers/ata/pata_serverworks.c
+++ b/drivers/ata/pata_serverworks.c
@@ -226,7 +226,7 @@ static unsigned long serverworks_csb_filter(struct ata_device *adev, unsigned lo
 
 	for (i = 0; (p = csb_bad_ata100[i]) != NULL; i++) {
 		if (!strcmp(p, model_num))
-			mask &= ~(0x1F << ATA_SHIFT_UDMA);
+			mask &= ~(0xE0 << ATA_SHIFT_UDMA);
 	}
 	return ata_pci_default_filter(adev, mask);
 }
