Return-Path: <linux-kernel-owner+w=401wt.eu-S1755458AbXJRFeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbXJRFeo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 01:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751976AbXJRFea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 01:34:30 -0400
Received: from rtr.ca ([76.10.145.34]:4649 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758026AbXJRFe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 01:34:28 -0400
Message-ID: <4716F061.50103@rtr.ca>
Date: Thu, 18 Oct 2007 01:34:25 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, fujita.tomonori@lab.ntt.co.jp,
       jens.axboe@oracle.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com, alan@lxorguk.ukuu.org.uk, tomof@acm.org
Subject: Re: [bug] ata subsystem related crash with latest -git
References: <alpine.LFD.0.999.0710171342550.26902@woody.linux-foundation.org> <20071018080048O.fujita.tomonori@lab.ntt.co.jp> <alpine.LFD.0.999.0710171801000.26902@woody.linux-foundation.org> <20071017.181907.63126798.davem@davemloft.net> <alpine.LFD.0.999.0710171834001.26902@woody.linux-foundation.org> <4716D6B1.8010309@rtr.ca> <alpine.LFD.0.999.0710172100420.26902@woody.linux-foundation.org> <4716EE37.9010701@rtr.ca>
In-Reply-To: <4716EE37.9010701@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Linus Torvalds wrote:
>>
>> On Wed, 17 Oct 2007, Mark Lord wrote:
>>> It would be good to have something soon-ish.
>>> This "dead at boot time" issue is impacting the general ability to test
>>> patches against latest -git in time for the current merge window.
>>
>> In the meantime, does the patch I sent out help people?
> 
> Your patch from this posting http://lkml.org/lkml/2007/10/17/285
> does not seem to make much difference here.
> 
> It still crashes at exactly the same place.


However, Jens's patch from that same thread:

     http://lkml.org/lkml/2007/10/17/269

..allowed me to boot and post this followup message from -git12

Jeff: try that one.

Patch reproduced here for convenience:

Jens Axboe wrote:
> OK, it is fine, as long as the sglist is cleared initially. And I don't
> think there's anyway around that, clearly I didn't think long enough
> before including the memset() removal from Tomo.
> 
> Ingo, please try this rolled up version.
> 
> Linus, this should work. It would probably be best if you first did a
> git revert on f5c0dde4c66421a3a2d7d6fa604a712c9b0744e5 and then applied
> the ll_rw_blk.c bit alone. Do you want me to stuff that (revert + patch)
> into a branch for you to pull?

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 9e3f3cc..3935469 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -1322,8 +1322,8 @@ int blk_rq_map_sg(struct request_queue *q, struct request *rq,
 		  struct scatterlist *sglist)
 {
 	struct bio_vec *bvec, *bvprv;
-	struct scatterlist *next_sg, *sg;
 	struct req_iterator iter;
+	struct scatterlist *sg;
 	int nsegs, cluster;
 
 	nsegs = 0;
@@ -1333,7 +1333,7 @@ int blk_rq_map_sg(struct request_queue *q, struct request *rq,
 	 * for each bio in rq
 	 */
 	bvprv = NULL;
-	sg = next_sg = &sglist[0];
+	sg = NULL;
 	rq_for_each_segment(bvec, rq, iter) {
 		int nbytes = bvec->bv_len;
 
@@ -1349,8 +1349,10 @@ int blk_rq_map_sg(struct request_queue *q, struct request *rq,
 			sg->length += nbytes;
 		} else {
 new_segment:
-			sg = next_sg;
-			next_sg = sg_next(sg);
+			if (!sg)
+				sg = sglist;
+			else
+				sg = sg_next(sg);
 
 			memset(sg, 0, sizeof(*sg));
 			sg->page = bvec->bv_page;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0c86be7..aac8a02 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -764,6 +764,8 @@ struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 		if (unlikely(!sgl))
 			goto enomem;
 
+		memset(sgl, 0, sizeof(*sgl) * sgp->size);
+
 		/*
 		 * first loop through, set initial index and return value
 		 */

