Return-Path: <linux-kernel-owner+w=401wt.eu-S1765877AbXJROAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765877AbXJROAJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 10:00:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762529AbXJRN7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 09:59:55 -0400
Received: from rtr.ca ([76.10.145.34]:1111 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762439AbXJRN7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 09:59:54 -0400
Message-ID: <471766D7.3030800@rtr.ca>
Date: Thu, 18 Oct 2007 09:59:51 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, fujita.tomonori@lab.ntt.co.jp,
       mingo@elte.hu, linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       tomof@acm.org
Subject: Re: [bug] ata subsystem related crash with latest -git
References: <alpine.LFD.0.999.0710171834001.26902@woody.linux-foundation.org> <4716D6B1.8010309@rtr.ca> <alpine.LFD.0.999.0710172100420.26902@woody.linux-foundation.org> <4716DB9A.2060809@rtr.ca> <4716DE82.2050006@rtr.ca> <4716E19F.1090201@garzik.org> <20071018070538.GD5063@kernel.dk> <47175C0A.5020907@rtr.ca> <20071018132351.GG5063@kernel.dk> <47176062.5020105@rtr.ca> <20071018133401.GI5063@kernel.dk>
In-Reply-To: <20071018133401.GI5063@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Thu, Oct 18 2007, Mark Lord wrote:
>> Jens Axboe wrote:
>>> On Thu, Oct 18 2007, Mark Lord wrote:
>>>> Jens Axboe wrote:
>>>>> On Thu, Oct 18 2007, Jeff Garzik wrote:
>>>>>> Mark Lord wrote:
>>>>>>> Okay, mine is dying with EIP at blk_rq_map_sg+0xcb/0x160.
>>>>>>> Screen photo is at http://rtr.ca/recent/2.6.23-git12-crash.jpg,
>>>>>>> but the top was cut off (isn't there a new config option or patch
>>>>>>> to do double-columns or scrollback or something ???.
>>>>>> Is this a sata_mv box?  If so, could you try this patch?
>>>>> If anything, that shrinks the size of the resulting request. Did this
>>>>> patch make any difference to you?
>>>> Not a sata_mv box, so no point here.
>>> Can you try the big patch I just posted?
>> I'll hunt for it and try it, but your earlier little patch already works 
>> fine.

I found the latest rev, and it failed to apply cleanly on -git12 or -git13
due to scsi_lib.c. After fixing that portion (replacement chunk below),
I'm now running with -git12, with the sg list debug option enabled (no messages).

Looks okay so far

 
--- a/drivers/scsi/scsi_lib.c	2007-10-18 09:35:28.000000000 -0400
+++ b/drivers/scsi/scsi_lib.c	2007-10-18 09:46:47.000000000 -0400
@@ -295,7 +295,7 @@
 	int i, err, nr_vecs = 0;
 
 	for_each_sg(sgl, sg, nsegs, i) {
-		page = sg->page;
+		page = sg_page(sg);
 		off = sg->offset;
 		len = sg->length;
  		data_len += len;
@@ -764,6 +764,8 @@
 		if (unlikely(!sgl))
 			goto enomem;
 
+		sg_init_table(sgl, sgp->size);
+
 		/*
 		 * first loop through, set initial index and return value
 		 */
@@ -779,6 +781,13 @@
 			sg_chain(prev, SCSI_MAX_SG_SEGMENTS, sgl);
 
 		/*
+		 * if we have nothing left, mark the last segment as
+		 * end-of-list
+		 */
+		if (!left)
+			sg_mark_end(sgl, this);
+
+		/*
 		 * don't allow subsequent mempool allocs to sleep, it would
 		 * violate the mempool principle.
 		 */
@@ -2351,7 +2360,7 @@
 	*offset = *offset - len_complete + sg->offset;
 
 	/* Assumption: contiguous pages can be accessed as "page + i" */
-	page = nth_page(sg->page, (*offset >> PAGE_SHIFT));
+	page = nth_page(sg_page(sg), (*offset >> PAGE_SHIFT));
 	*offset &= ~PAGE_MASK;
 
 	/* Bytes in this sg-entry from *offset to the end of the page */
