Return-Path: <linux-kernel-owner+w=401wt.eu-S1756214AbZEAQH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbZEAQH7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 12:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753765AbZEAQHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 12:07:50 -0400
Received: from kroah.org ([198.145.64.141]:49381 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290AbZEAQHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 12:07:50 -0400
Date: Fri, 1 May 2009 09:04:44 -0700
From: Greg KH <greg@kroah.com>
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: Chris Wedgwood <cw@f00f.org>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jan Blunck <jblunck@suse.de>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev
	tmpfs
Message-ID: <20090501160444.GA17325@kroah.com>
References: <1241097822.2516.3.camel@poy> <20090501065754.GA30626@puku.stupidest.org> <20090501140108.GA20846@kroah.com> <9b2b86520905010843p63daf856pd537adcb439cbaed@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b2b86520905010843p63daf856pd537adcb439cbaed@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 04:43:49PM +0100, Alan Jenkins wrote:
> On 5/1/09, Greg KH <greg@kroah.com> wrote:
> > On Thu, Apr 30, 2009 at 11:57:54PM -0700, Chris Wedgwood wrote:
> >> On Thu, Apr 30, 2009 at 03:23:42PM +0200, Kay Sievers wrote:
> >>
> >> > Devtmpfs lets the kernel create a tmpfs very early at kernel
> >> > initialization, before any driver core device is registered. Every
> >> > device with a major/minor will have a device node created in this
> >> > tmpfs instance. After the rootfs is mounted by the kernel, the
> >> > populated tmpfs is mounted at /dev. In initramfs, it can be moved to
> >> > the manually mounted root filesystem before /sbin/init is executed.
> >>
> >> Why can't the initramfs create /dev and populate it?
> >
> > Right now it does, and it takes about 1-2 seconds to do so depending on
> > the hardware.
> >
> > Which is over double the time it takes to boot the kernel entirely these
> > days, so it is quite noticable.
> 
> Please, this argument is pants.

Is that short pants?  Jeans?  Khakis?  What color? :)

> The initramfs _could_  create /dev and populate it.

How?  With a bash script like Android does?  Do you want to maintain two
different code streams for this kind of thing?

> Neither crawling /sys or creating device nodes is horribly expensive.

No, but it is measurable.

> It's udev that adds overhead which is not needed at this point.
> If the initramfs was optimised to do the same as devtmpfs, it needn't
> take more than 50ms on my eeepc.

It would take longer than 50ms.

> Here's my 630Mhz Celeron in action:
> 
> # Crawl sysfs to discover valid devices
> time ls -l /sys/dev/ > /dev/null
> 
> real    0m0.008s
> user    0m0.000s
> sys     0m0.007s
> 
> # Create X number of device nodes
> time cp -a /dev/block /dev/char .dev2
> 
> real    0m0.016s
> user    0m0.003s
> sys     0m0.013s

But first, time it with an initramfs with the load time of your script
and the rest of the stuff you need to do there to get it running.  And
also drop your caches before doing such a test as well to make it
"real".

> If this deserves to live in the kernel, let's not pretend that it is
> because it works dramatically faster.

But it does.

And it's also a solution for the embedded people, and the rescue disk
users, and the others of us that have to drop down to init=/bin/bash at
times.

If you don't like it, don't build it into your kernel, it's only 300
lines of code to keep away from your machine.

thanks,

greg k-h
