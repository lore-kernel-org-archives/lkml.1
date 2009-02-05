Return-Path: <linux-kernel-owner+w=401wt.eu-S1759356AbZBEQ4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759356AbZBEQ4N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 11:56:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758881AbZBEQyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 11:54:15 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:24489 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758820AbZBEQyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 11:54:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Q9j/Cuu1eO9gY0gIrkgmxzdWMC01Vn8l3V5OQ5H1AZIi4Z4ayKwsVXymXJPH17AOHK
         ysrInTNsPTzYtzxBPuvseMbvownMQiJ5RaMNTcZo0U+Za1XFmi+nGWL7+hixVOrgxfaz
         wGM+39ykIn5jST1RfrG6q1PqkXGlwj1es90qE=
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@openedhand.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Matt Reimer <mreimer@vpop.net>,
       Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH 6/6] mfd: PASIC3: supply clock_rate to DS1WM via driver_data
Date: Thu,  5 Feb 2009 17:53:40 +0100
Message-Id: <1233852820-28549-7-git-send-email-philipp.zabel@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1233852820-28549-1-git-send-email-philipp.zabel@gmail.com>
References: <1233852820-28549-1-git-send-email-philipp.zabel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/mfd/htc-pasic3.c |   22 +++++++++++++---------
 1 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/htc-pasic3.c b/drivers/mfd/htc-pasic3.c
index 92b6837..386da15 100644
--- a/drivers/mfd/htc-pasic3.c
+++ b/drivers/mfd/htc-pasic3.c
@@ -167,15 +167,19 @@ static int __init pasic3_probe(struct platform_device *pdev)
 	/* calculate bus shift from mem resource */
 	asic->bus_shift = (resource_size(r) - 5) >> 3;
 
-	/* the first 5 PASIC3 registers control the DS1WM */
-	ds1wm_resources[0].end = (5 << asic->bus_shift) - 1;
-	ds1wm_cell.platform_data = &ds1wm_cell;
-	ds1wm_cell.data_size = sizeof(ds1wm_cell);
-	ret = mfd_add_devices(&pdev->dev, pdev->id, &ds1wm_cell, 1, r, irq);
-	if (ret < 0)
-		dev_warn(dev, "failed to register DS1WM\n");
-
-	if (pdata->led_pdata) {
+	if (pdata && pdata->clock_rate) {
+		ds1wm_pdata.clock_rate = pdata->clock_rate;
+		/* the first 5 PASIC3 registers control the DS1WM */
+		ds1wm_resources[0].end = (5 << asic->bus_shift) - 1;
+		ds1wm_cell.platform_data = &ds1wm_cell;
+		ds1wm_cell.data_size = sizeof(ds1wm_cell);
+		ret = mfd_add_devices(&pdev->dev, pdev->id,
+				&ds1wm_cell, 1, r, irq);
+		if (ret < 0)
+			dev_warn(dev, "failed to register DS1WM\n");
+	}
+
+	if (pdata && pdata->led_pdata) {
 		led_cell.driver_data = pdata->led_pdata;
 		led_cell.platform_data = &led_cell;
 		led_cell.data_size = sizeof(ds1wm_cell);
-- 
1.5.6.5

