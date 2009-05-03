Return-Path: <linux-kernel-owner+w=401wt.eu-S1755710AbZECSfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710AbZECSfM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 14:35:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbZECSe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 14:34:56 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:32949 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183AbZECSez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 14:34:55 -0400
Message-ID: <49FDE3BB.505@garzik.org>
Date: Sun, 03 May 2009 14:34:35 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: Matthew Wilcox <matthew@wil.cx>, Hugh Dickins <hugh@veritas.com>,
       Matthew Wilcox <willy@linux.intel.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>,
       linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Mark Lord <lkml@rtr.ca>
Subject: Re: New TRIM/UNMAP tree published (2009-05-02)
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com> <49D8A3D7.5070507@panasas.com> <20090503061150.GF10704@linux.intel.com> <20090503071619.GP8822@parisc-linux.org> <Pine.LNX.4.64.0905031346350.29671@blonde.anvils> <20090503144847.GR8822@parisc-linux.org> <49FDB21B.3080301@panasas.com> <20090503154216.GU8822@parisc-linux.org> <49FDC786.6070309@panasas.com>
In-Reply-To: <49FDC786.6070309@panasas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh wrote:
> On 05/03/2009 06:42 PM, Matthew Wilcox wrote:
>> On Sun, May 03, 2009 at 06:02:51PM +0300, Boaz Harrosh wrote:
>>> I agree with Hugh. The allocation is done at, too-low in the food chain.
>>> (And that free of buffer at upper layer allocated by lower layer).
>>>
>>> I think you need to separate the: "does lld need buffer, what size"
>>> from the "here is buffer prepare", so upper layer that can sleep does
>>> sleep.
>> So you want two function pointers in the request queue relating to discard?
>>
> 
> OK I don't know what I want, I guess. ;-)
> 
> I'm not a block-device export but from the small osdblk device I maintain
> it looks like osdblk_prepare_flush which is set into:
>     blk_queue_ordered(q, QUEUE_ORDERED_DRAIN_FLUSH, osdblk_prepare_flush);
> 
> does some internal structure setup, but the actual flush command is only executed
> later in the global osdblk_rq_fn which is set into:
>     blk_init_queue(osdblk_rq_fn, &osdev->lock);
> 
> But I'm not even sure that prepare_flush is called in a better context then
> queue_fn, and what does it means to let block devices take care of another
> new command type at queue_fn.
> 
> I guess it comes back to Jeff Garzik's comment about not having a central
> place to ask the request what we need to do.
> 
> But I do hate that allocation is done by driver and free by mid-layer,
> so yes two vectors, request_queue is allocated once per device it's not
> that bad. And later when Jeff's comment is addressed it can be removed.

May I presume you are referring to the following osdblk.c comment?

                 /* deduce our operation (read, write, flush) */
                 /* I wish the block layer simplified
		 * cmd_type/cmd_flags/cmd[]
                  * into a clearly defined set of RPC commands:
                  * read, write, flush, scsi command, power mgmt req,
                  * driver-specific, etc.
                  */

Yes, the task of figuring out -what to do- in the queue's request 
function is quite complex, and discard makes it even more so.

The API makes life difficult -- you have to pass temporary info to 
yourself in ->prepare_flush_fn() and ->prepare_discard_fn(), and the 
overall sum is a bewildering collection of opcodes, flags, and internal 
driver notes to itself.

Add to this yet another prep function, ->prep_rq_fn()

It definitely sucks, especially with regards to failed atomic 
allocations...   but I think fixing this quite a big more than Matthew 
probably willing to tackle ;-)

My ideal block layer interface would be a lot more opcode-based, e.g.

(1) create REQ_TYPE_DISCARD

(2) determine at init if queue (a) supports explicit DISCARD and/or (b) 
supports DISCARD flag passed with READ or WRITE

(3) when creating a discard request, use block helpers w/ queue-specific 
knowledge to create either
	(a) one request, REQ_TYPE_FS, with discard flag or
	(b) two requests, REQ_TYPE_FS followed by REQ_TYPE_DISCARD

(4) blkdev_issue_discard() would function like an empty barrier, and 
unconditionally create REQ_TYPE_DISCARD.


This type of setup would require NO prepare_discard command, as all 
knowledge would be passed directly to ->prep_rq_fn() and ->request_fn()


And to tangent a bit...  I feel barriers should be handled in exactly 
the same way.  Create REQ_TYPE_FLUSH, which would be issued for above 
examples #2a and #4, if the queue is setup that way.

All this MINIMIZES the amount of information a driver must "pass to 
itself", by utilizing existing ->prep_fn_rq() and ->request_fn() pathways.

	Jeff



