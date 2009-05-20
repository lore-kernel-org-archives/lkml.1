Return-Path: <linux-kernel-owner+w=401wt.eu-S1755151AbZETRnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbZETRnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 13:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754142AbZETRnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 13:43:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:39082 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753773AbZETRnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 13:43:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,222,1241420400"; 
   d="scan'208";a="145073639"
Date: Wed, 20 May 2009 10:42:59 -0700
From: Fenghua Yu <fenghua.yu@intel.com>
To: "'David Woodhouse'" <dwmw2@infradead.org>, "'Ingo Molnar'" <mingo@elte.hu>,
       "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
       "'IOMMU'" <iommu@lists.linux-foundation.org>
Subject: [PATCH] Time out for possible dead loops during queued invalidation wait
Message-ID: <20090520174259.GA10646@linux-os.sc.intel.com>
References: <20090327212241.234500000@intel.com> <20090327212321.070229000@intel.com> <20090416001957.GA1527@linux-os.sc.intel.com> <1240135508.3589.75.camel@macbook.infradead.org> <A6AD88C3F2289247BE726C37303E1EB8A4DF7DB1@orsmsx505.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A6AD88C3F2289247BE726C37303E1EB8A4DF7DB1@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two loops in qi_submit_sync() do not have time out. If hardware can not finish
the queued invalidation for some reason, the loops could end up in dead loops
without any hint for what is going on. I add time out for the loops and report
warning when time out happens.
 
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>

---

 dmar.c |   12 ++++++++++++
 1 files changed, 12 insertions(+)

diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index fa3a113..95baacd 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -637,6 +637,7 @@ int qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu)
 	struct qi_desc *hw, wait_desc;
 	int wait_index, index;
 	unsigned long flags;
+	cycles_t start_time;
 
 	if (!qi)
 		return 0;
@@ -644,8 +645,13 @@ int qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu)
 	hw = qi->desc;
 
 	spin_lock_irqsave(&qi->q_lock, flags);
+	start_time = get_cycles();
 	while (qi->free_cnt < 3) {
 		spin_unlock_irqrestore(&qi->q_lock, flags);
+		if (DMAR_OPERATION_TIMEOUT < (get_cycles() - start_time)) {
+			WARN(1, "No space in invalidation queue.\n");
+			return -ENOSPC;
+		}
 		cpu_relax();
 		spin_lock_irqsave(&qi->q_lock, flags);
 	}
@@ -675,6 +681,7 @@ int qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu)
 	 */
 	writel(qi->free_head << 4, iommu->reg + DMAR_IQT_REG);
 
+	start_time = get_cycles();
 	while (qi->desc_status[wait_index] != QI_DONE) {
 		/*
 		 * We will leave the interrupts disabled, to prevent interrupt
@@ -687,6 +694,11 @@ int qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu)
 		if (rc)
 			goto out;
 
+		if (DMAR_OPERATION_TIMEOUT < (get_cycles() - start_time)) {
+			WARN(1, "Queued invalidation can not complete.\n");
+			goto out;
+		}
+
 		spin_unlock(&qi->q_lock);
 		cpu_relax();
 		spin_lock(&qi->q_lock);
