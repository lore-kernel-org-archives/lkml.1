Return-Path: <linux-kernel-owner+w=401wt.eu-S1755014AbZEBHQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014AbZEBHQr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 03:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752442AbZEBHQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 03:16:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38181 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbZEBHQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 03:16:37 -0400
Date: Sat, 2 May 2009 03:16:36 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Jan Blunck <jblunck@suse.de>, linux-arch@vger.kernel.org,
       viro@zeniv.linux.org.uk, torvalds@osdl.org, akpm@osdl.org,
       adam@yggdrasil.com
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev
	tmpfs
Message-ID: <20090502071636.GA9487@infradead.org>
References: <1241097822.2516.3.camel@poy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241097822.2516.3.camel@poy>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 03:23:42PM +0200, Kay Sievers wrote:
> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: driver-core: devtmpfs - driver core maintained /dev tmpfs

Umm, guys this needs much broader discussion than just sneaking in
a patch under the covers.

It basically does re-introduce devfs under a different name, and from
looking at the implementation it might not be quite as bad a Gooch's
original, but it's certainly worse than Adam Richters rewrite the we
never ended up merging.

Now we might want to revisit the decision to leave all the device name
handling to a userspace daemon, because it provded to be quite fragile
under certain circumstances, and you apparently see performance issues.

> Devtmpfs lets the kernel create a tmpfs very early at kernel
> initialization, before any driver core device is registered. Every
> device with a major/minor will have a device node created in this
> tmpfs instance. After the rootfs is mounted by the kernel, the
> populated tmpfs is mounted at /dev. In initramfs, it can be moved
> to the manually mounted root filesystem before /sbin/init is
> executed.

That for example is something that is not acceptable.  We really don't
want the kernel to mess with the initial namespace in such a major way.

> The tmpfs instance can be changed and altered by userspace at any time,
> and in any way needed - just like today's udev-mounted tmpfs. Unmodified
> udev versions will run just fine on top of it, and will recognize an
> already existing kernel-created device node and use it.
> The default node permissions are root:root 0600. Only if none of these
> values have been changed by userspace, the driver core will remove the
> device node when the device goes away. If the device node was altered
> by udev, by applying the appropriate permissions and ownership, it will
> need to be removed by udev - just as it usually works today.

That's some really, really odd lifetime rules.


Counter-proposal:  Re-introduce a proper mini-devfs.  All nodes in there
are kernel-created and not changeable which sorts out that whole
mess of both drivers and userspace messing with tree topology we had
both in original devfs and this new devtmpfs.  Single-instance so it can be
populated before it's actually mounted somewhere, that way the kernel
doesn't have to do any policy devicision on where it's mounted.  Mount
point would usually be /dev/something so /dev can remaining udev-managed
tmpfs or even manually maintained and symlinks can point into
/dev/something.

> +static char *bsg_nodename(struct device *dev)
> +{
> +	return kasprintf(GFP_KERNEL, "bsg/%s", dev_name(dev));
> +}
> +
>  static int __init bsg_init(void)
>  {
>  	int ret, i;
> @@ -1082,6 +1087,7 @@ static int __init bsg_init(void)
>  		ret = PTR_ERR(bsg_class);
>  		goto destroy_kmemcache;
>  	}
> +	bsg_class->nodename = bsg_nodename;

And adding this gunk to every driver is really ugly.  Must say
late-devfs version of the same defintively was more pretty.

