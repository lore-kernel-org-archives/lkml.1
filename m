Return-Path: <linux-kernel-owner+w=401wt.eu-S1755875AbZINRte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875AbZINRte (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 13:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755367AbZINRtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 13:49:12 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:47402 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571AbZINRtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 13:49:09 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH] fbdev: bfin-t350mcqb-fb: handle all resources in suspend/resume
Date: Mon, 14 Sep 2009 13:49:08 -0400
Message-Id: <1252950549-9838-2-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252950549-9838-1-git-send-email-vapier@gentoo.org>
References: <1252950549-9838-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

The LCD commands DMA/timers as well as PPI which we need to save/restore.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/video/bfin-t350mcqb-fb.c |   28 +++++++++++++++++++++++-----
 1 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/video/bfin-t350mcqb-fb.c b/drivers/video/bfin-t350mcqb-fb.c
index 5cc36cf..46cb07f 100644
--- a/drivers/video/bfin-t350mcqb-fb.c
+++ b/drivers/video/bfin-t350mcqb-fb.c
@@ -634,17 +634,35 @@ static int __devexit bfin_t350mcqb_remove(struct platform_device *pdev)
 #ifdef CONFIG_PM
 static int bfin_t350mcqb_suspend(struct platform_device *pdev, pm_message_t state)
 {
-	bfin_t350mcqb_disable_ppi();
-	disable_dma(CH_PPI);
-	bfin_write_PPI_STATUS(0xFFFF);
+	struct fb_info *fbinfo = platform_get_drvdata(pdev);
+	struct bfin_t350mcqbfb_info *fbi = fbinfo->par;
+
+	if (fbi->lq043_open_cnt) {
+		bfin_t350mcqb_disable_ppi();
+		disable_dma(CH_PPI);
+		bfin_t350mcqb_stop_timers();
+		bfin_write_PPI_STATUS(-1);
+	}
+
 
 	return 0;
 }
 
 static int bfin_t350mcqb_resume(struct platform_device *pdev)
 {
-	enable_dma(CH_PPI);
-	bfin_t350mcqb_enable_ppi();
+	struct fb_info *fbinfo = platform_get_drvdata(pdev);
+	struct bfin_t350mcqbfb_info *fbi = fbinfo->par;
+
+	if (fbi->lq043_open_cnt) {
+		bfin_t350mcqb_config_dma(fbi);
+		bfin_t350mcqb_config_ppi(fbi);
+		bfin_t350mcqb_init_timers();
+
+		/* start dma */
+		enable_dma(CH_PPI);
+		bfin_t350mcqb_enable_ppi();
+		bfin_t350mcqb_start_timers();
+	}
 
 	return 0;
 }
-- 
1.6.4.2

