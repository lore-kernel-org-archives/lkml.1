Return-Path: <linux-kernel-owner+w=401wt.eu-S933481AbZIDJoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933481AbZIDJoc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 05:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933461AbZIDJoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 05:44:30 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:26771 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933350AbZIDJmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 05:42:00 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KPFXLS-03-O1I-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 04/14] x86/amd-iommu: Add a gneric version of amd_iommu_flush_all_devices
Date: Fri, 4 Sep 2009 11:40:42 +0200
Message-ID: <1252057252-32074-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1252057252-32074-1-git-send-email-joerg.roedel@amd.com>
References: <1252057252-32074-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 04 Sep 2009 09:40:55.0299 (UTC) FILETIME=[CCA64D30:01CA2D43]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a generic variant of
amd_iommu_flush_all_devices function which flushes only the
DTEs for a given protection domain.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 4a54366..5265dd1 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -481,13 +481,14 @@ void amd_iommu_flush_all_domains(void)
 	}
 }
 
-void amd_iommu_flush_all_devices(void)
+static void flush_devices_by_domain(struct protection_domain *domain)
 {
 	struct amd_iommu *iommu;
 	int i;
 
 	for (i = 0; i <= amd_iommu_last_bdf; ++i) {
-		if (amd_iommu_pd_table[i] == NULL)
+		if ((domain == NULL && amd_iommu_pd_table[i] == NULL) ||
+		    (amd_iommu_pd_table[i] != domain))
 			continue;
 
 		iommu = amd_iommu_rlookup_table[i];
@@ -499,6 +500,11 @@ void amd_iommu_flush_all_devices(void)
 	}
 }
 
+void amd_iommu_flush_all_devices(void)
+{
+	flush_devices_by_domain(NULL);
+}
+
 /****************************************************************************
  *
  * The functions below are used the create the page table mappings for
-- 
1.6.3.3


