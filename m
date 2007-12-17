Return-Path: <linux-kernel-owner+w=401wt.eu-S1764583AbXLQIZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764583AbXLQIZl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 03:25:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbXLQIZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 03:25:31 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:64433 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbXLQIZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 03:25:30 -0500
Subject: Re: /sys/block [was: [PATCH 007 of 7] md: Get name for block
	device in sysfs]
From: Kay Sievers <kay.sievers@vrfy.org>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
In-Reply-To: <47660927.9070002@msgid.tls.msk.ru>
References: <20071214171950.1308.patches@notabene>
	 <1071214062647.1928@suse.de>
	 <3ae72650712150858v14681823td2b0410eb67b1d04@mail.gmail.com>
	 <18277.43533.991986.323212@notabene.brown>
	 <1197857414.2585.16.camel@lov.site>  <47660927.9070002@msgid.tls.msk.ru>
Content-Type: text/plain
Date: Mon, 17 Dec 2007 09:24:39 +0100
Message-Id: <1197879879.2585.28.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX182QvQyYMz2Tmi2RJKwUcEJxkEXGWSdFEGKwTW
 0845vUT9Fh3BpwmsZ4jd2IxkKuOjrYsRKDua/g+T8VXYm+PQkf
 iP1ekRr3+Bka4vkpsVgPX+eaPSGnWKI
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-12-17 at 08:29 +0300, Michael Tokarev wrote:
> Kay Sievers wrote:
> > On Mon, 2007-12-17 at 09:43 +1100, Neil Brown wrote:
> >> On Saturday December 15, kay.sievers@vrfy.org wrote:
> >>> On Dec 14, 2007 7:26 AM, NeilBrown <neilb@suse.de> wrote:
> >>>> Given an fd on a block device, returns a string like
> >>>>
> >>>>         /block/sda/sda1
> >>>>
> >>>> which can be used to find related information in /sys.
> >> ....
> >>> As pointed out to when you came up with the idea, we can't do this. A devpath
> >>> is a path to the device and will not necessarily start with "/block" for block
> >>> devices. It may start with "/devices" and can be much longer than
> >>> BDEVNAME_SIZE*2  + 10.
> >> When you say "will not necessarily" can I take that to mean that it
> >> currently does, but it might (will) change??
> > 
> > It's in -mm. The devpath for all block devices, like for all other
> > devices, will start with /devices/* if !SYSFS_DEPRECATED.
> 
> This is the second time I come across this (planned?) change, and for
> the second time I can't understand it.
> 
> How to distinguish char devices from block devices in sysfs?
> Is the only way to read a symlink `subsystem' in the device
> directory?

By its subsystem value (block), from the symlink, from the environment,
or from $1.

> For now, I've a shell code (used heavily in numerous places),
> which looks like this:
> 
>   function makedev() {
>     ...
>     case $DEVPATH in
>       /block/*) TYPE=b ;;
>       *) TYPE=c ;;
>     esac
>     ...
>     mknod /dev/$DEV $TYPE $MAJOR $MINOR
>   }
> 
> The only external process invocation in there is mknod, all
> the rest is done using pure shell constructs.  Is it really
> necessary to spawn another process just to read a symlink
> now?  It will be almost 2 times slower....

No need.

> (Sure thing this may be rewritten in C, but using shell it's
> MUCH easier to customize if necessary.)

$SUBSYSTEM == "block"

> Also, /sys/block/ directory is very easy to use currently, --
> unlike other /sys/ stuff which is way too deep and often
> placed in unknown/unexpected places (and /sys/class/ and
> /sys/bus/ directories are changing all the time).

/sys/block is still there and contains symlinks. And all this happens
only for !SYSFS_DEPRECATED.

> What's the benefit of moving things from /sys/block/ to
> /sys/devices/ ?

Unification. Block devices are "struct devices", use a class, use the
common driver core code instead of their own, show up in the tree, and
can be parents for other devices.

Kay

