Return-Path: <linux-kernel-owner+w=401wt.eu-S1755515AbYLIOWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515AbYLIOWh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 09:22:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753257AbYLIOQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 09:16:51 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:52848 "EHLO
	WA4EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbYLIOQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 09:16:31 -0500
X-BigFish: VPS3(zzzzzzz32i43j67h)
X-Spam-TCS-SCL: 6:0
X-WSS-ID: 0KBM4Z8-03-KKQ-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 13/21] AMD IOMMU: add domain cleanup helper function
Date: Tue, 9 Dec 2008 15:16:10 +0100
Message-ID: <1228832178-13429-14-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1228832178-13429-13-git-send-email-joerg.roedel@amd.com>
References: <20081209141143.GW12816@amd.com>
 <1228832178-13429-1-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-2-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-3-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-4-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-5-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-6-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-7-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-8-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-9-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-10-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-11-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-12-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-13-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 09 Dec 2008 14:16:19.0146 (UTC) FILETIME=[B48282A0:01C95A08]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: add a function to remove all devices from a domain

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 47158e3..26b929b 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1510,3 +1510,17 @@ static void detach_device(struct protection_domain *domain, u16 devid)
 	__detach_device(domain, devid);
 	write_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
 }
+
+static void cleanup_domain(struct protection_domain *domain)
+{
+	unsigned long flags;
+	u16 devid;
+
+	write_lock_irqsave(&amd_iommu_devtable_lock, flags);
+
+	for (devid = 0; devid <= amd_iommu_last_bdf; ++devid)
+		if (amd_iommu_pd_table[devid] == domain)
+			__detach_device(domain, devid);
+
+	write_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
+}
-- 
1.5.6.4


