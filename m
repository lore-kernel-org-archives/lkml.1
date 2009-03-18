Return-Path: <linux-kernel-owner+w=401wt.eu-S1758488AbZCRNa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758488AbZCRNa5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 09:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755752AbZCRN1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 09:27:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755953AbZCRN0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 09:26:53 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 12/18] GFS2: Fix alignment issue and tidy gfs2_bitfit
Date: Wed, 18 Mar 2009 12:23:47 +0000
Message-Id: <1237379033-28095-13-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1237379033-28095-12-git-send-email-swhiteho@redhat.com>
References: <1237379033-28095-1-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-2-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-3-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-4-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-5-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-6-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-7-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-8-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-9-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-10-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-11-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-12-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

An alignment issue with the existing bitfit algorithm was reported
on IA64. This patch attempts to fix that, and also to tidy up the
code a bit. There is now more documentation about how this works
and it has survived a number of different tests.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index a068ac9..c0abe69 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -132,81 +132,89 @@ static inline unsigned char gfs2_testbit(struct gfs2_rgrpd *rgd,
 }
 
 /**
+ * gfs2_bit_search
+ * @ptr: Pointer to bitmap data
+ * @mask: Mask to use (normally 0x55555.... but adjusted for search start)
+ * @state: The state we are searching for
+ *
+ * We xor the bitmap data with a patter which is the bitwise opposite
+ * of what we are looking for, this gives rise to a pattern of ones
+ * wherever there is a match. Since we have two bits per entry, we
+ * take this pattern, shift it down by one place and then and it with
+ * the original. All the even bit positions (0,2,4, etc) then represent
+ * successful matches, so we mask with 0x55555..... to remove the unwanted
+ * odd bit positions.
+ *
+ * This allows searching of a whole u64 at once (32 blocks) with a
+ * single test (on 64 bit arches).
+ */
+
+static inline u64 gfs2_bit_search(const __le64 *ptr, u64 mask, u8 state)
+{
+	u64 tmp;
+	static const u64 search[] = {
+		[0] = 0xffffffffffffffff,
+		[1] = 0xaaaaaaaaaaaaaaaa,
+		[2] = 0x5555555555555555,
+		[3] = 0x0000000000000000,
+	};
+	tmp = le64_to_cpu(*ptr) ^ search[state];
+	tmp &= (tmp >> 1);
+	tmp &= mask;
+	return tmp;
+}
+
+/**
  * gfs2_bitfit - Search an rgrp's bitmap buffer to find a bit-pair representing
  *       a block in a given allocation state.
  * @buffer: the buffer that holds the bitmaps
- * @buflen: the length (in bytes) of the buffer
+ * @len: the length (in bytes) of the buffer
  * @goal: start search at this block's bit-pair (within @buffer)
- * @old_state: GFS2_BLKST_XXX the state of the block we're looking for.
+ * @state: GFS2_BLKST_XXX the state of the block we're looking for.
  *
  * Scope of @goal and returned block number is only within this bitmap buffer,
  * not entire rgrp or filesystem.  @buffer will be offset from the actual
- * beginning of a bitmap block buffer, skipping any header structures.
+ * beginning of a bitmap block buffer, skipping any header structures, but
+ * headers are always a multiple of 64 bits long so that the buffer is
+ * always aligned to a 64 bit boundary.
+ *
+ * The size of the buffer is in bytes, but is it assumed that it is
+ * always ok to to read a complete multiple of 64 bits at the end
+ * of the block in case the end is no aligned to a natural boundary.
  *
  * Return: the block number (bitmap buffer scope) that was found
  */
 
-static u32 gfs2_bitfit(const u8 *buffer, unsigned int buflen, u32 goal,
-		       u8 old_state)
+u32 gfs2_bitfit(const u8 *buf, const unsigned int len, u32 goal, u8 state)
 {
-	const u8 *byte, *start, *end;
-	int bit, startbit;
-	u32 g1, g2, misaligned;
-	unsigned long *plong;
-	unsigned long lskipval;
-
-	lskipval = (old_state & GFS2_BLKST_USED) ? LBITSKIP00 : LBITSKIP55;
-	g1 = (goal / GFS2_NBBY);
-	start = buffer + g1;
-	byte = start;
-        end = buffer + buflen;
-	g2 = ALIGN(g1, sizeof(unsigned long));
-	plong = (unsigned long *)(buffer + g2);
-	startbit = bit = (goal % GFS2_NBBY) * GFS2_BIT_SIZE;
-	misaligned = g2 - g1;
-	if (!misaligned)
-		goto ulong_aligned;
-/* parse the bitmap a byte at a time */
-misaligned:
-	while (byte < end) {
-		if (((*byte >> bit) & GFS2_BIT_MASK) == old_state) {
-			return goal +
-				(((byte - start) * GFS2_NBBY) +
-				 ((bit - startbit) >> 1));
-		}
-		bit += GFS2_BIT_SIZE;
-		if (bit >= GFS2_NBBY * GFS2_BIT_SIZE) {
-			bit = 0;
-			byte++;
-			misaligned--;
-			if (!misaligned) {
-				plong = (unsigned long *)byte;
-				goto ulong_aligned;
-			}
-		}
-	}
-	return BFITNOENT;
-
-/* parse the bitmap a unsigned long at a time */
-ulong_aligned:
-	/* Stop at "end - 1" or else prefetch can go past the end and segfault.
-	   We could "if" it but we'd lose some of the performance gained.
-	   This way will only slow down searching the very last 4/8 bytes
-	   depending on architecture.  I've experimented with several ways
-	   of writing this section such as using an else before the goto
-	   but this one seems to be the fastest. */
-	while ((unsigned char *)plong < end - sizeof(unsigned long)) {
-		prefetch(plong + 1);
-		if (((*plong) & LBITMASK) != lskipval)
-			break;
-		plong++;
-	}
-	if ((unsigned char *)plong < end) {
-		byte = (const u8 *)plong;
-		misaligned += sizeof(unsigned long) - 1;
-		goto misaligned;
+	u32 spoint = (goal << 1) & ((8*sizeof(u64)) - 1);
+	const __le64 *ptr = ((__le64 *)buf) + (goal >> 5);
+	const __le64 *end = (__le64 *)(buf + ALIGN(len, sizeof(u64)));
+	u64 tmp;
+	u64 mask = 0x5555555555555555;
+	u32 bit;
+
+	BUG_ON(state > 3);
+
+	/* Mask off bits we don't care about at the start of the search */
+	mask <<= spoint;
+	tmp = gfs2_bit_search(ptr, mask, state);
+	ptr++;
+	while(tmp == 0 && ptr < end) {
+		tmp = gfs2_bit_search(ptr, 0x5555555555555555, state);
+		ptr++;
 	}
-	return BFITNOENT;
+	/* Mask off any bits which are more than len bytes from the start */
+	if (ptr == end && (len & (sizeof(u64) - 1)))
+		tmp &= (((u64)~0) >> (64 - 8*(len & (sizeof(u64) - 1))));
+	/* Didn't find anything, so return */
+	if (tmp == 0)
+		return BFITNOENT;
+	ptr--;
+	bit = fls64(tmp);
+	bit--;		/* fls64 always adds one to the bit count */
+	bit /= 2;	/* two bits per entry in the bitmap */
+	return (((const unsigned char *)ptr - buf) * GFS2_NBBY) + bit;
 }
 
 /**
-- 
1.6.0.3

