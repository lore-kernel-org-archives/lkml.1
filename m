Return-Path: <linux-kernel-owner+w=401wt.eu-S1754690AbZIKQVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbZIKQVA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 12:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754553AbZIKQVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 12:21:00 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:42659 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481AbZIKQU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 12:20:59 -0400
Date: Fri, 11 Sep 2009 18:21:00 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/8] arch/mips/txx9: introduce missing kfree, iounmap
Message-ID: <Pine.LNX.4.64.0909111820370.10552@pc-004.diku.dk>
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
 arch/mips/txx9/generic/setup.c      |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/mips/txx9/generic/setup.c b/arch/mips/txx9/generic/setup.c
index a205e2b..5744af2 100644
--- a/arch/mips/txx9/generic/setup.c
+++ b/arch/mips/txx9/generic/setup.c
@@ -781,8 +781,10 @@ void __init txx9_iocled_init(unsigned long baseaddr,
 	if (!iocled)
 		return;
 	iocled->mmioaddr = ioremap(baseaddr, 1);
-	if (!iocled->mmioaddr)
+	if (!iocled->mmioaddr) {
+		kfree(iocled);
 		return;
+	}
 	iocled->chip.get = txx9_iocled_get;
 	iocled->chip.set = txx9_iocled_set;
 	iocled->chip.direction_input = txx9_iocled_dir_in;
@@ -790,8 +792,11 @@ void __init txx9_iocled_init(unsigned long baseaddr,
 	iocled->chip.label = "iocled";
 	iocled->chip.base = basenum;
 	iocled->chip.ngpio = num;
-	if (gpiochip_add(&iocled->chip))
+	if (gpiochip_add(&iocled->chip)) {
+		iounmap(iocled->mmioaddr);
+		kfree(iocled);
 		return;
+	}
 	if (basenum < 0)
 		basenum = iocled->chip.base;
 
