Return-Path: <linux-kernel-owner+w=401wt.eu-S933591AbZIDJpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933591AbZIDJpt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 05:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933463AbZIDJpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 05:45:43 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:22640
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933555AbZIDJpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 05:45:40 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KPFXRW-02-2ES-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 4/8] x86/amd-iommu: Add function to flush all DTEs on one IOMMU
Date: Fri, 4 Sep 2009 11:44:38 +0200
Message-ID: <1252057482-32207-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1252057482-32207-1-git-send-email-joerg.roedel@amd.com>
References: <1252057482-32207-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 04 Sep 2009 09:44:45.0226 (UTC) FILETIME=[55B260A0:01CA2D44]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function flushes all DTE entries on one IOMMU for all
devices behind this IOMMU. This is required for command
buffer resetting later.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 64cc582..2dc0933 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -516,6 +516,19 @@ void amd_iommu_flush_all_domains(void)
 		flush_all_domains_on_iommu(iommu);
 }
 
+static void flush_all_devices_for_iommu(struct amd_iommu *iommu)
+{
+	int i;
+
+	for (i = 0; i <= amd_iommu_last_bdf; ++i) {
+		if (iommu != amd_iommu_rlookup_table[i])
+			continue;
+
+		iommu_queue_inv_dev_entry(iommu, i);
+		iommu_completion_wait(iommu);
+	}
+}
+
 void amd_iommu_flush_all_devices(void)
 {
 	struct amd_iommu *iommu;
-- 
1.6.3.3


