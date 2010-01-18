Return-Path: <linux-kernel-owner+w=401wt.eu-S1754276Ab0ARRQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276Ab0ARRQJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:16:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754233Ab0ARRQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:16:00 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:61470 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039Ab0ARRP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:15:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=jK17Wh083+xVbmykvqZhqmbgP6ccVgsU4TAh7y18BpQARTVidqqR7en9PoxMoElMED
         gq/IAjQCbVqUwowRscpfPYbNgMMeiUQj9uzgrAFT31muzZKJHFi0oZG//fcCgz31r2zQ
         +/lGGwWlYT1koTcM5EutAEQTRgIPQ9Dic7P7Q=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:14:47 +0100
Message-Id: <20100118171447.14623.47438.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 07/64] pata_atiixp: enable parallel scan
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_atiixp: enable parallel scan

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_atiixp.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

Index: b/drivers/ata/pata_atiixp.c
===================================================================
--- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -189,8 +189,23 @@ static int atiixp_init_one(struct pci_de
 		.port_ops = &atiixp_port_ops
 	};
 	const struct ata_port_info *ppi[] = { &info, &info };
+	struct ata_host *host;
+	int rc;
 
-	return ata_pci_sff_init_one(pdev, ppi, &atiixp_sht, NULL);
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
+	return ata_pci_sff_activate_host(host, ata_sff_interrupt, &atiixp_sht);
 }
 
 static const struct pci_device_id atiixp[] = {
