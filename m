Return-Path: <linux-kernel-owner+w=401wt.eu-S1758712AbZIFVJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712AbZIFVJI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 17:09:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758704AbZIFVJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 17:09:07 -0400
Received: from server1.wserver.cz ([82.113.45.157]:60201 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758701AbZIFVJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 17:09:06 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: airlied@linux.ie
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] AGP: amd64, fix pci reference leaks
Date: Sun,  6 Sep 2009 23:09:07 +0200
Message-Id: <1252271347-25951-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found pci reference leaks in uli_agp_init and
nforce3_agp_init initialization functions.

The PCI devices are bridges, so it's not critical, but still
worth fixing.

http://stanse.fi.muni.cz/

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: David Airlie <airlied@linux.ie>
---
 drivers/char/agp/amd64-agp.c |   28 ++++++++++++++++++----------
 1 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
index 2fb2e6c..258c712 100644
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -383,7 +383,7 @@ static int __devinit uli_agp_init(struct pci_dev *pdev)
 {
 	u32 httfea,baseaddr,enuscr;
 	struct pci_dev *dev1;
-	int i;
+	int i, ret;
 	unsigned size = amd64_fetch_size();
 
 	dev_info(&pdev->dev, "setting up ULi AGP\n");
@@ -399,15 +399,18 @@ static int __devinit uli_agp_init(struct pci_dev *pdev)
 
 	if (i == ARRAY_SIZE(uli_sizes)) {
 		dev_info(&pdev->dev, "no ULi size found for %d\n", size);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto put;
 	}
 
 	/* shadow x86-64 registers into ULi registers */
 	pci_read_config_dword (k8_northbridges[0], AMD64_GARTAPERTUREBASE, &httfea);
 
 	/* if x86-64 aperture base is beyond 4G, exit here */
-	if ((httfea & 0x7fff) >> (32 - 25))
-		return -ENODEV;
+	if ((httfea & 0x7fff) >> (32 - 25)) {
+		ret = -ENODEV;
+		goto put;
+	}
 
 	httfea = (httfea& 0x7fff) << 25;
 
@@ -419,9 +422,10 @@ static int __devinit uli_agp_init(struct pci_dev *pdev)
 	enuscr= httfea+ (size * 1024 * 1024) - 1;
 	pci_write_config_dword(dev1, ULI_X86_64_HTT_FEA_REG, httfea);
 	pci_write_config_dword(dev1, ULI_X86_64_ENU_SCR_REG, enuscr);
-
+	ret = 0;
+put:
 	pci_dev_put(dev1);
-	return 0;
+	return ret;
 }
 
 
@@ -440,7 +444,7 @@ static int nforce3_agp_init(struct pci_dev *pdev)
 {
 	u32 tmp, apbase, apbar, aplimit;
 	struct pci_dev *dev1;
-	int i;
+	int i, ret;
 	unsigned size = amd64_fetch_size();
 
 	dev_info(&pdev->dev, "setting up Nforce3 AGP\n");
@@ -457,7 +461,8 @@ static int nforce3_agp_init(struct pci_dev *pdev)
 
 	if (i == ARRAY_SIZE(nforce3_sizes)) {
 		dev_info(&pdev->dev, "no NForce3 size found for %d\n", size);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto put;
 	}
 
 	pci_read_config_dword(dev1, NVIDIA_X86_64_1_APSIZE, &tmp);
@@ -471,7 +476,8 @@ static int nforce3_agp_init(struct pci_dev *pdev)
 	/* if x86-64 aperture base is beyond 4G, exit here */
 	if ( (apbase & 0x7fff) >> (32 - 25) ) {
 		dev_info(&pdev->dev, "aperture base > 4G\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto put;
 	}
 
 	apbase = (apbase & 0x7fff) << 25;
@@ -487,9 +493,11 @@ static int nforce3_agp_init(struct pci_dev *pdev)
 	pci_write_config_dword(dev1, NVIDIA_X86_64_1_APBASE2, apbase);
 	pci_write_config_dword(dev1, NVIDIA_X86_64_1_APLIMIT2, aplimit);
 
+	ret = 0;
+put:
 	pci_dev_put(dev1);
 
-	return 0;
+	return ret;
 }
 
 static int __devinit agp_amd64_probe(struct pci_dev *pdev,
-- 
1.6.4.2

