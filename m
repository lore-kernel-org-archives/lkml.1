Return-Path: <linux-kernel-owner+w=401wt.eu-S1756901AbZIROES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901AbZIROES (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 10:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753688AbZIROER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 10:04:17 -0400
Received: from vertical.com.s9a1.psmtp.com ([63.146.191.166]:50280 "EHLO
	mail0.vertical.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbZIROER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 10:04:17 -0400
X-Greylist: delayed 710 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Sep 2009 10:04:17 EDT
X-ASG-Debug-ID: 1253281942-1fdf000d0000-xx1T2L
X-Barracuda-URL: http://172.16.0.2:8000/cgi-bin/mark.cgi
X-Barracuda-Envelope-From: jon@ringle.org
X-ASG-Whitelist: Sender
From: Jon Ringle <jon@ringle.org>
X-Barracuda-BBL-IP: 172.19.6.1
X-Barracuda-RBL-IP: 172.19.6.1
To: "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
       Jon Ringle <jon@ringle.org>
X-ASG-Orig-Subj: [PATCH] i2c: Move i2c request_irq so that it occurs after iop3xx_i2c_enable
Subject: [PATCH] i2c: Move i2c request_irq so that it occurs after iop3xx_i2c_enable
Date: Fri, 18 Sep 2009 09:51:11 -0400
Message-Id: <1253281871-28243-1-git-send-email-jon@ringle.org>
X-Mailer: git-send-email 1.6.4.rc3.12.gdf73a
X-OriginalArrivalTime: 18 Sep 2009 13:51:56.0924 (UTC) FILETIME=[2FDC63C0:01CA3867]
X-Barracuda-Connect: UNKNOWN[172.16.0.10]
X-Barracuda-Start-Time: 1253281943
X-Barracuda-Virus-Scanned: by Barracuda Spam & Virus Firewall at vertical.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there is a pending i2c interrupt present before i2c-iop3xx initialization
then it must be cleared first before registering irq handler. Otherwise,
a hung system due to an unhandled interrupt loop may occur.

Signed-off-by: Jon Ringle <jon@ringle.org>

---
 drivers/i2c/busses/i2c-iop3xx.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/i2c/busses/i2c-iop3xx.c b/drivers/i2c/busses/i2c-iop3xx.c
index a75c75e..e6dc46d 100644
--- a/drivers/i2c/busses/i2c-iop3xx.c
+++ b/drivers/i2c/busses/i2c-iop3xx.c
@@ -471,14 +471,6 @@ iop3xx_i2c_probe(struct platform_device *pdev)
 		ret = -ENXIO;
 		goto unmap;
 	}
-	ret = request_irq(irq, iop3xx_i2c_irq_handler, 0,
-				pdev->name, adapter_data);
-
-	if (ret) {
-		ret = -EIO;
-		goto unmap;
-	}
-
 	memcpy(new_adapter->name, pdev->name, strlen(pdev->name));
 	new_adapter->owner = THIS_MODULE;
 	new_adapter->class = I2C_CLASS_HWMON | I2C_CLASS_SPD;
@@ -497,6 +489,14 @@ iop3xx_i2c_probe(struct platform_device *pdev)
 	iop3xx_i2c_reset(adapter_data);
 	iop3xx_i2c_enable(adapter_data);
 
+	ret = request_irq(irq, iop3xx_i2c_irq_handler, 0,
+				pdev->name, adapter_data);
+
+	if (ret) {
+		ret = -EIO;
+		goto unmap;
+	}
+
 	platform_set_drvdata(pdev, new_adapter);
 	new_adapter->algo_data = adapter_data;
 
-- 
tg: (74fca6a..) t/isc-31/i2c-request_irq-iop3xx_i2c_enable-reorder (depends on: b2.6.31.y)
