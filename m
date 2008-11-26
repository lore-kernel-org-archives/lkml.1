Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932AbYKZQiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbYKZQiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 11:38:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752723AbYKZQim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 11:38:42 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:24803 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752254AbYKZQim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 11:38:42 -0500
Date: Wed, 26 Nov 2008 19:38:40 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Wolfgang Grandegger <wg@grandegger.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-mtd@lists.infradead.org
Subject: [PATCH for 2.6.28] NAND: fsl_upm: fix build problem with 2.6.28-rc2
Message-ID: <20081126163840.GA21669@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfgang Grandegger <wg@grandegger.com>

The patch fixes following build error:

  CC      drivers/mtd/nand/fsl_upm.o
drivers/mtd/nand/fsl_upm.c: In function 'fun_chip_init':
drivers/mtd/nand/fsl_upm.c:168: warning: passing argument 2 of 'of_mtd_parse_partitions' from incompatible pointer type
drivers/mtd/nand/fsl_upm.c:168: warning: passing argument 3 of 'of_mtd_parse_partitions' from incompatible pointer type
drivers/mtd/nand/fsl_upm.c:168: error: too many arguments to function 'of_mtd_parse_partitions'
make[1]: *** [drivers/mtd/nand/fsl_upm.o] Error 1

The breakage was introduced in 69fd3a8d098faf41a04930afa83757c0555ee360
("[MTD] remove unused mtd parameter in of_mtd_parse_partitions()").

While at it, also add a check for the of_mtd_parse_partitions() return
value.

Signed-off-by: Wolfgang Grandegger <wg@grandegger.com>
Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/mtd/nand/fsl_upm.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/nand/fsl_upm.c b/drivers/mtd/nand/fsl_upm.c
index 024e3ff..a83192f 100644
--- a/drivers/mtd/nand/fsl_upm.c
+++ b/drivers/mtd/nand/fsl_upm.c
@@ -163,9 +163,11 @@ static int __devinit fun_chip_init(struct fsl_upm_nand *fun,
 	ret = parse_mtd_partitions(&fun->mtd, part_types, &fun->parts, 0);
 
 #ifdef CONFIG_MTD_OF_PARTS
-	if (ret == 0)
-		ret = of_mtd_parse_partitions(fun->dev, &fun->mtd,
-					      flash_np, &fun->parts);
+	if (ret == 0) {
+		ret = of_mtd_parse_partitions(fun->dev, flash_np, &fun->parts);
+		if (ret < 0)
+			goto err;
+	}
 #endif
 	if (ret > 0)
 		ret = add_mtd_partitions(&fun->mtd, fun->parts, ret);
-- 
1.5.6.5
