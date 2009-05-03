Return-Path: <linux-kernel-owner+w=401wt.eu-S1756684AbZECPEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684AbZECPEW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 11:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753991AbZECPEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 11:04:06 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:16101 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753878AbZECPEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 11:04:04 -0400
Message-ID: <49FDB21B.3080301@panasas.com>
Date: Sun, 03 May 2009 18:02:51 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Hugh Dickins <hugh@veritas.com>, Matthew Wilcox <willy@linux.intel.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jeff Garzik <jgarzik@redhat.com>, linux-scsi@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Mark Lord <lkml@rtr.ca>
Subject: Re: New TRIM/UNMAP tree published (2009-05-02)
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com> <49D8A3D7.5070507@panasas.com> <20090503061150.GF10704@linux.intel.com> <20090503071619.GP8822@parisc-linux.org> <Pine.LNX.4.64.0905031346350.29671@blonde.anvils> <20090503144847.GR8822@parisc-linux.org>
In-Reply-To: <20090503144847.GR8822@parisc-linux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 May 2009 15:03:07.0105 (UTC) FILETIME=[4414CD10:01C9CC00]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2009 05:48 PM, Matthew Wilcox wrote:
> On Sun, May 03, 2009 at 02:07:32PM +0100, Hugh Dickins wrote:
>> I notice OCZ hope to have updated Vertex firmware mid-May,
>> such that their TRIM support matches up with (y)ours.
> 
> Excellent.
> 
>> You have GFP_KERNEL allocations in your discard_fn()s.  I believe that
>> allocations down at that level will need to be GFP_NOIO - the bio mempool
>> might be empty by this point, you don't want memory allocation to get into
>> submitting even more I/O to satisfy your discard_fn().  Does it need its
>> own mempool of reserve pages?  My guess is that you can get away without
>> that, since a failed discard, though regrettable, loses no data.
> 
> You make a good point.  There's definitely still work to be done around
> error handling.  OTOH, we could always do what IDE does ...
> 
> static void idedisk_prepare_flush(struct request_queue *q, struct request *rq)
> {
>         ide_drive_t *drive = q->queuedata;
>         struct ide_cmd *cmd = kmalloc(sizeof(*cmd), GFP_ATOMIC);
> 
>         /* FIXME: map struct ide_taskfile on rq->cmd[] */
>         BUG_ON(cmd == NULL);
> 
> 
> 

Out from the frying pan and into the fire. ;-)

I agree with Hugh. The allocation is done at, too-low in the food chain.
(And that free of buffer at upper layer allocated by lower layer).

I think you need to separate the: "does lld need buffer, what size"
from the "here is buffer prepare", so upper layer that can sleep does
sleep.

In all other buffer needing operations the allocation is done before
submission of request, No?

Just my $0.017
Thanks
Boaz

BTW:
 I've not have time to review second round will "TODO"
