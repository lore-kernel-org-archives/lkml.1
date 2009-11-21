Return-Path: <linux-kernel-owner+w=401wt.eu-S1753934AbZKULuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbZKULuH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 06:50:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753709AbZKULuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 06:50:06 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:42563 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070AbZKULuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 06:50:04 -0500
Date: Sat, 21 Nov 2009 12:50:08 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Paul Gortmaker <p_gortmaker@yahoo.com>,
       Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/8] drivers/rtc: introduce missing kfree
Message-ID: <Pine.LNX.4.64.0911211249420.23681@ask.diku.dk>
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
 drivers/rtc/rtc-mxc.c               |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-mxc.c b/drivers/rtc/rtc-mxc.c
index 6bd5072..2642e6b 100644
--- a/drivers/rtc/rtc-mxc.c
+++ b/drivers/rtc/rtc-mxc.c
@@ -396,8 +396,10 @@ static int __init mxc_rtc_probe(struct platform_device *pdev)
 	pdata->ioaddr = ioremap(res->start, resource_size(res));
 
 	clk = clk_get(&pdev->dev, "ckil");
-	if (IS_ERR(clk))
-		return PTR_ERR(clk);
+	if (IS_ERR(clk)) {
+		ret = PTR_ERR(clk);
+		goto exit_free_pdata;
+	}
 
 	rate = clk_get_rate(clk);
 	clk_put(clk);
