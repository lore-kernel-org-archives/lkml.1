Return-Path: <linux-kernel-owner+w=401wt.eu-S1758132AbZCUN2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132AbZCUN2U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 09:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754032AbZCUN2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 09:28:10 -0400
Received: from woodchuck.wormnet.eu ([77.75.105.223]:38433 "EHLO
	woodchuck.wormnet.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651AbZCUN2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 09:28:09 -0400
Date: Sat, 21 Mar 2009 13:28:03 +0000
From: Alexander Clouter <alex@digriz.org.uk>
To: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH] [HWRNG] fixed timeriomem-rng to use a phys address rather
	than virt
Message-ID: <20090321132803.GN22563@woodchuck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: diGriz
X-URL: http://www.digriz.org.uk/
X-JabberID: jimdigriz@jabber.earth.li
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[HWRNG] fixed timeriomem-rng to use a phys address rather than virt

There is no ioremap'ing or anything in timeriomem-rng.c as I foolishly
used already remapped virtual addresses instead of passing the physical
address to be polled.

This patch fixes this flaw and lets developers do the Right Thing(tm).

Signed-off-by: Alexander Clouter <alex@digriz.org.uk>
---
 drivers/char/hw_random/timeriomem-rng.c |   39 +++++++++++++++++++++++++++---
 include/linux/timeriomem-rng.h          |    2 +-
 2 files changed, 36 insertions(+), 5 deletions(-)

diff --git a/drivers/char/hw_random/timeriomem-rng.c b/drivers/char/hw_random/timeriomem-rng.c
index 10ad41b..dcd352a 100644
--- a/drivers/char/hw_random/timeriomem-rng.c
+++ b/drivers/char/hw_random/timeriomem-rng.c
@@ -90,10 +90,30 @@ static struct hwrng timeriomem_rng_ops = {
 
 static int __init timeriomem_rng_probe(struct platform_device *pdev)
 {
+	struct resource *res, *mem;
 	int ret;
 
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+
+	if (!res)
+		return -ENOENT;
+
+	mem = request_mem_region(res->start, res->end - res->start + 1,
+				 pdev->name);
+	if (mem == NULL)
+		return -EBUSY;
+
+	dev_set_drvdata(&pdev->dev, mem);
+
 	timeriomem_rng_data = pdev->dev.platform_data;
 
+	timeriomem_rng_data->address = ioremap(res->start,
+						res->end - res->start + 1);
+	if (!timeriomem_rng_data->address) {
+		ret = -ENOMEM;
+		goto err_ioremap;
+	}
+
 	if (timeriomem_rng_data->period != 0
 		&& usecs_to_jiffies(timeriomem_rng_data->period) > 0) {
 		timeriomem_rng_timer.expires = jiffies;
@@ -104,23 +124,34 @@ static int __init timeriomem_rng_probe(struct platform_device *pdev)
 	timeriomem_rng_data->present = 1;
 
 	ret = hwrng_register(&timeriomem_rng_ops);
-	if (ret) {
-		dev_err(&pdev->dev, "problem registering\n");
-		return ret;
-	}
+	if (ret)
+		goto err_register;
 
 	dev_info(&pdev->dev, "32bits from 0x%p @ %dus\n",
 			timeriomem_rng_data->address,
 			timeriomem_rng_data->period);
 
 	return 0;
+
+err_register:
+	dev_err(&pdev->dev, "problem registering\n");
+	iounmap(timeriomem_rng_data->address);
+err_ioremap:
+	release_resource(mem);
+
+	return ret;
 }
 
 static int __devexit timeriomem_rng_remove(struct platform_device *pdev)
 {
+	struct resource *mem = dev_get_drvdata(&pdev->dev);
+
 	del_timer_sync(&timeriomem_rng_timer);
 	hwrng_unregister(&timeriomem_rng_ops);
 
+	iounmap(timeriomem_rng_data->address);
+	release_resource(mem);
+
 	return 0;
 }
 
diff --git a/include/linux/timeriomem-rng.h b/include/linux/timeriomem-rng.h
index dd25317..3e08a1c 100644
--- a/include/linux/timeriomem-rng.h
+++ b/include/linux/timeriomem-rng.h
@@ -14,7 +14,7 @@ struct timeriomem_rng_data {
 	struct completion	completion;
 	unsigned int		present:1;
 
-	u32 __iomem		*address;
+	void __iomem		*address;
 
 	/* measures in usecs */
 	unsigned int		period;
-- 
1.6.2
