Return-Path: <linux-kernel-owner+w=401wt.eu-S1757080AbYBNPQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080AbYBNPQM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 10:16:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754132AbYBNPPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 10:15:53 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:36055 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756194AbYBNPPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 10:15:51 -0500
Date: Thu, 14 Feb 2008 16:15:45 +0100 (MET)
From: Julia Lawall <julia@diku.dk>
To: jack@suse.cz, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 4/6] fs/udf: Use DIV_ROUND_UP
Message-ID: <Pine.LNX.4.58.0802141615240.1185@pc-041.diku.dk>
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

diff -u -p a/fs/udf/super.c b/fs/udf/super.c
--- a/fs/udf/super.c	2008-02-10 17:13:55.000000000 +0100
+++ b/fs/udf/super.c	2008-02-14 07:32:31.000000000 +0100
@@ -1025,10 +1025,9 @@ static void udf_load_fileset(struct supe
 int udf_compute_nr_groups(struct super_block *sb, u32 partition)
 {
 	struct udf_part_map *map = &UDF_SB(sb)->s_partmaps[partition];
-	return (map->s_partition_len +
-		(sizeof(struct spaceBitmapDesc) << 3) +
-		(sb->s_blocksize * 8) - 1) /
-		(sb->s_blocksize * 8);
+	return DIV_ROUND_UP(map->s_partition_len +
+			    (sizeof(struct spaceBitmapDesc) << 3),
+			    sb->s_blocksize * 8);
 }

 static struct udf_bitmap *udf_sb_alloc_bitmap(struct super_block *sb, u32 index)
