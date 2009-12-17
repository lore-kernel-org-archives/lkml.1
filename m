Return-Path: <linux-kernel-owner+w=401wt.eu-S936259AbZLQEHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936259AbZLQEHv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:07:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936188AbZLQEHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:07:18 -0500
Received: from kroah.org ([198.145.64.141]:52312 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936232AbZLQEF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:05:59 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:57:02 2009
Message-Id: <20091217035702.183430151@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:57:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Chris Wright <chrisw@sous-sol.org>,
       David Woodhouse <David.Woodhouse@intel.com>
Subject: [148/151] intel-iommu: ignore page table validation in pass through mode
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Wright <chrisw@sous-sol.org>

commit 1672af1164d3d50ba8908014fd34cc0b58afdc1e upstream.

We are seeing a bug when booting w/ iommu=pt with current upstream
(bisect blames 19943b0e30b05d42e494ae6fef78156ebc8c637e "intel-iommu:
Unify hardware and software passthrough support).

The issue is specific to this loop during identity map initialization
of each device:

domain_context_mapping_one(si_domain, ..., CONTEXT_TT_PASS_THROUGH)
...
		/* Skip top levels of page tables for
		* iommu which has less agaw than default.
		*/
		for (agaw = domain->agaw; agaw != iommu->agaw; agaw--) {
			pgd = phys_to_virt(dma_pte_addr(pgd));
			if (!dma_pte_present(pgd)) {      <------ failing here
				spin_unlock_irqrestore(&iommu->lock, flags);
			return -ENOMEM;
		}

This box has 2 iommu's in it.  The catchall iommu has MGAW == 48, and
SAGAW == 4.  The other iommu has MGAW == 39, SAGAW == 2.

The device that's failing the above pgd test is the only device connected
to the non-catchall iommu, which has a smaller address width than the
domain default.  This test is not necessary since the context is in PT
mode and the ASR is ignored.

Thanks to Don Dutile for discovering and debugging this one.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/intel-iommu.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -1523,12 +1523,15 @@ static int domain_context_mapping_one(st
 
 		/* Skip top levels of page tables for
 		 * iommu which has less agaw than default.
+		 * Unnecessary for PT mode.
 		 */
-		for (agaw = domain->agaw; agaw != iommu->agaw; agaw--) {
-			pgd = phys_to_virt(dma_pte_addr(pgd));
-			if (!dma_pte_present(pgd)) {
-				spin_unlock_irqrestore(&iommu->lock, flags);
-				return -ENOMEM;
+		if (translation != CONTEXT_TT_PASS_THROUGH) {
+			for (agaw = domain->agaw; agaw != iommu->agaw; agaw--) {
+				pgd = phys_to_virt(dma_pte_addr(pgd));
+				if (!dma_pte_present(pgd)) {
+					spin_unlock_irqrestore(&iommu->lock, flags);
+					return -ENOMEM;
+				}
 			}
 		}
 	}


