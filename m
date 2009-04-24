Return-Path: <linux-kernel-owner+w=401wt.eu-S1758347AbZDXVc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758347AbZDXVc6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 17:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756917AbZDXVcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 17:32:45 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:27023 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756692AbZDXVco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 17:32:44 -0400
X-IronPort-AV: E=Sophos;i="4.40,243,1238976000"; 
   d="scan'208";a="292518748"
Date: Fri, 24 Apr 2009 14:32:38 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jamie Lokier <jamie@shareable.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Linux Embedded Mailing List <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Wait for console to become available, v3.2
Message-ID: <20090424213238.GA5973@cuplxvomd02.corp.sa.net>
References: <20090424003555.GA31173@cuplxvomd02.corp.sa.net> <Pine.LNX.4.44L0.0904241502440.4531-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0904241502440.4531-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-2; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 24, 2009 at 03:20:42PM -0400, Alan Stern wrote:
> On Thu, 23 Apr 2009, David VomLehn wrote:
> 
> > I'm still scratching my head, trying to figure out where I can tap into the
> > 'USB notion of "all devices that were present at boot time have been probed"'
> > that Alan mentions above, so I don't have a specific implementation yet. I'm
> > open to any tips in this area.
> 
> This is a general notion; it applies to all subsystems that do
> asynchronous device discovery or registration.  The idea is simple
> enough: Keep a count of all devices which are known or suspected to be
> present, and decrement the count each time one of them is registered or
> determined not to exist.  When the count first reaches 0, all devices
> that were present (or reachable) at boot time will have been
> registered.
> 
> Isn't this basically what you had in mind?  If you're concerned about 
> the USB implementation, don't be -- I can write it quite easily.

I will absolutely take you up on your offer to lash this into USB. I'm still
fine-tuning a few details but will send out a patch soon, probably today. It's
a bit hard to test it and I'm sure it will need revision, but it will help a
whole bunch to have a USB implementation to play with.

> It's not just hot-pluggable devices.  These ideas are appropriate 
> whenever detection or registration is asynchronous.

This is very true, and I should modify the nomenclature to reflect this.

> > There currently two types supported:
> > -	consoles
> > -	network devices
> 
> You might as well add block devices too.

Yes, we should. My guess is block devices that hang off of buses besides USB
would be able to use this.

> > bus_bootdev_initialized(int bootdev_mask)
> > 	This function must be called by the bus support code after it calls the
> > 	initialiation function for a boot device. Every call to
> > 	bus_bootdev_found must be matched by a call to
> > 	bus_bootdev_initialized with the same bootdev_mask.
> 
> Even if the device can't be initialized for some reason, or if it turns
> out not the be the sort of boot device originally thought, this
> function still has to be called.  That should be made extremely clear.

True, and I was hoping that was clear enough, but I'll go back and emphasize
this more.

> > 	Device initialization functions must have called the appropriate
> > 	registration function for that device before bus_bootdev_initialized
> > 	is called. So, for console devices, register_console must be called
> > 	before bus_bootdev_initialized, and for network devices,
> > 	register_netdevice must be called first.
> 
> It's not clear how either of these two functions is bus-specific.

They aren't, not directly.  I *think* there isn't a problem here, but it
is certainly possible that the driver wouldn't register the device until some
time after its probe function is called. If that's the case, we would still
have a race condition when we went to use the device, which would defeat the
whole purpose of this change. Determining whether actually have a problem
here is probably too difficult to do beforehand; if an issue exists will find
it during use. Not the ideal approach, but this is engineering and not math.

> This looks like a good plan and not hard to implement.  It even should 
> be possible to fit USB disk drives into the scheme.

That would definitely rock. 

> Alan Stern

David VomLehn
