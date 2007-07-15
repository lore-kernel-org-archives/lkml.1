Return-Path: <linux-kernel-owner+w=401wt.eu-S1752174AbXGOTkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174AbXGOTkx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 15:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936AbXGOTko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 15:40:44 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:41277
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbXGOTko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 15:40:44 -0400
Date: Sun, 15 Jul 2007 12:33:58 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Jeremy Maitin-Shepard <jbms@cmu.edu>, "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
In-Reply-To: <200707151239.28400.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.64.0707151224160.25614@asgard.lang.hm>
References: <1184167831.12556.13.camel@caritas-dev.intel.com>
 <200707142200.17515.rjw@sisk.pl> <Pine.LNX.4.64.0707141413330.14672@asgard.lang.hm>
 <200707151239.28400.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Jul 2007, Rafael J. Wysocki wrote:

> On Saturday, 14 July 2007 23:34, david@lang.hm wrote:
>> On Sat, 14 Jul 2007, Rafael J. Wysocki wrote:
>>
>>> On Saturday, 14 July 2007 09:51, david@lang.hm wrote:
>>>> On Fri, 13 Jul 2007, Rafael J. Wysocki wrote:
>>>>
>>>>>> Ok, now we need a data channel from the old kernel to the hibernate
>>>>>> kernel, to the restore kernel. and the messier the memory layout the
>>>>>> larger this data channel needs to be (hmm, what's the status on the memory
>>>>>> defrag patches being proposed?) if this list can be made small enough it
>>>>>> would work to just have the old kernel put the data in a known location in
>>>>>> ram, and let the other two parts find it (in ram for the hibernate kernel,
>>>>>> in the hibernate image for the wakeup kernel).
>>>>>
>>>>> I think the hibernation kernel should mmap() the "old" kernel's (and it's
>>>>> processes') memory available for saving, so that the image-saving process
>>>>> can read its contents from the original locations.
>>>>
>>>> but I'll bet that not all kernels keep the info in the same place (and
>>>> probably not even in the same format). I'm suggesting that a standard be
>>>> defined for the format of the data and the location of a pointer to it
>>>> that will be maintained across kernel versions.
>>>
>>> Yes.
>>>
>>> The image-saving kernel needs to have access to the hibernated kernel's
>>> pages data, plus some additional information that should be passed in a
>>> standard format.
>>
>> but per stable-abi-nonsense the internal structure of the kernel's pages
>> data isn't an abi. so instead of figuring this out by pokeing around in
>> the memory of the old kernel and deciding what should be saved and what
>> shouldn't, the old kernel (which understands the memory structure) should
>> create a simple map of what should be backed up (either a bitmap or an
>> extent-style map, depending on how many holes there are expected to be)
>> and then provide that map to the new kernel. the new kernel (or more
>> precisely it's userspace) reads the pages it's told to read and writes
>> them somewhere.
>
> That's reasonable, but the "old" kernel can only do this after handling the
> shut down/quiescing of devices, when there is 100% guarantee that the memory
> contents will not change.

Ok, that makes sense. and since part of what's being passed along here is 
what ram is free as far as the outgoing kernel is concerned, this is 
useful info for the new kernel for other situations, not just for the 
hibernate operation, so this is probably a reasonable modification to the 
kexec call in any case (although a crash-dump kernel may decide not to 
trust this info and save everything, it's still useful to know what the 
outgoing kernel considers free)

>>>>>> since people are complaining about the amount of ram that a kexec kernel
>>>>>> would take up I'm assuiming it's somethingmore complex then just a bitmap
>>>>>> of all possible pages.
>>>>>
>>>>> No, it's just bitmaps, AFAICS, and the complaints are a bit overstated, IMO. ;-)
>>>>
>>>> 1 bit for each 4k means 1m bits for 4g of ram, or 128k of bitmaps, growing
>>>> up to 1m of ram used for 32G of ram in the system. I guess this isn't bad
>>>> as long as it doesn't need to be contiguous for the new kernel to access
>>>> it.
>>>>
>>>> ok, that makes it a pretty trivial thing to work with. I just need to
>>>> learn how to find the bitmaps.
>>>
>>> They are created on the fly before the hibernation.  The format is described in
>>> kernel/power/snapshot.c .
>>
>> I'll look through this file, but the format of this is an abi/api to the
>> userspace and should be documented outside of the code.
>
> Nope.  The user space need not know anything about the image contents.
>
> The current implementation of the user space tools use the knowledge of the
> image header format, which is given by 'struct swsusp_info', defined in
> kernel/power/power.h .

there are a couple factors here.

1. this needs to remain the same across different kernel versions.

2. this may or may not be created by userspace tools

both of these tend to imply that this is an interface to the world and 
needs to be documented and stable.

David Lang
