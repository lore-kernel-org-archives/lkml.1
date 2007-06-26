Return-Path: <linux-kernel-owner+w=401wt.eu-S1757307AbXFZONS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbXFZONS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 10:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752236AbXFZONI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 10:13:08 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:47096
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbXFZONH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 10:13:07 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] hw_random: add quality categories
Date: Tue, 26 Jun 2007 16:12:26 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <200706241555.22957.mb@bu3sch.de> <20070626031340.GQ11166@waste.org>
In-Reply-To: <20070626031340.GQ11166@waste.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706261612.27184.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 June 2007 05:13:41 Matt Mackall wrote:
> On Sun, Jun 24, 2007 at 03:55:22PM +0200, Michael Buesch wrote:
> > This adds quality categories for hardware random number generators.
> > 
> ...
> > +
> > +/**
> > + * enum hwrng_quality - Quality identifier for RNG hardware
> > + * @HWRNG_QUAL_HIGH:	High quality RNG. Higher quality than
> > + * 			what is found on the usual PC mainboards.
> > + * 			Use that for special dedicated RNG
> > + * 			extension boards.
> > + * @HWRNG_QUAL_NORMAL:	PC-onboard-RNG devices.
> > + * @HWRNG_QUAL_LOW:	Low quality RNG devices. Use this for
> > + * 			devices which gather the entropy from possibly
> > + * 			bad sources, like the network.
> > + * @HWRNG_QUAL_PSEUDO:	Pseudo RNG device. Use this for devices
> > + * 			which are not RNG devices by definition, but
> > + * 			could be used as such. For example various
> > + * 			hardware sensors, like a motion sensor.
> > + */
> 
> I don't think these definitions are very useful.
...

No wait. You are missing the whole point of this
quality category.
The whole point of it is to prevent defaulting to a bad RNG, if
there's a bad and a good one in a machine.
Well, what's bad.
It's easy. HWRNGs like the one in bcm43xx are bad.
It's proprietary and nobody knows what it does (I guess
it gathers the entropy from the network or something
and hashes that in hardware).
So such a device would be QUAL_LOW.
_All_ HWRNGs that are shipped onboard in machines are
QUAL_NORMAL. There's no point in prefering an intel RNG
over and AMD RNG, although there might be differences.
These quality categories are only a _rough_ estimation
of how good the device is.
The reference frame for this estimation are the normal
onboard (or on-CPU) RNGs that are shipped.

This is _not_ a test to rule out your RNG extender board
for 10,000USD against the one which costs 100,000USD. They
would _both_ get QUAL_HIGH. So it's up to the user which
one of the devices he uses. But the important thing is that
this quality categories prevent the kernel from _defaulting_
to the in-CPU RNG, while a 10,000USD extender card is installed.

QUAL_LOW and QUAL_PSEUDO are _not_ to be used for real
HWRNGs. These categories are only for devices that can be used
to get entropy, _if_ there's nothing better in the machine.

Of would you like to generate your keys from entropy gathered
by your wireless-card, while you have a perfectly fine RNG in
your shiny CPU? This patch prevents that.
And you can still switch to your crappy wireless-card, if you
like that, in sysfs.

-- 
Greetings Michael.
