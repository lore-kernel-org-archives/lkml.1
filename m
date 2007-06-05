Return-Path: <linux-kernel-owner+w=401wt.eu-S1764257AbXFESpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764257AbXFESpp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 14:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759489AbXFESpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 14:45:35 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37857 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759520AbXFESpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 14:45:34 -0400
Date: Tue, 5 Jun 2007 14:45:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Pavel Machek <pavel@ucw.cz>
cc: Matthew Garrett <mjg59@srcf.ucam.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Oliver Neukum <oliver@neukum.org>
Subject: Re: [RFC][PATCH -mm 3/3] PM: Disable _request_firmware before
 hibernation/suspend
In-Reply-To: <20070604110052.GI4363@elf.ucw.cz>
Message-ID: <Pine.LNX.4.44L0.0706051420351.2606-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2007, Pavel Machek wrote:

> > With the USB subsystem I have followed the approach taken by the PM
> > core, which is that tasks are frozen.  But one can -- and Linus has on
> > at least one occasion -- make a good case that tasks should be left
> > running while only I/O is frozen.  This would require the subsystem to
> > distinguish between a selective device suspend and a system-wide
> > suspend-to-RAM, so that selective resume could be enabled on demand in
> > one case but not the other.
> > 
> > It's quite doable in principle -- it's just not the technique I used.
> 
> I guess we need to do that. Random user should not be able to prevent
> machine from sleeping.

Just to be clear about this, let's agree that we're talking about 
suspend-to-RAM here, not hibernation.

It boils down to whether we want to freeze user tasks.  As I recall,
Linus said that he didn't have any big objection to freezing user
threads; he was much more concerned about freezing kernel threads.  
Thanks to Raphael's new notifier chains this will no longer be an
issue, since kernel threads will be able to stop themselves when they
receive a suspend notification.

There may remain some obscure difficulties in discerning whether a 
particular thread should be classified as user or kernel, but let's 
ignore them.

Even if we don't actively freeze user threads, approximately the same
effect can be achieved in the following way: Change the main kernel
entry points so that any thread performing a system call during a
suspend will get frozen until the suspend is over.  Threads that run
entirely in userspace will continue doing useful work as before, and
kernel threads won't be affected at all.  (Not that I think it's 
necessary to do this; it's just a way to avoid freezing user tasks
until they need it.)

One way or another, freezing user tasks should not be a big deal.  
After all, once the suspend is complete eveything will effectively be 
frozen anyway.  I suppose there might be issues involving tasks which 
need to run in order to complete the suspend -- IMO any such issues 
should be handled by carrying out the necessary actions before the 
point where we now start up the freezer.


The alternative is to have drivers take over the burden.  I don't like
this at all.  The most obvious disadvantage is that the necessary
checks would have to be duplicated many many times and spread out over
lots of drivers.

It's also harder to handle these things at the driver level.  Suppose a
driver gets an I/O request while a suspend is underway.  What should it
do?  Return an error?  Block until the suspend is over?  Both
approaches have their difficulties:

Returning an error would mean that suspend is no longer transparent.  
Even an error like -EAGAIN.

Waiting until the suspend is over is likely to be impractical.  At a 
minimum it would involve adding code to drop a lock or mutex, enter the 
freezer (or its equivalent), and then restart the I/O operation.  And 
then, what if the driver was invoked with O_NONBLOCK?

I think it is much better overall to stop I/O requests from being
generated at the source, either by freezing userspace or preventing it
from making system calls.  It's hard to imagine that anybody would
miss the small amount of CPU time they'd be giving up by not allowing
user threads to run during the time that a suspend is underway!

Alan Stern

