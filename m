Return-Path: <linux-kernel-owner+w=401wt.eu-S1757383AbZKJRRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383AbZKJRRw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 12:17:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757339AbZKJRRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 12:17:52 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:46900 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757333AbZKJRRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 12:17:51 -0500
Subject: SM501: Fix missing uses of resource_size()
Message-Id: <20091110171734.085189722@fluff.org.uk>
User-Agent: quilt/0.46-1
From: Ben Dooks <ben@simtec.co.uk>
To: akpm@linux-foundation.org, krzysztof.h1@wp.pl
Cc: lethal@linux-sh.org, dilinger@debian.org, linux-kernel@vger.kernel.org,
       Simtec Linux Team <linux@simtec.co.uk>
Content-Disposition: inline; filename=simtec/ready/sm501-use-resource-size.patch
Date: Tue, 10 Nov 2009 17:17:34 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are several places in the SM501 fb driver that could do with using
resource_size() to calculate the size of a resource.

Also fix a bug where request_mem_region() is being passed one too few
bytes when requesting the register memory region, which was causing
the following in /proc/iomem:

 13e80000-13e8ffff : sm501-fb.0
   13e80000-13e8fffe : sm501-fb

fixed, this reads:

 13e80000-13e8ffff : sm501-fb.0
   13e80000-13e8ffff : sm501-fb

Signed-off-by: Ben Dooks <ben@simtec.co.uk>
Signed-off-by: Simtec Linux Team <linux@simtec.co.uk>

---
 drivers/video/sm501fb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: b/drivers/video/sm501fb.c
===================================================================
--- a/drivers/video/sm501fb.c	2009-11-03 11:17:52.000000000 +0000
+++ b/drivers/video/sm501fb.c	2009-11-03 11:18:36.000000000 +0000
@@ -1338,7 +1338,7 @@ static int sm501fb_start(struct sm501fb_
 	}
 
 	info->regs_res = request_mem_region(res->start,
-					    res->end - res->start,
+					    resource_size(res),
 					    pdev->name);
 
 	if (info->regs_res == NULL) {
@@ -1347,7 +1347,7 @@ static int sm501fb_start(struct sm501fb_
 		goto err_release;
 	}
 
-	info->regs = ioremap(res->start, (res->end - res->start)+1);
+	info->regs = ioremap(res->start, resource_size(res));
 	if (info->regs == NULL) {
 		dev_err(dev, "cannot remap registers\n");
 		ret = -ENXIO;
@@ -1363,7 +1363,7 @@ static int sm501fb_start(struct sm501fb_
 	}
 
 	info->fbmem_res = request_mem_region(res->start,
-					     (res->end - res->start)+1,
+					     resource_size(res),
 					     pdev->name);
 	if (info->fbmem_res == NULL) {
 		dev_err(dev, "cannot claim framebuffer\n");
@@ -1377,7 +1377,7 @@ static int sm501fb_start(struct sm501fb_
 		goto err_mem_res;
 	}
 
-	info->fbmem_len = (res->end - res->start)+1;
+	info->fbmem_len = resource_size(res);
 
 	/* clear framebuffer memory - avoids garbage data on unused fb */
 	memset(info->fbmem, 0, info->fbmem_len);

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
