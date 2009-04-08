Return-Path: <linux-kernel-owner+w=401wt.eu-S1759638AbZDHB32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759638AbZDHB32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 21:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757712AbZDHB3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 21:29:14 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:45547 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756282AbZDHB3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 21:29:13 -0400
Message-ID: <49DBFDE1.9010303@garzik.org>
Date: Tue, 07 Apr 2009 21:29:05 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] osdblk: a Linux block device for OSD objects
References: <20090402015455.GA14087@havoc.gtf.org> <20090403094909.GQ5178@kernel.dk> <49D5DDDE.9090407@garzik.org> <49D8856E.3090903@panasas.com>
In-Reply-To: <49D8856E.3090903@panasas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh wrote:
> On 04/03/2009 12:58 PM, Jeff Garzik wrote:
>> Jens Axboe wrote:
>>> This wont work, GFP_NOIO inside the queue lock. You are also only
>>> cloning the front bio, what happens if you have > 1 bio on the request?
>>> You seem to dequeue the request and complete all of it, regardless of
>>> whether bio->bi_size == blk_rq_bytes(rq). I'm assuming you have to clone
>>> because of how the osd_req_{read,write} works, so I'd suggest storing
>>> the byte size in your osdblk_request and only completing that in
>>> osdblk_end_request(). Then do a rq_for_each_bio() look in there, and
>>> only dequeue if you manage to start an osd request for each of them,
>>> THEN moving on to the next request.
> 
> There is nothing preventing from issuing a linked bio list. The only thing
> is that osd_read/write looks at the first bio for total size.
> If the first bio->bi_size does not specify the full length of the chain
> then we should add another parameter to osd_read/write for that.
> 
> The original idea was to specifically allow chained bios.
> 
> Please advise?

As passed to us from the block layer, there is nothing special about the 
size of the first bio, AFAIK.

This seems like a libosd bug?  If you want to support chained bio's, I 
would presume you would either walk the list and sum all sizes, or in 
some other way input the total request size?

	Jeff



