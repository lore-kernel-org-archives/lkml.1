Return-Path: <linux-kernel-owner+w=401wt.eu-S934684AbXGLT4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934684AbXGLT4E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 15:56:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756314AbXGLTzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 15:55:54 -0400
Received: from smtp.andrew.cmu.edu ([128.2.10.83]:41746 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755011AbXGLTzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 15:55:53 -0400
From: Jeremy Maitin-Shepard <jbms@cmu.edu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: david@lang.hm, "Huang\, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
References: <1184167831.12556.13.camel@caritas-dev.intel.com>
	<200707121453.49616.rjw@sisk.pl>
	<Pine.LNX.4.64.0707121150460.25614@asgard.lang.hm>
	<200707122134.29991.rjw@sisk.pl>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Thu, 12 Jul 2007 15:55:05 -0400
In-Reply-To: <200707122134.29991.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Thu\, 12 Jul 2007 21\:34\:28 +0200")
Message-ID: <877ip54cti.fsf@jbms.ath.cx>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

[snip]

> There's more to it, though.  If devices are suspended, the hibernation kernel
> will have to resume them (using platform, like ACPI, callbacks in the process)
> instead and that will get complicated.

> It's better if devices are quiesced, or even shut down, before we call the
> hibernation kernel.

I agree that they definitely should not be put into a low power mode, as
that has nothing to do with hibernation.

Ideally, the following would be done:

All of the hardware that won't be needed by the "save image" kernel will
be shut down.  The normal driver shut down calls may not be suitable,
however, because although the same thing should be done to the hardware,
the device shouldn't be "unregistered", since unlike in the actual
shutdown case, the same device will need to brought back up again on
resume, and it will need to have the same device id and such (and
userspace probably shouldn't see the device going away).

Any devices that will be needed by the "save image" kernel could also
safely be shutdown as with the unneeded devices, but it would be more
efficient to simply quiesce it.  Since this would be an additional
complication, initially probably all of the hardware should be shut
down, rather than quiesced.

The reason that I think it is useful to actually shut down the devices,
rather than merely leaving some unneeded devices quiesced, is that it
would be useful to be able to build the "save image" kernel without
support for unneeded devices.  In order to support "suspend to ram"
instead of shutting down after saving the image to disk, the hibernate
kernel needs to be able to send devices into a low power state.  My
impression is that if there are devices it does not know about (i.e. the
unneeded devices), but which are left quiesced but powered on, this
would be a problem for suspend to ram, although not knowing much about
how suspend to ram actually works, I could be mistaken.  (Maybe it is
possible through ACPI or standard bus interfaces to shut down all of the
devices without really knowing anything about them.)

>> >> 2. Do not reserve memory for kexec kernel. That is, backup needed memory
>> >> before kexec and restore them after kexec.
>> >
>> > I don't think this is very important initially.
>> 
>> I agree, a stipped down hibernate kernel can be very small, not allocating 
>> this memory until it's needed is a step for the final polishing.

> I'm not sure if I agree with that.  In any case, having to use two different
> kernels for hibernation would be a big drawback.

I agree that it should not be necessary to use a separate kernel, but it
would be useful to not _require_ that the same kernel is used.
Practically, all this means is to save and restore the text sections as
well, and not rely on the code itself remaining untouched during restore.

>> >> 3. Support the in-place kexec? The relocatable kernel is not necessary
>> >> if this can be implemented.
>> >> 4. Image writing/reading. (Only user space application is needed).
>> >
>> > And a kernel interface for that application.
>> 
>> I do't understand this statement, this application is just useing the 
>> standard kernel interfaces (block devices to read/write to disk, network 
>> devices to read/write to a server, etc). no new interfaces needed.

> Yes, but it will have to know _what_ to save, no?

I agree that a kernel interface would be important; something like
/dev/snapshot that can be read by the "save image" kernel, and written
to by the "restore image" kernel.  Note that similarly, kdump provides a
kernel interface to an ELF image of the old kernel.

> Plus we need to figure out how to avoid corrupting filesystems and swap in use
> by the "old" kernel and its processes (hint: a separate "hibernation partition"
> is a no-go).

Presumably swapoff would take care of freeing up a swap partition for
saving the image.  (It seems that this is the most common hibernate
method, anyway.)  If the user wants to write to a file, like a swap
file, then the old kernel would need to somehow communicate the sequence
of blocks in the file to the "save image" kernel.  Perhaps support for
this method of saving the image need not be available initially.

[snip]

> I think it's most portable to use initrd for that, which already makes things
> complicated.  Then, we'll have to load the image and jump to the hibernated
> kernel in such a way that it would be able to continue from where it stopped
> before.  I don't think that is trivial.

As we've discussed before, I think the resume from hibernate can be done
essentially exactly as it is done currently; it may likely be possible
to reuse the uswsusp kernel code for this purpose.

>> >> 6. Reduce the boot-up time of kexec kernel. Maybe the kexec kernel can
>> >> be hibernate/resume by the normal kernel too. This way, a real
>> >> kexec/boot-up is only needed for the first time.
>> >
>> > I'm not sure what you mean.
>> 
>> he's trying to get fancy again, the best way to speed up the boot of the 
>> kexec kernel is make it smaller and avoid probing for devices (hotplug 
>> should NOT be used for normal suspend situations)

> Still, I believe that we should do our best to use only one kernel (meaning one
> kernel image) here.

It seems that it is not very difficult to make the choice of using a
different kernel or not one that the user can make.  The only extra
thing required to allow a different kernel to be used is to save and
restore the text sections.

-- 
Jeremy Maitin-Shepard
