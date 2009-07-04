Return-Path: <linux-kernel-owner+w=401wt.eu-S1753059AbZGDSk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbZGDSk4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 14:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbZGDSkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 14:40:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:36664 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbZGDSkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 14:40:45 -0400
Subject: Re: [PATCH 1/2] IOMMU Identity Mapping Support:
 iommu_identity_mapping definition
From: David Woodhouse <dwmw2@infradead.org>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Fenghua Yu <fenghua.yu@intel.com>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'Ingo Molnar'" <mingo@elte.hu>,
       "'Christopher Wright'" <chrisw@redhat.com>,
       "'Allen Kay'" <allen.m.kay@intel.com>,
       "'iommu'" <iommu@lists.linux-foundation.org>,
       "'lkml'" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090618181335.GB19771@sequoia.sous-sol.org>
References: <20090327212241.234500000@intel.com>
	 <20090327212321.070229000@intel.com>
	 <20090416001957.GA1527@linux-os.sc.intel.com>
	 <1240135508.3589.75.camel@macbook.infradead.org>
	 <A6AD88C3F2289247BE726C37303E1EB8A4DF7DB1@orsmsx505.amr.corp.intel.com>
	 <20090513231351.GA22386@linux-os.sc.intel.com>
	 <1242314271.3393.11.camel@macbook.infradead.org>
	 <20090514175944.GA5168@linux-os.sc.intel.com>
	 <20090618180514.GA24082@linux-os.sc.intel.com>
	 <20090618181335.GB19771@sequoia.sous-sol.org>
Content-Type: text/plain
Date: Sat, 04 Jul 2009 19:40:18 +0100
Message-Id: <1246732818.3892.446.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-18 at 11:13 -0700, Chris Wright wrote:
> * Fenghua Yu (fenghua.yu@intel.com) wrote:
> > IOMMU Identity Mapping Support: iommu_identity_mapping definition
> > 
> > Identity mapping for IOMMU defines a single domain to 1:1 map all pci devices
> > to all usable memory.
> > 
> > This will reduces map/unmap overhead in DMA API's and improve IOMMU performance.
> > On 10Gb network cards, Netperf shows no performance degradation compared to
> > non-IOMMU performance.
> > 
> > This method may lose some of DMA remapping benefits like isolation.
> > 
> > The first patch defines iommu_identity_mapping varialbe which controls the
> > identity mapping code and is 0 by default.
> 
> The only real difference between "pt" and "identity" is hardware support.
> We should have a single value we don't have to tell users to do different
> things depending on their hardware (they won't even know what they have)
> to achieve the same result.

The _code_ ought to be a lot more shared than it is, too. Currently, the
hardware pass-through support has bugs that the software identity
mapping doesn't. It doesn't remove devices from the identity map if they
are limited to 32-bit DMA and a driver tries to set up mappings, which
is quite suboptimal. And it doesn't put them _back_ into the identity
map after they're detached from a VM, AFAICT.

I was going to fix that and unify the code paths, but then I found a bug
with the software identity mapping too -- if you have a PCI device which
is only capable of 32-bit DMA and it's behind a bridge (such as the
ohci1394 device on a Tylersburg SDV, although you'll have to hack the
kernel to pretend not to have the hardware PT support), it'll cause a
BUG() when it first sets up a mapping. What happens is this:

First it removes that device from si_domain because it can only address
4GiB of RAM, then get_domain_for_dev() will put it right back _in_ the
si_domain again, because it inherits its domain from the upstream PCI
bridge. And then we BUG() in domain_get_iommu() which _really_ doesn't
want to see the si_domain.

I _think_ this is the best fix for that...

>From 3dfc813d94bba2046c6aed216e0fd69ac93a8e03 Mon Sep 17 00:00:00 2001
From: David Woodhouse <David.Woodhouse@intel.com>
Date: Sat, 4 Jul 2009 19:11:08 +0100
Subject: [PATCH] intel-iommu: Don't use identity mapping for PCI devices behind bridges

Our current strategy for pass-through mode is to put all devices into
the 1:1 domain at startup (which is before we know what their dma_mask
will be), and only _later_ take them out of that domain, if it turns out
that they really can't address all of memory.

However, when there are a bunch of PCI devices behind a bridge, they all
end up with the same source-id on their DMA transactions, and hence in
the same IOMMU domain. This means that we _can't_ easily move them from
the 1:1 domain into their own domain at runtime, because there might be DMA
in-flight from their siblings.

So we have to adjust our pass-through strategy: For PCI devices not on
the root bus, and for the bridges which will take responsibility for
their transactions, we have to start up _out_ of the 1:1 domain, just in
case.

This fixes the BUG() we see when we have 32-bit-capable devices behind a
PCI-PCI bridge, and use the software identity mapping.

It does mean that we might end up using 'normal' mapping mode for some
devices which could actually live with the faster 1:1 mapping -- but
this is only for PCI devices behind bridges, which presumably aren't the
devices for which people are most concerned about performance.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
 drivers/pci/intel-iommu.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index f9fc4f3..360fb67 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -2122,6 +2122,36 @@ static int iommu_should_identity_map(struct pci_dev *pdev, int startup)
 	if (iommu_identity_mapping == 2)
 		return IS_GFX_DEVICE(pdev);
 
+	/*
+	 * We want to start off with all devices in the 1:1 domain, and
+	 * take them out later if we find they can't access all of memory.
+	 *
+	 * However, we can't do this for PCI devices behind bridges,
+	 * because all PCI devices behind the same bridge will end up
+	 * with the same source-id on their transactions.
+	 *
+	 * Practically speaking, we can't change things around for these
+	 * devices at run-time, because we can't be sure there'll be no
+	 * DMA transactions in flight for any of their siblings.
+	 * 
+	 * So PCI devices (unless they're on the root bus) as well as
+	 * their parent PCI-PCI or PCIe-PCI bridges must be left _out_ of
+	 * the 1:1 domain, just in _case_ one of their siblings turns out
+	 * not to be able to map all of memory.
+	 */
+	if (!pdev->is_pcie) {
+		if (!pci_is_root_bus(pdev->bus))
+			return 0;
+		if (pdev->class >> 8 == PCI_CLASS_BRIDGE_PCI)
+			return 0;
+	} else if (pdev->pcie_type == PCI_EXP_TYPE_PCI_BRIDGE)
+		return 0;
+
+	/* 
+	 * At boot time, we don't yet know if devices will be 64-bit capable.
+	 * Assume that they will -- if they turn out not to be, then we can 
+	 * take them out of the 1:1 domain later.
+	 */
 	if (!startup)
 		return pdev->dma_mask > DMA_BIT_MASK(32);
 
-- 
1.6.2.5


-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

