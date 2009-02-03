Return-Path: <linux-kernel-owner+w=401wt.eu-S1753633AbZBCXXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbZBCXXz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 18:23:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbZBCXXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 18:23:46 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41859 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbZBCXXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 18:23:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: PCI PM: Restore standard config registers of all devices early
Date: Wed, 4 Feb 2009 00:23:02 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org> <alpine.LFD.2.00.0902030742530.3247@localhost.localdomain> <1233701977.16867.104.camel@pasglop>
In-Reply-To: <1233701977.16867.104.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902040023.03843.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 February 2009, Benjamin Herrenschmidt wrote:
> 
> > You've found a bug somewhere.
> 
> Yup :-)
> 
> > We _should_ be saving things, the legacy code does something like this:
> > 
> >         if (drv && drv->suspend) {
> >                 pci_dev->state_saved = false;
> > 
> >                 i = drv->suspend(pci_dev, state);
> >                 suspend_report_result(drv->suspend, i);
> >                 if (i)
> >                         return i;
> > 
> >                 if (pci_dev->state_saved)
> >                         goto Fixup;
> > 
> >                 if (WARN_ON_ONCE(pci_dev->current_state != PCI_D0))
> >                         goto Fixup;
> 
> It looks like the above is what breaks. Looks like current_state is
> UNKNOWN. The device is an old mach64 that has no PCI PM capability, thus
> the driver doesn't call any PCI PM stuff, the state basically stays set
> to what the core set it to at probe time which appears to be
> PCI_UNKNOWN.

Overlooked, sorry.

> Thus we don't call pci_save_state().
> 
> Then ...
> 
> >         }
> > 
> >         pci_save_state(pci_dev);
> > 
> > ie if your ->suspend function doesn't use pci_save_state() itself (which 
> > sets that "state_saved" flag to true), then the generic code will do it 
> > for you.
> > 
> > Also, on the resume path, we actually have
> > 
> >         if (pci_dev->state_saved)
> >                 pci_restore_standard_config(pci_dev);
> > 
> > so I wonder how the heck you got that blast of all zeroes - because we
> > clearly shouldn't be trying to restore any unsaved state!
> 
> Well, that's it ... we don't actually test pci_dev->state_saved in
> whatever is currently upstream. The code is:
> 
> static void pci_pm_default_resume_noirq(struct pci_dev *pci_dev)
> {
> 	pci_restore_standard_config(pci_dev);
> 	pci_fixup_device(pci_fixup_resume_early, pci_dev);
> }
> 
> Oops... 

The assumption here is that the state will be saved either by the driver
or by the core, so the bug here is a consequence of the previous one.

I'll add a check.

> Rafael, the second one is trivial to fix, but what about the first one ?
> Should we not count UNKNOWN in that goto or should we set legacy stuff
> that don't do PCI PM to PCI_D0 somewhere ? Or both ? :-)

Well, if the state is UNKNOWN, I think it's safe to save the config, so the
WARN_ON should really catch the low power states only.  I'll fix that.

Thanks for debugging it!

Rafael
