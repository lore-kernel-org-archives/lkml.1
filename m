Return-Path: <linux-kernel-owner+w=401wt.eu-S936547AbXGQVDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936547AbXGQVDo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 17:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754185AbXGQVDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 17:03:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50312 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753249AbXGQVDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 17:03:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeremy Maitin-Shepard <jbms@cmu.edu>
Subject: Re: Hibernation considerations
Date: Tue, 17 Jul 2007 23:11:13 +0200
User-Agent: KMail/1.9.5
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
References: <Pine.LNX.4.44L0.0707171416120.3728-100000@iolanthe.rowland.org> <200707172217.01890.rjw@sisk.pl> <87odiag45q.fsf@jbms.ath.cx>
In-Reply-To: <87odiag45q.fsf@jbms.ath.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707172311.14721.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 17 July 2007 22:34, Jeremy Maitin-Shepard wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> [snip]
> 
> >> Rafael, for those of us who aren't thoroughly familiar with all the ins
> >> and outs of the ACPI spec, could you please summarize a list of the
> >> ACPI calls needed in the second and third cases above?  Indicate which
> >> ones need to be done from within the original kernel and which should
> >> be done from within a kexec'd hibernation kernel.
> 
> > Sure.
> 
> > In the third case (ie. transition to S4) we are supposed to do the following:
> 
> > (1) Upon entering the sleep state, which IMO can be done _after_ the image
> >     has been saved:
> 
> I assume you mean "in order to enter the sleep state", rather than "upon
> entering the sleep state".

Yes, that seems to be more accurate.

> I still don't understand what you mean by 
> "which IMO can be done _after_ the image has been saved"; as far as I
> understand, the last step of this process, "make the platform enter S4",
> is almost like a shutdown as far as the kernel is concerned (except for
> the tiny detail of having to call those special ACPI methods on resume);
> consequently, it would seem that nothing can be done after that step.

Well, the ACPI spec suggests to save the image somewhere after the devices
have been but into low power states, which is kind of unreasonable. :-)

> >   * figure out which devices can wake up
> >   * put devices into low power states (wake-up devices are placed in the Dx
> >     states compatible with the wake capability, the others are powered off)
> >   * execute the _PTS global control method
> >   * switch off the nonlocal CPUs (eg. nonboot CPUs on x86)
> >   * execute the _GTS global control method
> >   * set the GPE enable registers corresponding to the wake-up devices)
> >   * make the platform enter S4 (there's a well defined procedure for that)
> >   I think that this should be done by the image-saving kernel.
> 
> I agree.
> 
> > (2) Upon start-up (by which I mean what happens after the user has pressed
> >     the power button or something like that):
> >   * check if the image is present (and valid) _without_ enabling ACPI (we don't
> >     do that now, but I see no reason for not doing it in the new framework)
> >   * if the image is present (and valid), load it
> >   * turn on ACPI (unless already turned on by the BIOS, that is)
> >   * execute the _BFS global control method
> >   * execute the _WAK global control method
> >   * continue
> >   Here, the first two things should be done by the image-loading kernel, but
> >   the remaining operations have to be carried out by the restored
> >     kernel.
> 
> It doesn't seem like a problem for that to be the case, but out of
> curiosity why do those methods need to be executed by the "restored"
> kernel, rather than the "image loading" kernel.  Do they require some
> information from ACPI-related kernel data structures that were populated
> by the normal ACPI initialization?

Well, there are some complications.  For example, _BFS and _WAK should be
executed with interrupts on (I'm told that the AML interpreter might not work
with interrupts disabled) and the nonboot CPUs should be offline while they
are being executed.  Perhaps we should also avoid playing with APICs and
things like that after executing _WAK, so it's better to execute them from the
restored kernel.

> [snip]
> 
> > ... we can't return to the hibernated kernel unless we are going to cancel the
> > hibernation.
> 
> I agree.
> 
> > That's why I think that for the suspend-to-both the image-saving kernel will
> > need to support the same set of devices as the hibernated kernel.
> 
> If all of the devices that the image writing kernel doesn't know about
> have already been shut down/powered off by the hibernated kernel, then
> does the "image writing" kernel still need to know about them in order
> to suspend to RAM properly (i.e. without leaving some devices on wasting
> power)?

For some devices it may be illegal to leave them powered on while entering
S3.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
