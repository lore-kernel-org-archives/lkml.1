Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751063Ab0CAJk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 04:40:57 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:42013 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889Ab0CAJkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 04:40:55 -0500
Date: Mon, 1 Mar 2010 20:40:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20100301204052.8561a0e5.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/mtd/nand/r852.c:22: error: 'enable_dma' redeclared as different kind of symbol
arch/powerpc/include/asm/dma.h:189: note: previous definition of 'enable_dma' was here
drivers/mtd/nand/r852.c: In function 'r852_engine_enable':
drivers/mtd/nand/r852.c:545: error: implicit declaration of function 'msleep'

Caused by commit 67e054e919248fa1db93de727fb9ad49eb700642 ("mtd: nand:
Add driver for Ricoh xD/SmartMedia reader") from the mtd.

I applied the following patch for today.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 1 Mar 2010 20:21:06 +1100
Subject: [PATCH] mtd: nand: fix name space clash

and include delay.h for msleep().

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/mtd/nand/r852.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/nand/r852.c b/drivers/mtd/nand/r852.c
index 218a42d..ca21883 100644
--- a/drivers/mtd/nand/r852.c
+++ b/drivers/mtd/nand/r852.c
@@ -13,15 +13,16 @@
 #include <linux/workqueue.h>
 #include <linux/interrupt.h>
 #include <linux/pci_ids.h>
+#include <linux/delay.h>
 #include <asm/byteorder.h>
 #include <linux/sched.h>
 #include "sm_common.h"
 #include "r852.h"
 
 
-static int enable_dma = 1;
-module_param(enable_dma, bool, S_IRUGO);
-MODULE_PARM_DESC(enable_dma, "Enable usage of the DMA (default)");
+static int r852_enable_dma = 1;
+module_param(r852_enable_dma, bool, S_IRUGO);
+MODULE_PARM_DESC(r852_enable_dma, "Enable usage of the DMA (default)");
 
 static int debug;
 module_param(debug, int, S_IRUGO | S_IWUSR);
@@ -75,7 +76,7 @@ static void r852_dma_test(struct r852_device *dev)
 	if (!dev->dma_usable)
 		message("Non dma capable device detected, dma disabled");
 
-	if (!enable_dma) {
+	if (!r852_enable_dma) {
 		message("disabling dma on user request");
 		dev->dma_usable = 0;
 	}
-- 
1.7.0

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
