Return-Path: <linux-kernel-owner+w=401wt.eu-S1753600AbYI3TNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbYI3TNO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 15:13:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239AbYI3TM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 15:12:58 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:47414 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720AbYI3TM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 15:12:57 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 2/2] PNP: don't check disabled PCI BARs for conflicts in quirk_system_pci_resources()
Date: Tue, 30 Sep 2008 13:12:48 -0600
User-Agent: KMail/1.9.9
Cc: Rene Herman <rene.herman@keyaccess.nl>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       Frans Pop <elendil@planet.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-acpi@vger.kernel.org, Adam Belay <abelay@mit.edu>,
       Avuton Olrich <avuton@gmail.com>,
       Karl Bellve <karl.bellve@umassmed.edu>, Willem Riede <wriede@riede.org>,
       Matthew Hall <mhall@mhcomputing.net>
References: <200809290953.56565.bjorn.helgaas@hp.com> <48E24C6F.3030903@keyaccess.nl> <alpine.LFD.2.00.0809300904530.3389@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0809300904530.3389@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809301312.50712.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 September 2008 10:29:44 am Linus Torvalds wrote:
> 
> On Tue, 30 Sep 2008, Rene Herman wrote:
> > 
> > > Of course, it may be that the PnP code runs too early, and we have only
> > > parsed the PCI resources, not inserted them into the resource tree yet. If
> > > so, none of this will work, of course.
> > 
> > It doesn't. With the test negated it triggers for all PCI resources (and
> > ofcourse my soundcard driver fails again).
> 
> Oh, ok. Looking at it, it does seem that we actually _insert_ the PCI 
> resources too late. We do it in pcibios_allocate_resources(), and there we 
> even take care to look at whether it was enabled or disabled (we 
> prioritize enabled resources, so that a disabled one will never be 
> requested before an enabled one and if they clash, it's always the 
> disabled one that loses the resource).
> 
> But pcibios_allocate_resources() is called from pcibios_resource_survey(), 
> which is called from pcibios_init(), which in turn is caled from 
> pci_subsys_init() that is a "subsys_initcall()".
> 
> In contrast, the PnP fixup thing is called from pnp_fixup_device, called 
> from __pnp_add_device(), called from pnp_add_device() (and 
> pnp_add_card(), but that should be later), and those in turn from
> pnpacpi_add_device and pnpacpi_init(). 
> 
> And pnpacpi_init is _also_ a subsys_initcall, but arch/x86/pci/built-in.o 
> gets linked in _after_ drivers/built-in.o. That, in turn, is because it's 
> marked as a "driver" in the x86 Makefile, and the main Makefile actually 
> ends up forcing "drivers-y" to have drivers/ first.
> 
> Just for fun, does this patch make a difference and allow you to just 
> take the "is it registered" thing into account?
> 
> It's a scary change right now, and I wouldn't commit it as is (I think 
> that for 2.6.27 the thing to do is to just do the minimal "zero means 
> disabled" thing), but having some random driver level initialize before 
> the core architecture-specific PCI code does smell. So something like this 
> sounds conceptually right anyway.

Sorry for the delay in responding -- I'm officially on vacation
yesterday and today.

I agree that for 2.6.27 the "res->start == 0 means disabled" check
in the PNP quirk seems safest.

I don't like it long-term, because (a) I'd like that knowledge to at
least be in PCI, not PNP, and (b) res->start is the CPU address, not
necessarily the PCI bus address, and the BAR value (== PCI bus address)
is what we're trying to check.  Even if we looked at the BAR value
instead of res->start, I think zero is a valid PCI bus address on
machines where the root bridge applies an address offset.

So something like the patch below (same as what Rene originally
proposed, I think)?

diff --git a/drivers/pnp/quirks.c b/drivers/pnp/quirks.c
index 0bdf9b8..b3319e4 100644
--- a/drivers/pnp/quirks.c
+++ b/drivers/pnp/quirks.c
@@ -254,6 +254,10 @@ static void quirk_system_pci_resources(struct pnp_dev *dev)
 
 			pci_start = pci_resource_start(pdev, i);
 			pci_end = pci_resource_end(pdev, i);
+
+			if (!pci_start)
+				continue;
+
 			for (j = 0;
 			     (res = pnp_get_resource(dev, type, j)); j++) {
 				if (res->start == 0 && res->end == 0)

