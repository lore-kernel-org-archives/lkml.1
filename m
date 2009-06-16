Return-Path: <linux-kernel-owner+w=401wt.eu-S1756527AbZFPI5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527AbZFPI5q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 04:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755875AbZFPI4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 04:56:40 -0400
Received: from wa4ehsobe003.messaging.microsoft.com ([216.32.181.13]:33995
	"EHLO WA4EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753803AbZFPI4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 04:56:39 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i17ch43j63h)
X-Spam-TCS-SCL: 2:0
X-FB-SS: 5,
X-WSS-ID: 0KLBQ5Z-04-3FU-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 4/6] amd-iommu: disable cmd buffer and evt logging before reprogramming iommu
Date: Tue, 16 Jun 2009 10:56:13 +0200
Message-ID: <1245142575-7166-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245142575-7166-1-git-send-email-joerg.roedel@amd.com>
References: <1245142575-7166-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 16 Jun 2009 08:56:17.0663 (UTC) FILETIME=[4F9B78F0:01C9EE60]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Wright <chrisw@sous-sol.org>

The IOMMU spec states that IOMMU behavior may be undefined when the
IOMMU registers are rewritten while command or event buffer is enabled.
Disable them in IOMMU disable path.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 575ca46..48a79b9 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -260,6 +260,14 @@ static void iommu_enable(struct amd_iommu *iommu)
 
 static void iommu_disable(struct amd_iommu *iommu)
 {
+	/* Disable command buffer */
+	iommu_feature_disable(iommu, CONTROL_CMDBUF_EN);
+
+	/* Disable event logging and event interrupts */
+	iommu_feature_disable(iommu, CONTROL_EVT_INT_EN);
+	iommu_feature_disable(iommu, CONTROL_EVT_LOG_EN);
+
+	/* Disable IOMMU hardware itself */
 	iommu_feature_disable(iommu, CONTROL_IOMMU_EN);
 }
 
@@ -1042,6 +1050,7 @@ static void enable_iommus(void)
 	struct amd_iommu *iommu;
 
 	for_each_iommu(iommu) {
+		iommu_disable(iommu);
 		iommu_set_device_table(iommu);
 		iommu_enable_command_buffer(iommu);
 		iommu_enable_event_buffer(iommu);
-- 
1.6.3.1


