Return-Path: <linux-kernel-owner+w=401wt.eu-S1757285AbYHOJH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285AbYHOJH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 05:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753618AbYHOJHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 05:07:18 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:61756 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483AbYHOJHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 05:07:17 -0400
X-IronPort-AV: E=Sophos;i="4.32,214,1217822400"; 
   d="scan'208";a="73537341"
From: Bryan Wu <cooloney@kernel.org>
To: adaplas@gmail.com, linux-fbdev-devel@lists.sourceforge.net
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/1] Video/Framebuffer: add fuctional power management support to Blackfin BF54x LQ043 framebuffer driver
Date: Fri, 15 Aug 2008 17:07:08 +0800
Message-Id: <1218791228-12974-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Fix bug: does nor properply resume after suspend mem
Fix for PM_SUSPEND_MEM: Save and restore peripheral base and DMA registers

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/video/bf54x-lq043fb.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/video/bf54x-lq043fb.c b/drivers/video/bf54x-lq043fb.c
index 940467a..6d5aa80 100644
--- a/drivers/video/bf54x-lq043fb.c
+++ b/drivers/video/bf54x-lq043fb.c
@@ -733,7 +733,6 @@ static int bfin_bf54x_remove(struct platform_device *pdev)
 static int bfin_bf54x_suspend(struct platform_device *pdev, pm_message_t state)
 {
 	struct fb_info *fbinfo = platform_get_drvdata(pdev);
-	struct bfin_bf54xfb_info *info = fbinfo->par;
 
 	bfin_write_EPPI0_CONTROL(bfin_read_EPPI0_CONTROL() & ~EPPI_EN);
 	disable_dma(CH_EPPI0);
@@ -747,8 +746,18 @@ static int bfin_bf54x_resume(struct platform_device *pdev)
 	struct fb_info *fbinfo = platform_get_drvdata(pdev);
 	struct bfin_bf54xfb_info *info = fbinfo->par;
 
-	enable_dma(CH_EPPI0);
-	bfin_write_EPPI0_CONTROL(bfin_read_EPPI0_CONTROL() | EPPI_EN);
+	if (info->lq043_open_cnt) {
+
+		bfin_write_EPPI0_CONTROL(0);
+		SSYNC();
+
+		config_dma(info);
+		config_ppi(info);
+
+		/* start dma */
+		enable_dma(CH_EPPI0);
+		bfin_write_EPPI0_CONTROL(bfin_read_EPPI0_CONTROL() | EPPI_EN);
+	}
 
 	return 0;
 }
-- 
1.5.6
