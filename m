Return-Path: <linux-kernel-owner+w=401wt.eu-S1757734AbXFAWZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757734AbXFAWZq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 18:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbXFAWZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 18:25:37 -0400
Received: from alnrmhc13.comcast.net ([206.18.177.53]:47878 "EHLO
	alnrmhc13.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880AbXFAWZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 18:25:36 -0400
From: Jeremy Maitin-Shepard <jbms@cmu.edu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: A kexec approach to hibernation
References: <878xb3l888.fsf@jbms.ath.cx> <200706012339.06379.rjw@sisk.pl>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Fri, 01 Jun 2007 18:25:20 -0400
In-Reply-To: <200706012339.06379.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Fri\, 1 Jun 2007 23\:39\:05 +0200")
Message-ID: <87zm3j9usv.fsf@jbms.ath.cx>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Friday, 1 June 2007 22:39, Jeremy Maitin-Shepard wrote:
>> I figured I'd throw this idea out, since although it is not perfect, it
>> has the potential to elegantly solve a lot of issues with hibernate.
>> 
>> Just as kexec can now be used to write a crashdump after a kernel panic,
>> a fresh kexec-loaded kernel (loaded into unused memory) could be used to
>> write the hibernate image of the existing kernel to disk, and then power
>> off the system (or suspend to ram, or anything else).  This avoids the
>> need for the original kernel to jump through hoops to hibernate itself
>> in place.
>> 
>> A hibernate sequence would be approximately as follows:
>> 
>> 1. Free some memory if needed or desired, and disable the swap device
>> if it is going to be used to write the hibernate image.

> Why to disable it?

To make sure that the swap data won't get clobbered by the writing of
the image, if the swap device is to be used to write the hibernate
image.  Presumably something similar is already done.  In any case this
is not an important point.

>> 2. Load the fresh kernel in a chunk of available (possibly
>> pre-allocated) memory (there must also be enough available memory
>> for this kernel to use).
>> 
>> 3. Disable interrupts and stop all devices.

> Well, this is one of the hardest parts of hibernation, so no advantage
> here.

It seems like support for this is mostly already in place though, and it
needs to be done for suspend to ram, kexec, and shutdown anyway.

>> 4. Jump to the new kernel, passing whatever state information will be
>> needed by it to know how to write the image.

> How would we know which data to write (more precisely, which data to
> tell the other kernel to write)?  How do we pass this information to
> the new kernel?

Just before jumping into the new kernel, with interrupts disabled, the
old kernel could either prepare a data structure that specifies what
pages are allocated, or alternatively simply provide a pointer to the
relevant data structure in the old kernel.  I can't say exactly how this
data would be given to the new kernel, but I can't imagine it being
difficult.  (For instance, multiboot headers, the kernel command line,
initrd, or some other mechanism could be used.)
 
>> 5. The new kernel loads, and then either kernel space or user space
>> writes the necessary data from the old kernel to disk.

> You also need to reinitialize devices needed to write the image.

Yes.  That would be done, as normal, when the kernel loads.  Currently
devices are suspended or stopped anyway before the atomic copy, and then
reinitialized to write the image.  In theory, this stopping shouldn't be
needed, and I mentioned that if additional support were added to some
drivers for passing some information about the current state of the
device, the device might only need to be partially shut down before
jumping to the new kernel.  This might allow, for instance, avoiding
spinning down and then up again the disks.

>> 6. The new kernel either powers off or suspends to ram.  If it suspends
>> to ram, then it would need to be able to jump back to the old kernel
>> when it resumes from ram.

> What if the user wants to abort the hibernation?

This would be handled in effectively the same way as if the user wants
to suspend to ram after writing the image: it would be necessary to jump
back to the old kernel.  This would effectively be handled in the same
way as a resume, except that the copying back of memory would be
avoided.  Presumably the image writing kernel would have devices in
approximately the same state as the image loading kernel, and so the old
kernel needs to be prepared to receive the devices in that state anyway.

>> The advantages of this approach include:
>> 
>> - having a completely functional system (with a completely functional
>> userspace) from which the image is written, without having to worry
>> about messing up the state that is being saved (hell, the user could
>> even do it via an interactive shell on the new kernel);
>> 
>> - no need to worry about trying to use drivers while some processes are
>> frozen;

> We're rather worried about running processes when the devices are
> frozen. ;-)

The point is, with this kexec approach, essentially no code at all runs
under the old kernel after the very initial steps of the hibernation
have begun, but any code, kernel or user, can run under the new kernel,
because the new kernel provides a completely functional system, while at
the same time not clobbering any of the memory of the old kernel.  In
particular, it will be possible to write the image to a fuse file
system.

>> - no need for complicated process freezing;

> In fact it's not complicated, at least as far as the user land is
> concerned.

I think given all of the issues about whether to freeze kernel or users
tasks, which tasks to freeze, etc., it is hard to argue that there are
not complications, and many possible bugs and deadlocks.  Linus made the
point that trying to freeze certain things and then continue using some
of the devices is fundamentally broken, because the freezer doesn't know
anything about dependencies.

>> the same logic that can be used for suspend to ram should be sufficient;
>> 
>> - no need for an atomic copy of memory, or any other complicated memory
>> copying; the memory of the old kernel, including the page cache, can
>> be written directly;
>> 
>> - instead of needing a significant amount of free memory to store the
>> atomic copy, only a few megabytes would needed to load and run the
>> new kernel.

> Yes, this sounds good in theory.

>> It may or may not be necessary to require that the new kernel used to
>> write the image is the same as the existing kernel; it will likely be
>> useful to require that it is built from the same sources and with a
>> similar config.  It would likely be useful, however, to either compile
>> out or (e.g. via the kernel command-line) disable the initialization of
>> drivers that will not be needed to write the image, such as sound
>> drivers, cdrom drivers, filesystems, and network drivers (if the image
>> is not to be written via the network).

> I think that, for average users, this would be difficult.

They could use the same kernel; it would simply be slower.  The
distributions could perhaps help with this.  If kernel command line
parameters could be used to disable certain subsystems, that should be
relatively easy for users.

>> Of course, if special initialization was needed under the original
>> kernel to set up the devices that will be used to write the image, such
>> as device mapper setup, or network initialization, that will have to be
>> repeated under the new kernel as well.  This is the principal
>> disadvantage to this approach, but since it must be done during resume
>> from hibernation in any case, it doesn't seem like a very significant
>> disadvantage.  The other disadvantage is that there would be the
>> delay of loading the fresh kernel; this may, however, only take a second
>> or two, which is relatively insignificant compared to the time required
>> to actually write the image, and the delay could be reduced by stripping
>> out unnecessary drivers from the image-writing kernel.

> One more thing: How do we restore the system state?

The "resume kernel" would be loaded at the same address as the "save
kernel" was loaded (it should probably be the same kernel), and then
have it copy back the image completely without any need for atomic
copies.  It can then place the devices in the desired state, and jump to
it.  The old kernel would then do what it needs to do with the devices,
and start running things again.

Presumably it would be most convenient to have the normal boot loader
load the resume kernel directly at the desired address.  The
disadvantage is that at the same time the image is written, something
would have to be done so that the boot loader would know to load the
resume kernel, rather than the normal kernel.  (E.g. the image writing
kernel would need to modify the grub config file.)  This shouldn't be a
significant problem in practice.

If resume fails, the resume kernel could just print an error message.
The user would be forced to manually tell the boot loader to not load
the resume kernel (perhaps by selecting a non-default menu option).
Alternatively, the resume kernel could just initialize all devices and
load the system as normal (this won't be possible if the resume kernel
was compiled with certain device support not needed for suspending
removed, though), or kexec another kernel.

It shouldn't matter too much how convenient it is when resume from
hibernate fails, because that shouldn't happen very often anyway.

-- 
Jeremy Maitin-Shepard
