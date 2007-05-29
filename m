Return-Path: <linux-kernel-owner+w=401wt.eu-S1753412AbXE2Mfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412AbXE2Mfu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 08:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbXE2Mfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 08:35:43 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:47264 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbXE2Mfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 08:35:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ib5p1L/yIkbqdiUwcevlTM1z+dnx4u0cfoRfh/qqEJN956YV4803/tYE/fP4P3iFdlBPhYL5gbfswo29t5Io6VWfJKPRjvaTjafZHD9mN+Frw32HDwOrC1DGNGbZOfYx5spJrXySwR5EsFwd2JACC3n6nF5QnFrgJCiSPYDTx0E=
Message-ID: <465C1DD1.8060201@gmail.com>
Date: Tue, 29 May 2007 14:34:25 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
CC: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Block devices and barriers
References: <Pine.LNX.4.62.0705211434150.8776@pademelon.sonytel.be> <18011.43887.825594.407340@notabene.brown>
In-Reply-To: <18011.43887.825594.407340@notabene.brown>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Neil Brown wrote:
>> but I can't find a way to actually trigger the calling of ps3disk_issue_flush()
>> and ps3disk_prepare_flush().
>>
>>  1. My prepare_flush_fn() routine should be called from queue_flush(), which is
>>     in turn called by start_ordered().
>>     start_ordered() is called by blk_do_ordered(), but only if there's no
>>     barrier (REQ_HARDBARRIER is not set).
>>     Apart from drivers/block/pktcdvd.c and init_request_from_bio()
>>     (BIO_RW_BARRIER is set by drivers/md/md.c only?), the only other way
>>     REQ_HARDBARRIER can be set is in queue_flush(), which is not possible.
> 
> BIO_RW_BARRIER is set by various filesystems when mounted with
>   -o barrier 
> or
>   -o barrier=1 (ext3)
> 
> See calls to set_buffer_ordered in fs/jbd/commit.c

You driver first needs to call blk_queue_ordered() to set ordered mode
(probably QUEUE_ORDERED_DRAIN_FLUSH) and the filesystem needs to be
mounted with barrier enabled as Neil explained.  Then, the FS will issue
barriers and the block layer will interpret them as draining + cache flush.

>>   2. My issue_flush_fn() should be called from blkdev_issue_flush() (ignoring
>>      drivers/md). But blkdev_issue_flush() is called by ReiserFS and XFS only.
> 
> Yeh, it isn't widely used at the moment.

I thought about re-implementing it in terms of barrier callbacks but
wasn't sure whether it would be better than completely removing
blkdev_issue_flush() && a bit lazy. :-)

I'll look into it.

>> I read the Block Device chapter in Linux Device Drivers 3rd edition, which says
>> to check blk_barrier_rq(), but the barrier part seems to be obsolete, as we now
>> have the prepare_flush_fn parameter of blk_queue_ordered().
>>
>> Am I missing something? Should I care about barriers?
> 
> Yes, you should care about barriers, though it is true that there is
> some confusion around them and it might be difficult.

Yeap, basically a block driver needs two callbacks - issue_flush and
prepare_flush plus a call to blk_queue_ordered().

>> BTW, Documentation/block/barrier.txt seems to be out-of-date. Patch to update
>> it is below.
> 
> You might like to post this directly to
>   Tejun Heo <htejun@gmail.com>

Received, acked && forwarded to Jens.

Thanks.

-- 
tejun
