Return-Path: <linux-kernel-owner+w=401wt.eu-S1764338AbYDOMTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764338AbYDOMTA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 08:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754696AbYDOMSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 08:18:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55237 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751677AbYDOMSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 08:18:51 -0400
Date: Tue, 15 Apr 2008 13:18:49 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Brownell <david-b@pacbell.net>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] wm97xx-core: Support use as a wakeup source
Message-ID: <20080415121849.GB24498@rakim.wolfsonmicro.main>
Mail-Followup-To: David Brownell <david-b@pacbell.net>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20080414173841.GA2213@rakim.wolfsonmicro.main> <1208194775-4293-3-git-send-email-broonie@opensource.wolfsonmicro.com> <20080414163033.ZZRA012@mailhub.coreip.homeip.net> <200804141729.08036.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804141729.08036.david-b@pacbell.net>
X-Cookie: He who hesitates is last.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 05:29:07PM -0700, David Brownell wrote:
> On Monday 14 April 2008, Dmitry Torokhov wrote:
> > Hmm, another unique module option... How about using device_can_wakeup()

The reason there are so many configuration options here is that many of
the features of the driver depend on exactly how the chip is connected
to the rest of the system and can't be automatically discovered.  In the
embedded applications where these devices are usually deployed this is
usually an OK user experience - if these hooks aren't provided what
tends to happen is that users patch the driver directly to get the
configurablilty they need.

> I don't quite follow the technical content of this "suspend_mode"
> mask, but it sure looks as if it should use the driver model flags
> in addition to whatever that mask is doing.

It's probably worth pointing out here that this part of the WM97xx
driver is split into two portions.  This part of the driver covers the
WM97xx itself but in order to actually use functionality like wakeup a
machine specific driver needs to be added.  The WM97xx chips have a
series of multi-function pins, some of which can be configured to
provide a signal mirroring the pen down status with most of the chip
powered down.  It can also be configured to do other things like try to
start the AC97 bus and/or start the touchscreen digitiser up if it
detects a pen down while suspended.

At the minute this is implemented by having the WM97xx register a child
device which platform code can provide.  When the child device probes it
configures both the WM97xx and the rest of the system.  The child device
can also provide other machine-specific things like use of the pen down
or interrupt signals from the chip to control when the touch screen is
read, synchronisation of the touch screen with writes to the display to
reduce interference from the video signals and accelerated reading of
the touchscreen if the AC97 controller is able to support it.

> There are two aspects to this:

>  (a) Whether on a given system the touchscreen *can* issue wakeup
>      events ... call device_init_wakeup(dev, true) to say it can.
>      In this case, presumably suspend_mode == 0 means it can't.
>      Board setup, or at latest probe(), should device_init_wakeup().

> So:  yes, this should initialize and use those driver model flags.

There is a bit of a question about which device this should be checked,
though the WM97xx itself is probably more sensible.

> > > +	reg = wm97xx_reg_read(wm, AC97_WM97XX_DIGITISER2);
> > > +	reg &= ~WM97XX_PRP_DET_DIG;
> > > +	if (wm->input_dev->users && suspend_mode)

> This should probably check device_may_wakeup(SOMEDEV), rather
> than testing suspend_mode.

That by itself isn't enough since if the system hasn't been configured
appropriately then the WM97xx won't be able to wake the system - we need
the suspend_mode configuration to know how to wake.  I'll do a spin of
the patch which pushes the configuration of suspend mode through an API
to let the core keep track of this.

> The wakeup mechanism here isn't clear to me.  Does this assume
> that the touchscreen IRQ is wakeup-capable?  I don't see any

No, it doesn't assume that.  For example, the system may wish to have
the chip initiate wakeup by bringing the AC97 bus up or have an output
from the WM97xx wired directly to some other component such as a PMU or
microcontroller rather than to an interrupt line visible to the CPU.

In theory this could also be used for some purpose other than waking the
system though I'm not aware of any such users so I don't think that's
worth worrying about right now.  In any case, the default is to enable
wakeup so most users won't notice this addition anyway.

> calls to enable_irq_wake() or disable_irq_wake() ... or for that
> matter any other calls that might affect system behavior.

Some combination of the machine-specific driver and other platform code
is expected to do this where required.

> > > +	/* WM97XX_PRP value to configure while system is suspended */
> > > +	u16 suspend_mode;

> I'm more accustomed to thinking that the driver will
> know "the" setup bit values to assign which will
> ensure that the chip issues wakeup events ... that
> stuff is usually not board-specific.

Unfortunately the fact that there are many different ways for the chip
to be used in a system (none of which can be automatically discovered)
means that this does need to be board-specific.
