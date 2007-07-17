Return-Path: <linux-kernel-owner+w=401wt.eu-S933064AbXGQQKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933064AbXGQQKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 12:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754493AbXGQQKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 12:10:04 -0400
Received: from alnrmhc14.comcast.net ([206.18.177.54]:53026 "EHLO
	alnrmhc14.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831AbXGQQKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 12:10:02 -0400
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
References: <Pine.LNX.4.44L0.0707171010490.3551-100000@iolanthe.rowland.org>
	<200707171640.39955.rjw@sisk.pl>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Tue, 17 Jul 2007 12:09:58 -0400
In-Reply-To: <200707171640.39955.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Tue\, 17 Jul 2007 16\:40\:38 +0200")
Message-ID: <87hco3ypt5.fsf@jbms.ath.cx>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

[snip]

> I'm afraid of one thing, though.

> If we create a framework without ACPI (well, ACPI needs to be enabled in the
> kernel anyway for other reasons, like the ability to suspend to RAM) and then
> it turns out that we have to add some ACPI hooks to it, that might be difficult
> to do cleanly.

> Thus, it seems reasonable to think of the ACPI handling in advance.

As far as I understand, ACPI support is only useful for hibernate to the
extent that it allows some or all of the following features:

 - possibly shows a nice looking "hibernate" LED
 - possibly allows the BIOS to show something about hibernate
 - possibly allows the lid or keyboard to "wake up" (turn on) the system

Note that properly restoring device state (or even properly determining
whether on external/mains power vs. battery) on resume is not something
that should require special hibernate ACPI support, since it should be
possible to make hibernate (and in general it will be the case that
hibernate will) look exactly like a reboot to the BIOS/ACPI/devices.
The problem that you mentioned on your system regarding power source
information would seem to just be a problem with how ACPI is
reinitialized after resuming from hibernation, which is not at all
surprising since we know it (the use of driver calls for hibernate) is
currently broken in many ways.

It seems that enabling S4 mode should just be treated as a special
shutdown mode, independent of hibernate.  In practice, it may likely
only be useful in conjunction with hibernate, but there doesn't seem to
be any reason it needs to be coupled.

It would be useful to determine whether it is necessary to initialize
ACPI specially after "resuming" from S4 mode, though, or whether they
can be initialized normally (i.e. by a normal kernel for instance,
completely unaware of hibernate).  If they can be initialized normally,
then it seems that it is unnecessary to have any ACPI S4 mode support in
the resume path, and it can merely exist as a special shutdown mode.
Note that it seems a bit odd if ACPI can't be initialized normally after
resume from S4 (and still work), since the "load image" kernel
initializes everything normally before attempting to resume the
hibernated system.

-- 
Jeremy Maitin-Shepard
