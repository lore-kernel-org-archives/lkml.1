Return-Path: <linux-kernel-owner+w=401wt.eu-S935370AbYDQJyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935370AbYDQJyz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752935AbYDQJ0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:26:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46252 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933760AbYDQJ0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:26:44 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 44/48] [GFS2] Faster gfs2_bitfit algorithm
Date: Thu, 17 Apr 2008 09:39:20 +0100
Message-Id: <12084216593910-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1208421657826-git-send-email-swhiteho@redhat.com>
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
 <12084216003676-git-send-email-swhiteho@redhat.com>
 <12084216023999-git-send-email-swhiteho@redhat.com>
 <12084216044123-git-send-email-swhiteho@redhat.com>
 <12084216061172-git-send-email-swhiteho@redhat.com>
 <12084216082638-git-send-email-swhiteho@redhat.com>
 <12084216101961-git-send-email-swhiteho@redhat.com>
 <12084216121811-git-send-email-swhiteho@redhat.com>
 <12084216153016-git-send-email-swhiteho@redhat.com>
 <1208421617421-git-send-email-swhiteho@redhat.com>
 <12084216182363-git-send-email-swhiteho@redhat.com>
 <12084216204027-git-send-email-swhiteho@redhat.com>
 <12084216222853-git-send-email-swhiteho@redhat.com>
 <12084216241802-git-send-email-swhiteho@redhat.com>
 <12084216262937-git-send-email-swhiteho@redhat.com>
 <12084216281152-git-send-email-swhiteho@redhat.com>
 <12084216301107-git-send-email-swhiteho@redhat.com>
 <12084216323165-git-send-email-swhiteho@redhat.com>
 <1208421634101-git-send-email-swhiteho@redhat.com>
 <12084216372363-git-send-email-swhiteho@redhat.com>
 <12084216391215-git-send-email-swhiteho@redhat.com>
 <12084216402644-git-send-email-swhiteho@redhat.com>
 <12084216431261-git-send-email-swhiteho@redhat.com>
 <1208421645785-git-send-email-swhiteho@redhat.com>
 <1208421647805-git-send-email-swhiteho@redhat.com>
 <12084216494161-git-send-email-swhiteho@redhat.com>
 <12084216511207-git-send-email-swhiteho@redhat.com>
 <12084216533319-git-send-email-swhiteho@redhat.com>
 <12084216553542-git-send-email-swhiteho@redhat.com>
 <1208421657826-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This version of the gfs2_bitfit algorithm includes the latest
suggestions from Steve Whitehouse.  It is typically eight to
ten times faster than the version we're using today.  If there
is a lot of metadata mixed in (lots of small files) the
algorithm is often 15 times faster, and given the right
conditions, I've seen peaks of 20 times faster.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 4291375..7e8f0b1 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -14,6 +14,7 @@
 #include <linux/fs.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/lm_interface.h>
+#include <linux/prefetch.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -33,6 +34,16 @@
 #define BFITNOENT ((u32)~0)
 #define NO_BLOCK ((u64)~0)
 
+#if BITS_PER_LONG == 32
+#define LBITMASK   (0x55555555UL)
+#define LBITSKIP55 (0x55555555UL)
+#define LBITSKIP00 (0x00000000UL)
+#else
+#define LBITMASK   (0x5555555555555555UL)
+#define LBITSKIP55 (0x5555555555555555UL)
+#define LBITSKIP00 (0x0000000000000000UL)
+#endif
+
 /*
  * These routines are used by the resource group routines (rgrp.c)
  * to keep track of block allocation.  Each block is represented by two
@@ -138,45 +149,63 @@ static inline unsigned char gfs2_testbit(struct gfs2_rgrpd *rgd,
 static u32 gfs2_bitfit(const u8 *buffer, unsigned int buflen, u32 goal,
 		       u8 old_state)
 {
-	const u8 *byte;
-	u32 blk = goal;
-	unsigned int bit, bitlong;
-	const unsigned long *plong;
-#if BITS_PER_LONG == 32
-	const unsigned long plong55 = 0x55555555;
-#else
-	const unsigned long plong55 = 0x5555555555555555;
-#endif
-
-	byte = buffer + (goal / GFS2_NBBY);
-	plong = (const unsigned long *)(buffer + (goal / GFS2_NBBY));
-	bit = (goal % GFS2_NBBY) * GFS2_BIT_SIZE;
-	bitlong = bit;
-
-	while (byte < buffer + buflen) {
-
-		if (bitlong == 0 && old_state == 0 && *plong == plong55) {
-			plong++;
-			byte += sizeof(unsigned long);
-			blk += sizeof(unsigned long) * GFS2_NBBY;
-			continue;
+	const u8 *byte, *start, *end;
+	int bit, startbit;
+	u32 g1, g2, misaligned;
+	unsigned long *plong;
+	unsigned long lskipval;
+
+	lskipval = (old_state & GFS2_BLKST_USED) ? LBITSKIP00 : LBITSKIP55;
+	g1 = (goal / GFS2_NBBY);
+	start = buffer + g1;
+	byte = start;
+        end = buffer + buflen;
+	g2 = ALIGN(g1, sizeof(unsigned long));
+	plong = (unsigned long *)(buffer + g2);
+	startbit = bit = (goal % GFS2_NBBY) * GFS2_BIT_SIZE;
+	misaligned = g2 - g1;
+	if (!misaligned)
+		goto ulong_aligned;
+/* parse the bitmap a byte at a time */
+misaligned:
+	while (byte < end) {
+		if (((*byte >> bit) & GFS2_BIT_MASK) == old_state) {
+			return goal +
+				(((byte - start) * GFS2_NBBY) +
+				 ((bit - startbit) >> 1));
 		}
-		if (((*byte >> bit) & GFS2_BIT_MASK) == old_state)
-			return blk;
 		bit += GFS2_BIT_SIZE;
-		if (bit >= 8) {
+		if (bit >= GFS2_NBBY * GFS2_BIT_SIZE) {
 			bit = 0;
 			byte++;
+			misaligned--;
+			if (!misaligned) {
+				plong = (unsigned long *)byte;
+				goto ulong_aligned;
+			}
 		}
-		bitlong += GFS2_BIT_SIZE;
-		if (bitlong >= sizeof(unsigned long) * 8) {
-			bitlong = 0;
-			plong++;
-		}
-
-		blk++;
 	}
+	return BFITNOENT;
 
+/* parse the bitmap a unsigned long at a time */
+ulong_aligned:
+	/* Stop at "end - 1" or else prefetch can go past the end and segfault.
+	   We could "if" it but we'd lose some of the performance gained.
+	   This way will only slow down searching the very last 4/8 bytes
+	   depending on architecture.  I've experimented with several ways
+	   of writing this section such as using an else before the goto
+	   but this one seems to be the fastest. */
+	while ((unsigned char *)plong < end - 1) {
+		prefetch(plong + 1);
+		if (((*plong) & LBITMASK) != lskipval)
+			break;
+		plong++;
+	}
+	if ((unsigned char *)plong < end) {
+		byte = (const u8 *)plong;
+		misaligned += sizeof(unsigned long) - 1;
+		goto misaligned;
+	}
 	return BFITNOENT;
 }
 
-- 
1.5.1.2

