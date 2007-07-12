Return-Path: <linux-kernel-owner+w=401wt.eu-S1760200AbXGLUiE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760200AbXGLUiE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 16:38:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755827AbXGLUhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 16:37:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56841 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755124AbXGLUhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 16:37:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeremy Maitin-Shepard <jbms@cmu.edu>
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
Date: Thu, 12 Jul 2007 22:45:20 +0200
User-Agent: KMail/1.9.5
Cc: david@lang.hm, "Huang\, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
References: <1184167831.12556.13.camel@caritas-dev.intel.com> <200707122134.29991.rjw@sisk.pl> <877ip54cti.fsf@jbms.ath.cx>
In-Reply-To: <877ip54cti.fsf@jbms.ath.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707122245.21606.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 12 July 2007 21:55, Jeremy Maitin-Shepard wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> [snip]
> 
> > There's more to it, though.  If devices are suspended, the hibernation kernel
> > will have to resume them (using platform, like ACPI, callbacks in the process)
> > instead and that will get complicated.
> 
> > It's better if devices are quiesced, or even shut down, before we call the
> > hibernation kernel.
> 
> I agree that they definitely should not be put into a low power mode, as
> that has nothing to do with hibernation.
> 
> Ideally, the following would be done:
> 
> All of the hardware that won't be needed by the "save image" kernel will
> be shut down.

For that to work, the kernel being hibernated would have to know in advance
which devices would be needed by the image-saving kernel.

> The normal driver shut down calls may not be suitable, 
> however, because although the same thing should be done to the hardware,
> the device shouldn't be "unregistered", since unlike in the actual
> shutdown case, the same device will need to brought back up again on
> resume, and it will need to have the same device id and such (and
> userspace probably shouldn't see the device going away).

Yes, IMO that's an important observation.  We shouldn't unregister devices
at this point and thus we need additinal callbacks for that.

> Any devices that will be needed by the "save image" kernel could also
> safely be shutdown as with the unneeded devices, but it would be more
> efficient to simply quiesce it.  Since this would be an additional
> complication, initially probably all of the hardware should be shut
> down, rather than quiesced.

Agreed, but spinning disks down and up during hibernation is really annoying.

> The reason that I think it is useful to actually shut down the devices,
> rather than merely leaving some unneeded devices quiesced, is that it
> would be useful to be able to build the "save image" kernel without
> support for unneeded devices.  In order to support "suspend to ram"
> instead of shutting down after saving the image to disk, the hibernate
> kernel needs to be able to send devices into a low power state.  My
> impression is that if there are devices it does not know about (i.e. the
> unneeded devices), but which are left quiesced but powered on, this
> would be a problem for suspend to ram, although not knowing much about
> how suspend to ram actually works, I could be mistaken.  (Maybe it is
> possible through ACPI or standard bus interfaces to shut down all of the
> devices without really knowing anything about them.)

I think that if we are going to support suspend-to-both (as Pavel calls it),
the image-saving kernel will have to support exactly the same set of devices
as the hibernated kernel.  In that case, it will be able to put all devices
into low power states for the suspend.

There's one more reason why that may be necessary, actually.  Namely, on ACPI
systems we may want to put the system into the S4 sleep state after saving the
image instead of just powering it off.  In turn, putting the system into the S4
sleep state is very similar to suspending it.

> >> >> 2. Do not reserve memory for kexec kernel. That is, backup needed memory
> >> >> before kexec and restore them after kexec.
> >> >
> >> > I don't think this is very important initially.
> >> 
> >> I agree, a stipped down hibernate kernel can be very small, not allocating 
> >> this memory until it's needed is a step for the final polishing.
> 
> > I'm not sure if I agree with that.  In any case, having to use two different
> > kernels for hibernation would be a big drawback.
> 
> I agree that it should not be necessary to use a separate kernel, but it
> would be useful to not _require_ that the same kernel is used.
>
> Practically, all this means is to save and restore the text sections as
> well, and not rely on the code itself remaining untouched during restore.

Yes, that might be useful.
 
> >> >> 3. Support the in-place kexec? The relocatable kernel is not necessary
> >> >> if this can be implemented.
> >> >> 4. Image writing/reading. (Only user space application is needed).
> >> >
> >> > And a kernel interface for that application.
> >> 
> >> I do't understand this statement, this application is just useing the 
> >> standard kernel interfaces (block devices to read/write to disk, network 
> >> devices to read/write to a server, etc). no new interfaces needed.
> 
> > Yes, but it will have to know _what_ to save, no?
> 
> I agree that a kernel interface would be important; something like
> /dev/snapshot that can be read by the "save image" kernel, and written
> to by the "restore image" kernel.  Note that similarly, kdump provides a
> kernel interface to an ELF image of the old kernel.

Yes, that's what I'm referring to.
 
> > Plus we need to figure out how to avoid corrupting filesystems and swap in use
> > by the "old" kernel and its processes (hint: a separate "hibernation partition"
> > is a no-go).
> 
> Presumably swapoff would take care of freeing up a swap partition for
> saving the image.  (It seems that this is the most common hibernate
> method, anyway.)

No, the swaps are not turned off for hibernation.

> If the user wants to write to a file, like a swap file, then the old kernel
> would need to somehow communicate the sequence of blocks in the file to the
> "save image" kernel.  Perhaps support for this method of saving the image
> need not be available initially. 

I think that the image-saving kernel will need to access the hibernated
kernel's swap data structures to figure out which blocks are safe.  That won't
be very easy, though.

> [snip]
> 
> > I think it's most portable to use initrd for that, which already makes things
> > complicated.  Then, we'll have to load the image and jump to the hibernated
> > kernel in such a way that it would be able to continue from where it stopped
> > before.  I don't think that is trivial.
> 
> As we've discussed before, I think the resume from hibernate can be done
> essentially exactly as it is done currently; it may likely be possible
> to reuse the uswsusp kernel code for this purpose.

Yes, I remember that discussion.

Still, I think that there also is an advantage of using kexec here, since in
that case we won't need additional support from the architectures that already
support kexec.

> >> >> 6. Reduce the boot-up time of kexec kernel. Maybe the kexec kernel can
> >> >> be hibernate/resume by the normal kernel too. This way, a real
> >> >> kexec/boot-up is only needed for the first time.
> >> >
> >> > I'm not sure what you mean.
> >> 
> >> he's trying to get fancy again, the best way to speed up the boot of the 
> >> kexec kernel is make it smaller and avoid probing for devices (hotplug 
> >> should NOT be used for normal suspend situations)
> 
> > Still, I believe that we should do our best to use only one kernel (meaning one
> > kernel image) here.
> 
> It seems that it is not very difficult to make the choice of using a
> different kernel or not one that the user can make.  The only extra
> thing required to allow a different kernel to be used is to save and
> restore the text sections.

Well, I know too little about kexec to be able to comment that.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
