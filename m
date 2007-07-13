Return-Path: <linux-kernel-owner+w=401wt.eu-S936418AbXGMPiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936418AbXGMPiT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 11:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757806AbXGMPiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 11:38:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60462 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757590AbXGMPiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 11:38:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeremy Maitin-Shepard <jbms@cmu.edu>
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
Date: Fri, 13 Jul 2007 17:45:41 +0200
User-Agent: KMail/1.9.5
Cc: david@lang.hm, "Huang\, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alan Stern <stern@rowland.harvard.edu>
References: <1184167831.12556.13.camel@caritas-dev.intel.com> <200707131359.53309.rjw@sisk.pl> <87abu01gnv.fsf@jbms.ath.cx>
In-Reply-To: <87abu01gnv.fsf@jbms.ath.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707131745.43055.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 13 July 2007 17:12, Jeremy Maitin-Shepard wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> [snip]
> 
> > Not necessarily.  If we don't put devices into low power states before creating
> > the image, that should work just fine (quiesce devices, create the image or
> > kexec the new kernel, reprobe devices, save the image, suspend to RAM,
> > resume from RAM, continue - or restore from the image if power failed in the
> > meantime).  Still, for this purpose, both kernels need to be able to handle the
> > same set of devices.
> 
> I don't know much about the suspend to RAM, but it seems that it would
> indeed be necessary to have a device driver for a device in order to
> switch it from e.g. a quiesced state to a low power state.  If, however,
> the original kernel already completely turned off the device, then it
> seems that the "save image" kernel shouldn't have to do anything to it
> in order to suspend to RAM.  The drawback, though, is that since the old
> kernel would have no way (unless the user tells it) to know which
> devices should be left quiesced and which should be turned off, it would
> have to turn them all off, which would mean spinning up and down the
> disks.
> 
> On the other hand, being able to build the "save image" kernel with only
> minimal hardware support could save a significant amount of the time
> required to boot it.
> 
> [snip]
> 
> > No, it can't.  For example, it can't access filesystems mounted by the
> > hibernated kernel, or they may get corrupted after the restore (if they are
> > journaling, it can't even read from them).
> 
> That is true, but this also holds for the current hibernate
> implementations.
> 
> > Which reminds me of one more issue, which is that the image-saving kernel
> > won't be able to use these filesystems either, so its modules and user space
> > will have to be available from somewhere else (like a RAM disk or dedicated
> > partition).  So things get ugly.
> 
> This is not the issue that it appears to be, though.  Under the current
> hibernate implementations, this very same userspace and set of modules
> must be available "somewhere else" (i.e. an initrd) because it is needed
> by the restore path.  Note that under the kexec approach, save and
> restore become rather symmetric operations.
> 
> > Apart from this, the new kernel's user space cannot blindly modify swap space
> > that might be in use by the hibernated kernel.
> 
> But it seems easy enough to swapoff in order to completely free up the
> swap space.  I suppose the disadvantage is that instead of failing
> cleanly if there is insufficient memory, the OOM killer will be invoked
> and cause all sorts of havoc.  This suggests that it may indeed be
> important to support "cooperation" with the old kernel on saving the
> image sooner, rather than later.

Okay, I have thought it through and I think that, as an initial step, we can do
something like this:

- preload the image-saving kernel before hibernation
- in the hibernation code path replace device_suspend() with the shutting down of
  all devices without unregistering them (not very nice, but should be sufficient
  for a while)
- when we've called device_power_down() and save_processor_state(), jump to
  the image-saving kernel and let it run
- make the image-saving kernel set up everything, save the image without
  starting any user space (we may use the existing image-saving code for this
  purpose, with some modifications) and power off the system (or make it enter
  S4)
- use the existing restoration code to load the image and jump to the
  hibernated kernel
- in the restore code patch replace device_resume() with the reprobing of all
  devices.

Comments?

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
