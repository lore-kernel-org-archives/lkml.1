Return-Path: <linux-kernel-owner+w=401wt.eu-S1760348AbYDAUbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760348AbYDAUbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 16:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758455AbYDAUbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 16:31:43 -0400
Received: from smtp1.versatel.nl ([62.58.50.88]:45314 "EHLO smtp1.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758884AbYDAUbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 16:31:42 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Apr 2008 16:31:41 EDT
Message-ID: <47F29A04.2040701@hhs.nl>
Date: Tue, 01 Apr 2008 22:24:36 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>,
       Sergey Dolgov <solkaa@gmail.com>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: usb-storage, error reading the last 8 sectors, regression in
 2.6.25-rc7
References: <20080401143420.GB20920@one-eyed-alien.net> <Pine.LNX.4.44L0.0804011040260.4253-100000@iolanthe.rowland.org> <20080401155323.GB31604@one-eyed-alien.net> <47F26372.30508@panasas.com>
In-Reply-To: <47F26372.30508@panasas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh wrote:
> On Tue, Apr 01 2008 at 18:53 +0300, Matthew Dharm <mdharm-kernel@one-eyed-alien.net> wrote:
>> On Tue, Apr 01, 2008 at 10:42:51AM -0400, Alan Stern wrote:
>>> On Tue, 1 Apr 2008, Matthew Dharm wrote:
>>>
>>>> On Tue, Apr 01, 2008 at 10:28:52AM -0400, Alan Stern wrote:
>>>>> On Tue, 1 Apr 2008, Oliver Neukum wrote:
>>>>>
>>>>>> Am Dienstag, 1. April 2008 03:58:31 schrieb Alan Stern:
>>>>>>> Nevertheless, it's clear that the problem has nothing to do with the 
>>>>>>> USB stack.  The real source of the problem lies in the device itself, 
>>>>>>> for reporting a bogus error when in fact nothing went wrong.  That may 
>>>>>>> also explain why you don't always see the problem -- sometimes the 
>>>>>>> device works the way it ought to.
>>>>>> Reminds me of the devices that can read the last sector but only if it is read
>>>>>> by itself. Do you reckon this device may have the "opposite" quirk?
>>>>> Could be something like that.
>>>> Didn't I see some SCSI patches go by to implement exactly this change?
>>>> That is, only read the last sector by itself?
>>> You are getting the two problems mixed up.  The older problem, which
>>> the SCSI patche addressed, was that the device would fail when
>>> accessing the last sector unless the transfer was 1 sector long.
>>>
>>> This problem is different.  When performing an 8-sector read that 
>>> includes the last sector, the device succeeds.  When performing a 
>>> 7-sector read starting from the same place (so not including the last 
>>> sector), the device fails.
>> I thought the patch I saw unconditionally re-wrote any access that included
>> the last sector into two accesses -- everything but the last sector, and
>> the last sector.
>>
>> In other words, the patch attempted to avoid problems on devices that
>> couldn't access the last sector unless the transfer was 1 sector long by
>> ONLY accessing the last sector in a single transfer.
>>
>> If I'm remembering correctly, that would explain the behavior change which
>> lead to the exposure of the bad behavior of this new device.  This new
>> device worked with the old code, but not with the new code.
>>
>> Basically, by avoiding a common error condition in device firmware, we've
>> found a device that has exactly the opposite bug.
>>
>> Presuming someone can find the patch in the archive, reverting it would
>> produce a good test case; it should restore this device to a working state.
>> Maybe we need some auto-detect logic here; try the new way, if it fails,
>> revert to the old behavior.  That's probably the safe order, as a lot of
>> the devices with the more 'classic' bug just die completely, whereas this
>> one appears to be recoverable.
>>

Reverting the patch is easy, edit drivers/usb/storage/scsiglue.c and remove the 
following line:
"                sdev->last_sector_bug = 1;"

Which should be close to line 193 (it is 193 in my source tree, but thats a bit 
stale).

> 
> The old way was not necessarily correct for this type of device bug. Only
> that it had a very high chance of not appearing.
> 
> When discussing the last bug, it was said to enable it by default for USB
> instead of using blacklists. It looks like this bug, or the other, needs a
> blacklist.
> 

If the splitting of the request is the cause, yes then it looks like that.

> But to me it looks like this is a 4k thing. I think Windows will always
> use 4k for FAT, though never triggering either of the bugs.
> 

I'm pretty sure the last sector must only be read by itself bug (for lack of a 
better name) is present under windows too, but won't be triggered as windows 
normally doesn't access the last sector, where as various pieces of Linux 
routinely probe the end of the disk, for detection of exotic partition types/ 
disklabes.etc.

> The one submitting the last sector patch was, I think, Hans de Goede (CCed)
> Hans ?

Correct I wrote the split up requests which touch the last sector changes to 
the scsi disk handling, and a seperate patch to always set the flag which 
enables the splitting for usb disks.

>   If I read last 8 sectors (4k) on a device that exhibits the "last sector bug"
>   Does it work? (Is 8 a magic number here)
> 

I just tried and I'm afraid not, an 8 sector read which includes at the last 
sector completely kills the device, no other transfers to / from the device 
will work until the sdcard is removed and reinserted (the troublesome device is 
a card reader build into a multi function printer, one gets what one pays for).

Regards,

Hans
