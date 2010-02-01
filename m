Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab0BAPO5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 10:14:57 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:55475 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951Ab0BAPOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 10:14:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=pzn7mSJOOTQ/QLLBhYZVc6THH0ZKAP69PdeRFviT2e3Bv9Bap3RqGpZu1oEW02jV0c
         vsehXK35VcWgg64byR4U8dhPQOcX6rJ3lgKLpwCCh2p78P8drzg+AseK4bqj5EOALMD9
         m0xyCJlVcAFh9cC1UMtW30bTXwdQNQBJRhtBo=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux-foundation.org
Subject: [PATCH 6/9] intel-iommu: Use for_each_set_bit
Date: Tue,  2 Feb 2010 00:10:37 +0900
Message-Id: <1265037040-23413-6-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1265037040-23413-1-git-send-email-akinobu.mita@gmail.com>
References: <1265037040-23413-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2: rename for_each_bit to for_each_set_bit

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: iommu@lists.linux-foundation.org
---
 drivers/pci/intel-iommu.c |   33 +++++++--------------------------
 1 files changed, 7 insertions(+), 26 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 4173125..a0ac719 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -491,13 +491,11 @@ static void domain_update_iommu_coherency(struct dmar_domain *domain)
 
 	domain->iommu_coherency = 1;
 
-	i = find_first_bit(&domain->iommu_bmp, g_num_of_iommus);
-	for (; i < g_num_of_iommus; ) {
+	for_each_set_bit(i, &domain->iommu_bmp, g_num_of_iommus) {
 		if (!ecap_coherent(g_iommus[i]->ecap)) {
 			domain->iommu_coherency = 0;
 			break;
 		}
-		i = find_next_bit(&domain->iommu_bmp, g_num_of_iommus, i+1);
 	}
 }
 
@@ -507,13 +505,11 @@ static void domain_update_iommu_snooping(struct dmar_domain *domain)
 
 	domain->iommu_snooping = 1;
 
-	i = find_first_bit(&domain->iommu_bmp, g_num_of_iommus);
-	for (; i < g_num_of_iommus; ) {
+	for_each_set_bit(i, &domain->iommu_bmp, g_num_of_iommus) {
 		if (!ecap_sc_support(g_iommus[i]->ecap)) {
 			domain->iommu_snooping = 0;
 			break;
 		}
-		i = find_next_bit(&domain->iommu_bmp, g_num_of_iommus, i+1);
 	}
 }
 
@@ -1194,8 +1190,7 @@ void free_dmar_iommu(struct intel_iommu *iommu)
 	unsigned long flags;
 
 	if ((iommu->domains) && (iommu->domain_ids)) {
-		i = find_first_bit(iommu->domain_ids, cap_ndoms(iommu->cap));
-		for (; i < cap_ndoms(iommu->cap); ) {
+		for_each_set_bit(i, iommu->domain_ids, cap_ndoms(iommu->cap)) {
 			domain = iommu->domains[i];
 			clear_bit(i, iommu->domain_ids);
 
@@ -1207,9 +1202,6 @@ void free_dmar_iommu(struct intel_iommu *iommu)
 					domain_exit(domain);
 			}
 			spin_unlock_irqrestore(&domain->iommu_lock, flags);
-
-			i = find_next_bit(iommu->domain_ids,
-				cap_ndoms(iommu->cap), i+1);
 		}
 	}
 
@@ -1292,14 +1284,11 @@ static void iommu_detach_domain(struct dmar_domain *domain,
 
 	spin_lock_irqsave(&iommu->lock, flags);
 	ndomains = cap_ndoms(iommu->cap);
-	num = find_first_bit(iommu->domain_ids, ndomains);
-	for (; num < ndomains; ) {
+	for_each_set_bit(num, iommu->domain_ids, ndomains) {
 		if (iommu->domains[num] == domain) {
 			found = 1;
 			break;
 		}
-		num = find_next_bit(iommu->domain_ids,
-				    cap_ndoms(iommu->cap), num+1);
 	}
 
 	if (found) {
@@ -1485,15 +1474,12 @@ static int domain_context_mapping_one(struct dmar_domain *domain, int segment,
 
 		/* find an available domain id for this device in iommu */
 		ndomains = cap_ndoms(iommu->cap);
-		num = find_first_bit(iommu->domain_ids, ndomains);
-		for (; num < ndomains; ) {
+		for_each_set_bit(num, iommu->domain_ids, ndomains) {
 			if (iommu->domains[num] == domain) {
 				id = num;
 				found = 1;
 				break;
 			}
-			num = find_next_bit(iommu->domain_ids,
-					    cap_ndoms(iommu->cap), num+1);
 		}
 
 		if (found == 0) {
@@ -3441,12 +3427,9 @@ static int vm_domain_min_agaw(struct dmar_domain *domain)
 	int i;
 	int min_agaw = domain->agaw;
 
-	i = find_first_bit(&domain->iommu_bmp, g_num_of_iommus);
-	for (; i < g_num_of_iommus; ) {
+	for_each_set_bit(i, &domain->iommu_bmp, g_num_of_iommus) {
 		if (min_agaw > g_iommus[i]->agaw)
 			min_agaw = g_iommus[i]->agaw;
-
-		i = find_next_bit(&domain->iommu_bmp, g_num_of_iommus, i+1);
 	}
 
 	return min_agaw;
@@ -3512,8 +3495,7 @@ static void iommu_free_vm_domain(struct dmar_domain *domain)
 		iommu = drhd->iommu;
 
 		ndomains = cap_ndoms(iommu->cap);
-		i = find_first_bit(iommu->domain_ids, ndomains);
-		for (; i < ndomains; ) {
+		for_each_set_bit(i, iommu->domain_ids, ndomains) {
 			if (iommu->domains[i] == domain) {
 				spin_lock_irqsave(&iommu->lock, flags);
 				clear_bit(i, iommu->domain_ids);
@@ -3521,7 +3503,6 @@ static void iommu_free_vm_domain(struct dmar_domain *domain)
 				spin_unlock_irqrestore(&iommu->lock, flags);
 				break;
 			}
-			i = find_next_bit(iommu->domain_ids, ndomains, i+1);
 		}
 	}
 }
-- 
1.6.0.6

