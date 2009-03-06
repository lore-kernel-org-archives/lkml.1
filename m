Return-Path: <linux-kernel-owner+w=401wt.eu-S1755178AbZCFHr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178AbZCFHr6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 02:47:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156AbZCFHrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 02:47:49 -0500
Received: from smtp.nokia.com ([192.100.105.134]:30055 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbZCFHrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 02:47:49 -0500
Message-ID: <49B0D514.2020804@nokia.com>
Date: Fri, 06 Mar 2009 09:47:32 +0200
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: "Jorge Boncompte [DTI2]" <jorge@dti2.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Error testing ext3 on brd ramdisk
References: <491D7C4C.3090907@nokia.com> <49A82C2E.4030903@dti2.net> <20090228055809.GC28496@wotan.suse.de> <49AC1A7A.1070108@dti2.net> <20090305065529.GB11916@wotan.suse.de>
In-Reply-To: <20090305065529.GB11916@wotan.suse.de>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 06 Mar 2009 07:47:13.0780 (UTC) FILETIME=[C3869B40:01C99E2F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Mon, Mar 02, 2009 at 06:42:18PM +0100, Jorge Boncompte [DTI2] wrote:
>> Nick Piggin escribió:
>>> On Fri, Feb 27, 2009 at 07:08:46PM +0100, Jorge Boncompte [DTI2] wrote:
>>>> 	Hi,
>>>>
>>>> 	I have added Nick Piggin to the CC: as maintainer of the brd driver.
>>>>
>>>> 	After switching an embedded distribution that /etc on a ramdisk 
>>>> 	based minix filesystem from 2.6.23.17 to 2.6.29-rcX i am too getting 
>>>> 	errors ant the filesystem is corrupted. Does not happen always. The 
>>>> visible effect with text files after reboot is getting the old version of 
>>>> the file and "\0"'s at the end.
>>>>
>>>> 	Did you found a solution?
>>> What architectures are you using? It's possible that brd is missing
>>> a cacheflush. I test it pretty heavily on x86 and no problems, so
>>> this might point to an arch specific problem.
>>>
>>> ---
>>> drivers/block/brd.c |    4 +++-
>>> 1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> Index: linux-2.6/drivers/block/brd.c
>>> ===================================================================
>>> --- linux-2.6.orig/drivers/block/brd.c
>>> +++ linux-2.6/drivers/block/brd.c
>>> @@ -275,8 +275,10 @@ static int brd_do_bvec(struct brd_device
>>> 	if (rw == READ) {
>>> 		copy_from_brd(mem + off, brd, sector, len);
>>> 		flush_dcache_page(page);
>>> -	} else
>>> +	} else {
>>> +		flush_dcache_page(page);
>>> 		copy_to_brd(brd, mem + off, sector, len);
>>> +	}
>>> 	kunmap_atomic(mem, KM_USER0);
>>>
>>> out:
>> 	Hi, I am on 32bits x86, 2 x Xeon with HT CPUs, but I have seen the 
>> 	same corruption on a KVM/QEMU guest with single emulated CPU.
>>
>> 	With your patch on top of vanilla 2.6.29-rc3+plus some networking 
>> patches I still get corruption sometimes.
>>
>> 	The script that saves the configuration does...
>>
>> ------------
>> mount -no remount,ro /dev/ram0
>> dd if=/dev/ram0 of=config.bin bs=1k count=1000
>> mount -no remount,rw /dev/ram0
>> md5sum config.bin
>> dd if=config.bin of=/dev/hda1
>> echo $md5sum | dd of=/dev/hda1 bs=1k seek=1100 count=32
>> ------------
>>
>> on system boot
>>
>> ------------
>> CHECK MD5SUM
>> dd if=/dev/hda1 of=/dev/ram0 bs=1k count=1000
>> fsck.minix -a /dev/ram0
>> mount -nt minix /dev/ram0 /etc -o rw
>> ------------
>>
>> 	I have never seen a MD5 failure on boot, just sometimes the 
>> 	filesystem is corrupted. Kernel config attached.
> 
> Hi Jorge,
> 
> Well I found and fixed something :) (see other mail) but I don't know
> whether that applies to you here if you're running with a single CPU
> and no preemption. But still, it might be worth trying that patch? I'm
> sorry I'm still unable to reproduce a problem with your script
> (although you don't describe how you create the filesystem before
> you remount it).
> 
>>From your description, it suggests that the corrupted image is being
> read from /dev/ram0 (becuase the md5sum passes).
> 
> In your script, can you run fsck.minix on config.bin when you first
> create it? What if you unmount /dev/ram0 before copying the image?
> 
> Thanks,
> Nick

Thanks for looking at this.

I applied both patches and still got:

-------------------------------------------------------------
Cycle 616
Thu Mar  5 22:13:16 EET 2009
Mounting
kjournald starting.  Commit interval 5 seconds
EXT3 FS on ram0, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Removing old fsstress data
Starting fsstress
Sleeping 30 seconds
seed = 1237038794
Stopping fsstress
18670 ttyS0    00:00:00 fsstress
18672 ttyS0    00:00:15 fsstress
18673 ttyS0    00:00:15 fsstress
18674 ttyS0    00:00:15 fsstress
./brd-test.sh: line 30: 18670 Terminated              ./fsstress/fsstress -d /mnt/test_file_system/work -p 3 -l 0 -n 100000000
Unmounting
Checking
/dev/ram0: HTREE directory inode 46 has an invalid root node.
HTREE INDEX CLEARED.
/dev/ram0: Entry 'f6c' in /work/p1/d0 (46) has deleted/unused inode 261.  CLEARED.
/dev/ram0: Entry 'f276' in /work/p1/d0 (46) has deleted/unused inode 454.  CLEARED.
/dev/ram0: Entry 'f152' in /work/p1/d0 (46) has deleted/unused inode 543.  CLEARED.
/dev/ram0: Entry 'cc1' in /work/p1/d0 (46) has an incorrect filetype (was 3, should be 2).


/dev/ram0: UNEXPECTED INCONSISTENCY; RUN fsck MANUALLY.
        (i.e., without -a or -p options)



My test box is Pentium D dual core.

