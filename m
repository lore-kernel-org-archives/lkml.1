Return-Path: <linux-kernel-owner+w=401wt.eu-S1754731AbYGGNGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbYGGNGv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 09:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753400AbYGGNGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 09:06:43 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:25662 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbYGGNGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 09:06:43 -0400
Date: Mon, 7 Jul 2008 15:06:29 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Hans Verkuil <hverkuil@xs4all.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: device/driver binding notification
Message-ID: <20080707150629.4d31d51c@hyperion.delvare>
In-Reply-To: <1215434491.23585.19.camel@linux.site>
References: <20080705205455.7e6579ea@hyperion.delvare>
	<1215434491.23585.19.camel@linux.site>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kay,

Thanks for your quick reply.

On Mon, 07 Jul 2008 14:41:31 +0200, Kay Sievers wrote:
> On Sat, 2008-07-05 at 20:54 +0200, Jean Delvare wrote:
> > Hi Greg, hi Kay,
> > 
> > In the course of finally making the i2c subsystem comply with the Linux
> > 2.6 device driver model, I am facing an issue which affects many v4l
> > drivers. I'm curious if the core device driver code has something to
> > offer to solve it.
> > 
> > Basically, a v4l driver creates an i2c bus, instantiates i2c devices on
> > that bus, and needs i2c chip drivers for these devices. In the past, i2c
> > devices were always bound to a driver by the time the v4l driver knew
> > they existed, so they were directly usable. But now that we follow the
> > device driver model, this is no longer the case. The sequence of events
> > is as follows:
> > 
> > 1* v4l driver creates i2c bus.
> > 
> > 2* v4l driver declares i2c devices in that bus.
> >    At this point, the v4l driver can't be used yet.
> > 
> > 3* Later on, the drivers for these devices in question are loaded
> >    (typically thanks to udev), and they bind to the i2c devices.
> > 
> > 4* Now the v4l driver can complete its initialization and users can make
> >    use of the device.
> > 
> > For now, between steps 2 and 3, I made the v4l driver sleep and
> > repeatedly check whether i2c_client.driver is set or not. It works but
> > it's pretty ugly. I am curious if there's a way to be notified when a
> > driver is finally bound to a given device? That's what I would need.
> 
> Is this what you are looking for? BUS_NOTIFY_BOUND_DRIVER:
>   http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=116af378201ef793424cd10508ccf18b06d8a021

Looks really good :) Thanks for the pointer. I'll get back to you if
it doesn't work for me, but apparently it should.

> > This also raises another question on reference counting. Ideally, the
> > i2c chip drivers shouldn't be allowed to be removed before the v4l
> > driver itself is (without the i2c chip drivers, the v4l drivers cannot
> > work properly.) So I would like to increase the reference count to the
> > i2c chip drivers when they bind to my chips, and decrease it when I
> > quit. Should I just do a try_module_get(i2c_driver.driver.owner) at a
> > random time and just hope for the best? Or is there a cleaner way to
> > express that kind of dependency between drivers?
> 
> Shouldn't the v4l device take a reference on the i2c device which will
> prevent the i2c device to go away?

They do eventually take a reference to the i2c device, but that's not
really the point. They control the life cycle of the device anyway, so
it's not going away. What the v4l drivers want to protect themselves
against, is said i2c device being unbound from its driver, because they
just can't work properly if they can't delegate a part of the work to
the i2c drivers.

My hope was that we could take a reference to the modules that provide
the drivers in question at the time they bind, so that they simply
can't be removed until we say it's safe, but I guess it wouldn't
protect us against manual unbind from sysfs. Unless there is a way to
block manual unbind, too?

In theory I guess that the v4l drivers should expect the i2c device to
be unbound and they should put themselves on hold when this happens,
until the devices are bound again, at which point they would need to
resync or reinitialize everything. However in practice this seems to
add a lot of complexity to the drivers, to handle a case which should
never happen in practice, so I'm reluctant to go that way.

Thanks,
-- 
Jean Delvare
