Return-Path: <linux-kernel-owner+w=401wt.eu-S1753078AbXDIISj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078AbXDIISj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 04:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbXDIISj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 04:18:39 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3004 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078AbXDIISh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 04:18:37 -0400
Date: Mon, 9 Apr 2007 09:18:24 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [RFC] pata_icside driver
Message-ID: <20070409081824.GA28366@flint.arm.linux.org.uk>
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Jeff Garzik <jgarzik@pobox.com>
References: <20070330110022.GA21653@flint.arm.linux.org.uk> <20070330110800.GB21653@flint.arm.linux.org.uk> <20070408101826.GA5431@flint.arm.linux.org.uk> <20070408210917.6e306851@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070408210917.6e306851@the-village.bc.nu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 08, 2007 at 09:09:17PM +0100, Alan Cox wrote:
> > +	/*
> > +	 * DMA is based on a 16MHz clock
> > +	 */
> > +	if (ata_timing_compute(adev, adev->dma_mode, &t, 1000, 1))
> > +		return;
> 
> This seems strange for a 16MHz clock.

We do this because, although the underlying clock is 16MHz, the DIOR
and DIOW signals go through a bit of logic and are not synchronised
to this clock.

As explained in the comments above:

+ *     Type    Active          Recovery        Cycle
+ *     A       250 (250)       312 (550)       562 (800)
+ *     B       187 (200)       250 (550)       437 (750)
+ *     C       125 (125)       125 (375)       250 (500)
+ *     D       62  (50)        125 (375)       187 (425)
+ *
+ * (figures in brackets are actual measured timings on DIOR/DIOW)

The figures outside the brackets are the documented timings on the host
bus, but these are not what the drive sees.  The timings which the drive
sees are those in brackets.

The timings the drive sees clearly are not based upon a 16MHz clock
period.  Therefore, I'd prefer to get the nanoseconds from the
calculation and work from that.

> > +
> > +	/*
> > +	 * Now, properly adjust the timings.  If we have a 62.5ns clock
> > +	 * period and we ask for MWDMA2, it calculates the following
> > +	 * timings: active 125ns, recovery 62.5ns, cycle 125ns.
> > +	 * Quite obviously bogus. 
> 
> NAK. 
> 
> At this point you need to work out why you are getting bogus results and
> fix it or demonstrate a bug in the core code and fix that.

Obviously I can demonstrate a bug. 8)

Lets say that we want to do MW DMA mode 2.  This has the minimum timing
of 70ns active, 25ns recovery, 120ns cycle time.

When you quantise those figures using a clock period of 62.5ns (16MHz)
you end up with: 2 clocks active (2*62.5 > 70), 1 clock recovery
(1*62.5 > 25) and 2 clocks cycle (2*62.5 > 120).

Last time I checked, active + recovery must always be equal to the cycle
time, and unless my math is failing me, 2 + 1 does not equal 2.

It's quite obvious that returning the active time _equal_ to the cycle
time is even more utterly bogus - that means you're asking for the signal
to remain active for the entire cycle without any recovery.

So, you probably need to incorporate that logic from pata_icside into the
libata core.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
