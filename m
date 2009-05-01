Return-Path: <linux-kernel-owner+w=401wt.eu-S1753250AbZEAGRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbZEAGRl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 02:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbZEAGRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 02:17:33 -0400
Received: from kroah.org ([198.145.64.141]:57122 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681AbZEAGRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 02:17:32 -0400
Date: Thu, 30 Apr 2009 23:17:01 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jan Blunck <jblunck@suse.de>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev
	tmpfs
Message-ID: <20090501061701.GB19234@kroah.com>
References: <1241097822.2516.3.camel@poy> <20090430222900.c13b63d5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090430222900.c13b63d5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 10:29:00PM -0700, Andrew Morton wrote:
> On Thu, 30 Apr 2009 15:23:42 +0200 Kay Sievers <kay.sievers@vrfy.org> wrote:
> 
> > From: Kay Sievers <kay.sievers@vrfy.org>
> > Subject: driver-core: devtmpfs - driver core maintained /dev tmpfs
> > 
> > Devtmpfs lets the kernel create a tmpfs very early at kernel
> > initialization, before any driver core device is registered. Every
> > device with a major/minor will have a device node created in this
> > tmpfs instance. After the rootfs is mounted by the kernel, the
> > populated tmpfs is mounted at /dev. In initramfs, it can be moved
> > to the manually mounted root filesystem before /sbin/init is
> > executed.
> 
> Lol, devfs.

Well, devfs "done right" with hopefully none of the vfs problems the
last devfs had. :)

> >  block/bsg.c                         |    6 
> >  drivers/gpu/drm/drm_sysfs.c         |    7 
> >  drivers/input/input.c               |    6 
> >  drivers/media/dvb/dvb-core/dvbdev.c |   10 +
> >  drivers/usb/core/usb.c              |   11 +
> 
> These five subsystems were updated, but there are so many others.  Why
> these five in particular?

These are the ones that create a subdirectory in /dev/   None of the
others do.

> > +const char *device_get_nodename(struct device *dev, const char **tmp)
> > +{
> > +	char *s;
> > +
> > +	*tmp = NULL;
> > +
> > +	/* the device type may provide a specific name */
> > +	if (dev->type && dev->type->nodename)
> > +		*tmp = dev->type->nodename(dev);
> 
> dev->type->nodename() might have failed due to -ENOMEM, in which case
> it seems wrong to assume that it returned NULL for <whatever reason you
> thought it might want to return NULL>.
> 
> It's all a bit confused.

I'll let Kay answer this one.

> > +	if (*tmp)
> > +		return *tmp;
> > +
> > +	/* the class may provide a specific name */
> > +	if (dev->class && dev->class->nodename)
> > +		*tmp = dev->class->nodename(dev);
> > +	if (*tmp)
> > +		return *tmp;
> > +
> > +	/* return name without allocation, tmp == NULL */
> > +	if (strchr(dev_name(dev), '!') ==  NULL)
> 
> s/  / /

good catch.  I've edited that in the version of this patch in my tree.

thanks,

greg k-h
