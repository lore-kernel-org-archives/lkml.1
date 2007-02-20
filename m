Return-Path: <linux-kernel-owner+w=401wt.eu-S965115AbXBTE7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965115AbXBTE7v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 23:59:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965117AbXBTE7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 23:59:51 -0500
Received: from wr-out-0506.google.com ([64.233.184.238]:55677 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965115AbXBTE7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 23:59:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gePNDgZdGHftddzdQFXQnd39z5j12iSIpmr0Qap9mOan+WSrRssQYAfgzfmENaUqDOxf4sT0pCXZSQk+ArIiYFIqnkL5sbFl7+t6ycVdx4Tel2NV27Q3DqyVZR8Rv0iyPZlLuKuX0hvrpgOgP1hJynmSFXEN3oQm+Up4TQ9HID0=
Message-ID: <f2b55d220702192059q454bd54dwc965620451211e5b@mail.gmail.com>
Date: Mon, 19 Feb 2007 20:59:46 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Robert Hancock" <hancockr@shaw.ca>
Subject: Re: Serial related oops
Cc: "Jose Goncalves" <jose.goncalves@inov.pt>,
       "Frederik Deweerdt" <deweerdt@free.fr>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <45DA618B.6040603@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.0IigYYV566ZB0kBHCj88jOEJx1s@ifi.uio.no>
	 <fa.IE91N03KQO01UZbOdcF6HewOdYc@ifi.uio.no> <45DA618B.6040603@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/19/07, Robert Hancock <hancockr@shaw.ca> wrote:
> How do you propose to do this? Drivers can get loaded and unloaded at any
> time. If you have a device generating spurious interrupts on a shared IRQ
> line, there's no way you can use any device on that line until that interrupt
> is shut off. Requiring all drivers to be loaded before any of them can use
> interrupts is simply not practical.

Of course not.  But dealing with a stuck IRQ line by locking up isn't
very practical either.  IRQ sharing is stupid yet universal, and it
happens all the time that a device that has been sitting there minding
its own business since power-up, with no driver to drive it, decides
to assert its IRQ.  Maybe it just got hot-plugged, maybe it just got
its first dribble of input, whatever.  Other devices on the shared IRQ
are screwed (or at least semi-screwed; you could periodically
re-enable the IRQ long enough to make a run through the ISR chain
servicing the other devices).  But if you run "lspci" (or whatever)
and load a driver for the newly awake device, everything goes back to
normal.

For devices compiled into the kernel, you shouldn't have to play these
games.  If, that is, there were three stages of driver initialization,
called in successive passes:

1) installing an ISR with a fallback STFU path (device-specific but
not dependent on any particular pre-existing chip state), quiescing it
if you know how and registering for the IRQ if you know which it is;

2) going through the chip's soft-reset-wake-up-shut-up cycle and
populating driver data structures, possibly correcting the IRQ
registration along the way;

3) ready-as-we'll-ever-be, bring on the interrupts.

You probably can't help enabling the IRQ briefly during 2) so that you
can do tests like Russell's loopback.  But it's a needless gamble to
do that without doing 1) for all compiled-in drivers and platform
devices first, in a previous discovery pass.  And it's stupid to do 3)
in the same pass as 2), because you'll just open race condition
windows that will only bite when an all-the-way-live device raises its
IRQ at a moment when the writer of the wake-up-shut-up code wasn't
expecting it.  All code has bugs and they're only a problem when they
bite in the field.

> If a system has a device that generates interrupts before they're enabled,
> and the firmware doesn't fix it, then some platform-specific quirk has to
> handle it and shut off the interrupt before it allows any interrupts
> to be enabled. (We have such a quirk for certain network controllers where
> the boot ROM can leave the chip generating interrupts on bootup.)

You don't need quirks if your driver initialization is bomb-proof to
begin with.  Devices that are quiet on power-up are purely
coincidental and should not be construed.

Cheers,
- Michael
