Return-Path: <linux-kernel-owner+w=401wt.eu-S1756865AbZLERpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865AbZLERpg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 12:45:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756709AbZLERpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 12:45:35 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48579 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756639AbZLERpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 12:45:34 -0500
Date: Sat, 5 Dec 2009 17:45:33 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: cbou@mai.ru, dwmw2@infradead.org, LKML <linux-kernel@vger.kernel.org>,
       linux-embedded@vger.kernel.org
Message-ID: <20091205174532.GA25808@sirena.org.uk>
References: <A6D19A13FE030A409EC4362C172E091F0E0495F6@eseldmw101.eemea.ericsson.se>
 <20091204104930.GA28625@sirena.org.uk>
 <A6D19A13FE030A409EC4362C172E091F0E071EB9@eseldmw101.eemea.ericsson.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A6D19A13FE030A409EC4362C172E091F0E071EB9@eseldmw101.eemea.ericsson.se>
X-Cookie: Don't feed the bats tonight.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.240.126
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [POWER] battery calibration parameters from sysfs
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 05, 2009 at 02:08:11PM +0100, Linus Walleij wrote:
> [Mark Brown]
> > [Linus Walleij]

> > Isn't the standard thing here to handle this voltage to 
> > capacity mapping in userspace if we're just extrapolating
> > from experimental results?

> That's an easy solution of course, but then the sysfs files
> specified by the power subsystem, i.e. all "charge_*",
> "energy_*", "capacity" and "time_to_*" loose their meaning
> and must be ignored by userspace.

I'd not expect them to be there at all in this case - certainly existing
drivers aren't reporting all these properties, even for relatively smart
batteries with embedded controllers like those in laptops.  For example,
the laptop I'm typing this on only reports charge, current and voltage
properties and doesn't have capacity, enegy or time to information.

> Also this was just an example, we have similar calibration
> for the temperature sensor, and thus the "temp" sysfs file
> also loose its meaning.

Sure, there's an awful lot of performance information that isn't
available from hardware and has to be interpolated.

> Since there is a plethora of userspace apps that just
> interface these files directly (gnome-power-manager and
> the Android stack come to mind) all these will have to
> be patches to accept a calibrated value from somewhere
> else if we shall use them with our hardware.

I was under the impression that at least GNOME was already working on
doing this themselves, based on data gathered at runtime rather than
pre-provided data tables, but I'm not turning anything up right now so I
might be imagining things.  If a userspace implementation is done right
I'd expect that it'd be possible to share the heavy lifting between the
various applications, and even with an in-kernel implementaiton we'll
need userspace to know to save and restore any data that needs to
persist over reboots.

> But as you say:

> > Even with the "smart" batteries in PCs there are some 
> > accuracy concerns and obviously the performance of the
> > battery will change over time.
> > ...
> > Actually, one further thing here - if this functionality
> > is implemented in kernel then shouldn't it be a generic
> > feature rather than part of the driver?  The idea of
> > mapping battery voltages to capacity percentages isn't
> > specific to a given charger and will apply to all
> > batteries using the same technology.

> Surely, we'd be happy to do it that way if desired.
> What about drivers/power/battery_lib.c?

I guess.  Probably if it's going to be in the kernel ought to just be
part of the power core and kick in automatically if properties it can
estimate aren't supplied by the driver.

> (And getting algorithms in place for gradually
> adjusting the capacity levels as compared to factory
> settings for PC batteries would perhaps end up in the
> same place then.)

I'm still not entirely seeing why this needs to be in the kernel.  It
sounds like the main push here is to fit in with existing applications
but given that these properties aren't reliably available at on current
systems I'd be a bit surprised if applications were relying on this
interface already.  Are there reasons for doing things this way other
than existing applications?

> As for the calibration format, after reading up on the
> latest sysfs doc I saw:

...

> This is close to that, an array of two types (x,y)(x,y)
> voltage,capacity,voltage,capacity etc. Pushing them in
> two files

> /sys/.../v_vs_cap_v
> /sys/.../v_vs_cap_cap

> and then make sure we write as many values to each array
> is uglier IMHO.

TBH I don't think there's going to be a nice way of doing this via
sysfs.  I'm not sure if one of the other filesystems such as configfs
might be a bit more suitable for this application.  The difficulty in
defining an ABI is another thing that makes it seem like doing this in
the kernel is the wrong approach.
