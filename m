Return-Path: <linux-kernel-owner+w=401wt.eu-S1758560AbYC2Apx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758560AbYC2Apx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 20:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754437AbYC2App
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 20:45:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:37774 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754064AbYC2Apo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 20:45:44 -0400
Subject: Re: 2.6.25-rc5-mm1 sparc64 boot problems due to generic
	pci_enable_resources()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: David Miller <davem@davemloft.net>
Cc: m.kozlowski@tuxland.pl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, greg@kroah.com,
       sparclinux@vger.kernel.org
In-Reply-To: <20080328.161011.08762096.davem@davemloft.net>
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org>
	 <200803282352.10780.m.kozlowski@tuxland.pl>
	 <20080328.161011.08762096.davem@davemloft.net>
Content-Type: text/plain
Date: Sat, 29 Mar 2008 11:44:53 +1100
Message-Id: <1206751493.10388.84.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-03-28 at 16:10 -0700, David Miller wrote:
> From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
> Date: Fri, 28 Mar 2008 23:52:10 +0100
> 
> > 	The gregkh-pci-pci-sparc64-use-generic-pci_enable_resources.patch which
> > replaces arch-specific code with generic pci_enable_resources() makes my sparc64
> > box unable to boot (that's what quilt bisection says). At first I see these messages:
> 
> Yes, that generic code won't work because of the NULL
> r->parent check.
> 
> Alpha, ARM, V32, FRV, IA64, MIPS, MN10300, PARISC, PPC,
> SH, V850, X86, and Xtensa are all likely to run into
> problems because of this change.

ppc and x86 won't have problem, I haven't checked the others, sparc64
will as I see things.

> The only platform that did the check as a test of r->parent
> being NULL is Powerpc.

Yup, though that makes sense to do it that way on platforms that
actually build a resource tree like x86 or powerpc.

> The rest either didn't check (like sparc64), or tested it by going:
> 
> 	if (!r->start && r->end)
> 
> So the amount of potential breakage from this change is enormous.

Not that big, but yeah, it should be limited to platforms that actually
build a resource-tree and keep track of assigned & allocated resources,
which sparc64 doesn't (which is fair enough, if your firmware is 100%
right and your kernel never has to assigns things itself). The NULL
parent is a 100% indication that the resource was properly claimed and
put in the resource-tree (and thus is non conflicting) on those
platforms, but it's unused on sparc64.

Basically, on platforms like x86 or powerpc, the PCI subsystem at boot
builds a resource tree by collecting resources for all enabled devices
and bridges in a first pass, then all others in a second pass, checking
for conflicts or unassigned ones, and potentially re-assigning and
re-allocating bridges if necessary.

Sparc64 takes a different approach, it basically doesn't bother with a
full resource tree, and just claims what driver claim, which is fine as
long as you are certain that you always get a perfectly well assigned &
non conflicting setup done by your firmware.

The "full featured" approach is necessary for platforms where this isn't
the case, such as powerpc, even with a pretty good OF like Apple ones,
since they love to not assign resources that they know their MacOS
driver will not need (such as not assigning IO space and closing it on
the P2P bridge) which doesn't necessarily quite work with the
requirements of the linux  drivers, in addition to also gross bugs they
have on some versions when using cards with P2P bridges on them.

In addition, we also need that resource management to be able to
dynamically assign resource after boot as our OF doesn't stay alive to
do it, such as when using cardbus cards, or other type of hotplug things
for which the firmware doesn't do dynamic resource allocation.

So, the meat of the original patch isn't bad per-se. There is definitely
a lot of interest in making a lot of this resource survey and management
code common for platforms who want it (for example, powerpc and x86 are
very close already), and in that regard, this NULL check is definitely
what we want in the "merged" version. But I can understand David
unwillingness in bringing that whole infrastructure on platforms that
don't need it.

A quick survey shows that:

- Use what looks like a full featured resource allocation scheme similar
to x86: alpha, powerpc, ppc, 

- Use what looks like a slightly different scheme that still results in
resources being claimed in the resource tree when valid: ia64, mips (not
100% sure there, but it does call pci_assign_unassigned_resources), 

- Don't build a resource-tree per-se and don't claim device resources
(and thus NULL parent check is unreliable): sparc, sparc64, parisc ?
(unsure but I didn't see code to claim resources in the pci layer), arm
(unsure but PCI here seems to be spread in sub platform code and doesn't
appear to do resource management)

And I stopped there. So we have people on all sides of the fence but it
would still be worth consolidating at least x86, alpha & powerpc, and
possibly bring in others like ia64 and mips.

Cheers,
Ben.

