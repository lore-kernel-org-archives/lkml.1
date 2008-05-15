Return-Path: <linux-kernel-owner+w=401wt.eu-S1761535AbYEOQEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761535AbYEOQEi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 12:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758984AbYEOQE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 12:04:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56602 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758321AbYEOQE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 12:04:27 -0400
Date: Thu, 15 May 2008 13:04:26 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: [PATCH][PCI]: Introduce pci_find_capability_cached and make MSI
	use it
Message-ID: <20080515160426.GD14846@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	linux-rt-users@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

	While using the preemptirqsoff ftrace tracer I noticed that
everytime handle_edge_irq is called it needs to mask and unmask MSI, and
that leads to a series of very expensive calls to pci_find_capability,
as can be seen here, with preemption disabled:

          <idle>-0     [03]   422.558652: unmask_msi_irq <-handle_edge_irq
          <idle>-0     [03]   422.558653: msi_set_mask_bits <-unmask_msi_irq
          <idle>-0     [03]   422.558653: msi_set_enable <-msi_set_mask_bits
          <idle>-0     [03]   422.558654: pci_find_capability <-msi_set_enable
          <idle>-0     [03]   422.558655: __pci_bus_find_cap_start <-pci_find_capability
          <idle>-0     [03]   422.558655: pci_bus_read_config_word <-__pci_bus_find_cap_start
          <idle>-0     [03]   422.558656: _spin_lock_irqsave <-pci_bus_read_config_word
          <idle>-0     [03]   422.558656: add_preempt_count <-_spin_lock_irqsave
          <idle>-0     [03]   422.558657: pci_read <-pci_bus_read_config_word
          <idle>-0     [03]   422.558657: raw_pci_read <-pci_read
          <idle>-0     [03]   422.558658: pci_conf1_read <-raw_pci_read
          <idle>-0     [03]   422.558658: _spin_lock_irqsave <-pci_conf1_read
          <idle>-0     [03]   422.558659: add_preempt_count <-_spin_lock_irqsave

	  BZZT! 37us

          <idle>-0     [03]   422.558696: _spin_unlock_irqrestore <-pci_conf1_read
          <idle>-0     [03]   422.558697: sub_preempt_count <-_spin_unlock_irqrestore
          <idle>-0     [03]   422.558697: preempt_schedule <-_spin_unlock_irqrestore
          <idle>-0     [03]   422.558698: _spin_unlock_irqrestore <-pci_bus_read_config_word
          <idle>-0     [03]   422.558698: sub_preempt_count <-_spin_unlock_irqrestore
          <idle>-0     [03]   422.558699: preempt_schedule <-_spin_unlock_irqrestore
          <idle>-0     [03]   422.558699: __pci_find_next_cap <-pci_find_capability
          <idle>-0     [03]   422.558700: __pci_find_next_cap_ttl <-__pci_find_next_cap
          <idle>-0     [03]   422.558700: pci_bus_read_config_byte <-__pci_find_next_cap_ttl
          <idle>-0     [03]   422.558701: _spin_lock_irqsave <-pci_bus_read_config_byte
          <idle>-0     [03]   422.558701: add_preempt_count <-_spin_lock_irqsave
          <idle>-0     [03]   422.558702: pci_read <-pci_bus_read_config_byte
          <idle>-0     [03]   422.558702: raw_pci_read <-pci_read
          <idle>-0     [03]   422.558703: pci_conf1_read <-raw_pci_read
          <idle>-0     [03]   422.558703: _spin_lock_irqsave <-pci_conf1_read
          <idle>-0     [03]   422.558704: add_preempt_count <-_spin_lock_irqsave

	  BZZT! 38us

          <idle>-0     [03]   422.558742: _spin_unlock_irqrestore <-pci_conf1_read
          <idle>-0     [03]   422.558743: sub_preempt_count <-_spin_unlock_irqrestore
          <idle>-0     [03]   422.558743: preempt_schedule <-_spin_unlock_irqrestore
          <idle>-0     [03]   422.558744: _spin_unlock_irqrestore <-pci_bus_read_config_byte
          <idle>-0     [03]   422.558744: sub_preempt_count <-_spin_unlock_irqrestore
          <idle>-0     [03]   422.558745: preempt_schedule <-_spin_unlock_irqrestore
          <idle>-0     [03]   422.558745: pci_bus_read_config_byte <-__pci_find_next_cap_ttl
          <idle>-0     [03]   422.558746: _spin_lock_irqsave <-pci_bus_read_config_byte
          <idle>-0     [03]   422.558746: add_preempt_count <-_spin_lock_irqsave
          <idle>-0     [03]   422.558747: pci_read <-pci_bus_read_config_byte
          <idle>-0     [03]   422.558747: raw_pci_read <-pci_read
          <idle>-0     [03]   422.558748: pci_conf1_read <-raw_pci_read
          <idle>-0     [03]   422.558748: _spin_lock_irqsave <-pci_conf1_read
          <idle>-0     [03]   422.558749: add_preempt_count <-_spin_lock_irqsave

	  BZZT! 39us

          <idle>-0     [03]   422.558788: _spin_unlock_irqrestore <-pci_conf1_read
          <idle>-0     [03]   422.558789: sub_preempt_count <-_spin_unlock_irqrestore
          <idle>-0     [03]   422.558789: preempt_schedule <-_spin_unlock_irqrestore
          <idle>-0     [03]   422.558790: _spin_unlock_irqrestore <-pci_bus_read_config_byte
          <idle>-0     [03]   422.558790: sub_preempt_count <-_spin_unlock_irqrestore
          <idle>-0     [03]   422.558791: preempt_schedule <-_spin_unlock_irqrestore
          <idle>-0     [03]   422.558791: pci_bus_read_config_byte <-__pci_find_next_cap_ttl
          <idle>-0     [03]   422.558792: _spin_lock_irqsave <-pci_bus_read_config_byte
          <idle>-0     [03]   422.558792: add_preempt_count <-_spin_lock_irqsave
          <idle>-0     [03]   422.558793: pci_read <-pci_bus_read_config_byte
          <idle>-0     [03]   422.558793: raw_pci_read <-pci_read
          <idle>-0     [03]   422.558794: pci_conf1_read <-raw_pci_read
          <idle>-0     [03]   422.558794: _spin_lock_irqsave <-pci_conf1_read
          <idle>-0     [03]   422.558795: add_preempt_count <-_spin_lock_irqsave

	  BZZT! 39us

          <idle>-0     [03]   422.558834: _spin_unlock_irqrestore <-pci_conf1_read
          <idle>-0     [03]   422.558834: sub_preempt_count <-_spin_unlock_irqrestore

	  <SNIP many more such BZZT!s>

	So I implemented pci_find_capability_cached and made MSI use it
for good measure, please consider applying.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/Makefile b/Makefile
index 14f34b4..d79fdac 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 25
-EXTRAVERSION =
+EXTRAVERSION = .pci_cached
 NAME = Funky Weasel is Jiggy wit it
 
 # *DOCUMENTATION*
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 8c61304..297f185 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -75,7 +75,7 @@ static void msi_set_enable(struct pci_dev *dev, int enable)
 	int pos;
 	u16 control;
 
-	pos = pci_find_capability(dev, PCI_CAP_ID_MSI);
+	pos = pci_find_capability_cached(dev, PCI_CAP_ID_MSI);
 	if (pos) {
 		pci_read_config_word(dev, pos + PCI_MSI_FLAGS, &control);
 		control &= ~PCI_MSI_FLAGS_ENABLE;
@@ -90,7 +90,7 @@ static void msix_set_enable(struct pci_dev *dev, int enable)
 	int pos;
 	u16 control;
 
-	pos = pci_find_capability(dev, PCI_CAP_ID_MSIX);
+	pos = pci_find_capability_cached(dev, PCI_CAP_ID_MSIX);
 	if (pos) {
 		pci_read_config_word(dev, pos + PCI_MSIX_FLAGS, &control);
 		control &= ~PCI_MSIX_FLAGS_ENABLE;
@@ -352,7 +352,7 @@ static int msi_capability_init(struct pci_dev *dev)
 
 	msi_set_enable(dev, 0);	/* Ensure msi is disabled as I set it up */
 
-   	pos = pci_find_capability(dev, PCI_CAP_ID_MSI);
+   	pos = pci_find_capability_cached(dev, PCI_CAP_ID_MSI);
 	pci_read_config_word(dev, msi_control_reg(pos), &control);
 	/* MSI Entry Initialization */
 	entry = alloc_msi_entry();
@@ -426,7 +426,7 @@ static int msix_capability_init(struct pci_dev *dev,
 
 	msix_set_enable(dev, 0);/* Ensure msix is disabled as I set it up */
 
-   	pos = pci_find_capability(dev, PCI_CAP_ID_MSIX);
+   	pos = pci_find_capability_cached(dev, PCI_CAP_ID_MSIX);
 	/* Request & Map MSI-X table region */
  	pci_read_config_word(dev, msi_control_reg(pos), &control);
 	nr_entries = multi_msix_capable(control);
@@ -533,7 +533,7 @@ static int pci_msi_check_device(struct pci_dev* dev, int nvec, int type)
 	if (ret)
 		return ret;
 
-	if (!pci_find_capability(dev, type))
+	if (!pci_find_capability_cached(dev, type))
 		return -EINVAL;
 
 	return 0;
@@ -667,7 +667,7 @@ int pci_enable_msix(struct pci_dev* dev, struct msix_entry *entries, int nvec)
 	if (status)
 		return status;
 
-	pos = pci_find_capability(dev, PCI_CAP_ID_MSIX);
+	pos = pci_find_capability_cached(dev, PCI_CAP_ID_MSIX);
 	pci_read_config_word(dev, msi_control_reg(pos), &control);
 	nr_entries = multi_msix_capable(control);
 	if (nvec > nr_entries)
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index e4548ab..659c93c 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -171,6 +171,35 @@ int pci_find_capability(struct pci_dev *dev, int cap)
 }
 
 /**
+ * pci_find_capability_cached - query for devices' capabilities, cached version
+ * @dev: PCI device to query
+ * @cap: capability code
+ *
+ * Tell if a device supports a given PCI capability.
+ * Returns the address of the requested capability structure within the
+ * device's PCI configuration space or 0 in case the device does not
+ * support it.  Possible values for @cap:
+ *
+ *  %PCI_CAP_ID_PM           Power Management 
+ *  %PCI_CAP_ID_AGP          Accelerated Graphics Port 
+ *  %PCI_CAP_ID_VPD          Vital Product Data 
+ *  %PCI_CAP_ID_SLOTID       Slot Identification 
+ *  %PCI_CAP_ID_MSI          Message Signalled Interrupts
+ *  %PCI_CAP_ID_CHSWP        CompactPCI HotSwap 
+ *  %PCI_CAP_ID_PCIX         PCI-X
+ *  %PCI_CAP_ID_EXP          PCI Express
+ */
+int pci_find_capability_cached(struct pci_dev *dev, int cap)
+{
+	const int idx = cap - 1;
+
+	if (dev->cached_capabilities[idx] == -1)
+		dev->cached_capabilities[idx] = pci_find_capability(dev, cap);
+
+	return dev->cached_capabilities[idx];
+}
+
+/**
  * pci_bus_find_capability - query for devices' capabilities 
  * @bus:   the PCI bus to query
  * @devfn: PCI device to query
@@ -1680,6 +1709,7 @@ EXPORT_SYMBOL(pcim_enable_device);
 EXPORT_SYMBOL(pcim_pin_device);
 EXPORT_SYMBOL(pci_disable_device);
 EXPORT_SYMBOL(pci_find_capability);
+EXPORT_SYMBOL(pci_find_capability_cached);
 EXPORT_SYMBOL(pci_bus_find_capability);
 EXPORT_SYMBOL(pci_release_regions);
 EXPORT_SYMBOL(pci_request_regions);
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 4a55bf3..59338e7 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -885,6 +885,7 @@ static void pci_release_bus_bridge_dev(struct device *dev)
 
 struct pci_dev *alloc_pci_dev(void)
 {
+	int i;
 	struct pci_dev *dev;
 
 	dev = kzalloc(sizeof(struct pci_dev), GFP_KERNEL);
@@ -893,6 +894,9 @@ struct pci_dev *alloc_pci_dev(void)
 
 	INIT_LIST_HEAD(&dev->bus_list);
 
+	for (i = 0; i < ARRAY_SIZE(dev->cached_capabilities); ++i)
+		dev->cached_capabilities[i] = -1;
+
 	pci_msi_init_pci_dev(dev);
 
 	return dev;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 6d0f93d..b7c4cfb 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -197,6 +197,7 @@ struct pci_dev {
 	unsigned int	msix_enabled:1;
 	unsigned int	is_managed:1;
 	unsigned int	is_pcie:1;
+	int		cached_capabilities[PCI_CAP_LIST_NR_ENTRIES]; /* See pci_find_capability_cached */
 	pci_dev_flags_t dev_flags;
 	atomic_t	enable_cnt;	/* pci_enable_device has been called */
 
@@ -516,6 +517,7 @@ struct pci_dev __deprecated *pci_find_slot(unsigned int bus,
 #endif /* CONFIG_PCI_LEGACY */
 
 int pci_find_capability(struct pci_dev *dev, int cap);
+int pci_find_capability_cached(struct pci_dev *dev, int cap);
 int pci_find_next_capability(struct pci_dev *dev, u8 pos, int cap);
 int pci_find_ext_capability(struct pci_dev *dev, int cap);
 int pci_find_ht_capability(struct pci_dev *dev, int ht_cap);
@@ -874,6 +876,11 @@ static inline int pci_find_capability(struct pci_dev *dev, int cap)
 	return 0;
 }
 
+static inline int pci_find_capability_cached(struct pci_dev *dev, int cap)
+{
+	return 0;
+}
+
 static inline int pci_find_next_capability(struct pci_dev *dev, u8 post,
 					   int cap)
 {
diff --git a/include/linux/pci_regs.h b/include/linux/pci_regs.h
index c0c1223..60c64fb 100644
--- a/include/linux/pci_regs.h
+++ b/include/linux/pci_regs.h
@@ -210,6 +210,7 @@
 #define  PCI_CAP_ID_AGP3	0x0E	/* AGP Target PCI-PCI bridge */
 #define  PCI_CAP_ID_EXP 	0x10	/* PCI Express */
 #define  PCI_CAP_ID_MSIX	0x11	/* MSI-X */
+#define PCI_CAP_LIST_NR_ENTRIES PCI_CAP_ID_MSIX
 #define PCI_CAP_LIST_NEXT	1	/* Next capability in the list */
 #define PCI_CAP_FLAGS		2	/* Capability defined flags (16 bits) */
 #define PCI_CAP_SIZEOF		4
