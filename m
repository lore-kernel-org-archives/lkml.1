Return-Path: <linux-kernel-owner+w=401wt.eu-S1754302Ab0ARRRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302Ab0ARRRt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:17:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754801Ab0ARRRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:17:45 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:57477 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788Ab0ARRRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:17:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=SnH6VeEGG2FOC6ZipFuPr6IrxVcAb88NiswiggrV0GiuHEbkfwoAEJouT+TExr7hHE
         jSbIxx+o87MXY7bjDyU28oSvAXAujE3lSEAvWFfq1VSFOu9v0CXfMiuB5abFMf7+PlVp
         3YF34GMI8T3OOhSx0ZX4llEVEYvEZKqd9P3ro=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:16:31 +0100
Message-Id: <20100118171631.14623.68700.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 18/64] pata_efar: enable parallel scan
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_efar: enable parallel scan

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_efar.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

Index: b/drivers/ata/pata_efar.c
===================================================================
--- a/drivers/ata/pata_efar.c
+++ b/drivers/ata/pata_efar.c
@@ -238,12 +238,27 @@ static int efar_init_one (struct pci_dev
 		.port_ops	= &efar_ops,
 	};
 	const struct ata_port_info *ppi[] = { &info, &info };
+	struct ata_host *host;
+	int rc;
 
 	if (!printed_version++)
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			   "version " DRV_VERSION "\n");
 
-	return ata_pci_sff_init_one(pdev, ppi, &efar_sht, NULL);
+	/* enable device and prepare host */
+	rc = pcim_enable_device(pdev);
+	if (rc)
+		return rc;
+
+	rc = ata_pci_sff_prepare_host(pdev, ppi, &host);
+	if (rc)
+		return rc;
+
+	host->flags |= ATA_HOST_PARALLEL_SCAN;
+
+	pci_set_master(pdev);
+
+	return ata_pci_sff_activate_host(host, ata_sff_interrupt, &efar_sht);
 }
 
 static const struct pci_device_id efar_pci_tbl[] = {
