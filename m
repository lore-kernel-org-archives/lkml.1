Return-Path: <linux-kernel-owner+w=401wt.eu-S1755485AbXFWMt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbXFWMt6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 08:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751297AbXFWMtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 08:49:49 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:64745 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbXFWMts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 08:49:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=a1YdkgO9gRwdv02AOr9UPDKk/308Rij61tySQwtp7jBIAd9xTl/K0M0C2/S8E0WWjm0vzAPdE5hHpFqWs7Br1NymGS0rEyDHPsbSn4ZJo23PBf6R076MCCkoyljs8QN+ONu21tTEFPyK2Hq3A0Joxiz5i/BTK8rN2k6KEr07+k8=
Message-ID: <3ae72650706230549oaf3f965ufa311177ea4134af@mail.gmail.com>
Date: Sat, 23 Jun 2007 14:49:47 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Rob Landley" <rob@landley.net>
Subject: Re: Rules on how to use sysfs in userspace programs
Cc: "Greg KH" <greg@kroah.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200706221746.03298.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070608203637.GA9259@kroah.com>
	 <200706221746.03298.rob@landley.net>
X-Google-Sender-Auth: e3852a4748aa9467
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/22/07, Rob Landley <rob@landley.net> wrote:
> On Friday 08 June 2007 16:36:37 Greg KH wrote:
> > Over time there have been a number of problems when sysfs has changed in
> > "unexpected" ways.  Here's a document that Kay wrote a while ago that
> > I'd like to add to the kernel Documentation directory to help userspace
> > programmers out.
> >
> > Any comments or critique of this is greatly appreciated.
>
> Still catching up from my laptop dying.
>
> I find the explanation of /sys/subsystem almost unintelligible.  What will the
> new one actually look like?

"It is planned to merge all three classification-directories into one
 place at /sys/subsystem/,  following the current layout of the
bus-directories."

Means that /sys/subsystem/ will have a devices/ directory, full of
symlinks to the devices, all in a flat list. Subsytem-global attribute
files/directories are not mixed with the devices in the same directory
like in /sys/class, it will also not contain any hierarchy like the
layout of /sys/block.

> If I want to find all block devices in the system, it looks like I should now
> look at /sys/subsystem/block.

Yes, in this order (if you want to use it, but /sys/block will still be there):
  /sys/subsytem/block/devices/*
  /sys/class/block/*
  /sys/block/*/*

> (And "subsystem" is not a variable here but
> the actual directory name?  I presume it moved for Feng Shui reasons.)

"one place at /sys/subsystem/"

Yes, it will be all pretty consistent, the event-environment contains
$SUBSYSTEM, we will  have /sys/subsystem/$SUBSYSTEM/devices/ directory
and at every device a symlink named "subsystem" pointing back to the
/sys/subsystem/$SUBSYSTEM/ directory.

> If I want to find char devices, where do I look?  /sys/subsystem...  char?
> class?  Is a char device now anything under /sys/subsystem that is _not_
> in /sys/subsystem/block?  (Minus bus devices?)  Is there a specific directory
> for these?

If /sys/subsystem exists, just look at /sys/subsystem/*/devices/*, you
will find every kernel device here, with exactly the logic to access
it. Every device with a "dev" file, it is a char device, unless
$SUBYSTEM=="block".

If /sys/subsystem/ doesn't exist, you have to search all through
/sys/bus/, /sys/class/, /sys/block/, every directory with completely
different access pattern to find your device. You may want to look at
the udev code, it's all implemented there:
http://git.kernel.org/?p=linux/hotplug/udev.git;a=blob;f=udevtrigger.c;hb=HEAD#l498

> This document is highly polluted with what NOT to do.

Yeah, that's sysfs. It exports all the useless kernel implementation
details, so that _what_not_to_do_ is the biggest problem we have. :)
There is much too much internal stuff available here, that never can
be kept stable in the usual sense, as long as we allow to change
kernel/driver internals at the same time.

> I'm looking for a
> clear "what SHOULD I do", and it takes some wading to find it.  (Historical
> cruft about what not to do is potentially a separate document, it's not
> useful for people learning this stuff now who weren't playing with the legacy
> mechanisms.)  The description of /sys/subsystem spends so much time talking
> about old legacy issues it never gives a clear description of the new way of
> doing things, which is theoretically what this document is about...

It was a first cut, I did months ago, and sure, it needs some work.

Thanks,
Kay
