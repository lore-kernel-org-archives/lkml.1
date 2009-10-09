Return-Path: <linux-kernel-owner+w=401wt.eu-S1759680AbZJIIai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759680AbZJIIai (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 04:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758472AbZJIIag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 04:30:36 -0400
Received: from mail-yw0-f182.google.com ([209.85.211.182]:37442 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759348AbZJIIac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 04:30:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=wuX0uHYBkX2G0ZHKv4t+6IQqtqGSx23wGMz5twQNYu5an/z7k1p06WsjKMM0oICR5V
         CBPrBqOs0LOSfYotHmAMbVGrzCGbuzIvxDIGfxmT7lDKeKy+GE65debqSlinq+LhK/qj
         xPByWCFSEetGIU2vUZM+qS12f8o330ichfJI4=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 8/8] genalloc: Use bitmap_find_next_zero_area
Date: Fri,  9 Oct 2009 17:29:21 +0900
Message-Id: <1255076961-21325-8-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1255076961-21325-7-git-send-email-akinobu.mita@gmail.com>
References: <>
 <1255076961-21325-1-git-send-email-akinobu.mita@gmail.com>
 <1255076961-21325-2-git-send-email-akinobu.mita@gmail.com>
 <1255076961-21325-3-git-send-email-akinobu.mita@gmail.com>
 <1255076961-21325-4-git-send-email-akinobu.mita@gmail.com>
 <1255076961-21325-5-git-send-email-akinobu.mita@gmail.com>
 <1255076961-21325-6-git-send-email-akinobu.mita@gmail.com>
 <1255076961-21325-7-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 lib/genalloc.c |   33 ++++++++++++---------------------
 1 files changed, 12 insertions(+), 21 deletions(-)

diff --git a/lib/genalloc.c b/lib/genalloc.c
index eed2bdb..e67f974 100644
--- a/lib/genalloc.c
+++ b/lib/genalloc.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/bitmap.h>
 #include <linux/genalloc.h>
 
 
@@ -114,7 +115,7 @@ unsigned long gen_pool_alloc(struct gen_pool *pool, size_t size)
 	struct gen_pool_chunk *chunk;
 	unsigned long addr, flags;
 	int order = pool->min_alloc_order;
-	int nbits, bit, start_bit, end_bit;
+	int nbits, start_bit, end_bit;
 
 	if (size == 0)
 		return 0;
@@ -129,29 +130,19 @@ unsigned long gen_pool_alloc(struct gen_pool *pool, size_t size)
 		end_bit -= nbits + 1;
 
 		spin_lock_irqsave(&chunk->lock, flags);
-		bit = -1;
-		while (bit + 1 < end_bit) {
-			bit = find_next_zero_bit(chunk->bits, end_bit, bit + 1);
-			if (bit >= end_bit)
-				break;
-
-			start_bit = bit;
-			if (nbits > 1) {
-				bit = find_next_bit(chunk->bits, bit + nbits,
-							bit + 1);
-				if (bit - start_bit < nbits)
-					continue;
-			}
-
-			addr = chunk->start_addr +
-					    ((unsigned long)start_bit << order);
-			while (nbits--)
-				__set_bit(start_bit++, chunk->bits);
+		start_bit = bitmap_find_next_zero_area(chunk->bits, end_bit, 0,
+						nbits, 0);
+		if (start_bit >= end_bit) {
 			spin_unlock_irqrestore(&chunk->lock, flags);
-			read_unlock(&pool->lock);
-			return addr;
+			continue;
 		}
+
+		addr = chunk->start_addr + ((unsigned long)start_bit << order);
+
+		bitmap_set(chunk->bits, start_bit, nbits);
 		spin_unlock_irqrestore(&chunk->lock, flags);
+		read_unlock(&pool->lock);
+		return addr;
 	}
 	read_unlock(&pool->lock);
 	return 0;
-- 
1.5.4.3

