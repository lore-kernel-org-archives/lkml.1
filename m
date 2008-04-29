Return-Path: <linux-kernel-owner+w=401wt.eu-S1758287AbYD2B6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758287AbYD2B6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 21:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbYD2B6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 21:58:06 -0400
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.150]:56800
	"EHLO outbound.icp-qv1-irony-out4.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751203AbYD2B6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 21:58:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlsBAFgdFkh8qMj2/2dsb2JhbAAIrAI
X-IronPort-AV: E=Sophos;i="4.25,719,1199631600"; 
   d="scan'208";a="213341629"
Subject: Re: [patch/rfc 2.6.25-git] gpio: sysfs interface
From: Ben Nizette <bn@niasdigital.com>
To: David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>, Trent Piepho <tpiepho@freescale.com>,
       hartleys <hartleys@visionengravers.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200804281744.11564.david-b@pacbell.net>
References: <200804281239.51729.david-b@pacbell.net>
	 <1209423678.14631.27.camel@moss.renham>
	 <200804281744.11564.david-b@pacbell.net>
Content-Type: text/plain
Organization: Nias Digital
Date: Tue, 29 Apr 2008 11:58:04 +1000
Message-Id: <1209434284.14631.71.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-04-28 at 17:44 -0700, David Brownell wrote:
> On Monday 28 April 2008, Ben Nizette wrote:
> > On Mon, 2008-04-28 at 12:39 -0700, David Brownell wrote:
> > > 
> > >   echo "export 23" > /sys/class/gpio/control
> > > 	... will gpio_request(23, "sysfs") and gpio_export(23); use
> > > 	/sys/class/gpio/gpio-23/direction to configure it.
> > >   echo "unexport 23" > /sys/class/gpio/control
> > > 	... will gpio_free(23)
> > 
> > Righteo, so if the kernel explicitly gpio_export()s something, it won't
> > be gpio_request()ed allowing multiple "owners" making driver debugging 
> > easier. 
> 
> The gpio_export() call requires someone (the caller!) to
> have requested the GPIO already.  The "one owner" rule is
> not being changed.

Owner's probably the wrong word.  I was just confirming that in that
case the request/export caller and userspace can both fiddle with the
pin.  Though of course the caller should expect this and behave
appropriately.

> 
> 
> > Most of the time though we don't want to be able to clobber the 
> > kernel's gpios
> 
> Right.  Not unless we're debugging the driver managing
> those GPIOs.
> 
> 
> > so the control file wizardry isn't so much to cope with 
> > incomplete board support, rather it's the way all regular (ie
> > non-driver-debugging) gpio access is started..?
> 
> Well, I wouldn't call that "regular"!  But then, I don't
> have this "use GPIOs from userspace" focus.  To me, that's
> the exception not the rule.
> 

Ah well we're backwards there, though now I think of it I can't think of
a great many valid use-cases on my side.  Just for funzies I'll post on
the avrfreaks AVR32 support forum and see how many I can actually dig
up.

> 
> > Or do you class any 
> > situation where userspace needs primary gpio control as a BSP omission
> > as there Should Be a formal in-kernel driver for it all?
> 
> I suppose I'd prefer to see a formal gpio_export() call from
> the kernel as part of the BSP, if that's the model for how that
> particular board stack should be used.  But I suspect there will
> be differing opinions on that point, especially from folk who
> avoid custom kernels for whatever reasons.  (Like, "that binary
> has been qualified, this one hasn't.")
> 

Keeping track of which pins aren't used for peripherals then requesting
and exporting them is going to be a pain even for smaller SoCs.  But as
you say, the BSP designer can just opt out if they can't be bothered.

Actually, in, eg AVR32 at32ap we'd have to keep track of all this anyway
so we can call at32_select_gpio() and make the pins ready for pio access
anyway.  Bugger.

>  
> > Also, gpio number discovery can be done through the debugfs interface
> > already in gpiolib
> 
> ... intended purely for debugging, not for use with production
> systems ...
> 
> 
> > but once you've got a userspace gpio interface which 
> > relies on gpio numbering like this that information ceases to be simple
> > debugging and becomes pretty mission-critical.  IMO it would make more
> > sense to shuffle it in to /sys/class/gpio with all this stuff or at
> > least offer a cut-down chip-to-range mapping in a file here.
> 
> I don't follow what you're saying here.  GPIO numbering is deeply
> specific to the hardware; so I'd say the relevant hardware docs are
> what become mission-critical.  The kernel can't know when some
> field update has rewired a bunch of GPIOs, for example...
> 
> Trent pointed out that dynamic range assignment can make trouble,
> so I can see some help might be needed here.  Were you suggesting
> something like a /sys/class/gpio/chips file with contents like
> 
> 	0-15	gpio
> 	16-31	gpio
> 	32-47	gpio
> 	48-63	gpio
> 	192-207	mpuio
> 	208-213	tps65010
> 
> (Matching a stock OMAP 5912 OSK board, for what it's worth.)

Yeah that's the kind of a thing.  Would be well worth having that info
especially for dynamically allocated chip bases.

> 
> 
> > > The D-space footprint is negligible, except for the sysfs resources
> > > associated with each exported GPIO.  The additional I-space footprint
> > > is about half of the current size of gpiolib.  No /dev node creation
> > > involved, and no "udev" support is needed.
> > 
> > Which is good for simplicity but makes async notification kinda tricky.
> 
> Sysfs attributes are supposed to be pollable.  I've not done it,
> but fs/sysfs/file.c::sysfs_notify() looks relevant ...

Right, that'll work.

> 
> 
> > I would suggest that a lack of pin-change signalling is going to be a
> > problem for people who've become accustomed to having it in their
> > out-of-tree interfaces.  Probably not a showstopper here but certainly
> > something which will slow the uptake of this interface.
> 
> We accept patches.   Even patches on top of patches.  ;)

I'll wait for a final(ish) version and a spare millisecond and see what
might be done :-)

--Ben.

> 
> - Dave
>  
