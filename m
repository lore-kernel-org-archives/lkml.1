Return-Path: <linux-kernel-owner+w=401wt.eu-S1757844AbYBTSiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757844AbYBTSiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 13:38:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753768AbYBTShy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 13:37:54 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53222 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752869AbYBTShw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 13:37:52 -0500
Date: Wed, 20 Feb 2008 10:37:04 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Chua <jeff.chua.linux@gmail.com>
cc: Jesse Barnes <jesse.barnes@intel.com>, lkml <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-acpi@vger.kernel.org,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       Greg KH <gregkh@suse.de>
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk.
 Screen becomes green.
In-Reply-To: <b6a2187b0802200954p1cccb01aqbc48c865797f0af1@mail.gmail.com>
Message-ID: <alpine.LFD.1.00.0802201007300.7833@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com>  <alpine.LFD.1.00.0802200922590.7833@woody.linux-foundation.org> <b6a2187b0802200954p1cccb01aqbc48c865797f0af1@mail.gmail.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 21 Feb 2008, Jeff Chua wrote:
> 
> > That said, before you do anything else, try if suspend-to-RAM works.
> 
> Linus, guess I missed this part ... so before touch anything, I did
> tried suspend-to-ram, and it works on console and in X.

Ok, so this is with clean current -git, and nothing disabled?

> And suspend-to-disk hangs, but I can still press and hold the power
> button to power it off.

The "press and hold for five seconds" is actually a hardware feature of 
the southbridge (well, I guess there is "software" in there too, but it's 
the embedded kind). So the fact that it powers off at that point means 
nothing, it just means that ok, your kernel is hung, but the hardware
still works ;)

This *sounds* like some part of the suspend-to-disk sequence is doing 
something stupid like trying to access the screen after it has been turned 
off, which doesn't surprise me at all. My oft-stated opinion has been that 
suspend-to-disk isn't a suspend at all, and should never have been 
confused with "suspending" anything.

It's "snapshot-and-restore", and my opinion is that:

 - it should *never* call "suspend()"/"resume()" at all (that should be
   reserved purely for suspend-to-RAM and has real power management 
   issues!)

 - it should have a totally separate "halt/unhalt/restore" thing 
   that has nothing what-so-ever to do with power management, and is 
   purely about stopping the hardware for things like USB and network 
   cards (which otherwise do things like scan their command lists 
   asynchronously) and making sure that the driver state is consistent 
   with that stopped hw state.

 - the people who confuse snapshot/restore with suspend/resume are 
   horrible people that cause problems exactly because driver people then 
   get those things mixed up, and something like the video suspend/resume 
   should probably never have impacted suspend-to-disk in the first place!

HOWEVER, that's a separate fight I've had, and in the meantime:

> Then upon powering on and resume, I get the ugly green "console" screen. 
> I can still type and move around. Starting X runs fine. Ctrl-Alt-Del or 
> switching back to console will get back to the green screen.

.. so this implies that while the laptop apparently hung at the end of the 
snapshotting, the snapshotting did actually work, and it must have hung at 
the very end, presumably when it tried to actually turn the power off.

So there seems to be two (probably largely independent) problems:

 - the hang at shutdown that requires you to press-and-hold the power 
   button to actually cut power.

   At a guess: putting the VGA device into D3hot makes the ACPI code that 
   actually does the shutoff unhappy. Probably because it wants to access 
   the device, and ends up not ever getting the replies it wants, since 
   the hardware has been turned off.

 - the fact that we restore something wrong for you and the screen is 
   green.

   At a guess: the restore_vga ends up restoring some state that wasn't 
   correctly and fully saved.

IOW, I think your patch that disables the two lines actually ends up 
pretty much matching the two *different* problems. Can you confirm that 
doing those two parts of that patch individually actually does 
individually fix the two issues? (Ie disabling D3hot makes it shut down 
nicely but resume with green text, while disabling just restore_vga() ends 
up with shutdown problems, but once you press-and-hold the power button, 
the thing will then restore nicely)+

		Linus
