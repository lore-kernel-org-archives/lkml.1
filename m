Return-Path: <linux-kernel-owner+w=401wt.eu-S1753635AbYI3QbD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635AbYI3QbD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 12:31:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbYI3Qav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 12:30:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56079 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751949AbYI3Qau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 12:30:50 -0400
Date: Tue, 30 Sep 2008 09:29:44 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rene Herman <rene.herman@keyaccess.nl>
cc: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       Frans Pop <elendil@planet.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-acpi@vger.kernel.org, Adam Belay <abelay@mit.edu>,
       Avuton Olrich <avuton@gmail.com>,
       Karl Bellve <karl.bellve@umassmed.edu>, Willem Riede <wriede@riede.org>,
       Matthew Hall <mhall@mhcomputing.net>
Subject: Re: [patch 2/2] PNP: don't check disabled PCI BARs for conflicts in
 quirk_system_pci_resources()
In-Reply-To: <48E24C6F.3030903@keyaccess.nl>
Message-ID: <alpine.LFD.2.00.0809300904530.3389@nehalem.linux-foundation.org>
References: <200809290953.56565.bjorn.helgaas@hp.com> <200809290957.59813.bjorn.helgaas@hp.com> <alpine.LFD.1.10.0809290912060.3265@nehalem.linux-foundation.org> <48E11EFA.8010402@keyaccess.nl> <alpine.LFD.2.00.0809291211330.3389@nehalem.linux-foundation.org>
 <48E1EF0E.8030006@keyaccess.nl> <alpine.LFD.2.00.0809300741320.3389@nehalem.linux-foundation.org> <48E24C6F.3030903@keyaccess.nl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 30 Sep 2008, Rene Herman wrote:
> 
> > Of course, it may be that the PnP code runs too early, and we have only
> > parsed the PCI resources, not inserted them into the resource tree yet. If
> > so, none of this will work, of course.
> 
> It doesn't. With the test negated it triggers for all PCI resources (and
> ofcourse my soundcard driver fails again).

Oh, ok. Looking at it, it does seem that we actually _insert_ the PCI 
resources too late. We do it in pcibios_allocate_resources(), and there we 
even take care to look at whether it was enabled or disabled (we 
prioritize enabled resources, so that a disabled one will never be 
requested before an enabled one and if they clash, it's always the 
disabled one that loses the resource).

But pcibios_allocate_resources() is called from pcibios_resource_survey(), 
which is called from pcibios_init(), which in turn is caled from 
pci_subsys_init() that is a "subsys_initcall()".

In contrast, the PnP fixup thing is called from pnp_fixup_device, called 
from __pnp_add_device(), called from pnp_add_device() (and 
pnp_add_card(), but that should be later), and those in turn from
pnpacpi_add_device and pnpacpi_init(). 

And pnpacpi_init is _also_ a subsys_initcall, but arch/x86/pci/built-in.o 
gets linked in _after_ drivers/built-in.o. That, in turn, is because it's 
marked as a "driver" in the x86 Makefile, and the main Makefile actually 
ends up forcing "drivers-y" to have drivers/ first.

Just for fun, does this patch make a difference and allow you to just 
take the "is it registered" thing into account?

It's a scary change right now, and I wouldn't commit it as is (I think 
that for 2.6.27 the thing to do is to just do the minimal "zero means 
disabled" thing), but having some random driver level initialize before 
the core architecture-specific PCI code does smell. So something like this 
sounds conceptually right anyway.

		Linus

---
 arch/x86/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index f5631da..97d0e86 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -159,7 +159,7 @@ core-$(CONFIG_IA32_EMULATION) += arch/x86/ia32/
 
 # drivers-y are linked after core-y
 drivers-$(CONFIG_MATH_EMULATION) += arch/x86/math-emu/
-drivers-$(CONFIG_PCI)            += arch/x86/pci/
+core-$(CONFIG_PCI)            += arch/x86/pci/
 
 # must be linked after kernel/
 drivers-$(CONFIG_OPROFILE) += arch/x86/oprofile/
