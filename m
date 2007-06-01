Return-Path: <linux-kernel-owner+w=401wt.eu-S1764292AbXFAUp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764292AbXFAUp3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 16:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762874AbXFAUpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 16:45:12 -0400
Received: from alnrmhc12.comcast.net ([206.18.177.52]:43005 "EHLO
	alnrmhc12.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762465AbXFAUpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 16:45:09 -0400
From: Jeremy Maitin-Shepard <jbms@cmu.edu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@osdl.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>
Cc: suspend2-devel@lists.suspend2.net
Subject: A kexec approach to hibernation
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Fri, 01 Jun 2007 16:39:51 -0400
Message-ID: <878xb3l888.fsf@jbms.ath.cx>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I figured I'd throw this idea out, since although it is not perfect, it
has the potential to elegantly solve a lot of issues with hibernate.

Just as kexec can now be used to write a crashdump after a kernel panic,
a fresh kexec-loaded kernel (loaded into unused memory) could be used to
write the hibernate image of the existing kernel to disk, and then power
off the system (or suspend to ram, or anything else).  This avoids the
need for the original kernel to jump through hoops to hibernate itself
in place.

A hibernate sequence would be approximately as follows:
 
 1. Free some memory if needed or desired, and disable the swap device
    if it is going to be used to write the hibernate image.

 2. Load the fresh kernel in a chunk of available (possibly
    pre-allocated) memory (there must also be enough available memory
    for this kernel to use).

 3. Disable interrupts and stop all devices.

 4. Jump to the new kernel, passing whatever state information will be
    needed by it to know how to write the image.

 5. The new kernel loads, and then either kernel space or user space
     writes the necessary data from the old kernel to disk.

 6. The new kernel either powers off or suspends to ram.  If it suspends
    to ram, then it would need to be able to jump back to the old kernel
    when it resumes from ram.

The advantages of this approach include:

 - having a completely functional system (with a completely functional
   userspace) from which the image is written, without having to worry
   about messing up the state that is being saved (hell, the user could
   even do it via an interactive shell on the new kernel);

 - no need to worry about trying to use drivers while some processes are
   frozen;

 - no need for complicated process freezing; the same logic that can be
   used for suspend to ram should be sufficient;

 - no need for an atomic copy of memory, or any other complicated memory
   copying; the memory of the old kernel, including the page cache, can
   be written directly;

 - instead of needing a significant amount of free memory to store the
   atomic copy, only a few megabytes would needed to load and run the
   new kernel.

It may or may not be necessary to require that the new kernel used to
write the image is the same as the existing kernel; it will likely be
useful to require that it is built from the same sources and with a
similar config.  It would likely be useful, however, to either compile
out or (e.g. via the kernel command-line) disable the initialization of
drivers that will not be needed to write the image, such as sound
drivers, cdrom drivers, filesystems, and network drivers (if the image
is not to be written via the network).

Of course, if special initialization was needed under the original
kernel to set up the devices that will be used to write the image, such
as device mapper setup, or network initialization, that will have to be
repeated under the new kernel as well.  This is the principal
disadvantage to this approach, but since it must be done during resume
from hibernation in any case, it doesn't seem like a very significant
disadvantage.  The other disadvantage is that there would be the
delay of loading the fresh kernel; this may, however, only take a second
or two, which is relatively insignificant compared to the time required
to actually write the image, and the delay could be reduced by stripping
out unnecessary drivers from the image-writing kernel.

-- 
Jeremy Maitin-Shepard
