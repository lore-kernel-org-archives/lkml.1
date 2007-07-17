Return-Path: <linux-kernel-owner+w=401wt.eu-S1765934AbXGQUf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765934AbXGQUf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 16:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761804AbXGQUfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 16:35:24 -0400
Received: from sccrmhc15.comcast.net ([63.240.77.85]:46315 "EHLO
	sccrmhc15.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbXGQUfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 16:35:17 -0400
From: Jeremy Maitin-Shepard <jbms@cmu.edu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>, david@lang.hm,
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
References: <Pine.LNX.4.44L0.0707171416120.3728-100000@iolanthe.rowland.org>
	<200707172217.01890.rjw@sisk.pl>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Tue, 17 Jul 2007 16:34:57 -0400
In-Reply-To: <200707172217.01890.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Tue\, 17 Jul 2007 22\:17\:00 +0200")
Message-ID: <87odiag45q.fsf@jbms.ath.cx>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

[snip]

>> Rafael, for those of us who aren't thoroughly familiar with all the ins
>> and outs of the ACPI spec, could you please summarize a list of the
>> ACPI calls needed in the second and third cases above?  Indicate which
>> ones need to be done from within the original kernel and which should
>> be done from within a kexec'd hibernation kernel.

> Sure.

> In the third case (ie. transition to S4) we are supposed to do the following:

> (1) Upon entering the sleep state, which IMO can be done _after_ the image
>     has been saved:

I assume you mean "in order to enter the sleep state", rather than "upon
entering the sleep state".  I still don't understand what you mean by
"which IMO can be done _after_ the image has been saved"; as far as I
understand, the last step of this process, "make the platform enter S4",
is almost like a shutdown as far as the kernel is concerned (except for
the tiny detail of having to call those special ACPI methods on resume);
consequently, it would seem that nothing can be done after that step.

>   * figure out which devices can wake up
>   * put devices into low power states (wake-up devices are placed in the Dx
>     states compatible with the wake capability, the others are powered off)
>   * execute the _PTS global control method
>   * switch off the nonlocal CPUs (eg. nonboot CPUs on x86)
>   * execute the _GTS global control method
>   * set the GPE enable registers corresponding to the wake-up devices)
>   * make the platform enter S4 (there's a well defined procedure for that)
>   I think that this should be done by the image-saving kernel.

I agree.

> (2) Upon start-up (by which I mean what happens after the user has pressed
>     the power button or something like that):
>   * check if the image is present (and valid) _without_ enabling ACPI (we don't
>     do that now, but I see no reason for not doing it in the new framework)
>   * if the image is present (and valid), load it
>   * turn on ACPI (unless already turned on by the BIOS, that is)
>   * execute the _BFS global control method
>   * execute the _WAK global control method
>   * continue
>   Here, the first two things should be done by the image-loading kernel, but
>   the remaining operations have to be carried out by the restored
>     kernel.

It doesn't seem like a problem for that to be the case, but out of
curiosity why do those methods need to be executed by the "restored"
kernel, rather than the "image loading" kernel.  Do they require some
information from ACPI-related kernel data structures that were populated
by the normal ACPI initialization?

[snip]

> ... we can't return to the hibernated kernel unless we are going to cancel the
> hibernation.

I agree.

> That's why I think that for the suspend-to-both the image-saving kernel will
> need to support the same set of devices as the hibernated kernel.

If all of the devices that the image writing kernel doesn't know about
have already been shut down/powered off by the hibernated kernel, then
does the "image writing" kernel still need to know about them in order
to suspend to RAM properly (i.e. without leaving some devices on wasting
power)?

-- 
Jeremy Maitin-Shepard
