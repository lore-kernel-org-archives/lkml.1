Return-Path: <linux-kernel-owner+w=401wt.eu-S1756044AbYE0RQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044AbYE0RQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 13:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751107AbYE0RQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 13:16:41 -0400
Received: from trinity.fluff.org ([89.145.97.151]:41578 "EHLO
	trinity.fluff.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbYE0RQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 13:16:40 -0400
Date: Tue, 27 May 2008 18:16:56 +0100
From: Ben Dooks <ben@fluff.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>, spi-devel-general@lists.sourceforge.net,
       Jonathan Cameron <Jonathan.Cameron@gmail.com>,
       linux-kernel@vger.kernel.org, LM Sensors <lm-sensors@lm-sensors.org>
Subject: Re: [spi-devel-general] Accelerometer, Gyros and ADC's etc within the kernel.
Message-ID: <20080527171656.GA870@trinity.fluff.org>
References: <4832A211.4040206@gmail.com> <20080520132817.03fb74ea@hyperion.delvare> <20080521093520.ZZRA012@mailhub.coreip.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080521093520.ZZRA012@mailhub.coreip.homeip.net>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.9i
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 09:49:42AM -0400, Dmitry Torokhov wrote:
> On Tue, May 20, 2008 at 01:28:17PM +0200, Jean Delvare wrote:
> > Hi Jonathan,
> > 
> > On Tue, 20 May 2008 11:04:01 +0100, Jonathan Cameron wrote:
> > > This email is basically a request for opinions on how and where such sensors
> > > should be integrated into the kernel.
> > > 
> > > To set the scene...
> > > 
> > > Increasing numbers of embedded devices are being supplied attached MEMS
> > > devices (www.xbow.com imote2 etc). Along with more traditional sensors such
> > > as ADC's not being used for hardware monitoring, these do not really 
> > > seem to
> > > fit with in an particular subsystem of the kernel.  A previous 
> > > discussion on
> > > lkml in 2006 considered the accelerometers to be found within some laptop
> > > hard drives, but I haven't been able to track down any more general 
> > > discussions
> > > of such non hardware monitoring sensors.
> > > 
> > > The obvious possibilities are:
> > > 
> > > * To place the various drivers within the spi / i2c etc subsystems as 
> > > relevant.
> > 
> > Bad idea. Grouping drivers by connectivity is almost always the wrong
> > thing to do, as it means that different persons will maintain them and
> > they have all chances to diverge. You really want to group drivers by
> > functionality. On top of that, I am busy enough maintaining the i2c
> > core and bus drivers without having more i2c device drivers added to my
> > plate. These days I am trying to _empty_ drivers/i2c/chips, if anything.

I concur for these sorts of devices, where the connectivity to the
device is quite an easy part of the driver, thus you end up with tiny
little bus drivers all over the place, and a main core driver. The kernel
build system should allow easy selection of interface depending on what
is available without huge #ifdef hacks. An example could be:

Makefile:
mysensor-y		:= mysensor-core.o
mysensor-$(CONFIG_SPI)	+= mysensor-spi.o
mysensor-$(CONFIG_I2C)	+= mysensor-i2c.o
obj-$(CONFIG_MYSENSOR)	+= mysensor.o

> > > * To place within the hwmon subsystem as this is probably closest.
> > > (there is already at least one straight ADC driver in hwmon)
> > 
> > Probably not the wisest choice, if nothing else, because the hwmon
> > maintainer is already overloaded. And I don't think that these devices
> > have much in common with the traditional hardware monitoring components
> > anyway.
> > 
> > I'm not sure what "straight ADC driver" you are referring to, but
> > anything which measures a voltage and exports the reading to user-space
> > is, well, a voltage sensor, and thus fix within hwmon. If the same chip
> > is used for a higher-level, dedicated function then we would probably
> > have a separate driver for it, outside of hwmon.
> > 
> > > * To create a new subsystem, or perhaps merely sysfs class to contain these
> > >   elements.
> > 
> > Would be OK. Or:
> > 
> > * Place these within the input subsystem. You might want to discuss
> > this with the input subsystem maintainer Dmitry Torokhov (Cc'd). The
> > Wii remote is essentially a joystick, and joysticks belong to the input
> > subsystem.
> > 
> 
> I don't think that input subsystem woudl be the best choice. While we
> do support the event-driven mechanism for delivering information to
> userspace input is mostly oriented for human interface devices, not
> general data acquisition. If anything input_dev is too fat. Another
> thing is that input layer anonymizes input devices, makes them
> capability-oriented. I.e. we dont really care what model of joystick
> we have, we want something that reports ABS_X, ABS_Y, BTN_FIRE and
> userpsace can use it whether it a simple analog joystick or something
> fancy and USB connected. For your purposes you probably do want to know
> what the device is and what exactly being sampled/measured.

Can you explain to me how the input system anonymizes things? I thought
it was quite easy to read the name of the device? You could easily add
a symlink from the driver's device binding in sysfs to the relevant
input device as well.

Also, why would you not want all your accelerometers grouped into a set
of accelerometers? If your application software just searches all input
devices for anything reporting itself as an accelerometer, then it would
get the right result... 

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

