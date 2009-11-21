Return-Path: <linux-kernel-owner+w=401wt.eu-S1754111AbZKULwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111AbZKULwl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 06:52:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754055AbZKULwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 06:52:40 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:42587 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753998AbZKULwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 06:52:39 -0500
Date: Sat, 21 Nov 2009 12:52:44 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: maciej.sosnowski@intel.com, Dan Williams <dan.j.williams@intel.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 7/8] drivers/dma: introduce missing kfree
Message-ID: <Pine.LNX.4.64.0911211252180.23681@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Error handling code following a kzalloc should free the allocated data.

The semantic match that finds this problem is as follows:
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
 drivers/dma/shdma.c                 |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/shdma.c b/drivers/dma/shdma.c
index b3b065c..0cd0d58 100644
--- a/drivers/dma/shdma.c
+++ b/drivers/dma/shdma.c
@@ -649,7 +649,7 @@ static int __init sh_dmae_probe(struct platform_device *pdev)
 
 	/* get platform data */
 	if (!pdev->dev.platform_data)
-		goto shdev_err;
+		goto platform_err;
 
 	/* platform data */
 	memcpy(&shdev->pdata, pdev->dev.platform_data,
@@ -720,6 +720,7 @@ eirq_err:
 		free_irq(eirq[ecnt], shdev);
 
 rst_err:
+platform_err:
 	kfree(shdev);
 
 shdev_err:
