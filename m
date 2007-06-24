Return-Path: <linux-kernel-owner+w=401wt.eu-S1755016AbXFXBb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016AbXFXBb6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 21:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbXFXBbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 21:31:50 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:60512
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbXFXBbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 21:31:49 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: Rules on how to use sysfs in userspace programs
Date: Sat, 23 Jun 2007 21:31:45 -0400
User-Agent: KMail/1.9.6
Cc: "Greg KH" <greg@kroah.com>, linux-kernel@vger.kernel.org
References: <20070608203637.GA9259@kroah.com> <200706221746.03298.rob@landley.net> <3ae72650706230549oaf3f965ufa311177ea4134af@mail.gmail.com>
In-Reply-To: <3ae72650706230549oaf3f965ufa311177ea4134af@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706232131.46016.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 June 2007 08:49:47 Kay Sievers wrote:
> On 6/22/07, Rob Landley <rob@landley.net> wrote:
> > On Friday 08 June 2007 16:36:37 Greg KH wrote:
> > > Over time there have been a number of problems when sysfs has changed
> > > in "unexpected" ways.  Here's a document that Kay wrote a while ago
> > > that I'd like to add to the kernel Documentation directory to help
> > > userspace programmers out.
> > >
> > > Any comments or critique of this is greatly appreciated.
> >
> > Still catching up from my laptop dying.
> >
> > I find the explanation of /sys/subsystem almost unintelligible.  What
> > will the new one actually look like?
>
> "It is planned to merge all three classification-directories into one
>  place at /sys/subsystem/,  following the current layout of the
> bus-directories."
>
> Means that /sys/subsystem/ will have a devices/ directory, full of
> symlinks to the devices, all in a flat list. Subsytem-global attribute
> files/directories are not mixed with the devices in the same directory
> like in /sys/class, it will also not contain any hierarchy like the
> layout of /sys/block.

But will it still be possible to distinguish block devices from character 
devices when teaching mdev to quickly scan for devices to populate /dev in 
embedded systems using the "new" locations for things?

> > If I want to find all block devices in the system, it looks like I should
> > now look at /sys/subsystem/block.
>
> Yes, in this order (if you want to use it, but /sys/block will still be
> there): /sys/subsytem/block/devices/*
>   /sys/class/block/*
>   /sys/block/*/*

If /sys/block will still be there, and this is reliable and just "not 
deprecated _yet_", then life is good.  I got the impression from the document 
that /sys/block was going away at some point.

> > (And "subsystem" is not a variable here but
> > the actual directory name?  I presume it moved for Feng Shui reasons.)
>
> "one place at /sys/subsystem/"
>
> Yes, it will be all pretty consistent, the event-environment contains
> $SUBSYSTEM, we will  have /sys/subsystem/$SUBSYSTEM/devices/ directory
> and at every device a symlink named "subsystem" pointing back to the
> /sys/subsystem/$SUBSYSTEM/ directory.

Which is good to know, but only useful if called from event context rather 
than scanning for devices from init scripts so it can mknod in /dev and fire 
off subsidiary scripts.

> > If I want to find char devices, where do I look?  /sys/subsystem... 
> > char? class?  Is a char device now anything under /sys/subsystem that is
> > _not_ in /sys/subsystem/block?  (Minus bus devices?)  Is there a specific
> > directory for these?
>
> If /sys/subsystem exists, just look at /sys/subsystem/*/devices/*, you
> will find every kernel device here, with exactly the logic to access
> it. Every device with a "dev" file, it is a char device, unless
> $SUBYSTEM=="block".

Oh good.  That last sentence contains the heuristic I need.

> If /sys/subsystem/ doesn't exist, you have to search all through
> /sys/bus/, /sys/class/, /sys/block/, every directory with completely

No, only /sys/class and /sys/block.  Currently, /sys/class contains char 
devices and /sys/block contains block devices.  You don't have to invoke 
mknod for a bus.

> different access pattern to find your device. You may want to look at
> the udev code, it's all implemented there:
> http://git.kernel.org/?p=linux/hotplug/udev.git;a=blob;f=udevtrigger.c;hb=H
>EAD#l498
>
> > This document is highly polluted with what NOT to do.
>
> Yeah, that's sysfs. It exports all the useless kernel implementation
> details, so that _what_not_to_do_ is the biggest problem we have. :)

If you document a specific subset of the data it exports and say "you can rely 
on this being there, lots of the rest is implementation details", then people 
have less cause to complain when the bits you haven't documented change.

Right now, it's all undocumented and if you try to wade through the 
documentation it spends most of its time reminiscing about the bad old days 
of...  nine months ago.

> There is much too much internal stuff available here, that never can
> be kept stable in the usual sense, as long as we allow to change
> kernel/driver internals at the same time.

Then document what is stable, please.

> > I'm looking for a
> > clear "what SHOULD I do", and it takes some wading to find it. 
> > (Historical cruft about what not to do is potentially a separate
> > document, it's not useful for people learning this stuff now who weren't
> > playing with the legacy mechanisms.)  The description of /sys/subsystem
> > spends so much time talking about old legacy issues it never gives a
> > clear description of the new way of doing things, which is theoretically
> > what this document is about...
>
> It was a first cut, I did months ago, and sure, it needs some work.

I'm very interested in helping out with it, and updating mdev based on the 
documentation rather than the source code, but not until after OLS I 
expect. :)

> Thanks,
> Kay

Thanks,

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
