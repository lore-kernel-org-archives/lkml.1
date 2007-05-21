Return-Path: <linux-kernel-owner+w=401wt.eu-S1765619AbXEUT1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765619AbXEUT1b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765372AbXEUTVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:21:32 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:46345 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765298AbXEUTV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:21:26 -0400
Message-Id: <20070521191701.791285000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:16:19 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Tejun Heo <htejun@gmail.com>, jeff@garzik.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Alan Cox <alan@redhat.com>
Subject: [patch 07/69] libata-sff: Undo bug introduced with pci_iomap changes
Content-Disposition: inline; filename=libata-sff-undo-bug-introduced-with-pci_iomap-changes.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Alan Cox <alan@lxorguk.ukuu.org.uk>

If you have a controller with one channel disabled and unmapped the new
iomap code blindly tries to iomap unconfigured BARs. Later on the code
does the right thing and checks for unmapped bars but it is done in the
wrong order

Reorder the checks and make the iomap conditional

Tejun: I think the code below is now correct but would appreciate you
giving it a review.

Signed-off-by: Alan Cox <alan@redhat.com>
Acked-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
[chrisw: Why is this not upstream yet?]

 drivers/ata/libata-sff.c |   35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

--- linux-2.6.21.1.orig/drivers/ata/libata-sff.c
+++ linux-2.6.21.1/drivers/ata/libata-sff.c
@@ -557,12 +557,30 @@ ata_pci_init_native_mode(struct pci_dev 
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
 
@@ -577,13 +595,6 @@ ata_pci_init_native_mode(struct pci_dev 
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

-- 
