Return-Path: <linux-kernel-owner+w=401wt.eu-S933348AbZIDJiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933348AbZIDJiV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 05:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755783AbZIDJiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 05:38:19 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:38648 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755740AbZIDJiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 05:38:18 -0400
X-SpamScore: 5
X-BigFish: VPS5(zba6lzzz1202hzzz32i203h63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KPFXFL-02-285-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6/8] x86/amd-iommu: Make sure a device is assigned in passthrough mode
Date: Fri, 4 Sep 2009 11:36:32 +0200
Message-ID: <1252056994-31980-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1252056994-31980-1-git-send-email-joerg.roedel@amd.com>
References: <1252056994-31980-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 04 Sep 2009 09:36:43.0201 (UTC) FILETIME=[36633310:01CA2D43]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the IOMMU driver runs in passthrough mode it has to
make sure that every device not assigned to an IOMMU-API
domain must be put into the passthrough domain instead of
keeping it unassigned.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 9aa135d..a8e74c3 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1141,6 +1141,15 @@ static void __detach_device(struct protection_domain *domain, u16 devid)
 
 	/* ready */
 	spin_unlock(&domain->lock);
+
+	/*
+	 * If we run in passthrough mode the device must be assigned to the
+	 * passthrough domain if it is detached from any other domain
+	 */
+	if (iommu_pass_through) {
+		struct amd_iommu *iommu = amd_iommu_rlookup_table[devid];
+		__attach_device(iommu, pt_domain, devid);
+	}
 }
 
 /*
-- 
1.6.3.3


