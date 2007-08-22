Return-Path: <linux-kernel-owner+w=401wt.eu-S933839AbXHVVIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933839AbXHVVIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 17:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932866AbXHVVIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 17:08:18 -0400
Received: from mx1.of.net-lab.net ([80.69.37.105]:37886 "EHLO
	imap.internetcave.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760294AbXHVVIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 17:08:17 -0400
X-Greylist: delayed 310 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Aug 2007 17:08:16 EDT
Message-ID: <46CCA483.4080105@aj.net-lab.net>
Date: Wed, 22 Aug 2007 23:02:59 +0200
From: Andreas John <lists@aj.net-lab.net>
User-Agent: IceDove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Conke Hu <conke.hu@gmail.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] ahci.c: fix ati sb600 sata IRQ_TF_ERR
References: <5767b9100703140222k79dbed9dq6419b4f35d276242@mail.gmail.com>	 <45F7E7E9.6010703@gmail.com>	 <5767b9100703150500t1c34dfb0kc6a199b5374a8d78@mail.gmail.com>	 <45F93888.1080207@gmail.com> <5767b9100703270253j2ac3b543y499323b42c6402b@mail.gmail.com>
In-Reply-To: <5767b9100703270253j2ac3b543y499323b42c6402b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi SB600-folks,

we bought some AMD690/sb600 based mobos and try go get them working. I
followed the patches on LKML and switched from Debian Etch 2.6.18-x
kernel to 2.6.22, just to ensure that all patches are already applied.
But we still have strange errors/lockups and we found a way to reproduce
them: simply run checkarry --all and do some dd if=/dev/sda ....
parallely. We notive load avg going up and then boom ... lockup,
softraid broken:

---<8----
ata2.00: exception Emask 0x0 SAct 0X2 SErr 0x= action 0x0
ata2.00: (irq_stat 0x40000008)
ata2.00: cmd 60/00:00:00:69:71/01:00:06:00:00/40 tag 0 cdb 0x0 data
131072 in
---<8----

This appears with ahci. If I switch to atiixp I only see the cdrom and
one harddisk, the second does not appear at all and -depending on the
setting in BIOS setup ahci->sata, native ide, legacy ide- only the cdrom
appears.

I might note that I first ran into that trouble on amd64 with 4GB RAM.
Then I swicthed back to 2 GB and back to i386 / 2 GB. The error message
above is from the i386 / 2 GB variant, but all suffer from this strange
sata pain, I am not 100% sure, if the log entriea read the same of onyl
similar. I also tried pci=nomsi some times, but I was still able to
trigger the bug. I might also note, that I noticed the problem on amd64
arch and it was simply to trigger it there, but with the checkarry --all
trick I was also able to trigger it on i386.

Is there anything I can further test? I you provide a patch, I will
glady test it.

best regards,
Andreas


Conke Hu schrieb:
> On 3/15/07, Tejun Heo <htejun@gmail.com> wrote:
>> Conke Hu wrote:
>> >> E  Internal error: The host bus adapter experienced an internal error
>> >> that caused the operation to fail and may have put the host bus
>> adapter
>> >> into an error state. Host software should reset the interface before
>> >> re-trying the operation. If the condition persists, the host bus
>> adapter
>> >> may suffer from a design issue rendering it incompatible with the
>> >> attached device.
>> >>
>> >
>> > Yes, I saw this too :) and I am contacting the hardware engineers to
>> > check if there is any hardware bug.
>> > But, even though this were a hardware bug and could be fixed, we would
>> > still need this patch since many SB600 boards have already come into
>> > the market and those ASICs can never be fixed :(
>>
>> Yeap, we certainly need the workaround.  I was just having a little fun.
>>  :-)
>>
>> >> 4381 isn't affected while 4380 is?
>> >
>> > I never see such an ID, and plan to remove 0x4381.
>> > The patch which added the PCI IDs was not sent out by myself. I
>> > checked all SB600 boards, and not found any 0x4381 controller, only
>> > 0x4380 instead. In fact, SB600 RAID and Non-RAID share the same PCI
>> > device ID, only with class code different.
>>
>> I see.
>>
>> >> Anyways, Conke Hu, can you please take a look at my patch from a month
>> >> ago?  It's almost identical but SERR_INTERNAL is always ignored on
>> both
>> >> SB600 PCI IDs, which I think is safer.  Does this fix what you're
>> seeing?
>> >>
>> >
>> > I just read your patch. Another difference is that my patch ignores
>> > SERR_INTERNAL only when the command is ATAPI and IRQ_TF_ERR occurs. In
>> > other cases, I think, we'd better not ignore the SERR_INTERNEL. Right?
>>
>> Yeah, I noticed the difference.  I don't really care but I was thinking
>> that SERR_INTERNAL might be set in other similar situations too.  e.g.
>> TF error from ATA device or what not, so I thought it would be safer to
>> ignore the bit altogether.  You probably need to consult your hardware
>> people about when exactly the bit misbehaves but unless proven
>> otherwise, I'd prefer to always ignore the bit.  Also, please rename the
>> enum constant and flag name.
>>
> 
> Thank you, Tejun!
> I was discussing with our HW designers on this topic. It is a HW
> design issue and will be fixed in SB700, the next generation of
> AMD/ATI southbridge.
> 
> The correct walkaround/solution for SB600 SATA is:
> 1. ignore SERR_INTERNAL for both ATA and ATAPI device (as you suggested
> :p ).
> 2. ignore SERR_INTERNAL only on IRQ_TF_ERR.
> 
> I'll re-create the patch.
> 
> Conke
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

