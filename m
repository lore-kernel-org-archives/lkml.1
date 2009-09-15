Return-Path: <linux-kernel-owner+w=401wt.eu-S1753583AbZIOP4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583AbZIOP4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 11:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbZIOP4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 11:56:14 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:34899 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbZIOP4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 11:56:13 -0400
Date: Tue, 15 Sep 2009 17:56:14 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: ralf@linux-mips.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/8] arch/mips/txx9: introduce missing kfree, iounmap
In-Reply-To: <20090916.004525.74746264.anemo@mba.ocn.ne.jp>
Message-ID: <Pine.LNX.4.64.0909151755280.8549@pc-004.diku.dk>
References: <20090914.003321.160496287.anemo@mba.ocn.ne.jp>
 <Pine.LNX.4.64.0909132113520.31000@ask.diku.dk> <Pine.LNX.4.64.0909150701170.11392@ask.diku.dk>
 <20090916.004525.74746264.anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Error handling code following a kzalloc should free the allocated data.
Error handling code following an ioremap should iounmap the allocated data.

The semantic match that finds the first problem is as follows:
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
 arch/mips/txx9/generic/setup.c      |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/mips/txx9/generic/setup.c b/arch/mips/txx9/generic/setup.c
index a205e2b..dfe4720 100644
--- a/arch/mips/txx9/generic/setup.c
+++ b/arch/mips/txx9/generic/setup.c
@@ -782,7 +782,7 @@ void __init txx9_iocled_init(unsigned long baseaddr,
 		return;
 	iocled->mmioaddr = ioremap(baseaddr, 1);
 	if (!iocled->mmioaddr)
-		return;
+		goto out_free;
 	iocled->chip.get = txx9_iocled_get;
 	iocled->chip.set = txx9_iocled_set;
 	iocled->chip.direction_input = txx9_iocled_dir_in;
@@ -791,13 +791,13 @@ void __init txx9_iocled_init(unsigned long baseaddr,
 	iocled->chip.base = basenum;
 	iocled->chip.ngpio = num;
 	if (gpiochip_add(&iocled->chip))
-		return;
+		goto out_unmap;
 	if (basenum < 0)
 		basenum = iocled->chip.base;
 
 	pdev = platform_device_alloc("leds-gpio", basenum);
 	if (!pdev)
-		return;
+		goto out_gpio;
 	iocled->pdata.num_leds = num;
 	iocled->pdata.leds = iocled->leds;
 	for (i = 0; i < num; i++) {
@@ -812,7 +812,17 @@ void __init txx9_iocled_init(unsigned long baseaddr,
 	}
 	pdev->dev.platform_data = &iocled->pdata;
 	if (platform_device_add(pdev))
-		platform_device_put(pdev);
+		goto out_pdev;
+	return;
+out_pdev:
+	platform_device_put(pdev);
+out_gpio:
+	if (gpiochip_remove(&iocled->chip))
+		return;
+out_unmap:
+	iounmap(iocled->mmioaddr);
+out_free:
+	kfree(iocled);
 }
 #else /* CONFIG_LEDS_GPIO */
 void __init txx9_iocled_init(unsigned long baseaddr,
