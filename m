Return-Path: <linux-kernel-owner+w=401wt.eu-S1753217AbYEEECv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbYEEECv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 00:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750857AbYEEECk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 00:02:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbYEEECj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 00:02:39 -0400
Date: Mon, 5 May 2008 00:01:01 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
cc: Mike Anderson <andmike@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Alasdair Graeme Kergon <agk@redhat.com>
Subject: Re: [PATCH] Optimize lock in queue unplugging
In-Reply-To: <20080504191132.GQ12774@kernel.dk>
Message-ID: <Pine.LNX.4.64.0805042335440.5512@engineering.redhat.com>
References: <Pine.LNX.4.64.0804291459030.17110@engineering.redhat.com>
 <20080429192556.GB12774@kernel.dk> <20080429202928.GB10641@linux.vnet.ibm.com>
 <20080430071415.GM12774@kernel.dk> <Pine.LNX.4.64.0804300944440.23408@engineering.redhat.com>
 <20080504191132.GQ12774@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> So it's basically dm calling into blk_unplug() all the time, which
>>> doesn't check if the queue is plugged. The reason why I didn't like the
>>> initial patch is that ->unplug_fn() really should not be called unless
>>> the queue IS plugged. So how about this instead:
>>>
>>> http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=c44993018887e82abd49023e92e8d8b6000e03ed
>>>
>>> That's a lot more appropriate, imho.
>>>
>>> --
>>> Jens Axboe
>>
>> This doesn't seem correct to me. The difference between blk_unplug and
>> generic_unplug_device is that blk_unplug is called on every type of device
>> and generic_unplug_device (pointed to by q->unplug_fn) is a method that is
>> called on low-level disk devices.
>>
>> dm and md redefine q->unplug_fn to point to their own method. On dm and
>> md, blk_unplug is called, but generic_unplug_device is not.
>>
>> So if you have this setup
>> dm-linear(unplugged) -> disk(plugged)
>>
>> then, with your patch, a call to blk_unplug(dm-linear) will not unplug the
>> disk. With my patch, a call to blk_unplug(dm-linear) will unplug the disk
>> --- it calls q->unplug_fn that points to dm_unplug_all, that calls
>> blk_unplug again on the disk and that calls generic_unplug_device on disk
>> queue.
>
> That is because the md/dm don't set the plugged flag which I think they
> should. So we fix that instead so that plugging works the same from the
> block core or from a driver instead of adding work-arounds in the block
> unplug handler.

When should dm/md set the plugged flag? It has several disks (or more 
dm/md layers), some of them may be plugged, some not --- furthermore, the 
disk queues are shared by other devices --- there may be more devices on 
different partitions.

So the question: when do you want dm/md to set the plugged bit? Do you 
really want to plug the queue at the top layer and merge requests there?

> Adding a check for plugged in the plug handler is a
> hack, I don't see how you can argue against that.

I changed generic_unplug_device from:
spin_lock()
if (plugged bit is set) unplug...;
spin_unlock()

to:
if (plugged bit is set)
{
spin_lock()
if (plugged bit is set) unplug...;
spin_unlock()
}

--- I don't see anything wrong with it. At least, the change is so trivial 
that we can be sure that it won't have negative effect on performance.

What you propose is complete rewrite of dm/md plugging mechanism to plug 
the queue and merge requests at upper layer --- the questions are:

- what exactly you are proposing? (plugging at upper layer? lower layer? 
both layers? don't plug and just somehow propagate the plugged bit?)
- why are you proposing that?

Note that for some dm targets it would be benefical to join the requests 
at upper layer (dm-linear, raid1), for others (raid0, dm-snapshots) it 
damages performance (you merge the requests before passing them to raid0 
and you chop them again to smaller pieces in raid0).

Mikulas

> -- 
> Jens Axboe
>
