Return-Path: <linux-kernel-owner+w=401wt.eu-S1756054AbZDUXJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbZDUXJQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 19:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475AbZDUXI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 19:08:58 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:54497 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbZDUXI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 19:08:56 -0400
X-IronPort-AV: E=Sophos;i="4.40,226,1238976000"; 
   d="scan'208";a="174913933"
Date: Tue, 21 Apr 2009 16:08:49 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jamie Lokier <jamie@shareable.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Linux Embedded Mailing List <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Wait for console to become available, v3.2
Message-ID: <20090421230849.GA29555@cuplxvomd02.corp.sa.net>
References: <20090421165214.GB8251@cuplxvomd02.corp.sa.net> <Pine.LNX.4.44L0.0904211457150.3986-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0904211457150.3986-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-4; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 03:09:52PM -0400, Alan Stern wrote:
> On Tue, 21 Apr 2009, David VomLehn wrote:
> 
> > > If somebody would like to suggest a programming interface (a waitqueue 
> > > perhaps?) by which the USB hub driver could send a notification when it 
> > > becomes idle, I could implement it.
> > 
> > I actually started the USB console stuff with exactly this approach, but
> > switched to the approach that's out there. A minor drawback, which is
> > probably obvious, is that you actually wait for some interval without
> > getting anything to do before you think things are idle.
> 
> Sorry, I don't understand.  You've got a waitqueue, and you wake up to
> try again every time a console device is registered.  So if the console
> device does exist, you'll find it as quickly as possible.  There's a
> problem only when no console device is ever registered.  In that case
> you want to stop waiting when all the devices present at boot time have
> been probed (as opposed to waiting for the user to plug in a USB serial
> device, for example).
> 
> So then the problem becomes: How do you tell when all the USB devices 
> present at boot time have been probed?  That's exactly what this new 
> interface is supposed to tell you.

The current patch already uses a waitqueue and wakes up as soon as a console
is registered, so that's the same. I agree that the other piece is determining
when all USB devices at boot time have been probed. For this suggestion to
work, two conditions must be met:
1.	The USB hub driver becoming idle must indicate that every device has
	been probed.
2.	The USB driver must become idle after every USB device has been
	probed.

If both conditions are met, this is a superior to a timeout for determining
that the console will not show up. It would surprise me a bit if the first
condition was true. Still, if it is true that the USB hub driver will be
idle for some interval I, where I is greater than the timeout we would
otherwise use, it is still a better approach.

There is one other possible gotcha to this approach. The code as I wrote it is
bus-agnostic, i.e. it has no idea where the console is located. As far as
I know, the long time to probe possible console devices only arises with
USB. If this is not tree, we need to handle any other cases that can arise.

> >  But a bigger
> > drawback is that you lose the ability to chose appropriate intervals for
> > different classes of devices.
> 
> Why do you need to choose any intervals at all?  Just keep waiting
> until you know there's no point waiting any longer.  If you stop 
> waiting before then, you run the risk of missing a device that could 
> have worked.

The question about appropriate intervals is that I need to wait for some
devices, like consoles and network devices, but not all devices, like printers
and cameras. There is no telling whether any two devices require the same
interval when I am tuning it for my particular system. And if I have a USB
console and no USB Ethernet device, I only want to wait for the console
probe interval.

> > So far, there appear to be three possible USB boot devices: consoles, network
> > devices, and boot devices.
> 
> Is that last supposed to be "disk drives containing root filesystems"?

Yup.

> > A system may not have all of these and so may not
> > need to wait as long as a system with all of them. One of my goals is to
> > preserve as much of the reduction in boot time as possible, even on systems
> > that use USB devices that may or may not be plugged in.
> 
> Let's take console devices as an example.  If one is present then you
> do want to wait until it is detected, instead of booting as quickly as
> possible, right?  Which implies that if one isn't present, you want to 
> wait until you _know_ that it's not present.  Which means waiting all 
> all the devices present during boot have been probed.
> 
> This approach should work fine with USB consoles and network devices;
> it's not so easy to implement for USB disk drives.  So let's not worry 
> about them.

I'm kinda flexible about whether all possible consoles show up; the patch
presently only waits for a console to be identified as the "preferred" console.
This gets the system going as soon as you have some place to write output,
but I won't argue with anyone who says we need to wait for all possible
consoles.

> Now the only drawback I can see would crop up if some device takes a
> very long time to probe (perhaps because of errors and retries).  If
> there's no other console device, it could slow down the boot procedure
> quite a lot.  But there doesn't appear to be any logical alternative,
> given your goals as stated above.

If there is a way to guarantee that we are done with the probing, I'm
all for using that. Will waiting for the USB hub driver to be idle do this?

> Alan Stern

David VomLehn
