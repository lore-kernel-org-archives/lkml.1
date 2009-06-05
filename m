Return-Path: <linux-kernel-owner+w=401wt.eu-S1752485AbZFEKmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485AbZFEKmS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 06:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbZFEKmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 06:42:00 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:44241 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbZFEKl7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 06:41:59 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zz1418M1432R98dR936eN148cM1805M10d1Izz1202hzz3198u327alz32i6bh17ch43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KKRHP9-04-8NT-01
Date: Fri, 5 Jun 2009 12:41:33 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: mingo@elte.hu, lethal@linux-sh.org, just.for.lkml@googlemail.com,
       hancockrwd@gmail.com, jens.axboe@oracle.com, bharrosh@panasas.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] dma-debug: disable DMA_API_DEBUG for now
Message-ID: <20090605104132.GE24836@amd.com>
References: <20090605173232N.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090605173232N.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.19 (2009-01-05)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 05 Jun 2009 10:41:33.0612 (UTC) FILETIME=[31A98EC0:01C9E5CA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, Jun 05, 2009 at 05:33:14PM +0900, FUJITA Tomonori wrote:
> dma-debugs wrongly assumes that no multiple DMA transfers are
> performed against the same dma address on one device at the same
> time. However it's true only with hardware IOMMUs. For example, an
> application can easily send the same buffer twice with different
> lengths to one device by using DIO and AIO. If these requests are not
> unmapped in the same order in which they were mapped,
> hash_bucket_find() finds a wrong entry and gives a false warning.
> 
> We should fix this before 2.6.30 release. Seems that there is no
> easy way to fix it. I think that it's better to just disable
> dma-debug for now.
> 
> Torsten Kaiser found this bug with the RAID1 configuration:
> 
> http://marc.info/?t=124336541900008&r=1&w=2
> 

Argh, I never thought that this can happen. But its not explicitly
forbidden so we have to handle this situation. Thanks for tracking down
the bug to this issue.
However, I think there is a somehow simple fix for the issue. Patch is
attached. Its the least intrusive way I can think of to fix this
problem.
But its up to Linus/Ingo to decide if it can be accepted at this very
late point in the cycle. Since dma-debug is new with 2.6.30 it will at
least not introduce any regression. The patch is boot and basically
load-tested with some disk and network load and showed no issues on my
test machine. The diffstat looks big but more than the half of the patch
adds comments to explain what it does. So the diffstat looks bigger than
the actual change.
Linus, if you think my patch is not acceptable at this point then please
apply the patch from FUJITA Tomonori.

Regards,

	Joerg

>From c0baa4d43a674c9cc321af3b23a6d5c9b46d65bd Mon Sep 17 00:00:00 2001
From: Joerg Roedel <joerg.roedel@amd.com>
Date: Fri, 5 Jun 2009 12:01:35 +0200
Subject: [PATCH] dma-debug: change hash_bucket_find from first-fit to best-fit

Some device drivers map the same physical address multiple times to a
dma address. Without an IOMMU this results in the same dma address being
put into the dma-debug hash multiple times. With a first-fit match in
hash_bucket_find() this function may return the wrong dma_debug_entry.
This can result in false positive warnings. This patch fixes it by
changing the first-fit behavior of hash_bucket_find() into a best-fit
algorithm.

Reported-by: Torsten Kaiser <just.for.lkml@googlemail.com>
Reported-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 lib/dma-debug.c |   43 +++++++++++++++++++++++++++++++++++++++----
 1 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 69da09a..2b16536 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -185,15 +185,50 @@ static void put_hash_bucket(struct hash_bucket *bucket,
 static struct dma_debug_entry *hash_bucket_find(struct hash_bucket *bucket,
 						struct dma_debug_entry *ref)
 {
-	struct dma_debug_entry *entry;
+	struct dma_debug_entry *entry, *ret = NULL;
+	int matches = 0, match_lvl, last_lvl = 0;
 
 	list_for_each_entry(entry, &bucket->list, list) {
-		if ((entry->dev_addr == ref->dev_addr) &&
-		    (entry->dev == ref->dev))
+		if ((entry->dev_addr != ref->dev_addr) ||
+		    (entry->dev != ref->dev))
+			continue;
+
+		/*
+		 * Some drivers map the same physical address multiple
+		 * times. Without a hardware IOMMU this results in the
+		 * same device addresses being put into the dma-debug
+		 * hash multiple times too. This can result in false
+		 * positives being reported. Therfore we implement a
+		 * best-fit algorithm here which returns the entry from
+		 * the hash which fits best to the reference value
+		 * instead of the first-fit.
+		 */
+		matches += 1;
+		match_lvl = 0;
+		entry->size      == ref->size      ? ++match_lvl : match_lvl;
+		entry->type      == ref->type      ? ++match_lvl : match_lvl;
+		entry->direction == ref->direction ? ++match_lvl : match_lvl;
+
+		if (match_lvl == 3) {
+			/* perfect-fit - return the result */
 			return entry;
+		} else if (match_lvl > last_lvl) {
+			/*
+			 * We found an entry that fits better then the
+			 * previous one
+			 */
+			last_lvl = match_lvl;
+			ret      = entry;
+		}
 	}
 
-	return NULL;
+	/*
+	 * If we have multiple matches but no perfect-fit, just return
+	 * NULL.
+	 */
+	ret = (matches == 1) ? ret : NULL;
+
+	return ret;
 }
 
 /*
-- 
1.6.3.1




-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

