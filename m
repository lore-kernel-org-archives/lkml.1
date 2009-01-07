Return-Path: <linux-kernel-owner+w=401wt.eu-S1757250AbZAGNOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250AbZAGNOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 08:14:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710AbZAGNOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 08:14:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59718 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbZAGNN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 08:13:59 -0500
Date: Wed, 7 Jan 2009 14:13:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86 PCI: Do not use interrupt links for devices using
	MSI-X
Message-ID: <20090107131348.GE3529@elte.hu>
References: <200901042308.42625.rjw@sisk.pl> <20090105130439.GA6014@elte.hu> <200901051153.07860.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901051153.07860.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Monday, January 5, 2009 5:04 am Ingo Molnar wrote:
> > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > >
> > > pcibios_enable_device() and pcibios_disable_device() don't handle
> > > IRQs for devices that have MSI enabled and it should tread the
> >
> > s/tread/treat
> >
> > > devices with MSI-X enabled in the same way.
> > >
> > > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > > ---
> > >  arch/x86/pci/common.c |    4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > looks good - Jesse, what do you think?
> 
> Yeah, seems obviously correct, I'll queue it up.
> 
> > Rafael, i'm curious is this in response to some regression/bug? Did some
> > box or driver get confused by us enabling/disabling the GSI? Some IRQ
> > flood perhaps?
> >
> > btw., there's a small observation:
> > > +     if (!dev->msi_enabled && !dev->msix_enabled)
> >
> > maybe a "pci_has_gsi_irq()" wrapper would make these checks cleaner and
> > would make things more robust, should there be any new IRQ delivery method
> > be introduced in the future?
> 
> pci_has_msi_irq surely?  Otherwise we'll catch pretty much everything?  Or did 
> you mean !pci_has_gsi_irq() here instead?

Well - here the check is: "if (not MSI or MSIX)" in essence. I thought 
that it might be confusing to call it _msi() as well, so we could approach 
it via the inverse space: general system interrupts (GSIs) - which are 
device irqs that are neither MSI nor MSIX.

But if pci_has_msi_irq() can cleanly include the MSIX portion too, that's 
fine too. (MSI-X is really MSI with wider eventing capabilities but 
otherwise non-GSI just as much - and we dont want to enable (or even 
touch) the legacy IRQ line registers for any of them, even if they happen 
to be enumerated)

Right?

	Ingo
