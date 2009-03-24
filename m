Return-Path: <linux-kernel-owner+w=401wt.eu-S1759174AbZCXKWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759174AbZCXKWg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 06:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758235AbZCXKWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 06:22:25 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46150 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757763AbZCXKWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 06:22:24 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 2/4] pata_sc1200: Activate secondary channel
To: jeff@garzik.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Date: Tue, 24 Mar 2009 10:22:25 +0000
Message-ID: <20090324102154.9152.85281.stgit@localhost.localdomain>
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

Implement serialize and turn on slave channel

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/ata/pata_sc1200.c |   29 +++++++++++++++++++++++++++--
 1 files changed, 27 insertions(+), 2 deletions(-)


diff --git a/drivers/ata/pata_sc1200.c b/drivers/ata/pata_sc1200.c
index 9a4bdca..fd96b96 100644
--- a/drivers/ata/pata_sc1200.c
+++ b/drivers/ata/pata_sc1200.c
@@ -2,7 +2,6 @@
  * New ATA layer SC1200 driver		Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  * TODO: Mode selection filtering
- * TODO: Can't enable second channel until ATA core has serialize
  * TODO: Needs custom DMA cleanup code
  *
  * Based very heavily on
@@ -178,6 +177,31 @@ static unsigned int sc1200_qc_issue(struct ata_queued_cmd *qc)
 	return ata_sff_qc_issue(qc);
 }
 
+/**
+ *	sc1200_qc_defer	-	implement serialization
+ *	@qc: command
+ *
+ *	Serialize command issue on this controller.
+ */
+
+static int sc1200_qc_defer(struct ata_queued_cmd *qc)
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
 static struct scsi_host_template sc1200_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 	.sg_tablesize	= LIBATA_DUMB_MAX_PRD,
@@ -187,6 +211,7 @@ static struct ata_port_operations sc1200_port_ops = {
 	.inherits	= &ata_bmdma_port_ops,
 	.qc_prep 	= ata_sff_dumb_qc_prep,
 	.qc_issue	= sc1200_qc_issue,
+	.qc_defer	= sc1200_qc_defer,
 	.cable_detect	= ata_cable_40wire,
 	.set_piomode	= sc1200_set_piomode,
 	.set_dmamode	= sc1200_set_dmamode,
@@ -211,7 +236,7 @@ static int sc1200_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.port_ops = &sc1200_port_ops
 	};
 	/* Can't enable port 2 yet, see top comments */
-	const struct ata_port_info *ppi[] = { &info, &ata_dummy_port_info };
+	const struct ata_port_info *ppi[] = { &info, };
 
 	return ata_pci_sff_init_one(dev, ppi, &sc1200_sht, NULL);
 }

