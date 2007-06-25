Return-Path: <linux-kernel-owner+w=401wt.eu-S1753522AbXFYSO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbXFYSO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 14:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbXFYSOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 14:14:20 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:59622
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbXFYSOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 14:14:20 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: Rules on how to use sysfs in userspace programs
Date: Mon, 25 Jun 2007 14:14:23 -0400
User-Agent: KMail/1.9.6
Cc: "Greg KH" <greg@kroah.com>, linux-kernel@vger.kernel.org
References: <20070608203637.GA9259@kroah.com> <200706241524.33109.rob@landley.net> <3ae72650706250757o5c468c2bg580f380f20067d33@mail.gmail.com>
In-Reply-To: <3ae72650706250757o5c468c2bg580f380f20067d33@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706251414.23596.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 June 2007 10:57:35 Kay Sievers wrote:
> > > Sure, all devices have a "subsystem" link, you have to readlink()
> > > that, and if it ends in "block, you have a blockdev. But as mentioned
> > > in an earlier mail, you should stop scanning /sys/devices/ and always
> > > come from the subsystem directories, so you get "block" for free.
> >
> > I'm not scanning /sys/devices, I'm scanning /sys/block and /sys/class
> > which this document implies are deprecated and going away.
>
> No. "It is planned to merge all three classification-directories into
> one place at /sys/subsystem/", but the they will still be available
> for backwards compat, and continue to export silly details like
> differentiation between class- and bus-devices in the userspace
> export.

As long as "available for backwards compat" doesn't imply "will be deprecated 
and removed at some point in the future", then fine.

I'm not interested in the difference between class and bus.  I don't even 
really know what it is.  I'm interested in the difference between char and 
block, which is a fairly important difference if you want to actually mknod() 
anything.

> > I'm trying to figure
> > out what replaced them.  Now instead of following a path to naturally get
> > char devices in one pass and block devices in another, it seems I have to
> > readlink a symlink and do string manipulation to identify the device type
> > once I've found the device.
>
> You enter a well defined directory of symlinks, that directory is
> named "block". What's so difficult here?

So anything that's not in /sys/subsystem/block is a char device?  Is there one 
directory in which to look for char devices, or are there multiple 
directories?  (Is there a /sys/subsystem/class?  Or a /sys/subsystem/char?  
Or multiple directories I have to look at all of?)

You mentioned busses exporting device nodes.  Would these be char or block 
device nodes?

> > I can do this, I'd just like to confirm it's "the way" now, and by "the
> > way" I mean Greg won't change his mind and yank it next month.
> >
> > > > > If /sys/subsystem exists, just look at /sys/subsystem/*/devices/*,
> > > > > you will find every kernel device here, with exactly the logic to
> > > > > access it. Every device with a "dev" file, it is a char device,
> > > > > unless $SUBYSTEM=="block".
> > > >
> > > > Oh good.  That last sentence contains the heuristic I need.
> >
> > Ok, hang on, looking back on this I'm confused again.
> >
> > When you say /sys/subsystem are you referring to a literal path (which my
> > sys directory currently doesn't have a subdirectory named "subsystem"),
> > or do you mean /sys/$SUBSYSTEM where today I have /sys/class and
> > /sys/block?
>
> "It is planned to merge ..." Today it exists only as a patch and will
> show up when the block-conversion eventually gets merged.

So code like mdev will need to keep using the old paths for this, or else not 
work on older kernels.

> It will be 
> /sys/subsystem/$SUBSYSTEM/, just like /sys/bus looks today but
> containing _all_ devices from _all_ subsytems in _one_ place with
> _one_ access rule.

How is /sys/subsystem/{block,class} and improvement over /sys/{block,class}?  
I'm sure there _is_ a rationale for this, but I haven't actually been told 
what it is.

> Again, please look at the udev or HAL code, it's 
> all pretty easy to understand by reading the code.

I was trying to read the documentation Greg posted.

> > > > > If /sys/subsystem/ doesn't exist, you have to search all through
> > > > > /sys/bus/, /sys/class/, /sys/block/, every directory with
> > > > > completely
> > > >
> > > > No, only /sys/class and /sys/block.  Currently, /sys/class contains
> > > > char devices and /sys/block contains block devices.  You don't have
> > > > to invoke mknod for a bus.
> > >
> > > Sure, you have! There are devices in /sys/bus which export device
> > > nodes, and the number will just grow.
> >
> > I have yet to encounter any, could you give me some examples?
> >
> > find /sys/bus -name dev
>
> There are only symlinks in /sys/bus, no attributes to "find" here.

There are devices in /sys/bus, but there are only symlinks in /sys/bus.  
That's very zen.

Would these devices be discoverable some other way?  Do they currently show up 
under either /sys/class or /sys/block?  If no, are they char device nodes or 
are they block device nodes?

> > Nope, nothing...
>
> Usb and firewire have device nodes at bus devices.
>
>   $ ls -l /sys/bus/usb/devices/*/dev
>   /sys/bus/usb/devices/1-2/dev
>   /sys/bus/usb/devices/4-1/dev

Hmmm...

$ cd /sys/bus/usb/devices
$ ls */dev
$ ls: */dev: No such file or directory

Let me plug in my USB external hard drive...

$ ls */dev
ls: */dev: No such file or directory

Is this only in newer kernel than Ubuntu 7.04 comes with?  Am I looking wrong?

> > Would these device nodes be char devices, or block devices, or...
> > something else entirely?  (The practical distinction between /sys/class
> > and /sys/block used to be that one contained char devices and the other
> > block devices.  I could work with that.  I'm sad to see it going away...)
>
> SUBSTEM=="block" are block devices, everything else are char devices.

Ok.  /sys/subsystem/block is where the block devices are, all 
other /sys/subsystem/* are char devices.

> Class-  or bus-devices can be anything, you need to know the subsystem
> to distinguish them.

So class and bus devices are NOT everything else, and therefore char devices?

I'M CONFUSED!

> Unfortunately the "dev" file itself does not contain "c123:123",
> "b234:8" that would be the proper solution, but reading the subsytem
> works fine too for a long time.

Actually I've been doing:

  path[]="/sys/class"
  if (path[5]=='b') is_block();
  if (path[5]=='c') is_char();

Pretty straightforward, I thought.  And it's had the added benefit of actually 
working, up until the config option to yank "old symlinks" went into the 
kernel...

> > > > I'm very interested in helping out with it, and updating mdev based
> > > > on the documentation rather than the source code, but not until after
> > > > OLS I expect. :)
> > >
> > > Sure, any help is welcome here.
> >
> > What I've had to do each time was install a new kernel, find out what had
> > changed by examination, and update programs to work with the new stuff.
> >
> > I'd like to be able to do it from documentation.
>
> Sure, that would be nice. any help documenting it in the right way, is
> appreciated.

After OLS I'll take a whack at updating mdev to use non-legacy paths, and tell 
you what I needed to do.

> Thanks,
> Kay

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
