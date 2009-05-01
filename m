Return-Path: <linux-kernel-owner+w=401wt.eu-S1751456AbZEAFbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456AbZEAFbj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 01:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750888AbZEAFba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 01:31:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33967 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750778AbZEAFb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 01:31:29 -0400
Date: Thu, 30 Apr 2009 22:29:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Jan Blunck <jblunck@suse.de>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev
 tmpfs
Message-Id: <20090430222900.c13b63d5.akpm@linux-foundation.org>
In-Reply-To: <1241097822.2516.3.camel@poy>
References: <1241097822.2516.3.camel@poy>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009 15:23:42 +0200 Kay Sievers <kay.sievers@vrfy.org> wrote:

> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: driver-core: devtmpfs - driver core maintained /dev tmpfs
> 
> Devtmpfs lets the kernel create a tmpfs very early at kernel
> initialization, before any driver core device is registered. Every
> device with a major/minor will have a device node created in this
> tmpfs instance. After the rootfs is mounted by the kernel, the
> populated tmpfs is mounted at /dev. In initramfs, it can be moved
> to the manually mounted root filesystem before /sbin/init is
> executed.

Lol, devfs.

> The tmpfs instance can be changed and altered by userspace at any time,
> and in any way needed - just like today's udev-mounted tmpfs. Unmodified
> udev versions will run just fine on top of it, and will recognize an
> already existing kernel-created device node and use it.
> The default node permissions are root:root 0600. Only if none of these
> values have been changed by userspace, the driver core will remove the
> device node when the device goes away. If the device node was altered
> by udev, by applying the appropriate permissions and ownership, it will
> need to be removed by udev - just as it usually works today.
> 
> This makes init=/bin/sh work without any further userspace support.
> /dev will be fully populated and dynamic, and always reflect the current
> device state of the kernel. Especially in the face of the already
> implemented dynamic device numbers for block devices, this can be very
> helpful in a rescue situation, where static devices nodes no longer
> work.
> Custom, embedded-like systems should be able to use this as a dynamic
> /dev directory without any need for aditional userspace tools.
> 
> With the kernel populated /dev, existing initramfs or kernel-mount
> bootup logic can be optimized to be more efficient, and not to require a
> full coldplug run, which is currently needed to bootstrap the inital
> /dev directory content, before continuing bringing up the rest of
> the system. There will be no missed events to replay, because /dev is
> available before the first kernel device is registered with the core.
> A coldplug run can take, depending on the speed of the system and the
> amount of devices which need to be handled, from one to several seconds.
> 
> ...
> 
>  block/bsg.c                         |    6 
>  drivers/gpu/drm/drm_sysfs.c         |    7 
>  drivers/input/input.c               |    6 
>  drivers/media/dvb/dvb-core/dvbdev.c |   10 +
>  drivers/usb/core/usb.c              |   11 +

These five subsystems were updated, but there are so many others.  Why
these five in particular?

> +const char *device_get_nodename(struct device *dev, const char **tmp)
> +{
> +	char *s;
> +
> +	*tmp = NULL;
> +
> +	/* the device type may provide a specific name */
> +	if (dev->type && dev->type->nodename)
> +		*tmp = dev->type->nodename(dev);

dev->type->nodename() might have failed due to -ENOMEM, in which case
it seems wrong to assume that it returned NULL for <whatever reason you
thought it might want to return NULL>.

It's all a bit confused.

> +	if (*tmp)
> +		return *tmp;
> +
> +	/* the class may provide a specific name */
> +	if (dev->class && dev->class->nodename)
> +		*tmp = dev->class->nodename(dev);
> +	if (*tmp)
> +		return *tmp;
> +
> +	/* return name without allocation, tmp == NULL */
> +	if (strchr(dev_name(dev), '!') ==  NULL)

s/  / /

> +		return dev_name(dev);
> +
> +	/* replace '!' in the name with '/' */
> +	*tmp = kstrdup(dev_name(dev), GFP_KERNEL);
> +	if (!*tmp)
> +		return NULL;
> +	while ((s = strchr(*tmp, '!')))
> +		s[0] = '/';
> +	return *tmp;
> +}
>
> ...
>
