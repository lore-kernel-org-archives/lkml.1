Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab0CCJc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 04:32:56 -0500
Received: from compulab.co.il ([67.18.134.219]:49315 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405Ab0CCJcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 04:32:54 -0500
Message-ID: <4B8E2CE9.3050001@compulab.co.il>
Date: Wed, 03 Mar 2010 11:33:29 +0200
From: Denis Turischev <denis@compulab.co.il>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
       Samuel Ortiz <sameo@linux.intel.com>, linux-next@vger.kernel.org,
       Mike Rapoport <mike@compulab.co.il>
Subject: sch_gpio: fix compilation warning "ignoring return value of gpiochip_remove"
References: <20100303162252.e7cf0e43.sfr@canb.auug.org.au>
In-Reply-To: <20100303162252.e7cf0e43.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denis Turischev <denis@compulab.co.il>
---
 drivers/gpio/sch_gpio.c |   25 +++++++++++++++++++++----
 1 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/sch_gpio.c b/drivers/gpio/sch_gpio.c
index 761071a..a89c02d 100644
--- a/drivers/gpio/sch_gpio.c
+++ b/drivers/gpio/sch_gpio.c
@@ -229,7 +229,12 @@ static int __devinit sch_gpio_probe(struct platform_device *pdev)
 	return 0;

 err_sch_gpio_resume:
-	gpiochip_remove(&sch_gpio_core);
+	err = gpiochip_remove(&sch_gpio_core);
+	if (err) {
+		dev_err(&pdev->dev, "%s failed, %d\n",
+				"gpiochip_remove()", err);
+		return err;
+	}

 err_sch_gpio_core:
 	release_region(res->start, resource_size(res));
@@ -240,11 +245,23 @@ err_sch_gpio_core:

 static int __devexit sch_gpio_remove(struct platform_device *pdev)
 {
+	int err_c, err_r;
 	struct resource *res;
 	if (gpio_ba) {
-		gpiochip_remove(&sch_gpio_core);
-		gpiochip_remove(&sch_gpio_resume);
-
+		err_c = gpiochip_remove(&sch_gpio_core);
+		
+		err_r = gpiochip_remove(&sch_gpio_resume);
+
+		if (err_c) {
+			dev_err(&pdev->dev, "%s failed, %d\n",
+					"gpiochip_remove()", err_c);
+			return err_c;
+		}
+		if (err_r) {
+			dev_err(&pdev->dev, "%s failed, %d\n",
+					"gpiochip_remove()", err_r);
+			return err_r;
+		}
 		res = platform_get_resource(pdev, IORESOURCE_IO, 0);

 		release_region(res->start, resource_size(res));
-- 
1.6.3.3

