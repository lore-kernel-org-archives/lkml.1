Return-Path: <linux-kernel-owner+w=401wt.eu-S1762310AbXIUSu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762310AbXIUSu6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 14:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760388AbXIUSuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 14:50:51 -0400
Received: from SMTP.andrew.cmu.edu ([128.2.10.212]:56714 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903AbXIUSut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 14:50:49 -0400
X-Greylist: delayed 2301 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Sep 2007 14:50:49 EDT
From: Jeremy Maitin-Shepard <jbms@cmu.edu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "huang ying" <huang.ying.caritas@gmail.com>,
       linux-pm@lists.linux-foundation.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Nigel Cunningham" <nigel@nigel.suspend2.net>, nigel@suspend2.net,
       "Kexec Mailing List" <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org, "Huang\, Ying" <ying.huang@intel.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Len Brown" <lenb@kernel.org>
Subject: Re: [linux-pm] Re: [RFC][PATCH 1/2 -mm] kexec based hibernation -v3: kexec jump
References: <1190266447.21818.17.camel@caritas-dev.intel.com>
	<200709211409.25008.rjw@sisk.pl>
	<851fc09e0709210614q33cf3c81u1441fda17a66a6fd@mail.gmail.com>
	<200709211631.19130.rjw@sisk.pl>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Fri, 21 Sep 2007 14:11:17 -0400
In-Reply-To: <200709211631.19130.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Fri\, 21 Sep 2007 16\:31\:18 +0200")
Message-ID: <87sl576g8q.fsf@jbms.ath.cx>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Friday, 21 September 2007 15:14, huang ying wrote:
>> On 9/21/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > On Friday, 21 September 2007 05:33, Eric W. Biederman wrote:
>> > > Nigel Cunningham <nigel@nigel.suspend2.net> writes:
> [--snip--]
>> > >
>> > > No one has yet attacked the hard problem of coming up with separate
>> > > hibernate methods for drivers.
>> >
>> > Well, I've been playing a bit with that for some time, but it's not easy by
> any
>> > means.
>> >
>> > In short, I'm seeing some problems related to the handling of ACPI that seem
> to
>> > shatter the entire idea of having separate hibernate methods, at least as
> far
>> > as ACPI systems are concerned.
>> 
>> So sadly to hear this. Can you details it a little? Or a link?

> Well, the problem is that apparently some systems (eg. my HP nx6325) expect us
> to execute the _PTS ACPI global control method before creating the image _and_
> to execute acpi_enter_sleep_state(ACPI_STATE_S4) in order to finally put the
> system into the sleep state.  In particular, on nx6325, if we don't do that,
> then after the restore the status of the AC power will not be reported
> correctly (and if you replace the battery while in the sleep state, the
> battery status will not be updated correctly after the restore).  Similar
> issues have been reported for other machines.

Suppose that instead of using ACPI S4 state at all, you instead just
power off.  Yes, you'll lose wakeup event functionality, and flashy
LEDs, but doesn't this take care of the problem?  The firmware shouldn't
see the hibernate as anything other than a shutdown and reboot.  ACPI
should be initialized normally when resuming, which should take care of
getting AC power status reported properly.

This should be the behavior, anyway, on the many systems that do not
support S4.

> Now, the ACPI specification requires us to put devices into low power states
> before executing _PTS and that's exactly what we're doing before a suspend to
> RAM.  Thus, it seems that in general we need to do the same for hibernation on
> ACPI systems.

It seems that if ACPI S4 is going to be used, Switching to low power
state is something that should be done only immediately before entering
that state (i.e. after the image has already been saved).  In
particular, it should not be done just before the atomic copy.  It is
true that (during resume) after the atomic copy snapshot is restored,
drivers will need to be prepared (i.e. have saved whatever information
is necessary) to _resume_ devices from the low power state, but that
does not mean they have to actually be put into that low power state
before the copy is made.

I agree that for the kexec implementation there may be additional
issues.  For swsusp, uswsusp, and tuxonice, though, I don't see why
there should be a problem.  I think that, as was recognized before, all
of the issues are resolved by properly considering exactly what each
callback should do and when it should be called.  The problems stem from
ambiguous specifications, or trying to use the same callback for two
different purposes or in two different cases.

Let me know if I'm mistaken.

-- 
Jeremy Maitin-Shepard
