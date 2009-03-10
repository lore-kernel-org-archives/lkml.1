Return-Path: <linux-kernel-owner+w=401wt.eu-S1756860AbZCJQFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860AbZCJQFr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756118AbZCJQEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:04:54 -0400
Received: from smtp.nokia.com ([192.100.122.230]:18841 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405AbZCJQEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:04:53 -0400
From: Atal Shargorodsky <ext-atal.shargorodsky@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk,
       Atal Shargorodsky <ext-atal.shargorodsky@nokia.com>
Subject: [PATCH 2/6] Fix interface clock existance check.
Date: Tue, 10 Mar 2009 18:03:52 +0200
Message-Id: <0fe7f2934f8416e9b5f05e2f18766362560116ee.1236609434.git.ext-atal.shargorodsky@nokia.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <cbbca1e42421e2ada459f0c0881f087977e34eed.1236609434.git.ext-atal.shargorodsky@nokia.com>
References: <>
 <1236701036-19942-1-git-send-email-ext-atal.shargorodsky@nokia.com>
 <cbbca1e42421e2ada459f0c0881f087977e34eed.1236609434.git.ext-atal.shargorodsky@nokia.com>
In-Reply-To: <cbbca1e42421e2ada459f0c0881f087977e34eed.1236609434.git.ext-atal.shargorodsky@nokia.com>
References: <cbbca1e42421e2ada459f0c0881f087977e34eed.1236609434.git.ext-atal.shargorodsky@nokia.com>
X-OriginalArrivalTime: 10 Mar 2009 16:04:34.0859 (UTC) FILETIME=[E7D8E7B0:01C9A199]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When enabling/disabling the iterface clock, the question
to be asked is if this clock exists rather than to
decide about it's existance by retrieving the chip version.
It can be done only once at init time.

Signed-off-by: Atal Shargorodsky <ext-atal.shargorodsky@nokia.com>
---
 drivers/watchdog/omap_wdt.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
index 5b72c7c..05dc55a 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -145,7 +145,7 @@ static int omap_wdt_open(struct inode *inode, struct file *file)
 	if (test_and_set_bit(1, (unsigned long *)&(wdev->omap_wdt_users)))
 		return -EBUSY;
 
-	if (cpu_is_omap24xx() || cpu_is_omap34xx())
+	if (wdev->mpu_wdt_ick)
 		clk_enable(wdev->mpu_wdt_ick);    /* Enable the interface clock */
 
 	clk_enable(wdev->mpu_wdt_fck);    /* Enable the functional clock */
@@ -177,7 +177,7 @@ static int omap_wdt_release(struct inode *inode, struct file *file)
 
 	omap_wdt_disable(wdev);
 
-	if (cpu_is_omap24xx() || cpu_is_omap34xx())
+	if (wdev->mpu_wdt_ick)
 		clk_disable(wdev->mpu_wdt_ick);	/* Disable the clock */
 
 	clk_disable(wdev->mpu_wdt_fck);	/* Disable the clock */
@@ -344,7 +344,7 @@ static int __init omap_wdt_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, wdev);
 
 	/* enable clocks for register access */
-	if (cpu_is_omap24xx() || cpu_is_omap34xx())
+	if (wdev->mpu_wdt_ick)
 		clk_enable(wdev->mpu_wdt_ick);    /* Enable the interface clock */
 
 	clk_enable(wdev->mpu_wdt_fck);    /* Enable the functional clock */
@@ -369,7 +369,7 @@ static int __init omap_wdt_probe(struct platform_device *pdev)
 	__raw_writel(0x01, wdev->base + OMAP_WATCHDOG_SYS_CONFIG);
 
 	/* disable clocks since we don't need them now */
-	if (cpu_is_omap24xx() || cpu_is_omap34xx())
+	if (wdev->mpu_wdt_ick)
 		clk_disable(wdev->mpu_wdt_ick);	/* Disable the clock */
 	clk_disable(wdev->mpu_wdt_fck);	/* Disable the clock */
 
-- 
1.5.4.3

