Return-Path: <linux-kernel-owner+w=401wt.eu-S1754265AbZF0Hzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265AbZF0Hzo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 03:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbZF0Hze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 03:55:34 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:34359 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079AbZF0Hzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 03:55:32 -0400
Date: Sat, 27 Jun 2009 09:55:32 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/mtd: use BLOCK_NIL
Message-ID: <Pine.LNX.4.64.0906270954290.2729@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use BLOCK_NIL consistently rather than sometimes 0xffff and sometimes
BLOCK_NIL.

The semantic patch that finds this issue is below
(http://www.emn.fr/x-info/coccinelle/).  On the other hand, the changes
were made by hand, in part because drivers/mtd/inftlcore.c contains dead
code that causes spatch to ignore a relevant function.  Specifically, the
function INFTL_findwriteunit contains a do-while loop, but always takes a
return that leaves the loop on the first iteration.

// <smpl>
@r exists@
identifier f,C;
@@

f(...) { ... return C; }

@s@
identifier r.C;
expression E;
@@

#define C E

@@
identifier r.f,r.C,I;
expression s.E;
@@

f(...) {
 <...
(
  I
|
- E
+ C
)
 ...>
}

// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/mtd/inftlcore.c |   11 ++++++-----
 drivers/mtd/nftlcore.c  |   16 ++++++++--------
 2 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/mtd/inftlcore.c b/drivers/mtd/inftlcore.c
index 73f0522..d8cf29c 100644
--- a/drivers/mtd/inftlcore.c
+++ b/drivers/mtd/inftlcore.c
@@ -226,7 +226,7 @@ static u16 INFTL_findfreeblock(struct INFTLrecord *inftl, int desperate)
 	if (!desperate && inftl->numfreeEUNs < 2) {
 		DEBUG(MTD_DEBUG_LEVEL1, "INFTL: there are too few free "
 			"EUNs (%d)\n", inftl->numfreeEUNs);
-		return 0xffff;
+		return BLOCK_NIL;
 	}
 
 	/* Scan for a free block */
@@ -281,7 +281,8 @@ static u16 INFTL_foldchain(struct INFTLrecord *inftl, unsigned thisVUC, unsigned
 	silly = MAX_LOOPS;
 	while (thisEUN < inftl->nb_blocks) {
 		for (block = 0; block < inftl->EraseSize/SECTORSIZE; block ++) {
-			if ((BlockMap[block] != 0xffff) || BlockDeleted[block])
+			if ((BlockMap[block] != BLOCK_NIL) ||
+			    BlockDeleted[block])
 				continue;
 
 			if (inftl_read_oob(mtd, (thisEUN * inftl->EraseSize)
@@ -525,7 +526,7 @@ static inline u16 INFTL_findwriteunit(struct INFTLrecord *inftl, unsigned block)
 			if (!silly--) {
 				printk(KERN_WARNING "INFTL: infinite loop in "
 					"Virtual Unit Chain 0x%x\n", thisVUC);
-				return 0xffff;
+				return BLOCK_NIL;
 			}
 
 			/* Skip to next block in chain */
@@ -549,7 +550,7 @@ hitused:
 			 * waiting to be picked up. We're going to have to fold
 			 * a chain to make room.
 			 */
-			thisEUN = INFTL_makefreeblock(inftl, 0xffff);
+			thisEUN = INFTL_makefreeblock(inftl, BLOCK_NIL);
 
 			/*
 			 * Hopefully we free something, lets try again.
@@ -631,7 +632,7 @@ hitused:
 
 	printk(KERN_WARNING "INFTL: error folding to make room for Virtual "
 		"Unit Chain 0x%x\n", thisVUC);
-	return 0xffff;
+	return BLOCK_NIL;
 }
 
 /*
diff --git a/drivers/mtd/nftlcore.c b/drivers/mtd/nftlcore.c
index e3f8495..fb86cac 100644
--- a/drivers/mtd/nftlcore.c
+++ b/drivers/mtd/nftlcore.c
@@ -208,7 +208,7 @@ static u16 NFTL_findfreeblock(struct NFTLrecord *nftl, int desperate )
 	/* Normally, we force a fold to happen before we run out of free blocks completely */
 	if (!desperate && nftl->numfreeEUNs < 2) {
 		DEBUG(MTD_DEBUG_LEVEL1, "NFTL_findfreeblock: there are too few free EUNs\n");
-		return 0xffff;
+		return BLOCK_NIL;
 	}
 
 	/* Scan for a free block */
@@ -230,11 +230,11 @@ static u16 NFTL_findfreeblock(struct NFTLrecord *nftl, int desperate )
 			printk("Argh! No free blocks found! LastFreeEUN = %d, "
 			       "FirstEUN = %d\n", nftl->LastFreeEUN,
 			       le16_to_cpu(nftl->MediaHdr.FirstPhysicalEUN));
-			return 0xffff;
+			return BLOCK_NIL;
 		}
 	} while (pot != nftl->LastFreeEUN);
 
-	return 0xffff;
+	return BLOCK_NIL;
 }
 
 static u16 NFTL_foldchain (struct NFTLrecord *nftl, unsigned thisVUC, unsigned pendingblock )
@@ -431,7 +431,7 @@ static u16 NFTL_foldchain (struct NFTLrecord *nftl, unsigned thisVUC, unsigned p
 
 	/* add the header so that it is now a valid chain */
 	oob.u.a.VirtUnitNum = oob.u.a.SpareVirtUnitNum = cpu_to_le16(thisVUC);
-	oob.u.a.ReplUnitNum = oob.u.a.SpareReplUnitNum = 0xffff;
+	oob.u.a.ReplUnitNum = oob.u.a.SpareReplUnitNum = BLOCK_NIL;
 
 	nftl_write_oob(mtd, (nftl->EraseSize * targetEUN) + 8,
 		       8, &retlen, (char *)&oob.u);
@@ -515,7 +515,7 @@ static u16 NFTL_makefreeblock( struct NFTLrecord *nftl , unsigned pendingblock)
 	if (ChainLength < 2) {
 		printk(KERN_WARNING "No Virtual Unit Chains available for folding. "
 		       "Failing request\n");
-		return 0xffff;
+		return BLOCK_NIL;
 	}
 
 	return NFTL_foldchain (nftl, LongestChain, pendingblock);
@@ -578,7 +578,7 @@ static inline u16 NFTL_findwriteunit(struct NFTLrecord *nftl, unsigned block)
 				printk(KERN_WARNING
 				       "Infinite loop in Virtual Unit Chain 0x%x\n",
 				       thisVUC);
-				return 0xffff;
+				return BLOCK_NIL;
 			}
 
 			/* Skip to next block in chain */
@@ -601,7 +601,7 @@ static inline u16 NFTL_findwriteunit(struct NFTLrecord *nftl, unsigned block)
 			//u16 startEUN = nftl->EUNtable[thisVUC];
 
 			//printk("Write to VirtualUnitChain %d, calling makefreeblock()\n", thisVUC);
-			writeEUN = NFTL_makefreeblock(nftl, 0xffff);
+			writeEUN = NFTL_makefreeblock(nftl, BLOCK_NIL);
 
 			if (writeEUN == BLOCK_NIL) {
 				/* OK, we accept that the above comment is
@@ -673,7 +673,7 @@ static inline u16 NFTL_findwriteunit(struct NFTLrecord *nftl, unsigned block)
 
 	printk(KERN_WARNING "Error folding to make room for Virtual Unit Chain 0x%x\n",
 	       thisVUC);
-	return 0xffff;
+	return BLOCK_NIL;
 }
 
 static int nftl_writeblock(struct mtd_blktrans_dev *mbd, unsigned long block,
