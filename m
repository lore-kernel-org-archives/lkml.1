Return-Path: <linux-kernel-owner+w=401wt.eu-S1754781AbYEXMxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbYEXMxL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 08:53:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbYEXMxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 08:53:00 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:14400 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbYEXMw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 08:52:59 -0400
Date: Sat, 24 May 2008 08:52:58 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: floppy question of the hour
In-reply-to: <4837DFC6.9010202@s5r6.in-berlin.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Message-id: <200805240852.58268.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200805232114.20937.gene.heskett@gmail.com>
 <4837DFC6.9010202@s5r6.in-berlin.de>
User-Agent: KMail/1.9.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 24 May 2008, Stefan Richter wrote:
>(Adding Cc: block layer maintainer for no solid reason...)

Thank you Stefan.  I've done a reply all.

>Gene Heskett wrote:
>> Who is the maintainer of drivers/block/floppy.c and associated files?
>>
>> I ask because there are a few of us still using it, in particular with
>> what some may call oddball disk formats & I'm up to here with doing such
>> as this:
>>
>> [root@coyote coco3]# setfdprm /dev/fd0 COCO7203.5
>> [root@coyote coco3]# getfdprm /dev/fd0
>> get geometry parameters: No such device
>>
>> Or: Assuming the above took,
>> [root@coyote coco3]# dd if=/dev/fd0 of=test.dsk
>> dd: reading `/dev/fd0': Input/output error
>> 0+0 records in
>> 0+0 records out
>> 0 bytes (0 B) copied, 25.5495 s, 0.0 kB/s
>>
>> /var/log/messages is full of these now:
>> May 23 21:02:07 coyote kernel: [20603.055178] floppy0: probe failed...
>> May 23 21:02:07 coyote kernel: [20603.455755] floppy0: unexpected
>> interrupt May 23 21:02:07 coyote kernel: [20603.455827] floppy0: sensei
>> repl[0]=80 May 23 21:02:07 coyote kernel: [20603.456135] floppy0: -- FDC
>> reply errorfloppy0: probe failed...
>
>[...]
>
>> The drive led is on and the disk is turning during that 25 seconds.
>> This is booted to 2.6.26-rc2, with the floppy driver built in.
>
>There was only a single change to drivers/block/floppy.c after 2.6.25:
>http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdif
>f;h=7afea3bcb1f87f3ddf34b38f202ad0d03f29e120
>
>This looks OK to me; I suppose the problem comes from somewhere else.

Floppy has not worked well for me since about the 2.6.22 time frame.  But I was 
usually able to make it work with minimal fussing before that, and there was a 
period where it appeared that fdutils-5.4 worked better than 5.5 too.

I don't know just yet.  On a whim yesterday after posting this, I rebuilt 
2.6.26-rc2 with the floppy as a module, and with one or two hiccups, like 
setfdprm might have to be done more than once after the disc is inserted, it 
worked nominally well, whereas if built in, it is a total failure.

Perhaps there is a clue in that?

One thing I've noted is that writing a 550k dsk image to a 720k DD OS-9 
(MicroWare OS-9, not Apples) formatted disc, while it works and the results cmp 
well, its very slow at 3.1kb a second for writes.  Reads are faster but 
similarly slow.

[root@coyote coco3_6309]# time dd if=/dev/fd0 of=/dev/null
1440+0 records in
1440+0 records out
737280 bytes (737 kB) copied, 112.984 s, 6.5 kB/s

real    1m53.023s
user    0m0.004s
sys     0m0.009s

This is a 250 kilobaud data rate format, the maximum the WD-1773 FDC chip in the 
target machine can handle, with 18, 256 byte sectors per track, two sides=73728 
bits to write a track, /250000 (baud rate)=0.294912 seconds to write one full 
tracks worth of data. 80 tracks=23.59296 seconds to write the whole disk if it 
were streaming, but it takes 3 minutes and change?  And nearly 2 to read it 
back as above?  Odd.  With the interleave of 3, I could see 75 seconds maybe 
for efficient methods.  I also understand this is a one size fits all scene 
too, and that there must be compromises.

I format these DD discs in the target machine with an interleave factor of 3 cuz 
that machines cpu is running at as low as .89MHZ and can't handle the read data 
any faster than that.

Is this non-1 interleave responsible for the slowness of the writes or reads on 
this box?  I can control the interleave on the target box, so I suppose I could 
test that effect easily enough.

>> 2.6.26-rc1 worked flawlessly yesterday, for both writing, then reading
>> back for a cmp session, twice each way, until it(2.6.26-rc1) went away
>> after about 3 hours uptime, the 5th time -rc1 had done this to me without
>> a single footprint in the logs.  -rc2 is doing better, uptime is 5:45 so
>> far.
>
>[...]
>
>By "until it(2.6.26-rc1) went away" you mean a crash during writing to
>or reading from the FDD, or during general usage?

General usage. While switching work screens several times the most common, the 
screen gets about half redrawn & the whole machine freezes up.  Reset button 
required.  The last time was in the middle of the nightly amanda run yesterday 
morning early & when I awoke, the space bar did nothing to unblank the screen, 
and the only other button that worked was the hardware reset on the case.  No 
screen switching there...  The last build of -rc2 has 10+ hours on it & still 
feels good.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The fortune program is supported, in part, by user contributions and by
a major grant from the National Endowment for the Inanities.
