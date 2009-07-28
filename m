Return-Path: <linux-kernel-owner+w=401wt.eu-S1753362AbZG1L4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbZG1L4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 07:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbZG1L4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 07:56:47 -0400
Received: from dakia2.marvell.com ([65.219.4.35]:53606 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbZG1L4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 07:56:46 -0400
X-ASG-Debug-ID: 1248782206-48b800120000-xx1T2L
X-Barracuda-URL: http://10.68.76.222:80/cgi-bin/mark.cgi
From: Saeed Bishara <saeed@marvell.com>
To: linux-kernel@vger.kernel.org, testers@vger.kernel.org, david-b@pacbell.net,
       David.Woodhouse@intel.com, eric.y.miao@gmail.com
Cc: Saeed Bishara <saeed@marvell.com>
X-ASG-Orig-Subj: [PATCH] [MTD] fix the conversion from dev to mtd_info
Subject: [PATCH] [MTD] fix the conversion from dev to mtd_info
Date: Tue, 28 Jul 2009 14:56:43 +0300
Message-Id: <1248782203-13095-1-git-send-email-saeed@marvell.com>
X-Mailer: git-send-email 1.6.0.4
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1248782206
X-Barracuda-Virus-Scanned: by dakia2.marvell.com at marvell.com
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch fixes a bug when converting dev to mtd_info by using the
drvdata of the dev, the previous code used
container_of(dev, struct mtd_info, dev), but won't work for the mtdXro
devices as they created without being contained inside mtd_info structure.

Signed-off-by: Saeed Bishara <saeed@marvell.com>
---
 drivers/mtd/mtdcore.c   |    7 ++++---
 include/linux/mtd/mtd.h |    2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index fac54a3..00ebf7a 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -65,8 +65,8 @@ static void mtd_release(struct device *dev)
 static int mtd_cls_suspend(struct device *dev, pm_message_t state)
 {
 	struct mtd_info *mtd = dev_to_mtd(dev);
-	
-	if (mtd->suspend)
+
+	if (mtd && mtd->suspend)
 		return mtd->suspend(mtd);
 	else
 		return 0;
@@ -76,7 +76,7 @@ static int mtd_cls_resume(struct device *dev)
 {
 	struct mtd_info *mtd = dev_to_mtd(dev);
 	
-	if (mtd->resume)
+	if (mtd && mtd->resume)
 		mtd->resume(mtd);
 	return 0;
 }
@@ -298,6 +298,7 @@ int add_mtd_device(struct mtd_info *mtd)
 			mtd->dev.class = &mtd_class;
 			mtd->dev.devt = MTD_DEVT(i);
 			dev_set_name(&mtd->dev, "mtd%d", i);
+			dev_set_drvdata(&mtd->dev, mtd);
 			if (device_register(&mtd->dev) != 0) {
 				mtd_table[i] = NULL;
 				break;
diff --git a/include/linux/mtd/mtd.h b/include/linux/mtd/mtd.h
index 5675b63..0f32a9b 100644
--- a/include/linux/mtd/mtd.h
+++ b/include/linux/mtd/mtd.h
@@ -251,7 +251,7 @@ struct mtd_info {
 
 static inline struct mtd_info *dev_to_mtd(struct device *dev)
 {
-	return dev ? container_of(dev, struct mtd_info, dev) : NULL;
+	return dev ? dev_get_drvdata(dev) : NULL;
 }
 
 static inline uint32_t mtd_div_by_eb(uint64_t sz, struct mtd_info *mtd)
-- 
1.6.0.4

