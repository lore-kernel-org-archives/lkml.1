Return-Path: <linux-kernel-owner+w=401wt.eu-S1756856AbYLIO2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856AbYLIO2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 09:28:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753125AbYLIORf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 09:17:35 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:39476 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479AbYLIOQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 09:16:30 -0500
X-BigFish: VPS3(zzzzzzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-FB-SS: 5,
X-WSS-ID: 0KBM4Z9-03-KKV-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 14/21] AMD IOMMU: add domain init function for IOMMU API
Date: Tue, 9 Dec 2008 15:16:11 +0100
Message-ID: <1228832178-13429-15-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1228832178-13429-14-git-send-email-joerg.roedel@amd.com>
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
 <1228832178-13429-14-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 09 Dec 2008 14:16:19.0192 (UTC) FILETIME=[B4898780:01C95A08]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: add a generic function for allocation protection domains

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 26b929b..cb7db66 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -22,6 +22,7 @@
 #include <linux/bitops.h>
 #include <linux/scatterlist.h>
 #include <linux/iommu-helper.h>
+#include <linux/iommu.h>
 #include <asm/proto.h>
 #include <asm/iommu.h>
 #include <asm/amd_iommu_types.h>
@@ -1524,3 +1525,30 @@ static void cleanup_domain(struct protection_domain *domain)
 
 	write_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
 }
+
+static int amd_iommu_domain_init(struct iommu_domain *dom)
+{
+	struct protection_domain *domain;
+
+	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
+	if (!domain)
+		return -ENOMEM;
+
+	spin_lock_init(&domain->lock);
+	domain->mode = PAGE_MODE_3_LEVEL;
+	domain->id = domain_id_alloc();
+	if (!domain->id)
+		goto out_free;
+	domain->pt_root = (void *)get_zeroed_page(GFP_KERNEL);
+	if (!domain->pt_root)
+		goto out_free;
+
+	dom->priv = domain;
+
+	return 0;
+
+out_free:
+	kfree(domain);
+
+	return -ENOMEM;
+}
-- 
1.5.6.4


