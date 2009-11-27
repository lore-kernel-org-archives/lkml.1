Return-Path: <linux-kernel-owner+w=401wt.eu-S1753773AbZK0N6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773AbZK0N6V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 08:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbZK0N6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 08:58:20 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:36113 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362AbZK0N4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 08:56:03 -0500
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KTRTD5-01-6RT-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 19/34] x86/amd-iommu: Let domain_for_device handle aliases
Date: Fri, 27 Nov 2009 14:55:30 +0100
Message-ID: <1259330145-14865-20-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
References: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Nov 2009 13:55:48.0592 (UTC) FILETIME=[52DC9F00:01CA6F69]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there is no domain associated to a device yet and the
device has an alias device which already has a domain, the
original device needs to have the same domain as the alias
device.
This patch changes domain_for_device to handle this
situation and directly assigns the alias device domain to
the device in this situation.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |  227 +++++++++++++++++++++++++-----------------
 1 files changed, 135 insertions(+), 92 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 2cd5800..75470ff 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -71,6 +71,19 @@ static u64 *fetch_pte(struct protection_domain *domain,
 		      unsigned long address, int map_size);
 static void update_domain(struct protection_domain *domain);
 
+/****************************************************************************
+ *
+ * Helper functions
+ *
+ ****************************************************************************/
+
+static inline u16 get_device_id(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	return calc_devid(pdev->bus->number, pdev->devfn);
+}
+
 #ifdef CONFIG_AMD_IOMMU_STATS
 
 /*
@@ -1174,26 +1187,13 @@ static bool dma_ops_domain(struct protection_domain *domain)
 	return domain->flags & PD_DMA_OPS_MASK;
 }
 
-/*
- * Find out the protection domain structure for a given PCI device. This
- * will give us the pointer to the page table root for example.
- */
-static struct protection_domain *domain_for_device(u16 devid)
-{
-	struct protection_domain *dom;
-	unsigned long flags;
-
-	read_lock_irqsave(&amd_iommu_devtable_lock, flags);
-	dom = amd_iommu_pd_table[devid];
-	read_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
-
-	return dom;
-}
-
 static void set_dte_entry(u16 devid, struct protection_domain *domain)
 {
+	struct amd_iommu *iommu = amd_iommu_rlookup_table[devid];
 	u64 pte_root = virt_to_phys(domain->pt_root);
 
+	BUG_ON(amd_iommu_pd_table[devid] != NULL);
+
 	pte_root |= (domain->mode & DEV_ENTRY_MODE_MASK)
 		    << DEV_ENTRY_MODE_SHIFT;
 	pte_root |= IOMMU_PTE_IR | IOMMU_PTE_IW | IOMMU_PTE_P | IOMMU_PTE_TV;
@@ -1203,42 +1203,87 @@ static void set_dte_entry(u16 devid, struct protection_domain *domain)
 	amd_iommu_dev_table[devid].data[0] = lower_32_bits(pte_root);
 
 	amd_iommu_pd_table[devid] = domain;
+
+	/* Do reference counting */
+	domain->dev_iommu[iommu->index] += 1;
+	domain->dev_cnt                 += 1;
+
+	/* Flush the changes DTE entry */
+	iommu_queue_inv_dev_entry(iommu, devid);
+}
+
+static void clear_dte_entry(u16 devid)
+{
+	struct protection_domain *domain = amd_iommu_pd_table[devid];
+	struct amd_iommu *iommu = amd_iommu_rlookup_table[devid];
+
+	BUG_ON(domain == NULL);
+
+	/* remove domain from the lookup table */
+	amd_iommu_pd_table[devid] = NULL;
+
+	/* remove entry from the device table seen by the hardware */
+	amd_iommu_dev_table[devid].data[0] = IOMMU_PTE_P | IOMMU_PTE_TV;
+	amd_iommu_dev_table[devid].data[1] = 0;
+	amd_iommu_dev_table[devid].data[2] = 0;
+
+	amd_iommu_apply_erratum_63(devid);
+
+	/* decrease reference counters */
+	domain->dev_iommu[iommu->index] -= 1;
+	domain->dev_cnt                 -= 1;
+
+	iommu_queue_inv_dev_entry(iommu, devid);
 }
 
 /*
  * If a device is not yet associated with a domain, this function does
  * assigns it visible for the hardware
  */
-static void __attach_device(struct amd_iommu *iommu,
-			    struct protection_domain *domain,
-			    u16 devid)
+static int __attach_device(struct device *dev,
+			   struct protection_domain *domain)
 {
+	u16 devid = get_device_id(dev);
+	u16 alias = amd_iommu_alias_table[devid];
+
 	/* lock domain */
 	spin_lock(&domain->lock);
 
-	/* update DTE entry */
-	set_dte_entry(devid, domain);
+	/* Some sanity checks */
+	if (amd_iommu_pd_table[alias] != NULL &&
+	    amd_iommu_pd_table[alias] != domain)
+		return -EBUSY;
 
-	/* Do reference counting */
-	domain->dev_iommu[iommu->index] += 1;
-	domain->dev_cnt                 += 1;
+	if (amd_iommu_pd_table[devid] != NULL &&
+	    amd_iommu_pd_table[devid] != domain)
+		return -EBUSY;
+
+	/* Do real assignment */
+	if (alias != devid &&
+	    amd_iommu_pd_table[alias] == NULL)
+		set_dte_entry(alias, domain);
+
+	if (amd_iommu_pd_table[devid] == NULL)
+		set_dte_entry(devid, domain);
 
 	/* ready */
 	spin_unlock(&domain->lock);
+
+	return 0;
 }
 
 /*
  * If a device is not yet associated with a domain, this function does
  * assigns it visible for the hardware
  */
-static void attach_device(struct amd_iommu *iommu,
-			  struct protection_domain *domain,
-			  u16 devid)
+static int attach_device(struct device *dev,
+			 struct protection_domain *domain)
 {
 	unsigned long flags;
+	int ret;
 
 	write_lock_irqsave(&amd_iommu_devtable_lock, flags);
-	__attach_device(iommu, domain, devid);
+	ret = __attach_device(dev, domain);
 	write_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
 
 	/*
@@ -1246,62 +1291,70 @@ static void attach_device(struct amd_iommu *iommu,
 	 * left the caches in the IOMMU dirty. So we have to flush
 	 * here to evict all dirty stuff.
 	 */
-	iommu_queue_inv_dev_entry(iommu, devid);
 	iommu_flush_tlb_pde(domain);
+
+	return ret;
 }
 
 /*
  * Removes a device from a protection domain (unlocked)
  */
-static void __detach_device(struct protection_domain *domain, u16 devid)
+static void __detach_device(struct device *dev)
 {
+	u16 devid = get_device_id(dev);
 	struct amd_iommu *iommu = amd_iommu_rlookup_table[devid];
 
 	BUG_ON(!iommu);
 
-	/* lock domain */
-	spin_lock(&domain->lock);
-
-	/* remove domain from the lookup table */
-	amd_iommu_pd_table[devid] = NULL;
-
-	/* remove entry from the device table seen by the hardware */
-	amd_iommu_dev_table[devid].data[0] = IOMMU_PTE_P | IOMMU_PTE_TV;
-	amd_iommu_dev_table[devid].data[1] = 0;
-	amd_iommu_dev_table[devid].data[2] = 0;
-
-	amd_iommu_apply_erratum_63(devid);
-
-	/* decrease reference counters */
-	domain->dev_iommu[iommu->index] -= 1;
-	domain->dev_cnt                 -= 1;
-
-	/* ready */
-	spin_unlock(&domain->lock);
+	clear_dte_entry(devid);
 
 	/*
 	 * If we run in passthrough mode the device must be assigned to the
 	 * passthrough domain if it is detached from any other domain
 	 */
-	if (iommu_pass_through) {
-		struct amd_iommu *iommu = amd_iommu_rlookup_table[devid];
-		__attach_device(iommu, pt_domain, devid);
-	}
+	if (iommu_pass_through)
+		__attach_device(dev, pt_domain);
 }
 
 /*
  * Removes a device from a protection domain (with devtable_lock held)
  */
-static void detach_device(struct protection_domain *domain, u16 devid)
+static void detach_device(struct device *dev)
 {
 	unsigned long flags;
 
 	/* lock device table */
 	write_lock_irqsave(&amd_iommu_devtable_lock, flags);
-	__detach_device(domain, devid);
+	__detach_device(dev);
 	write_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
 }
 
+/*
+ * Find out the protection domain structure for a given PCI device. This
+ * will give us the pointer to the page table root for example.
+ */
+static struct protection_domain *domain_for_device(struct device *dev)
+{
+	struct protection_domain *dom;
+	unsigned long flags;
+	u16 devid, alias;
+
+	devid = get_device_id(dev);
+	alias = amd_iommu_alias_table[devid];
+
+	read_lock_irqsave(&amd_iommu_devtable_lock, flags);
+	dom = amd_iommu_pd_table[devid];
+	if (dom == NULL &&
+	    amd_iommu_pd_table[alias] != NULL) {
+		__attach_device(dev, amd_iommu_pd_table[alias]);
+		dom = amd_iommu_pd_table[devid];
+	}
+
+	read_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
+
+	return dom;
+}
+
 static int device_change_notifier(struct notifier_block *nb,
 				  unsigned long action, void *data)
 {
@@ -1322,7 +1375,7 @@ static int device_change_notifier(struct notifier_block *nb,
 	if (iommu == NULL)
 		goto out;
 
-	domain = domain_for_device(devid);
+	domain = domain_for_device(dev);
 
 	if (domain && !dma_ops_domain(domain))
 		WARN_ONCE(1, "AMD IOMMU WARNING: device %s already bound "
@@ -1334,7 +1387,7 @@ static int device_change_notifier(struct notifier_block *nb,
 			goto out;
 		if (iommu_pass_through)
 			break;
-		detach_device(domain, devid);
+		detach_device(dev);
 		break;
 	case BUS_NOTIFY_ADD_DEVICE:
 		/* allocate a protection domain if a device is added */
@@ -1441,30 +1494,25 @@ static bool get_device_resources(struct device *dev,
 {
 	struct dma_ops_domain *dma_dom;
 	struct amd_iommu *iommu;
-	struct pci_dev *pcidev;
-	u16 _bdf;
 
 	if (!check_device(dev))
 		return false;
 
-	pcidev  = to_pci_dev(dev);
-	_bdf    = calc_devid(pcidev->bus->number, pcidev->devfn);
-	*bdf    = amd_iommu_alias_table[_bdf];
+	*bdf    = get_device_id(dev);
+	*domain = domain_for_device(dev);
 	iommu   = amd_iommu_rlookup_table[*bdf];
-	*domain = domain_for_device(*bdf);
 
-	if (*domain == NULL) {
-		dma_dom = find_protection_domain(*bdf);
-		if (!dma_dom)
-			dma_dom = iommu->default_dom;
-		*domain = &dma_dom->domain;
-		attach_device(iommu, *domain, *bdf);
-		DUMP_printk("Using protection domain %d for device %s\n",
-			    (*domain)->id, dev_name(dev));
-	}
+	if (*domain != NULL)
+		return true;
 
-	if (domain_for_device(_bdf) == NULL)
-		attach_device(iommu, *domain, _bdf);
+	/* Device not bount yet - bind it */
+	dma_dom = find_protection_domain(*bdf);
+	if (!dma_dom)
+		dma_dom = iommu->default_dom;
+	*domain = &dma_dom->domain;
+	attach_device(dev, *domain);
+	DUMP_printk("Using protection domain %d for device %s\n",
+		    (*domain)->id, dev_name(dev));
 
 	return true;
 }
@@ -2068,7 +2116,7 @@ static void prealloc_protection_domains(void)
 		if (devid > amd_iommu_last_bdf)
 			continue;
 		devid = amd_iommu_alias_table[devid];
-		if (domain_for_device(devid))
+		if (domain_for_device(&dev->dev))
 			continue;
 		iommu = amd_iommu_rlookup_table[devid];
 		if (!iommu)
@@ -2079,9 +2127,7 @@ static void prealloc_protection_domains(void)
 		init_unity_mappings_for_device(dma_dom, devid);
 		dma_dom->target_dev = devid;
 
-		attach_device(iommu, &dma_dom->domain, devid);
-		if (__devid != devid)
-			attach_device(iommu, &dma_dom->domain, __devid);
+		attach_device(&dev->dev, &dma_dom->domain);
 
 		list_add_tail(&dma_dom->list, &iommu_pd_list);
 	}
@@ -2174,7 +2220,7 @@ static void cleanup_domain(struct protection_domain *domain)
 
 	for (devid = 0; devid <= amd_iommu_last_bdf; ++devid)
 		if (amd_iommu_pd_table[devid] == domain)
-			__detach_device(domain, devid);
+			clear_dte_entry(devid);
 
 	write_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
 }
@@ -2262,7 +2308,6 @@ static void amd_iommu_domain_destroy(struct iommu_domain *dom)
 static void amd_iommu_detach_device(struct iommu_domain *dom,
 				    struct device *dev)
 {
-	struct protection_domain *domain = dom->priv;
 	struct amd_iommu *iommu;
 	struct pci_dev *pdev;
 	u16 devid;
@@ -2275,7 +2320,7 @@ static void amd_iommu_detach_device(struct iommu_domain *dom,
 	devid = calc_devid(pdev->bus->number, pdev->devfn);
 
 	if (devid > 0)
-		detach_device(domain, devid);
+		detach_device(dev);
 
 	iommu = amd_iommu_rlookup_table[devid];
 	if (!iommu)
@@ -2292,6 +2337,7 @@ static int amd_iommu_attach_device(struct iommu_domain *dom,
 	struct protection_domain *old_domain;
 	struct amd_iommu *iommu;
 	struct pci_dev *pdev;
+	int ret;
 	u16 devid;
 
 	if (dev->bus != &pci_bus_type)
@@ -2309,15 +2355,15 @@ static int amd_iommu_attach_device(struct iommu_domain *dom,
 	if (!iommu)
 		return -EINVAL;
 
-	old_domain = domain_for_device(devid);
+	old_domain = amd_iommu_pd_table[devid];
 	if (old_domain)
-		detach_device(old_domain, devid);
+		detach_device(dev);
 
-	attach_device(iommu, domain, devid);
+	ret = attach_device(dev, domain);
 
 	iommu_completion_wait(iommu);
 
-	return 0;
+	return ret;
 }
 
 static int amd_iommu_map_range(struct iommu_domain *dom,
@@ -2414,8 +2460,9 @@ static struct iommu_ops amd_iommu_ops = {
 
 int __init amd_iommu_init_passthrough(void)
 {
+	struct amd_iommu *iommu;
 	struct pci_dev *dev = NULL;
-	u16 devid, devid2;
+	u16 devid;
 
 	/* allocate passthroug domain */
 	pt_domain = protection_domain_alloc();
@@ -2425,20 +2472,16 @@ int __init amd_iommu_init_passthrough(void)
 	pt_domain->mode |= PAGE_MODE_NONE;
 
 	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
-		struct amd_iommu *iommu;
 
 		devid = calc_devid(dev->bus->number, dev->devfn);
 		if (devid > amd_iommu_last_bdf)
 			continue;
 
-		devid2 = amd_iommu_alias_table[devid];
-
-		iommu = amd_iommu_rlookup_table[devid2];
+		iommu = amd_iommu_rlookup_table[devid];
 		if (!iommu)
 			continue;
 
-		__attach_device(iommu, pt_domain, devid);
-		__attach_device(iommu, pt_domain, devid2);
+		attach_device(&dev->dev, pt_domain);
 	}
 
 	pr_info("AMD-Vi: Initialized for Passthrough Mode\n");
-- 
1.6.5.3


