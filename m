Return-Path: <linux-kernel-owner+w=401wt.eu-S934684AbZLGD5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934684AbZLGD5O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 22:57:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933436AbZLGD5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 22:57:00 -0500
Received: from mga02.intel.com ([134.134.136.20]:46438 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934489AbZLGD44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 22:56:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,351,1257148800"; 
   d="scan'208";a="576204152"
Subject: Re: [GIT PULL] PM updates for 2.6.33
From: Zhang Rui <rui.zhang@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.44L0.0912060953190.4442-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.0912060953190.4442-100000@netrider.rowland.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Dec 2009 11:57:59 +0800
Message-ID: <1260158279.27069.181.camel@rzhang1-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-06 at 23:23 +0800, Alan Stern wrote:
> On Sat, 5 Dec 2009, Linus Torvalds wrote:
> 
> > Think of a situation that we already handle pretty poorly: USB mass 
> > storage devices over a suspend/resume.
> > 
> > > The device tree represents a good deal of the dependences
> > > between devices and the other dependences may be represented as PM links
> > > enforcing specific ordering of the PM callbacks.
> > 
> > The device tree means nothing at all, because it may need to be entirely 
> > rebuilt at resume time. 
> 
> Nonsense.
> 
> > Optimally, what we _should_ be doing (and aren't) for suspend/resume of 
> > USB is to just tear down the whole topology and rebuild it and re-connect 
> > the things like mass storage devices. IOW, there would be no device tree 
> > to describe the topology, because we're finding it anew. And it's one of 
> > the things we _would_ want to do asynchronously with other things.
> 
> That's ridiculous.  Having gone to all the trouble of building a device
> tree, one which is presumably still almost entirely correct, why go to
> all the trouble of tearing it down only to rebuild it again?  (Note:
> I'm talking about resume-from-RAM here, not resume-from-hibernation.)
> 
> Instead what we do is verify that the devices we remember from before
> the suspend are still there, and then asynchronously handle new devices
> which have been plugged in during the meantime.  Doing this involves
> relatively little extra or new code; most of the routines are shared
> with the runtime PM and device reset paths.
> 
> As for asynchronicity...  At init time, USB device discovery truly is 
> asynchronous.  It can happen long after you log in (especially if you 
> don't plug in the device until after you log in!).  But at resume time 
> we are more highly constrained.  User processes cannot be unfrozen 
> until all the devices have been resumed; otherwise they would encounter 
> errors when trying to do I/O to a suspended device.  (With the runtime 
> PM framework this is much less of a problem, but plenty of drivers 
> don't support runtime PM yet.)
> 
> 
> > We don't want to build up some irrelevant PM links and callbacks. We don't 
> > want to have some completely made-up new infrastructure for something that 
> > we _already_ want to handle totally differently for init time.
> > 
> > IOW, I argue very strongly against making up something PM-specific, when 
> > there really doesn't seem to be much of an advantage. We're much better 
> > off trying to share the init code than making up something new.
> 
> If I understand correctly, what you're suggesting is impractical.  You
> would have each driver responsible for resuming the devices it
> registers.  If it registered some children synchronously (during the
> parent's probe) then it would resume them synchronously (during the
> parent's resume); if it registered them asynchronously then it would
> resume them asynchronously.  In essence, every single device_add() or
> device_register() call would have to be paired with a resume call.
> 
> To make such significant changes in every driver would be prohibitively
> difficult.  What we need is a compromise which gives drivers control
> over the resume process without making them responsible for actually
> carrying it out.
> 
> So consider this suggestion: Let's define PM groups.  Each device
> belongs to a group, and each group (except group 0, the initial group)  
> has an owner device.  By default a device is added to its parent's
> group during registration, but the driver can request that it be
> assigned to a different group, which must be owned by that parent.
> 
> During resume, each PM group would correspond to an async task.  The 
> devices in each group would be resumed sequentially, in order of 
> registration, but asynchronously with respect to other groups.  The 
> async thread to resume a group would be launched after the group's 
> owner device was resumed.
> 
yes, we've talked about something similar to this before. :)

Hi, Linus,
can you please look at this patch set and see if the idea is right?
http://marc.info/?l=linux-kernel&m=124840449826386&w=2
http://marc.info/?l=linux-acpi&m=124840456826456&w=2
http://marc.info/?l=linux-acpi&m=124840456926459&w=2
http://marc.info/?l=linux-acpi&m=124840457026468&w=2
http://marc.info/?l=linux-acpi&m=124840457126471&w=2

If yes, I'll pick them up again and rework a patch set, including some
good thoughts from Rafael.

thanks,
rui

> So for example, the sibling functions on a PCI card could all be
> assigned to the same group, but different cards could belong to
> different groups.  Likewise for ATA and PCMCIA controllers.  Extra
> cross-group constraints could be added if needed, but there should be
> relatively few of them.
> 
> This way drivers can decide which of their devices will be resumed in 
> sequence or concurrently, but they won't have to do any of the 
> necessary work.
> 


> Alan Stern
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


