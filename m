Return-Path: <linux-kernel-owner+w=401wt.eu-S1752619AbZHAI4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbZHAI4s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 04:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbZHAI4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 04:56:47 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:50640 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561AbZHAI4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 04:56:45 -0400
Date: Sat, 1 Aug 2009 10:54:00 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: p_gortmaker@yahoo.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 5/10] drivers/rtc: introduce missing kfree
Message-ID: <Pine.LNX.4.64.0908011053390.23408@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Error handling code following a kzalloc should free the allocated data.

The semantic match that finds the problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
statement S;
expression E;
identifier f,f1,l;
position p1,p2;
expression *ptr != NULL;
@@

x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
...
if (x == NULL) S
<... when != x
     when != if (...) { <+...x...+> }
(
x->f1 = E
|
 (x->f1 == NULL || ...)
|
 f(...,x->f1,...)
)
...>
(
 return \(0\|<+...x...+>\|ptr\);
|
 return@p2 ...;
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

print "* file: %s kmalloc %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---
 drivers/rtc/rtc-ep93xx.c            |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-ep93xx.c b/drivers/rtc/rtc-ep93xx.c
index 551332e..9da02d1 100644
--- a/drivers/rtc/rtc-ep93xx.c
+++ b/drivers/rtc/rtc-ep93xx.c
@@ -128,12 +128,16 @@ static int __init ep93xx_rtc_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res == NULL)
-		return -ENXIO;
+	if (res == NULL) {
+		err = -ENXIO;
+		goto fail_free;
+	}
 
 	res = request_mem_region(res->start, resource_size(res), pdev->name);
-	if (res == NULL)
-		return -EBUSY;
+	if (res == NULL) {
+		err = -EBUSY;
+		goto fail_free;
+	}
 
 	ep93xx_rtc->mmio_base = ioremap(res->start, resource_size(res));
 	if (ep93xx_rtc->mmio_base == NULL) {
@@ -169,6 +173,8 @@ fail:
 		pdev->dev.platform_data = NULL;
 	}
 	release_mem_region(res->start, resource_size(res));
+fail_free:
+	kfree(ep93xx_rtc);
 	return err;
 }
 
