Return-Path: <linux-kernel-owner+w=401wt.eu-S1756683AbXH2Rg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683AbXH2Rg5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 13:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbXH2Rgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 13:36:50 -0400
Received: from mail.tmr.com ([64.65.253.246]:35680 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbXH2Rgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 13:36:50 -0400
Message-ID: <46D5AEAD.50909@tmr.com>
Date: Wed, 29 Aug 2007 13:36:45 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Theodore Tso <tytso@mit.edu>, Jan Engelhardt <jengelh@computergmbh.de>,
       Richard Ballantyne <richardballantyne@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: file system for solid state disks
References: <46CD14A6.4050605@gmail.com> <Pine.LNX.4.64.0708230746140.12788@fbirervta.pbzchgretzou.qr> <20070823102630.GH7267@thunk.org> <20070823112507.GL23758@kernel.dk>
In-Reply-To: <20070823112507.GL23758@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Thu, Aug 23 2007, Theodore Tso wrote:
>> On Thu, Aug 23, 2007 at 07:52:46AM +0200, Jan Engelhardt wrote:
>>> On Aug 23 2007 01:01, Richard Ballantyne wrote:
>>>> What file system that is already in the linux kernel do people recommend
>>>> I use for my laptop that now contains a solid state disk?
>>> If I had to choose, the list of options seems to be:
>>>
>>> - logfs
>>>   [unmerged]
>>>
>>> - UBI layer with any fs you like
>>>   [just a guess]
>> The question is whether the solid state disk gives you access to the
>> raw flash, or whether you have to go through the flash translation
>> layer because it's trying to look (exclusively) like a PATA or SATA
>> drive.  There are some SSD's that have a form factor and interfaces
>> that make them a drop-in replacement for a laptop hard drive, and a
>> number of the newer laptops that are supporting SSD's seem to be these
>> because (a) they don't have to radically change their design, (b) so
>> they can be compatible with Windows, and (c) so that users can
>> purchase the laptop either with a traditional hard drive or a SSD's as
>> an option, since at the moment SSD's are far more expensive than
>> disks.
>>
>> So if you can't get access to the raw flash layer, then what you're
>> probably going to be looking at is a traditional block-oriented
>> filesystem, such as ext3, although there are clearly some things that
>> could be done such as disabling the elevator.   
> 
> It's more complicated than that, I'd say. If the job of the elevator was
> purely to sort request based on sector criteria, then I'd agree that
> noop was the best way to go. But the elevator also abritrates access to
> the disk for processes. Even if you don't pay a seek penalty, you still
> would rather like to get your sync reads in without having to wait for
> that huge writer that just queued hundreds of megabytes of io in front
> of you (and will have done so behind your read, making you wait again
> for a subsequent read).

In most cases the time in the elevator is minimal compared to the 
benefits. Even without your next suggestion.
> 
> My plan in this area is to add a simple storage profile and attach it to
> the queue. Just start simple, allow a device driver to inform the block
> layer that this device has no seek penalty. Then the io scheduler can
> make more informed decisions on what to do - eg for ssd, sector
> proximity may not have much meaning, so we should not take that into
> account.
> 
Eventually the optimal solution may require both bandwidth and seek 
information. If "solid state disk" means flash, it's on a peripheral 
bus, it's probably not all that fast at transfer rate. If it means NV 
memory, battery backed or core, probably nothing changes, again *if* 
it's on a peripheral bus, but if it's on a card plugged to the 
backplane, the transfer rate may be high enough to make ordering cost 
more than waiting. This could be extended to nbd and iSCSI devices as 
well, I think, to optimize performance.

Your plan seems a good one in this area, but if you agree that transfer 
rate will be important (if it isn't already), perhaps you will be able 
to design allowing for that capability to be easily added.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
