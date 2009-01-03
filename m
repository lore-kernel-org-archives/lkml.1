Return-Path: <linux-kernel-owner+w=401wt.eu-S932967AbZACVRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932967AbZACVRk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 16:17:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932462AbZACVR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 16:17:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44884 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760400AbZACVRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 16:17:25 -0500
Date: Sat, 3 Jan 2009 13:16:35 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Pavel Machek <pavel@suse.cz>, Andreas Mohr <andi@lisas.de>,
       Sriram V <vshrirama@gmail.com>, Pierre Ossman <drzeus-list@drzeus.cx>,
       linux-kernel@vger.kernel.org
Subject: Re: Power Management with rootfs on SDMMC.
In-Reply-To: <20090103204535.1a91cbcb@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.00.0901031306150.3179@localhost.localdomain>
References: <8bf247760901012235v20bb448ch5c34fb2791ea83ca@mail.gmail.com> <20090102102152.GA26603@rhlx01.hs-esslingen.de> <20090102172407.GD1555@ucw.cz> <alpine.LFD.2.00.0901031217261.3179@localhost.localdomain> <20090103204329.GD1666@elf.ucw.cz>
 <20090103204535.1a91cbcb@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 3 Jan 2009, Alan Cox wrote:

> > [Now, olympus uses VFAT and probably will not write to the filesystem
> > unless you take a picture... with mp3 player, I'd expect mtime to be
> > updated on the playlist files...]
> 
> Some of the MP3/OGG players (especially the bigger disk based ones) use
> the file system to store their own metadata so yes it makes a nasty mess.

Well, it goes both ways. You can make a nasty mess right now by suspending 
and simply not having a working computer when it comes back - all your 
work being lost.

At least with cameras and mp3 players you _can_ choose to just unmount 
them before suspending (and most distros would hopefully mount them with 
something like automount anyway?). In contrast, if your root (or /home) 
directory is on a SD card, and that card is over USB rather than some IDE 
controller, you're basically screwed.

Yes, distros can set the /sys/bus/usb/devices/.../power/persist thing for 
important filesystems automatically, and I'm sure there are magic udev 
rules that could be written (and perhaps even exist). The likelihood that 
they actually get things right is pretty low, though. So I suspect we'd be 
much better off having sane defaults in the kernel instead.

And yes, the "sane defaults" may well be that FATFS does _not_ make the 
media be persistent. 

Think "door lock" commands (aka "prevent/allow medium removal"). This is 
really not that very different. Some filesystems are so important that the 
user messing with them is deadly anyway - so we should "lock" them and 
consider them persistent - and if the user does something bad, there was 
really never any good solution for it. Other filesystems we're better off 
just letting the user rip out, because we can be reasonably expected to 
handle it gracefully.

So it boils down to the fact that if you have something like / or /home 
mounted, we really _cannot_ do any better than "assume the user doesn't 
screw us up".

A per-filesystem callback to re-verify at resume might be a good idea, but 
a lot of filesystems cannot reasonably do a lot of verification.

			Linus
