Return-Path: <linux-kernel-owner+w=401wt.eu-S1753168AbZK0N4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbZK0N4K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 08:56:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753310AbZK0N4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 08:56:08 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:52907
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753169AbZK0Nz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 08:55:59 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KTRTD4-01-6RQ-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 27/34] x86/amd-iommu: Use dev->arch->iommu to store iommu related information
Date: Fri, 27 Nov 2009 14:55:38 +0100
Message-ID: <1259330145-14865-28-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
References: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Nov 2009 13:55:48.0389 (UTC) FILETIME=[52BDA550:01CA6F69]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes IOMMU code to use dev->archdata->iommu to
store information about the alias device and the domain the
device is attached to.
This allows the driver to get rid of the amd_iommu_pd_table
in the future.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |    8 +++
 arch/x86/include/asm/device.h          |    2 +-
 arch/x86/kernel/amd_iommu.c            |  109 +++++++++++++++++++++++++-------
 3 files changed, 95 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index 02b6a0f..9eaa27b 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -248,6 +248,14 @@ struct protection_domain {
 };
 
 /*
+ * This struct contains device specific data for the IOMMU
+ */
+struct iommu_dev_data {
+	struct device *alias;		  /* The Alias Device */
+	struct protection_domain *domain; /* Domain the device is bound to */
+};
+
+/*
  * For dynamic growth the aperture size is split into ranges of 128MB of
  * DMA address space each. This struct represents one such range.
  */
diff --git a/arch/x86/include/asm/device.h b/arch/x86/include/asm/device.h
index cee34e9..029f230 100644
--- a/arch/x86/include/asm/device.h
+++ b/arch/x86/include/asm/device.h
@@ -8,7 +8,7 @@ struct dev_archdata {
 #ifdef CONFIG_X86_64
 struct dma_map_ops *dma_ops;
 #endif
-#ifdef CONFIG_DMAR
+#if defined(CONFIG_DMAR) || defined(CONFIG_AMD_IOMMU)
 	void *iommu; /* hook for IOMMU specific extension */
 #endif
 };
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index ed58a16..3214e88 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -73,6 +73,11 @@ static inline u16 get_device_id(struct device *dev)
 	return calc_devid(pdev->bus->number, pdev->devfn);
 }
 
+static struct iommu_dev_data *get_dev_data(struct device *dev)
+{
+	return dev->archdata.iommu;
+}
+
 /*
  * In this function the list of preallocated protection domains is traversed to
  * find the domain for a specific device
@@ -128,6 +133,35 @@ static bool check_device(struct device *dev)
 	return true;
 }
 
+static int iommu_init_device(struct device *dev)
+{
+	struct iommu_dev_data *dev_data;
+	struct pci_dev *pdev;
+	u16 devid, alias;
+
+	if (dev->archdata.iommu)
+		return 0;
+
+	dev_data = kzalloc(sizeof(*dev_data), GFP_KERNEL);
+	if (!dev_data)
+		return -ENOMEM;
+
+	devid = get_device_id(dev);
+	alias = amd_iommu_alias_table[devid];
+	pdev = pci_get_bus_and_slot(PCI_BUS(alias), alias & 0xff);
+	if (pdev)
+		dev_data->alias = &pdev->dev;
+
+	dev->archdata.iommu = dev_data;
+
+
+	return 0;
+}
+
+static void iommu_uninit_device(struct device *dev)
+{
+	kfree(dev->archdata.iommu);
+}
 #ifdef CONFIG_AMD_IOMMU_STATS
 
 /*
@@ -1346,28 +1380,39 @@ static void clear_dte_entry(u16 devid)
 static int __attach_device(struct device *dev,
 			   struct protection_domain *domain)
 {
-	u16 devid = get_device_id(dev);
-	u16 alias = amd_iommu_alias_table[devid];
+	struct iommu_dev_data *dev_data, *alias_data;
+	u16 devid, alias;
+
+	devid      = get_device_id(dev);
+	alias      = amd_iommu_alias_table[devid];
+	dev_data   = get_dev_data(dev);
+	alias_data = get_dev_data(dev_data->alias);
+	if (!alias_data)
+		return -EINVAL;
 
 	/* lock domain */
 	spin_lock(&domain->lock);
 
 	/* Some sanity checks */
-	if (amd_iommu_pd_table[alias] != NULL &&
-	    amd_iommu_pd_table[alias] != domain)
+	if (alias_data->domain != NULL &&
+	    alias_data->domain != domain)
 		return -EBUSY;
 
-	if (amd_iommu_pd_table[devid] != NULL &&
-	    amd_iommu_pd_table[devid] != domain)
+	if (dev_data->domain != NULL &&
+	    dev_data->domain != domain)
 		return -EBUSY;
 
 	/* Do real assignment */
 	if (alias != devid &&
-	    amd_iommu_pd_table[alias] == NULL)
+	    alias_data->domain == NULL) {
+		alias_data->domain = domain;
 		set_dte_entry(alias, domain);
+	}
 
-	if (amd_iommu_pd_table[devid] == NULL)
+	if (dev_data->domain == NULL) {
+		dev_data->domain = domain;
 		set_dte_entry(devid, domain);
+	}
 
 	/* ready */
 	spin_unlock(&domain->lock);
@@ -1406,10 +1451,12 @@ static void __detach_device(struct device *dev)
 {
 	u16 devid = get_device_id(dev);
 	struct amd_iommu *iommu = amd_iommu_rlookup_table[devid];
+	struct iommu_dev_data *dev_data = get_dev_data(dev);
 
 	BUG_ON(!iommu);
 
 	clear_dte_entry(devid);
+	dev_data->domain = NULL;
 
 	/*
 	 * If we run in passthrough mode the device must be assigned to the
@@ -1439,18 +1486,23 @@ static void detach_device(struct device *dev)
 static struct protection_domain *domain_for_device(struct device *dev)
 {
 	struct protection_domain *dom;
+	struct iommu_dev_data *dev_data, *alias_data;
 	unsigned long flags;
 	u16 devid, alias;
 
-	devid = get_device_id(dev);
-	alias = amd_iommu_alias_table[devid];
+	devid      = get_device_id(dev);
+	alias      = amd_iommu_alias_table[devid];
+	dev_data   = get_dev_data(dev);
+	alias_data = get_dev_data(dev_data->alias);
+	if (!alias_data)
+		return NULL;
 
 	read_lock_irqsave(&amd_iommu_devtable_lock, flags);
-	dom = amd_iommu_pd_table[devid];
+	dom = dev_data->domain;
 	if (dom == NULL &&
-	    amd_iommu_pd_table[alias] != NULL) {
-		__attach_device(dev, amd_iommu_pd_table[alias]);
-		dom = amd_iommu_pd_table[devid];
+	    alias_data->domain != NULL) {
+		__attach_device(dev, alias_data->domain);
+		dom = alias_data->domain;
 	}
 
 	read_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
@@ -1473,14 +1525,12 @@ static int device_change_notifier(struct notifier_block *nb,
 
 	devid  = get_device_id(dev);
 	iommu  = amd_iommu_rlookup_table[devid];
-	domain = domain_for_device(dev);
-
-	if (domain && !dma_ops_domain(domain))
-		WARN_ONCE(1, "AMD IOMMU WARNING: device %s already bound "
-			  "to a non-dma-ops domain\n", dev_name(dev));
 
 	switch (action) {
 	case BUS_NOTIFY_UNBOUND_DRIVER:
+
+		domain = domain_for_device(dev);
+
 		if (!domain)
 			goto out;
 		if (iommu_pass_through)
@@ -1488,6 +1538,11 @@ static int device_change_notifier(struct notifier_block *nb,
 		detach_device(dev);
 		break;
 	case BUS_NOTIFY_ADD_DEVICE:
+
+		iommu_init_device(dev);
+
+		domain = domain_for_device(dev);
+
 		/* allocate a protection domain if a device is added */
 		dma_domain = find_protection_domain(devid);
 		if (dma_domain)
@@ -1502,6 +1557,10 @@ static int device_change_notifier(struct notifier_block *nb,
 		spin_unlock_irqrestore(&iommu_pd_list_lock, flags);
 
 		break;
+	case BUS_NOTIFY_DEL_DEVICE:
+
+		iommu_uninit_device(dev);
+
 	default:
 		goto out;
 	}
@@ -2079,6 +2138,8 @@ static void prealloc_protection_domains(void)
 		if (!check_device(&dev->dev))
 			continue;
 
+		iommu_init_device(&dev->dev);
+
 		/* Is there already any domain for it? */
 		if (domain_for_device(&dev->dev))
 			continue;
@@ -2270,6 +2331,7 @@ static void amd_iommu_domain_destroy(struct iommu_domain *dom)
 static void amd_iommu_detach_device(struct iommu_domain *dom,
 				    struct device *dev)
 {
+	struct iommu_dev_data *dev_data = dev->archdata.iommu;
 	struct amd_iommu *iommu;
 	u16 devid;
 
@@ -2278,7 +2340,7 @@ static void amd_iommu_detach_device(struct iommu_domain *dom,
 
 	devid = get_device_id(dev);
 
-	if (amd_iommu_pd_table[devid] != NULL)
+	if (dev_data->domain != NULL)
 		detach_device(dev);
 
 	iommu = amd_iommu_rlookup_table[devid];
@@ -2293,7 +2355,7 @@ static int amd_iommu_attach_device(struct iommu_domain *dom,
 				   struct device *dev)
 {
 	struct protection_domain *domain = dom->priv;
-	struct protection_domain *old_domain;
+	struct iommu_dev_data *dev_data;
 	struct amd_iommu *iommu;
 	int ret;
 	u16 devid;
@@ -2301,14 +2363,15 @@ static int amd_iommu_attach_device(struct iommu_domain *dom,
 	if (!check_device(dev))
 		return -EINVAL;
 
+	dev_data = dev->archdata.iommu;
+
 	devid = get_device_id(dev);
 
 	iommu = amd_iommu_rlookup_table[devid];
 	if (!iommu)
 		return -EINVAL;
 
-	old_domain = amd_iommu_pd_table[devid];
-	if (old_domain)
+	if (dev_data->domain)
 		detach_device(dev);
 
 	ret = attach_device(dev, domain);
-- 
1.6.5.3


