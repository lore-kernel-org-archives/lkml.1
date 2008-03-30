Return-Path: <linux-kernel-owner+w=401wt.eu-S1753269AbYC3NQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbYC3NQ2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 09:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbYC3NQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 09:16:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34526 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419AbYC3NQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 09:16:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH] ACPI PM: Restore the 2.6.24 suspend ordering
Date: Sun, 30 Mar 2008 15:15:32 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Len Brown <lenb@kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Shaohua Li <shaohua.li@intel.com>,
       Felix =?iso-8859-1?q?M=F6ller?= <fm@opensuse.org>,
       Arthur Erhardt <erhardt@pit.physik.uni-tuebingen.de>,
       Matthew Garrett <mjg59@srcf.ucam.org>
References: <200803300319.08398.rjw@sisk.pl> <200803301358.39831.rjw@sisk.pl> <20080330122838.GA7093@elf.ucw.cz>
In-Reply-To: <20080330122838.GA7093@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803301515.33922.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 30 of March 2008, Pavel Machek wrote:
> Hi!

Hi,

> > > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > > 
> > > > Some time ago it turned out that our suspend code ordering broke
> > > > some NVidia-based systems that hung if _PTS was executed with one of
> > > > the PCI devices, specifically a USB controller, in a low power state.
> > > > Then, it was noticed that the suspend code ordering was not compliant
> > > > with ACPI 1.0, although it was compliant with ACPI 2.0 (and later),
> > > > and it was argued that the code had to be changed for that reason
> > > > (ref. http://bugzilla.kernel.org/show_bug.cgi?id=9528).  So we did,
> > > > but evidently we did wrong, because it's now turning out that some
> > > > systems have been broken by this change (refs.
> > > > http://bugzilla.kernel.org/show_bug.cgi?id=10340 ,
> > > > https://bugzilla.novell.com/show_bug.cgi?id=374217#c16).  [I said
> > > > at that time that something like this might happend, but the majority
> > > > of people involved thought that it was improbable due to the
> > > > necessity to preserve the compliance of hardware with ACPI 1.0.]
> > > > This actually is a quite serious regression from 2.6.24.
> > > > 
> > > > Moreover, the ACPI 1.0 ordering of suspend code introduced another
> > > > issue that I have only noticed recently.  Namely, if the suspend of
> > > > one of devices fails, the already suspended devices will be resumed
> > > > without executing _WAK before, which leads to problems on some
> > > > systems (for example, in such situations thermal management is
> > > > broken on my HP nx6325).  Consequently, it also breaks suspend
> > > > debugging on the affected systems.
> > > > 
> > > > Note also, that the requirement to execute _PTS before suspending
> > > > devices does not really make sense, because the device in question
> > > > may be put into a low power state at run time for a reason unrelated
> > > > to a system-wide suspend.
> 
> Yes, but if we are putting them into lowpower state ourselves, we
> should probably be doing that "by hand", without calling acpi
> methods. _PTS may prepare something for acpi methods (which tell us
> which PCI Dx state to put the device in at the very least).

I meant "the requirement to execute _PTS before suspending devices, because
it would hang otherwise".

> > > > For the reasons outlined above, the change of the suspend ordering
> > > > should be reverted, which is done by the patch below.
> > > 
> > > But this will break those few nvidia-based systems, no?
> > > 
> > > this may have been a good idea in -rc1 days, but we are in -rc7
> > > now... and the patch is slightly big.
> > 
> > It's quite obvious, though.
> 
> Yes, but breaking systems between -rc7 and final is _very_ unnice.

Breaking systems between 2.6.24 and 2.6.25 is even worse, which is why
I've posted this patch.

IOW, we tried to fix systems that were broken with 2.6.24, but it didn't work,
because our "fix" broke systems that were OK with 2.6.24.  Solution: revert
the "fix" and go back to the design board.  That's all we can do so late in
the release cycle, IMO.

> > > What about something like: (hand-edited patch, sorry)
> > 
> > Well, I think that would be confusing.
> > 
> > The NVidia systems are broken anyway on 2.6.24.x, so we just don't fix them
> > rather than break them and there are more reasons to do what the patch does
> > (as pointed out in the changelog).  For example, your suggested patch doesn't
> >  fix the error paths/debugging breakage described in the changelog.
> 
> But that should not be impossible to fix, right?

No, it shouldn't, but it would be more complicated than it seemed to be.

> > I think we _can_ do something about the failing NVidia systems in the 2.6.26
> > time frame, but that will require some more consideration.
> 
> We could simply blacklist them, no?

Yes, but for this purpose we'll have to redesign the core so that everything
(including debugging and the error paths) works if _PTS is executed before
suspending devices.  _That_, however, is not a 2.6.25 thing.

Thanks,
Rafael
