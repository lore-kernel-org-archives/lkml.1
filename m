Return-Path: <linux-kernel-owner+w=401wt.eu-S1753297AbZBCXAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297AbZBCXAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 18:00:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755AbZBCXAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 18:00:35 -0500
Received: from gate.crashing.org ([63.228.1.57]:44948 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639AbZBCXAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 18:00:34 -0500
Subject: Re: PCI PM: Restore standard config registers of all devices early
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LFD.2.00.0902030742530.3247@localhost.localdomain>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org>
	 <200902030045.19416.rjw@sisk.pl>
	 <alpine.LFD.2.00.0902021551050.3247@localhost.localdomain>
	 <200902030115.32659.rjw@sisk.pl>
	 <alpine.LFD.2.00.0902021622350.3247@localhost.localdomain>
	 <1233641226.16867.81.camel@pasglop>
	 <alpine.LFD.2.00.0902030742530.3247@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 04 Feb 2009 09:59:37 +1100
Message-Id: <1233701977.16867.104.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> You've found a bug somewhere.

Yup :-)

> We _should_ be saving things, the legacy code does something like this:
> 
>         if (drv && drv->suspend) {
>                 pci_dev->state_saved = false;
> 
>                 i = drv->suspend(pci_dev, state);
>                 suspend_report_result(drv->suspend, i);
>                 if (i)
>                         return i;
> 
>                 if (pci_dev->state_saved)
>                         goto Fixup;
> 
>                 if (WARN_ON_ONCE(pci_dev->current_state != PCI_D0))
>                         goto Fixup;

It looks like the above is what breaks. Looks like current_state is
UNKNOWN. The device is an old mach64 that has no PCI PM capability, thus
the driver doesn't call any PCI PM stuff, the state basically stays set
to what the core set it to at probe time which appears to be
PCI_UNKNOWN.

Thus we don't call pci_save_state().

Then ...

>         }
> 
>         pci_save_state(pci_dev);
> 
> ie if your ->suspend function doesn't use pci_save_state() itself (which 
> sets that "state_saved" flag to true), then the generic code will do it 
> for you.
> 
> Also, on the resume path, we actually have
> 
>         if (pci_dev->state_saved)
>                 pci_restore_standard_config(pci_dev);
> 
> so I wonder how the heck you got that blast of all zeroes - because we
> clearly shouldn't be trying to restore any unsaved state!

Well, that's it ... we don't actually test pci_dev->state_saved in
whatever is currently upstream. The code is:

static void pci_pm_default_resume_noirq(struct pci_dev *pci_dev)
{
	pci_restore_standard_config(pci_dev);
	pci_fixup_device(pci_fixup_resume_early, pci_dev);
}

Oops... 

Rafael, the second one is trivial to fix, but what about the first one ?
Should we not count UNKNOWN in that goto or should we set legacy stuff
that don't do PCI PM to PCI_D0 somewhere ? Or both ? :-)

Cheers,
Ben.


