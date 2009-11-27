Return-Path: <linux-kernel-owner+w=401wt.eu-S1754287AbZK0OAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287AbZK0OAG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 09:00:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676AbZK0N7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 08:59:40 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:53403
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752934AbZK0Nz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 08:55:58 -0500
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KTRTD2-01-6RM-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 10/34] x86/amd-iommu: Reimplement amd_iommu_flush_all_domains()
Date: Fri, 27 Nov 2009 14:55:21 +0100
Message-ID: <1259330145-14865-11-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
References: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Nov 2009 13:55:48.0045 (UTC) FILETIME=[528927D0:01CA6F69]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch reimplementes the amd_iommu_flush_all_domains
function to use the global protection domain list instead
of flushing every domain on every IOMMU.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 0c4319b..5141f56 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -530,10 +530,12 @@ static void flush_all_domains_on_iommu(struct amd_iommu *iommu)
 
 void amd_iommu_flush_all_domains(void)
 {
-	struct amd_iommu *iommu;
+	struct protection_domain *domain;
 
-	for_each_iommu(iommu)
-		flush_all_domains_on_iommu(iommu);
+	list_for_each_entry(domain, &amd_iommu_pd_list, list) {
+		iommu_flush_tlb_pde(domain);
+		iommu_flush_complete(domain);
+	}
 }
 
 static void flush_all_devices_for_iommu(struct amd_iommu *iommu)
-- 
1.6.5.3


