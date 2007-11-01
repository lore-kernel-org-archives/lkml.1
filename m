Return-Path: <linux-kernel-owner+w=401wt.eu-S1760150AbXKAW0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760150AbXKAW0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 18:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754496AbXKAW0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 18:26:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50697 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753821AbXKAW0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 18:26:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Russell King <rmk+lkml@arm.linux.org.uk>,
       Rodolfo Giometti <giometti@enneenne.com>
Subject: Re: [PATCH] PCMCIA: prevent auto insert during resume.
Date: Thu, 1 Nov 2007 23:43:18 +0100
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, linux-pcmcia@lists.infradead.org,
       linux-kernel@vger.kernel.org,
       Dominik Brodowski <linux@dominikbrodowski.net>
References: <20071026154705.GY19019@enneenne.com> <20071101183741.GA27621@flint.arm.linux.org.uk> <20071101185629.GA3136@flint.arm.linux.org.uk>
In-Reply-To: <20071101185629.GA3136@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711012343.19861.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 1 November 2007 19:56, Russell King wrote:
> On Thu, Nov 01, 2007 at 06:37:41PM +0000, Russell King wrote:
> > On Thu, Nov 01, 2007 at 03:53:59PM +0100, Rodolfo Giometti wrote:
> > > On Mon, Oct 29, 2007 at 07:24:15PM +0000, Pavel Machek wrote:
> > > > On Fri 2007-10-26 19:18:57, Rodolfo Giometti wrote:
> > > > > On Fri, Oct 26, 2007 at 06:00:31PM +0100, Russell King wrote:
> > > > > 
> > > > > > > > > Also if you didn't eject the socket, at resume the device will be
> > > > > > > > > powered up again, my patch just prevents that a pre-powered off device
> > > > > > > > > to be turned on at resume time.
> > > > > > > > > 
> > > > > > > > > However you should consider that some embedded systems have fixed
> > > > > > > > > PCMCIA devices that can't be removed so there are no reasons to detect
> > > > > > > > > them after resume, nobody can change them. :)
> > > > > > > > > 
> > > > > > > > > Also battery powered devices can go very frequently to sleep and the
> > > > > > > > > current behavior force the user to switch off the unused device each
> > > > > > > > > time the system resumes from sleep.
> > > > > > > > 
> > > > > > > > I realise that.  I do work on embedded devices, and this behaviour is
> > > > > > > > explicitly there to support embedded devices.
> > > > > > > > 
> > > > > > > > I've suggested a workable solution to you which allows both of us to
> > > > > > > > have the behaviour we both desire from the system.  That sounds like
> > > > > > > > a negotiated solution to me...
> > > > > > > 
> > > > > > > Do you mean to switch off the socket from userland? It could be a
> > > > > > > solution but in this case the device is powered on each time even if
> > > > > > > for a short delay...
> > > > > > 
> > > > > > If it's a permanent device, and you've powered it down via pccardctl,
> > > > > > then you've powered it down from userland.  So record that it's been
> > > > > > powered down from userland.  Then, on resume, if it's been powered down
> > > > > > from userland, don't try to re-power it on resume.
> > > > > 
> > > > > But the userland doesn't re-power it on resume... it's the kernel
> > > > > itself whos re-powers the device on resume. So the userland can only
> > > > > power down the device again.
> > > > 
> > > > I think Russell means: at a flag into kernel. If user powers down the
> > > > device, set the flag. If flag is set during resume, avoid powering up
> > > > the device.
> > > 
> > > That's exactly what my patch does! :)
> > > 
> > > If the user does 'eject' the device is not powered on at resume.
> > > 
> > > Currently, with out the patch, if you do an 'eject' to power down the
> > > device, then you go to sleep and resume, the device is powered up
> > > again and you have to do a new 'eject' to power it down.
> > > 
> > > My patch fixes this behaviour.
> > 
> > Let's be absolutely clear about this.  The patch in your original post
> > does *NOT* do that.  It *completely* removes the possibility of powering
> > up a device inserted into the PCMCIA slot before resuming without
> > unplugging and replugging it by removing the code which detects an
> > inserted card on resume.
> > 
> > And let's also be clear about something else.  You _were_ crystal clear
> > on that aspect of it from your last mail on the subject since you were
> > asking for names of attributes to set and clear such a flag.  I didn't
> > respond because I'm not going to hold your hand with such obvious
> > issues - if you need that level of support, it will be far faster for
> > me to write the damned patch myself.
> 
> Oh, and I'd like to make another thing clear - let's get the roles of
> responsibility right.
> 
> I'm the ex-PCMCIA maintainer who had a requirement for the current
> behaviour on my embedded ARM devices with classical PCMCIA sockets.
> 
> Dominik is the current PCMCIA maintainer who gets to say what goes in,
> how things should be designed, etc.

Well, this is not what the MAINTAINERS file says, btw.

> You're the guy coming along with a different requirement for a device
> using the PCMCIA subsystem in a non-classical way (non-pluggable PCMCIA)
> and finding that the subsystem doesn't work in a good way with that
> setup, and suggesting we break classical PCMCIA setups to make it
> work.

OK

Can we CC all future messages regarding this patch to Dominik, please?
