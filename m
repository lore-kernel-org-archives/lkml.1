Return-Path: <linux-kernel-owner+w=401wt.eu-S1760988AbZDSNHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760988AbZDSNHN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 09:07:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760241AbZDSNG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 09:06:58 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:49963 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758242AbZDSNG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 09:06:57 -0400
Message-ID: <49EB21EF.3060600@msgid.tls.msk.ru>
Date: Sun, 19 Apr 2009 17:06:55 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Mark Lord <lkml@rtr.ca>,
       =?UTF-8?B?Um9nw6lyaW8gQnJpdG8=?= <rbrito@ime.usp.br>,
       linux-kernel@vger.kernel.org
Subject: Re: Quick question about libata and hdparm
References: <E693AEE4-7895-4650-A1DC-1FB16D409D5B@ime.usp.br> <49EB1A33.7050808@rtr.ca> <49EB1C9C.3000105@msgid.tls.msk.ru> <49EB1FB3.5000609@garzik.org>
In-Reply-To: <49EB1FB3.5000609@garzik.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Michael Tokarev wrote:
>> Mark Lord wrote:
>> []
>>> Nearly all of the hdparm flags work fine with libata and SATA/PATA 
>>> drives.
>>> Among the *very few* that do not, are the -m and -d flags.  -c will 
>>> be working
>>> in the newest kernels, but not yet in most distro kernels.
>>>
>>> The -d flag is not permitted by libata, as the kernel prefers to 
>>> completely
>>> dictate DMA / PIO, and it does do a rather good job of it.
>>
>> Well, the kernel does a good job here in *almost* all cases.
>> The problematic case is when a device has some bad/unreadable
>> blocks/sectors.  When such a place occurs on read, libata
>> (or whatever it is) performs several retries, each time
>> using "less aggressive" settings - like reducing UDMA and
>> PIO mode till the lowest possible PIO/33.  And the device
>> stays in that mode until reboot, even if the problematic
>> sector has been relocated.  So it'd be nice to be able to
>> reset the mode back in such cases.
> 
> Do you have a log?

Hmm.  Just a week ago I were reading several bad disks - one
dying drive from a laptop with many bad blocks on it and several
scsi drives that were in a server room where an airconditioner
failed and ambient temp were as high as 78C.  Ran that off an
rescue cd, without any permanent storage to save logs.  It was
quite time-consuming process - I had to use ddrescue to recover
data, and I had  to reboot several times to get the (sata) disk
to work in UDMA6 mode again (ddrescue saves state and resumes
from place it were stopped before).  So no - I don't have logs
right now even if I saw it very recently.

> libata worries about speed changes for CRC errors and the like, not for 
> media errors that involve sector relocation.

Maybe I were not clear enough.  The relocation event were triggered
especially *after* failure to read the bad block(s).  I tried to
read the bad blocks with ddrescue, during which drive returned
"media error" (in case of scsi drives) and - probably, but i'm
not sure - crc errors in case of sata, and libata (in case of
sata) reduced the mode the drive is working at and retried.
Later on I just wrote something to the problematic place to
trigger relocation and continued, but the drive (now reading
good portions) stays in PIO/33 mode anyway, which is slow and
I had to reboot to speed it up again.

So it seems there's no disagreement - the drive actually returned
something similar to CRC errors, and it has nothing to do with
sector relocation.

What I mean by mentioning relocated sectors is that the drive
stays in "lower" mode after - even if the problematic sector
is fixed already.

But this is not something you encounter 20 times a day, hopefully :)

/mjt
