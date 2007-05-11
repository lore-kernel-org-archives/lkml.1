Return-Path: <linux-kernel-owner+w=401wt.eu-S1758693AbXEKIj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758693AbXEKIj1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 04:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753995AbXEKIjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 04:39:12 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:61331 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751749AbXEKIjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 04:39:08 -0400
Date: Fri, 11 May 2007 10:39:05 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MMC: Flush mmc workqueue late in the boot sequence
Message-ID: <20070511103905.08530507@dhcp-252-105.norway.atmel.com>
In-Reply-To: <46437562.9050501@drzeus.cx>
References: <117879333788-git-send-email-hskinnemoen@atmel.com>
	<46430A49.9090803@drzeus.cx>
	<20070510143737.54969394@dhcp-252-105.norway.atmel.com>
	<46432212.9070008@drzeus.cx>
	<20070510163348.0a117d92@dhcp-252-105.norway.atmel.com>
	<46434123.8040801@drzeus.cx>
	<20070510182749.219351cb@dhcp-252-105.norway.atmel.com>
	<46437562.9050501@drzeus.cx>
Organization: Atmel Norway
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 21:41:22 +0200
Pierre Ossman <drzeus@drzeus.cx> wrote:

> You're assuming two things:
> 
> 1. The bus the host controller reside on is synchronous both in adding devices
> and drivers. This is true for most buses, but not all. As we can see, the MMC
> bus is an example of one that isn't.
> 
> 2. The bus the host controller reside on is scanned before any sync function we add.
> 
> The second probably isn't much of a stretch, but the first is more likely to
> break. E.g. an usb based controller would not satisfy 1 as usb is scanned
> asynchronously. Platform devices are case by case (e.g. some device might be
> delayed since it needs time to power up).

You're right about my assumptions. Are there any existing drivers that
break them? Are there even any usb-based controllers around? I though
most usb-mmc controllers used the USB Mass Storage class and thus
don't use the mmc subsystem at all.

> >> Indeed. But it is not by design that they are scheduled before late_initcall().
> >> Also, flushing the workqueue is also not a by-design way of completing a scan,
> >> it just happens to be that way right now.
> > 
> > So how is it supposed to work "by design"?
> > 
> 
> It isn't. The MMC bus is a pesky bugger in that it is slow and involves a lot of
> sleeping and asynchronous callbacks. As such, synchronisation needs to be very
> explicit using for example completions.

I see. The flush_workqueue approach might end up waiting for other
things than just scanning, is that the problem? Would it be better to
add a per-host "inital scan complete" completion that we could wait on
instead?

> >>> And I never realized that using a block device as a parameter to the
> >>> root= parameter could possibly be "unofficial" functionality...?
> >> Then you've learned something new. ;)
> > 
> > Guess so. It seems like the prepare_namespace stuff is getting less
> > useful every day.
> > 
> 
> Probably. But I'd like to hope we're gaining more than we lose. There are some
> horror stories from the scsi camp where synchronous scanning means it takes an
> hour to boot a machine.

Yeah, but I don't understand why we keep breaking it without providing
any real alternative (apart from distro-specific initrd scripts.)

Also, with scsi you can do the scanning in parallel, but wait for all
of them to complete before mounting the root filesystem. This is what I
want the mmc subsystem to do as well.

> >> Only some devices work that way (generally only those with "simple" interfaces).
> >> And most things are these days behind more advanced buses, more akin to a network.
> > 
> > It's funny that NFS root does not have these kinds of problems then...
> > 
> 
> I'm not familiar with that code, but I would guess it has a whole bunch of
> prerequisite conditions. And the nfs root installations I've seen all use
> initrd, so I would assume there are some restrictions to letting the kernel
> handle it.

I've never used initrd with nfs root. I suspect most distributions use
initrd so that they can build a generic, modular kernel and just load
the modules they need from initrd.

And nfs root often uses DHCP to obtain an IP address, it has to do
portmap lookups, etc, so it definitely qualifies as a pesky,
asynchronous bugger. But it still manages to be synchronous enough to
be able to mount root without depending on initrd or rootdelay.

> >> Generally, not waiting for a lot of hardware is a good thing as it speeds up
> >> boot times. In my mind, the proper way is having a script in an initrd that
> >> waits for just the parts of the hardware that this particular system needs.
> >> Everything else can be brought up in the background.
> > 
> > Yeah, but I suspect most users will rather have a system that actually
> > boots than a system that would have booted very quickly if it had booted
> > at all.
> > 
> 
> I think most people can live with having an initrd, so I wouldn't paint quite
> such a bleak picture.

I'm not sure how many embedded people actually know how to build an
initrd for a custom board.

> > Btw, how can I wait for the scanning to complete from early userspace?
> > 
> 
> Monitor /proc/partitions or /sys until the device you need for rootfs shows up.

Simple enough, I suppose. But it still adds complexity to the system
which used to be unnecessary.

> The big problem from my point of view is that I do not want to start promising
> people a feature we might not be able to support in the future, and perhaps not
> even now with some hardware.

The problem from _my_ point of view is that this feature already worked
until 2.6.20, so the promise has already been made.

> Is there some reason you cannot use an initrd or is it just the inconvenience?

Well, it's mostly inconvenience I suppose. But I'm also worried about
increasing the boot time of systems that used to boot in 4-5 seconds.
One second extra spent doing decompression, polling files in sysfs,
etc. could have a huge impact, relatively speaking.

Now, I'm not really opposed to the whole concept of doing filesystem
mounting from early userspace -- I think that might be a quite elegant
approach. But a) the prepare_namespace code is still in the kernel, so
it ought to work, b) klibc has not yet been merged so each user is on
his own, and c) Repeatedly reading sysfs files to see when the root
device is available is one thing that I don't think is very elegant.

But if you don't want this issue fixed (i.e. you don't think of it as
an issue) I guess I have to either start working on yet another initrd
setup or just apply the patch to our vendor kernel and be done with it.
The latter certainly is the most tempting, but I suppose the former is
more like how things are supposed to be done in the future.

Haavard
