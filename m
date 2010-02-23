Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab0BWORD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 09:17:03 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:42845 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538Ab0BWORA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 09:17:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=An0CUL/aIij/5vGbxDTaJHMyOvE0dfY+xgeKbamXIzWGt1ARy/gZ4f+tfkBD5MK0VT
         Wbbn/3uGp9So/x3Rl/O7ZPr7TyvRCzY3ESJFQ/PyGFYXltTdd4SyWslvK1LDXs/VX3Z5
         fd6Lyogw0j7GI8W5f5RFyFEq/Bn+W8TatZuXI=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Jan Kara <jack@suse.cz>
Subject: [PATCH] udf: use ext2_find_next_bit
Date: Tue, 23 Feb 2010 23:11:13 +0900
Message-Id: <1266934273-9371-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use ext2_find_next_bit (generic_find_next_le_bit) to find the set bit
in little endian bitmap region.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Jan Kara <jack@suse.cz>
---
 fs/udf/balloc.c |   50 ++------------------------------------------------
 1 files changed, 2 insertions(+), 48 deletions(-)

diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
index 82372e3..05347f4 100644
--- a/fs/udf/balloc.c
+++ b/fs/udf/balloc.c
@@ -31,55 +31,9 @@
 #define udf_clear_bit(nr, addr) ext2_clear_bit(nr, addr)
 #define udf_set_bit(nr, addr) ext2_set_bit(nr, addr)
 #define udf_test_bit(nr, addr) ext2_test_bit(nr, addr)
-#define udf_find_first_one_bit(addr, size) find_first_one_bit(addr, size)
+#define udf_find_first_one_bit(addr, size) ext2_find_first_bit(addr, size)
 #define udf_find_next_one_bit(addr, size, offset) \
-		find_next_one_bit(addr, size, offset)
-
-#define leBPL_to_cpup(x) leNUM_to_cpup(BITS_PER_LONG, x)
-#define leNUM_to_cpup(x, y) xleNUM_to_cpup(x, y)
-#define xleNUM_to_cpup(x, y) (le ## x ## _to_cpup(y))
-#define uintBPL_t uint(BITS_PER_LONG)
-#define uint(x) xuint(x)
-#define xuint(x) __le ## x
-
-static inline int find_next_one_bit(void *addr, int size, int offset)
-{
-	uintBPL_t *p = ((uintBPL_t *) addr) + (offset / BITS_PER_LONG);
-	int result = offset & ~(BITS_PER_LONG - 1);
-	unsigned long tmp;
-
-	if (offset >= size)
-		return size;
-	size -= result;
-	offset &= (BITS_PER_LONG - 1);
-	if (offset) {
-		tmp = leBPL_to_cpup(p++);
-		tmp &= ~0UL << offset;
-		if (size < BITS_PER_LONG)
-			goto found_first;
-		if (tmp)
-			goto found_middle;
-		size -= BITS_PER_LONG;
-		result += BITS_PER_LONG;
-	}
-	while (size & ~(BITS_PER_LONG - 1)) {
-		tmp = leBPL_to_cpup(p++);
-		if (tmp)
-			goto found_middle;
-		result += BITS_PER_LONG;
-		size -= BITS_PER_LONG;
-	}
-	if (!size)
-		return result;
-	tmp = leBPL_to_cpup(p);
-found_first:
-	tmp &= ~0UL >> (BITS_PER_LONG - size);
-found_middle:
-	return result + ffz(~tmp);
-}
-
-#define find_first_one_bit(addr, size)\
-	find_next_one_bit((addr), (size), 0)
+		ext2_find_next_bit(addr, size, offset)
 
 static int read_block_bitmap(struct super_block *sb,
 			     struct udf_bitmap *bitmap, unsigned int block,
-- 
1.6.0.6

