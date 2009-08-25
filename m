Return-Path: <linux-kernel-owner+w=401wt.eu-S1754699AbZHYJPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbZHYJPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 05:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbZHYJPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 05:15:24 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:37289 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181AbZHYJPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 05:15:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=E0+yssIGGw4SiYbo2KUSNJot9X2scEzX665SwqwEMUYJn35LvPUT4vyYLwp8zmnWOp
         L+IcOPQdnIizyQZu1pxHpw65qYvW2ZYEbCSBBT210JHIrOjFVAejlkK+dXlJZokyNS7e
         MzkEHcKxJ/poU0+B/Jr4uBtbMShDXlxmWfLWk=
Message-ID: <4A93ACDA.8030000@gmail.com>
Date: Tue, 25 Aug 2009 11:20:26 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Wim Van Sebroeck <wim@iguana.be>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] txx9wdt.c:52: Fix txx9wdt_probe() cleaning up after errors
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make txx9wdt_probe() clean up after errors.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Any comments?

diff --git a/drivers/watchdog/txx9wdt.c b/drivers/watchdog/txx9wdt.c
index 6adab77..1e15de3 100644
--- a/drivers/watchdog/txx9wdt.c
+++ b/drivers/watchdog/txx9wdt.c
@@ -212,25 +212,31 @@ static int __init txx9wdt_probe(struct platform_device *dev)
 	}
 
 	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
-	if (!res)
-		goto exit_busy;
+	if (!res) {
+		ret = -EBUSY;
+		goto exit;
+	}
 	if (!devm_request_mem_region(&dev->dev,
 				     res->start, res->end - res->start + 1,
-				     "txx9wdt"))
-		goto exit_busy;
+				     "txx9wdt")) {
+		ret = -EBUSY;
+		goto exit;
+	}
 	txx9wdt_reg = devm_ioremap(&dev->dev,
 				   res->start, res->end - res->start + 1);
-	if (!txx9wdt_reg)
-		goto exit_busy;
+	if (!txx9wdt_reg) {
+		ret = -EBUSY;
+		goto exit_release_mem;
+	}
 
 	ret = register_reboot_notifier(&txx9wdt_notifier);
 	if (ret)
-		goto exit;
+		goto exit_iounmap;
 
 	ret = misc_register(&txx9wdt_miscdev);
 	if (ret) {
 		unregister_reboot_notifier(&txx9wdt_notifier);
-		goto exit;
+		goto exit_iounmap;
 	}
 
 	printk(KERN_INFO "Hardware Watchdog Timer for TXx9: "
@@ -238,8 +244,11 @@ static int __init txx9wdt_probe(struct platform_device *dev)
 	       timeout, WD_MAX_TIMEOUT, nowayout);
 
 	return 0;
-exit_busy:
-	ret = -EBUSY;
+
+exit_iounmap:
+	devm_iounmap(&dev->dev, txx9wdt_reg);
+exit_release_mem:
+	devm_release_mem_region(&dev->dev, res->start, res->end - res->start + 1);
 exit:
 	if (txx9_imclk) {
 		clk_disable(txx9_imclk);
