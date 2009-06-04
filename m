Return-Path: <linux-kernel-owner+w=401wt.eu-S1753198AbZFDTh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbZFDTh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 15:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbZFDThS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 15:37:18 -0400
Received: from adelie.canonical.com ([91.189.90.139]:37640 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbZFDThR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 15:37:17 -0400
Message-ID: <4A28226F.1040307@canonical.com>
Date: Thu, 04 Jun 2009 21:37:19 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Pierre Ossman <pierre@ossman.eu>
CC: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH] mmc: prevent dangling block device from accessing stale
 queues
References: <4A280BD4.9080908@canonical.com>	<20090604202900.57f31d6a@mjolnir.ossman.eu>	<4A2819DA.7040603@canonical.com> <20090604212103.33570174@mjolnir.ossman.eu>
In-Reply-To: <20090604212103.33570174@mjolnir.ossman.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> On Thu, 04 Jun 2009 21:00:42 +0200
> Stefan Bader <stefan.bader@canonical.com> wrote:
> 
>> Pierre Ossman wrote:
>>> You seem to have dug a bit further than I've had time for. Do you have
>>> anything substantial to back this up:
>>>
>>>> +	/*
>>>> +	 * Calling blk_cleanup_queue() would be too soon here. As long as
>>>> +	 * the gendisk has a reference to it and is not released we should
>>>> +	 * keep the queue. It has been shutdown and will not accept any new
>>>> +	 * requests, so that should be safe.
>>>> +	 */
>> This is mostly based on the debug output. But it seems hard to get around of it 
>> without having a way to increment the refcount of the queue. It is probably not 
>> the most common use case to remove a device while it is mounted.
>> Hm, not sure this is what you wanted to know... On the launchpad report there 
>> are logs which I took with lots of printk's enabled. This shows that after 
>> resume the queue receives a request from mmcblk0 (which no longer exists) but 
>> uses the same pointer as mmcblk1 which was just created.
>>
> 
> I was hoping you had dug around in the block layer and had some idea
> why gendisk requires someone else to keep the queue around for it. Is
> it just a simple case of a missing reference, or is there some
> architectural problem?
> 

You could say architectural. The get a queue object and the pointer to that 
gets stored in the gendisk object. This is used in generic make request to get 
the queue for a bdev. The reference to the bdev (this is a bit guessing) is 
kept by the filesystem.
The mmc block device will release the disk reference not before the last user 
is gone (again the fs). Another approach would have been to set the queue 
pointer to NULL after the queue has been released. But there is no locking 
around getting the pointer, so that seemed dangerous as well.

>>> This part from the launchpad report also seems incredibly broken:
>>>
>>>> What makes the whole thing a disaster is the fact that the block device queue objects are taken from a slub cache. Which means on resume, the newly created block device will get the same queue object as the old one, initializes it and
>>>> after the tasks have been resumed, ext3 feels obliged to write out the invalidated superblocks (still not sure why it goes for sector 0) which will happily migrate to the new block device and cause confusion.
>> I don't think that part is that much broken. It is more a unfortunate result of 
>> the previous events. Maybe the part of ext3 writing to sector 0 is a bit 
>> worrying as I would only expect it to update the mount information which I hink 
>> is somewhere around sector 10.
>>
> 
> The incredibly broken part is how requests for the old queue wind up on
> the new queue. Such a thing should never be possible.
>

That is only possible as the queue object s created from a cache. The old queue 
has been released and the new on re-uses that storage. This would be ok, but 
now pointer in the old gendisk is in fact crosspointing.

I think (but I have not debugged much into that direction) that I saw bad 
pointer dereferences on just ejecting the mounted sd card. Which probably was 
caused by the same issue. Just in that case the pointer is invalid and no new 
device has been created to be hit.


> Rgds


-- 

When all other means of communication fail, try words!


