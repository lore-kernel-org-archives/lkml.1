Return-Path: <linux-kernel-owner+w=401wt.eu-S934898AbXGQUbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934898AbXGQUbN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 16:31:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757961AbXGQU3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 16:29:54 -0400
Received: from rwcrmhc13.comcast.net ([216.148.227.153]:36663 "EHLO
	rwcrmhc13.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932932AbXGQU3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 16:29:52 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Jul 2007 16:29:52 EDT
From: Jeremy Maitin-Shepard <jbms@cmu.edu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: david@lang.hm, Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang\, Ying" <ying.huang@intel.com>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Al Boldi <a1426z@gawab.com>
Subject: Re: Hibernation considerations
References: <Pine.LNX.4.44L0.0707171010490.3551-100000@iolanthe.rowland.org>
	<200707171802.30903.rjw@sisk.pl>
	<Pine.LNX.4.64.0707170959160.2467@asgard.lang.hm>
	<200707172150.44417.rjw@sisk.pl>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Tue, 17 Jul 2007 16:24:29 -0400
In-Reply-To: <200707172150.44417.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Tue\, 17 Jul 2007 21\:50\:42 +0200")
Message-ID: <87sl7mg4n6.fsf@jbms.ath.cx>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

[snip]

> Well, first, the fact is that _some_ systems _will_ be powered while in
> hibernation (the majority of notebooks, for example) and you should assume
> that the platform _may_ retain some information accross the hibernation/restore
> cycle.  In that case you _should_ _not_ trash the information retained by the
> platform.

I'm not sure the majority of notebook users will want wakeup support in
exchange for some power consumption while the system is off.  I think
many people would not consider the trouble of having to press the power
button instead of merely opening the lid too great.

Furthermore, S4 mode is of course also not suitable if you intend to
replace the battery while the system is hibernated.

It does seem that it is useful to provide S4 as an option, but certainly
just shutting down should also be an option on all systems.

> Now, with that in mind, ACPI requires us to make the system enter the S4 sleep
> state as a result of the hibernation procedure.  In my opinion this may be done
> after saving the image, but still this means, for example, that the
> image-saving kernel needs to support ACPI.

It seems that it most certainly must be done AFTER saving the image, as
the image obviously cannot be saved after entering S4 state, since S4
state is nearly the same as powering off completely and all memory will
be lost.

> Next, during the restore, we should first check if the image is present (and
> valid) _without_ turning ACPI on (note that this is not done by the current
> hibernation code and that leads to strange problems on some systems).  Then,
> if the image is present (and valid), we should first load it, jump to the
> hibernated kernel and _then_ turn ACPI on and execute the _BFS and
> _WAK ACPI global methods (again, this is not done by the current code in that
> order, which is wrong).  Only after that is the hibernated kernel supposed to
> continue.

It seems that the implementation of that behavior for Linux cannot be
quite so simple, since resume from hibernation is driven (in general)
from an initrd/initramfs rather than directly from the kernel
initialization sequence, in order to support modular drivers and
features like DM and LVM.

Thus, there would have to be a new "delay_acpi_initialization" kernel
command-line option.  Additionally, there would be a sysfs interface to
tell the kernel to proceed with the ACPI initialization as normal.  This
would be used by an initrd/initramfs after determining that a resume
from hibernate will not be done.  If a resume from hibernate is done,
this hook won't be used, and instead the resumed kernel will call the
ACPI hibernate resume stuff if S4 state was used; otherwise, the resumed
kernel will just re-initialize ACPI as normal.  Also, if the in-kernel
code for checking if a resume can be done does not find a hibernate
image, it will also invoke the delayed ACPI initialization.

-- 
Jeremy Maitin-Shepard
