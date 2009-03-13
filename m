Return-Path: <linux-kernel-owner+w=401wt.eu-S1758499AbZCMPHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758499AbZCMPHX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 11:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752840AbZCMPHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 11:07:08 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:32037 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbZCMPHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 11:07:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=GeoSKNlfOJg+0dukc8tmN7yUvJDl6yEcCHTX51p9HFUT9N9NEGA90V/fgoypCWPYkR
         gzR2SxeHaQ3qFVXY6taydnOFtMfCiTUpSlyATsyPIE/CvFRvDHvJXsKPUCQ96Eh7V80R
         3snrjYS8ATTcPtyTR5fPW/ADne1ygU6Zr+8AA=
From: tom.leiming@gmail.com
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH] driver core: fix passing platform_data
Date: Fri, 13 Mar 2009 23:06:59 +0800
Message-Id: <1236956819-13412-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

We will remove platform_data field from struct device until
all platform devices pass its specific data from platfom_device
and all platform drivers use platform specific data passed by
platform_device->platform_data. This kind of conversion will
need a long time, for thousands of files is affected.

To make the conversion easily, we allow platform specific data
passed by struct device or struct platform_device and platform
driver may use it from struct device or struct platform_device.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/base/platform.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index c5ac81d..d2198f6 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -247,7 +247,20 @@ int platform_device_add(struct platform_device *pdev)
 	else
 		dev_set_name(&pdev->dev, pdev->name);
 
-	pdev->platform_data = pdev->dev.platform_data;
+	/* We will remove platform_data field from struct device
+	* if all platform devices pass its platform specific data
+	* from platform_device. The conversion is going to be a
+	* long time, so we allow the two cases coexist to make
+	* this kind of fix more easily*/
+	if (pdev->platform_data && pdev->dev.platform_data) {
+		printk(KERN_ERR
+			       "%s: use which platform_data?\n",
+			       dev_name(&pdev->dev));
+	} else if (pdev->platform_data) {
+		pdev->dev.platform_data = pdev->platform_data;
+	} else if (pdev->dev.platform_data) {
+		pdev->platform_data = pdev->dev.platform_data;
+	}
 
 	for (i = 0; i < pdev->num_resources; i++) {
 		struct resource *p, *r = &pdev->resource[i];
-- 
1.6.0.GIT

