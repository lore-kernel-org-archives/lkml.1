Return-Path: <linux-kernel-owner+w=401wt.eu-S1754128AbZFDTAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbZFDTAv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 15:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbZFDTAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 15:00:44 -0400
Received: from adelie.canonical.com ([91.189.90.139]:58568 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbZFDTAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 15:00:44 -0400
Message-ID: <4A2819DA.7040603@canonical.com>
Date: Thu, 04 Jun 2009 21:00:42 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Pierre Ossman <pierre@ossman.eu>
CC: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH] mmc: prevent dangling block device from accessing stale
 queues
References: <4A280BD4.9080908@canonical.com> <20090604202900.57f31d6a@mjolnir.ossman.eu>
In-Reply-To: <20090604202900.57f31d6a@mjolnir.ossman.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> On Thu, 04 Jun 2009 20:00:52 +0200
> Stefan Bader <stefan.bader@canonical.com> wrote:
> 
>> Kernel: 2.6.30-rc7 based
>> Worked in 2.6.28 (probably only because things went at a different speed)
>>
>> Testcase: Use ext3/ext4 on a SD card partitioned with one primary DOS partition 
>> and leave it mounted while suspend/resume.
>>
>> Result: After resume the partition table of the SD card has been erased.
>>
>> The detailed description can be found at:
>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/383668
>>
>> In essence the mmc block device frees the generic request queue before the last 
>> user of the gendisk has stopped using it leaving an invalid queue pointer which 
>> get unfortunately re-used before more requests come in for the old device.
>>
>> The bugfix will cause more I/O error messages and might not be the ultimate way 
>> things should work, but it prevents data from getting lost.
>>
> 
> You seem to have dug a bit further than I've had time for. Do you have
> anything substantial to back this up:
> 
>> +	/*
>> +	 * Calling blk_cleanup_queue() would be too soon here. As long as
>> +	 * the gendisk has a reference to it and is not released we should
>> +	 * keep the queue. It has been shutdown and will not accept any new
>> +	 * requests, so that should be safe.
>> +	 */
> 

This is mostly based on the debug output. But it seems hard to get around of it 
without having a way to increment the refcount of the queue. It is probably not 
the most common use case to remove a device while it is mounted.
Hm, not sure this is what you wanted to know... On the launchpad report there 
are logs which I took with lots of printk's enabled. This shows that after 
resume the queue receives a request from mmcblk0 (which no longer exists) but 
uses the same pointer as mmcblk1 which was just created.

> 
> It would seem that gendisk is making some bad assumptions and needs to
> be changed if that is the case.

I think the setup and release of it would need to have access to blk_queue_get 
and blk_queue_put. When it is created and the queue pointer is stored it should 
take a reference and when the object is finally released, reference to the 
queue would get dropped.

> This part from the launchpad report also seems incredibly broken:
> 
>> What makes the whole thing a disaster is the fact that the block device queue objects are taken from a slub cache. Which means on resume, the newly created block device will get the same queue object as the old one, initializes it and
>> after the tasks have been resumed, ext3 feels obliged to write out the invalidated superblocks (still not sure why it goes for sector 0) which will happily migrate to the new block device and cause confusion.

I don't think that part is that much broken. It is more a unfortunate result of 
the previous events. Maybe the part of ext3 writing to sector 0 is a bit 
worrying as I would only expect it to update the mount information which I hink 
is somewhere around sector 10.

> Jens, comments?
> 
> Rgds


-- 

When all other means of communication fail, try words!


