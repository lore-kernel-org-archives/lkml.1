Return-Path: <linux-kernel-owner+w=401wt.eu-S933360AbYD3XP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933360AbYD3XP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 19:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760099AbYD3XPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 19:15:09 -0400
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107]:14745
	"EHLO outbound.icp-qv1-irony-out2.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763688AbYD3XPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 19:15:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqEBANqZGEh8qMj2/2dsb2JhbAAIrW0
X-IronPort-AV: E=Sophos;i="4.25,730,1199631600"; 
   d="scan'208";a="308892058"
Subject: Re: [patch/rfc 2.6.25-git v2] gpio: sysfs interface
From: Ben Nizette <bn@niasdigital.com>
To: Trent Piepho <tpiepho@freescale.com>
Cc: David Brownell <david-b@pacbell.net>, lkml <linux-kernel@vger.kernel.org>,
       hartleys <hartleys@visionengravers.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
In-Reply-To: <Pine.LNX.4.64.0804301511120.1537@t2.domain.actdsltmp>
References: <200804281239.51729.david-b@pacbell.net>
	 <1209521291.311.99.camel@moss.renham>
	 <200804301042.42513.david-b@pacbell.net>
	 <200804301434.25211.david-b@pacbell.net>
	 <Pine.LNX.4.64.0804301511120.1537@t2.domain.actdsltmp>
Content-Type: text/plain
Organization: Nias Digital
Date: Thu, 01 May 2008 09:14:58 +1000
Message-Id: <1209597298.3377.20.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-04-30 at 15:47 -0700, Trent Piepho wrote:
> On Wed, 30 Apr 2008, David Brownell wrote:
> > Simple sysfs interface for GPIOs.
> >
> >    /sys/class/gpio
> >    	/control ... to request a GPIO be imported or returned
> >        /gpioN ... for each exported GPIO #N
> > 	    /value ... always readable, writes fail for input GPIOs
> > 	    /direction ... r/w as: in, out (default low); write high, low
> > 	/gpiochipN ... for each gpiochip; #N is its first GPIO
> > 	    /base ... (r/o) same as N
> > 	    /label ... (r/o) descriptive, not necessarily unique
> > 	    /ngpio ... (r/o) number of GPIOs; numbered N .. N+(ngpio - 1)
> 
> "simple"?  What I had was a lot simpler.
> 
> So, I want to set gpio 5 on a pcf9557 extender.
> 
> cat 1 > /sys/class/gpio/pcf9557-0:0
> 
> But now I can't do this anymore, it has to be harder.  So how do I do it?

We've discussed the down sides of your model.  It's got up sides, eg
your use case is made very easy, but it ain't all roses.

Now, if the kernel has requested that pin and hasn't exported it you
can't touch it.  This is what we want.

Otherwise you will walk the gpiochips, find your chip's base and use it
to calculate the gpio number.  If the kernel's exported it then the file
will be there to use.  If the kernel hasn't requested it then you can do
so by using the control file.

Yes it's longer and harder and more convoluted.  It's also much more
safe.

>   It
> doesn't seem very considerate to ignore the real use cases of the person who
> wrote the code to begin with.
> 
> > GPIOs may be exported by kernel code using gpio_export(), which should
> > be most useful for driver debugging.  Userspace may also ask that they
> 
> I have a JTAG interface implemented via GPIOs.  With my system, one can see
> the gpios used in sysfs with the proper labels (TCK, TDO, TDI, etc.).  This is
> very helpful for people connecting something to the interface to know they
> have the write gpio lines connected.  What's the point of allowing
> one to label gpio lines if it's not going to be easy to see?

That label was always just supposed to be a debugging aid, i.e.
something to show up in debugfs.  This is used to reduce D footprint.
Maybe if the labels are being stored anyway they can be made available
through sysfs as well as debugfs?

> 
> It also means that if they have trouble getting what their connecting to work,
> they can always control the line via sysfs and see with a probe that it
> changes.  They can raise TRST (which they know is the right line from the
> label) and see the system reset.

That's very useful indeed, but if you don't want userspace to be able to
do that it's also dangerous.  This is why the kernel has to explicitly
allow it.

> 
> Adding gpio_export() calls to the kernel source and recompiling and
> re-flashing just isn't going to happen for a large portion of users.
> 
> Why can't the gpio lines just show up when something requests them?

So you want userspace to be able to clobber any gpio which is used by
the kernel?  That's what this version of the interface is designed to
avoid!

> 
> > be imported by writing to the sysfs control file, helping to cope with
> > incomplete board support:
> >
> >  echo "23" > /sys/class/gpio/control
> > 	... will gpio_request(23, "sysfs") and gpio_export(23); use
> 
> So if a driver is already using gpio 23, then there is no way to see it in
> sysfs, since the gpio_request() will fail?

The way to see it in sysfs is to have the kernel export it.  This is the
point.  The kernel should request it for it's own use then export it if
it wants userspace to be able to touch it as well.

> 
> > 	/sys/class/gpio/gpio-23/direction to configure it.
> >  echo "-23" > /sys/class/gpio/control
> > 	... will gpio_free(23)
> 
> So if a driver was already using gpio 23 and you wanted to look at it from
> userspace, you'll free it from both sysfs and the driver that was using it
> when you're done?

If driver was using it, it will have requested it.  If you are looking
at it then the kernel must have also exported it.  If the kernel's
exported it then nothing you can do will unexport it.  You can only
unexport gpios you've exported yourself manually and the only gpios you
can do this to are ones unused by the driver.

> 
> > +When a kernel driver has requested a GPIO, it may only be made available
> > +in the sysfs interface by gpio_export().  This prevents userspace code
> > +from clobbering important state.
> 
> You could say the same about 90% of the writable files in sysfs.
