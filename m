Return-Path: <linux-kernel-owner+w=401wt.eu-S1753887AbZHINGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbZHINGs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 09:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870AbZHINGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 09:06:47 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:40698 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866AbZHINGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 09:06:46 -0400
Date: Sun, 9 Aug 2009 15:06:43 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Vitaly Wool <vitalywool@gmail.com>, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/i2c: Correct use of request_region/request_mem_region
Message-ID: <Pine.LNX.4.64.0908091506160.16252@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

request_mem_region should be used when ioremap is used subsequently.
release_region is then correspondingly replaced by release_mem_region.

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
expression start,E;
@@

- request_region
+ request_mem_region
  (start,...)
... when != request_mem_region(start,...)
    when != start = E
ioremap(start,...)

@@
expression r.start;
@@

- release_region
+ release_mem_region
  (start,...)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/i2c/busses/i2c-pnx.c        |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/i2c-pnx.c b/drivers/i2c/busses/i2c-pnx.c
index ec15cff..6ff6c20 100644
--- a/drivers/i2c/busses/i2c-pnx.c
+++ b/drivers/i2c/busses/i2c-pnx.c
@@ -586,7 +586,8 @@ static int __devinit i2c_pnx_probe(struct platform_device *pdev)
 	alg_data->mif.timer.data = (unsigned long)i2c_pnx->adapter;
 
 	/* Register I/O resource */
-	if (!request_region(alg_data->base, I2C_PNX_REGION_SIZE, pdev->name)) {
+	if (!request_mem_region(alg_data->base, I2C_PNX_REGION_SIZE,
+				pdev->name)) {
 		dev_err(&pdev->dev,
 		       "I/O region 0x%08x for I2C already in use.\n",
 		       alg_data->base);
@@ -650,7 +651,7 @@ out_clock:
 out_unmap:
 	iounmap((void *)alg_data->ioaddr);
 out_release:
-	release_region(alg_data->base, I2C_PNX_REGION_SIZE);
+	release_mem_region(alg_data->base, I2C_PNX_REGION_SIZE);
 out_drvdata:
 	platform_set_drvdata(pdev, NULL);
 out:
@@ -667,7 +668,7 @@ static int __devexit i2c_pnx_remove(struct platform_device *pdev)
 	i2c_del_adapter(adap);
 	i2c_pnx->set_clock_stop(pdev);
 	iounmap((void *)alg_data->ioaddr);
-	release_region(alg_data->base, I2C_PNX_REGION_SIZE);
+	release_mem_region(alg_data->base, I2C_PNX_REGION_SIZE);
 	platform_set_drvdata(pdev, NULL);
 
 	return 0;
