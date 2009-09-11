Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbZIKQWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbZIKQWL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 12:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754666AbZIKQWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 12:22:10 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:34621 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754411AbZIKQWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 12:22:08 -0400
Date: Fri, 11 Sep 2009 18:22:09 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 5/8] drivers/net/phy: introduce missing kfree
Message-ID: <Pine.LNX.4.64.0909111821520.10552@pc-004.diku.dk>
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
 drivers/net/phy/mdio-gpio.c         |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/phy/mdio-gpio.c b/drivers/net/phy/mdio-gpio.c
index 22cdd45..250e10f 100644
--- a/drivers/net/phy/mdio-gpio.c
+++ b/drivers/net/phy/mdio-gpio.c
@@ -211,7 +211,7 @@ static int __devinit mdio_ofgpio_probe(struct of_device *ofdev,
 
 	new_bus = mdio_gpio_bus_init(&ofdev->dev, pdata, pdata->mdc);
 	if (!new_bus)
-		return -ENODEV;
+		goto out_free;
 
 	ret = of_mdiobus_register(new_bus, ofdev->node);
 	if (ret)

