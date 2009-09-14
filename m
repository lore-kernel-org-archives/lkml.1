Return-Path: <linux-kernel-owner+w=401wt.eu-S1753717AbZINRh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717AbZINRh6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 13:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751066AbZINRhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 13:37:52 -0400
Received: from kroah.org ([198.145.64.141]:51833 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749AbZINRhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 13:37:51 -0400
Date: Mon, 14 Sep 2009 10:35:44 -0700
From: Greg KH <greg@kroah.com>
To: Dave Taht <d@teklibre.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Frontier USB Drivers (Was: Staging tree status for the .32
 kernel merge)
Message-ID: <20090914173544.GC26582@kroah.com>
References: <20090903041429.GA29875@kroah.com>
 <8763bodk9f.fsf@mahal.sjds.teklibre.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8763bodk9f.fsf@mahal.sjds.teklibre.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 12, 2009 at 01:40:28PM -0600, Dave Taht wrote:
> Greg KH <greg@kroah.com> writes:
> 
> > 	- frontier.  A nice driver, again, should not be hard to get
> > 	  merged into the main tree, if someone wants an easy project...
> 
> Thank you for your kind words.
> 
> Mild correction, it's actually two drivers, one for the Frontier Designs
> Tranzport, the other is for the Frontier Designs Alphatrack. The
> interfaces are very similar in most respects.

Yes, sorry.

> I would certainly like to see the frontier drivers escape staging and
> become part of the regular kernel. The tranzport sub-driver in
> particular, has been in daily use in my studio for nearly two years now,
> and people like Dave Phillips are also happy with it. (at least the
> kernel portion, userspace needs more work)
> 
> In looking over the drivers/staging/frontier/TODO list for these
> drivers, I would love to get some help and feedback on the remaining,
> minor, problems:
> 
> 	- review by the USB developer community
> 
> DEEPLY Desired, see below for details. 
> 
> - Missing usb ids for lsusb.
> 
> Although I had submitted the requisite usb ids to the maintainer
> I'm not sure if they ever made it into the kernel. I am not presently
> tracking the tip of kernel development however.

Who did you send them to?  Me?

> - Stolen USB minor device numbers
> 
> I reused some uncommon usb minor numbers in these drivers. Presumably
> new ones need to be applied for or has the world gone dynamic these days?
> 
> Haven't the foggiest idea how to apply for minor numbers. I just googled
> for the right procedure. Oh, wait, there's this greg KH guy that assigns
> those. Greg!  Need two minor numbers for these devices! We've talked
> about it, a couple times...
> 
> It's possible to plug more than one Alphatrack into a system. I'm not
> sure how that's supposed to work, numberwise.

I'll have to pick a number, and a range, will do that when the drivers
move to the main portion of the kernel tree.

> 	- checkpatch.pl clean
> 
> I submitted patches to this during the last kernel round that made the
> alphatrack and tranzport drivers checkpatch.pl clean for all except one
> error message that I didn't understand, which I noted at the time.
> 
> $ /home/d/src/git/linux-2.6/scripts/checkpatch.pl --file alphatrack.c
> WARNING: mutexes are preferred for single holder semaphores
> #681: FILE: alphatrack.c:681:
> +	init_MUTEX(&dev->sem);
> 
> total: 0 errors, 1 warnings, 895 lines checked
> 
> 
> ***But it IS a single holder semaphore!***

Can this be a 'struct semaphore' then?

> 	- sparse clean
> 
> I don't know a darn thing about sparse. I'm willing to learn but...

I can do this.

> 	- possibly just port to userspace with libusb
> 
> No. The original version of this was written for libusb. Unless libusb
> has improved dramatically, it was simply incapable of keeping up with
> interrupts, particularly the high number of interrupts the scroll wheel
> would generate. When you have a keyboard-like device, missing one key-up
> event is disastrous. When the tranzport is controlling a real-time audio
> session, with live musicians and backing tracks all playing at once,
> when you hit that key and spin that knob it better do what you expect,
> every time. Thus, these became kernel drivers.
> 
> I also tried writing this in UIO, but that lacked adequate support for
> USB disconnect events. Thus, these drivers became very small drivers
> that merely handled interrupts, usb related events, and kept a
> ringbuffer around of backlogged events.

Ok, that's fair enough, just want to make sure.

> I wrote these drivers back around 2.6.17 and today is the first time
> I've subscribed to read lkml since 2.6.22....
> 
> 	- fix userspace interface to be sane
> 
> This is the biggest open question I have. Right now the drivers just
> handle the interrupts, and queue up the data in a ringbuffer, sending the
> events in the exact same format as received from the device, and vice versa.
> 
> Coming up with an abstract means to handle a very specialized device - a
> control surface that simultaneously is a LCD screen, a bunch of LEDS, a
> scroll wheel, and 20+ buttons that can be pressed in various
> combinations, would kind of involve reinventing a char I/O based X11,
> and I don't really feel that much or any of that needs to happen in
> kernel space.
> 
> (the alphatrack is worse, it has a slider with feedback and buttons that
> have touch sensitivity, and a special key that remaps the sliders and
> buttons to another keymap entirely)
> 
> There are a lot of "surfaces" out there in the music world, with all
> kinds of combinations of buttons and knobs and gee-gaws, etc, but coming
> up with adaquate abstractions for them all is an effort on the scale of
> X11, with a considerably smaller user-base, and more rapidly shifting
> market.
> 
> Far better, I thought, to just handle the RT critical portions of the
> code in the kernel and hand off the rest of the chaos to userspace.
> 
> But certainly, some guidance and thought on this matter would be welcomed.

Hm, I'll look at this, but if what you say is how it works, it might be
fine as-is.

> 	- review by the USB developer community
> 
> I'd like that. My test or production userspace code doesn't test poll
> for example. My inexperienced eyeballs look at the poll stub and say
> that it can't possibly work, and I worry that there are situations
> involving suspend or hubs or inotify or some other desirable set of
> usb calls, or something that has changed since I wrote the thing back in
> 2.6.17 days. that actually matters in newer versions of the kernel.
> 
> So if someone truly expert in USB would PLEASE review this code I'd
> appreciate it very much. I can be available via irc or email for further
> discussions, and I will track lkml for as long as it takes.
> 
> Stuff that is not in the TODO that needs to be done.
> 
> Documentation 
> 
> udev line

I'll take what we currently have, run it through sparse, and then submit
it to the linux-usb list for review there.

And we can then take it from there.

thanks,

greg k-h
