Return-Path: <linux-kernel-owner+w=401wt.eu-S1757881AbXFAXJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757881AbXFAXJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 19:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbXFAXJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 19:09:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58047 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546AbXFAXJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 19:09:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeremy Maitin-Shepard <jbms@cmu.edu>
Subject: Re: A kexec approach to hibernation
Date: Sat, 2 Jun 2007 01:14:36 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>
References: <878xb3l888.fsf@jbms.ath.cx> <200706012339.06379.rjw@sisk.pl> <87zm3j9usv.fsf@jbms.ath.cx>
In-Reply-To: <87zm3j9usv.fsf@jbms.ath.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706020114.37245.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 2 June 2007 00:25, Jeremy Maitin-Shepard wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > On Friday, 1 June 2007 22:39, Jeremy Maitin-Shepard wrote:
> >> I figured I'd throw this idea out, since although it is not perfect, it
> >> has the potential to elegantly solve a lot of issues with hibernate.
> >> 
> >> Just as kexec can now be used to write a crashdump after a kernel panic,
> >> a fresh kexec-loaded kernel (loaded into unused memory) could be used to
> >> write the hibernate image of the existing kernel to disk, and then power
> >> off the system (or suspend to ram, or anything else).  This avoids the
> >> need for the original kernel to jump through hoops to hibernate itself
> >> in place.
> >> 
> >> A hibernate sequence would be approximately as follows:
> >> 
> >> 1. Free some memory if needed or desired, and disable the swap device
> >> if it is going to be used to write the hibernate image.
> 
> > Why to disable it?
> 
> To make sure that the swap data won't get clobbered by the writing of
> the image, if the swap device is to be used to write the hibernate
> image.  Presumably something similar is already done.  In any case this
> is not an important point.
> 
> >> 2. Load the fresh kernel in a chunk of available (possibly
> >> pre-allocated) memory (there must also be enough available memory
> >> for this kernel to use).
> >> 
> >> 3. Disable interrupts and stop all devices.
> 
> > Well, this is one of the hardest parts of hibernation, so no advantage
> > here.
> 
> It seems like support for this is mostly already in place though, and it
> needs to be done for suspend to ram, kexec, and shutdown anyway.
> 
> >> 4. Jump to the new kernel, passing whatever state information will be
> >> needed by it to know how to write the image.
> 
> > How would we know which data to write (more precisely, which data to
> > tell the other kernel to write)?  How do we pass this information to
> > the new kernel?
> 
> Just before jumping into the new kernel, with interrupts disabled, the
> old kernel could either prepare a data structure that specifies what
> pages are allocated, or alternatively simply provide a pointer to the
> relevant data structure in the old kernel.

But for this purpose the old kernel will actually need to do what is currently
done in swsusp while the image is being created (the only difference is that
we allocate memory in the process, but that's a detail only).

> I can't say exactly how this data would be given to the new kernel, but I
> can't imagine it being difficult.  (For instance, multiboot headers, the
> kernel command line, initrd, or some other mechanism could be used.)

Besides, you need to load the new kernel somehow.  If that's to work without
problems, that should be done before we switch off devices.

> >> 5. The new kernel loads, and then either kernel space or user space
> >> writes the necessary data from the old kernel to disk.
> 
> > You also need to reinitialize devices needed to write the image.
> 
> Yes.  That would be done, as normal, when the kernel loads.  Currently
> devices are suspended or stopped anyway before the atomic copy, and then
> reinitialized to write the image.  In theory, this stopping shouldn't be
> needed, and I mentioned that if additional support were added to some
> drivers for passing some information about the current state of the
> device, the device might only need to be partially shut down before
> jumping to the new kernel.  This might allow, for instance, avoiding
> spinning down and then up again the disks.

Well, I don't quite agree.  I think that for this purpose we'll need devices to
be initialized from scratch by the new kernel, so the old kernel should put
them into states that allow this to be done.

We are going to implement something like this anyway, but that's a rather long
way to go.

> >> 6. The new kernel either powers off or suspends to ram.  If it suspends
> >> to ram, then it would need to be able to jump back to the old kernel
> >> when it resumes from ram.
> 
> > What if the user wants to abort the hibernation?
> 
> This would be handled in effectively the same way as if the user wants
> to suspend to ram after writing the image: it would be necessary to jump
> back to the old kernel.  This would effectively be handled in the same
> way as a resume, except that the copying back of memory would be
> avoided.  Presumably the image writing kernel would have devices in
> approximately the same state as the image loading kernel, and so the old
> kernel needs to be prepared to receive the devices in that state anyway.

Please see above.  I don't think that would be easy to arrange for.

> >> The advantages of this approach include:
> >> 
> >> - having a completely functional system (with a completely functional
> >> userspace) from which the image is written, without having to worry
> >> about messing up the state that is being saved (hell, the user could
> >> even do it via an interactive shell on the new kernel);
> >> 
> >> - no need to worry about trying to use drivers while some processes are
> >> frozen;
> 
> > We're rather worried about running processes when the devices are
> > frozen. ;-)
> 
> The point is, with this kexec approach, essentially no code at all runs
> under the old kernel after the very initial steps of the hibernation
> have begun, but any code, kernel or user, can run under the new kernel,
> because the new kernel provides a completely functional system, while at
> the same time not clobbering any of the memory of the old kernel.  In
> particular, it will be possible to write the image to a fuse file
> system.

You need to be cautious here.  You can't touch any filesystems mounted by
the old kernel, or they will be corrupted after the restore.

> >> - no need for complicated process freezing;
> 
> > In fact it's not complicated, at least as far as the user land is
> > concerned.
> 
> I think given all of the issues about whether to freeze kernel or users
> tasks, which tasks to freeze, etc., it is hard to argue that there are
> not complications, and many possible bugs and deadlocks.  Linus made the
> point that trying to freeze certain things and then continue using some
> of the devices is fundamentally broken, because the freezer doesn't know
> anything about dependencies.

Yes, this applies to kernel threads and I agree with that, except that there
are kernel threads independent of any other tasks, so we don't need to worry
about them.

> >> the same logic that can be used for suspend to ram should be sufficient;
> >> 
> >> - no need for an atomic copy of memory, or any other complicated memory
> >> copying; the memory of the old kernel, including the page cache, can
> >> be written directly;
> >> 
> >> - instead of needing a significant amount of free memory to store the
> >> atomic copy, only a few megabytes would needed to load and run the
> >> new kernel.
> 
> > Yes, this sounds good in theory.
> 
> >> It may or may not be necessary to require that the new kernel used to
> >> write the image is the same as the existing kernel; it will likely be
> >> useful to require that it is built from the same sources and with a
> >> similar config.  It would likely be useful, however, to either compile
> >> out or (e.g. via the kernel command-line) disable the initialization of
> >> drivers that will not be needed to write the image, such as sound
> >> drivers, cdrom drivers, filesystems, and network drivers (if the image
> >> is not to be written via the network).
> 
> > I think that, for average users, this would be difficult.
> 
> They could use the same kernel; it would simply be slower.  The
> distributions could perhaps help with this.  If kernel command line
> parameters could be used to disable certain subsystems, that should be
> relatively easy for users.

Well, I don't agree here.  My experience with the userland suspend is that such
things are generally very difficult for users to set up.

> >> Of course, if special initialization was needed under the original
> >> kernel to set up the devices that will be used to write the image, such
> >> as device mapper setup, or network initialization, that will have to be
> >> repeated under the new kernel as well.  This is the principal
> >> disadvantage to this approach, but since it must be done during resume
> >> from hibernation in any case, it doesn't seem like a very significant
> >> disadvantage.  The other disadvantage is that there would be the
> >> delay of loading the fresh kernel; this may, however, only take a second
> >> or two, which is relatively insignificant compared to the time required
> >> to actually write the image, and the delay could be reduced by stripping
> >> out unnecessary drivers from the image-writing kernel.
> 
> > One more thing: How do we restore the system state?
> 
> The "resume kernel" would be loaded at the same address as the "save
> kernel" was loaded (it should probably be the same kernel),

Well, we'd have to use a relocatable kernel for this purpose, it seems.

> and then have it copy back the image completely without any need for atomic
> copies.  It can then place the devices in the desired state, and jump to
> it.  The old kernel would then do what it needs to do with the devices,
> and start running things again.
> 
> Presumably it would be most convenient to have the normal boot loader
> load the resume kernel directly at the desired address.  The
> disadvantage is that at the same time the image is written, something
> would have to be done so that the boot loader would know to load the
> resume kernel, rather than the normal kernel.  (E.g. the image writing
> kernel would need to modify the grub config file.)

No, it can't do that, unless the file is on a 'safe' filesystem

> This shouldn't be a significant problem in practice.

I don't agree here.

> If resume fails, the resume kernel could just print an error message.
> The user would be forced to manually tell the boot loader to not load
> the resume kernel (perhaps by selecting a non-default menu option).
> Alternatively, the resume kernel could just initialize all devices and
> load the system as normal (this won't be possible if the resume kernel
> was compiled with certain device support not needed for suspending
> removed, though), or kexec another kernel.

Actually, I think we could restore in the same way as we do it right now,
if the image contained the right information (which I think it should anyway),
so that's not a big deal technically, but the current code would be needed
anyway.
 
> It shouldn't matter too much how convenient it is when resume from
> hibernate fails, because that shouldn't happen very often anyway.

Except when there's a problem to debug. ;-)

All in all, I think that the idea is worth considering, although the details
need to be clarified before we can try to implement it.

However, it really doesn't solve the basic problem that we have, which is
that we can't checkpoint filesystems easily.  That's why we freeze processes
in the first place and you're suggesting to replace this with another, equally
if not more complicated, mechanism.

I see two basic advantages of your approach:
1) We don't need to freeze tasks.
2) We can create images larger than 50% of RAM.
Still, I don't think we could implement it quickly and easily.

[And really, the freezing of tasks is not that horrible, although it may seem
so. ;-)]

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
