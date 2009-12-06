Return-Path: <linux-kernel-owner+w=401wt.eu-S1758009AbZLFB5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009AbZLFB5B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 20:57:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757778AbZLFB44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 20:56:56 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36482 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757167AbZLFB4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 20:56:55 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] PM updates for 2.6.33
Date: Sun, 6 Dec 2009 02:57:44 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>
References: <200912052216.19540.rjw@sisk.pl> <alpine.LFD.2.00.0912051635330.3560@localhost.localdomain> <200912060254.10081.rjw@sisk.pl>
In-Reply-To: <200912060254.10081.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912060257.45067.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 06 December 2009, Rafael J. Wysocki wrote:
> On Sunday 06 December 2009, Linus Torvalds wrote:
> > 
> > On Sun, 6 Dec 2009, Rafael J. Wysocki wrote:
> > > 
> > > The approach you're suggesting would require modifying individual drivers which
> > > I just wanted to avoid.
> > 
> > In the init path, we had the reverse worry - not wanting to make 
> > everything (where "everything" can be some subsystem like just the set of 
> > PCI drivers, of course - not really "everything" in an absolute sense) 
> > async, and then having to try to work out with the random driver that 
> > couldn't handle it.
> > 
> > And there were _lots_ of drivers that couldn't handle it, because they 
> > knew they got woken up serially. The ATA layer needed to know about 
> > asynchronous things, because sometimes those independent devices aren't so 
> > independent at all. Which is why I don't think your approach is safe.
> 
> While the current settings are probably unsafe (like enabling PCI devices
> to be suspended asynchronously by default if there are not any direct
> dependences between them), there are provisions to make eveything safe, if
> we have enough information (which also is needed to put the required logic into
> the drivers).  The device tree represents a good deal of the dependences
> between devices and the other dependences may be represented as PM links
> enforcing specific ordering of the PM callbacks.
> 
> > Just to take an example of the whole "independent devices are not 
> > necessarily independent" thing - things like multi-port PCMCIA controllers 
> > generally show up as multiple PCI devices. But they are _not_ independent, 
> > and they actually share some registers. Resuming them asynchronously might 
> > well be ok, but maybe it's not. Who knows?
> 
> I'd say if there's a worry that the same register may be accessed concurrently
> from two different code paths, there should be some locking in place.
> 
> > In contrast, a device driver can generally know that certain _parts_ of 
> > the initialization is safe. As an example of that, I think the libata 
> > layer does all the port enumeration synchronously, but then once the ports 
> > have been identified, it does the rest async. 
> > 
> > That's the kind of decision we can sanely make when we do the async part 
> > as a "drivers may choose to do certain parts asynchronously". Doing it at 
> > a higher level sounds like a problem to me.
> 
> The difference between suspend and initialization is that during suspend we
> have already enumerated all devices and we should know how they depend on
> each other (and we really should know that if we are to actually understand how
> things work), so we can represent that information somehow and use it to do
> things at the higher level.
> 
> How to represent it is a different matter, but in principle it should be
> possible.
> 
> > > If you don't like that, we'll have to take the longer route, although 
> > > I'm afraid that will take lots of time and we won't be able to exploit 
> > > the entire possible parallelism this way.
> > 
> > Sure. But I'd rather do the safe thing. Especially since there are likely 
> > just a few cases that really take a long time.
> 
> And there are lots of small sleeps here and there that accumulate and are
> entirely avoidable.

I mean, it is avoidable to do all these sleeps sequentially.

Thanks,
Rafael
