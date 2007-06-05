Return-Path: <linux-kernel-owner+w=401wt.eu-S1761575AbXFEMoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761575AbXFEMoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 08:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756484AbXFEMoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 08:44:01 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:18301 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755603AbXFEMoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 08:44:00 -0400
Message-ID: <46655AEA.4020906@ru.mvista.com>
Date: Tue, 05 Jun 2007 16:45:30 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Geller Sandor <wildy@petra.hos.u-szeged.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: HPT374 IDE problem with 2.6.21.* kernels
References: <Pine.LNX.4.62.0705301112170.1260@petra.hos.u-szeged.hu> <Pine.LNX.4.62.0706031224030.25438@petra.hos.u-szeged.hu> <4662FC30.2000602@ru.mvista.com> <200706050300.56079.bzolnier@gmail.com>
In-Reply-To: <200706050300.56079.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

>>>>>>>The log of a typical IDE reset is available here:

>>>>>>>http://petra.hos.u-szeged.hu/~wildy/syslog.gz

>>>>>>>This was the worst case: the IDE bus was resetted during the system 
>>>>>>>boot.

>>>>>>  Could you try setting HPT374_ALLOW_ATA133_6 to 0 in
>>>>>>drivers/ide/pci/hpt366.c and rebuild/reboot the kernel?

>>>>>Hi Sergei,

>>>>>This looks promising. Using a vanilla 2.6.22-rc3 I was able to reproduce
>>>>>the problem within a few seconds. With the above modification the 
>>>>>machine
>>>>>is running under heavy disk I/O without problems since 30 minutes...

>>>>Did it fix the problem for good?

>>>It seems so far. There hasn't been any problem since I've applied the fix.

>>>>Sergei, do we need to disallow UDMA6 completely on HPT734 or
>>>>is it only an issue with some problematic devices (=> blacklist)?

>>    Note that I didn't change what the old code was doing in this regard -- 
>>although the HPT374 spec does *not* say that UDMA6 is supported, it had been 
>>enabled. What have *really* changed for HPT374 was:

>>- in 2.6.20-rc1, the driver switched to using the actual 33 MHz timing table
>>   instead of the old one, matching 50 MHz (and so, severely underclocked);

>>- in 2.6.2-rc1, the driver switched from 33 MHz PCI to 66 MHz DPLL clock.

>>    Disallowing UDMA6 would clock the chip with 50 MHz DPLL, howewer, the 

> I felt inspired by this explanation (thanks!) and took a look at
> hpt374-opensource-v2.10 vendor driver.  Here is something interesting:

> glbdata.c:

> ...
> #ifdef CLOCK_66MHZ
> ULONG setting370_66[] = {
>         0xd029d5e,  0xd029d26,  0xc829ca6,  0xc829c84,  0xc829c62,
>         0x2c829d2c, 0x2c829c66, 0x2c829c62,
>         0x1c829c62, 0x1c9a9c62, 0x1c929c62, 0x1c8e9c62, 0x1c8a9c62,
>         0x1c8a9c62/*0x1cae9c62*/, 0x1c869c62, 0x1c869c62,
> };
> ...

> hpt366.c:

> ...
> static u32 sixty_six_base_hpt37x[] = {
>         /* XFER_UDMA_6 */       0x1c869c62,
>         /* XFER_UDMA_5 */       0x1cae9c62,     /* 0x1c8a9c62 */
> ...

> So we are using Dual ATA Clock for UDMA5 whereas vendor driver doesn't

    This is so in all other HPT drivers (and HPT371N datasheet has the same 
figures -- this chip is the only one supporting UDMA6 and having the default 
DPLL clock > 50 MHz).  Note that it means that there's no actual UDMA5 since 
the timing exactly matches that one used for UDMA4.

> (the only other mode which uses Dual ATA Clock, in both drivers, is rarely
> used UDMA3).

    And UDMA4 with 50 MHz clock.

> Thanks to this UDMA cycle time should be equal 22.5ns instead of 30ns
> (spec defines it at 16.8ns, ide_timings[] uses 20ns) when using 66 MHz DPLL
> clock.  In theory everything should play nice but the data manual for HPT374

    And it does -- on other chips.

> contains weird note that Dual ATA Clock is meant to implement ATA100 read
> and write at different clocks (there is no more explanation to this).

    That's the thing that keeps me confused in the other datasheets too -- 
from my interpretation of their timing figures it seemed to control 2x ATA 
clock multipler. HPT370 datasheet just gives different timings and SCR2 values 
for reads/writes in UDMA5 (I've disabled this mode on HPT370 from which the 
read performance only gained -- not sure if it makes sense to restore the old 
clock turnaround hack).

> Geller reported that the problems started after migrating from 2.6.20.7 to
> 2.6.21.1 (the affected disks are using UDMA5) and at the same time the driver
> switched from 33 MHz PCI to 66 MHz DPLL clock.  Also the issue is completely
> fixed by using 50 MHz DPLL clock (UDMA5 timing for 50 MHz DPLL clock is
> 0x12848242 so UDMA cycle time equals 20ns and is smaller than the one
> obtained using 66 MHz DPLL clock).


> It all makes me wonder whether it is really safe to use Dual ATA Clock for
> UDMA5 and whether we should just be using "the offical" timing instead...

    Not sure. I had no problems with this on the HPT371N/302 and 371N was 
clocked by 66 MHz DPLL from the start (its default clock is 75 MHz however).
    I'm still holding to my hypothesis that HPT374 simply can't tolerate 66 
MHz DPLL clock, and the UDMA5 timing figures that you've cited seem to prove that.
    I'm going to post a patch today -- how about completely prohibiting UDMA6 
on HPT374?

> Thanks,
> Bart

WBR, Sergei
