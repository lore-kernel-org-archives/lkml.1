Return-Path: <linux-kernel-owner+w=401wt.eu-S1753889AbYGDS4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbYGDS4R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 14:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751262AbYGDSz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 14:55:59 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:29162 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbYGDSz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 14:55:58 -0400
X-BigFish: VPS-40(zz1432R98dR4015M7efV1805Mzz10d3izzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K3HWKQ-01-5FW-01
Date: Fri, 4 Jul 2008 20:55:42 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Alistair John Strachan <alistair@devzero.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: enable hpet=force for AMD SB400
Message-ID: <20080704185542.GC21102@alberich.amd.com>
References: <20080509094911.GG5023@alberich.amd.com> <alpine.LFD.1.10.0805100140490.3197@apollo.tec.linutronix.de> <20080509165501.a0fdb29d.akpm@linux-foundation.org> <200805110402.20327.alistair@devzero.co.uk> <alpine.LFD.1.10.0805111059190.3197@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805111059190.3197@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 04 Jul 2008 18:55:45.0370 (UTC) FILETIME=[90B0C3A0:01C8DE07]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2008 at 11:03:16AM +0200, Thomas Gleixner wrote:
> On Sun, 11 May 2008, Alistair John Strachan wrote:
> > either the Intel quirk should be consistent with the hpet=force usage, 
> > or "known correct" HPET overrides should just always be applied.
> 
> That's what we do. We have "known correct" for Intel and those which
> work on the patch submitters box w/o confirmation of the
> correctness. I guess the SB400 one can move into the "is correct"
> category, Andreas ???

Seems that I was too quick with the submission of my patch.  I have
done some testing in the past few weeks and there are severe problems
with HPET on IXP400/IXP450 which I was not aware of before.

The HPET on that chipset is usually not activated because it is not
fully compliant to the HPET spec. Using HPET on older revisions of
that chipset does not make sense at all.

For newer chipset revisions I found a working configuration, but ...

The only reliable configuration that worked in periodic _and_ one-shot
mode was to configure it such that HPET interrupt is delivered to INT2
of IOAPIC.

This means to force usage of HPET on IXP400/IXP450 needs a "manual"
IRQ0/INT2 override and some more chipset configuration to ensure that
the HPET interrupt is routed to INT2 of IOAPIC.

So this all is a big mess. And it probably explains why most (almost
all?) IXP400/IXP450 based systems do not provide an ACPI HPET table.

Said that, the question is, why would it still be worthwhile to force
usage of HPET on such systems. This is what sprang to my mind:

(1) availability of /dev/hpet for users

(2) faster timer programming

    From what I've seen setting up a timer in Linux' one-shot mode on
    SB400 (and also on SB600) is more than twice as fast when using
    HPET in comparison to PIT (on average).

(3) faster clocksource than acpi_pm

    E.g. on dual core K8 systems Linux cannot use TSC as clocksource.
    So usually it falls back to acpi_pm. IMHO access to HPET main
    counter is faster than using acpi_pm as clocksource. But I didn't
    determine exact numbers fot that.

(4) Viewer interrupts when Linux is running in NOHZ mode

    ... on systems where AMD C1E is enabled. If there is no HPET the
    Kernel falls back to PIT, but that one as just a 16-bit counter and
    overflows at least every 0.055 seconds.

(5) HPET is more accurate than PIT - as it has a smaller minimum delta
    (Examples for minimum delta according to /proc/timer_list are
    HPET:  3352 ns, PIT: 12571 ns.)

So far I have thought that (2) and (4) were helpful to save power on
my Turion X2 Laptop in NOHZ mode. But I recently did some evaluation
of that and it's rather negligible.

So there remain (1), (3) and (5) and I really tend to ignore HPET on
SB400 in the future. ;-(

It might even be worthwhile to disable it on systems where it's
advertised by an ACPI HPET table.

Any opinion about that last point?

In any case, please revert commit e8aa4667baf74dfd85fbaab86861465acb811085
The quirk is useless without doing more chipset an IOAPIC
configuration to ensure proper interrupt routing.


Thanks,

Andreas


