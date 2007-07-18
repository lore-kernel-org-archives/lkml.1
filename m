Return-Path: <linux-kernel-owner+w=401wt.eu-S935591AbXGRRkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935591AbXGRRkO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 13:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbXGRRkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 13:40:00 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:60490
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763072AbXGRRj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 13:39:58 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: Documentation for sysfs, hotplug, and firmware loading.
Date: Wed, 18 Jul 2007 13:39:53 -0400
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, "Greg KH" <greg@kroah.com>,
       Michael-Luke Jones <mlj28@cam.ac.uk>, Krzysztof Halasa <khc@pm.waw.pl>,
       Rod Whitby <rod@whitby.id.au>, Russell King <rmk@arm.linux.org.uk>,
       david@lang.hm
References: <200707171703.31340.rob@landley.net> <20070718095857.5365323a@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070718095857.5365323a@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707181339.54192.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 July 2007 3:58:57 am Cornelia Huck wrote:
> On Tue, 17 Jul 2007 17:03:31 -0400,
>
> Rob Landley <rob@landley.net> wrote:
> > Here's some sysfs/hotplug/firmware loading documentation I wrote.  I
> > finally tracked down the netlink bits to finish it up, so I can send it
> > out to the world.
> >
> > What's wrong with it? :)
>
> OK, some comments from me:
> > Entires for block devices are found at the following locations:
>
>   ^^^^^^^ typo

Got it.

> >  /sys/block/*/dev
> >  /sys/block/*/*/dev
>
> Note that this will change to /sys/class/block/ in the future.

At OLS, Kay Sievers said in a future version they were going to move it 
to "/sys/subsystem/block", which I can't document right now because no 
current kernel does this, and that path will never work with any previous 
kernel, but there should be a compatability symlink from the old path to the 
new one.  He never mentioned /sys/class/block.

To all of this, I would like to humbly ask:

PICK ONE!  JUST #*%(&#%& PICK ONE!  AAAAAAAAHHHHHHH!!!!!!!!!

I don't care where it is.  Just put it somewhere I can find it, and keep it 
there.  All this gratuitous moving stuff around serves NO PURPOSE other than 
to break userspace.  I'm trying to document this so that the next time you 
go "oh wait, it should be at "/sys/tarantula/fruitbat" I can show that you're 
breaking an existing documented userspace API.

There's a kernel config option to make symlinks from the old 
location.  /sys/block makes as much sense as any other location, and it's 
what's there now.

> > Entries for char devices are found at the following locations:
> >
> >  /sys/bus/*/devices/*/dev
> >  /sys/class/*/*/dev
>
> Uh, that is actually the generic location?

It's what Kay Sievers and Greg KH told me at OLS when I tracked them down to 
ask.  I've also experimentally verified it working on Ubuntu 7.04.  That was 
cut and pasted from Kay's email, and it works today.

> It may be enough (and less confusing) to just state that the dev
> attribute will belong to the associated "class" device sitting
> under /sys/class/ (with the current exception of /sys/block/).

Nope.  If you recurse down under /sys/class following symlinks, you go into an 
endless loop bouncing off of /sys/devices and getting pointed back.  If you 
don't follow symlinks, it works fine up until about 2.6.20 at which point 
things that were previously directories BECAME symlinks because the 
directories got moved, and it all broke.

Which is why I want it documented where to look for these suckers.  Just give 
me ONE STABLE WAY TO FIND THIS INFORMATION, PLEASE.

This document is trying to document just enough information to make hotplug 
work using sysfs (which includes firmware loading if necessary).

> (And how about referring to Documentation/sysfs-rules.txt?)

Because there isn't one in 2.6.22, and I've been writing this file on and off 
for a month as I tracked down various bits of information?

> > A simple bash script to record variables from hotplug events might look
> > like:
>
> Using a bash script is actually a very bad idea in the general case. It
> can lead to OOM very quickly on large installations.

I know.  I'm just trying to show people how to do it.  Notice that this script 
doesn't DO anything, it just dumps the variables (and proves 
that /sys/hotplug got called).  You're worried about the scalability of a 
debugging script.

> > It's possible to disable the usermode helper hotplug mechanism (by
> > writing an empty string into /proc/sys/kernel/hotplug), but there's
> > little reason to do this since a usermode helper won't be spawned if
> > /sbin/hotplug doesn't exist, and negative dentries will record the fact
> > it doesn't exist after the first lookup attempt.
>
> AFAIK, the normal mode of operation is to use the hotplug mechanism
> during early setup but to disable it once you have a listener on
> netlink in place. My systems have an empty /proc/sys/kernel/hotplug.

And I documented how to blank it.  However, lots of embedded systems stick 
with one mechanism because having two is something they won't waste space on.  
(I note that mdev is about 5k and can be made to use very little memory per 
instance.)

Also, you can hold off on all device probing until a netlink daemon is up and 
then echo "add" to all the "uevent" entries you find.  At one point, udev did 
this, dunno what it's doing now.

> >   ACTION
> >     The current hotplug action: "add" to add the device...
> >     [QUESTION: Full list of actions?]
>
> Would be good. See lib/kobject_uevent.c.

Ah, I left a TODO item in there that I forgot to mark TODO. :)

(Rummage)  Seems to be "add, remove, change, online, offline, move"?

I can list 'em.  Now I'm vaguely curious what generates online and offline 
events (MII transciever state transitions on a network card, or does this 
have to do with power saving modes?)  And I have no idea what the difference 
between "change" and "move" is....

> >   DEVPATH
> >     Path under /sys at which this device's sysfs directory can be found.
> >     If $DEVPATH begins with /block/ the event refers to a block device,
> >     otherwise it refers to a char device.
>
> Huh? That's just the path in sysfs. And there's more than block and
> char :) Check SUBSYSTEM for what your device actually is.

If you are doing mknod, you need three pieces of information:
1) Major, 2) Minor, 3) Block or Char device.  That's pretty much it.  If 
you're trying to populate /dev you need that info.

> >   SUBSYSTEM
> >     If this is "block", it's a block device.  Anything else is a char
> > device.
>
> No. For devices, SUBSYSTEM may be the class (like 'scsi_device') or the
> bus (like 'pci').

Do you make a /dev node for either one?

I'm trying to, at minimum, document what you pass to mknod.  I consider it 
important to know.

> >   DRIVER
> >     If present, a suggested driver (module) for handling this device.  No
> >     relation to whether or not a driver is currently handling the device.
>
> No, this actually is the current driver.

I've had it suggest drivers for devices that didn't have any loaded, and I had 
it _not_ specify drivers for devices that were loaded.  (I checked.)

Could I get some clarification here?

> > stable_api_nonsense:
> > ====================
> >
> > Note: Sysfs exports a lot of kernel internal state, and the maintainers
> > of sysfs do not believe that exposing information to userspace for use by
> > userspace programs constitues an "API" that must be "stable".  The sysfs
> > infrastructure is maintained by the author of
> > Documentation/stable_api_nonsense.txt, who seems to believe it applies to
> > userspace as well.  Therefore, at best only a subset of the information
> > in sysfs can be considered stable from version to version.
> >
> > The information documented here should remain stable.  Some other parts
> > of sysfs are documented under Documentation/API, although that
> > directory comes with a warning that anything documented there can go
> > away after two years. Any other information exported by sysfs should be
> > considered debugging info at best, and probably shouldn't have been
> > exported at all since it's not a "stable API" intended for use by
> > actual programs.
>
> Uh. Please refer to Documentation/sysfs-rules.txt.

Where do I find this?  It's not in 2.6.22, and -rc1 isn't out yet, so I assume 
you mean it's in the random git snapshot du jour?

(Rummages...)

Sigh.  Missed that thread, and yes I've been working on this document since 
well before that was posted...

Ah yes.  I replied to that when it was first posted.  It's still "here's a 
list of things NOT to do" rather then telling you what you CAN do.  I'm 
trying to document what you can do.

Useful documentation is not "Doing THIS is forbidden.  Doing THIS is 
forbidden.  Doing THIS is forbidden.  What are you allowed to do?  Guess!  
Oh, and anything I didn't explicitly mention could change at any time.  Have 
fun."

Sysfs CAN export a stable API.  It may only be a subset of what it's 
exporting, but it can still do so.

Sigh.  I'll dig through this to try to find useful information amongst 
the "thou shalt nots", but I've got to catch a plane in a couple hours.  
Maybe on the flight...

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
