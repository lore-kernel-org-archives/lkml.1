Return-Path: <linux-kernel-owner+w=401wt.eu-S936769AbXGQUxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936769AbXGQUxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 16:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936640AbXGQUxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 16:53:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50239 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934756AbXGQUxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 16:53:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeremy Maitin-Shepard <jbms@cmu.edu>
Subject: Re: Hibernation considerations
Date: Tue, 17 Jul 2007 23:00:49 +0200
User-Agent: KMail/1.9.5
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
References: <Pine.LNX.4.44L0.0707171010490.3551-100000@iolanthe.rowland.org> <200707172150.44417.rjw@sisk.pl> <87sl7mg4n6.fsf@jbms.ath.cx>
In-Reply-To: <87sl7mg4n6.fsf@jbms.ath.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707172300.51279.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 17 July 2007 22:24, Jeremy Maitin-Shepard wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> [snip]
> 
> > Well, first, the fact is that _some_ systems _will_ be powered while in
> > hibernation (the majority of notebooks, for example) and you should assume
> > that the platform _may_ retain some information accross the hibernation/restore
> > cycle.  In that case you _should_ _not_ trash the information retained by the
> > platform.
> 
> I'm not sure the majority of notebook users will want wakeup support in
> exchange for some power consumption while the system is off.  I think
> many people would not consider the trouble of having to press the power
> button instead of merely opening the lid too great.
> 
> Furthermore, S4 mode is of course also not suitable if you intend to
> replace the battery while the system is hibernated.
> 
> It does seem that it is useful to provide S4 as an option, but certainly
> just shutting down should also be an option on all systems.
> 
> > Now, with that in mind, ACPI requires us to make the system enter the S4 sleep
> > state as a result of the hibernation procedure.  In my opinion this may be done
> > after saving the image, but still this means, for example, that the
> > image-saving kernel needs to support ACPI.
> 
> It seems that it most certainly must be done AFTER saving the image, as
> the image obviously cannot be saved after entering S4 state, since S4
> state is nearly the same as powering off completely and all memory will
> be lost.
> 
> > Next, during the restore, we should first check if the image is present (and
> > valid) _without_ turning ACPI on (note that this is not done by the current
> > hibernation code and that leads to strange problems on some systems).  Then,
> > if the image is present (and valid), we should first load it, jump to the
> > hibernated kernel and _then_ turn ACPI on and execute the _BFS and
> > _WAK ACPI global methods (again, this is not done by the current code in that
> > order, which is wrong).  Only after that is the hibernated kernel supposed to
> > continue.
> 
> It seems that the implementation of that behavior for Linux cannot be
> quite so simple, since resume from hibernation is driven (in general)
> from an initrd/initramfs rather than directly from the kernel
> initialization sequence, in order to support modular drivers and
> features like DM and LVM.

That's correct.

> Thus, there would have to be a new "delay_acpi_initialization" kernel
> command-line option.  Additionally, there would be a sysfs interface to
> tell the kernel to proceed with the ACPI initialization as normal.  This
> would be used by an initrd/initramfs after determining that a resume
> from hibernate will not be done.  If a resume from hibernate is done,
> this hook won't be used, and instead the resumed kernel will call the
> ACPI hibernate resume stuff if S4 state was used; otherwise, the resumed
> kernel will just re-initialize ACPI as normal.  Also, if the in-kernel
> code for checking if a resume can be done does not find a hibernate
> image, it will also invoke the delayed ACPI initialization.

Yes, something like this.

My point is, though, that it really requires some thought and needs to be
remebered about.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
