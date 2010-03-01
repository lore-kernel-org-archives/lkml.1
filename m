Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751310Ab0CAJss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 04:48:48 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:60129 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019Ab0CAJsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 04:48:47 -0500
Date: Mon, 1 Mar 2010 20:48:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: linux-next: build failure after merge of the final tree (mtd
 related)
Message-Id: <20100301204844.68915148.sfr@canb.auug.org.au>
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

drivers/mtd/nand/r852.o: In function `.sm_sector_valid':
(.text+0x5c70): multiple definition of `.sm_sector_valid'
drivers/mtd/nand/sm_common.o:(.text+0x3c8): first defined here
drivers/mtd/nand/r852.o: In function `.sm_block_erased':
(.text+0x50dc): multiple definition of `.sm_block_erased'
drivers/mtd/nand/sm_common.o:(.text+0x2bc): first defined here
drivers/mtd/nand/r852.o: In function `.sm_block_valid':
(.text+0x5be8): multiple definition of `.sm_block_valid'
drivers/mtd/nand/sm_common.o:(.text+0x340): first defined here

Caused by commit 9fc51a37a8da84618df7584cad67c078317f6720 ("mtd: common
module for smartmedia/xD support") from the mtd tree.

I applied the following patch for today.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 1 Mar 2010 20:44:57 +1100
Subject: [PATCH] mtd: declare inline functions static

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/mtd/nand/sm_common.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/nand/sm_common.h b/drivers/mtd/nand/sm_common.h
index 7c03314..18284f5 100644
--- a/drivers/mtd/nand/sm_common.h
+++ b/drivers/mtd/nand/sm_common.h
@@ -39,17 +39,17 @@ struct sm_oob {
 extern int sm_register_device(struct mtd_info *mtd);
 
 
-inline int sm_sector_valid(struct sm_oob *oob)
+static inline int sm_sector_valid(struct sm_oob *oob)
 {
 	return hweight16(oob->data_status) >= 5;
 }
 
-inline int sm_block_valid(struct sm_oob *oob)
+static inline int sm_block_valid(struct sm_oob *oob)
 {
 	return hweight16(oob->block_status) >= 7;
 }
 
-inline int sm_block_erased(struct sm_oob *oob)
+static inline int sm_block_erased(struct sm_oob *oob)
 {
 	static const uint32_t erased_pattern[4] = {
 		0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF };
-- 
1.7.0

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
