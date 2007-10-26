Return-Path: <linux-kernel-owner+w=401wt.eu-S1761620AbXJZTH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761620AbXJZTH0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 15:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750851AbXJZTHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 15:07:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:59798 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803AbXJZTHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 15:07:12 -0400
Subject: Re: fixing up DRM device model usage
From: Kay Sievers <kay.sievers@vrfy.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Greg KH <gregkh@suse.de>, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>
In-Reply-To: <200710261140.41016.jbarnes@virtuousgeek.org>
References: <200710181401.50470.jbarnes@virtuousgeek.org>
	 <200710260957.15137.jbarnes@virtuousgeek.org>
	 <3ae72650710261010p195e2228h91c9cb11829c2a77@mail.gmail.com>
	 <200710261140.41016.jbarnes@virtuousgeek.org>
Content-Type: text/plain
Date: Fri, 26 Oct 2007 21:08:58 +0200
Message-Id: <1193425738.2190.45.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19AKWpIUkGLqEWFaksdknvb5qEQrodvtx1zDbL
 oHBz/vSrYV8gsHKMSXaIRkBVF60HKNUXt7VpQ95m22QBd6teso
 P4jf2yG8kpMSrIqtlyqrtbxWYnIhBIA
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-26 at 11:40 -0700, Jesse Barnes wrote:
> On Friday, October 26, 2007 10:10 am Kay Sievers wrote:
> > On 10/26/07, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > > On Thursday, October 25, 2007 9:59 pm Greg KH wrote:
> > > > On Thu, Oct 25, 2007 at 04:53:18PM -0700, Jesse Barnes wrote:
> > > > > Ok, here's yet another version that uses the device model for
> > > > > the suspend/resume, rather than pci hooks.
> > > > >
> > > > > Greg, DRM desperately needs review of its device model usage,
> > > > > can you take a look at this patch and the current drm_sysfs.c
> > > > > code? Right now, we're mixing class_devices and regular devices
> > > > > (the latter seem to be required for suspend/resume to work
> > > > > correctly), but this seems wrong. Any ideas?  Should we just
> > > > > rip out the class_device stuff and create full-on DRM device
> > > > > nodes?
> > > >
> > > > The class_device stuff is already ripped out in the latest -mm
> > > > trees and I will be forwarding that change on for 2.6.25 after
> > > > 2.6.24 is out.  So yes, it should be taken away :)
> > > >
> > > > But converting from class_device to struct device does not mean
> > > > you use a "device node".  But you could if you want to :)
> > >
> > > Yeah, bad choice of words. :)
> > >
> > > To retain compatibility, we need to have directories under the DRM
> > > class dir (/sys/class/drm) for each card (e.g. card0) that contains
> > > a file describing which graphics driver is bound to the device. 
> > > For class devices, we could just add an attributes structure to the
> > > device.  Can we do the same with regular, non-class devices?
> >
> > The conversion is already queued in Greg's tree, and in -mm:
> > http://git.kernel.org/?p=linux/kernel/git/gregkh/patches.git;a=blob;f
> >=driver/drm-convert-from-class_device-to-device-in-drivers-char-drm.pa
> >tch;h=f993183d1cb017f981cc2232d17930af40459bd8;hb=HEAD
> >
> > /sys/class/drm will look the same as with the class_device's, only if
> > !CONFIG_SYSFS_DEPRECATED, there will be symlinks instead of
> > directories, otherwise the same pathes, like for all other
> > (converted) classes too.
> 
> How does this conversion look?

Seems fine, at a first look. You moved the device structure into the
object where it belongs, instead of allocating one, and saving the
pointer. You should really considering changing the core to do the
free()ing of your object with the embedded devices release function,
that is called when the last reference to the object is gone, instead of
"hoping the best". :) But if the drm core does that properly, it might
work, sure.

The open coded: device_create_file(&dev->dev, &device_attrs[i]) should
probably replaced by passing the array to the class, and the core will
do that for you. 

Do you assign the dev_t: MKDEV(DRM_MAJOR, head->minor) somewhere? You
need to put it in dev->devt, if you want a device node created by
userspace.

> It retains directory compatibility with
> the old scheme, but I'm not sure about the dev->dev.parent value.

You should use the same value as the old code:
  &(head->dev->pdev)->dev
and assign it as the parent, seems right..

> I'm using the PCI device corresponding to the DRM device as the parent, but
> maybe I don't need one at all?

Keep it, you want to express the relationship in sysfs, so that a
"device" link is created, or that the device directory lives as a child
below the parent device. Seems fine so far.

> Dave, the drm_head stuff is a bit funky; it seems like a partially
> implemented feature?  I wonder if we should rip that out too, just to
> keep things simple...

Hehe, that's always a solution. :)

Kay

