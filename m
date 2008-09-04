Return-Path: <linux-kernel-owner+w=401wt.eu-S1756256AbYIDFWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256AbYIDFWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 01:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbYIDFWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 01:22:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50485 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751603AbYIDFWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 01:22:03 -0400
Date: Wed, 3 Sep 2008 22:21:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: linux-next: Tree for September 3
In-Reply-To: <20080903214634.ea17ff53.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0809032201510.3378@nehalem.linux-foundation.org>
References: <20080903191619.6b6b230e.sfr@canb.auug.org.au> <20080903214634.ea17ff53.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Sep 2008, Andrew Morton wrote:
>
> The Vaio says:
> 
> calling  init_acpi_pm_clocksource+0x0/0x14a
> initcall init_acpi_pm_clocksource+0x0/0x14a returned 0 after 32 msecs
> calling  pcibios_assign_resources+0x0/0x70
> pci 0000:06:05.0: BAR 9 too large: 0x00000000000000-0x00000003ffffff

Hmm. This should not be a new warning, afaik.

But it looks totally bogus.

The code does:

	r_size = r->end - r->start + 1;
	/* For bridges size != alignment */
	align = (i < PCI_BRIDGE_RESOURCES) ? r_size : r->start;
	order = __ffs(align) - 20;
	if (order > 11) {
		dev_warn(&dev->dev, "BAR %d too large: "
			"%#016llx-%#016llx\n", i,
			(unsigned long long)r->start,
			(unsigned long long)r->end);

and the thing is, that's a bridge resource, so it chooses r_start as the 
alignment. Which is zero. so now __ffs(align) returns a bogus value, and 
you get the bogus warning.

But CARDBUS bridges are _different_ from normal PCI bridges, and the 
alignment value isn't r->start. Strictly speaking it's not r_size either, 
it's always a fixed alignment of 4096 for MMIO bridging, i think. Maybe. 
Whatever. But our resource handling code can't handle that, and always 
wants either size alignment or start alignment.

But for cardbus bridges, we should be doing size alignment, and the 
problem is that that code doesn't do the proper "resource_alignment()" 
use.

Can you apply this patch, just to see if it fixes things.

And do you know when this started happening? It shouldn't have been all 
that recent. Maybe you haven't tried your Vaio in a while?

		Linus

---
 drivers/pci/setup-bus.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 82634a2..1aad599 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -352,11 +352,12 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask, unsigned long
 				continue;
 			r_size = r->end - r->start + 1;
 			/* For bridges size != alignment */
-			align = (i < PCI_BRIDGE_RESOURCES) ? r_size : r->start;
+			align = resource_alignment(r);
 			order = __ffs(align) - 20;
 			if (order > 11) {
-				dev_warn(&dev->dev, "BAR %d too large: "
+				dev_warn(&dev->dev, "BAR %d bad alignment %llx: "
 				       "%#016llx-%#016llx\n", i,
+				       (unsigned long long)align,
 				       (unsigned long long)r->start,
 				       (unsigned long long)r->end);
 				r->flags = 0;
