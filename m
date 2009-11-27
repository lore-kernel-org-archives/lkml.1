Return-Path: <linux-kernel-owner+w=401wt.eu-S1754589AbZK0OC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbZK0OC1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 09:02:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754533AbZK0OCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 09:02:19 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:49814
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752711AbZK0Nzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 08:55:53 -0500
X-SpamScore: -2
X-BigFish: VPS-2(z78cMzzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KTRTCZ-01-6RH-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 04/34] x86/amd-iommu: Add per IOMMU reference counting
Date: Fri, 27 Nov 2009 14:55:15 +0100
Message-ID: <1259330145-14865-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
References: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Nov 2009 13:55:47.0764 (UTC) FILETIME=[525E4740:01CA6F69]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds reference counting for protection domains
per IOMMU. This allows a smarter TLB flushing strategy.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |    2 ++
 arch/x86/kernel/amd_iommu.c            |   12 +++++++++---
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index ab3e7bf..e68b148 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -238,7 +238,9 @@ struct protection_domain {
 	unsigned long flags;	/* flags to find out type of domain */
 	bool updated;		/* complete domain flush required */
 	unsigned dev_cnt;	/* devices assigned to this domain */
+	unsigned dev_iommu[MAX_IOMMUS]; /* per-IOMMU reference count */
 	void *priv;		/* private data */
+
 };
 
 /*
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 7fe28be..8c38f00 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1175,7 +1175,9 @@ static void __attach_device(struct amd_iommu *iommu,
 	/* update DTE entry */
 	set_dte_entry(devid, domain);
 
-	domain->dev_cnt += 1;
+	/* Do reference counting */
+	domain->dev_iommu[iommu->index] += 1;
+	domain->dev_cnt                 += 1;
 
 	/* ready */
 	spin_unlock(&domain->lock);
@@ -1209,6 +1211,9 @@ static void attach_device(struct amd_iommu *iommu,
  */
 static void __detach_device(struct protection_domain *domain, u16 devid)
 {
+	struct amd_iommu *iommu = amd_iommu_rlookup_table[devid];
+
+	BUG_ON(!iommu);
 
 	/* lock domain */
 	spin_lock(&domain->lock);
@@ -1223,8 +1228,9 @@ static void __detach_device(struct protection_domain *domain, u16 devid)
 
 	amd_iommu_apply_erratum_63(devid);
 
-	/* decrease reference counter */
-	domain->dev_cnt -= 1;
+	/* decrease reference counters */
+	domain->dev_iommu[iommu->index] -= 1;
+	domain->dev_cnt                 -= 1;
 
 	/* ready */
 	spin_unlock(&domain->lock);
-- 
1.6.5.3


