Return-Path: <linux-kernel-owner+w=401wt.eu-S935747AbXGMPMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935747AbXGMPMx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 11:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932567AbXGMPMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 11:12:41 -0400
Received: from rwcrmhc14.comcast.net ([216.148.227.154]:54003 "EHLO
	rwcrmhc14.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932867AbXGMPMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 11:12:40 -0400
From: Jeremy Maitin-Shepard <jbms@cmu.edu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: david@lang.hm, "Huang\, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
References: <1184167831.12556.13.camel@caritas-dev.intel.com>
	<200707131129.34974.rjw@sisk.pl>
	<Pine.LNX.4.64.0707130227310.25614@asgard.lang.hm>
	<200707131359.53309.rjw@sisk.pl>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Fri, 13 Jul 2007 11:12:36 -0400
Message-ID: <87abu01gnv.fsf@jbms.ath.cx>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

[snip]

> Not necessarily.  If we don't put devices into low power states before creating
> the image, that should work just fine (quiesce devices, create the image or
> kexec the new kernel, reprobe devices, save the image, suspend to RAM,
> resume from RAM, continue - or restore from the image if power failed in the
> meantime).  Still, for this purpose, both kernels need to be able to handle the
> same set of devices.

I don't know much about the suspend to RAM, but it seems that it would
indeed be necessary to have a device driver for a device in order to
switch it from e.g. a quiesced state to a low power state.  If, however,
the original kernel already completely turned off the device, then it
seems that the "save image" kernel shouldn't have to do anything to it
in order to suspend to RAM.  The drawback, though, is that since the old
kernel would have no way (unless the user tells it) to know which
devices should be left quiesced and which should be turned off, it would
have to turn them all off, which would mean spinning up and down the
disks.

On the other hand, being able to build the "save image" kernel with only
minimal hardware support could save a significant amount of the time
required to boot it.

[snip]

> No, it can't.  For example, it can't access filesystems mounted by the
> hibernated kernel, or they may get corrupted after the restore (if they are
> journaling, it can't even read from them).

That is true, but this also holds for the current hibernate
implementations.

> Which reminds me of one more issue, which is that the image-saving kernel
> won't be able to use these filesystems either, so its modules and user space
> will have to be available from somewhere else (like a RAM disk or dedicated
> partition).  So things get ugly.

This is not the issue that it appears to be, though.  Under the current
hibernate implementations, this very same userspace and set of modules
must be available "somewhere else" (i.e. an initrd) because it is needed
by the restore path.  Note that under the kexec approach, save and
restore become rather symmetric operations.

> Apart from this, the new kernel's user space cannot blindly modify swap space
> that might be in use by the hibernated kernel.

But it seems easy enough to swapoff in order to completely free up the
swap space.  I suppose the disadvantage is that instead of failing
cleanly if there is insufficient memory, the OOM killer will be invoked
and cause all sorts of havoc.  This suggests that it may indeed be
important to support "cooperation" with the old kernel on saving the
image sooner, rather than later.

[snip]

-- 
Jeremy Maitin-Shepard
