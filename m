Return-Path: <linux-kernel-owner+w=401wt.eu-S1764973AbXJRNvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764973AbXJRNvd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 09:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761772AbXJRNvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 09:51:11 -0400
Received: from rtr.ca ([76.10.145.34]:1086 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757635AbXJRNvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 09:51:09 -0400
Message-ID: <471764CB.5020906@rtr.ca>
Date: Thu, 18 Oct 2007 09:51:07 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
Cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       alan@lxorguk.ukuu.org.uk, tomof@acm.org
Subject: Re: [bug] ata subsystem related crash with latest -git
References: <20071018082145.GK5063@kernel.dk> <20071018.045505.106265100.davem@davemloft.net> <20071018115702.GW5063@kernel.dk> <20071018.050554.115911163.davem@davemloft.net> <20071018120950.GX5063@kernel.dk> <20071018121547.GY5063@kernel.dk> <20071018125840.GF5063@kernel.dk> <20071018133200.GH5063@kernel.dk>
In-Reply-To: <20071018133200.GH5063@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens wrote:
> OK, I think that covers every arch out there. I haven't been able to
> compile any of them, but it's mostly search'n replace operations. I hope
> nothing is missing linux/scatterlist.h includes...

Patch fails on drivers/scsi/scsi_lib.c.

I replaced that part of the patch with this updated portion instead:



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
