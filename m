Return-Path: <linux-kernel-owner+w=401wt.eu-S965298AbXBLSv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965298AbXBLSv5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 13:51:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965302AbXBLSv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 13:51:57 -0500
Received: from wx-out-0506.google.com ([66.249.82.233]:15190 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965298AbXBLSvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 13:51:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=BNMc035Jk0QBKiXg7ED4+vT5Xl1forAGE9BVQBwJSvDUbrgQ9JYXjo0KtfGS2I3dA47L9EiLFcB3w59NnBL/nlCG9OGV+Pe4AGKs7YpL2I1O70AaZ/Lyav8TsndQfa7eFoDkd154TNBCpSQhgR5kFNsIlY3hqIu4c1o6d3Lwoqk=
Message-ID: <45D0B740.9050704@gmail.com>
Date: Mon, 12 Feb 2007 10:51:44 -0800
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Markus Trippelsdorf <markus@trippelsdorf.de>
CC: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sata_via: fix resource-managed iomap conversion
References: <20070210010914.GA19717@havoc.gtf.org> <20070210054629.GA4395@gentoox2.trippelsdorf.de> <45CF93D1.9080009@gmail.com> <20070212025843.GA4406@gentoox2.trippelsdorf.de>
In-Reply-To: <20070212025843.GA4406@gentoox2.trippelsdorf.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Conversion to resource-managed iomap was buggy causing init failures
on both vt6420 and 6421 - BAR5 wasn't mapped for both controllers
while on vt6420 sata_via tried to map BAR0-4 twice.  Fix it.

DO NOT APPLY YET.
---
Markus, does this fix your problem?

diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index baca6d7..fe9101a 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -423,16 +423,21 @@ static struct ata_probe_ent *vt6420_init_probe_ent(struct pci_dev *pdev)
 {
 	struct ata_probe_ent *probe_ent;
 	struct ata_port_info *ppi[2];
-	void __iomem * const *iomap;
+	void __iomem *bar5;
 
 	ppi[0] = ppi[1] = &vt6420_port_info;
 	probe_ent = ata_pci_init_native_mode(pdev, ppi, ATA_PORT_PRIMARY | ATA_PORT_SECONDARY);
 	if (!probe_ent)
 		return NULL;
 
-	iomap = pcim_iomap_table(pdev);
-	probe_ent->port[0].scr_addr = svia_scr_addr(iomap[5], 0);
-	probe_ent->port[1].scr_addr = svia_scr_addr(iomap[5], 1);
+	bar5 = pcim_iomap(pdev, 5, 0);
+	if (!bar5) {
+		dev_printk(KERN_ERR, &pdev->dev, "failed to iomap PCI BAR 5\n");
+		return NULL;
+	}
+
+	probe_ent->port[0].scr_addr = svia_scr_addr(bar5, 0);
+	probe_ent->port[1].scr_addr = svia_scr_addr(bar5, 1);
 
 	return probe_ent;
 }
@@ -460,6 +465,13 @@ static struct ata_probe_ent *vt6421_init_probe_ent(struct pci_dev *pdev)
 	probe_ent->mwdma_mask	= 0x07;
 	probe_ent->udma_mask	= 0x7f;
 
+	for (i = 0; i < 6; i++)
+		if (!pcim_iomap(pdev, i, 0)) {
+			dev_printk(KERN_ERR, &pdev->dev,
+				   "failed to iomap PCI BAR %d\n", i);
+			return NULL;
+		}
+
 	for (i = 0; i < N_PORTS; i++)
 		vt6421_init_addrs(probe_ent, pcim_iomap_table(pdev), i);
 
@@ -522,7 +534,7 @@ static int svia_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		return rc;
 
-	rc = pcim_iomap_regions(pdev, 0x1f, DRV_NAME);
+	rc = pci_request_regions(pdev, DRV_NAME);
 	if (rc) {
 		pcim_pin_device(pdev);
 		return rc;
