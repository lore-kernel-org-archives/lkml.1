Return-Path: <linux-kernel-owner+w=401wt.eu-S1754178AbZKQPHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbZKQPHR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 10:07:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754115AbZKQPHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 10:07:16 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40512 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753442AbZKQPHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 10:07:14 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 1/5] pata_via: Blacklist some combinations of Transcend Flash
	and via
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Date: Tue, 17 Nov 2009 14:51:06 +0000
Message-ID: <20091117145054.15430.52425.stgit@localhost.localdomain>
In-Reply-To: <20091117144450.15430.83450.stgit@localhost.localdomain>
References: <20091117144450.15430.83450.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported by Mikulas Patocka.

VIA VT82C586B + Transcend TS64GSSD25-M v0826 does not work in UDMA mode

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/ata/pata_via.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)


diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index 88984b8..2fb8be2 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -337,6 +337,32 @@ static void via_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 }
 
 /**
+ *	via_mode_filter		-	filter buggy device/mode pairs
+ *	@dev: ATA device
+ *	@mask: Mode bitmask
+ *
+ *	We need to apply some minimal filtering for old controllers and at least
+ *	one breed of Transcend SSD. Return the updated mask.
+ */
+
+static unsigned long via_mode_filter(struct ata_device *dev, unsigned long mask)
+{
+	struct ata_host *host = dev->link->ap->host;
+	const struct via_isa_bridge *config = host->private_data;
+	unsigned char model_num[ATA_ID_PROD_LEN + 1];
+
+	if (config->id == PCI_DEVICE_ID_VIA_82C586_0) {
+		ata_id_c_string(dev->id, model_num, ATA_ID_PROD, sizeof(model_num));
+		if (strcmp(model_num, "TS64GSSD25-M") == 0) {
+			ata_dev_printk(dev, KERN_WARNING,
+	"disabling UDMA mode due to reported lockups with this device.\n");
+			mask &= ~ ATA_MASK_UDMA;
+		}
+	}
+	return ata_bmdma_mode_filter(dev, mask);
+}
+
+/**
  *	via_tf_load - send taskfile registers to host controller
  *	@ap: Port to which output is sent
  *	@tf: ATA taskfile register set
@@ -427,6 +453,7 @@ static struct ata_port_operations via_port_ops = {
 	.prereset	= via_pre_reset,
 	.sff_tf_load	= via_tf_load,
 	.port_start	= via_port_start,
+	.mode_filter	= via_mode_filter,
 };
 
 static struct ata_port_operations via_port_ops_noirq = {

