Return-Path: <linux-kernel-owner+w=401wt.eu-S1756784AbXFYO5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784AbXFYO5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 10:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755438AbXFYO5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 10:57:41 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:59315 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbXFYO5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 10:57:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=LrW8ES6H3CSnZbvXOH/GSOsMBbFftcTOYCAMjKWLP7/ZBD5FoJc/cVfTgq7RVfKFn+xjGcGHwjmx4NNTNXxtBpfVw1x+nCvBcE7Hkg0tDaPkbJSaSD4eDxH8u6vH5ggXkHRTNhxfMD5UJy0OqQrHWRRXBUUqDBzpn8oXkPUU9qc=
Message-ID: <3ae72650706250757o5c468c2bg580f380f20067d33@mail.gmail.com>
Date: Mon, 25 Jun 2007 16:57:35 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Rob Landley" <rob@landley.net>
Subject: Re: Rules on how to use sysfs in userspace programs
Cc: "Greg KH" <greg@kroah.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200706241524.33109.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070608203637.GA9259@kroah.com>
	 <200706232131.46016.rob@landley.net>
	 <3ae72650706240403j779a9aedyf6321de1d22b19fd@mail.gmail.com>
	 <200706241524.33109.rob@landley.net>
X-Google-Sender-Auth: 12e655d02ef180aa
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/24/07, Rob Landley <rob@landley.net> wrote:
> On Sunday 24 June 2007 07:03:39 Kay Sievers wrote:
> > On 6/24/07, Rob Landley <rob@landley.net> wrote:
> > > On Saturday 23 June 2007 08:49:47 Kay Sievers wrote:
> > > > On 6/22/07, Rob Landley <rob@landley.net> wrote:
> > > > > On Friday 08 June 2007 16:36:37 Greg KH wrote:
> > > > > > Over time there have been a number of problems when sysfs has
> > > > > > changed in "unexpected" ways.  Here's a document that Kay wrote a
> > > > > > while ago that I'd like to add to the kernel Documentation
> > > > > > directory to help userspace programmers out.
> > > > > >
> > > > > > Any comments or critique of this is greatly appreciated.
> > > > >
> > > > > Still catching up from my laptop dying.
> > > > >
> > > > > I find the explanation of /sys/subsystem almost unintelligible.  What
> > > > > will the new one actually look like?
> > > >
> > > > "It is planned to merge all three classification-directories into one
> > > >  place at /sys/subsystem/,  following the current layout of the
> > > > bus-directories."
> > > >
> > > > Means that /sys/subsystem/ will have a devices/ directory, full of
> > > > symlinks to the devices, all in a flat list. Subsytem-global attribute
> > > > files/directories are not mixed with the devices in the same directory
> > > > like in /sys/class, it will also not contain any hierarchy like the
> > > > layout of /sys/block.
> > >
> > > But will it still be possible to distinguish block devices from character
> > > devices when teaching mdev to quickly scan for devices to populate /dev
> > > in embedded systems using the "new" locations for things?
> >
> > Sure, all devices have a "subsystem" link, you have to readlink()
> > that, and if it ends in "block, you have a blockdev. But as mentioned
> > in an earlier mail, you should stop scanning /sys/devices/ and always
> > come from the subsystem directories, so you get "block" for free.
>
> I'm not scanning /sys/devices, I'm scanning /sys/block and /sys/class which
> this document implies are deprecated and going away.

No. "It is planned to merge all three classification-directories into
one place at /sys/subsystem/", but the they will still be available
for backwards compat, and continue to export silly details like
differentiation between class- and bus-devices in the userspace
export.

> I'm trying to figure
> out what replaced them.  Now instead of following a path to naturally get
> char devices in one pass and block devices in another, it seems I have to
> readlink a symlink and do string manipulation to identify the device type
> once I've found the device.

You enter a well defined directory of symlinks, that directory is
named "block". What's so difficult here?

> I can do this, I'd just like to confirm it's "the way" now, and by "the way" I
> mean Greg won't change his mind and yank it next month.
>
> > > > If /sys/subsystem exists, just look at /sys/subsystem/*/devices/*, you
> > > > will find every kernel device here, with exactly the logic to access
> > > > it. Every device with a "dev" file, it is a char device, unless
> > > > $SUBYSTEM=="block".
> > >
> > > Oh good.  That last sentence contains the heuristic I need.
>
> Ok, hang on, looking back on this I'm confused again.
>
> When you say /sys/subsystem are you referring to a literal path (which my sys
> directory currently doesn't have a subdirectory named "subsystem"), or do you
> mean /sys/$SUBSYSTEM where today I have /sys/class and /sys/block?

"It is planned to merge ..." Today it exists only as a patch and will
show up when the block-conversion eventually gets merged. It will be
/sys/subsystem/$SUBSYSTEM/, just like /sys/bus looks today but
containing _all_ devices from _all_ subsytems in _one_ place with
_one_ access rule. Again, please look at the udev or HAL code, it's
all pretty easy to understand by reading the code.

> > > > If /sys/subsystem/ doesn't exist, you have to search all through
> > > > /sys/bus/, /sys/class/, /sys/block/, every directory with completely
> > >
> > > No, only /sys/class and /sys/block.  Currently, /sys/class contains char
> > > devices and /sys/block contains block devices.  You don't have to invoke
> > > mknod for a bus.
> >
> > Sure, you have! There are devices in /sys/bus which export device
> > nodes, and the number will just grow.
>
> I have yet to encounter any, could you give me some examples?
>
> find /sys/bus -name dev

There are only symlinks in /sys/bus, no attributes to "find" here.

> Nope, nothing...

Usb and firewire have device nodes at bus devices.

  $ ls -l /sys/bus/usb/devices/*/dev
  /sys/bus/usb/devices/1-2/dev
  /sys/bus/usb/devices/4-1/dev
  ...

> Would these device nodes be char devices, or block devices, or... something
> else entirely?  (The practical distinction between /sys/class and /sys/block
> used to be that one contained char devices and the other block devices.  I
> could work with that.  I'm sad to see it going away...)

SUBSTEM=="block" are block devices, everything else are char devices.
Class-  or bus-devices can be anything, you need to know the subsystem
to distinguish them.

Unfortunately the "dev" file itself does not contain "c123:123",
"b234:8" that would be the proper solution, but reading the subsytem
works fine too for a long time.

> > That's why the document states: "There is no such thing like class-,
> > bus-, physical devices, interfaces, and such that you can rely on in
> > userspace. Everything is just simply a "device". Class-, bus-,
> > physical, ... types are just kernel implementation details, which
> > should not be expected by applications that handle devices."
>
> Whether you feed "b" or "c" to mknod is a kernel implementation detail?

Please ...

> Are you unifying char and block devices so mknod doesn't have to distinguish
> between them anymore?

No.

> > > I'm very interested in helping out with it, and updating mdev based on
> > > the documentation rather than the source code, but not until after OLS I
> > > expect. :)
> >
> > Sure, any help is welcome here.
>
> What I've had to do each time was install a new kernel, find out what had
> changed by examination, and update programs to work with the new stuff.
>
> I'd like to be able to do it from documentation.

Sure, that would be nice. any help documenting it in the right way, is
appreciated.

Thanks,
Kay
