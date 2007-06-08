Return-Path: <linux-kernel-owner+w=401wt.eu-S967291AbXFHNK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967291AbXFHNK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 09:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968607AbXFHNJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 09:09:23 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:48188 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968449AbXFHNJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 09:09:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=HY0CDxolSd1V1UF6hVtBjiDtTluNbP4ldO1tSlk4uFAHSszxOESrSjuZkyXu9MdRaN1NwOrZStAtJbUXkbQrFtS6WvuV4axMA0c4kMABK2egXi7hvkvsBXFM+OE35Wlma2uH+bz9Nx+z+tK0wffjpAgrq6J7nZzOgyM3fEDu02g=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: HPT374 IDE problem with 2.6.21.* kernels
Date: Fri, 8 Jun 2007 14:33:24 +0200
User-Agent: KMail/1.9.6
Cc: Geller Sandor <wildy@petra.hos.u-szeged.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
References: <Pine.LNX.4.62.0705301112170.1260@petra.hos.u-szeged.hu> <200706050300.56079.bzolnier@gmail.com> <46655AEA.4020906@ru.mvista.com>
In-Reply-To: <46655AEA.4020906@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200706081433.25181.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 June 2007, Sergei Shtylyov wrote:
> Hello.
> 
> Bartlomiej Zolnierkiewicz wrote:
> 
> >>>>>>>The log of a typical IDE reset is available here:
> 
> >>>>>>>http://petra.hos.u-szeged.hu/~wildy/syslog.gz
> 
> >>>>>>>This was the worst case: the IDE bus was resetted during the system 
> >>>>>>>boot.
> 
> >>>>>>  Could you try setting HPT374_ALLOW_ATA133_6 to 0 in
> >>>>>>drivers/ide/pci/hpt366.c and rebuild/reboot the kernel?
> 
> >>>>>Hi Sergei,
> 
> >>>>>This looks promising. Using a vanilla 2.6.22-rc3 I was able to reproduce
> >>>>>the problem within a few seconds. With the above modification the 
> >>>>>machine
> >>>>>is running under heavy disk I/O without problems since 30 minutes...
> 
> >>>>Did it fix the problem for good?
> 
> >>>It seems so far. There hasn't been any problem since I've applied the fix.
> 
> >>>>Sergei, do we need to disallow UDMA6 completely on HPT734 or
> >>>>is it only an issue with some problematic devices (=> blacklist)?
> 
> >>    Note that I didn't change what the old code was doing in this regard -- 
> >>although the HPT374 spec does *not* say that UDMA6 is supported, it had been 
> >>enabled. What have *really* changed for HPT374 was:
> 
> >>- in 2.6.20-rc1, the driver switched to using the actual 33 MHz timing table
> >>   instead of the old one, matching 50 MHz (and so, severely underclocked);
> 
> >>- in 2.6.2-rc1, the driver switched from 33 MHz PCI to 66 MHz DPLL clock.
> 
> >>    Disallowing UDMA6 would clock the chip with 50 MHz DPLL, howewer, the 
> 
> > I felt inspired by this explanation (thanks!) and took a look at
> > hpt374-opensource-v2.10 vendor driver.  Here is something interesting:
> 
> > glbdata.c:
> 
> > ...
> > #ifdef CLOCK_66MHZ
> > ULONG setting370_66[] = {
> >         0xd029d5e,  0xd029d26,  0xc829ca6,  0xc829c84,  0xc829c62,
> >         0x2c829d2c, 0x2c829c66, 0x2c829c62,
> >         0x1c829c62, 0x1c9a9c62, 0x1c929c62, 0x1c8e9c62, 0x1c8a9c62,
> >         0x1c8a9c62/*0x1cae9c62*/, 0x1c869c62, 0x1c869c62,
> > };
> > ...
> 
> > hpt366.c:
> 
> > ...
> > static u32 sixty_six_base_hpt37x[] = {
> >         /* XFER_UDMA_6 */       0x1c869c62,
> >         /* XFER_UDMA_5 */       0x1cae9c62,     /* 0x1c8a9c62 */
> > ...
> 
> > So we are using Dual ATA Clock for UDMA5 whereas vendor driver doesn't
> 
>     This is so in all other HPT drivers (and HPT371N datasheet has the same 
> figures -- this chip is the only one supporting UDMA6 and having the default 
> DPLL clock > 50 MHz).  Note that it means that there's no actual UDMA5 since 
> the timing exactly matches that one used for UDMA4.
> 
> > (the only other mode which uses Dual ATA Clock, in both drivers, is rarely
> > used UDMA3).
> 
>     And UDMA4 with 50 MHz clock.
> 
> > Thanks to this UDMA cycle time should be equal 22.5ns instead of 30ns
> > (spec defines it at 16.8ns, ide_timings[] uses 20ns) when using 66 MHz DPLL
> > clock.  In theory everything should play nice but the data manual for HPT374
> 
>     And it does -- on other chips.

My beautiful theory failed... Oh, well... ;)

> > contains weird note that Dual ATA Clock is meant to implement ATA100 read
> > and write at different clocks (there is no more explanation to this).
> 
>     That's the thing that keeps me confused in the other datasheets too -- 
> from my interpretation of their timing figures it seemed to control 2x ATA 
> clock multipler. HPT370 datasheet just gives different timings and SCR2 values 
> for reads/writes in UDMA5 (I've disabled this mode on HPT370 from which the 
> read performance only gained -- not sure if it makes sense to restore the old 
> clock turnaround hack).
> 
> > Geller reported that the problems started after migrating from 2.6.20.7 to
> > 2.6.21.1 (the affected disks are using UDMA5) and at the same time the driver
> > switched from 33 MHz PCI to 66 MHz DPLL clock.  Also the issue is completely
> > fixed by using 50 MHz DPLL clock (UDMA5 timing for 50 MHz DPLL clock is
> > 0x12848242 so UDMA cycle time equals 20ns and is smaller than the one
> > obtained using 66 MHz DPLL clock).
> 
> 
> > It all makes me wonder whether it is really safe to use Dual ATA Clock for
> > UDMA5 and whether we should just be using "the offical" timing instead...
> 
>     Not sure. I had no problems with this on the HPT371N/302 and 371N was 
> clocked by 66 MHz DPLL from the start (its default clock is 75 MHz however).
>     I'm still holding to my hypothesis that HPT374 simply can't tolerate 66 
> MHz DPLL clock, and the UDMA5 timing figures that you've cited seem to prove that.
>     I'm going to post a patch today -- how about completely prohibiting UDMA6 
> on HPT374?

Sounds fine, in case somebody misses it we can introduce something like
hpt374_allow_66mhz_dpll module parameter...

Thanks,
Bart
