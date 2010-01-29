Return-Path: <linux-kernel-owner+w=401wt.eu-S1756040Ab0A2QKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab0A2QKf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:10:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754550Ab0A2QKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:10:25 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:47963 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171Ab0A2QKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:10:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=wueoLnz9eju2pKa3Gptv6N45pGvLamr6dqnspyCrG69Mm2XlESPj4Pbxt9SorTPILw
         ad0tc/P6qbrdjYkxzr+o4Zi3MZHcckcZIojM7qQQ+6T+vSCUY3bW0zTI8YswlOXCY9Rh
         MbHghviePy7xgFDF7qCC6ok0nblBkT7X8V5O0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:10:13 +0100
Message-Id: <20100129161013.21495.89241.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 66/68] pata_via: factor out code for finding ISA bridge
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_via: factor out code for finding ISA bridge

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_via.c |   35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

Index: b/drivers/ata/pata_via.c
===================================================================
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -431,6 +431,28 @@ static struct ata_port_operations via_po
 	.sff_data_xfer	= ata_sff_data_xfer_noirq,
 };
 
+static const struct via_isa_bridge *via_config_find(void)
+{
+	const struct via_isa_bridge *config;
+	struct pci_dev *isa;
+
+	for (config = via_isa_bridges; config->id != PCI_DEVICE_ID_VIA_ANON;
+	     config++) {
+		isa = pci_get_device(PCI_VENDOR_ID_VIA +
+			!!(config->flags & VIA_BAD_ID), config->id, NULL);
+		if (isa) {
+			u8 rev = isa->revision;
+
+			pci_dev_put(isa);
+
+			if (rev >= config->rev_min && rev <= config->rev_max)
+				break;
+		}
+	}
+
+	return config;
+}
+
 /**
  *	via_config_fifo		-	set up the FIFO
  *	@pdev: PCI device
@@ -544,7 +566,6 @@ static int via_init_one(struct pci_dev *
 		.port_ops = &via_port_ops
 	};
 	const struct ata_port_info *ppi[] = { NULL, NULL };
-	struct pci_dev *isa;
 	const struct via_isa_bridge *config;
 	static int printed_version;
 	u8 enable;
@@ -563,17 +584,7 @@ static int via_init_one(struct pci_dev *
 
 	/* To find out how the IDE will behave and what features we
 	   actually have to look at the bridge not the IDE controller */
-	for (config = via_isa_bridges; config->id != PCI_DEVICE_ID_VIA_ANON;
-	     config++)
-		if ((isa = pci_get_device(PCI_VENDOR_ID_VIA +
-			!!(config->flags & VIA_BAD_ID),
-			config->id, NULL))) {
-			u8 rev = isa->revision;
-			pci_dev_put(isa);
-
-			if (rev >= config->rev_min && rev <= config->rev_max)
-				break;
-		}
+	config = via_config_find();
 
 	if (!(config->flags & VIA_NO_ENABLES)) {
 		/* 0x40 low bits indicate enabled channels */
