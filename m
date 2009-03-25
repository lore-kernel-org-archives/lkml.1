Return-Path: <linux-kernel-owner+w=401wt.eu-S1756912AbZCYAs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912AbZCYAs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756955AbZCYAai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:30:38 -0400
Received: from kroah.org ([198.145.64.141]:54191 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756857AbZCYAaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:30:24 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Ming Lei <tom.leiming@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 50/61] driver core: fix passing platform_data
Date: Tue, 24 Mar 2009 17:26:54 -0700
Message-Id: <1237940825-22904-50-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.6.2

