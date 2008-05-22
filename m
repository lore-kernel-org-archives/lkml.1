Return-Path: <linux-kernel-owner+w=401wt.eu-S934059AbYEVJeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934059AbYEVJeb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 05:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933320AbYEVJd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 05:33:58 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:31654 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932795AbYEVJd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 05:33:56 -0400
Date: Thu, 22 May 2008 11:32:58 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
       Andrew Morton <akpm@linux-foundation.org>,
       Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       David Woodhouse <dwmw2@infradead.org>,
       Ralf Baechle <ralf@linux-mips.org>,
       Thomas Gleixner <tglx@linutronix.de>, rtc-linux@googlegroups.com,
       i2c@lm-sensors.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH 6/6] RTC: Trivially probe for an M41T80 (#2)
Message-ID: <20080522113258.3dff7eed@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.55.0805202057380.31790@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0805130303430.535@cliff.in.clinika.pl>
	<20080513142829.2d737424@hyperion.delvare>
	<Pine.LNX.4.55.0805131759580.7267@cliff.in.clinika.pl>
	<20080519223718.3c89aa40@hyperion.delvare>
	<Pine.LNX.4.55.0805202057380.31790@cliff.in.clinika.pl>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maciej,

On Tue, 20 May 2008 21:26:42 +0100 (BST), Maciej W. Rozycki wrote:
> > As I wrote above: the I2C device will be listed as present forever. I
> > believe it's pretty confusing to have a device listed
> > under /sys/bus/i2c/devices which is in fact not present on the system.
> 
>  It somehow escaped me a sysfs entry would be present even before the 
> driver for this device has been loaded.  You are right, of course.
> 
> > On top of that, in case of modular setups with proper coldplug support,
> > the I2C device driver will be loaded automatically when the device is
> > declared, but will not be removed automatically when the probe fails,
> > so this is wasted memory.
> 
>  We used to support module unloading unconditionally -- I keep forgetting
> this was lifted at one point.  Personally I do not think removing the
> requirement for modules to support unloading was a good decision and here
> is a good example where it hurts, but obviously we have to live with
> whatever consequences of that decision we have.

Whether the unneeded module can be removed or not, is a side problem
(which I didn't even have in mind at first, thanks for pointing it
out.) The main problem is that, even if you can remove the module, the
device you declared is still visible, even though it's not on the
system - and that's confusing.

> > The comparison with ISA devices does not hold: ISA devices are created
> > by their own drivers (much like the legacy I2C device drivers.) Thus,
> > when the probe fails, they can simply delete the device they created (or
> > even better, they can delay the device creation until they are sure
> > that the device is there.) New-style I2C device drivers do not create
> > their devices, so they don't get a chance to delete them nor to delay
> > their creation.
> 
>  Sometimes you may have to use a device-specific probe sequence and this
> is where my comparison is right.  You cannot always escape with random
> poking at the device done by the core.  For example some devices have
> additional manufacturer/device ID registers -- only the respective drivers
> will know which ones are acceptable.  Others may get badly hurt -- not
> necessarily broken, but for example reconfigured undesirably -- as a
> results of blind accesses.

What you describe here doesn't fit in the platform device declaration
model. The platform code is supposed to know what hardware is present,
with all the required configuration details. Not being certain that a
given device is there or not, as was the case for your RTC chip, is
already a variation from the standard theme. Being uncertain what chip
is at a given address would be completely off-track IMHO. That would be
much like the PC SMBus' realm where the hardware monitoring chips are
probed automatically, i.e. we do not follow the device driver model at
all. These are the legacy i2c device drivers we are trying to get rid
of at the moment, even though the plan on how to do this is still vague.

>  Although I agree a generic probe would work with both RTC chips under
> question here.
> 
> > It could certainly be implemented in terms of i2c_new_probed_device()
> > in i2c-sibyte, if it was a proper platform driver with proper platform
> > data. I admit it wouldn't be necessarily very elegant, in particular if
> > we have more similar cases in the future. That could still do for now,
> > though. Converting i2c-sibyte to a proper platform driver is needed
> > anyway.
> 
>  No question about the conversion -- it's just unlikely to happen soon.
> 
> > The flag in struct i2c_board_info would trigger the exact same probing
> > mechanism as i2c_new_probed_device() does. The whole point it to test
> > for the presence of the device _before_ its driver is loaded. It you
> > have to let the I2C device driver decide, then it's already too late:
> > the I2C device is created and it won't go even if the probe fails.
> 
>  That sounds like a limitation, although perhaps there is not enough
> justification to lift it.  I can certainly imagine a flag telling the
> driver: "Please check if this device is there for me [=the core] as the
> complication behind that is beyond my capabilities."

Again this would not fit well within the device driver model, as you
would have to load the driver before you know if you really need it.
I agree that we might have to resort to this in some cases (I have
hwmon drivers in mind as I write this.) However, my original idea was
rather to have a single module dedicated to identification of a given
type of I2C devices (say hwmon), that would act as an helper for
i2c-core, letting it instantiate the right I2C devices (in turn
triggering the loading of the appropriate device drivers.)

An alternative would be to delegate the identification task to a
user-space helper. This would however require that new-style I2C
devices can be created and removed from user-space, which isn't the
case yet.

Anyway, I don't expect embedded platforms to need this. That's more
likely to be needed only by hwmon drivers on the PC, and possibly some
old v4l drivers.

> > If said probing mechanism doesn't work properly for some devices, we'll
> > improve it, but it has to stay in i2c-core.
> 
>  No doubt as it is good enough for many devices.

-- 
Jean Delvare
