Return-Path: <linux-kernel-owner+w=401wt.eu-S934278AbZLGLsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934278AbZLGLsW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 06:48:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934163AbZLGLsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 06:48:22 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46474 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933770AbZLGLsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 06:48:21 -0500
Date: Mon, 7 Dec 2009 11:48:25 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: cbou@mail.ru, dwmw2@infradead.org, LKML <linux-kernel@vger.kernel.org>,
       linux-embedded@vger.kernel.org
Subject: Re: [POWER] battery calibration parameters from sysfs
Message-ID: <20091207114825.GA26965@rakim.wolfsonmicro.main>
References: <A6D19A13FE030A409EC4362C172E091F0E0495F6@eseldmw101.eemea.ericsson.se>
 <20091204104930.GA28625@sirena.org.uk>
 <A6D19A13FE030A409EC4362C172E091F0E071EB9@eseldmw101.eemea.ericsson.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A6D19A13FE030A409EC4362C172E091F0E071EB9@eseldmw101.eemea.ericsson.se>
X-Cookie: To teach is to learn.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 05, 2009 at 02:08:11PM +0100, Linus Walleij wrote:
> [Mark Brown]

> > Isn't the standard thing here to handle this voltage to 
> > capacity mapping in userspace if we're just extrapolating
> > from experimental results?

> That's an easy solution of course, but then the sysfs files
> specified by the power subsystem, i.e. all "charge_*",
> "energy_*", "capacity" and "time_to_*" loose their meaning
> and must be ignored by userspace.

These files should only be present if we have data for them.  Userspace
can't be reliant on them at present since relatively few systems seem to
implement them, for example none of my laptops have time_to, energy_ or
capacity attributes.

> Also this was just an example, we have similar calibration
> for the temperature sensor, and thus the "temp" sysfs file
> also loose its meaning.

Sure, and with temperature sensors tables of design based information
might be more appropriate since it's not possible to gain experimenal
data from the running system in the way we can for batteries.

> Since there is a plethora of userspace apps that just
> interface these files directly (gnome-power-manager and
> the Android stack come to mind) all these will have to
> be patches to accept a calibrated value from somewhere
> else if we shall use them with our hardware.

At least GNOME seems to already be collecting historical statistics on
the battery performance.  I believe it's factoring the results into the
values reported through the UI but I'd need to check.

> > Actually, one further thing here - if this functionality
> > is implemented in kernel then shouldn't it be a generic
> > feature rather than part of the driver?  The idea of

> Surely, we'd be happy to do it that way if desired.
> What about drivers/power/battery_lib.c?

If we're going to do it at all.  Ideally it'd just kick in automatically
when data isn't available so possibly it ought to be core code rather
than a library used by drivers.

> (And getting algorithms in place for gradually
> adjusting the capacity levels as compared to factory
> settings for PC batteries would perhaps end up in the
> same place then.)

I'm still not convinced that it's a good idea to put this into the
kernel.

So far as I can see the main case for doing it in kernel is existing
userspace - is there any other motivation I've overlooked?  Like I say
I'd be somewhat surprised if userspace were relying on this data given
that we're not currently generating it and it's going to need at least
some userspace work to save and restore the data.  There's also policy
issues about how often you do the monitoring and so on.

> We have other odd code. Actually we have full software-
> controlled CC/CV charging in our driver, and that
> would *definately* go in such a library if it was
> to end up in kernelspace. We have actually
> pushed that to userspace, while I still tend to think
> that the kernel (with right parameters) should be able
> to charge a battery. But, well.

As was previously discussed (in another thread) I do think there needs
to be at least some in kernel part to charger code like this in order to
ensure that we're robust against userspace failure and cope well with
suspend and resume.  There's the potential for serious hardware damage
if the battery is mistreated.

> As for the calibration format, after reading up on the
> latest sysfs doc I saw:

There's other kernel filesystems that might be more approprite for this
sort of stuff, trying to fit this into sysfs really does feel like far
too much pain to be right.
