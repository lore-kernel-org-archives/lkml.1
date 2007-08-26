Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbXHZURG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbXHZURG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 16:17:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753007AbXHZUQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 16:16:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:65294 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbXHZUQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 16:16:54 -0400
Subject: Re: [patch 09/14] Convert from class_device to device for SPI
From: Kay Sievers <kay.sievers@vrfy.org>
To: David Brownell <david-b@pacbell.net>
Cc: Tony Jones <tonyj@suse.de>, linux-kernel@vger.kernel.org
In-Reply-To: <200708261254.14641.david-b@pacbell.net>
References: <20070820224806.154198000@suse.de>
	 <200708231403.52846.david-b@pacbell.net>
	 <1187907172.3632.43.camel@lov.localdomain>
	 <200708261254.14641.david-b@pacbell.net>
Content-Type: text/plain
Date: Sun, 26 Aug 2007 22:20:54 +0200
Message-Id: <1188159654.4445.73.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.6.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18vVksM+twXhM7FrlPVEQnjJNVR2ckseU2RWGQ
 deBOfOQaBdLtvEMWb1kDYfkxRUJwGUl2F1SruRBakKHNboooCj
 3b02/ZOtlGJu2CzIjKkRJFDwmeYhuKi
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-08-26 at 12:54 -0700, David Brownell wrote:
> On Thursday 23 August 2007, Kay Sievers wrote:
> > On Thu, 2007-08-23 at 14:03 -0700, David Brownell wrote:
> > > On Tuesday 21 August 2007, Tony Jones wrote:
> > > > I believe this is the necessary documentation changes.
> > > 
> > > Thanks.  I have an update, plus updates for the mmc_spi
> > > driver (now in MM) which you didn't update.
> > > 
> > > By the way, it's worth noting an incompatibility introduced
> > > through these conversions and CONFIG_SYSFS_DEPRECATED=n:
> > > 
> > >  ...
> > >  
> > >  - now, /sys/class/spi_master/spi2 is a symlink to
> > >    .../controller/spi_master (with DEPRECATED=n).
> > 
> > Ugh! Are you sure, that is doesn't point to:
> >   .../controller/spi_master/spi2/ ?
> 
> Turns out that it does -- once you tell Minicom to change its
> bogus default of discarding data rather than line wrapping!
> Which means there can still be multiple class instances that
> get coupled to a given physical device; no lossage there.

Great.

> Sigh.  It's hard sometimes to remember to apply all the
> right bug workarounds, when some of them are in userspace.

Yeah, it's a mess, I totally know that feeling. :)

> Still, that's a needless incompatibility.  Why isn't that
> pointing to a .../controller/spi_master:spi2 directory,
> so that the pathnames don't change (only symlink polarity)?

The directory name is the kernel's kobject name used by userspace, we
can't change the name. Most of these names are used to name the device
nodes.

Also the link would just point to the direct child directory with the
same name, which would be kind of strange. We could add them back, if
really needed, but they didn't exist for long, so we think it's fine to
get rid of them when !DEPRECATED is used.

With the hierarchy of class devices in recently changed subsytems, it
would be totally inconsistent to make a difference between a class
device parent/child (no "device" link, no <class>:<devname> link) and a
bus device parent/child (links). For userspace, there is no interesting
difference between class or bus device parents.

These links are really only needed with the !DEPRECATED mode, with the
directories all spread around in different places, and you need to use
these magic links to reconstruct the virtual device tree from it. They
are the counterpart of the "device" link which is also not too useful in
!DEPRECATED mode, because it's always just the next parent device.

With !DEPRECATED we get a big unified device tree with all devices in
_one_ hierarchy. All Child/parent relationships can be read by just
walking the up and down the tree. All the classification directories
(bus/, class/, block/) will only be lists of symlinks pointing to a
specific entry point in the unified tree. From there you can walk upward
or downwards the path, without any magic rules.

Thanks,
Kay

