Return-Path: <linux-kernel-owner+w=401wt.eu-S1758064AbZEVMQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064AbZEVMQV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 08:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757960AbZEVMP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 08:15:58 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:44638 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758038AbZEVMP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 08:15:56 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j)
X-FB-SS: 5,
X-WSS-ID: 0KK1OQ7-04-9XQ-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/9] amd-iommu: introduce for_each_iommu* macros
Date: Fri, 22 May 2009 14:15:32 +0200
Message-ID: <1242994540-28799-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1242994540-28799-1-git-send-email-joerg.roedel@amd.com>
References: <1242994540-28799-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 May 2009 12:15:42.0110 (UTC) FILETIME=[06A573E0:01C9DAD7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: simplify iterating over all iommus in the system

This patch introduces the for_each_iommu and for_each_iommu_safe macros
to simplify the developers life when having to iterate over all AMD
IOMMUs in the system.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |    8 ++++++++
 arch/x86/kernel/amd_iommu.c            |    8 ++++----
 arch/x86/kernel/amd_iommu_init.c       |    8 ++++----
 3 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index 95c8cd9..cf5ef17 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -196,6 +196,14 @@
 					      domain for an IOMMU */
 
 /*
+ * Make iterating over all IOMMUs easier
+ */
+#define for_each_iommu(iommu) \
+	list_for_each_entry((iommu), &amd_iommu_list, list)
+#define for_each_iommu_safe(iommu, next) \
+	list_for_each_entry_safe((iommu), (next), &amd_iommu_list, list)
+
+/*
  * This structure contains generic data for  IOMMU protection domains
  * independent of their use.
  */
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index a97db99..d9e9dc1 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -213,7 +213,7 @@ irqreturn_t amd_iommu_int_handler(int irq, void *data)
 {
 	struct amd_iommu *iommu;
 
-	list_for_each_entry(iommu, &amd_iommu_list, list)
+	for_each_iommu(iommu)
 		iommu_poll_events(iommu);
 
 	return IRQ_HANDLED;
@@ -440,7 +440,7 @@ static void iommu_flush_domain(u16 domid)
 	__iommu_build_inv_iommu_pages(&cmd, CMD_INV_IOMMU_ALL_PAGES_ADDRESS,
 				      domid, 1, 1);
 
-	list_for_each_entry(iommu, &amd_iommu_list, list) {
+	for_each_iommu(iommu) {
 		spin_lock_irqsave(&iommu->lock, flags);
 		__iommu_queue_command(iommu, &cmd);
 		__iommu_completion_wait(iommu);
@@ -1672,7 +1672,7 @@ int __init amd_iommu_init_dma_ops(void)
 	 * found in the system. Devices not assigned to any other
 	 * protection domain will be assigned to the default one.
 	 */
-	list_for_each_entry(iommu, &amd_iommu_list, list) {
+	for_each_iommu(iommu) {
 		iommu->default_dom = dma_ops_domain_alloc(iommu, order);
 		if (iommu->default_dom == NULL)
 			return -ENOMEM;
@@ -1710,7 +1710,7 @@ int __init amd_iommu_init_dma_ops(void)
 
 free_domains:
 
-	list_for_each_entry(iommu, &amd_iommu_list, list) {
+	for_each_iommu(iommu) {
 		if (iommu->default_dom)
 			dma_ops_domain_free(iommu->default_dom);
 	}
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 8c0be09..675a4b6 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -679,7 +679,7 @@ static void __init free_iommu_all(void)
 {
 	struct amd_iommu *iommu, *next;
 
-	list_for_each_entry_safe(iommu, next, &amd_iommu_list, list) {
+	for_each_iommu_safe(iommu, next) {
 		list_del(&iommu->list);
 		free_iommu_one(iommu);
 		kfree(iommu);
@@ -779,7 +779,7 @@ static int __init iommu_setup_msix(struct amd_iommu *iommu)
 	struct msix_entry entries[32]; /* only 32 supported by AMD IOMMU */
 	int nvec = 0, i;
 
-	list_for_each_entry(curr, &amd_iommu_list, list) {
+	for_each_iommu(curr) {
 		if (curr->dev == iommu->dev) {
 			entries[nvec].entry = curr->evt_msi_num;
 			entries[nvec].vector = 0;
@@ -818,7 +818,7 @@ static int __init iommu_setup_msi(struct amd_iommu *iommu)
 	int r;
 	struct amd_iommu *curr;
 
-	list_for_each_entry(curr, &amd_iommu_list, list) {
+	for_each_iommu(curr) {
 		if (curr->dev == iommu->dev)
 			curr->int_enabled = true;
 	}
@@ -971,7 +971,7 @@ static void __init enable_iommus(void)
 {
 	struct amd_iommu *iommu;
 
-	list_for_each_entry(iommu, &amd_iommu_list, list) {
+	for_each_iommu(iommu) {
 		iommu_set_exclusion_range(iommu);
 		iommu_init_msi(iommu);
 		iommu_enable_event_logging(iommu);
-- 
1.6.3.1


