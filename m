Return-Path: <linux-kernel-owner+w=401wt.eu-S1754894AbZFAWXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbZFAWXN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 18:23:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753440AbZFAWW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 18:22:59 -0400
Received: from woodchuck.wormnet.eu ([77.75.105.223]:33722 "EHLO
	woodchuck.wormnet.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289AbZFAWW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 18:22:59 -0400
X-Greylist: delayed 508 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Jun 2009 18:22:58 EDT
Date: Mon, 1 Jun 2009 23:14:29 +0100
From: Alexander Clouter <alex@digriz.org.uk>
To: herbert@gondor.apana.org.au
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [HWRNG] timeriomem-rng fixes (request_mem_region/__devinit)
Message-ID: <20090601221429.GP32238@woodchuck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: diGriz
X-URL: http://www.digriz.org.uk/
X-JabberID: alex@digriz.org.uk
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[HWRNG] timeriomem-rng fixes (request_mem_region/__devinit)

Fixed oops when calling device_unregister followed by device_register
(changing __init to __devinit) and removed request_mem_region() as
platform_device_register already does this which can result in EBUSY

Signed-off-by: Alexander Clouter <alex@digriz.org.uk>
---
 drivers/char/hw_random/timeriomem-rng.c |   26 ++++++--------------------
 1 files changed, 6 insertions(+), 20 deletions(-)

diff --git a/drivers/char/hw_random/timeriomem-rng.c b/drivers/char/hw_random/timeriomem-rng.c
index dcd352a..a94e930 100644
--- a/drivers/char/hw_random/timeriomem-rng.c
+++ b/drivers/char/hw_random/timeriomem-rng.c
@@ -88,9 +88,9 @@ static struct hwrng timeriomem_rng_ops = {
 	.priv		= 0,
 };
 
-static int __init timeriomem_rng_probe(struct platform_device *pdev)
+static int __devinit timeriomem_rng_probe(struct platform_device *pdev)
 {
-	struct resource *res, *mem;
+	struct resource *res;
 	int ret;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -98,21 +98,12 @@ static int __init timeriomem_rng_probe(struct platform_device *pdev)
 	if (!res)
 		return -ENOENT;
 
-	mem = request_mem_region(res->start, res->end - res->start + 1,
-				 pdev->name);
-	if (mem == NULL)
-		return -EBUSY;
-
-	dev_set_drvdata(&pdev->dev, mem);
-
 	timeriomem_rng_data = pdev->dev.platform_data;
 
 	timeriomem_rng_data->address = ioremap(res->start,
 						res->end - res->start + 1);
-	if (!timeriomem_rng_data->address) {
-		ret = -ENOMEM;
-		goto err_ioremap;
-	}
+	if (!timeriomem_rng_data->address)
+		return -EIO;
 
 	if (timeriomem_rng_data->period != 0
 		&& usecs_to_jiffies(timeriomem_rng_data->period) > 0) {
@@ -125,7 +116,7 @@ static int __init timeriomem_rng_probe(struct platform_device *pdev)
 
 	ret = hwrng_register(&timeriomem_rng_ops);
 	if (ret)
-		goto err_register;
+		goto failed;
 
 	dev_info(&pdev->dev, "32bits from 0x%p @ %dus\n",
 			timeriomem_rng_data->address,
@@ -133,24 +124,19 @@ static int __init timeriomem_rng_probe(struct platform_device *pdev)
 
 	return 0;
 
-err_register:
+failed:
 	dev_err(&pdev->dev, "problem registering\n");
 	iounmap(timeriomem_rng_data->address);
-err_ioremap:
-	release_resource(mem);
 
 	return ret;
 }
 
 static int __devexit timeriomem_rng_remove(struct platform_device *pdev)
 {
-	struct resource *mem = dev_get_drvdata(&pdev->dev);
-
 	del_timer_sync(&timeriomem_rng_timer);
 	hwrng_unregister(&timeriomem_rng_ops);
 
 	iounmap(timeriomem_rng_data->address);
-	release_resource(mem);
 
 	return 0;
 }
-- 
1.6.3.1
