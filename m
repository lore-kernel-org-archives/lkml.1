Return-Path: <linux-kernel-owner+w=401wt.eu-S1752938AbYIXLdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbYIXLdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 07:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751879AbYIXLdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 07:33:06 -0400
Received: from mail.transmode.se ([83.241.175.147]:32549 "EHLO
	mail.transmode.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbYIXLdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 07:33:05 -0400
Subject: Re: UIO device name
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Reply-To: joakim.tjernlund@transmode.se
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: Paul Mundt <lethal@linux-sh.org>, gregkh@suse.de,
       Linux-Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080924102230.GB2973@local>
References: <1222248093.12624.188.camel@gentoo-jocke.transmode.se>
	 <20080924093551.GB7591@linux-sh.org>
	 <1222250279.12624.195.camel@gentoo-jocke.transmode.se>
	 <20080924102230.GB2973@local>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Transmode AB
Date: Wed, 24 Sep 2008 13:33:01 +0200
Message-Id: <1222255981.12624.215.camel@gentoo-jocke.transmode.se>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-24 at 12:22 +0200, Hans J. Koch wrote:
> On Wed, Sep 24, 2008 at 11:57:59AM +0200, Joakim Tjernlund wrote:
> > On Wed, 2008-09-24 at 18:35 +0900, Paul Mundt wrote:
> > > On Wed, Sep 24, 2008 at 11:21:33AM +0200, Joakim Tjernlund wrote:
> > > > As far as I can see there isn't a way to name the /dev/uio%d device file
> > > > to something more useful, is that so?
> > > > I would like to name the device file from within the kernel so I can
> > > > find the correct device from userspace.
> > > > The very least is to control the minor(%d) number.
> > > > 
> > > You have a couple of options for this:
> > > 
> > > 	- the 'name' sysfs entry for each of the uio devices, which
> > > 	  corresponds to the uio device name.
> > > 	- extracting the relevant data from things like 'lsuio'.
> > > 	- hooking in the pretty mame through udev to create an alias.
> > 
> > Right, but I want to do it from within the kernel when I create the
> > device because that the only place I truly know what HW the uio maps to.
> 
> Set info->name to something that's useful for the userspace part of the
> driver. You can create an individual string for each HW so userspace can
> easily identify the devices. The string in info->name can be anything
> you like, it's only used as info given in the "name" sysfs file.

All suggestions so far implies changes i 3 different areas, the kernel
needs to set a name, then udev(I am using mdev btw so that won't work
for me) or add some RC scripts to translate the name to the
wanted /dev/name and then the app needs to know the name.

The udev/scripts is pure overhead and makes it harder for me to have a
generic root FS. I don't see why not uio can offer the kernel to
select another name than the standard uio%d name.

> 
> > 
> > I found that this works:
> >  struct uio_info *info,
> >  struct uio_device *idev;
> > 
> >  idev = info->uio_dev;
> >  device_rename(idev->dev, "irq4");
> > 
> > but then I have to copy the private uio_device struct from uio.c
> 
> That's a clear sign that the UIO authors didn't want people to do that
> ;-)
> 
> > Is there a better way to get at idev->dev?
> 
> No hackery, please. The "name" attribute is there for this purpose, use
> it. Or use one of the other possibilities Paul mentioned.

Yes, this is a hack until UIO has a proper API for choosing a name other
than uio%d. Seems like it is very essy to do, just pass the wanted name
to __uio_register_device() and offer an new uio_register_device_name()
method or add a dev_name field to struct uio_info.

  Jocke
