Return-Path: <linux-kernel-owner+w=401wt.eu-S1757607AbYHBPOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607AbYHBPOk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 11:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757430AbYHBPO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 11:14:26 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:37848 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756634AbYHBPOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 11:14:24 -0400
Date: Sat, 2 Aug 2008 17:14:21 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 6/10] drivers/mtd: Use DIV_ROUND_UP
Message-ID: <Pine.LNX.4.64.0808021713580.20095@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The kernel.h macro DIV_ROUND_UP performs the computation (((n) + (d) - 1) /
(d)) but is perhaps more readable.

An extract of the semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@haskernel@
@@

#include <linux/kernel.h>

@depends on haskernel@
expression n,d;
@@

(
- (n + d - 1) / d
+ DIV_ROUND_UP(n,d)
|
- (n + (d - 1)) / d
+ DIV_ROUND_UP(n,d)
)

@depends on haskernel@
expression n,d;
@@

- DIV_ROUND_UP((n),d)
+ DIV_ROUND_UP(n,d)

@depends on haskernel@
expression n,d;
@@

- DIV_ROUND_UP(n,(d))
+ DIV_ROUND_UP(n,d)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/mtd/chips/cfi_cmdset_0001.c |    2 +-
 drivers/mtd/chips/gen_probe.c       |    2 +-
 drivers/mtd/ssfdc.c                 |    3 +--
 3 files changed, 3 insertions(+), 4 deletions(-)

diff -u -p a/drivers/mtd/chips/cfi_cmdset_0001.c b/drivers/mtd/chips/cfi_cmdset_0001.c
--- a/drivers/mtd/chips/cfi_cmdset_0001.c
+++ b/drivers/mtd/chips/cfi_cmdset_0001.c
@@ -1640,7 +1640,7 @@ static int __xipram do_write_buffer(stru
 
 	/* Figure out the number of words to write */
 	word_gap = (-adr & (map_bankwidth(map)-1));
-	words = (len - word_gap + map_bankwidth(map) - 1) / map_bankwidth(map);
+	words = DIV_ROUND_UP(len - word_gap, map_bankwidth(map));
 	if (!word_gap) {
 		words--;
 	} else {
diff -u -p a/drivers/mtd/chips/gen_probe.c b/drivers/mtd/chips/gen_probe.c
--- a/drivers/mtd/chips/gen_probe.c
+++ b/drivers/mtd/chips/gen_probe.c
@@ -111,7 +111,7 @@ static struct cfi_private *genprobe_iden
 		max_chips = 1;
 	}
 
-	mapsize = sizeof(long) * ( (max_chips + BITS_PER_LONG-1) / BITS_PER_LONG );
+	mapsize = sizeof(long) * DIV_ROUND_UP(max_chips, BITS_PER_LONG);
 	chip_map = kzalloc(mapsize, GFP_KERNEL);
 	if (!chip_map) {
 		printk(KERN_WARNING "%s: kmalloc failed for CFI chip map\n", map->name);
diff -u -p a/drivers/mtd/ssfdc.c b/drivers/mtd/ssfdc.c
--- a/drivers/mtd/ssfdc.c
+++ b/drivers/mtd/ssfdc.c
@@ -321,8 +321,7 @@ static void ssfdcr_add_mtd(struct mtd_bl
 	DEBUG(MTD_DEBUG_LEVEL1,
 		"SSFDC_RO: cis_block=%d,erase_size=%d,map_len=%d,n_zones=%d\n",
 		ssfdc->cis_block, ssfdc->erase_size, ssfdc->map_len,
-		(ssfdc->map_len + MAX_PHYS_BLK_PER_ZONE - 1) /
-		MAX_PHYS_BLK_PER_ZONE);
+		DIV_ROUND_UP(ssfdc->map_len, MAX_PHYS_BLK_PER_ZONE));
 
 	/* Set geometry */
 	ssfdc->heads = 16;
