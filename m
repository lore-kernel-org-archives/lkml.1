Return-Path: <linux-kernel-owner+w=401wt.eu-S1753177AbZHSV0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbZHSV0M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 17:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbZHSV0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 17:26:11 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:26276 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144AbZHSV0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 17:26:10 -0400
Date: Wed, 19 Aug 2009 15:26:11 -0600
From: Troy Heber <troy.heber@hp.com>
To: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux-foundation.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] pci/dmar: correct off-by-one error
Message-ID: <20090819212611.GA7964@pc.troyhebe>
Mail-Followup-To: David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci/dmar: correct off-by-one error in dmar_fault()
    
DMAR faults are recorded into a ring of "fault recording registers".
fault_index is a 0-based index into the ring. The code allows the
0-based fault_index to be equal to the total number of fault registers
available from the cap_num_fault_regs() macro, which causes access
beyond the last available register. 
    
Signed-off-by Troy Heber <troy.heber@hp.com>

---
 drivers/pci/dmar.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index 7b287cb..c0c776f 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -1212,7 +1212,7 @@ irqreturn_t dmar_fault(int irq, void *dev_id)
 				source_id, guest_addr);
 
 		fault_index++;
-		if (fault_index > cap_num_fault_regs(iommu->cap))
+		if (fault_index >= cap_num_fault_regs(iommu->cap))
 			fault_index = 0;
 		spin_lock_irqsave(&iommu->register_lock, flag);
 	}
