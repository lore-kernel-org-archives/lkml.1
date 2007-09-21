Return-Path: <linux-kernel-owner+w=401wt.eu-S1762129AbXIUSrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762129AbXIUSrf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 14:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762036AbXIUSrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 14:47:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43900 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761999AbXIUSrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 14:47:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeremy Maitin-Shepard <jbms@cmu.edu>
Subject: Re: [linux-pm] Re: [RFC][PATCH 1/2 -mm] kexec based hibernation -v3: kexec jump
Date: Fri, 21 Sep 2007 21:00:09 +0200
User-Agent: KMail/1.9.5
Cc: "huang ying" <huang.ying.caritas@gmail.com>,
       linux-pm@lists.linux-foundation.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Nigel Cunningham" <nigel@nigel.suspend2.net>, nigel@suspend2.net,
       "Kexec Mailing List" <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org, "Huang\, Ying" <ying.huang@intel.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Len Brown" <lenb@kernel.org>
References: <1190266447.21818.17.camel@caritas-dev.intel.com> <200709211631.19130.rjw@sisk.pl> <87sl576g8q.fsf@jbms.ath.cx>
In-Reply-To: <87sl576g8q.fsf@jbms.ath.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709212100.11050.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 21 September 2007 20:11, Jeremy Maitin-Shepard wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > On Friday, 21 September 2007 15:14, huang ying wrote:
> >> On 9/21/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> > On Friday, 21 September 2007 05:33, Eric W. Biederman wrote:
> >> > > Nigel Cunningham <nigel@nigel.suspend2.net> writes:
> > [--snip--]
> >> > >
> >> > > No one has yet attacked the hard problem of coming up with separate
> >> > > hibernate methods for drivers.
> >> >
> >> > Well, I've been playing a bit with that for some time, but it's not easy by
> > any
> >> > means.
> >> >
> >> > In short, I'm seeing some problems related to the handling of ACPI that seem
> > to
> >> > shatter the entire idea of having separate hibernate methods, at least as
> > far
> >> > as ACPI systems are concerned.
> >> 
> >> So sadly to hear this. Can you details it a little? Or a link?
> 
> > Well, the problem is that apparently some systems (eg. my HP nx6325) expect us
> > to execute the _PTS ACPI global control method before creating the image _and_
> > to execute acpi_enter_sleep_state(ACPI_STATE_S4) in order to finally put the
> > system into the sleep state.  In particular, on nx6325, if we don't do that,
> > then after the restore the status of the AC power will not be reported
> > correctly (and if you replace the battery while in the sleep state, the
> > battery status will not be updated correctly after the restore).  Similar
> > issues have been reported for other machines.
> 
> Suppose that instead of using ACPI S4 state at all, you instead just
> power off.  Yes, you'll lose wakeup event functionality, and flashy
> LEDs, but doesn't this take care of the problem?

Nope.

> The firmware shouldn't see the hibernate as anything other than a shutdown
> and reboot.

Actually, this assumption is apparently wrong.

> ACPI should be initialized normally when resuming, which should take care of
> getting AC power status reported properly.

Well, that doesn't work.  I've tested it, really. :-)

> This should be the behavior, anyway, on the many systems that do not
> support S4.
> 
> > Now, the ACPI specification requires us to put devices into low power states
> > before executing _PTS and that's exactly what we're doing before a suspend to
> > RAM.  Thus, it seems that in general we need to do the same for hibernation on
> > ACPI systems.
> 
> It seems that if ACPI S4 is going to be used, Switching to low power
> state is something that should be done only immediately before entering
> that state (i.e. after the image has already been saved).

Doesn't.  Work.

> In particular, it should not be done just before the atomic copy.  It is
> true that (during resume) after the atomic copy snapshot is restored,
> drivers will need to be prepared (i.e. have saved whatever information
> is necessary) to _resume_ devices from the low power state, but that
> does not mean they have to actually be put into that low power state
> before the copy is made.
> 
> I agree that for the kexec implementation there may be additional
> issues.  For swsusp, uswsusp, and tuxonice, though, I don't see why
> there should be a problem.  I think that, as was recognized before, all
> of the issues are resolved by properly considering exactly what each
> callback should do and when it should be called.  The problems stem from
> ambiguous specifications, or trying to use the same callback for two
> different purposes or in two different cases.
> 
> Let me know if I'm mistaken.

See above. :-)

Greetings,
Rafael
