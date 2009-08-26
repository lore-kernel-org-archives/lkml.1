Return-Path: <linux-kernel-owner+w=401wt.eu-S1755477AbZHZBGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbZHZBGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 21:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753991AbZHZBGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 21:06:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53185 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050AbZHZBGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 21:06:42 -0400
Message-ID: <4A948A82.4080901@redhat.com>
Date: Tue, 25 Aug 2009 21:06:10 -0400
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: Andrei Tanas <andrei@tanas.ca>, linux-kernel@vger.kernel.org
Subject: Re: MD/RAID: what's wrong with sector 1953519935?
References: <004e01ca25e4$c11a54e0$434efea0$@ca> <9cfb6af689a7010df166fdebb1ef516b.squirrel@neil.brown.name>
In-Reply-To: <9cfb6af689a7010df166fdebb1ef516b.squirrel@neil.brown.name>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2009 08:50 PM, NeilBrown wrote:
> On Wed, August 26, 2009 10:32 am, Andrei Tanas wrote:
>    
>> Hello,
>>
>> I'm using two ST31000528AS drives in RAID1 array using MD. I've had
>> several
>> failures occur over a period of few months (see logs below). I've RMA'd
>> the
>> drive, but then got curious why an otherwise normal drive locks up while
>> trying to write the same sector once a month or so, but does not report
>> having bad sectors, doesn't fail any tests, and does just fine if I do
>> dd if=/dev/urandom of=/dev/sdb bs=512 seek=1953519935 count=1
>> however many times I try.
>> I then tried Googling for this number (1953519935) and found that it comes
>> up quite a few times and most of the time (or always) in context of
>> md/raid.
>> So my question is: is it just a coincidence (doesn't seem to be likely for
>> a
>> number this big), or is it possible that when sent to hard drive, it gets
>> interpreted like some command and sends the drive into some unpredictable
>> state?
>>      
> All 1TB drives are exactly the same size.
> If you create a single partition (e.g. sdb1) on such a device, and that
> partition starts at sector 63 (which is common), and create an md
> array using that partition, then the superblock will always be at the
> address you quote.
> The superblock is probably updated more often than any other block in
> the array, so there is probably an increased likelyhood of an error
> being reported against that sector.
>
> So it is not just a coincidence.
> Whether there is some deeper underlying problem though, I cannot say.
> Google only claims 68 matches for that number which doesn't seem
> big enough to be significant.
>
> NeilBrown
>
>    

Neil,

One thing that can happen is when we have a hot spot (like the super 
block) on high capacity drives is that the frequent write degrade the 
data in adjacent tracks.  Some drives have firmware that watches for 
this and rewrites adjacent tracks, but it is also a good idea to avoid 
too frequent updates.

Didn't you have a tunable to decrease this update frequency?

Ric

>
>    
>> I will gladly provide any additional info that might be necessary.
>>
>>
>> #smartctl -i /dev/sdb
>> === START OF INFORMATION SECTION ===
>> Device Model:     ST31000528AS
>> Serial Number:    6VP01LNL
>> Firmware Version: CC34
>> User Capacity:    1,000,204,886,016 bytes
>> Device is:        Not in smartctl database [for details use: -P showall]
>> ATA Version is:   8
>> ATA Standard is:  ATA-8-ACS revision 4
>> Local Time is:    Thu Aug 20 10:52:31 2009 EDT
>> SMART support is: Available - device has SMART capability.
>> SMART support is: Enabled
>>
>> ----------------------------------------------------
>> Jul 27 19:02:31 srv kernel: [901292.247428] ata2.00: exception Emask 0x0
>> SAct 0x0 SErr 0x0 action 0x6 frozen
>> Jul 27 19:02:31 srv kernel: [901292.247492] ata2.00: cmd
>> ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
>> Jul 27 19:02:31 srv kernel: [901292.247494]          res
>> 40/00:01:01:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
>> Jul 27 19:02:31 srv kernel: [901292.247500] ata2.00: status: { DRDY }
>> Jul 27 19:02:31 srv kernel: [901292.247512] ata2: hard resetting link
>> Jul 27 19:02:33 srv kernel: [901294.090746] ata2: SRST failed (errno=-19)
>> Jul 27 19:02:33 srv kernel: [901294.101922] ata2: SATA link up 3.0 Gbps
>> (SStatus 123 SControl 300)
>> Jul 27 19:02:33 srv kernel: [901294.101938] ata2.00: failed to IDENTIFY
>> (I/O
>> error, err_mask=0x40)
>> Jul 27 19:02:33 srv kernel: [901294.101943] ata2.00: revalidation failed
>> (errno=-5)
>> Jul 27 19:02:38 srv kernel: [901299.100347] ata2: hard resetting link
>> Jul 27 19:02:38 srv kernel: [901299.974103] ata2: SATA link up 3.0 Gbps
>> (SStatus 123 SControl 300)
>> Jul 27 19:02:39 srv kernel: [901300.105734] ata2.00: configured for
>> UDMA/133
>> Jul 27 19:02:39 srv kernel: [901300.105776] ata2: EH complete
>> Jul 27 19:02:39 srv kernel: [901300.137059] end_request: I/O error, dev
>> sdb,
>> sector 1953519935
>> Jul 27 19:02:39 srv kernel: [901300.137069] md: super_written gets
>> error=-5,
>> uptodate=0
>> Jul 27 19:02:39 srv kernel: [901300.137077] raid1: Disk failure on sdb1,
>> disabling device.
>> Jul 27 19:02:39 srv kernel: [901300.137079] raid1: Operation continuing on
>> 1
>> devices.
>> Jul 27 19:02:39 srv kernel: [901300.208812] RAID1 conf printout:
>> Jul 27 19:02:39 srv kernel: [901300.208820]  --- wd:1 rd:2
>> Jul 27 19:02:39 srv kernel: [901300.208826]  disk 0, wo:0, o:1, dev:sda1
>> Jul 27 19:02:39 srv kernel: [901300.208830]  disk 1, wo:1, o:0, dev:sdb1
>> Jul 27 19:02:39 srv kernel: [901300.217392] RAID1 conf printout:
>> Jul 27 19:02:39 srv kernel: [901300.217399]  --- wd:1 rd:2
>> Jul 27 19:02:39 srv kernel: [901300.217404]  disk 0, wo:0, o:1, dev:sda1
>>
>> Aug 20 00:15:36 srv kernel: [90307.328266] ata2.00: exception Emask 0x0
>> SAct
>> 0x0 SErr 0x0 action 0x6 frozen
>> Aug 20 00:15:36 srv kernel: [90307.328275] ata2.00: cmd
>> ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
>> Aug 20 00:15:36 srv kernel: [90307.328277]          res
>> 40/00:01:01:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
>> Aug 20 00:15:36 srv kernel: [90307.328280] ata2.00: status: { DRDY }
>> Aug 20 00:15:36 srv kernel: [90307.328288] ata2: hard resetting link
>> Aug 20 00:15:47 srv kernel: [90313.218511] ata2: link is slow to respond,
>> please be patient (ready=0)
>> Aug 20 00:15:47 srv kernel: [90317.377711] ata2: SRST failed (errno=-16)
>> Aug 20 00:15:47 srv kernel: [90317.377720] ata2: hard resetting link
>> Aug 20 00:15:47 srv kernel: [90318.251720] ata2: SATA link up 3.0 Gbps
>> (SStatus 123 SControl 300)
>> Aug 20 00:15:47 srv kernel: [90318.338026] ata2.00: configured for
>> UDMA/133
>> Aug 20 00:15:47 srv kernel: [90318.338062] ata2: EH complete
>> Aug 20 00:15:47 srv kernel: [90318.370625] end_request: I/O error, dev
>> sdb,
>> sector 1953519935
>> Aug 20 00:15:47 srv kernel: [90318.370632] md: super_written gets
>> error=-5,
>> uptodate=0
>> Aug 20 00:15:47 srv kernel: [90318.370636] raid1: Disk failure on sdb1,
>> disabling device.
>> Aug 20 00:15:47 srv kernel: [90318.370637] raid1: Operation continuing on
>> 1
>> devices.
>> Aug 20 00:15:47 srv kernel: [90318.396403] RAID1 conf printout:
>> Aug 20 00:15:47 srv kernel: [90318.396408]  --- wd:1 rd:2
>> Aug 20 00:15:47 srv kernel: [90318.396410]  disk 0, wo:0, o:1, dev:sda1
>> Aug 20 00:15:47 srv kernel: [90318.396413]  disk 1, wo:1, o:0, dev:sdb1
>> Aug 20 00:15:47 srv kernel: [90318.429178] RAID1 conf printout:
>> Aug 20 00:15:47 srv kernel: [90318.429185]  --- wd:1 rd:2
>> Aug 20 00:15:47 srv kernel: [90318.429189]  disk 0, wo:0, o:1, dev:sda1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>>      
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>    

