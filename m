Return-Path: <linux-kernel-owner+w=401wt.eu-S934277AbYD2AqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934277AbYD2AqX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 20:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756165AbYD2AqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 20:46:12 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:22089 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753723AbYD2AqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 20:46:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=wmopuPuFbEfulKP3WQepgUcnyy3FSxIXSTnfLydyMeTp2r16fGYn5U4CZBb+E4DtxDBsOL4imc4IstveN3mqkYRi8i+H7V41akdyFi1XyENempwMSkwa2qXeYw2etfWCyVjbvZTo7ciPJskWdRWaMhpiaJzqTZE4w2yzSFoo0yY=  ;
X-YMail-OSG: FBrBDkYVM1kqSGJttYRwPvHZixZRM7ejofVfW5mPT_m74XmQlqR2fbJTpCMoZFTo.L8q4kiBv8.8IM7gjjFTArZ4gNs8KBK4uV_h1ur4zu6DfqfGX9JCesQJo_D_BXp1ylU-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ben Nizette <bn@niasdigital.com>
Subject: Re: [patch/rfc 2.6.25-git] gpio: sysfs interface
Date: Mon, 28 Apr 2008 17:44:11 -0700
User-Agent: KMail/1.9.6
Cc: lkml <linux-kernel@vger.kernel.org>, Trent Piepho <tpiepho@freescale.com>,
       hartleys <hartleys@visionengravers.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200804281239.51729.david-b@pacbell.net> <1209423678.14631.27.camel@moss.renham>
In-Reply-To: <1209423678.14631.27.camel@moss.renham>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804281744.11564.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 April 2008, Ben Nizette wrote:
> 
> On Mon, 2008-04-28 at 12:39 -0700, David Brownell wrote:
> > Simple sysfs interface for GPIOs.
> > 
> >     /sys/class/gpio
> >         /gpio-N ... for each exported GPIO #N
> > 	    /value ... always readable, writes fail except for output GPIOs
> > 	    /direction ... writable as: in, out (default low), high, low
> >     	/control ... to request a GPIO be exported or unexported
> > 
> > GPIOs may be exported by kernel code using gpio_export(), which should
> > be most useful for driver debugging.  Userspace may also ask that they
> > be exported by writing to the sysfs control file, helping to cope with
> > incomplete board support:
> > 
> >   echo "export 23" > /sys/class/gpio/control
> > 	... will gpio_request(23, "sysfs") and gpio_export(23); use
> > 	/sys/class/gpio/gpio-23/direction to configure it.
> >   echo "unexport 23" > /sys/class/gpio/control
> > 	... will gpio_free(23)
> 
> Righteo, so if the kernel explicitly gpio_export()s something, it won't
> be gpio_request()ed allowing multiple "owners" making driver debugging 
> easier. 

The gpio_export() call requires someone (the caller!) to
have requested the GPIO already.  The "one owner" rule is
not being changed.


> Most of the time though we don't want to be able to clobber the 
> kernel's gpios

Right.  Not unless we're debugging the driver managing
those GPIOs.


> so the control file wizardry isn't so much to cope with 
> incomplete board support, rather it's the way all regular (ie
> non-driver-debugging) gpio access is started..?

Well, I wouldn't call that "regular"!  But then, I don't
have this "use GPIOs from userspace" focus.  To me, that's
the exception not the rule.


> Or do you class any 
> situation where userspace needs primary gpio control as a BSP omission
> as there Should Be a formal in-kernel driver for it all?

I suppose I'd prefer to see a formal gpio_export() call from
the kernel as part of the BSP, if that's the model for how that
particular board stack should be used.  But I suspect there will
be differing opinions on that point, especially from folk who
avoid custom kernels for whatever reasons.  (Like, "that binary
has been qualified, this one hasn't.")

 
> Also, gpio number discovery can be done through the debugfs interface
> already in gpiolib

... intended purely for debugging, not for use with production
systems ...


> but once you've got a userspace gpio interface which 
> relies on gpio numbering like this that information ceases to be simple
> debugging and becomes pretty mission-critical.  IMO it would make more
> sense to shuffle it in to /sys/class/gpio with all this stuff or at
> least offer a cut-down chip-to-range mapping in a file here.

I don't follow what you're saying here.  GPIO numbering is deeply
specific to the hardware; so I'd say the relevant hardware docs are
what become mission-critical.  The kernel can't know when some
field update has rewired a bunch of GPIOs, for example...

Trent pointed out that dynamic range assignment can make trouble,
so I can see some help might be needed here.  Were you suggesting
something like a /sys/class/gpio/chips file with contents like

	0-15	gpio
	16-31	gpio
	32-47	gpio
	48-63	gpio
	192-207	mpuio
	208-213	tps65010

(Matching a stock OMAP 5912 OSK board, for what it's worth.)


> > The D-space footprint is negligible, except for the sysfs resources
> > associated with each exported GPIO.  The additional I-space footprint
> > is about half of the current size of gpiolib.  No /dev node creation
> > involved, and no "udev" support is needed.
> 
> Which is good for simplicity but makes async notification kinda tricky.

Sysfs attributes are supposed to be pollable.  I've not done it,
but fs/sysfs/file.c::sysfs_notify() looks relevant ...


> I would suggest that a lack of pin-change signalling is going to be a
> problem for people who've become accustomed to having it in their
> out-of-tree interfaces.  Probably not a showstopper here but certainly
> something which will slow the uptake of this interface.

We accept patches.   Even patches on top of patches.  ;)

- Dave
 
