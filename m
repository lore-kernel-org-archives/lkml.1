Return-Path: <linux-kernel-owner+w=401wt.eu-S1756009AbZEBLfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbZEBLfO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 07:35:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753408AbZEBLe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 07:34:59 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:28025 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbZEBLe6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 07:34:58 -0400
MIME-Version: 1.0
In-Reply-To: <20090502071636.GA9487@infradead.org>
References: <1241097822.2516.3.camel@poy> <20090502071636.GA9487@infradead.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sat, 2 May 2009 13:34:42 +0200
Message-ID: <ac3eb2510905020434k57b561f7ld3db423f3dba26f0@mail.gmail.com>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev tmpfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Jan Blunck <jblunck@suse.de>, linux-arch@vger.kernel.org,
       viro@zeniv.linux.org.uk, torvalds@osdl.org, akpm@osdl.org,
       adam@yggdrasil.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 2, 2009 at 09:16, Christoph Hellwig <hch@infradead.org> wrote:
> >After the rootfs is mounted by the kernel, the
>> populated tmpfs is mounted at /dev. In initramfs, it can be moved
>> to the manually mounted root filesystem before /sbin/init is
>> executed.
>
> That for example is something that is not acceptable.  We really don't
> want the kernel to mess with the initial namespace in such a major way.

There is nothing like "mess around", it's not mounted at all, until
the kernel mounts the root filesystem at /, then devtmpfs is mounted
the first time, and only if it's compiled in because you asked for it.
Also, just try:
  egrep 'mknod|create_dev' init/*.c
and see what we currently do.

> Counter-proposal:  Re-introduce a proper mini-devfs.  All nodes in there
> are kernel-created and not changeable which sorts out that whole
> mess of both drivers and userspace messing with tree topology we had
> both in original devfs and this new devtmpfs.  Single-instance so it can be
> populated before it's actually mounted somewhere, that way the kernel
> doesn't have to do any policy devicision on where it's mounted.

That sounds worse than devtpfs, and does not help for most of the
mentioned problems we are trying to solve here.

> Mount
> point would usually be /dev/something so /dev can remaining udev-managed
> tmpfs or even manually maintained and symlinks can point into
> /dev/something.

And that would solve what? init=/bin/sh would still not work, you can
not bring your box up with that, and you have some pretty useless
unchangeable stuff hanging around in a /dev subdirectory?

>> @@ -1082,6 +1087,7 @@ static int __init bsg_init(void)
>>               ret = PTR_ERR(bsg_class);
>>               goto destroy_kmemcache;
>>       }
>> +     bsg_class->nodename = bsg_nodename;
>
> And adding this gunk to every driver is really ugly.  Must say
> late-devfs version of the same defintively was more pretty.

There are only a very few places who need this, there nothing ever
like "every driver". It's a very few subsystems, not even the drivers,
if they have more than one. Most device nodes do not have a
subdirectory and don't have that at all.

Thanks,
Kay
