Return-Path: <linux-kernel-owner+w=401wt.eu-S1757610AbXGRH7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610AbXGRH7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 03:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752754AbXGRH7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 03:59:10 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:22198 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbXGRH7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 03:59:08 -0400
Date: Wed, 18 Jul 2007 09:58:57 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, "Greg KH" <greg@kroah.com>,
       Michael-Luke Jones <mlj28@cam.ac.uk>, Krzysztof Halasa <khc@pm.waw.pl>,
       Rod Whitby <rod@whitby.id.au>, Russell King <rmk@arm.linux.org.uk>,
       david@lang.hm
Subject: Re: Documentation for sysfs, hotplug, and firmware loading.
Message-ID: <20070718095857.5365323a@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <200707171703.31340.rob@landley.net>
References: <200707171703.31340.rob@landley.net>
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

On Tue, 17 Jul 2007 17:03:31 -0400,
Rob Landley <rob@landley.net> wrote:

> Here's some sysfs/hotplug/firmware loading documentation I wrote.  I finally 
> tracked down the netlink bits to finish it up, so I can send it out to the 
> world.
> 
> What's wrong with it? :)

OK, some comments from me:


> Entires for block devices are found at the following locations:
  ^^^^^^^ typo
>
>  /sys/block/*/dev
>  /sys/block/*/*/dev

Note that this will change to /sys/class/block/ in the future.

> Entries for char devices are found at the following locations:
> 
>  /sys/bus/*/devices/*/dev
>  /sys/class/*/*/dev

Uh, that is actually the generic location?

It may be enough (and less confusing) to just state that the dev
attribute will belong to the associated "class" device sitting
under /sys/class/ (with the current exception of /sys/block/).

(And how about referring to Documentation/sysfs-rules.txt?)

> A simple bash script to record variables from hotplug events might look like:

Using a bash script is actually a very bad idea in the general case. It
can lead to OOM very quickly on large installations.

> It's possible to disable the usermode helper hotplug mechanism (by writing an
> empty string into /proc/sys/kernel/hotplug), but there's little reason to
> do this since a usermode helper won't be spawned if /sbin/hotplug doesn't
> exist, and negative dentries will record the fact it doesn't exist after
> the first lookup attempt.

AFAIK, the normal mode of operation is to use the hotplug mechanism
during early setup but to disable it once you have a listener on
netlink in place. My systems have an empty /proc/sys/kernel/hotplug.


>   ACTION
>     The current hotplug action: "add" to add the device...
>     [QUESTION: Full list of actions?]

Would be good. See lib/kobject_uevent.c.

>   DEVPATH
>     Path under /sys at which this device's sysfs directory can be found.
>     If $DEVPATH begins with /block/ the event refers to a block device,
>     otherwise it refers to a char device.

Huh? That's just the path in sysfs. And there's more than block and
char :) Check SUBSYSTEM for what your device actually is.

>   SUBSYSTEM
>     If this is "block", it's a block device.  Anything else is a char device.

No. For devices, SUBSYSTEM may be the class (like 'scsi_device') or the
bus (like 'pci').

>   DRIVER
>     If present, a suggested driver (module) for handling this device.  No
>     relation to whether or not a driver is currently handling the device.

No, this actually is the current driver.

> stable_api_nonsense:
> ====================
> 
> Note: Sysfs exports a lot of kernel internal state, and the maintainers of
> sysfs do not believe that exposing information to userspace for use by
> userspace programs constitues an "API" that must be "stable".  The sysfs
> infrastructure is maintained by the author of
> Documentation/stable_api_nonsense.txt, who seems to believe it applies to
> userspace as well.  Therefore, at best only a subset of the information in
> sysfs can be considered stable from version to version.
> 
> The information documented here should remain stable.  Some other parts
> of sysfs are documented under Documentation/API, although that
> directory comes with a warning that anything documented there can go
> away after two years. Any other information exported by sysfs should be
> considered debugging info at best, and probably shouldn't have been
> exported at all since it's not a "stable API" intended for use by
> actual programs.

Uh. Please refer to Documentation/sysfs-rules.txt.
