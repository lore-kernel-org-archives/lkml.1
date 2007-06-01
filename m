Return-Path: <linux-kernel-owner+w=401wt.eu-S1762078AbXFAVdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762078AbXFAVdl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 17:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751504AbXFAVdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 17:33:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57710 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157AbXFAVde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 17:33:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeremy Maitin-Shepard <jbms@cmu.edu>
Subject: Re: A kexec approach to hibernation
Date: Fri, 1 Jun 2007 23:39:05 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>
References: <878xb3l888.fsf@jbms.ath.cx>
In-Reply-To: <878xb3l888.fsf@jbms.ath.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706012339.06379.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 1 June 2007 22:39, Jeremy Maitin-Shepard wrote:
> I figured I'd throw this idea out, since although it is not perfect, it
> has the potential to elegantly solve a lot of issues with hibernate.
> 
> Just as kexec can now be used to write a crashdump after a kernel panic,
> a fresh kexec-loaded kernel (loaded into unused memory) could be used to
> write the hibernate image of the existing kernel to disk, and then power
> off the system (or suspend to ram, or anything else).  This avoids the
> need for the original kernel to jump through hoops to hibernate itself
> in place.
> 
> A hibernate sequence would be approximately as follows:
>  
>  1. Free some memory if needed or desired, and disable the swap device
>     if it is going to be used to write the hibernate image.

Why to disable it?

>  2. Load the fresh kernel in a chunk of available (possibly
>     pre-allocated) memory (there must also be enough available memory
>     for this kernel to use).
> 
>  3. Disable interrupts and stop all devices.

Well, this is one of the hardest parts of hibernation, so no advantage here.

>  4. Jump to the new kernel, passing whatever state information will be
>     needed by it to know how to write the image.

How would we know which data to write (more precisely, which data to tell
the other kernel to write)?  How do we pass this information to the new kernel?
 
>  5. The new kernel loads, and then either kernel space or user space
>      writes the necessary data from the old kernel to disk.

You also need to reinitialize devices needed to write the image.

>  6. The new kernel either powers off or suspends to ram.  If it suspends
>     to ram, then it would need to be able to jump back to the old kernel
>     when it resumes from ram.

What if the user wants to abort the hibernation?

> The advantages of this approach include:
> 
>  - having a completely functional system (with a completely functional
>    userspace) from which the image is written, without having to worry
>    about messing up the state that is being saved (hell, the user could
>    even do it via an interactive shell on the new kernel);
> 
>  - no need to worry about trying to use drivers while some processes are
>    frozen;

We're rather worried about running processes when the devices are frozen. ;-)

>  - no need for complicated process freezing;

In fact it's not complicated, at least as far as the user land is concerned.

>  the same logic that can be used for suspend to ram should be sufficient;
> 
>  - no need for an atomic copy of memory, or any other complicated memory
>    copying; the memory of the old kernel, including the page cache, can
>    be written directly;
> 
>  - instead of needing a significant amount of free memory to store the
>    atomic copy, only a few megabytes would needed to load and run the
>    new kernel.

Yes, this sounds good in theory.

> It may or may not be necessary to require that the new kernel used to
> write the image is the same as the existing kernel; it will likely be
> useful to require that it is built from the same sources and with a
> similar config.  It would likely be useful, however, to either compile
> out or (e.g. via the kernel command-line) disable the initialization of
> drivers that will not be needed to write the image, such as sound
> drivers, cdrom drivers, filesystems, and network drivers (if the image
> is not to be written via the network).

I think that, for average users, this would be difficult.

> Of course, if special initialization was needed under the original
> kernel to set up the devices that will be used to write the image, such
> as device mapper setup, or network initialization, that will have to be
> repeated under the new kernel as well.  This is the principal
> disadvantage to this approach, but since it must be done during resume
> from hibernation in any case, it doesn't seem like a very significant
> disadvantage.  The other disadvantage is that there would be the
> delay of loading the fresh kernel; this may, however, only take a second
> or two, which is relatively insignificant compared to the time required
> to actually write the image, and the delay could be reduced by stripping
> out unnecessary drivers from the image-writing kernel.

One more thing: How do we restore the system state?

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
