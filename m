Return-Path: <linux-kernel-owner+w=401wt.eu-S1762565AbXGMQuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762565AbXGMQuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 12:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933876AbXGMQsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 12:48:41 -0400
Received: from sccrmhc12.comcast.net ([204.127.200.82]:59237 "EHLO
	sccrmhc12.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933704AbXGMQsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 12:48:39 -0400
From: Jeremy Maitin-Shepard <jbms@cmu.edu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: david@lang.hm, "Huang\, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
References: <1184167831.12556.13.camel@caritas-dev.intel.com>
	<200707131359.53309.rjw@sisk.pl> <87abu01gnv.fsf@jbms.ath.cx>
	<200707131745.43055.rjw@sisk.pl>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Fri, 13 Jul 2007 12:48:36 -0400
In-Reply-To: <200707131745.43055.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Fri\, 13 Jul 2007 17\:45\:41 +0200")
Message-ID: <87644o1c7v.fsf@jbms.ath.cx>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

[snip]

> Okay, I have thought it through and I think that, as an initial step, we can do
> something like this:

> - preload the image-saving kernel before hibernation
> - in the hibernation code path replace device_suspend() with the shutting down
> of
>   all devices without unregistering them (not very nice, but should be
> sufficient
>   for a while)

It seems that the effect of what is done by the current hibernate
implementations is to shutdown all of the devices, but according to
kernel data structures, have it look like the devices were merely
suspended (i.e. device_suspend).  Then in the resume path, the "restore
image" kernel also calls device_suspend just before jumping to the
hibernated kernel, so all of the devices the "restore image" kernel knew
about are in the state device_suspend expects them to be in, except that
they were actually suspended by a different kernel, so they might not be
in quite the right state.  There is also the issue that the "restore
image" kernel might not know about all of the devices; for instance, if
USB support is modular, and, as is likely to be the case, the user
didn't load the USB modules in the "restore image" kernel from an initrd
or something, then the USB devices will actually be powered off, rather
than "suspended".  Despite these apparent discrepancies, it seems that
for many devices (I'm not sure USB devices are included, though),
device_restore happens to do the right thing so that the device is
placed back in the state it needs to be so that the driver can begin
talking to it as it did before, and the device is recognized as the same
device as was there before (since otherwise mounted filesystems backed
by block devices that came back as a different device would cause great
havoc).

Since I recall there being issues with USB devices being recognized as
the same devices post-hibernate-resume, without looking at the code I'm
inclined to believe that the USB drivers still don't end up resuming
from hibernate correctly.

Note that I am describing what is done currently, not what is planned to
be done (i.e. change device_suspend to quiesce and device_resume to
unquiesce).  It seems that ironically, despite everyone believing that
device_suspend/device_resume is incorrect for hibernate, many of the
things that those functions do (like saving the PCI configuration,
perhaps, and then restoring it later, or re-initializing the device) are
actually necessary, especially for modular drivers that won't be loaded
by the "restore image" kernel.

What needs to be done is for the devices to be shut down (or possibly
just quiesced for a select few, but we won't worry about that
complication until later; in the case of the current implementations,
they should all be quiesced rather than shut down), but whatever
information that will be needed later to reinitialize the device
(ideally the reinitialization should be able to handle the device either
being in a quiesced state or completely off) and recognize it as the
same device must be saved.  This probably means they cannot be
"unregistered", as otherwise there would be nothing with which to
associate the saved information.

The resume path needs to use the saved state to reinitialize the device
and recognize it as the same device.  It seems that the existing
reprobing code may not be sufficient for this.  Note that exactly the
same thing must be done on resume for both the current hibernate
implementations and the kexec approach.  It seems that properly
restoring the devices should be relatively easy for the devices that
already get this correct, like IDE devices and basic PCI devices (and
SATA and SCSI devices as well perhaps?), and possibly harder for
Firewire or USB devices.

> - when we've called device_power_down() and save_processor_state(), jump to
>   the image-saving kernel and let it run
> - make the image-saving kernel set up everything, save the image without
>   starting any user space (we may use the existing image-saving code for this
>   purpose, with some modifications) and power off the system (or make it enter
>   S4)

I suppose this has the advantage of not requiring that a
kernel-to-userspace interface be created for this purpose.

> - use the existing restoration code to load the image and jump to the
>   hibernated kernel

This would again avoid the need for a separate userspace-kernelspace
interface for the purpose, so I agree it could be a useful thing to do
initially.

> - in the restore code patch replace device_resume() with the reprobing of all
>   devices.

See my comments above.

-- 
Jeremy Maitin-Shepard
