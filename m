Return-Path: <linux-kernel-owner+w=401wt.eu-S1755943AbXJQR6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbXJQR6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 13:58:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752256AbXJQR54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 13:57:56 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41210 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752134AbXJQR54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 13:57:56 -0400
Date: Wed, 17 Oct 2007 10:56:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [bug] block subsystem related crash with latest -git
In-Reply-To: <20071017172932.GI15552@kernel.dk>
Message-ID: <alpine.LFD.0.999.0710171053180.26902@woody.linux-foundation.org>
References: <20071017154655.GA13394@elte.hu>
 <alpine.LFD.0.999.0710170929270.26902@woody.linux-foundation.org>
 <20071017165949.GF15552@kernel.dk> <20071017170804.GG15552@kernel.dk>
 <20071017172158.GH15552@kernel.dk> <20071017172932.GI15552@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Oct 2007, Jens Axboe wrote:
> 
> OK, it is fine, as long as the sglist is cleared initially. And I don't
> think there's anyway around that, clearly I didn't think long enough
> before including the memset() removal from Tomo.

Ok, I think that one-liner fixes the real bug.

But I think the rest of your changes are simply bad.

The fix to block/ll_rw_block.c should likely be something like the 
appended instead:

 - remove the "memset()" you had added earlier. It's bogus. It cannot be 
   the right thing. If the sg list wasn't initialized correctly much 
   earlier, trying to initialize it late is pointless - it contains crap.

 - the old code was fine, but let's initialize "sg" to NULL to make it 
   clear that the initial value of sg is pointless, and only "next_sg" 
   matters (since sg had better be assigned from that).

Hmm?

		Linus

---
diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 9e3f3cc..54d974e 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -1333,7 +1333,8 @@ int blk_rq_map_sg(struct request_queue *q, struct request *rq,
 	 * for each bio in rq
 	 */
 	bvprv = NULL;
-	sg = next_sg = &sglist[0];
+	sg = NULL;
+	next_sg = &sglist[0];
 	rq_for_each_segment(bvec, rq, iter) {
 		int nbytes = bvec->bv_len;
 
@@ -1352,7 +1353,6 @@ new_segment:
 			sg = next_sg;
 			next_sg = sg_next(sg);
 
-			memset(sg, 0, sizeof(*sg));
 			sg->page = bvec->bv_page;
 			sg->length = nbytes;
 			sg->offset = bvec->bv_offset;
