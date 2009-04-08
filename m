Return-Path: <linux-kernel-owner+w=401wt.eu-S1762098AbZDHGCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762098AbZDHGCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 02:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758040AbZDHGCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 02:02:38 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:57478 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061AbZDHGCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 02:02:37 -0400
Message-ID: <49DC3DF6.6090903@garzik.org>
Date: Wed, 08 Apr 2009 02:02:30 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Boaz Harrosh <bharrosh@panasas.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] osdblk: a Linux block device for OSD objects
References: <20090402015455.GA14087@havoc.gtf.org> <20090403094909.GQ5178@kernel.dk> <49D5DDDE.9090407@garzik.org> <49D8856E.3090903@panasas.com> <49DBFDE1.9010303@garzik.org> <20090408054537.GI5178@kernel.dk>
In-Reply-To: <20090408054537.GI5178@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Tue, Apr 07 2009, Jeff Garzik wrote:
>> Boaz Harrosh wrote:
>>> On 04/03/2009 12:58 PM, Jeff Garzik wrote:
>>>> Jens Axboe wrote:
>>>>> This wont work, GFP_NOIO inside the queue lock. You are also only
>>>>> cloning the front bio, what happens if you have > 1 bio on the request?
>>>>> You seem to dequeue the request and complete all of it, regardless of
>>>>> whether bio->bi_size == blk_rq_bytes(rq). I'm assuming you have to clone
>>>>> because of how the osd_req_{read,write} works, so I'd suggest storing
>>>>> the byte size in your osdblk_request and only completing that in
>>>>> osdblk_end_request(). Then do a rq_for_each_bio() look in there, and
>>>>> only dequeue if you manage to start an osd request for each of them,
>>>>> THEN moving on to the next request.
>>> There is nothing preventing from issuing a linked bio list. The only thing
>>> is that osd_read/write looks at the first bio for total size.
>>> If the first bio->bi_size does not specify the full length of the chain
>>> then we should add another parameter to osd_read/write for that.
>>>
>>> The original idea was to specifically allow chained bios.
>>>
>>> Please advise?
>> As passed to us from the block layer, there is nothing special about the  
>> size of the first bio, AFAIK.
>>
>> This seems like a libosd bug?  If you want to support chained bio's, I  
>> would presume you would either walk the list and sum all sizes, or in  
>> some other way input the total request size?
> 
> Completely agree, if you want to support passing in a chain, you better
> make the first bio just part of the chain (not some header bio).
> 
> And Jeff, you still have that bio_clone() bug in your v2 posting.

Yep, that was noted in the patch description as "The major remaining 
pre-merge FIXME" :)

	Jeff


