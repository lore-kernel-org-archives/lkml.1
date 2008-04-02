Return-Path: <linux-kernel-owner+w=401wt.eu-S1753223AbYDBHgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbYDBHgu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 03:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbYDBHgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 03:36:42 -0400
Received: from frosty.hhs.nl ([145.52.2.15]:55386 "EHLO frosty.hhs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421AbYDBHgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 03:36:41 -0400
X-Greylist: delayed 1421 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Apr 2008 03:36:41 EDT
Message-ID: <47F32F4F.2030702@hhs.nl>
Date: Wed, 02 Apr 2008 09:01:35 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080303)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Boaz Harrosh <bharrosh@panasas.com>, Oliver Neukum <oliver@neukum.org>,
       Sergey Dolgov <solkaa@gmail.com>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: usb-storage, error reading the last 8 sectors, regression in
 2.6.25-rc7
References: <Pine.LNX.4.44L0.0804011659500.9362-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0804011659500.9362-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.2/RELEASE, bases: 02042008 #608293, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Tue, 1 Apr 2008, Hans de Goede wrote:
> 
>> Reverting the patch is easy, edit drivers/usb/storage/scsiglue.c and remove the 
>> following line:
>> "                sdev->last_sector_bug = 1;"
>>
>> Which should be close to line 193 (it is 193 in my source tree, but thats a bit 
>> stale).
>>
>>> The old way was not necessarily correct for this type of device bug. Only
>>> that it had a very high chance of not appearing.
>>>
>>> When discussing the last bug, it was said to enable it by default for USB
>>> instead of using blacklists. It looks like this bug, or the other, needs a
>>> blacklist.
>>>
>> If the splitting of the request is the cause, yes then it looks like that.
>>
>>> But to me it looks like this is a 4k thing. I think Windows will always
>>> use 4k for FAT, though never triggering either of the bugs.
>>>
>> I'm pretty sure the last sector must only be read by itself bug (for lack of a 
>> better name) is present under windows too, but won't be triggered as windows 
>> normally doesn't access the last sector, where as various pieces of Linux 
>> routinely probe the end of the disk, for detection of exotic partition types/ 
>> disklabes.etc.
>>
>>> The one submitting the last sector patch was, I think, Hans de Goede (CCed)
>>> Hans ?
>> Correct I wrote the split up requests which touch the last sector changes to 
>> the scsi disk handling, and a seperate patch to always set the flag which 
>> enables the splitting for usb disks.
>>
>>>   If I read last 8 sectors (4k) on a device that exhibits the "last sector bug"
>>>   Does it work? (Is 8 a magic number here)
>>>
>> I just tried and I'm afraid not, an 8 sector read which includes at the last 
>> sector completely kills the device, no other transfers to / from the device 
>> will work until the sdcard is removed and reinserted (the troublesome device is 
>> a card reader build into a multi function printer, one gets what one pays for).
> 
> It sounds like the last_sector_bug setting should be conditional on a 
> blacklist entry.  As far as I know it affects only a small proportion 
> of devices; most are fine with multi-sector reads at the end.
> 

Maybe we should first determine that the regression is _really_ caused by this?

When testing yesterday I did a printk of any (unmodified) reads which would 
touch the last sector and quite a few where not 8 sector reads, so if this 
devices goes barf on any last sector including read of a different size then 8, 
it will have troubles without the work around too.

First we need to determine what _exactly_ causes this device to become unhappy 
(which should be trivial to test through dd), if I understand things sofar, the 
device doesn't like if a read is done which stops one sector short of the last 
sector. Such  a read being done could happen without my split requests code 
too, so making that conditional then wouldn't do any good, it would only make 
the bug (much) less likely to get triggered, but it could still happen en 
probably be reproduced by a trivial dd command.

Regards,

Hans

