Return-Path: <linux-kernel-owner+w=401wt.eu-S936026AbXGSIQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936026AbXGSIQ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 04:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761313AbXGSIQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 04:16:42 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:18923 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759213AbXGSIQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 04:16:39 -0400
Date: Thu, 19 Jul 2007 10:16:17 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, "Greg KH" <greg@kroah.com>,
       Michael-Luke Jones <mlj28@cam.ac.uk>, Krzysztof Halasa <khc@pm.waw.pl>,
       Rod Whitby <rod@whitby.id.au>, Russell King <rmk@arm.linux.org.uk>,
       david@lang.hm
Subject: Re: Documentation for sysfs, hotplug, and firmware loading.
Message-ID: <20070719101617.08c867a7@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <200707181339.54192.rob@landley.net>
References: <200707171703.31340.rob@landley.net>
	<20070718095857.5365323a@gondolin.boeblingen.de.ibm.com>
	<200707181339.54192.rob@landley.net>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jul 2007 13:39:53 -0400,
Rob Landley <rob@landley.net> wrote:

> Nope.  If you recurse down under /sys/class following symlinks, you go into an 
> endless loop bouncing off of /sys/devices and getting pointed back.  If you 
> don't follow symlinks, it works fine up until about 2.6.20 at which point 
> things that were previously directories BECAME symlinks because the 
> directories got moved, and it all broke.

I have no idea what you're doing.

> Which is why I want it documented where to look for these suckers.  Just give 
> me ONE STABLE WAY TO FIND THIS INFORMATION, PLEASE.

See Documentation/sysfs-rules.txt.

> This document is trying to document just enough information to make hotplug 
> work using sysfs (which includes firmware loading if necessary).
> 
> > (And how about referring to Documentation/sysfs-rules.txt?)
> 
> Because there isn't one in 2.6.22, and I've been writing this file on and off 
> for a month as I tracked down various bits of information?

That was a _suggestion_.

> I know.  I'm just trying to show people how to do it.  Notice that this script 
> doesn't DO anything, it just dumps the variables (and proves 
> that /sys/hotplug got called).  You're worried about the scalability of a 
> debugging script.

If you use bash scripts as examples, people will write bash scripts.

> (Rummage)  Seems to be "add, remove, change, online, offline, move"?
> 
> I can list 'em.  Now I'm vaguely curious what generates online and offline 
> events (MII transciever state transitions on a network card, or does this 
> have to do with power saving modes?)  And I have no idea what the difference 
> between "change" and "move" is....

"change" - something about the device has changed
"move" - the device is in a different position in the tree now

You may want to grep for the usage...

> 
> > >   DEVPATH
> > >     Path under /sys at which this device's sysfs directory can be found.
> > >     If $DEVPATH begins with /block/ the event refers to a block device,
> > >     otherwise it refers to a char device.
> >
> > Huh? That's just the path in sysfs. And there's more than block and
> > char :) Check SUBSYSTEM for what your device actually is.
> 
> If you are doing mknod, you need three pieces of information:
> 1) Major, 2) Minor, 3) Block or Char device.  That's pretty much it.  If 
> you're trying to populate /dev you need that info.
> 
> > >   SUBSYSTEM
> > >     If this is "block", it's a block device.  Anything else is a char
> > > device.
> >
> > No. For devices, SUBSYSTEM may be the class (like 'scsi_device') or the
> > bus (like 'pci').
> 
> Do you make a /dev node for either one?
> 
> I'm trying to, at minimum, document what you pass to mknod.  I consider it 
> important to know.

The problem is that your information is wrong. Imagine someone reading
this document, thinking "cool, I'll create a char node if
SUBSYSTEM!=block" and subsequently getting completely confused about
all those SUBSYSTEM==pci events.

> 
> > >   DRIVER
> > >     If present, a suggested driver (module) for handling this device.  No
> > >     relation to whether or not a driver is currently handling the device.
> >
> > No, this actually is the current driver.
> 
> I've had it suggest drivers for devices that didn't have any loaded, and I had 
> it _not_ specify drivers for devices that were loaded.  (I checked.)

The code disagrees with you. If a driver matches and probing succeeds,
it will be specified, otherwise not. Maybe you were checking the wrong
devices?

> Ah yes.  I replied to that when it was first posted.  It's still "here's a 
> list of things NOT to do" rather then telling you what you CAN do.  I'm 
> trying to document what you can do.
> 
> Useful documentation is not "Doing THIS is forbidden.  Doing THIS is 
> forbidden.  Doing THIS is forbidden.  What are you allowed to do?  Guess!  
> Oh, and anything I didn't explicitly mention could change at any time.  Have 
> fun."

It _does_ specify what you may rely on. Don't rely on anything else.

> Sysfs CAN export a stable API.  It may only be a subset of what it's 
> exporting, but it can still do so.

And that is exactly what sysfs-rules.txt is doing. I don't understand
your problem.

If you think that getting this information from sysfs-rules.txt could
be made easier, do a patch against it.
