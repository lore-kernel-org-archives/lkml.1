Return-Path: <linux-kernel-owner+w=401wt.eu-S932184AbXEALti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184AbXEALti (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 07:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932247AbXEALti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 07:49:38 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43137 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932184AbXEALtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 07:49:36 -0400
Date: Tue, 1 May 2007 12:53:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <htejun@gmail.com>, jeff@garzik.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] libata-sff: Undo bug introduced with pci_iomap changes
Message-ID: <20070501125327.52dd92e4@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If you have a controller with one channel disabled and unmapped the new
iomap code blindly tries to iomap unconfigured BARs. Later on the code
does the right thing and checks for unmapped bars but it is done in the
wrong order

Reorder the checks and make the iomap conditional

Tejun: I think the code below is now correct but would appreciate you
giving it a review.

Signed-off-by: Alan Cox <alan@redhat.com>

--- drivers/ata/libata-sff.c~	2007-05-01 12:03:39.634876384 +0100
+++ drivers/ata/libata-sff.c	2007-05-01 12:03:39.634876384 +0100
@@ -557,12 +557,30 @@
 	int i, p = 0;
 	void __iomem * const *iomap;
 
+	/* Discard disabled ports. Some controllers show their
+	   unused channels this way */
+	if (ata_resources_present(pdev, 0) == 0)
+		ports &= ~ATA_PORT_PRIMARY;
+	if (ata_resources_present(pdev, 1) == 0)
+		ports &= ~ATA_PORT_SECONDARY;
+
 	/* iomap BARs */
-	for (i = 0; i < 4; i++) {
-		if (pcim_iomap(pdev, i, 0) == NULL) {
-			dev_printk(KERN_ERR, &pdev->dev,
-				   "failed to iomap PCI BAR %d\n", i);
-			return NULL;
+	if (ports & ATA_PORT_PRIMARY) {
+		for (i = 0; i <= 1; i++) {
+			if (pcim_iomap(pdev, i, 0) == NULL) {
+				dev_printk(KERN_ERR, &pdev->dev,
+					   "failed to iomap PCI BAR %d\n", i);
+				return NULL;
+			}
+		}
+	}
+	if (ports & ATA_PORT_SECONDARY) {
+		for (i = 2; i <= 3; i++) {
+			if (pcim_iomap(pdev, i, 0) == NULL) {
+				dev_printk(KERN_ERR, &pdev->dev,
+					   "failed to iomap PCI BAR %d\n", i);
+				return NULL;
+			}
 		}
 	}
 
@@ -577,13 +595,6 @@
 	probe_ent->irq = pdev->irq;
 	probe_ent->irq_flags = IRQF_SHARED;
 
-	/* Discard disabled ports. Some controllers show their
-	   unused channels this way */
-	if (ata_resources_present(pdev, 0) == 0)
-		ports &= ~ATA_PORT_PRIMARY;
-	if (ata_resources_present(pdev, 1) == 0)
-		ports &= ~ATA_PORT_SECONDARY;
-
 	if (ports & ATA_PORT_PRIMARY) {
 		probe_ent->port[p].cmd_addr = iomap[0];
 		probe_ent->port[p].altstatus_addr =
