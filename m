Return-Path: <linux-kernel-owner+w=401wt.eu-S1752765AbZEIDa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbZEIDa4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 23:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757527AbZEID3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 23:29:12 -0400
Received: from kroah.org ([198.145.64.141]:41365 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757433AbZEID3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 23:29:10 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Ming Lei <tom.leiming@gmail.com>, David Brownell <david-b@pacbell.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 4/5] Revert driver core: fix passing platform_data
Date: Fri,  8 May 2009 20:25:58 -0700
Message-Id: <1241839559-9157-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <20090509032432.GA9000@kroah.com>
References: <20090509032432.GA9000@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

This reverts commit ce21c7bcd796fc4f45d48781b7e85f493cc55ee5:
	We will remove platform_data field from struct device until
	all platform devices pass its specific data from platfom_device
	and all platform drivers use platform specific data passed by
	platform_device->platform_data. This kind of conversion will
	need a long time, for thousands of files is affected.

	To make the conversion easily, we allow platform specific data
	passed by struct device or struct platform_device and platform
	driver may use it from struct device or struct platform_device.

As we really don't want to do this at all.


Cc: David Brownell <david-b@pacbell.net>
Cc: Ming Lei <tom.leiming@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/platform.c |   15 +--------------
 1 files changed, 1 insertions(+), 14 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index ec5400c..d1d0ee4 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -247,20 +247,7 @@ int platform_device_add(struct platform_device *pdev)
 	else
 		dev_set_name(&pdev->dev, pdev->name);
 
-	/* We will remove platform_data field from struct device
-	* if all platform devices pass its platform specific data
-	* from platform_device. The conversion is going to be a
-	* long time, so we allow the two cases coexist to make
-	* this kind of fix more easily*/
-	if (pdev->platform_data && pdev->dev.platform_data) {
-		printk(KERN_ERR
-			       "%s: use which platform_data?\n",
-			       dev_name(&pdev->dev));
-	} else if (pdev->platform_data) {
-		pdev->dev.platform_data = pdev->platform_data;
-	} else if (pdev->dev.platform_data) {
-		pdev->platform_data = pdev->dev.platform_data;
-	}
+	pdev->platform_data = pdev->dev.platform_data;
 
 	for (i = 0; i < pdev->num_resources; i++) {
 		struct resource *p, *r = &pdev->resource[i];
-- 
1.6.3

