Return-Path: <linux-kernel-owner+w=401wt.eu-S1755732AbXJYIkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732AbXJYIkF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 04:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753583AbXJYIjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 04:39:55 -0400
Received: from ozlabs.org ([203.10.76.45]:37505 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873AbXJYIjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 04:39:54 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 09/10] Change table chaining layout
Date: Thu, 25 Oct 2007 18:40:01 +1000
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Boaz Harrosh <bharrosh@panasas.com>, Jens Axboe <jens.axboe@oracle.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>, mingo@elte.hu
References: <1193076664-13652-10-git-send-email-jens.axboe@oracle.com> <471DCBB2.9020706@panasas.com> <alpine.LFD.0.999.0710230808260.30120@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710230808260.30120@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710251840.02157.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 October 2007 01:22:55 Linus Torvalds wrote:
> On Tue, 23 Oct 2007, Boaz Harrosh wrote:
> > But since we do not do that, and every single API in the kernel that
> > receives a scatterlist pointer also receives an sg_count parameter,
> > than I do not see what is so hacky about giving that sg_count parameter
> > to the one that needs it the most. sg_next();
>
> Well, I'd personally actually prefer to *not* have the count be passed
> down explicitly, because it's just too error prone.

Well, the duplication is bad, but walking lists to find the length is
inefficient so you pass around the length as well.

What irritates me more is that scatterlists aren't quite generically useful.
The virtio code wants to join a scatterlist created by blk_rq_map_sg() with
two others, yet it won't work because sg_chain() doesn't remove the end
marker from the first entry.

If this patch weren't already included, I'd be strongly arguing for the bio
idea: I find the chained sg code tricksy and ugly (sorry Jens).

To be constructive, how's this (BTW, why @arg@, I thought it was simply
"@arg"?)

===
Make sg_chain() a little more generic

Allow chaining when the first chain already has an end marker, and
change it to a slightly clearer semantic (the number of used entries
in the array, not that number plus one).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 61fdaf0..24bbc92 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -778,7 +778,7 @@ struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 		 * ended up doing another loop.
 		 */
 		if (prev)
-			sg_chain(prev, SCSI_MAX_SG_SEGMENTS, sgl);
+			sg_chain(prev, SCSI_MAX_SG_SEGMENTS-1, sgl);
 
 		/*
 		 * if we have nothing left, mark the last segment as
diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index df7ddce..c1ef145 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -147,12 +147,11 @@ static inline struct scatterlist *sg_last(struct scatterlist *sgl,
 /**
  * sg_chain - Chain two sglists together
  * @prv:	First scatterlist
- * @prv_nents:	Number of entries in prv
+ * @prv_nents:	Number of entries used in prv
  * @sgl:	Second scatterlist
  *
  * Description:
- *   Links @prv@ and @sgl@ together, to form a longer scatterlist.
- *
+ *   @prv[@prv_nents] is used as a link to join @prv to @sgl.
  **/
 static inline void sg_chain(struct scatterlist *prv, unsigned int prv_nents,
 			    struct scatterlist *sgl)
@@ -160,7 +159,9 @@ static inline void sg_chain(struct scatterlist *prv, unsigned int prv_nents,
 #ifndef ARCH_HAS_SG_CHAIN
 	BUG();
 #endif
-	prv[prv_nents - 1].page_link = (unsigned long) sgl | 0x01;
+	if (prv_nents > 0)
+		prv[prv_nents - 1].page_link &= ~0x02UL;
+	prv[prv_nents].page_link = (unsigned long) sgl | 0x01;
 }
 
 /**
