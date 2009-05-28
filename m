Return-Path: <linux-kernel-owner+w=401wt.eu-S1762826AbZE1OWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762826AbZE1OWV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 10:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757039AbZE1OWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 10:22:13 -0400
Received: from trinity.fluff.org ([89.16.178.74]:43547 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756486AbZE1OWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 10:22:12 -0400
Date: Thu, 28 May 2009 15:22:08 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, Timur Tabi <timur@freescale.com>,
       Jon Smirl <jonsmirl@gmail.com>, Scott Wood <scottwood@freescale.com>,
       Janboe Ye <yuan-bo.ye@motorola.com>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Message-ID: <20090528142208.GB16199@trinity.fluff.org>
References: <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com> <20090527150527.GK6805@pengutronix.de> <87vdnm8sec.fsf@macbook.be.48ers.dk> <4A1D6901.2090508@freescale.com> <20090527175609.GB31861@flint.arm.linux.org.uk> <4A1D8FBA.6040802@freescale.com> <9e4733910905271213k7f4b93e7i7e6f2af24d85f@mail.gmail.com> <20090527192116.GA31110@n2100.arm.linux.org.uk> <20090527193927.GD30039@game.jcrosoft.org> <fa686aa40905271322x2f62c3dcs355374b30b4db3ca@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fa686aa40905271322x2f62c3dcs355374b30b4db3ca@mail.gmail.com>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 02:22:50PM -0600, Grant Likely wrote:
> On Wed, May 27, 2009 at 1:39 PM, Jean-Christophe PLAGNIOL-VILLARD
> <plagnioj@jcrosoft.com> wrote:
> > On 20:21 Wed 27 May     , Russell King - ARM Linux wrote:
> >> On Wed, May 27, 2009 at 03:13:55PM -0400, Jon Smirl wrote:
> >> > On Wed, May 27, 2009 at 3:08 PM, Scott Wood <scottwood@freescale.com> wrote:
> >> > > I'm not talking about platform specific code, I'm talking about code to
> >> > > retrieve information about a device from the device tree.  There would not
> >> > > be separate instances of this for "platforms X, Y and Z", just one
> >> > > of_platform binding in each driver.  It's no different than having a
> >> > > platform bus binding, except in the data structures used.
> >> > >
> >> > > But to restate, having external glue to create platform devices from the
> >> > > device tree is fine if that's what you want to do.  We used to do that, but
> >> > > it was a pain compared to keeping everything in one place.  Your experience
> >> > > may differ.
> >> >
> >> > Could 'struct platform_device' and 'struct of_platform_device" be
> >> > unified into a single structure? It's personal preference whether the
> >> > internal representation of the hardware is done via a device tree or
> >> > snippets of platform code, but do we need to have to different device
> >> > types?
> >>
> >> That's a damned good question - platform devices have been around since
> >> the dawn of the device model, so the real question which needs to be
> >> asked is: what was the reason that of_platform_device created rather
> >> than unifying it with the already provided platform_device ?
> > I agree at 100%
> >
> > when you have to support the same driver for non OF and OF platform it's
> > really a pain in the ass
> 
> There are two issues that keep the of_platform and platform busses
> separate.  They aren't show stoppers, but they reflect the current
> state.
> 
> 1) Source of data: a platform_device carries a pdata structure with it
> to describe the hardware.  An of_device carries a device_node pointer.
>  Before dropping of_platform bus, a mechanism needs to be in place to
> add hooks for translating the device tree data into a pdata structure
> for each platform device.
> 
> 2) Driver binding mechanism:  device tree nodes usually have a
> "compatible" property which is a list of strings.  The first string
> describes exactly what the device is (ie. "atmel,24c08") and an
> optional list of other devices which it is register interface
> backwards compatible with.  The intent is that newer devices can claim
> compatibility with older ones so that existing device drivers will
> work without needing to be told the new device name.  However, it
> leaves the option when a device errata or something similar raises
> it's ugly head, a driver can still get information about the exact
> device name and apply the appropriate workarounds.  Driver probing
> should walk the list and give preference to higher priority compatible
> values.  of_platform bus does this, but I cannot think of a clean way
> to do the same thing with the platform bus.
> 
> One option that has been suggested (more than once) is to make the
> adapter code an of_platform_driver which translates the device tree
> data and then registers the appropriate platform_devices.  This neatly
> solves the problem, but I don't like the overhead involved in
> registering 2 struct devices with the kernel for every device node in
> the device tree.

Surely the code could simply run at init time, throwing away the data
and code it doesn't need once it is done?

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

