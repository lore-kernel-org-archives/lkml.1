Return-Path: <linux-kernel-owner+w=401wt.eu-S933448AbZIDJig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933448AbZIDJig (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 05:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933436AbZIDJie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 05:38:34 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:26472
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755785AbZIDJia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 05:38:30 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KPFXFS-01-4LZ-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/8] x86/amd-iommu: Add core functions for pd allocation/freeing
Date: Fri, 4 Sep 2009 11:36:28 +0200
Message-ID: <1252056994-31980-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1252056994-31980-1-git-send-email-joerg.roedel@amd.com>
References: <1252056994-31980-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 04 Sep 2009 09:36:43.0201 (UTC) FILETIME=[36633310:01CA2D43]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch factors some code of protection domain allocation
into seperate functions. This way the logic can be used to
allocate the passthrough domain later. As a side effect this
patch fixes an unlikely domain id leakage bug.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   36 ++++++++++++++++++++++++++++++++----
 1 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 6c99f50..0934348 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1988,19 +1988,47 @@ static void cleanup_domain(struct protection_domain *domain)
 	write_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
 }
 
-static int amd_iommu_domain_init(struct iommu_domain *dom)
+static void protection_domain_free(struct protection_domain *domain)
+{
+	if (!domain)
+		return;
+
+	if (domain->id)
+		domain_id_free(domain->id);
+
+	kfree(domain);
+}
+
+static struct protection_domain *protection_domain_alloc(void)
 {
 	struct protection_domain *domain;
 
 	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
 	if (!domain)
-		return -ENOMEM;
+		return NULL;
 
 	spin_lock_init(&domain->lock);
-	domain->mode = PAGE_MODE_3_LEVEL;
 	domain->id = domain_id_alloc();
 	if (!domain->id)
+		goto out_err;
+
+	return domain;
+
+out_err:
+	kfree(domain);
+
+	return NULL;
+}
+
+static int amd_iommu_domain_init(struct iommu_domain *dom)
+{
+	struct protection_domain *domain;
+
+	domain = protection_domain_alloc();
+	if (!domain)
 		goto out_free;
+
+	domain->mode    = PAGE_MODE_3_LEVEL;
 	domain->pt_root = (void *)get_zeroed_page(GFP_KERNEL);
 	if (!domain->pt_root)
 		goto out_free;
@@ -2010,7 +2038,7 @@ static int amd_iommu_domain_init(struct iommu_domain *dom)
 	return 0;
 
 out_free:
-	kfree(domain);
+	protection_domain_free(domain);
 
 	return -ENOMEM;
 }
-- 
1.6.3.3


