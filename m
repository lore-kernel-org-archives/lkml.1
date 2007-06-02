Return-Path: <linux-kernel-owner+w=401wt.eu-S1761665AbXFBA2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761665AbXFBA2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 20:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757446AbXFBA2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 20:28:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58307 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594AbXFBA2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 20:28:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeremy Maitin-Shepard <jbms@cmu.edu>
Subject: Re: A kexec approach to hibernation
Date: Sat, 2 Jun 2007 02:33:43 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>
References: <878xb3l888.fsf@jbms.ath.cx> <200706020114.37245.rjw@sisk.pl> <87odjz9qo9.fsf@jbms.ath.cx>
In-Reply-To: <87odjz9qo9.fsf@jbms.ath.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706020233.44509.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 2 June 2007 01:54, Jeremy Maitin-Shepard wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > On Saturday, 2 June 2007 00:25, Jeremy Maitin-Shepard wrote:
> 
> [snip]
> 
> >> Just before jumping into the new kernel, with interrupts disabled, the
> >> old kernel could either prepare a data structure that specifies what
> >> pages are allocated, or alternatively simply provide a pointer to the
> >> relevant data structure in the old kernel.
> 
> > But for this purpose the old kernel will actually need to do what is currently
> > done in swsusp while the image is being created (the only difference is that
> > we allocate memory in the process, but that's a detail only).
> 
> Okay, but creating a list of pages should be extremely easy.
> Alternatively, with the "save kernel" might be able to read the existing
> data structures directly.
> 
> >> I can't say exactly how this data would be given to the new kernel, but I
> >> can't imagine it being difficult.  (For instance, multiboot headers, the
> >> kernel command line, initrd, or some other mechanism could be used.)
> 
> > Besides, you need to load the new kernel somehow.  If that's to work without
> > problems, that should be done before we switch off devices.
> 
> Well, the new kernel can be loaded at any time,

No.  By reading from a file systems, you're modifying it's meta data (in
general, of course).

> and would be done in exactly the way kexec loads a kernel.  It would probably
> make sense to load the kernel into memory (but not jump to it) as the very
> first step of hibernation.

I think you'd have to do that.

> >> >> 5. The new kernel loads, and then either kernel space or user space
> >> >> writes the necessary data from the old kernel to disk.
> >> 
> >> > You also need to reinitialize devices needed to write the image.
> >> 
> >> Yes.  That would be done, as normal, when the kernel loads.  Currently
> >> devices are suspended or stopped anyway before the atomic copy, and then
> >> reinitialized to write the image.  In theory, this stopping shouldn't be
> >> needed, and I mentioned that if additional support were added to some
> >> drivers for passing some information about the current state of the
> >> device, the device might only need to be partially shut down before
> >> jumping to the new kernel.  This might allow, for instance, avoiding
> >> spinning down and then up again the disks.
> 
> > Well, I don't quite agree.  I think that for this purpose we'll need devices to
> > be initialized from scratch by the new kernel, so the old kernel should put
> > them into states that allow this to be done.
> 
> I agree that the default behavior should be to completely shut down the
> devices.  Later, special support could be added to select devices to
> allow them to not be fully shut down.
> 
> > We are going to implement something like this anyway, but that's a rather long
> > way to go.
> 
> >> >> 6. The new kernel either powers off or suspends to ram.  If it suspends
> >> >> to ram, then it would need to be able to jump back to the old kernel
> >> >> when it resumes from ram.
> >> 
> >> > What if the user wants to abort the hibernation?
> >> 
> >> This would be handled in effectively the same way as if the user wants
> >> to suspend to ram after writing the image: it would be necessary to jump
> >> back to the old kernel.  This would effectively be handled in the same
> >> way as a resume, except that the copying back of memory would be
> >> avoided.  Presumably the image writing kernel would have devices in
> >> approximately the same state as the image loading kernel, and so the old
> >> kernel needs to be prepared to receive the devices in that state anyway.
> 
> > Please see above.  I don't think that would be easy to arrange for.
> 
> In that case, the devices can indeed be fully shut down, at least
> initially.
> 
> >> >> The advantages of this approach include:
> >> >> 
> >> >> - having a completely functional system (with a completely functional
> >> >> userspace) from which the image is written, without having to worry
> >> >> about messing up the state that is being saved (hell, the user could
> >> >> even do it via an interactive shell on the new kernel);
> >> >> 
> >> >> - no need to worry about trying to use drivers while some processes are
> >> >> frozen;
> >> 
> >> > We're rather worried about running processes when the devices are
> >> > frozen. ;-)
> >> 
> >> The point is, with this kexec approach, essentially no code at all runs
> >> under the old kernel after the very initial steps of the hibernation
> >> have begun, but any code, kernel or user, can run under the new kernel,
> >> because the new kernel provides a completely functional system, while at
> >> the same time not clobbering any of the memory of the old kernel.  In
> >> particular, it will be possible to write the image to a fuse file
> >> system.
> 
> > You need to be cautious here.  You can't touch any filesystems mounted by
> > the old kernel, or they will be corrupted after the restore.
> 
> Certainly.  Note that any filesystems that are available to the "save
> state" kernel would have been specifically mounted under that kernel.
> There isn't any real possibility of confusion over which filesystems are
> safe to access.
> 
> >> >> - no need for complicated process freezing;
> >> 
> >> > In fact it's not complicated, at least as far as the user land is
> >> > concerned.
> >> 
> >> I think given all of the issues about whether to freeze kernel or users
> >> tasks, which tasks to freeze, etc., it is hard to argue that there are
> >> not complications, and many possible bugs and deadlocks.  Linus made the
> >> point that trying to freeze certain things and then continue using some
> >> of the devices is fundamentally broken, because the freezer doesn't know
> >> anything about dependencies.
> 
> > Yes, this applies to kernel threads and I agree with that, except that there
> > are kernel threads independent of any other tasks, so we don't need to worry
> > about them.
> 
> But kernel threads also rely on userspace, due to e.g. fuse and usermode
> helpers.

Yes, I know that and I think these issues are solvable within the current
approach.

> [snip]
> 
> >> > One more thing: How do we restore the system state?
> >> 
> >> The "resume kernel" would be loaded at the same address as the "save
> >> kernel" was loaded (it should probably be the same kernel),
> 
> > Well, we'd have to use a relocatable kernel for this purpose, it
> > seems.
> 
> Not necessarily relocatable (although that would be the usual
> solution).  It just needs to be loaded at a different address than the
> normal kernel.

AFAICS, you can't do that with a kernel which is not relocatable (you can load
it, of course, but will it work then?).

> If it isn't relocatable, the memory that would be needed by the "save kernel"
> would have to be reserved at boot. 

That doesn't seem to be realistic to me.
 
> >> and then have it copy back the image completely without any need for atomic
> >> copies.  It can then place the devices in the desired state, and jump to
> >> it.  The old kernel would then do what it needs to do with the devices,
> >> and start running things again.
> >> 
> >> Presumably it would be most convenient to have the normal boot loader
> >> load the resume kernel directly at the desired address.  The
> >> disadvantage is that at the same time the image is written, something
> >> would have to be done so that the boot loader would know to load the
> >> resume kernel, rather than the normal kernel.  (E.g. the image writing
> >> kernel would need to modify the grub config file.)
> 
> > No, it can't do that, unless the file is on a 'safe' filesystem
> 
> Grub, its configuration, and the kernel used to resume the system had
> better be on a "safe" filesystem already (i.e. a separate, unmounted
> before hibernation /boot).

Currently, you don't need to do that.

> >> This shouldn't be a significant problem in practice.
> 
> > I don't agree here.
> 
> I think hibernate-script already includes support for modifying grub's
> configuration.

Yes.  It does that _before_ the hibernation begins. ;-)

> >> If resume fails, the resume kernel could just print an error message.
> >> The user would be forced to manually tell the boot loader to not load
> >> the resume kernel (perhaps by selecting a non-default menu option).
> >> Alternatively, the resume kernel could just initialize all devices and
> >> load the system as normal (this won't be possible if the resume kernel
> >> was compiled with certain device support not needed for suspending
> >> removed, though), or kexec another kernel.
> 
> > Actually, I think we could restore in the same way as we do it right now,
> > if the image contained the right information (which I think it should anyway),
> > so that's not a big deal technically, but the current code would be needed
> > anyway.
> 
> As far as I understand it, the swsusp resume path involves the boot
> kernel loading the entire image from disk to available memory, then
> shutting down all the devices, and copying the memory into place, and
> then jumping to the original kernel, which reinitializes devices and
> starts tasks running.  This isn't very different from what I was
> proposing as the alternative anyway, except that: memory is copied once,
> which is pretty fast, but means that only up to half of the total memory
> can be saved.

No that's not correct.  Actually, during the restore we _can_ load much more
than 50% of RAM, everything needed for that is already in place. :-)

The problem is that we can't _save_ more than 50% of RAM without either doing
the suspend2's trick, or saving some memory contents directly from where it is.

Currently, we need to copy each page before saving it, which I admit is a bit
wasteful, but it generally is difficult to say which pages can be saved without
copying (your approach solves this problem quite radically).  If we had known
that, we would have been able to create even very large images just fine.

> The suspend2 resume path is a bit more complicated, it seems: it copies
> some of the kernel memory off disk to available memory (everything
> except page caches), shuts down devices, copies that memory in place,
> jumps to it, and then the original kernel reinitializes devices, and
> copies the remaining pages off disk into place directly.  Having the
> original kernel take care of copying some memory back would be totally
> incompatible with my proposal, since the original kernel would not be
> prepared to access the device containing the hibernate image (since it
> never accessed the device during hibernation).
> 
> >> It shouldn't matter too much how convenient it is when resume from
> >> hibernate fails, because that shouldn't happen very often anyway.
> 
> > Except when there's a problem to debug. ;-)
> 
> The gain would be a faster resume from hibernation, because there would
> be no need to load unnecessary drivers.  The disadvantage is that
> instead of being able to just go on and boot a normal system if resuming
> fails, it would be necessary to reboot.  I don't think that presents a
> significant inconvenience.
> 
> > All in all, I think that the idea is worth considering, although the details
> > need to be clarified before we can try to implement it.
> 
> > However, it really doesn't solve the basic problem that we have, which is
> > that we can't checkpoint filesystems easily.  That's why we freeze processes
> > in the first place and you're suggesting to replace this with another, equally
> > if not more complicated, mechanism.
> 
> The whole reason to want to checkpoint filesystems was so that the
> original kernel would remain a fully-functional system with a
> fully-functional userspace that can continue to access the filesystems
> while the hibernate image is being written.  In addition to the lack of
> checkpoint support, however, there are a number of other issues that
> this would create: Even if you can checkpoint filesystems, you can't
> checkpoint the entire world.  The kernel will keep acking network
> packets, and userspace as well will send any normal replies.  If a
> document was sent off to be printed right before the checkpoint, it
> might end up printing while the image is being saved, and then printed
> again when the system resumes.

That's correct.

> Fundamentally, I don't think checkpointing is the right answer.  What is
> desired is a fully functional system with a fully functional userspace
> during the image writing.  But we don't want this to be the _same_
> system that is actually being imaged.
> 
> That is why I think the kexec solution is the elegant solution.

Frankly, I think it's tricky. ;-)  Moreover, I think it would require some
problems that we don't even anticipate to be solved.

> > I see two basic advantages of your approach:
> > 1) We don't need to freeze tasks.
> > 2) We can create images larger than 50% of RAM.
> 
> There is also the key benefit of allowing an arbitrary userspace in a
> fully functional system to be used to both save and load the image.  As
> far as I understand, uswsusp allows a single userspace processes to run
> to handle the loading and saving, but the processes runs in a rather
> fragile userspace with most things disabled; in particular, this
> userspace process can't access a fuse filesystem and probably can't do
> other things like fork.

The user space running on top of the new kernel would be limited by the
fact that the old kernel's filesystems would be inaccessible to it.  That
would, effectively, require the user to have special filesystems for the
image-saving kernel and its user space, which isn't very realistic IMO.

> > Still, I don't think we could implement it quickly and easily.
> 
> It is hard to say how hard it would be.  I think a lot of the existing
> kexec and hibernate code could be leveraged.

Yes, I think so, but at least we need to fix the quiescing of devices before
we think of implementing that.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
