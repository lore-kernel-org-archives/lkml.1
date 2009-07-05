Return-Path: <linux-kernel-owner+w=401wt.eu-S1755637AbZGEGh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637AbZGEGh7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 02:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754580AbZGEGhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 02:37:50 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:48560 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641AbZGEGht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 02:37:49 -0400
Date: Sun, 5 Jul 2009 08:37:50 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: linux-i2c@vger.kernel.org, linus.walleij@stericsson.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 5/5] drivers/i2c: Use resource_size
Message-ID: <Pine.LNX.4.64.0907050837160.27464@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use the function resource_size, which reduces the chance of introducing
off-by-one errors in calculating the resource size.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
struct resource *res;
@@

- (res->end - res->start) + 1
+ resource_size(res)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/i2c/busses/i2c-davinci.c   |    6 +++---
 drivers/i2c/busses/i2c-omap.c      |    6 +++---
 drivers/i2c/busses/i2c-sh_mobile.c |    2 +-
 drivers/i2c/busses/i2c-simtec.c    |    2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff -u -p a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
--- a/drivers/i2c/busses/i2c-davinci.c 2009-03-28 23:34:54.000000000 +0100
+++ b/drivers/i2c/busses/i2c-davinci.c 2009-07-04 21:38:17.000000000 +0200
@@ -505,7 +505,7 @@ static int davinci_i2c_probe(struct plat
 		return -ENODEV;
 	}
 
-	ioarea = request_mem_region(mem->start, (mem->end - mem->start) + 1,
+	ioarea = request_mem_region(mem->start, resource_size(mem),
 				    pdev->name);
 	if (!ioarea) {
 		dev_err(&pdev->dev, "I2C region already claimed\n");
@@ -568,7 +568,7 @@ err_free_mem:
 	put_device(&pdev->dev);
 	kfree(dev);
 err_release_region:
-	release_mem_region(mem->start, (mem->end - mem->start) + 1);
+	release_mem_region(mem->start, resource_size(mem));
 
 	return r;
 }
@@ -591,7 +591,7 @@ static int davinci_i2c_remove(struct pla
 	kfree(dev);
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(mem->start, (mem->end - mem->start) + 1);
+	release_mem_region(mem->start, resource_size(mem));
 	return 0;
 }
 
diff -u -p a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
--- a/drivers/i2c/busses/i2c-omap.c 2009-06-24 21:18:49.000000000 +0200
+++ b/drivers/i2c/busses/i2c-omap.c 2009-07-04 21:38:17.000000000 +0200
@@ -806,7 +806,7 @@ omap_i2c_probe(struct platform_device *p
 		return -ENODEV;
 	}
 
-	ioarea = request_mem_region(mem->start, (mem->end - mem->start) + 1,
+	ioarea = request_mem_region(mem->start, resource_size(mem),
 			pdev->name);
 	if (!ioarea) {
 		dev_err(&pdev->dev, "I2C region already claimed\n");
@@ -905,7 +905,7 @@ err_free_mem:
 	platform_set_drvdata(pdev, NULL);
 	kfree(dev);
 err_release_region:
-	release_mem_region(mem->start, (mem->end - mem->start) + 1);
+	release_mem_region(mem->start, resource_size(mem));
 
 	return r;
 }
@@ -925,7 +925,7 @@ omap_i2c_remove(struct platform_device *
 	iounmap(dev->base);
 	kfree(dev);
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(mem->start, (mem->end - mem->start) + 1);
+	release_mem_region(mem->start, resource_size(mem));
 	return 0;
 }
 
diff -u -p a/drivers/i2c/busses/i2c-sh_mobile.c b/drivers/i2c/busses/i2c-sh_mobile.c
--- a/drivers/i2c/busses/i2c-sh_mobile.c 2009-01-09 22:41:01.000000000 +0100
+++ b/drivers/i2c/busses/i2c-sh_mobile.c 2009-07-04 21:38:18.000000000 +0200
@@ -563,7 +563,7 @@ static int sh_mobile_i2c_probe(struct pl
 		goto err_irq;
 	}
 
-	size = (res->end - res->start) + 1;
+	size = resource_size(res);
 
 	pd->reg = ioremap(res->start, size);
 	if (pd->reg == NULL) {
diff -u -p a/drivers/i2c/busses/i2c-simtec.c b/drivers/i2c/busses/i2c-simtec.c
--- a/drivers/i2c/busses/i2c-simtec.c 2008-12-07 19:29:06.000000000 +0100
+++ b/drivers/i2c/busses/i2c-simtec.c 2009-07-04 21:38:16.000000000 +0200
@@ -92,7 +92,7 @@ static int simtec_i2c_probe(struct platf
 		goto err;
 	}
 
-	size = (res->end-res->start)+1;
+	size = resource_size(res);
 
 	pd->ioarea = request_mem_region(res->start, size, dev->name);
 	if (pd->ioarea == NULL) {
