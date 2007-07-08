Return-Path: <linux-kernel-owner+w=401wt.eu-S1758417AbXGHV7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758417AbXGHV7S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 17:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757343AbXGHV7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 17:59:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37362 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757323AbXGHV7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 17:59:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Mon, 9 Jul 2007 00:06:31 +0200
User-Agent: KMail/1.9.5
Cc: Alan Stern <stern@rowland.harvard.edu>, Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Matthew Garrett <mjg59@srcf.ucam.org>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <Pine.LNX.4.44L0.0707081517540.11049-100000@netrider.rowland.org> <1183929611.3388.303.camel@localhost.localdomain>
In-Reply-To: <1183929611.3388.303.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707090006.32712.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 8 July 2007 23:20, Benjamin Herrenschmidt wrote:
> 
> > But I'm not sure it's a good idea in the long run.  Think of a printer 
> > daemon, for example.  It shouldn't have to experience unexpected I/O 
> > problems merely because someone has decided to put the system to sleep.
> 
> Why not ? Printer is offline when machine is asleep... trying to print
> errors out, I don't see the problem there. At one point, we'll need a
> cleaner way to also notify userland in which case our daemon could
> become more intelligent and stop servicings things before sleep and
> resume afterward :-)
>  
> > This will be up to the people responsible for the subsystems.  I can 
> > take care of USB.
> 
> USB is not that much of a problem in the sense that for most "leaf"
> drivers, USB is a provider (ie, the bus they sit on), not the client
> (like the network stack is to network drivers).
> 
> In most cases, that "helper" thing would sit on the client subsystem,
> since it's the one feeding drivers with requests. The main ones I see at
> hand are block, alsa, net, fb/drm... Some of them already have
> infrastructure to do it, some my need some more work.
> 
> > > I think it's a fairly significant change from the current freezer and I
> > > also think it's a very good idea. The more I think about it, the more I
> > > like it, in the sense that it's a simple drop-in that you could put in a
> > > lot of the ioctl path of drivers to just block tasks that are trying to
> > > call in while suspending, and could be used selectively by things like
> > > the USB hub threads.
> > 
> > That's what I had in mind.  Rafael, can we add an "icebox" routine?  
> > Like Ben says, it doesn't need to be much more than a waitqueue
> > that the current task puts itself on if a suspend is in progress.  
> > Callers arriving at a time when the icebox isn't activated should
> > simply return without blocking.  Basically the icebox should be active 
> > at the same times as the existing freezer.
> 
> There is still the race of:
> 
> 	drivers_sysfs_write()
> 		try_to_icebox()
> 		<---- <sleep request gets here>
> 		hit hardware
> 
> Those are akin, in some ways, to the freezer races.

I'm not sure what races you're referring to, but never mind. :-)

This is the reason why the freezer waits for tasks to freeze, actually.

> Some kind of RCU might take care of them if we enable the icebox,
> then wait for all tasks to hit an explicit schedule point once (or return to
> userland).

This is what the freezer does, isn't it? ;-)

> That would mean that drivers need to try_to_icebox() again if they do
> something that may schedule (such as __get_user). So it's not a magic
> solution, it has issues, but it can handle a lot of the simplest cases. 

Well, can't we do:

 	drivers_sysfs_write()
		while(!suspend_trylock())
			try_to_icebox() --> or even try_to_freeze(), what's the difference?

 		hit hardware
		unlock_suspend()

where the PM core must wait for the suspend lock to get released (say with a
timeout)?
 
> > Here's a wacky idea which just might work:
> > 
> > In order to prevent binding and unbinding, while suspending devices all
> > the PM core has to do is avoid dropping the device semaphores!  It can
> > release the semaphores as it resumes the devices.
> > 
> > Of course, for this to work it's necessary to avoid changes to the 
> > device list during the suspend.  However I believe the iteration can be 
> > made safe against unregistration, so we only have to prevent device 
> > registration.  (And anyway, it won't be possible to unregister a device 
> > while the PM core is holding its semaphore.)
> > 
> > If we are willing to be somewhat non-transparent, this is easy to
> > accomplish.  After the notifier chain has been alerted about the
> > upcoming suspend, we tell the driver core to disallow adding new
> > devices.  Maybe use SRCU to synchronize with registration calls that
> > are in progress.  Thus, until the suspend is over device_add() will
> > immediately return an error.  We could even add a new ESUSPENDING code
> > to errno.h; it would come in handy in a few places.
> > 
> > Drivers are already prepared for device registration to fail (or they
> > ought to be), so this change shouldn't knock the bottom out of things.  
> > device_add() isn't on a hot path, so adding an extra check and
> > srcu_read_lock() won't hurt.
> 
> True. Also, bus drivers could just flag the port with something saying
> "try registering again later". Don't underestimate the power of "try
> later" constructs :-)
> 
> > I have had the same thought, that unbinding and unregistration would be 
> > easier to handle than binding and registration.  As it happens, holding 
> > the device semaphore will block both all three -- which makes life 
> > simpler.
> 
> Yup. Fair and simple.
> 
> > There are other possibilities too.  For example, instead of using
> > keventd these attributes could use a separate workqueue which would put
> > itself in the icebox during a suspend.  Or maybe sysfs can be reworked 
> > so that they don't need to use a workqueue at all.
> 
> I think having a facility for a given workqueue entry to requeue itself
> for after resume might be of use for drivers too.

Hmm, perhaps we can use a special workqueue that's created before the suspend
(say by the PM core) and starts processing jobs after the resume?

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
