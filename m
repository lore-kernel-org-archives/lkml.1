Return-Path: <linux-kernel-owner+w=401wt.eu-S1753866AbZK0N4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbZK0N4w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 08:56:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753604AbZK0N4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 08:56:51 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:18587 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310AbZK0N4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 08:56:11 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KTRTD7-01-6RX-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 32/34] x86/amd-iommu: Cleanup DTE flushing code
Date: Fri, 27 Nov 2009 14:55:43 +0100
Message-ID: <1259330145-14865-33-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
References: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Nov 2009 13:55:48.0623 (UTC) FILETIME=[52E159F0:01CA6F69]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up the code to flush device table entries
in the IOMMU. With this chance the driver can get rid of the
iommu_queue_inv_dev_entry() function.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |    1 +
 arch/x86/kernel/amd_iommu.c            |  100 +++++++++++---------------------
 2 files changed, 35 insertions(+), 66 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index 93953d1..f92d1b3 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -253,6 +253,7 @@ struct protection_domain {
  */
 struct iommu_dev_data {
 	struct list_head list;		  /* For domain->dev_list */
+	struct device *dev;		  /* Device this data belong to */
 	struct device *alias;		  /* The Alias Device */
 	struct protection_domain *domain; /* Domain the device is bound to */
 	atomic_t bind;			  /* Domain attach reverent count */
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 41c4ebe..0eafca5 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -146,6 +146,8 @@ static int iommu_init_device(struct device *dev)
 	if (!dev_data)
 		return -ENOMEM;
 
+	dev_data->dev = dev;
+
 	devid = get_device_id(dev);
 	alias = amd_iommu_alias_table[devid];
 	pdev = pci_get_bus_and_slot(PCI_BUS(alias), alias & 0xff);
@@ -478,31 +480,21 @@ static void iommu_flush_complete(struct protection_domain *domain)
 /*
  * Command send function for invalidating a device table entry
  */
-static int iommu_queue_inv_dev_entry(struct amd_iommu *iommu, u16 devid)
-{
-	struct iommu_cmd cmd;
-	int ret;
-
-	BUG_ON(iommu == NULL);
-
-	memset(&cmd, 0, sizeof(cmd));
-	CMD_SET_TYPE(&cmd, CMD_INV_DEV_ENTRY);
-	cmd.data[0] = devid;
-
-	ret = iommu_queue_command(iommu, &cmd);
-
-	return ret;
-}
-
 static int iommu_flush_device(struct device *dev)
 {
 	struct amd_iommu *iommu;
+	struct iommu_cmd cmd;
 	u16 devid;
 
 	devid = get_device_id(dev);
 	iommu = amd_iommu_rlookup_table[devid];
 
-	return iommu_queue_inv_dev_entry(iommu, devid);
+	/* Build command */
+	memset(&cmd, 0, sizeof(cmd));
+	CMD_SET_TYPE(&cmd, CMD_INV_DEV_ENTRY);
+	cmd.data[0] = devid;
+
+	return iommu_queue_command(iommu, &cmd);
 }
 
 static void __iommu_build_inv_iommu_pages(struct iommu_cmd *cmd, u64 address,
@@ -592,30 +584,43 @@ static void iommu_flush_tlb_pde(struct protection_domain *domain)
 	__iommu_flush_pages(domain, 0, CMD_INV_IOMMU_ALL_PAGES_ADDRESS, 1);
 }
 
+
 /*
- * This function flushes all domains that have devices on the given IOMMU
+ * This function flushes the DTEs for all devices in domain
  */
-static void flush_all_domains_on_iommu(struct amd_iommu *iommu)
+static void iommu_flush_domain_devices(struct protection_domain *domain)
+{
+	struct iommu_dev_data *dev_data;
+	unsigned long flags;
+
+	spin_lock_irqsave(&domain->lock, flags);
+
+	list_for_each_entry(dev_data, &domain->dev_list, list)
+		iommu_flush_device(dev_data->dev);
+
+	spin_unlock_irqrestore(&domain->lock, flags);
+}
+
+static void iommu_flush_all_domain_devices(void)
 {
-	u64 address = CMD_INV_IOMMU_ALL_PAGES_ADDRESS;
 	struct protection_domain *domain;
 	unsigned long flags;
 
 	spin_lock_irqsave(&amd_iommu_pd_lock, flags);
 
 	list_for_each_entry(domain, &amd_iommu_pd_list, list) {
-		if (domain->dev_iommu[iommu->index] == 0)
-			continue;
-
-		spin_lock(&domain->lock);
-		iommu_queue_inv_iommu_pages(iommu, address, domain->id, 1, 1);
+		iommu_flush_domain_devices(domain);
 		iommu_flush_complete(domain);
-		spin_unlock(&domain->lock);
 	}
 
 	spin_unlock_irqrestore(&amd_iommu_pd_lock, flags);
 }
 
+void amd_iommu_flush_all_devices(void)
+{
+	iommu_flush_all_domain_devices();
+}
+
 /*
  * This function uses heavy locking and may disable irqs for some time. But
  * this is no issue because it is only called during resume.
@@ -637,38 +642,6 @@ void amd_iommu_flush_all_domains(void)
 	spin_unlock_irqrestore(&amd_iommu_pd_lock, flags);
 }
 
-static void flush_all_devices_for_iommu(struct amd_iommu *iommu)
-{
-	int i;
-
-	for (i = 0; i <= amd_iommu_last_bdf; ++i) {
-		if (iommu != amd_iommu_rlookup_table[i])
-			continue;
-
-		iommu_queue_inv_dev_entry(iommu, i);
-		iommu_completion_wait(iommu);
-	}
-}
-
-static void flush_devices_by_domain(struct protection_domain *domain)
-{
-	struct amd_iommu *iommu;
-	int i;
-
-	for (i = 0; i <= amd_iommu_last_bdf; ++i) {
-		if ((domain == NULL && amd_iommu_pd_table[i] == NULL) ||
-		    (amd_iommu_pd_table[i] != domain))
-			continue;
-
-		iommu = amd_iommu_rlookup_table[i];
-		if (!iommu)
-			continue;
-
-		iommu_queue_inv_dev_entry(iommu, i);
-		iommu_completion_wait(iommu);
-	}
-}
-
 static void reset_iommu_command_buffer(struct amd_iommu *iommu)
 {
 	pr_err("AMD-Vi: Resetting IOMMU command buffer\n");
@@ -679,17 +652,12 @@ static void reset_iommu_command_buffer(struct amd_iommu *iommu)
 	iommu->reset_in_progress = true;
 
 	amd_iommu_reset_cmd_buffer(iommu);
-	flush_all_devices_for_iommu(iommu);
-	flush_all_domains_on_iommu(iommu);
+	amd_iommu_flush_all_devices();
+	amd_iommu_flush_all_domains();
 
 	iommu->reset_in_progress = false;
 }
 
-void amd_iommu_flush_all_devices(void)
-{
-	flush_devices_by_domain(NULL);
-}
-
 /****************************************************************************
  *
  * The functions below are used the create the page table mappings for
@@ -1692,7 +1660,7 @@ static void update_domain(struct protection_domain *domain)
 		return;
 
 	update_device_table(domain);
-	flush_devices_by_domain(domain);
+	iommu_flush_domain_devices(domain);
 	iommu_flush_tlb_pde(domain);
 
 	domain->updated = false;
-- 
1.6.5.3


