Return-Path: <linux-kernel-owner+w=401wt.eu-S1761191AbZFKILE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761191AbZFKILE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 04:11:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760272AbZFKIKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 04:10:47 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:15627 "EHLO
	IE1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759144AbZFKIKo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 04:10:44 -0400
X-SpamScore: -28
X-BigFish: VPS-28(zz1432R98dR936eN1805Mzz1202hzzz32i6bh17ch43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KL2EPM-04-YC2-01
Date: Thu, 11 Jun 2009 10:10:32 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu,
       lethal@linux-sh.org, hancockrwd@gmail.com, jens.axboe@oracle.com,
       bharrosh@panasas.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [PATCH] dma-debug: disable DMA_API_DEBUG for now
Message-ID: <20090611081032.GN5139@amd.com>
References: <20090605173232N.fujita.tomonori@lab.ntt.co.jp> <20090605104132.GE24836@amd.com> <64bb37e0906101341j341f5179o9abfa888a6b96fc3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <64bb37e0906101341j341f5179o9abfa888a6b96fc3@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 11 Jun 2009 08:10:33.0348 (UTC) FILETIME=[17CD7C40:01C9EA6C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 10:41:53PM +0200, Torsten Kaiser wrote:
> I applied this patch to the just released 2.6.30, but it does not fix
> the false warning on my System.
> 
> Jun 10 21:10:14 treogen [ 2611.715341] ------------[ cut here ]------------
> Jun 10 21:10:14 treogen [ 2611.715359] WARNING: at lib/dma-debug.c:565
> check_unmap+0x536/0x620()
> Jun 10 21:10:14 treogen [ 2611.715363] Hardware name: KFN5-D SLI
> Jun 10 21:10:14 treogen [ 2611.715369] sata_sil24 0000:04:00.0:
> DMA-API: device driver frees DMA sg list with different entry count [map count=2] [unmap count=1]

Ok, thats because we need also to check for sg_call_ents in the best-fit
checks. Can you please test if you can reproduce it with the attached
patch?

>From 1e83c7eab546314ad9dbe08602d243bb83e93b50 Mon Sep 17 00:00:00 2001
From: Joerg Roedel <joerg.roedel@amd.com>
Date: Thu, 11 Jun 2009 10:03:42 +0200
Subject: [PATCH] dma-debug: check for sg_call_ents in best-fit algorithm too

If we don't check for sg_call_ents the hash_bucket_find function might
still return the wrong dma_debug_entry for sg mappings.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 lib/dma-debug.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index ad65fc0..eb86ec3 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -262,11 +262,12 @@ static struct dma_debug_entry *hash_bucket_find(struct hash_bucket *bucket,
 		 */
 		matches += 1;
 		match_lvl = 0;
-		entry->size      == ref->size      ? ++match_lvl : match_lvl;
-		entry->type      == ref->type      ? ++match_lvl : match_lvl;
-		entry->direction == ref->direction ? ++match_lvl : match_lvl;
+		entry->size         == ref->size         ? ++match_lvl : 0;
+		entry->type         == ref->type         ? ++match_lvl : 0;
+		entry->direction    == ref->direction    ? ++match_lvl : 0;
+		entry->sg_call_ents == ref->sg_call_ents ? ++match_lvl : 0;
 
-		if (match_lvl == 3) {
+		if (match_lvl == 4) {
 			/* perfect-fit - return the result */
 			return entry;
 		} else if (match_lvl > last_lvl) {
-- 
1.6.3.1


-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

