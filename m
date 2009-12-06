Return-Path: <linux-kernel-owner+w=401wt.eu-S933835AbZLFPXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933835AbZLFPXr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 10:23:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933816AbZLFPXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 10:23:45 -0500
Received: from netrider.rowland.org ([192.131.102.5]:51744 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933814AbZLFPXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 10:23:43 -0500
Date: Sun, 6 Dec 2009 10:23:49 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [GIT PULL] PM updates for 2.6.33
In-Reply-To: <alpine.LFD.2.00.0912051758190.3560@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.0912060953190.4442-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Dec 2009, Linus Torvalds wrote:

> Think of a situation that we already handle pretty poorly: USB mass 
> storage devices over a suspend/resume.
> 
> > The device tree represents a good deal of the dependences
> > between devices and the other dependences may be represented as PM links
> > enforcing specific ordering of the PM callbacks.
> 
> The device tree means nothing at all, because it may need to be entirely 
> rebuilt at resume time. 

Nonsense.

> Optimally, what we _should_ be doing (and aren't) for suspend/resume of 
> USB is to just tear down the whole topology and rebuild it and re-connect 
> the things like mass storage devices. IOW, there would be no device tree 
> to describe the topology, because we're finding it anew. And it's one of 
> the things we _would_ want to do asynchronously with other things.

That's ridiculous.  Having gone to all the trouble of building a device
tree, one which is presumably still almost entirely correct, why go to
all the trouble of tearing it down only to rebuild it again?  (Note:
I'm talking about resume-from-RAM here, not resume-from-hibernation.)

Instead what we do is verify that the devices we remember from before
the suspend are still there, and then asynchronously handle new devices
which have been plugged in during the meantime.  Doing this involves
relatively little extra or new code; most of the routines are shared
with the runtime PM and device reset paths.

As for asynchronicity...  At init time, USB device discovery truly is 
asynchronous.  It can happen long after you log in (especially if you 
don't plug in the device until after you log in!).  But at resume time 
we are more highly constrained.  User processes cannot be unfrozen 
until all the devices have been resumed; otherwise they would encounter 
errors when trying to do I/O to a suspended device.  (With the runtime 
PM framework this is much less of a problem, but plenty of drivers 
don't support runtime PM yet.)


> We don't want to build up some irrelevant PM links and callbacks. We don't 
> want to have some completely made-up new infrastructure for something that 
> we _already_ want to handle totally differently for init time.
> 
> IOW, I argue very strongly against making up something PM-specific, when 
> there really doesn't seem to be much of an advantage. We're much better 
> off trying to share the init code than making up something new.

If I understand correctly, what you're suggesting is impractical.  You
would have each driver responsible for resuming the devices it
registers.  If it registered some children synchronously (during the
parent's probe) then it would resume them synchronously (during the
parent's resume); if it registered them asynchronously then it would
resume them asynchronously.  In essence, every single device_add() or
device_register() call would have to be paired with a resume call.

To make such significant changes in every driver would be prohibitively
difficult.  What we need is a compromise which gives drivers control
over the resume process without making them responsible for actually
carrying it out.

So consider this suggestion: Let's define PM groups.  Each device
belongs to a group, and each group (except group 0, the initial group)  
has an owner device.  By default a device is added to its parent's
group during registration, but the driver can request that it be
assigned to a different group, which must be owned by that parent.

During resume, each PM group would correspond to an async task.  The 
devices in each group would be resumed sequentially, in order of 
registration, but asynchronously with respect to other groups.  The 
async thread to resume a group would be launched after the group's 
owner device was resumed.

So for example, the sibling functions on a PCI card could all be
assigned to the same group, but different cards could belong to
different groups.  Likewise for ATA and PCMCIA controllers.  Extra
cross-group constraints could be added if needed, but there should be
relatively few of them.

This way drivers can decide which of their devices will be resumed in 
sequence or concurrently, but they won't have to do any of the 
necessary work.

Alan Stern

