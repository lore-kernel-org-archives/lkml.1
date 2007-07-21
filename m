Return-Path: <linux-kernel-owner+w=401wt.eu-S935581AbXGUAV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935581AbXGUAV5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 20:21:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760394AbXGUAVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 20:21:49 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:59301
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758164AbXGUAVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 20:21:47 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: Documentation for sysfs, hotplug, and firmware loading.
Date: Fri, 20 Jul 2007 20:21:39 -0400
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, "Greg KH" <greg@kroah.com>,
       Michael-Luke Jones <mlj28@cam.ac.uk>, Krzysztof Halasa <khc@pm.waw.pl>,
       Rod Whitby <rod@whitby.id.au>, Russell King <rmk@arm.linux.org.uk>,
       david@lang.hm
References: <200707171703.31340.rob@landley.net> <200707181339.54192.rob@landley.net> <20070719101617.08c867a7@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070719101617.08c867a7@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707202021.40009.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 July 2007 4:16:17 am Cornelia Huck wrote:
> On Wed, 18 Jul 2007 13:39:53 -0400,
>
> Rob Landley <rob@landley.net> wrote:
> > Nope.  If you recurse down under /sys/class following symlinks, you go
> > into an endless loop bouncing off of /sys/devices and getting pointed
> > back.  If you don't follow symlinks, it works fine up until about 2.6.20
> > at which point things that were previously directories BECAME symlinks
> > because the directories got moved, and it all broke.
>
> I have no idea what you're doing.

See the email to kay sievers.  In 2.6.14 following symlinks hit an endless
/sys/block/hda/device/block/device/block/device/block...  This has changed 
since, like much of sysfs, but in the absence of either a spec or a stable 
API there's no guarantee it won't reoccur.

> > Which is why I want it documented where to look for these suckers.  Just
> > give me ONE STABLE WAY TO FIND THIS INFORMATION, PLEASE.
>
> See Documentation/sysfs-rules.txt.

Ok:

Paragraph 1: "It's not stable."
Paragraph 2: "It's not stable."
Paragraph 3: If you really really need to access it directly...
Paragraph 4: DO NOT DO $XXX.
Paragraph 5: Expect it to be mounted at /sys
Paragraph 6: DO NOT DO $XXX.  (Specficially, the way you were distinguishing 
between block and char devices?  Don't do that.  No, we won't tell you what 
to replace it with, keep reading.)

So far, not exactly gripping reading.

Paragraph 7: What a devpath is.  Ok, is it just me or does it say that 
applications shouldn't use the symlinks in sysfs?  Why are they there, then?

Paragraph 8: The kernel has a name for the device.
Paragraph 9: Subsystem is a string.  What it means, we leave for you to guess.
Paragraph 10: Driver is the name of a driver.  (Does this mean a driver is 
currently loaded and handling the device, or that the kernel is suggesting a 
driver based on something like PCI ID, through the kind of mechanism that 
used to be used to request module loading?  Experimentally, it looks like the 
first, which makes sense but isn't specified.  Does something 
like /sys/class/mem/zero or have a driver?  Experimentally, no, it hasn't got 
a device link.)
Paragraph 11: Atributes, and yet more DO NOT DO $XXX.  It took me three reads 
of that to figure out they probably meant "Attributes belong to a device, 
don't confuse the attributes of another device with attributes of this 
device."  (Following _which_ device symlink?)

Ok, back up.  /sys/devices does not contain all the information necessary to 
populate /dev, because it hasn't got things like 
ramdisks, /dev/zero, /dev/console which are THERE in sysfs, which may or may 
not be supported by the kernel (the kernel might have ramdisk support, might 
not).  These things could also, in future, have their major and minor numbers 
dynamically (even randomly) assigned.  That's been discussed on this list.

I'm not trying to document /sys/devices.  I'm trying to document hotplug, 
populating /dev, and things like firmware loading that fall out of that.  
This requires use of sysfs, and I'm only trying to document as much of sysfs 
as you need to do that.  I'm not documenting stuff 
like /sys/devices/system/cpu.

The consensus so far is "the udev implementation is the spec", except I 
watched the udev implementation change rather a lot before I stopped tracking 
it, and saw a number of people complain on this list about things breaking 
when they upgraded the kernel but not udev.

Back to reading the document:
> - Properties of parent devices never belong into a child device.

Belong into?

>  Always look at the parent devices themselves for determining device
>  context properties.

For determining?

What was the original language of this document?

> If the device 'eth0' or 'sda' does not have a
>   "driver"-link, then this device does not have a driver.

Again, whether they mean "the kernel was not built with a driver that can 
handle this device" or "no driver is currently loaded and handling this 
device".  It _sounds_ like "this device is not supported by Linux", which 
probably isn't what they meant.

> Never copy any property of the parent-device into a child-device.

I note that the only mention made so far of parent-child relationships in 
devices is in terms of "don'ts".  I assume they're talking about how a 
partition can be the child of a block device, and a network controller card 
can be the child of a pci bus device?

Ah, I see.  The next paragraph is on hierarchy, yet doesn't actually explain 
anything, other than to imply that the device hierarchy being fully 
represented there is a dream to be achieved sometime in the future but not 
necessarily the truth with today's kernels, because stuff is still being 
_moved_ into /sys/devices.

> - Classification by subsystem
>  There are currently three places for classification of devices:
>  /sys/block, /sys/class and /sys/bus.

So if somebody wants to write code that runs on a current kernel, they have no 
alternative but to look in these three places.  If future kernels want to be 
compatible with current kernels, they must retain these three places as 
symlinks or some such.  Therefore, these three places form an API, and that's 
what I'm trying to document.

>  It is planned that these will 
>  not contain any device-directories themselves, but only flat lists of
>  symlinks pointing to the unified /sys/devices tree.

So presumably /sys/class/mem/zero and friends will show up under /sys/devices 
at some point, but that path should still find the thing via symlinks.  So 
moving it is an implementation detail irrelevant to documenting an api 
through with /dev can be populated by a userspace application.

>  Assuming /sys/class/<subsystem> and /sys/bus/<subsystem>, or
>  /sys/block and /sys/class/block are not interchangeable, is a bug in
>  the application.

So the fact Kay didn't mention /sys/class/block when we talked at OLS is a 
simple oversight.  You know, the type of feedback I was asking for was "This 
is wrong, you should change it to X", rather than "this is wrong, you're 
stupid".  I already _know_ I don't understand every nook and cranny of the 
Linux kernel, and that this is unlikely to change, thanks.  If you were 
wondering why writing documentation is like pulling teeth, and that there 
isn't enough of it, now you know.

Anyway, it seems like the paragraph I quoted can be rephrased "The contents 
of /sys/class/* and /sys/bus/* are interchangeable, and the contents 
of /sys/block and /sys/class/block are interchangeable."  However, this 
implies that /sys/class/block and /sys/block are interchangeable 
because /sys/class/block is part of /sys/class/*...

> - Block
>   The converted block-subsystem at /sys/class/block, or
>   /sys/subsystem/block will contain the links for disks and partitions
>   at the same level, never in a hierarchy.

A) The converted block subsystem isn't in 2.6.22 or any earlier kernel, thus 
software has to be written to use the current /sys/block path to be 
compatible with any kernel actually deployed anywhere today.  And if you've 
got the old mechanism working, what's the advantage of the new one?

B) This is the first mention (by implication only) that the current /sys/block 
might have a hierarchy under it.  The point of this document is obviously not 
to document how it works _today_.  The point of mine _is_.

> - "device"-link and <subsystem>:<kernel name>-links
>   Never depend on the "device"-link.

This paragraph is a big "DO NOT DO $XXX" repeated six times, and I note that 
this link was the reason I made mdev not follow symlinks in the first place.

>   Never depend on the class-specific links back to the /sys/class
>   directory.

DO NOT DO $XXX.

>   Never depend on a specific parent device position in the devpath,
>   or the chain of parent devices.

DO NOT DO $XXX.

Although I am curious about this paragraph.  Not that I'm really trying to 
document this bit, but "You must always request the parent device you are 
looking for by its subsystem value." does not explain HOW to request a 
specific device by its subsystem value.  According to the earlier bullet 
point about "subsystem", it's a simple string "(block, tty, pci, ...)" that 
seems to indicate a category of devices rather than a specific device...

And that is the end of the document.

Now, where in it did it explain how to determine whether a device is a block 
device or a char device when attempting to use the major and minor numbers 
extracted from sysfs to do a mknod?

> > This document is trying to document just enough information to make
> > hotplug work using sysfs (which includes firmware loading if necessary).
> >
> > > (And how about referring to Documentation/sysfs-rules.txt?)
> >
> > Because there isn't one in 2.6.22, and I've been writing this file on and
> > off for a month as I tracked down various bits of information?
>
> That was a _suggestion_.
>
> > I know.  I'm just trying to show people how to do it.  Notice that this
> > script doesn't DO anything, it just dumps the variables (and proves
> > that /sys/hotplug got called).  You're worried about the scalability of a
> > debugging script.
>
> If you use bash scripts as examples, people will write bash scripts.

And they'll find out, as I did, that it scales horribly.  (Scanning /dev with 
a shell script took about 15 seconds last time I tried it, which was 2 
laptops ago...)

I can document scalability issues, though.  (That and sequencing are why the 
netlink method exists in the first place...)

I was writing up a "history of hotplug" document that got trashed when my 
laptop died last month, but when I get around to rewriting it I plan to 
mention how /sys/hotplug was originally a big shell script and why they 
stopped doing that:
http://lwn.net/2001/0830/a/diet-hotplug.php3

> > (Rummage)  Seems to be "add, remove, change, online, offline, move"?
> >
> > I can list 'em.  Now I'm vaguely curious what generates online and
> > offline events (MII transciever state transitions on a network card, or
> > does this have to do with power saving modes?)  And I have no idea what
> > the difference between "change" and "move" is....
>
> "change" - something about the device has changed
> "move" - the device is in a different position in the tree now
>
> You may want to grep for the usage...

I did, thanks.

> > > No. For devices, SUBSYSTEM may be the class (like 'scsi_device') or the
> > > bus (like 'pci').
> >
> > Do you make a /dev node for either one?
> >
> > I'm trying to, at minimum, document what you pass to mknod.  I consider
> > it important to know.
>
> The problem is that your information is wrong. Imagine someone reading
> this document, thinking "cool, I'll create a char node if
> SUBSYSTEM!=block" and subsequently getting completely confused about
> all those SUBSYSTEM==pci events.

They get major and minor numbers for SUBSYSTEM==pci?

Is there something wrong other than the need to filter out /sys/class/block if 
that starts contaminating the pool of char devices (which it isn't in current 
kernels)?

> > > >   DRIVER
> > > >     If present, a suggested driver (module) for handling this device.
> > > >  No relation to whether or not a driver is currently handling the
> > > > device.
> > >
> > > No, this actually is the current driver.
> >
> > I've had it suggest drivers for devices that didn't have any loaded, and
> > I had it _not_ specify drivers for devices that were loaded.  (I
> > checked.)
>
> The code disagrees with you. If a driver matches and probing succeeds,
> it will be specified, otherwise not. Maybe you were checking the wrong
> devices?

Could be.  Or I could have been looking at an old kernel.

> > Ah yes.  I replied to that when it was first posted.  It's still "here's
> > a list of things NOT to do" rather then telling you what you CAN do.  I'm
> > trying to document what you can do.
> >
> > Useful documentation is not "Doing THIS is forbidden.  Doing THIS is
> > forbidden.  Doing THIS is forbidden.  What are you allowed to do?  Guess!
> > Oh, and anything I didn't explicitly mention could change at any time. 
> > Have fun."
>
> It _does_ specify what you may rely on. Don't rely on anything else.

Ok, how do I find a list of:

A) all char devices in the system.
B) all block devices currently in the system
C) whether a device that just got hotplugged (and I just got a hotplug event 
for) is a char or block device so I can call mknod?  (I know how to tell when 
there's no device node for it, there's no "dev" entry or no MAJOR=/MINOR= 
variables.  But when I do have those, how do I tell if they refer to a block 
or a char device?

Are you saying there's no reliable way to do that, or are you saying the 
document explains how to do that?

> > Sysfs CAN export a stable API.  It may only be a subset of what it's
> > exporting, but it can still do so.
>
> And that is exactly what sysfs-rules.txt is doing.

What does going on about buggy apps have to do with listing what you're 
allowed to do?  Listing things not to do isn't the same as listing what 
you're allowed to do, unless attempting to arrive at an API document by 
process of elimination.

> I don't understand your problem.

I've noticed.  I suspect I phrased my goals unclearly.

> If you think that getting this information from sysfs-rules.txt could
> be made easier, do a patch against it.

I'm trying to document hotplug, which includes scanning to initially 
populate /dev, and firmware loading.  Documenting a portion of sysfs is a 
side effect of documenting hotplug.

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
