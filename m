Return-Path: <linux-kernel-owner+w=401wt.eu-S936489AbXGMJK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936489AbXGMJK4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 05:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935252AbXGMJKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 05:10:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58762 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936342AbXGMJKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 05:10:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: david@lang.hm
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
Date: Fri, 13 Jul 2007 11:17:37 +0200
User-Agent: KMail/1.9.5
Cc: Jeremy Maitin-Shepard <jbms@cmu.edu>, "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
References: <1184167831.12556.13.camel@caritas-dev.intel.com> <877ip54cti.fsf@jbms.ath.cx> <Pine.LNX.4.64.0707122008550.25614@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0707122008550.25614@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707131117.38426.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 13 July 2007 05:12, david@lang.hm wrote:
> On Thu, 12 Jul 2007, Jeremy Maitin-Shepard wrote:
> 
> > "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> >
> > [snip]
> >
> >> There's more to it, though.  If devices are suspended, the hibernation kernel
> >> will have to resume them (using platform, like ACPI, callbacks in the process)
> >> instead and that will get complicated.
> >
> >> It's better if devices are quiesced, or even shut down, before we call the
> >> hibernation kernel.
> >
> > I agree that they definitely should not be put into a low power mode, as
> > that has nothing to do with hibernation.
> >
> > Ideally, the following would be done:
> >
> > All of the hardware that won't be needed by the "save image" kernel will
> > be shut down.  The normal driver shut down calls may not be suitable,
> > however, because although the same thing should be done to the hardware,
> > the device shouldn't be "unregistered", since unlike in the actual
> > shutdown case, the same device will need to brought back up again on
> > resume, and it will need to have the same device id and such (and
> > userspace probably shouldn't see the device going away).
> >
> > Any devices that will be needed by the "save image" kernel could also
> > safely be shutdown as with the unneeded devices, but it would be more
> > efficient to simply quiesce it.  Since this would be an additional
> > complication, initially probably all of the hardware should be shut
> > down, rather than quiesced.
> >
> > The reason that I think it is useful to actually shut down the devices,
> > rather than merely leaving some unneeded devices quiesced, is that it
> > would be useful to be able to build the "save image" kernel without
> > support for unneeded devices.  In order to support "suspend to ram"
> > instead of shutting down after saving the image to disk, the hibernate
> > kernel needs to be able to send devices into a low power state.  My
> > impression is that if there are devices it does not know about (i.e. the
> > unneeded devices), but which are left quiesced but powered on, this
> > would be a problem for suspend to ram, although not knowing much about
> > how suspend to ram actually works, I could be mistaken.  (Maybe it is
> > possible through ACPI or standard bus interfaces to shut down all of the
> > devices without really knowing anything about them.)
> 
> I don't think that anyone is talking about useing kexec for 
> suspend-to-ram, only for suspend-to-disk (hibernate)
> 
> >>>>> 3. Support the in-place kexec? The relocatable kernel is not necessary
> >>>>> if this can be implemented.
> >>>>> 4. Image writing/reading. (Only user space application is needed).
> >>>>
> >>>> And a kernel interface for that application.
> >>>
> >>> I do't understand this statement, this application is just useing the
> >>> standard kernel interfaces (block devices to read/write to disk, network
> >>> devices to read/write to a server, etc). no new interfaces needed.
> >
> >> Yes, but it will have to know _what_ to save, no?
> >
> > I agree that a kernel interface would be important; something like
> > /dev/snapshot that can be read by the "save image" kernel, and written
> > to by the "restore image" kernel.  Note that similarly, kdump provides a
> > kernel interface to an ELF image of the old kernel.
> 
> I thought that the idea was to save the entire contents of ram so that 
> caches, etc remain populated.
> 
> having the system kernel free up ram and then making a sg list of what 
> memory needs to be backed up would be a nice enhancement, but let's let 
> that remain a future enhancement until everyone agrees that the basic 
> approach works.

It's not that easy. :-)

First, there are memory regions that we don't want to save, because the
restoration of them may cause problems (generally all of the reserved pages
fall into this category).

We also don't want to save free RAM and we don't want to save the memory
occupied by the hibernation kernel (ie. the "new" one).

Also, please note that we can't restore 100% of RAM, even if we save it.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
