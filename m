Return-Path: <linux-kernel-owner+w=401wt.eu-S1755594AbZDMJ13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594AbZDMJ13 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 05:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753422AbZDMJ1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 05:27:15 -0400
Received: from havoc.gtf.org ([69.61.125.42]:58026 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401AbZDMJ1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 05:27:15 -0400
Date: Mon, 13 Apr 2009 05:27:13 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20090413092713.GA27458@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ahci.c        |   57 ++++++++++++++++++++++++++-------------------
 drivers/ata/libata-core.c |    4 +--
 drivers/ata/sata_via.c    |    2 +-
 3 files changed, 35 insertions(+), 28 deletions(-)

Jeff Garzik (1):
      [libata] sata_via: kill uninit'd var warning

Tejun Heo (1):
      ahci: force CAP_NCQ for earlier NV MCPs

Vegard Nossum (1):
      ata: fix obviously wrong comment

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 57be6be..08186ec 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -114,6 +114,7 @@ enum {
 	board_ahci_sb700	= 5, /* for SB700 and SB800 */
 	board_ahci_mcp65	= 6,
 	board_ahci_nopmp	= 7,
+	board_ahci_yesncq	= 8,
 
 	/* global controller registers */
 	HOST_CAP		= 0x00, /* host capabilities */
@@ -469,6 +470,14 @@ static const struct ata_port_info ahci_port_info[] = {
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_ops,
 	},
+	/* board_ahci_yesncq */
+	{
+		AHCI_HFLAGS	(AHCI_HFLAG_YES_NCQ),
+		.flags		= AHCI_FLAG_COMMON,
+		.pio_mask	= ATA_PIO4,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &ahci_ops,
+	},
 };
 
 static const struct pci_device_id ahci_pci_tbl[] = {
@@ -535,30 +544,30 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(NVIDIA, 0x045d), board_ahci_mcp65 },	/* MCP65 */
 	{ PCI_VDEVICE(NVIDIA, 0x045e), board_ahci_mcp65 },	/* MCP65 */
 	{ PCI_VDEVICE(NVIDIA, 0x045f), board_ahci_mcp65 },	/* MCP65 */
-	{ PCI_VDEVICE(NVIDIA, 0x0550), board_ahci },		/* MCP67 */
-	{ PCI_VDEVICE(NVIDIA, 0x0551), board_ahci },		/* MCP67 */
-	{ PCI_VDEVICE(NVIDIA, 0x0552), board_ahci },		/* MCP67 */
-	{ PCI_VDEVICE(NVIDIA, 0x0553), board_ahci },		/* MCP67 */
-	{ PCI_VDEVICE(NVIDIA, 0x0554), board_ahci },		/* MCP67 */
-	{ PCI_VDEVICE(NVIDIA, 0x0555), board_ahci },		/* MCP67 */
-	{ PCI_VDEVICE(NVIDIA, 0x0556), board_ahci },		/* MCP67 */
-	{ PCI_VDEVICE(NVIDIA, 0x0557), board_ahci },		/* MCP67 */
-	{ PCI_VDEVICE(NVIDIA, 0x0558), board_ahci },		/* MCP67 */
-	{ PCI_VDEVICE(NVIDIA, 0x0559), board_ahci },		/* MCP67 */
-	{ PCI_VDEVICE(NVIDIA, 0x055a), board_ahci },		/* MCP67 */
-	{ PCI_VDEVICE(NVIDIA, 0x055b), board_ahci },		/* MCP67 */
-	{ PCI_VDEVICE(NVIDIA, 0x07f0), board_ahci },		/* MCP73 */
-	{ PCI_VDEVICE(NVIDIA, 0x07f1), board_ahci },		/* MCP73 */
-	{ PCI_VDEVICE(NVIDIA, 0x07f2), board_ahci },		/* MCP73 */
-	{ PCI_VDEVICE(NVIDIA, 0x07f3), board_ahci },		/* MCP73 */
-	{ PCI_VDEVICE(NVIDIA, 0x07f4), board_ahci },		/* MCP73 */
-	{ PCI_VDEVICE(NVIDIA, 0x07f5), board_ahci },		/* MCP73 */
-	{ PCI_VDEVICE(NVIDIA, 0x07f6), board_ahci },		/* MCP73 */
-	{ PCI_VDEVICE(NVIDIA, 0x07f7), board_ahci },		/* MCP73 */
-	{ PCI_VDEVICE(NVIDIA, 0x07f8), board_ahci },		/* MCP73 */
-	{ PCI_VDEVICE(NVIDIA, 0x07f9), board_ahci },		/* MCP73 */
-	{ PCI_VDEVICE(NVIDIA, 0x07fa), board_ahci },		/* MCP73 */
-	{ PCI_VDEVICE(NVIDIA, 0x07fb), board_ahci },		/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x0550), board_ahci_yesncq },	/* MCP67 */
+	{ PCI_VDEVICE(NVIDIA, 0x0551), board_ahci_yesncq },	/* MCP67 */
+	{ PCI_VDEVICE(NVIDIA, 0x0552), board_ahci_yesncq },	/* MCP67 */
+	{ PCI_VDEVICE(NVIDIA, 0x0553), board_ahci_yesncq },	/* MCP67 */
+	{ PCI_VDEVICE(NVIDIA, 0x0554), board_ahci_yesncq },	/* MCP67 */
+	{ PCI_VDEVICE(NVIDIA, 0x0555), board_ahci_yesncq },	/* MCP67 */
+	{ PCI_VDEVICE(NVIDIA, 0x0556), board_ahci_yesncq },	/* MCP67 */
+	{ PCI_VDEVICE(NVIDIA, 0x0557), board_ahci_yesncq },	/* MCP67 */
+	{ PCI_VDEVICE(NVIDIA, 0x0558), board_ahci_yesncq },	/* MCP67 */
+	{ PCI_VDEVICE(NVIDIA, 0x0559), board_ahci_yesncq },	/* MCP67 */
+	{ PCI_VDEVICE(NVIDIA, 0x055a), board_ahci_yesncq },	/* MCP67 */
+	{ PCI_VDEVICE(NVIDIA, 0x055b), board_ahci_yesncq },	/* MCP67 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f0), board_ahci_yesncq },	/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f1), board_ahci_yesncq },	/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f2), board_ahci_yesncq },	/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f3), board_ahci_yesncq },	/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f4), board_ahci_yesncq },	/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f5), board_ahci_yesncq },	/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f6), board_ahci_yesncq },	/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f7), board_ahci_yesncq },	/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f8), board_ahci_yesncq },	/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f9), board_ahci_yesncq },	/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07fa), board_ahci_yesncq },	/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07fb), board_ahci_yesncq },	/* MCP73 */
 	{ PCI_VDEVICE(NVIDIA, 0x0ad0), board_ahci },		/* MCP77 */
 	{ PCI_VDEVICE(NVIDIA, 0x0ad1), board_ahci },		/* MCP77 */
 	{ PCI_VDEVICE(NVIDIA, 0x0ad2), board_ahci },		/* MCP77 */
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index e7ea77c..065507c 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6110,13 +6110,11 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 			ata_port_printk(ap, KERN_INFO, "DUMMY\n");
 	}
 
-	/* perform each probe synchronously */
-	DPRINTK("probe begin\n");
+	/* perform each probe asynchronously */
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
 		async_schedule(async_port_probe, ap);
 	}
-	DPRINTK("probe end\n");
 
 	return 0;
 }
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index 98e8c50..bdd43c7 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -566,7 +566,7 @@ static int svia_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	static int printed_version;
 	unsigned int i;
 	int rc;
-	struct ata_host *host;
+	struct ata_host *host = NULL;
 	int board_id = (int) ent->driver_data;
 	const unsigned *bar_sizes;
 
