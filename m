Return-Path: <linux-kernel-owner+w=401wt.eu-S1752357Ab0ATNWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357Ab0ATNWU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 08:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750942Ab0ATNWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 08:22:18 -0500
Received: from smtp.mujha-vel.cz ([81.30.225.246]:37180 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab0ATNWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 08:22:18 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Richard Purdie <rpurdie@rpsys.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org
Subject: [PATCH 1/1] video: backlight/progear, fix pci device refcounting
Date: Wed, 20 Jan 2010 14:22:14 +0100
Message-Id: <1263993734-23954-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found an ommitted pci_dev_puts on error path in
progearbl_probe. pmu_dev and sb_dev are gotten, but never put when
backlight_device_register fails.

So unify fail paths and put the devs when the failure occurs.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org
---
 drivers/video/backlight/progear_bl.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/video/backlight/progear_bl.c b/drivers/video/backlight/progear_bl.c
index 075786e..2ec16de 100644
--- a/drivers/video/backlight/progear_bl.c
+++ b/drivers/video/backlight/progear_bl.c
@@ -63,6 +63,7 @@ static int progearbl_probe(struct platform_device *pdev)
 {
 	u8 temp;
 	struct backlight_device *progear_backlight_device;
+	int ret;
 
 	pmu_dev = pci_get_device(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M7101, NULL);
 	if (!pmu_dev) {
@@ -73,8 +74,8 @@ static int progearbl_probe(struct platform_device *pdev)
 	sb_dev = pci_get_device(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M1533, NULL);
 	if (!sb_dev) {
 		printk("ALI 1533 SB not found.\n");
-		pci_dev_put(pmu_dev);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto put_pmu;
 	}
 
 	/*     Set SB_MPS1 to enable brightness control. */
@@ -84,8 +85,10 @@ static int progearbl_probe(struct platform_device *pdev)
 	progear_backlight_device = backlight_device_register("progear-bl",
 							     &pdev->dev, NULL,
 							     &progearbl_ops);
-	if (IS_ERR(progear_backlight_device))
-		return PTR_ERR(progear_backlight_device);
+	if (IS_ERR(progear_backlight_device)) {
+		ret = PTR_ERR(progear_backlight_device);
+		goto put_sb;
+	}
 
 	platform_set_drvdata(pdev, progear_backlight_device);
 
@@ -95,6 +98,11 @@ static int progearbl_probe(struct platform_device *pdev)
 	progearbl_set_intensity(progear_backlight_device);
 
 	return 0;
+put_sb:
+	pci_dev_put(sb_dev);
+put_pmu:
+	pci_dev_put(pmu_dev);
+	return ret;
 }
 
 static int progearbl_remove(struct platform_device *pdev)
-- 
1.6.5.7

