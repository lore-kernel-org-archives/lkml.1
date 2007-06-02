Return-Path: <linux-kernel-owner+w=401wt.eu-S1763423AbXFBB7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763423AbXFBB7v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 21:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762225AbXFBB7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 21:59:39 -0400
Received: from rwcrmhc11.comcast.net ([216.148.227.151]:54737 "EHLO
	rwcrmhc11.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761587AbXFBB7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 21:59:36 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Jun 2007 21:59:36 EDT
From: Jeremy Maitin-Shepard <jbms@cmu.edu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: A kexec approach to hibernation
References: <878xb3l888.fsf@jbms.ath.cx> <200706020114.37245.rjw@sisk.pl>
	<87odjz9qo9.fsf@jbms.ath.cx> <200706020233.44509.rjw@sisk.pl>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Fri, 01 Jun 2007 21:54:16 -0400
In-Reply-To: <200706020233.44509.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Sat\, 2 Jun 2007 02\:33\:43 +0200")
Message-ID: <87k5un9l4n.fsf@jbms.ath.cx>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

>> But kernel threads also rely on userspace, due to e.g. fuse and usermode
>> helpers.

> Yes, I know that and I think these issues are solvable within the current
> approach.

It seems like it would be very hard to get writing of an image to a
fuse filesystem working under the current scheme.

Trying to image a system while it is running seems fundamentally broken.
As another example, I believe currently although devices are "quiesced"
or stopped while the atomic snapshot is made, they are all then started
again afterward while the image is written to disk.  As a result, the
network drivers will continue acking TCP packets that are received after
the snapshot, but these packets will be lost.

You might claim then that the solution is to simply keep the network
driver quiesced or stopped.  But then it is impossible to write the
image over the network.  The way to get around this problem is to write
the image over the network using a fresh network stack.

>> [snip]
>> 
>> >> > One more thing: How do we restore the system state?
>> >> 
>> >> The "resume kernel" would be loaded at the same address as the "save
>> >> kernel" was loaded (it should probably be the same kernel),
>> 
>> > Well, we'd have to use a relocatable kernel for this purpose, it
>> > seems.
>> 
>> Not necessarily relocatable (although that would be the usual
>> solution).  It just needs to be loaded at a different address than the
>> normal kernel.

> AFAICS, you can't do that with a kernel which is not relocatable (you can load
> it, of course, but will it work then?).

I seem to recall in recent kernel versions support for both a
relocatable kernel and also support for non-relocatable kernels which
load at a non-standard address.

>> If it isn't relocatable, the memory that would be needed by the "save kernel"
>> would have to be reserved at boot. 

> That doesn't seem to be realistic to me.

Okay.  I don't see why there would be a problem with using a relocatable
kernel though.

[snip]

>> >> Presumably it would be most convenient to have the normal boot loader
>> >> load the resume kernel directly at the desired address.  The
>> >> disadvantage is that at the same time the image is written, something
>> >> would have to be done so that the boot loader would know to load the
>> >> resume kernel, rather than the normal kernel.  (E.g. the image writing
>> >> kernel would need to modify the grub config file.)
>> 
>> > No, it can't do that, unless the file is on a 'safe' filesystem
>> 
>> Grub, its configuration, and the kernel used to resume the system had
>> better be on a "safe" filesystem already (i.e. a separate, unmounted
>> before hibernation /boot).

> Currently, you don't need to do that.

Some people get away with it, but fundamentally it is broken to do so.
(The fact that the current software suspend implementations tell the
filesystems to sync to disk increases its chances of working.)  You are
accessing a filesystem that is in an unknown state.  Consider that the
user might make a change to grub.conf, but the kernel caches the write.
If the filesystem containing grub.conf is left mounted, the write might
never reach disk before the system is hibernated.  As a result, when
grub attempts to read it, it doesn't get the expected data.

>> >> This shouldn't be a significant problem in practice.
>> 
>> > I don't agree here.
>> 
>> I think hibernate-script already includes support for modifying grub's
>> configuration.

> Yes.  It does that _before_ the hibernation begins. ;-)

Either way, it doesn't make much difference.  Inside of
hibernate-script, you need logic like:

if /boot is not mounted: mount /boot
make change
umount /boot

If you do it from the "save kernel", you need logic like:
mount /dev/boot-device /boot  (no fstab on "save kernel", most likely)
make change
umount /boot.

[snip]

>> As far as I understand it, the swsusp resume path involves the boot
>> kernel loading the entire image from disk to available memory, then
>> shutting down all the devices, and copying the memory into place, and
>> then jumping to the original kernel, which reinitializes devices and
>> starts tasks running.  This isn't very different from what I was
>> proposing as the alternative anyway, except that: memory is copied once,
>> which is pretty fast, but means that only up to half of the total memory
>> can be saved.

> No that's not correct.  Actually, during the restore we _can_ load much more
> than 50% of RAM, everything needed for that is already in place. :-)

I suppose you do that by using more sophisticated logic to atomically
copy the pages to their final location after loading them from disk.  In
particular, I suppose you must order the page copies carefully to avoid
clobbering pages that have not yet been copied.  Seems reasonable.  In
that case, there is indeed probably no reason to not use that approach
for resuming.

[snip]

>> The whole reason to want to checkpoint filesystems was so that the
>> original kernel would remain a fully-functional system with a
>> fully-functional userspace that can continue to access the filesystems
>> while the hibernate image is being written.  In addition to the lack of
>> checkpoint support, however, there are a number of other issues that
>> this would create: Even if you can checkpoint filesystems, you can't
>> checkpoint the entire world.  The kernel will keep acking network
>> packets, and userspace as well will send any normal replies.  If a
>> document was sent off to be printed right before the checkpoint, it
>> might end up printing while the image is being saved, and then printed
>> again when the system resumes.

> That's correct.

>> Fundamentally, I don't think checkpointing is the right answer.  What is
>> desired is a fully functional system with a fully functional userspace
>> during the image writing.  But we don't want this to be the _same_
>> system that is actually being imaged.
>> 
>> That is why I think the kexec solution is the elegant solution.

> Frankly, I think it's tricky. ;-)

To me, it seems a lot easier to get right than the current approaches.

> Moreover, I think it would require some problems that we don't even
> anticipate to be solved.

Possibly.  The alternative, though, seems to be to add hack after hack
to get certain functionality to work.

>> > I see two basic advantages of your approach:
>> > 1) We don't need to freeze tasks.
>> > 2) We can create images larger than 50% of RAM.
>> 
>> There is also the key benefit of allowing an arbitrary userspace in a
>> fully functional system to be used to both save and load the image.  As
>> far as I understand, uswsusp allows a single userspace processes to run
>> to handle the loading and saving, but the processes runs in a rather
>> fragile userspace with most things disabled; in particular, this
>> userspace process can't access a fuse filesystem and probably can't do
>> other things like fork.

> The user space running on top of the new kernel would be limited by the
> fact that the old kernel's filesystems would be inaccessible to it.  That
> would, effectively, require the user to have special filesystems for the
> image-saving kernel and its user space, which isn't very realistic
> IMO.

Fundamentally, saving of the image can't access any of the normal
filesystems anyway.  The userspace would likely be provided as an
initramfs or initrd, exactly as is done for userspace resume from
hibernate currently.  The same initramfs could probably be used for both
saving the image and restoring the image, since exactly the same
procedure would be used to set up the necessary devices for both the
save and restore case, and the GUI that is used might also be the same.

>> > Still, I don't think we could implement it quickly and easily.
>> 
>> It is hard to say how hard it would be.  I think a lot of the existing
>> kexec and hibernate code could be leveraged.

> Yes, I think so, but at least we need to fix the quiescing of devices before
> we think of implementing that.

It seems like fixing of device stopping/suspend/quiescing is an
orthogonal issue to the actual hibernate implementation.  It would
probably be most reliable and simplest if on every jump between kernels,
all devices are fully stopped by the jumping kernel, and then fully
reinitialized by the jumped-to kernel.  Presumably the time spent doing
this initialization will not be very significant compared to the time
required to write the image.

-- 
Jeremy Maitin-Shepard
