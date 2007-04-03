Return-Path: <linux-kernel-owner+w=401wt.eu-S932760AbXDCHm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932760AbXDCHm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 03:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932739AbXDCHm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 03:42:26 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:49887 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932759AbXDCHm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 03:42:26 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Greg KH" <gregkh@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-pci@atrey.karlin.mff.cuni.cz>, <linux-kernel@vger.kernel.org>,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>,
       "Williams, Mitch A" <mitch.a.williams@intel.com>
Subject: [PATCH] msi: Immediately mask and unmask msi-x irqs.
References: <08FE5CC30C9A3F41BF819A502CF7BF6E0100376E@fmsmsx411.amr.corp.intel.com>
Date: Tue, 03 Apr 2007 01:41:49 -0600
In-Reply-To: <08FE5CC30C9A3F41BF819A502CF7BF6E0100376E@fmsmsx411.amr.corp.intel.com>
	(Mitch A. Williams's message of "Fri, 30 Mar 2007 13:49:20 -0700")
Message-ID: <m1lkh9dhvm.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This is a simplified and actually more comprehensive form of a bug
fix from Mitch Williams <mitch.a.williams@intel.com>.

When we mask or unmask a msi-x irqs the writes may be posted because
we are writing to memory mapped region.  This means the mask and
unmask don't happen immediately but at some unspecified time in the
future.  Which is out of sync with how the mask/unmask logic work
for ioapic irqs.

The practical result is that we get very subtle and hard to track down
irq migration bugs.

This patch performs a read flush after writes to the MSI-X table for mask
and unmask operations.  Since the SMP affinity is set while the interrupt
is masked, and since it's unmasked immediately after, no additional flushes
are required in the various affinity setting routines.

The testing by Mitch Williams on his especially problematic system should
still be valid as I have only simplified the code, not changed the
functionality.

We currently have 7 drivers: cciss, mthca, cxgb3, forceth, s2io,
pcie/portdrv_core, and qla2xxx in 2.6.21 that are affected by this
problem when the hardware they driver is plugged into the right slot.

Given the difficulty of reproducing this bug and tracing it down to
anything that even remotely resembles a cause, even if people are
being affected we aren't likely to see many meaningful bug reports, and
the people who see this bug aren't likely to be able to reproduce this
bug in a timely fashion.  So it is best to get this problem fixed 
as soon as we can so people don't have problems.

Then if people do have a kernel message stating "No irq for vector" we
will know it is yet another novel cause that needs a complete new
investigation.

So here is a one liner that will hopefully be a part of 2.6.21.

Cc: Mitch Williams <mitch.a.williams@intel.com>
Cc: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 drivers/pci/msi.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index ad33e01..435c195 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -94,6 +94,7 @@ static void msi_set_mask_bit(unsigned int irq, int flag)
 		int offset = entry->msi_attrib.entry_nr * PCI_MSIX_ENTRY_SIZE +
 			PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET;
 		writel(flag, entry->mask_base + offset);
+		readl(entry->mask_base + offset);
 		break;
 	}
 	default:
-- 
1.5.0.4

