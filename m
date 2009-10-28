Return-Path: <linux-kernel-owner+w=401wt.eu-S932811AbZJ1Iom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932811AbZJ1Iom (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 04:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932772AbZJ1Iok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 04:44:40 -0400
Received: from mail-yw0-f202.google.com ([209.85.211.202]:60692 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932765AbZJ1Inm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 04:43:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=nNPDH4VSssF6ybQVUiFrEXL80BvmzX0j8ULuZbcyiFQaHNx2GOk4STz5srk3Zyo/aq
         ZR4L6KPHsg683jJKQ6dRagydefDoxasElRj+XF9Il18yAauKUyMBWMBF2sGaAGrTtFPV
         FZazjZDffae7zYg02hQ911KekRcrrF+OoLmco=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
       Yevgeny Petrilin <yevgenyp@mellanox.co.il>, netdev@vger.kernel.org
Subject: [PATCH 4/7] mlx4: Use bitmap_find_next_zero_area
Date: Wed, 28 Oct 2009 17:43:14 +0900
Message-Id: <1256719397-4258-4-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.5.1
In-Reply-To: <1256719397-4258-1-git-send-email-akinobu.mita@gmail.com>
References: <1256719397-4258-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Reviewed-by: Roland Dreier <rolandd@cisco.com>
Cc: Yevgeny Petrilin <yevgenyp@mellanox.co.il>
Cc: netdev@vger.kernel.org
---
 drivers/net/mlx4/alloc.c |   37 ++++---------------------------------
 1 files changed, 4 insertions(+), 33 deletions(-)

diff --git a/drivers/net/mlx4/alloc.c b/drivers/net/mlx4/alloc.c
index ad95d5f..8c85156 100644
--- a/drivers/net/mlx4/alloc.c
+++ b/drivers/net/mlx4/alloc.c
@@ -72,35 +72,6 @@ void mlx4_bitmap_free(struct mlx4_bitmap *bitmap, u32 obj)
 	mlx4_bitmap_free_range(bitmap, obj, 1);
 }
 
-static unsigned long find_aligned_range(unsigned long *bitmap,
-					u32 start, u32 nbits,
-					int len, int align)
-{
-	unsigned long end, i;
-
-again:
-	start = ALIGN(start, align);
-
-	while ((start < nbits) && test_bit(start, bitmap))
-		start += align;
-
-	if (start >= nbits)
-		return -1;
-
-	end = start+len;
-	if (end > nbits)
-		return -1;
-
-	for (i = start + 1; i < end; i++) {
-		if (test_bit(i, bitmap)) {
-			start = i + 1;
-			goto again;
-		}
-	}
-
-	return start;
-}
-
 u32 mlx4_bitmap_alloc_range(struct mlx4_bitmap *bitmap, int cnt, int align)
 {
 	u32 obj, i;
@@ -110,13 +81,13 @@ u32 mlx4_bitmap_alloc_range(struct mlx4_bitmap *bitmap, int cnt, int align)
 
 	spin_lock(&bitmap->lock);
 
-	obj = find_aligned_range(bitmap->table, bitmap->last,
-				 bitmap->max, cnt, align);
+	obj = bitmap_find_next_zero_area(bitmap->table, bitmap->max,
+				bitmap->last, cnt, align - 1);
 	if (obj >= bitmap->max) {
 		bitmap->top = (bitmap->top + bitmap->max + bitmap->reserved_top)
 				& bitmap->mask;
-		obj = find_aligned_range(bitmap->table, 0, bitmap->max,
-					 cnt, align);
+		obj = bitmap_find_next_zero_area(bitmap->table, bitmap->max,
+						0, cnt, align - 1);
 	}
 
 	if (obj < bitmap->max) {
-- 
1.6.5.1

