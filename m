Return-Path: <linux-kernel-owner+w=401wt.eu-S1759574AbXGLT1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759574AbXGLT1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 15:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754692AbXGLT1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 15:27:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56535 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476AbXGLT07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 15:26:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: david@lang.hm
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
Date: Thu, 12 Jul 2007 21:34:28 +0200
User-Agent: KMail/1.9.5
Cc: "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <1184167831.12556.13.camel@caritas-dev.intel.com> <200707121453.49616.rjw@sisk.pl> <Pine.LNX.4.64.0707121150460.25614@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0707121150460.25614@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707122134.29991.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 12 July 2007 20:57, david@lang.hm wrote:
> On Thu, 12 Jul 2007, Rafael J. Wysocki wrote:
> 
> >>> I didn't understand the ACPI problem.  Does this mean that CONFIG_ACPI must
> >>> be disabled in the to-be-hibernated kernel, or in the little transient
> >>> kexec kernel?
> >>
> >> Under current implementation of device state quiescent/save/restore, the
> >> CONFIG_ACPI must be turned off both in to-be-hibernated kernel and
> >> transient kexec kernel.
> >>
> >> But the hibernation people are going to separate the device suspend from
> >> device hibernate. The device hibernate will put device in quiescent
> >> state but not in low power state. When this is done, it is not necessary
> >> to disable CONFIG_ACPI at all. It is just a workaround for current
> >> implementation that disabling CONFIG_ACPI.
> >>
> >>> How close do you think all this is to being a viable thing?
> >>
> >> The kexec jump is the first step, maybe the simplest step. There are
> >> many other issues to be resolved, at least the following ones.
> >>
> >> 1. Separate device suspend from device hibernate.
> >
> > Step 0, I'd say. :-)
> 
> is there more involved then just start ignoreing device hibernate and just 
> useing the device suspend? (although if there is not a workable device 
> suspend for a driver, that would answer my question :-)

There's more to it, though.  If devices are suspended, the hibernation kernel
will have to resume them (using platform, like ACPI, callbacks in the process)
instead and that will get complicated.

It's better if devices are quiesced, or even shut down, before we call the
hibernation kernel.

> >> 2. Do not reserve memory for kexec kernel. That is, backup needed memory
> >> before kexec and restore them after kexec.
> >
> > I don't think this is very important initially.
> 
> I agree, a stipped down hibernate kernel can be very small, not allocating 
> this memory until it's needed is a step for the final polishing.

I'm not sure if I agree with that.  In any case, having to use two different
kernels for hibernation would be a big drawback.

> >> 3. Support the in-place kexec? The relocatable kernel is not necessary
> >> if this can be implemented.
> >> 4. Image writing/reading. (Only user space application is needed).
> >
> > And a kernel interface for that application.
> 
> I do't understand this statement, this application is just useing the 
> standard kernel interfaces (block devices to read/write to disk, network 
> devices to read/write to a server, etc). no new interfaces needed.

Yes, but it will have to know _what_ to save, no?

Plus we need to figure out how to avoid corrupting filesystems and swap in use
by the "old" kernel and its processes (hint: a separate "hibernation partition"
is a no-go).

> >> 5. A smooth resume process. Maybe it is not needed to kexec a new kernel
> >> for resume. For example, in the first stage of kernel boot, just first
> >> 16M (or a little more) RAM is used, if the resume image is found, the
> >> saved kernel image is resumed; if the resume image is not found, turn on
> >> the remaining RAM. This will depends on 3.
> >
> > I think that this is the most difficult part of the whole thing.
> 
> don't try to get too fancy right now. stick with a simple 'boot hibernate 
> kernel, it's userspace looks for an image to resume, and if it doesn't 
> find one reboot to the normal system'
> 
> I don't know how to do this with grub, but it would be a trivial shell 
> script with lilo

I think it's most portable to use initrd for that, which already makes things
complicated.  Then, we'll have to load the image and jump to the hibernated
kernel in such a way that it would be able to continue from where it stopped
before.  I don't think that is trivial.

> >> 6. Reduce the boot-up time of kexec kernel. Maybe the kexec kernel can
> >> be hibernate/resume by the normal kernel too. This way, a real
> >> kexec/boot-up is only needed for the first time.
> >
> > I'm not sure what you mean.
> 
> he's trying to get fancy again, the best way to speed up the boot of the 
> kexec kernel is make it smaller and avoid probing for devices (hotplug 
> should NOT be used for normal suspend situations)

Still, I believe that we should do our best to use only one kernel (meaning one
kernel image) here.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
