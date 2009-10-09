Return-Path: <linux-kernel-owner+w=401wt.eu-S1760275AbZJIIf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760275AbZJIIf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 04:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758170AbZJIIf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 04:35:27 -0400
Received: from mail-yx0-f187.google.com ([209.85.210.187]:54548 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029AbZJIIfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 04:35:24 -0400
X-Greylist: delayed 322 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Oct 2009 04:35:24 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=MSMcA43cUMEJ70sk6PBh05lik3PmbR2LExPqEnm+aua+bU/UIPXN30iGGXiFn88Zc1
         H27J+aGwzKE7nwNREUkKclHvPYJiS3V+xIoVrCQ5DV0EOgCOjXPUXHDyxqBD3Y9NpaKH
         kpJbPFZQvWFLgPk6JaAx+z33/dfCEHkhRqDJk=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Roland Dreier <rolandd@cisco.com>,
       Yevgeny Petrilin <yevgenyp@mellanox.co.il>, netdev@vger.kernel.org
Subject: [PATCH 5/8] mlx4: Use bitmap_find_next_zero_area
Date: Fri,  9 Oct 2009 17:29:18 +0900
Message-Id: <1255076961-21325-5-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1255076961-21325-4-git-send-email-akinobu.mita@gmail.com>
References: <>
 <1255076961-21325-1-git-send-email-akinobu.mita@gmail.com>
 <1255076961-21325-2-git-send-email-akinobu.mita@gmail.com>
 <1255076961-21325-3-git-send-email-akinobu.mita@gmail.com>
 <1255076961-21325-4-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Roland Dreier <rolandd@cisco.com>
Cc: Yevgeny Petrilin <yevgenyp@mellanox.co.il>
Cc: netdev@vger.kernel.org
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
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
1.5.4.3

