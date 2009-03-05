Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111AbZCEJVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbZCEJVA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 04:21:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752357AbZCEJUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 04:20:42 -0500
Received: from alcalazamora.dti2.net ([81.24.162.8]:4165 "EHLO
	alcalazamora.dti2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbZCEJUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 04:20:40 -0500
X-Spam-Processed: alcalazamora.dti2.net, Thu, 05 Mar 2009 10:20:35 +0100
	(not processed: message from valid local sender)
X-MDOP-RefID: str=0001.0A0B0203.49AF9960.0175,ss=1,fgs=0 (_st=1 _vt=0 _iwf=0)
X-Authenticated-Sender: jorge@dti2.net
X-MDRemoteIP: 81.24.161.20
X-Return-Path: jorge@dti2.net
X-Envelope-From: jorge@dti2.net
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Message-ID: <49AF9932.2040301@dti2.net>
Date: Thu, 05 Mar 2009 10:19:46 +0100
From: "Jorge Boncompte [DTI2]" <jorge@dti2.net>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: npiggin@suse.de
CC: ext-adrian.hunter@nokia.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Error testing ext3 on brd ramdisk
References: <491D7C4C.3090907@nokia.com> <49A82C2E.4030903@dti2.net> <20090228055809.GC28496@wotan.suse.de> <49AC1A7A.1070108@dti2.net> <20090305065529.GB11916@wotan.suse.de>
In-Reply-To: <20090305065529.GB11916@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Reply-To: jorge@dti2.net
X-MDAV-Processed: alcalazamora.dti2.net, Thu, 05 Mar 2009 10:20:36 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin escribió:
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

	I first saw the corruption on the 2 x Xeon system. I'll try it and let 
you know.

> sorry I'm still unable to reproduce a problem with your script
> (although you don't describe how you create the filesystem before
> you remount it).

	If the MD5Sum check fails the startup script copy a templated image of 
the filesystem contained on a file on another partition to the ramdisk.

>>From your description, it suggests that the corrupted image is being
> read from /dev/ram0 (becuase the md5sum passes).

	No, it is read from /dev/hda1.

> In your script, can you run fsck.minix on config.bin when you first
> create it? What if you unmount /dev/ram0 before copying the image?

	Yesterday I did some tests and found that doing...

-----------
umount /etc (/etc is what is mounted from /dev/ram0)
dd if=/dev/zero of=/dev/ram0 bs=1k count=1000
mount /dev/ram0 /etc -t minix -o rw
-----------
...succeds and mounts a corrupted filesystem with the old content. Doing 
the same with the all ramdisk driver fails on mount with "no filesystem 
found".

If I do...
-----------
umount /etc (/etc is what is mounted from /dev/ram0)
echo 3 > /proc/sys/vm/drop_caches
dd if=/dev/zero of=/dev/ram0 bs=1k count=1000
mount /dev/ram0 /etc -t minix -o rw
----------
... then the mount fails with no filesystem found as it should.

	Does this ring any bell? :-)

	Regards,

	Jorge

-- 
==============================================================
Jorge Boncompte - Ingenieria y Gestion de RED
DTI2 - Desarrollo de la Tecnologia de las Comunicaciones
--------------------------------------------------------------
C/ Abogado Enriquez Barrios, 5   14004 CORDOBA (SPAIN)
Tlf: +34 957 761395 / FAX: +34 957 450380
==============================================================
- Sin pistachos no hay Rock & Roll...
- Without wicker a basket cannot be made.
==============================================================

