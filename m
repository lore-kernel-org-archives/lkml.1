Return-Path: <linux-kernel-owner+w=401wt.eu-S1030224AbXDMWfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030224AbXDMWfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 18:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030862AbXDMWfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 18:35:00 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:50193 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030224AbXDMWe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 18:34:59 -0400
Subject: Re: [RFD] swsusp problem: Drivers allocate much memory during
	suspend (was: Re: 2.6.21-rc5: swsusp: Not enough free memory)
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jiri Slaby <jirislaby@gmail.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux-pm@lists.osdl.org
In-Reply-To: <20070413221016.GQ28264@elf.ucw.cz>
References: <460B6E4B.3060004@gmail.com> <200704131400.12021.rjw@sisk.pl>
	 <1176466896.7112.159.camel@nigel.suspend2.net>
	 <200704132241.52725.rjw@sisk.pl>  <20070413221016.GQ28264@elf.ucw.cz>
Content-Type: text/plain
Date: Sat, 14 Apr 2007 08:34:52 +1000
Message-Id: <1176503692.7112.189.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Sat, 2007-04-14 at 00:10 +0200, Pavel Machek wrote:
> Hi!
> 
> > > > Well, it looks like someone allocated about 6000 pages after we had freed
> > > > enough memory for suspending.
> > > 
> > > We have a tunable allowance in Suspend2 for this, because fglrx
> > > allocates a lot of pages in its suspend routine if DRI is enabled. I
> > > think some other drivers do too, but fglrx is the main one I know.
> > 
> > I wasn't aware of that, thanks for the information.
> > 
> > I think this means we'll probably need to add a tunable, similar to image_size,
> > that will allow the users to specify how much spare memory they want to reserve
> > for suspending (instead of the constant PAGES_FOR_IO).  IMO we can call it
> > 'spare_memory'.
> 
> Just increase PAGES_FOR_IO. This should not be tunable.

If we don't have a means for drivers to pre-allocate or say how much
memory they need, it should be tunable. Frankly, I'm startled that you
guys haven't heard of this issue before now. I can't believe everyone
who has ever wanted to hibernate with DRM enabled has been using
Suspend2. Maybe this is one of the sources of complaints that swsusp
isn't reliable?

> > IMO to really fix the problem, we should let the drivers that need much memory
> > for suspending allocate it _before_ the memory shrinker is called.  For this
> > purpose we can use notifiers that will be called before we start the shrinking
> > of memory.  Namely, if a driver needs to allocate substantial amount
> > of memory
> 
> Yes please. Using that notifier without leaking the memory will be
> "interesting" but if someone needs so much memory during suspend, let
> them eat their own complexity.

It doesn't need to be that complex. Add another (optional) function to
the driver model to let drivers say how much they want and it becomes
trivial. Maybe this idea should be preferred over the notifier chain.

Regards,

Nigel

