Return-Path: <linux-kernel-owner+w=401wt.eu-S1423135AbXBIAYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423135AbXBIAYh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 19:24:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423086AbXBIAYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 19:24:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41105 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423078AbXBIAYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 19:24:35 -0500
Date: Thu, 8 Feb 2007 16:23:25 -0800
From: Greg KH <greg@kroah.com>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: James Simmons <jsimmons@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       Marcin Juszkiewicz <openembedded@hrw.one.pl>
Subject: Re: Git backlight subsystem tree
Message-ID: <20070209002325.GA29979@kroah.com>
References: <1170901826.5859.2.camel@localhost.localdomain> <Pine.LNX.4.64.0702081520110.824@pentafluge.infradead.org> <1170957595.5849.11.camel@localhost.localdomain> <Pine.LNX.4.64.0702081830520.7686@pentafluge.infradead.org> <20070208212314.GA21165@kroah.com> <1170978623.5849.63.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170978623.5849.63.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 08, 2007 at 11:50:23PM +0000, Richard Purdie wrote:
> Hi Greg,
> 
> On Thu, 2007-02-08 at 13:23 -0800, Greg KH wrote:
> > On Thu, Feb 08, 2007 at 06:32:02PM +0000, James Simmons wrote:
> > > I CC Greg to explain. The backlight class didn't go away. The way it is 
> > > handled is different.
> > 
> > Have a pointer to the patch so I can help explain better?
> 
> You've been cc'd on the proposed patch a couple of times in this thread
> so it should be in your mailbox now.
> 
> > As a short summary, 'struct class_device' is going away.  Using a
> > 'struct device' in its place is what the conversion should have just
> > done, no functionality change otherwise.
> 
> The backlight class is drivers/video/backlight/backlight.c and if I
> understand things correctly what shows up in sysfs changes.
> 
> At the moment (as I understand the code which could be wrong), the
> backlight functionality is tagged onto an existing device. Taking
> drivers/video/backlight/corgi_bl.c as an example, the corgi_bl device
> exists under /sys/devices/platform/corgi_bl with an associated struct
> device. The backlight code then appends some magic to this to link in
> some class attributes that show up under /sys/class/backlight. There is
> only ever one device.
> 
> By replacing class_device_register() with device_create(), the proposed
> patch appears to generate a second struct device with the original as
> its parent. I'm not sure where it appears in /sys/devices? Having
> another full blown struct device around makes me uneasy as wherever it
> appears, we only have one device, not two.

No, your blacklight "device" is also a device now, not just a
class_device.  You want to show that heirachy properly for a variety of
different reasons (power management being one of the most important.)

> If I had some kind of platform device which had an LED, backlight and
> say battery component and registered with the three appropriate classes
> would that mean four struct devices? Where under /sys/devices do they
> each appear?

Under the main device itself, as they are children of it.

As an example, look at a sound device now on 2.6.20 with
CONFIG_SYSFS_DEPRECATED turned off:

$ tree /sys/class/sound/
/sys/class/sound/
|-- adsp -> ../../devices/pci0000:00/0000:00:1b.0/card0/adsp
|-- audio -> ../../devices/pci0000:00/0000:00:1b.0/card0/audio
|-- card0 -> ../../devices/pci0000:00/0000:00:1b.0/card0
|-- controlC0 -> ../../devices/pci0000:00/0000:00:1b.0/card0/controlC0
|-- dsp -> ../../devices/pci0000:00/0000:00:1b.0/card0/dsp
|-- mixer -> ../../devices/pci0000:00/0000:00:1b.0/card0/mixer
|-- pcmC0D0c -> ../../devices/pci0000:00/0000:00:1b.0/card0/pcmC0D0c
|-- pcmC0D0p -> ../../devices/pci0000:00/0000:00:1b.0/card0/pcmC0D0p
|-- pcmC0D1p -> ../../devices/pci0000:00/0000:00:1b.0/card0/pcmC0D1p
|-- seq -> ../../devices/virtual/sound/seq
|-- sequencer -> ../../devices/virtual/sound/sequencer
|-- sequencer2 -> ../../devices/virtual/sound/sequencer2
`-- timer -> ../../devices/virtual/sound/timer

There are a bunch of mixer and other interfaces, all now real devices
under the proper PCI device (sound added the "card0" intermediate level
also, but you will not have that for your devices.

> Also, it was mentioned that a parent struct device is a requirement and
> this isn't the case for all backlight users. I think this constraint on
> device_create has been removed in more recent code though? 

Yes, if NULL is passed in, it will be created in the
/sys/devices/virtual/CLASS_NAME/ directory.  See the above "seq" and
"timer" devices as an example of that.

Hope this helps,

greg k-h
