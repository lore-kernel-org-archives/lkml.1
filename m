Return-Path: <linux-kernel-owner+w=401wt.eu-S935485AbZLGQ42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935485AbZLGQ42 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 11:56:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935444AbZLGQ4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 11:56:25 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37457 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935443AbZLGQ4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 11:56:23 -0500
Date: Mon, 7 Dec 2009 16:56:28 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: cbou@mail.ru, dwmw2@infradead.org, LKML <linux-kernel@vger.kernel.org>,
       linux-embedded@vger.kernel.org, Brian Swetland <swetland@google.com>
Subject: Re: [POWER] battery calibration parameters from sysfs
Message-ID: <20091207165628.GA24981@rakim.wolfsonmicro.main>
References: <A6D19A13FE030A409EC4362C172E091F0E0495F6@eseldmw101.eemea.ericsson.se>
 <20091204104930.GA28625@sirena.org.uk>
 <A6D19A13FE030A409EC4362C172E091F0E071EB9@eseldmw101.eemea.ericsson.se>
 <20091207114825.GA26965@rakim.wolfsonmicro.main>
 <A6D19A13FE030A409EC4362C172E091F0E0A1FA1@eseldmw101.eemea.ericsson.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A6D19A13FE030A409EC4362C172E091F0E0A1FA1@eseldmw101.eemea.ericsson.se>
X-Cookie: Editing is a rewording activity.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07, 2009 at 03:07:15PM +0100, Linus Walleij wrote:
> [Mark wrote]

> > These files should only be present if we have data for them.  
> > Userspace can't be reliant on them at present since relatively few 
> > systems seem to implement them, for example none of my laptops
> > have time_to, energy_ or capacity attributes.

> Well, yeah, we're not exactly in the laptop business.
> (But my HP laptop nc2400 has the "charge_*" attributes,
> 4990000 uAh in "charge_now" and this corresponds to
> what is shown in g-p-m converted over to Wh, but I don't
> know exactly where it's getting it from...)

Looking at what PCs are doing is often a useful guide as to what the
desktop userspace stacks will be trying to use - if you can't get the
information from a Dell or whatever then the chances are they'll cope
fine without it.  Of course, laptop batteries tend to be rather more
fancy in terms of their embedded controllers if nothing else.

> One of the things we're facing is Android, which has
> its userspace in plain Java JNI at the end of this link:
> http://android.git.kernel.org/?p=platform/frameworks/base.git;a=blob;f=s
> ervices/jni/com_android_server_BatteryService.cpp;h=8e7cadc6b680fc420d34
> 1faa094c71922946fdab;hb=HEAD

Something word wrapped that link but I think I found the same code.

> If you browse down to line 275 you can see it parse the sysfs
> attribute "capacity", then this propagates up to the battery
> status indicator on *all* Android phones out there. So if
> you want to run Android unmodified, this is what you need to
> provide. They are effectively using the power sysfs as
> their hardware abstraction layer in this case.

Oh dear.  Using the power sysfs as the hardware abstraction seems
perfectly reasonable but assuming that a given battery driver is going
to have this level of information doesn't match up with an awful lot of
actual charger hardware.  My main concern here is that battery
performance monitoring has no pressing need to be in kernel and that
pushing it into the kernel creates a barrier to implementing more
advanced schemes in userspace, which is especially serious given how
involved this needs to be in order to be accurate.  

I'm not sure how familiar you are with the issues surrounding trying to
do a voltage to charge mapping for a battery but it's much more complex
than a simple table if you want to get it accurate.  There's a lot of
dependence on particular operating conditions and things do change as
the batteries age.  There are systems out there that do the work
required to gather the information in hardware and it's definitely good
to report the information from them but that doesn't mean it's a good
idea to try to synthesise the information for other systems.

We should at least explore the possibility of getting Android to improve
their userspace code rather than put this sort of code into the kernel.
I've CCed Brian in in case he can comment on the possibility of doing
that.

> Note: I'm not claiming that Android is doing it right or that
> we can't modify this code or so, it's just that this is the way
> a few million Android devices out there are actually doing it.

I don't think the existing Android devices are much of an issue here,
it's not as though end users have the ability modify the firmware on
them (modulo the fairly small number of ADP devices).  This is an issue
for people producing new devices who are already going to be doing some
development to get the kernel up and running on their hardware.
