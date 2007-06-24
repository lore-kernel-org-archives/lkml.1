Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbXFXLDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbXFXLDt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 07:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754045AbXFXLDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 07:03:41 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:19966 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072AbXFXLDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 07:03:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=uImqkOKJyHqA2MNhGjlyKuHlQ2GFts16OmhRn9rKf8mBmYLsvDOf0CDswD9BqflEFYYw/R5GPRmUyJ/5GOxBfkmHVBZ85qJw3A76OVxRhdrHntmnWIVQ1Z5irEQH4RaXseCT5vAlspmoidB/mHJQKW3Y3lRuujoiqWWhz6n78gk=
Message-ID: <3ae72650706240403j779a9aedyf6321de1d22b19fd@mail.gmail.com>
Date: Sun, 24 Jun 2007 13:03:39 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Rob Landley" <rob@landley.net>
Subject: Re: Rules on how to use sysfs in userspace programs
Cc: "Greg KH" <greg@kroah.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200706232131.46016.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070608203637.GA9259@kroah.com>
	 <200706221746.03298.rob@landley.net>
	 <3ae72650706230549oaf3f965ufa311177ea4134af@mail.gmail.com>
	 <200706232131.46016.rob@landley.net>
X-Google-Sender-Auth: 88ca1ff91cf6c635
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/24/07, Rob Landley <rob@landley.net> wrote:
> On Saturday 23 June 2007 08:49:47 Kay Sievers wrote:
> > On 6/22/07, Rob Landley <rob@landley.net> wrote:
> > > On Friday 08 June 2007 16:36:37 Greg KH wrote:
> > > > Over time there have been a number of problems when sysfs has changed
> > > > in "unexpected" ways.  Here's a document that Kay wrote a while ago
> > > > that I'd like to add to the kernel Documentation directory to help
> > > > userspace programmers out.
> > > >
> > > > Any comments or critique of this is greatly appreciated.
> > >
> > > Still catching up from my laptop dying.
> > >
> > > I find the explanation of /sys/subsystem almost unintelligible.  What
> > > will the new one actually look like?
> >
> > "It is planned to merge all three classification-directories into one
> >  place at /sys/subsystem/,  following the current layout of the
> > bus-directories."
> >
> > Means that /sys/subsystem/ will have a devices/ directory, full of
> > symlinks to the devices, all in a flat list. Subsytem-global attribute
> > files/directories are not mixed with the devices in the same directory
> > like in /sys/class, it will also not contain any hierarchy like the
> > layout of /sys/block.
>
> But will it still be possible to distinguish block devices from character
> devices when teaching mdev to quickly scan for devices to populate /dev in
> embedded systems using the "new" locations for things?

Sure, all devices have a "subsystem" link, you have to readlink()
that, and if it ends in "block, you have a blockdev. But as mentioned
in an earlier mail, you should stop scanning /sys/devices/ and always
come from the subsystem directories, so you get "block" for free.

> > > If I want to find all block devices in the system, it looks like I should
> > > now look at /sys/subsystem/block.
> >
> > Yes, in this order (if you want to use it, but /sys/block will still be
> > there): /sys/subsytem/block/devices/*
> >   /sys/class/block/*
> >   /sys/block/*/*
>
> If /sys/block will still be there, and this is reliable and just "not
> deprecated _yet_", then life is good.  I got the impression from the document
> that /sys/block was going away at some point.
>
> > > (And "subsystem" is not a variable here but
> > > the actual directory name?  I presume it moved for Feng Shui reasons.)
> >
> > "one place at /sys/subsystem/"
> >
> > Yes, it will be all pretty consistent, the event-environment contains
> > $SUBSYSTEM, we will  have /sys/subsystem/$SUBSYSTEM/devices/ directory
> > and at every device a symlink named "subsystem" pointing back to the
> > /sys/subsystem/$SUBSYSTEM/ directory.
>
> Which is good to know, but only useful if called from event context rather
> than scanning for devices from init scripts so it can mknod in /dev and fire
> off subsidiary scripts.
>
> > > If I want to find char devices, where do I look?  /sys/subsystem...
> > > char? class?  Is a char device now anything under /sys/subsystem that is
> > > _not_ in /sys/subsystem/block?  (Minus bus devices?)  Is there a specific
> > > directory for these?
> >
> > If /sys/subsystem exists, just look at /sys/subsystem/*/devices/*, you
> > will find every kernel device here, with exactly the logic to access
> > it. Every device with a "dev" file, it is a char device, unless
> > $SUBYSTEM=="block".
>
> Oh good.  That last sentence contains the heuristic I need.
>
> > If /sys/subsystem/ doesn't exist, you have to search all through
> > /sys/bus/, /sys/class/, /sys/block/, every directory with completely
>
> No, only /sys/class and /sys/block.  Currently, /sys/class contains char
> devices and /sys/block contains block devices.  You don't have to invoke
> mknod for a bus.

Sure, you have! There are devices in /sys/bus which export device
nodes, and the number will just grow.

That's why the document states: "There is no such thing like class-,
bus-, physical devices, interfaces, and such that you can rely on in
userspace. Everything is just simply a "device". Class-, bus-,
physical, ... types are just kernel implementation details, which
should not be expected by applications that handle devices."

> > different access pattern to find your device. You may want to look at
> > the udev code, it's all implemented there:
> > http://git.kernel.org/?p=linux/hotplug/udev.git;a=blob;f=udevtrigger.c;hb=H
> >EAD#l498
> >
> > > This document is highly polluted with what NOT to do.
> >
> > Yeah, that's sysfs. It exports all the useless kernel implementation
> > details, so that _what_not_to_do_ is the biggest problem we have. :)
>
> If you document a specific subset of the data it exports and say "you can rely
> on this being there, lots of the rest is implementation details", then people
> have less cause to complain when the bits you haven't documented change.
>
> Right now, it's all undocumented and if you try to wade through the
> documentation it spends most of its time reminiscing about the bad old days
> of...  nine months ago.
>
> > There is much too much internal stuff available here, that never can
> > be kept stable in the usual sense, as long as we allow to change
> > kernel/driver internals at the same time.
>
> Then document what is stable, please.
>
> > > I'm looking for a
> > > clear "what SHOULD I do", and it takes some wading to find it.
> > > (Historical cruft about what not to do is potentially a separate
> > > document, it's not useful for people learning this stuff now who weren't
> > > playing with the legacy mechanisms.)  The description of /sys/subsystem
> > > spends so much time talking about old legacy issues it never gives a
> > > clear description of the new way of doing things, which is theoretically
> > > what this document is about...
> >
> > It was a first cut, I did months ago, and sure, it needs some work.
>
> I'm very interested in helping out with it, and updating mdev based on the
> documentation rather than the source code, but not until after OLS I
> expect. :)

Sure, any help is welcome here.

Thanks,
Kay
