Return-Path: <linux-kernel-owner+w=401wt.eu-S1758687AbXLTIqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758687AbXLTIqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 03:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754011AbXLTIqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 03:46:09 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:36678 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbXLTIqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 03:46:08 -0500
Date: Thu, 20 Dec 2007 11:46:16 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Richard Henderson <rth@twiddle.net>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Daniel Ritz <daniel.ritz@gmx.ch>, Greg KH <greg@kroah.com>
Subject: Re: PCI resource problems caused by improper address rounding
Message-ID: <20071220084616.GA28578@jurassic.park.msu.ru>
References: <47671377.6000405@redhat.com> <alpine.LFD.0.9999.0712171648150.21557@woody.linux-foundation.org> <47680489.6040809@redhat.com> <alpine.LFD.0.9999.0712180946030.21557@woody.linux-foundation.org> <20071218202234.GA24525@twiddle.net> <20071219002349.A12278@jurassic.park.msu.ru> <alpine.LFD.0.9999.0712181338150.21557@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0712181338150.21557@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2007 at 01:46:56PM -0800, Linus Torvalds wrote:
> Heh, indeed. Good catch - that
> 
> 	Prefetchable memory behind bridge: 0000000000000000-000000000fffffff
> 
> on device 00:01.0 does look totally broken, and it would make more sense 
> if it matched what the device has (and what /proc/iomem resports).

Sigh. The patch was way too incomplete - I somehow missed
PCI_PREF_LIMIT_UPPER32... Corrected patch appended - I think it's
worth applying in either case since a bridge window at address 0 is
an obvious bug and this patch fixes it.

> That said, Intel bridges tend to be transparent even when they *claim* 
> normal decode, so I wonder whether it actually matters in this case. But 
> your patch looks very obviously right. 

I don't think that transparency is the case here - I read specs for some
recent Intel chipsets and it looks like they are pretty accurate now with
a "subtractive decode" flag - over the last couple of years, at least.
There are, of course, some strange "priority decode rules", but they
can be safely ignored as far as the kernel resource management is
concerned.

> So maybe the rest of the kernel and X both already did everything right, 
> and it was just this stupid bridge setup thing that was broken (and 
> forcing the IOMEM resource to below the 4G mark just hid it).

I've just checked the setup-bus code and have to say that its ability to
correctly handle the 64-bit BARs is close to zero...

On the positive side, getting it right doesn't seem to be as complicated
as I thought initially - mainly because only the prefetchable memory
window of p2p bridge is 64-bit. This effectively limits >4G allocations
to prefetchable resources only.

Anyway, using PCI bus space above 4G on x86 seems to be a must these
days, and I have some spare hardware to play with. Maybe I'll be able
to get something working by mid January or so...

Ivan.

---
PCI: do respect full 64-bit address for bridge prefetch window

Prevent the prefetch window from being programmed with a bogus address
when its respective resource gets allocated above the 4G mark.

Note that we cannot yet guarantee correct resource allocations
above 4G, though it might work in some simple cases.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
---
 drivers/pci/setup-bus.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 401e03c..643e72e 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -208,8 +208,11 @@ pci_setup_bridge(struct pci_bus *bus)
 	}
 	pci_write_config_dword(bridge, PCI_PREF_MEMORY_BASE, l);
 
-	/* Clear out the upper 32 bits of PREF base. */
-	pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32, 0);
+	/* Set up the upper 32 bits of PREF base/limit. */
+	l = region.start >> 16 >> 16;
+	pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32, l);
+	l = region.end >> 16 >> 16;
+	pci_write_config_dword(bridge, PCI_PREF_LIMIT_UPPER32, l);
 
 	pci_write_config_word(bridge, PCI_BRIDGE_CONTROL, bus->bridge_ctl);
 }
