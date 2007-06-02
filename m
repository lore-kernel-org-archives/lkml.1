Return-Path: <linux-kernel-owner+w=401wt.eu-S1756784AbXFBJQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784AbXFBJQi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 05:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753392AbXFBJQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 05:16:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59360 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752336AbXFBJQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 05:16:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeremy Maitin-Shepard <jbms@cmu.edu>
Subject: Re: A kexec approach to hibernation
Date: Sat, 2 Jun 2007 11:22:00 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>
References: <878xb3l888.fsf@jbms.ath.cx> <200706020233.44509.rjw@sisk.pl> <87k5un9l4n.fsf@jbms.ath.cx>
In-Reply-To: <87k5un9l4n.fsf@jbms.ath.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706021122.00786.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 2 June 2007 03:54, Jeremy Maitin-Shepard wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> >> But kernel threads also rely on userspace, due to e.g. fuse and usermode
> >> helpers.
> 
> > Yes, I know that and I think these issues are solvable within the current
> > approach.
> 
> It seems like it would be very hard to get writing of an image to a
> fuse filesystem working under the current scheme.

If the filesystem is located on a separate partition, that should be doable
(not that I'm going to try it in the foreseeable future).

> Trying to image a system while it is running seems fundamentally broken.

I don't agree.

> As another example, I believe currently although devices are "quiesced"
> or stopped while the atomic snapshot is made, they are all then started
> again afterward while the image is written to disk.  As a result, the
> network drivers will continue acking TCP packets that are received after
> the snapshot, but these packets will be lost.
> 
> You might claim then that the solution is to simply keep the network
> driver quiesced or stopped.  But then it is impossible to write the
> image over the network.  The way to get around this problem is to write
> the image over the network using a fresh network stack.

Can we just take the interface down and bring it up just for writing the image,
possibly with another IP address?  We don't need another kernel to do
that.

> >> [snip]
> >> 
> >> >> > One more thing: How do we restore the system state?
> >> >> 
> >> >> The "resume kernel" would be loaded at the same address as the "save
> >> >> kernel" was loaded (it should probably be the same kernel),
> >> 
> >> > Well, we'd have to use a relocatable kernel for this purpose, it
> >> > seems.
> >> 
> >> Not necessarily relocatable (although that would be the usual
> >> solution).  It just needs to be loaded at a different address than the
> >> normal kernel.
> 
> > AFAICS, you can't do that with a kernel which is not relocatable (you can load
> > it, of course, but will it work then?).
> 
> I seem to recall in recent kernel versions support for both a
> relocatable kernel and also support for non-relocatable kernels which
> load at a non-standard address.
> 
> >> If it isn't relocatable, the memory that would be needed by the "save kernel"
> >> would have to be reserved at boot. 
> 
> > That doesn't seem to be realistic to me.
> 
> Okay.  I don't see why there would be a problem with using a relocatable
> kernel though.
> 
> [snip]
> 
> >> >> Presumably it would be most convenient to have the normal boot loader
> >> >> load the resume kernel directly at the desired address.  The
> >> >> disadvantage is that at the same time the image is written, something
> >> >> would have to be done so that the boot loader would know to load the
> >> >> resume kernel, rather than the normal kernel.  (E.g. the image writing
> >> >> kernel would need to modify the grub config file.)
> >> 
> >> > No, it can't do that, unless the file is on a 'safe' filesystem
> >> 
> >> Grub, its configuration, and the kernel used to resume the system had
> >> better be on a "safe" filesystem already (i.e. a separate, unmounted
> >> before hibernation /boot).
> 
> > Currently, you don't need to do that.
> 
> Some people get away with it, but fundamentally it is broken to do so.
> (The fact that the current software suspend implementations tell the
> filesystems to sync to disk increases its chances of working.)  You are
> accessing a filesystem that is in an unknown state.  Consider that the
> user might make a change to grub.conf, but the kernel caches the write.
> If the filesystem containing grub.conf is left mounted, the write might
> never reach disk before the system is hibernated.  As a result, when
> grub attempts to read it, it doesn't get the expected data.

Yes, that can happen in theory (and I believe it's happend for some XFS
users), but _most_ often it just works and people are used to doing it.

> >> >> This shouldn't be a significant problem in practice.
> >> 
> >> > I don't agree here.
> >> 
> >> I think hibernate-script already includes support for modifying grub's
> >> configuration.
> 
> > Yes.  It does that _before_ the hibernation begins. ;-)
> 
> Either way, it doesn't make much difference.  Inside of
> hibernate-script, you need logic like:
> 
> if /boot is not mounted: mount /boot
> make change
> umount /boot
> 
> If you do it from the "save kernel", you need logic like:
> mount /dev/boot-device /boot  (no fstab on "save kernel", most likely)
> make change
> umount /boot.
> 
> [snip]
> 
> >> As far as I understand it, the swsusp resume path involves the boot
> >> kernel loading the entire image from disk to available memory, then
> >> shutting down all the devices, and copying the memory into place, and
> >> then jumping to the original kernel, which reinitializes devices and
> >> starts tasks running.  This isn't very different from what I was
> >> proposing as the alternative anyway, except that: memory is copied once,
> >> which is pretty fast, but means that only up to half of the total memory
> >> can be saved.
> 
> > No that's not correct.  Actually, during the restore we _can_ load much more
> > than 50% of RAM, everything needed for that is already in place. :-)
> 
> I suppose you do that by using more sophisticated logic to atomically
> copy the pages to their final location after loading them from disk.  In
> particular, I suppose you must order the page copies carefully to avoid
> clobbering pages that have not yet been copied.

Yes.

> Seems reasonable.  In that case, there is indeed probably no reason to not
> use that approach for resuming.
> 
> [snip]
> 
> >> The whole reason to want to checkpoint filesystems was so that the
> >> original kernel would remain a fully-functional system with a
> >> fully-functional userspace that can continue to access the filesystems
> >> while the hibernate image is being written.  In addition to the lack of
> >> checkpoint support, however, there are a number of other issues that
> >> this would create: Even if you can checkpoint filesystems, you can't
> >> checkpoint the entire world.  The kernel will keep acking network
> >> packets, and userspace as well will send any normal replies.  If a
> >> document was sent off to be printed right before the checkpoint, it
> >> might end up printing while the image is being saved, and then printed
> >> again when the system resumes.
> 
> > That's correct.
> 
> >> Fundamentally, I don't think checkpointing is the right answer.  What is
> >> desired is a fully functional system with a fully functional userspace
> >> during the image writing.  But we don't want this to be the _same_
> >> system that is actually being imaged.
> >> 
> >> That is why I think the kexec solution is the elegant solution.
> 
> > Frankly, I think it's tricky. ;-)
> 
> To me, it seems a lot easier to get right than the current approaches.

Well, maybe. :-)
 
> > Moreover, I think it would require some problems that we don't even
> > anticipate to be solved.
> 
> Possibly.  The alternative, though, seems to be to add hack after hack
> to get certain functionality to work.

The problem here is that you can't just anticipate everything and sometimes
you need to add hacks to handle problems that you have not anticipated.

I'm not sure if you're able to avoid adding hacks within the kexec-based
approach.

> >> > I see two basic advantages of your approach:
> >> > 1) We don't need to freeze tasks.
> >> > 2) We can create images larger than 50% of RAM.
> >> 
> >> There is also the key benefit of allowing an arbitrary userspace in a
> >> fully functional system to be used to both save and load the image.  As
> >> far as I understand, uswsusp allows a single userspace processes to run
> >> to handle the loading and saving, but the processes runs in a rather
> >> fragile userspace with most things disabled; in particular, this
> >> userspace process can't access a fuse filesystem and probably can't do
> >> other things like fork.
> 
> > The user space running on top of the new kernel would be limited by the
> > fact that the old kernel's filesystems would be inaccessible to it.  That
> > would, effectively, require the user to have special filesystems for the
> > image-saving kernel and its user space, which isn't very realistic
> > IMO.
> 
> Fundamentally, saving of the image can't access any of the normal
> filesystems anyway.  The userspace would likely be provided as an
> initramfs or initrd, exactly as is done for userspace resume from
> hibernate currently.  The same initramfs could probably be used for both
> saving the image and restoring the image, since exactly the same
> procedure would be used to set up the necessary devices for both the
> save and restore case, and the GUI that is used might also be the same.

Do you realize how much time would it take to implement that?

> >> > Still, I don't think we could implement it quickly and easily.
> >> 
> >> It is hard to say how hard it would be.  I think a lot of the existing
> >> kexec and hibernate code could be leveraged.
> 
> > Yes, I think so, but at least we need to fix the quiescing of devices before
> > we think of implementing that.
> 
> It seems like fixing of device stopping/suspend/quiescing is an
> orthogonal issue to the actual hibernate implementation.

Not that much, IMO, but that's not the issue.  The issue is that for the
kexec-based approach to work you'll need the devices to be quiesced properly.

> It would probably be most reliable and simplest if on every jump between
> kernels, all devices are fully stopped by the jumping kernel, and then fully
> reinitialized by the jumped-to kernel.

Yes, but that's not what's going on today.  So first, let's fix that.

> Presumably the time spent doing this initialization will not be very
> significant compared to the time required to write the image.

You are probably right.

Now, I think that your idea boils down to freezing the kernel along with all
tasks, which is reasonable, albeit extreme. :-)

I think we can consider doing something like this in the long run, but at
present we are not ready to do that.

Besides, I wouldn't like to drop the existing infrastructure that people use
and start over at some other place, because that would be wasteful.  Instead,
I'd prefer to improve the existing approach gradually, in such a way that
new code is added in a more-or-less transparent way (of course it's difficult
to avoid breaking things from time to time, but doing small steps it's easier
to fix bugs along the way).

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
