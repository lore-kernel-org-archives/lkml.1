Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbYDWVqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbYDWVqQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 17:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbYDWVp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 17:45:59 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:53683 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbYDWVp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 17:45:59 -0400
Message-ID: <480FADA3.7030708@tiscali.nl>
Date: Wed, 23 Apr 2008 23:44:03 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: rmk@arm.linux.org.uk, Linux-arm <linux-arm-kernel@lists.arm.linux.org.uk>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] ARM: am79c961a: platform_get_irq() may return signed unnoticed
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev->irq is unsigned, platform_get_irq() may return signed unnoticed

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/net/arm/am79c961a.c b/drivers/net/arm/am79c961a.c
index ba6bd03..a637910 100644
--- a/drivers/net/arm/am79c961a.c
+++ b/drivers/net/arm/am79c961a.c
@@ -693,11 +693,15 @@ static int __init am79c961_probe(struct platform_device *pdev)
 	 * done by the ether bootp loader.
 	 */
 	dev->base_addr = res->start;
-	dev->irq = platform_get_irq(pdev, 0);
+	ret = platform_get_irq(pdev, 0);
 
-	ret = -ENODEV;
-	if (dev->irq < 0)
+	if (ret < 0) {
+		ret = -ENODEV;
 		goto nodev;
+	}
+	dev->irq = ret;
+
+	ret = -ENODEV;
 	if (!request_region(dev->base_addr, 0x18, dev->name))
 		goto nodev;
 
