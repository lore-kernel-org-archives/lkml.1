Return-Path: <linux-kernel-owner+w=401wt.eu-S1756204AbZDZR4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbZDZR4P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 13:56:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755167AbZDZR4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 13:56:00 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:35940 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670AbZDZRz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 13:55:58 -0400
X-IronPort-AV: E=Sophos;i="4.40,249,1238976000"; 
   d="scan'208";a="293201053"
Date: Sun, 26 Apr 2009 10:55:37 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: Jamie Lokier <jamie@shareable.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Linux Embedded Mailing List <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Wait for console to become available, v3.2
Message-ID: <20090426175537.GB18594@cuplxvomd02.corp.sa.net>
References: <20090424003555.GA31173@cuplxvomd02.corp.sa.net> <Pine.LNX.4.44L0.0904241502440.4531-100000@iolanthe.rowland.org> <20090424213238.GA5973@cuplxvomd02.corp.sa.net> <20090424221951.GC18260@shareable.org> <20090424231013.GA18340@cuplxvomd02.corp.sa.net> <20090425014152.GD23106@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090425014152.GD23106@shareable.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-4; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 25, 2009 at 02:41:52AM +0100, Jamie Lokier wrote:
> David VomLehn wrote:
> > I think this is over-engineered. This focused on boot devices, so you really
> > don't care about things like buses, and I don't perceive a broader use. What
> > really matters is particular boot device types, wherever they came from.
> 
> I'm thinking this broader use:
> 
>     - My boot _script_ is waiting for a disk which identifies as
>       UUID=392852908752345749857 to appear before it can mount it on
>       /data.  If there's no such disk, it proceeds without it.  It's a
>       USB disk, behind a USB hub.
> 
>     - My boot script is looking to see if I'm holding down 'z' on the
>       keyboard, to do something different.  But how does it know if
>       there's a USB keyboard plugged in (behind two USB hubs) that
>       hasn't finished being detected?
> 
> It just seemed to fit comfortably into what's being discussed.
> 
> (I do have these a system with these requirements, by the way.  It's
> solved at the moment by waiting 5 seconds after booting, and by using
> an older kernel which doesn't have boot parallelisation yet...)

If the keyboard is being used for the console, this should fix your problem.
If not, I think you can fix it by using a hotplug script.

> Only one problem I see: what happens when there's an attempt to open
> /dev/console before you increment the pending count?  It seems to me
> you have to wait for all buses to have been detected, which is why I
> mentioned buses, as some buses are _themselves_ slow devices to detect.

A valid point. I just sent an updated patch to address this.

> > The key question is, are there cases where there is enough time between steps
> > 1 and 2, and steps 2 and 3, to add this complexity? If not, let's skip it.
> 
> The time between enumerating that a USB device exists and what it's
> class is (could be a console?), and actually initialising the device
> to find out if it's then usable, including loading firmware, can be a
> little while.
> 
> I don't know if the times are long enough to matter.

Me neither, but I went ahead and added bus_bootdev_type_found. It's a trivial
piece of code and will allow this case to be handled cleanly.

> Possibly related to all this: it would be really nice if the ATA
> rather slow probe time didn't have to delay boot scripts until they
> depend on the not-yet-probed disks, as sometimes they might not.

Related to boot time, yes, but it sounds like it's not related to the
boot device issue. By the time you get to boot scripts, you've initialized
all the boot devices you're going to.

> -- Jamie

David VomLehn
