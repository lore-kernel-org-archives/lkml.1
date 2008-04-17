Return-Path: <linux-kernel-owner+w=401wt.eu-S934654AbYDQJlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934654AbYDQJlN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:41:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933471AbYDQJZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:25:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46170 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933343AbYDQJZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:25:44 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 15/48] [GFS2] Add consts to various bits of rgrp.c
Date: Thu, 17 Apr 2008 09:38:51 +0100
Message-Id: <12084216003676-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1208421597980-git-send-email-swhiteho@redhat.com>
References: 12084214272083-git-send-email-swhiteho@redhat.com
 <12084215642582-git-send-email-swhiteho@redhat.com>
 <1208421571478-git-send-email-swhiteho@redhat.com>
 <12084215742081-git-send-email-swhiteho@redhat.com>
 <12084215763647-git-send-email-swhiteho@redhat.com>
 <12084215781246-git-send-email-swhiteho@redhat.com>
 <12084215802470-git-send-email-swhiteho@redhat.com>
 <12084215833555-git-send-email-swhiteho@redhat.com>
 <12084215851158-git-send-email-swhiteho@redhat.com>
 <120842158797-git-send-email-swhiteho@redhat.com>
 <12084215891940-git-send-email-swhiteho@redhat.com>
 <12084215913125-git-send-email-swhiteho@redhat.com>
 <12084215931509-git-send-email-swhiteho@redhat.com>
 <12084215961690-git-send-email-swhiteho@redhat.com>
 <1208421597980-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

There are a couple of routines which scan bitmaps where we can
mark the bitmaps const, plus a couple of call sites that can
be updated too.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index da60ce8..5fd8710 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -126,23 +126,24 @@ static unsigned char gfs2_testbit(struct gfs2_rgrpd *rgd, unsigned char *buffer,
  * Return: the block number (bitmap buffer scope) that was found
  */
 
-static u32 gfs2_bitfit(unsigned char *buffer, unsigned int buflen, u32 goal,
-		       unsigned char old_state)
+static u32 gfs2_bitfit(const u8 *buffer, unsigned int buflen, u32 goal,
+		       u8 old_state)
 {
-	unsigned char *byte;
+	const u8 *byte;
 	u32 blk = goal;
 	unsigned int bit, bitlong;
-	unsigned long *plong, plong55;
+	const unsigned long *plong;
+#if BITS_PER_LONG == 32
+	const unsigned long plong55 = 0x55555555;
+#else
+	const unsigned long plong55 = 0x5555555555555555;
+#endif
 
 	byte = buffer + (goal / GFS2_NBBY);
-	plong = (unsigned long *)(buffer + (goal / GFS2_NBBY));
+	plong = (const unsigned long *)(buffer + (goal / GFS2_NBBY));
 	bit = (goal % GFS2_NBBY) * GFS2_BIT_SIZE;
 	bitlong = bit;
-#if BITS_PER_LONG == 32
-	plong55 = 0x55555555;
-#else
-	plong55 = 0x5555555555555555;
-#endif
+
 	while (byte < buffer + buflen) {
 
 		if (bitlong == 0 && old_state == 0 && *plong == plong55) {
@@ -179,14 +180,14 @@ static u32 gfs2_bitfit(unsigned char *buffer, unsigned int buflen, u32 goal,
  * Returns: The number of bits
  */
 
-static u32 gfs2_bitcount(struct gfs2_rgrpd *rgd, unsigned char *buffer,
-			      unsigned int buflen, unsigned char state)
+static u32 gfs2_bitcount(struct gfs2_rgrpd *rgd, const u8 *buffer,
+			 unsigned int buflen, u8 state)
 {
-	unsigned char *byte = buffer;
-	unsigned char *end = buffer + buflen;
-	unsigned char state1 = state << 2;
-	unsigned char state2 = state << 4;
-	unsigned char state3 = state << 6;
+	const u8 *byte = buffer;
+	const u8 *end = buffer + buflen;
+	const u8 state1 = state << 2;
+	const u8 state2 = state << 4;
+	const u8 state3 = state << 6;
 	u32 count = 0;
 
 	for (; byte < end; byte++) {
@@ -1327,12 +1328,11 @@ static u32 rgblk_search(struct gfs2_rgrpd *rgd, u32 goal,
 	for (x = 0; x <= length; x++) {
 		/* The GFS2_BLKST_UNLINKED state doesn't apply to the clone
 		   bitmaps, so we must search the originals for that. */
+		const u8 *buffer = bi->bi_bh->b_data + bi->bi_offset;
 		if (old_state != GFS2_BLKST_UNLINKED && bi->bi_clone)
-			blk = gfs2_bitfit(bi->bi_clone + bi->bi_offset,
-					  bi->bi_len, goal, old_state);
-		else
-			blk = gfs2_bitfit(bi->bi_bh->b_data + bi->bi_offset,
-					  bi->bi_len, goal, old_state);
+			buffer = bi->bi_clone + bi->bi_offset;
+
+		blk = gfs2_bitfit(buffer, bi->bi_len, goal, old_state);
 		if (blk != BFITNOENT)
 			break;
 
-- 
1.5.1.2

