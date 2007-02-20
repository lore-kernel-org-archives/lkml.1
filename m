Return-Path: <linux-kernel-owner+w=401wt.eu-S932839AbXBTFT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932839AbXBTFT3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 00:19:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965177AbXBTFT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 00:19:29 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:49403 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932839AbXBTFT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 00:19:29 -0500
Date: Mon, 19 Feb 2007 23:18:33 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Serial related oops
In-reply-to: <f2b55d220702192059q454bd54dwc965620451211e5b@mail.gmail.com>
To: "Michael K. Edwards" <medwards.linux@gmail.com>
Cc: Jose Goncalves <jose.goncalves@inov.pt>,
       Frederik Deweerdt <deweerdt@free.fr>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Message-id: <45DA84A9.5010908@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.0IigYYV566ZB0kBHCj88jOEJx1s@ifi.uio.no>
 <fa.IE91N03KQO01UZbOdcF6HewOdYc@ifi.uio.no> <45DA618B.6040603@shaw.ca>
 <f2b55d220702192059q454bd54dwc965620451211e5b@mail.gmail.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael K. Edwards wrote:
> Of course not.  But dealing with a stuck IRQ line by locking up isn't
> very practical either.  IRQ sharing is stupid yet universal, and it

And we don't, that's why we have that "nobody cared" logic that disables 
the interrupt line if no driver services the interrupt. That doesn't 
provide a clean recovery, of course, it's meant to notify the user of 
what happened so that the problem can be fixed.

> happens all the time that a device that has been sitting there minding
> its own business since power-up, with no driver to drive it, decides
> to assert its IRQ.  Maybe it just got hot-plugged, maybe it just got
> its first dribble of input, whatever.  Other devices on the shared IRQ
> are screwed (or at least semi-screwed; you could periodically
> re-enable the IRQ long enough to make a run through the ISR chain
> servicing the other devices).  But if you run "lspci" (or whatever)
> and load a driver for the newly awake device, everything goes back to
> normal.
> 
> For devices compiled into the kernel, you shouldn't have to play these
> games.  If, that is, there were three stages of driver initialization,
> called in successive passes:

Exactly, for devices compiled into the kernel. In most setups this is 
only a fraction of all devices, so solving this problem only for drivers 
built into the kernel is no solution.

> 
> 1) installing an ISR with a fallback STFU path (device-specific but
> not dependent on any particular pre-existing chip state), quiescing it
> if you know how and registering for the IRQ if you know which it is;
> 
> 2) going through the chip's soft-reset-wake-up-shut-up cycle and
> populating driver data structures, possibly correcting the IRQ
> registration along the way;
> 
> 3) ready-as-we'll-ever-be, bring on the interrupts.
> 
> You probably can't help enabling the IRQ briefly during 2) so that you
> can do tests like Russell's loopback.  But it's a needless gamble to
> do that without doing 1) for all compiled-in drivers and platform
> devices first, in a previous discovery pass.  And it's stupid to do 3)
> in the same pass as 2), because you'll just open race condition
> windows that will only bite when an all-the-way-live device raises its
> IRQ at a moment when the writer of the wake-up-shut-up code wasn't
> expecting it.  All code has bugs and they're only a problem when they
> bite in the field.
> 
>> If a system has a device that generates interrupts before they're 
>> enabled,
>> and the firmware doesn't fix it, then some platform-specific quirk has to
>> handle it and shut off the interrupt before it allows any interrupts
>> to be enabled. (We have such a quirk for certain network controllers 
>> where
>> the boot ROM can leave the chip generating interrupts on bootup.)
> 
> You don't need quirks if your driver initialization is bomb-proof to
> begin with.  Devices that are quiet on power-up are purely
> coincidental and should not be construed.

It's not coincidental, it is the only sane way to design hardware. You 
just can't go firing off interrupts without a driver having 
intentionally enabled them. There are a few devices that have had such 
issues, but they have been few and far between, certainly not enough to 
warrant the complexity of the scheme you propose.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

