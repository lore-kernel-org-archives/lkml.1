Return-Path: <linux-kernel-owner+w=401wt.eu-S1753779AbYGELLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbYGELLj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 07:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbYGELLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 07:11:32 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:16758 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbYGELLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 07:11:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dXxcf0fn/juEHC4IUkBULauI7+etX/MamWS839P1IZFEcC+LVMNfFu9sguLTJA2aDo
         MS7nwTN5bURPihHf9g52Rco6pzLTYk/If4pv5MNGaQm9iHMSFgjOP+ePUeVyXLGkdGkd
         t6Cct3jFH1oUFZg3ufbebkhLKlXbyJZI0cqf8=
Date: Sat, 5 Jul 2008 20:11:24 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Pavel Machek <pavel@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-pm@lists.linux-foundation.org
Subject: [PATCH 2/2] swsusp: simplify memory bitmap
Message-ID: <20080705111123.GB17071@localhost.localdomain>
References: <20080705110946.GA17071@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <20080705110946.GA17071@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch simplifies the memory bitmap manipulations.

- remove the member size in struct bm_block

It is not necessary for struct bm_block to have the number of bit chunks
that can be calculated by using end_pfn and start_pfn.

- use find_next_bit() for memory_bm_next_pfn

No need to invent the bitmap library only for the memory bitmap.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Pavel Machek <pavel@suse.cz>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org
---
 kernel/power/snapshot.c |   84 ++++++++++--------------------------------------
 1 file changed, 19 insertions(+), 65 deletions(-)

Index: 2.6-git/kernel/power/snapshot.c
===================================================================
--- 2.6-git.orig/kernel/power/snapshot.c
+++ 2.6-git/kernel/power/snapshot.c
@@ -205,8 +205,7 @@ static void chain_free(struct chain_allo
  *	objects.  The main list's elements are of type struct zone_bitmap
  *	and each of them corresonds to one zone.  For each zone bitmap
  *	object there is a list of objects of type struct bm_block that
- *	represent each blocks of bit chunks in which information is
- *	stored.
+ *	represent each blocks of bitmap in which information is stored.
  *
  *	struct memory_bitmap contains a pointer to the main list of zone
  *	bitmap objects, a struct bm_position used for browsing the bitmap,
@@ -224,26 +223,27 @@ static void chain_free(struct chain_allo
  *	pfns that correspond to the start and end of the represented zone.
  *
  *	struct bm_block contains a pointer to the memory page in which
- *	information is stored (in the form of a block of bit chunks
- *	of type unsigned long each).  It also contains the pfns that
- *	correspond to the start and end of the represented memory area and
- *	the number of bit chunks in the block.
+ *	information is stored (in the form of a block of bitmap)
+ *	It also contains the pfns that correspond to the start and end of
+ *	the represented memory area.
  */
 
 #define BM_END_OF_MAP	(~0UL)
 
-#define BM_CHUNKS_PER_BLOCK	(PAGE_SIZE / sizeof(long))
-#define BM_BITS_PER_CHUNK	(sizeof(long) << 3)
 #define BM_BITS_PER_BLOCK	(PAGE_SIZE << 3)
 
 struct bm_block {
 	struct bm_block *next;		/* next element of the list */
 	unsigned long start_pfn;	/* pfn represented by the first bit */
 	unsigned long end_pfn;	/* pfn represented by the last bit plus 1 */
-	unsigned int size;	/* number of bit chunks */
-	unsigned long *data;	/* chunks of bits representing pages */
+	unsigned long *data;	/* bitmap representing pages */
 };
 
+static inline unsigned long bm_block_bits(struct bm_block *bb)
+{
+	return bb->end_pfn - bb->start_pfn;
+}
+
 struct zone_bitmap {
 	struct zone_bitmap *next;	/* next element of the list */
 	unsigned long start_pfn;	/* minimal pfn in this zone */
@@ -257,7 +257,6 @@ struct zone_bitmap {
 struct bm_position {
 	struct zone_bitmap *zone_bm;
 	struct bm_block *block;
-	int chunk;
 	int bit;
 };
 
@@ -272,12 +271,6 @@ struct memory_bitmap {
 
 /* Functions that operate on memory bitmaps */
 
-static inline void memory_bm_reset_chunk(struct memory_bitmap *bm)
-{
-	bm->cur.chunk = 0;
-	bm->cur.bit = -1;
-}
-
 static void memory_bm_position_reset(struct memory_bitmap *bm)
 {
 	struct zone_bitmap *zone_bm;
@@ -285,7 +278,7 @@ static void memory_bm_position_reset(str
 	zone_bm = bm->zone_bm_list;
 	bm->cur.zone_bm = zone_bm;
 	bm->cur.block = zone_bm->bm_blocks;
-	memory_bm_reset_chunk(bm);
+	bm->cur.bit = 0;
 }
 
 static void memory_bm_free(struct memory_bitmap *bm, int clear_nosave_free);
@@ -394,12 +387,10 @@ memory_bm_create(struct memory_bitmap *b
 			bb->start_pfn = pfn;
 			if (nr >= BM_BITS_PER_BLOCK) {
 				pfn += BM_BITS_PER_BLOCK;
-				bb->size = BM_CHUNKS_PER_BLOCK;
 				nr -= BM_BITS_PER_BLOCK;
 			} else {
 				/* This is executed only once in the loop */
 				pfn += nr;
-				bb->size = DIV_ROUND_UP(nr, BM_BITS_PER_CHUNK);
 			}
 			bb->end_pfn = pfn;
 			bb = bb->next;
@@ -528,36 +519,6 @@ static int memory_bm_test_bit(struct mem
 	return test_bit(bit, addr);
 }
 
-/* Two auxiliary functions for memory_bm_next_pfn */
-
-/* Find the first set bit in the given chunk, if there is one */
-
-static inline int next_bit_in_chunk(int bit, unsigned long *chunk_p)
-{
-	bit++;
-	while (bit < BM_BITS_PER_CHUNK) {
-		if (test_bit(bit, chunk_p))
-			return bit;
-
-		bit++;
-	}
-	return -1;
-}
-
-/* Find a chunk containing some bits set in given block of bits */
-
-static inline int next_chunk_in_block(int n, struct bm_block *bb)
-{
-	n++;
-	while (n < bb->size) {
-		if (bb->data[n])
-			return n;
-
-		n++;
-	}
-	return -1;
-}
-
 /**
  *	memory_bm_next_pfn - find the pfn that corresponds to the next set bit
  *	in the bitmap @bm.  If the pfn cannot be found, BM_END_OF_MAP is
@@ -571,40 +532,33 @@ static unsigned long memory_bm_next_pfn(
 {
 	struct zone_bitmap *zone_bm;
 	struct bm_block *bb;
-	int chunk;
 	int bit;
 
 	do {
 		bb = bm->cur.block;
 		do {
-			chunk = bm->cur.chunk;
 			bit = bm->cur.bit;
-			do {
-				bit = next_bit_in_chunk(bit, bb->data + chunk);
-				if (bit >= 0)
-					goto Return_pfn;
-
-				chunk = next_chunk_in_block(chunk, bb);
-				bit = -1;
-			} while (chunk >= 0);
+			bit = find_next_bit(bb->data, bm_block_bits(bb), bit);
+			if (bit < bm_block_bits(bb))
+				goto Return_pfn;
+
 			bb = bb->next;
 			bm->cur.block = bb;
-			memory_bm_reset_chunk(bm);
+			bm->cur.bit = 0;
 		} while (bb);
 		zone_bm = bm->cur.zone_bm->next;
 		if (zone_bm) {
 			bm->cur.zone_bm = zone_bm;
 			bm->cur.block = zone_bm->bm_blocks;
-			memory_bm_reset_chunk(bm);
+			bm->cur.bit = 0;
 		}
 	} while (zone_bm);
 	memory_bm_position_reset(bm);
 	return BM_END_OF_MAP;
 
  Return_pfn:
-	bm->cur.chunk = chunk;
-	bm->cur.bit = bit;
-	return bb->start_pfn + chunk * BM_BITS_PER_CHUNK + bit;
+	bm->cur.bit = bit + 1;
+	return bb->start_pfn + bit;
 }
 
 /**
