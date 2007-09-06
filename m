Return-Path: <linux-kernel-owner+w=401wt.eu-S1756890AbXIFRHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890AbXIFRHq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 13:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751096AbXIFRHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 13:07:36 -0400
Received: from mga03.intel.com ([143.182.124.21]:30504 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbXIFRHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 13:07:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,216,1186383600"; 
   d="scan'208";a="273344614"
From: Shannon Nelson <shannon.nelson@intel.com>
Subject: [PATCH -mm] [RFC] IOAT: Add support for version 2 of ioatdma device
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: shannon.nelson@intel.com
Date: Thu, 06 Sep 2007 10:07:12 -0700
Message-ID: <20070906170712.7444.34573.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for version 2 of the ioatdma device.  This device handles
the descriptor chain and DCA services slightly differently:
 - Instead of using a busy chain and an idle chain for the dma descriptors,
   this new version uses a single chain that loops back to itself.  One of
   the benefits is that we don't have rewrite the next_descriptor pointers
   as we add new requests, so the device doesn't need to re-read the last
   descriptor.
 - The new device has CPUs' DCA tags defined internally, instead of needing
   them defined statically in the code.

This patch applies on the recent DCA patches currently in the -mm tree.

Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
---

 drivers/dma/ioat.c              |   33 +-
 drivers/dma/ioat_dca.c          |  164 +++++++++
 drivers/dma/ioat_dma.c          |  699 +++++++++++++++++++++++++++++++++------
 drivers/dma/ioatdma.h           |   33 +-
 drivers/dma/ioatdma_hw.h        |    1 
 drivers/dma/ioatdma_registers.h |  104 +++++-
 include/linux/pci_ids.h         |    1 
 7 files changed, 890 insertions(+), 145 deletions(-)

diff --git a/drivers/dma/ioat.c b/drivers/dma/ioat.c
index f7276bf..e00acba 100644
--- a/drivers/dma/ioat.c
+++ b/drivers/dma/ioat.c
@@ -34,15 +34,19 @@
 #include "ioatdma_registers.h"
 #include "ioatdma_hw.h"
 
-MODULE_VERSION("1.24");
+MODULE_VERSION("2.02");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Intel Corporation");
 
 static struct pci_device_id ioat_pci_tbl[] = {
+	/* I/OAT v1 platforms */
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_CNB)  },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_SCNB) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_UNISYS, PCI_DEVICE_ID_UNISYS_DMA_DIRECTOR) },
+
+	/* I/OAT v2 platforms */
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_SNB) },
 	{ 0, }
 };
 
@@ -53,16 +57,18 @@ struct ioat_device {
 	struct dca_provider	*dca;
 };
 
+static int ioat_dca_enabled = 1;
+module_param(ioat_dca_enabled, int, 0644);
+MODULE_PARM_DESC(ioat_dca_enabled,
+		 "control support of dca service (default: 1)");
+
+
 static int __devinit ioat_probe(struct pci_dev *pdev,
 				const struct pci_device_id *id);
 #ifdef IOAT_DMA_REMOVE
 static void __devexit ioat_remove(struct pci_dev *pdev);
 #endif
 
-static int ioat_dca_enabled = 1;
-module_param(ioat_dca_enabled, int, 0644);
-MODULE_PARM_DESC(ioat_dca_enabled, "control support of dca service (default: 1)");
-
 static int ioat_setup_functionality(struct pci_dev *pdev, void __iomem *iobase)
 {
 	struct ioat_device *device = pci_get_drvdata(pdev);
@@ -73,13 +79,20 @@ static int ioat_setup_functionality(struct pci_dev *pdev, void __iomem *iobase)
 	switch (version) {
 	case IOAT_VER_1_2:
 		device->dma = ioat_dma_probe(pdev, iobase);
-		if (ioat_dca_enabled)
+		if (device->dma && ioat_dca_enabled)
 			device->dca = ioat_dca_init(pdev, iobase);
 		break;
+	case IOAT_VER_2_0:
+		device->dma = ioat_dma_probe(pdev, iobase);
+		if (device->dma && ioat_dca_enabled)
+			device->dca = ioat2_dca_init(pdev, iobase);
+		break;
 	default:
 		err = -ENODEV;
 		break;
 	}
+	if (!device->dma)
+		err = -ENODEV;
 	return err;
 }
 
@@ -100,7 +113,7 @@ static void ioat_shutdown_functionality(struct pci_dev *pdev)
 
 }
 
-static struct pci_driver ioat_pci_drv = {
+static struct pci_driver ioat_pci_driver = {
 	.name		= "ioatdma",
 	.id_table	= ioat_pci_tbl,
 	.probe		= ioat_probe,
@@ -122,7 +135,7 @@ static int __devinit ioat_probe(struct pci_dev *pdev,
 	if (err)
 		goto err_enable_device;
 
-	err = pci_request_regions(pdev, ioat_pci_drv.name);
+	err = pci_request_regions(pdev, ioat_pci_driver.name);
 	if (err)
 		goto err_request_regions;
 
@@ -200,12 +213,12 @@ static void __devexit ioat_remove(struct pci_dev *pdev)
 
 static int __init ioat_init_module(void)
 {
-	return pci_register_driver(&ioat_pci_drv);
+	return pci_register_driver(&ioat_pci_driver);
 }
 module_init(ioat_init_module);
 
 static void __exit ioat_exit_module(void)
 {
-	pci_unregister_driver(&ioat_pci_drv);
+	pci_unregister_driver(&ioat_pci_driver);
 }
 module_exit(ioat_exit_module);
diff --git a/drivers/dma/ioat_dca.c b/drivers/dma/ioat_dca.c
index 2ae04c3..9f1359e 100644
--- a/drivers/dma/ioat_dca.c
+++ b/drivers/dma/ioat_dca.c
@@ -261,3 +261,167 @@ struct dca_provider *ioat_dca_init(struct pci_dev *pdev, void __iomem *iobase)
 	return dca;
 }
 
+
+static int ioat2_dca_add_requester(struct dca_provider *dca, struct device *dev)
+{
+	struct ioat_dca_priv *ioatdca = dca_priv(dca);
+	struct pci_dev *pdev;
+	int i;
+	u16 id;
+	u16 global_req_table;
+
+	/* This implementation only supports PCI-Express */
+	if (dev->bus != &pci_bus_type)
+		return -ENODEV;
+	pdev = to_pci_dev(dev);
+	id = dcaid_from_pcidev(pdev);
+
+	if (ioatdca->requester_count == ioatdca->max_requesters)
+		return -ENODEV;
+
+	for (i = 0; i < ioatdca->max_requesters; i++) {
+		if (ioatdca->req_slots[i].pdev == NULL) {
+			/* found an empty slot */
+			ioatdca->requester_count++;
+			ioatdca->req_slots[i].pdev = pdev;
+			ioatdca->req_slots[i].rid = id;
+			global_req_table =
+			      readw(ioatdca->dca_base + IOAT_DCA_GREQID_OFFSET);
+			writel(id | IOAT_DCA_GREQID_VALID,
+			       ioatdca->iobase + global_req_table + (i * 4));
+			return i;
+		}
+	}
+	/* Error, ioatdma->requester_count is out of whack */
+	return -EFAULT;
+}
+
+static int ioat2_dca_remove_requester(struct dca_provider *dca,
+				      struct device *dev)
+{
+	struct ioat_dca_priv *ioatdca = dca_priv(dca);
+	struct pci_dev *pdev;
+	int i;
+	u16 global_req_table;
+
+	/* This implementation only supports PCI-Express */
+	if (dev->bus != &pci_bus_type)
+		return -ENODEV;
+	pdev = to_pci_dev(dev);
+
+	for (i = 0; i < ioatdca->max_requesters; i++) {
+		if (ioatdca->req_slots[i].pdev == pdev) {
+			global_req_table =
+			      readw(ioatdca->dca_base + IOAT_DCA_GREQID_OFFSET);
+			writel(0, ioatdca->iobase + global_req_table + (i * 4));
+			ioatdca->req_slots[i].pdev = NULL;
+			ioatdca->req_slots[i].rid = 0;
+			ioatdca->requester_count--;
+			return i;
+		}
+	}
+	return -ENODEV;
+}
+
+static u8 ioat2_dca_get_tag(struct dca_provider *dca, int cpu)
+{
+	u8 tag;
+
+	tag = ioat_dca_get_tag(dca, cpu);
+	tag = (~tag) & 0x1F;
+	return tag;
+}
+
+static struct dca_ops ioat2_dca_ops = {
+	.add_requester		= ioat2_dca_add_requester,
+	.remove_requester	= ioat2_dca_remove_requester,
+	.get_tag		= ioat2_dca_get_tag,
+};
+
+static int ioat2_dca_count_dca_slots(void *iobase, u16 dca_offset)
+{
+	int slots = 0;
+	u32 req;
+	u16 global_req_table;
+
+	global_req_table = readw(iobase + dca_offset + IOAT_DCA_GREQID_OFFSET);
+	if (global_req_table == 0)
+		return 0;
+	do {
+		req = readl(iobase + global_req_table + (slots * sizeof(u32)));
+		slots++;
+	} while ((req & IOAT_DCA_GREQID_LASTID) == 0);
+
+	return slots;
+}
+
+struct dca_provider *ioat2_dca_init(struct pci_dev *pdev, void __iomem *iobase)
+{
+	struct dca_provider *dca;
+	struct ioat_dca_priv *ioatdca;
+	int slots;
+	int i;
+	int err;
+	u32 tag_map;
+	u16 dca_offset;
+	u16 csi_fsb_control;
+	u16 pcie_control;
+	u8 bit;
+
+	if (!system_has_dca_enabled())
+		return NULL;
+
+	dca_offset = readw(iobase + IOAT_DCAOFFSET_OFFSET);
+	if (dca_offset == 0)
+		return NULL;
+
+	slots = ioat2_dca_count_dca_slots(iobase, dca_offset);
+	if (slots == 0)
+		return NULL;
+
+	dca = alloc_dca_provider(&ioat2_dca_ops,
+				 sizeof(*ioatdca)
+				      + (sizeof(struct ioat_dca_slot) * slots));
+	if (!dca)
+		return NULL;
+
+	ioatdca = dca_priv(dca);
+	ioatdca->iobase = iobase;
+	ioatdca->dca_base = iobase + dca_offset;
+	ioatdca->max_requesters = slots;
+
+	/* some bios might not know to turn these on */
+	csi_fsb_control = readw(ioatdca->dca_base + IOAT_FSB_CAP_ENABLE_OFFSET);
+	if ((csi_fsb_control & IOAT_FSB_CAP_ENABLE_PREFETCH) == 0) {
+		csi_fsb_control |= IOAT_FSB_CAP_ENABLE_PREFETCH;
+		writew(csi_fsb_control,
+		       ioatdca->dca_base + IOAT_FSB_CAP_ENABLE_OFFSET);
+	}
+	pcie_control = readw(ioatdca->dca_base + IOAT_PCI_CAP_ENABLE_OFFSET);
+	if ((pcie_control & IOAT_PCI_CAP_ENABLE_MEMWR) == 0) {
+		pcie_control |= IOAT_PCI_CAP_ENABLE_MEMWR;
+		writew(pcie_control,
+		       ioatdca->dca_base + IOAT_PCI_CAP_ENABLE_OFFSET);
+	}
+
+
+	/* TODO version, compatibility and configuration checks */
+
+	/* copy out the APIC to DCA tag map */
+	tag_map = readl(ioatdca->dca_base + IOAT_APICID_TAG_MAP_OFFSET);
+	for (i = 0; i < 5; i++) {
+		bit = (tag_map >> (4 * i)) & 0x0f;
+		if (bit < 8)
+			ioatdca->tag_map[i] = bit | DCA_TAG_MAP_VALID;
+		else
+			ioatdca->tag_map[i] = 0;
+	}
+
+	err = register_dca_provider(dca, &pdev->dev);
+	if (err) {
+		free_dca_provider(dca);
+		return NULL;
+	}
+
+	return dca;
+}
diff --git a/drivers/dma/ioat_dma.c b/drivers/dma/ioat_dma.c
index e4c3afe..e0185d2 100644
--- a/drivers/dma/ioat_dma.c
+++ b/drivers/dma/ioat_dma.c
@@ -36,13 +36,19 @@
 #include "ioatdma_registers.h"
 #include "ioatdma_hw.h"
 
-#define INITIAL_IOAT_DESC_COUNT 128
-
 #define to_ioat_chan(chan) container_of(chan, struct ioat_dma_chan, common)
 #define to_ioatdma_device(dev) container_of(dev, struct ioatdma_device, common)
 #define to_ioat_desc(lh) container_of(lh, struct ioat_desc_sw, node)
 #define tx_to_ioat_desc(tx) container_of(tx, struct ioat_desc_sw, async_tx)
 
+#define chan_num(ch) ((int)((ch)->reg_base - (ch)->device->reg_base) / 0x80)
+
+static int ioat_dma_dca_enabled;
+module_param(ioat_dma_dca_enabled, int, 0644);
+MODULE_PARM_DESC(ioat_dma_dca_enabled,
+		 "control use of dca on dma operations, "
+		 "does not affect endpoint dca (default: 0)");
+
 /* internal functions */
 static void ioat_dma_start_null_desc(struct ioat_dma_chan *ioat_chan);
 static void ioat_dma_memcpy_cleanup(struct ioat_dma_chan *ioat_chan);
@@ -127,6 +133,7 @@ static int ioat_dma_enumerate_channels(struct ioatdma_device *device)
 		ioat_chan->device = device;
 		ioat_chan->reg_base = device->reg_base + (0x80 * (i + 1));
 		ioat_chan->xfercap = xfercap;
+		ioat_chan->desccount = 0;
 		spin_lock_init(&ioat_chan->cleanup_lock);
 		spin_lock_init(&ioat_chan->desc_lock);
 		INIT_LIST_HEAD(&ioat_chan->free_desc);
@@ -150,12 +157,16 @@ static void ioat_set_src(dma_addr_t addr,
 {
 	struct ioat_desc_sw *iter, *desc = tx_to_ioat_desc(tx);
 	struct ioat_dma_chan *ioat_chan = to_ioat_chan(tx->chan);
+	int cnt = desc->tx_cnt;
 
 	pci_unmap_addr_set(desc, src, addr);
 
 	list_for_each_entry(iter, &desc->async_tx.tx_list, node) {
 		iter->hw->src_addr = addr;
 		addr += ioat_chan->xfercap;
+
+		if (--cnt == 0);
+			break;
 	}
 
 }
@@ -166,20 +177,28 @@ static void ioat_set_dest(dma_addr_t addr,
 {
 	struct ioat_desc_sw *iter, *desc = tx_to_ioat_desc(tx);
 	struct ioat_dma_chan *ioat_chan = to_ioat_chan(tx->chan);
+	int cnt = desc->tx_cnt;
 
 	pci_unmap_addr_set(desc, dst, addr);
 
 	list_for_each_entry(iter, &desc->async_tx.tx_list, node) {
 		iter->hw->dst_addr = addr;
 		addr += ioat_chan->xfercap;
+
+		if (--cnt == 0);
+			break;
 	}
 }
 
-static dma_cookie_t ioat_tx_submit(struct dma_async_tx_descriptor *tx)
+static inline void __ioat1_dma_memcpy_issue_pending(
+					       struct ioat_dma_chan *ioat_chan);
+static inline void __ioat2_dma_memcpy_issue_pending(
+					       struct ioat_dma_chan *ioat_chan);
+
+static dma_cookie_t ioat1_tx_submit(struct dma_async_tx_descriptor *tx)
 {
 	struct ioat_dma_chan *ioat_chan = to_ioat_chan(tx->chan);
 	struct ioat_desc_sw *desc = tx_to_ioat_desc(tx);
-	int append = 0;
 	dma_cookie_t cookie;
 	struct ioat_desc_sw *group_start;
 
@@ -198,20 +217,44 @@ static dma_cookie_t ioat_tx_submit(struct dma_async_tx_descriptor *tx)
 						group_start->async_tx.phys;
 	list_splice_init(&desc->async_tx.tx_list, ioat_chan->used_desc.prev);
 
+	ioat_chan->dmacount += desc->tx_cnt;
 	ioat_chan->pending += desc->tx_cnt;
-	if (ioat_chan->pending >= 4) {
-		append = 1;
-		ioat_chan->pending = 0;
-	}
 	spin_unlock_bh(&ioat_chan->desc_lock);
 
-	if (append)
-		writeb(IOAT_CHANCMD_APPEND,
-			ioat_chan->reg_base + IOAT_CHANCMD_OFFSET);
+	if (ioat_chan->pending >= 4)
+		__ioat1_dma_memcpy_issue_pending(ioat_chan);
+	return cookie;
+}
+
+static dma_cookie_t ioat2_tx_submit(struct dma_async_tx_descriptor *tx)
+{
+	struct ioat_dma_chan *ioat_chan = to_ioat_chan(tx->chan);
+	struct ioat_desc_sw *desc = tx_to_ioat_desc(tx);
+	dma_cookie_t cookie;
+
+	/* ioat_chan->desc_lock is still in force in version 2 path */
+
+	/* cookie incr and addition to used_list must be atomic */
+	cookie = ioat_chan->common.cookie;
+	cookie++;
+	if (cookie < 0)
+		cookie = 1;
+	ioat_chan->common.cookie = desc->async_tx.cookie = cookie;
+
+	ioat_chan->dmacount += desc->tx_cnt;
+	ioat_chan->pending += desc->tx_cnt;
+	if (ioat_chan->pending >= 4)
+		__ioat2_dma_memcpy_issue_pending(ioat_chan);
+	spin_unlock_bh(&ioat_chan->desc_lock);
 
 	return cookie;
 }
 
+/**
+ * ioat_dma_alloc_descriptor - allocate and return a sw and hw descriptor pair
+ * @ioat_chan: the channel supplying the memory pool for the descriptors
+ * @flags: allocation flags
+ */
 static struct ioat_desc_sw *ioat_dma_alloc_descriptor(
 					struct ioat_dma_chan *ioat_chan,
 					gfp_t flags)
@@ -236,15 +279,58 @@ static struct ioat_desc_sw *ioat_dma_alloc_descriptor(
 	dma_async_tx_descriptor_init(&desc_sw->async_tx, &ioat_chan->common);
 	desc_sw->async_tx.tx_set_src = ioat_set_src;
 	desc_sw->async_tx.tx_set_dest = ioat_set_dest;
-	desc_sw->async_tx.tx_submit = ioat_tx_submit;
+	switch (ioat_chan->device->version) {
+	case IOAT_VER_1_2:
+		desc_sw->async_tx.tx_submit = ioat1_tx_submit;
+		break;
+	case IOAT_VER_2_0:
+		desc_sw->async_tx.tx_submit = ioat2_tx_submit;
+		break;
+	}
 	INIT_LIST_HEAD(&desc_sw->async_tx.tx_list);
+
+	desc->ctl = IOAT_DMA_DESCRIPTOR_NUL;
 	desc_sw->hw = desc;
 	desc_sw->async_tx.phys = phys;
 
 	return desc_sw;
 }
 
-/* returns the actual number of allocated descriptors */
+static int ioat_initial_desc_count = 256;
+module_param(ioat_initial_desc_count, int, 0644);
+MODULE_PARM_DESC(ioat_initial_desc_count,
+		 "initial descriptors per channel (default: 256)");
+
+/**
+ * ioat2_dma_massage_chan_desc - link the descriptors into a circle
+ * @ioat_chan: the channel to be massaged
+ */
+static void ioat2_dma_massage_chan_desc(struct ioat_dma_chan *ioat_chan)
+{
+	struct ioat_desc_sw *desc, *_desc;
+
+	/* setup used_desc */
+	ioat_chan->used_desc.next = ioat_chan->free_desc.next;
+	ioat_chan->used_desc.prev = NULL;
+
+	/* pull free_desc out of the circle so that every node is a hw
+	 * descriptor, but leave it pointing to the list
+	 */
+	ioat_chan->free_desc.prev->next = ioat_chan->free_desc.next;
+	ioat_chan->free_desc.next->prev = ioat_chan->free_desc.prev;
+
+	/* circle link the hw descriptors */
+	desc = to_ioat_desc(ioat_chan->free_desc.next);
+	desc->hw->next = to_ioat_desc(desc->node.next)->async_tx.phys;
+	list_for_each_entry_safe(desc, _desc, ioat_chan->free_desc.next, node) {
+		desc->hw->next = to_ioat_desc(desc->node.next)->async_tx.phys;
+	}
+}
+
+/**
+ * ioat_dma_alloc_chan_resources - returns the number of allocated descriptors
+ * @chan: the channel to be filled out
+ */
 static int ioat_dma_alloc_chan_resources(struct dma_chan *chan)
 {
 	struct ioat_dma_chan *ioat_chan = to_ioat_chan(chan);
@@ -256,7 +342,7 @@ static int ioat_dma_alloc_chan_resources(struct dma_chan *chan)
 
 	/* have we already been set up? */
 	if (!list_empty(&ioat_chan->free_desc))
-		return INITIAL_IOAT_DESC_COUNT;
+		return ioat_chan->desccount;
 
 	/* Setup register to interrupt and write completion status on error */
 	chanctrl = IOAT_CHANCTRL_ERR_INT_EN |
@@ -272,7 +358,7 @@ static int ioat_dma_alloc_chan_resources(struct dma_chan *chan)
 	}
 
 	/* Allocate descriptors */
-	for (i = 0; i < INITIAL_IOAT_DESC_COUNT; i++) {
+	for (i = 0; i < ioat_initial_desc_count; i++) {
 		desc = ioat_dma_alloc_descriptor(ioat_chan, GFP_KERNEL);
 		if (!desc) {
 			dev_err(&ioat_chan->device->pdev->dev,
@@ -282,7 +368,10 @@ static int ioat_dma_alloc_chan_resources(struct dma_chan *chan)
 		list_add_tail(&desc->node, &tmp_list);
 	}
 	spin_lock_bh(&ioat_chan->desc_lock);
+	ioat_chan->desccount = i;
 	list_splice(&tmp_list, &ioat_chan->free_desc);
+	if (ioat_chan->device->version == IOAT_VER_2_0)
+		ioat2_dma_massage_chan_desc(ioat_chan);
 	spin_unlock_bh(&ioat_chan->desc_lock);
 
 	/* allocate a completion writeback area */
@@ -300,9 +389,13 @@ static int ioat_dma_alloc_chan_resources(struct dma_chan *chan)
 
 	tasklet_enable(&ioat_chan->cleanup_task);
 	ioat_dma_start_null_desc(ioat_chan);
-	return i;
+	return ioat_chan->desccount;
 }
 
+/**
+ * ioat_dma_free_chan_resources - release all the descriptors
+ * @chan: the channel to be cleaned
+ */
 static void ioat_dma_free_chan_resources(struct dma_chan *chan)
 {
 	struct ioat_dma_chan *ioat_chan = to_ioat_chan(chan);
@@ -316,22 +409,45 @@ static void ioat_dma_free_chan_resources(struct dma_chan *chan)
 	/* Delay 100ms after reset to allow internal DMA logic to quiesce
 	 * before removing DMA descriptor resources.
 	 */
-	writeb(IOAT_CHANCMD_RESET, ioat_chan->reg_base + IOAT_CHANCMD_OFFSET);
+	writeb(IOAT_CHANCMD_RESET,
+	       ioat_chan->reg_base
+			+ IOAT_CHANCMD_OFFSET(ioat_chan->device->version));
 	mdelay(100);
 
 	spin_lock_bh(&ioat_chan->desc_lock);
-	list_for_each_entry_safe(desc, _desc, &ioat_chan->used_desc, node) {
-		in_use_descs++;
-		list_del(&desc->node);
-		pci_pool_free(ioatdma_device->dma_pool, desc->hw,
-			      desc->async_tx.phys);
-		kfree(desc);
-	}
-	list_for_each_entry_safe(desc, _desc, &ioat_chan->free_desc, node) {
-		list_del(&desc->node);
+	switch (ioat_chan->device->version) {
+	case IOAT_VER_1_2:
+		list_for_each_entry_safe(desc, _desc,
+					 &ioat_chan->used_desc, node) {
+			in_use_descs++;
+			list_del(&desc->node);
+			pci_pool_free(ioatdma_device->dma_pool, desc->hw,
+				      desc->async_tx.phys);
+			kfree(desc);
+		}
+		list_for_each_entry_safe(desc, _desc,
+					 &ioat_chan->free_desc, node) {
+			list_del(&desc->node);
+			pci_pool_free(ioatdma_device->dma_pool, desc->hw,
+				      desc->async_tx.phys);
+			kfree(desc);
+		}
+		break;
+	case IOAT_VER_2_0:
+		list_for_each_entry_safe(desc, _desc,
+					 ioat_chan->free_desc.next, node) {
+			list_del(&desc->node);
+			pci_pool_free(ioatdma_device->dma_pool, desc->hw,
+				      desc->async_tx.phys);
+			kfree(desc);
+		}
+		desc = to_ioat_desc(ioat_chan->free_desc.next);
 		pci_pool_free(ioatdma_device->dma_pool, desc->hw,
 			      desc->async_tx.phys);
 		kfree(desc);
+		INIT_LIST_HEAD(&ioat_chan->free_desc);
+		INIT_LIST_HEAD(&ioat_chan->used_desc);
+		break;
 	}
 	spin_unlock_bh(&ioat_chan->desc_lock);
 
@@ -347,6 +463,7 @@ static void ioat_dma_free_chan_resources(struct dma_chan *chan)
 
 	ioat_chan->last_completion = ioat_chan->completion_addr = 0;
 	ioat_chan->pending = 0;
+	ioat_chan->dmacount = 0;
 }
 /**
  * ioat_dma_get_next_descriptor - return the next available descriptor
@@ -356,7 +473,7 @@ static void ioat_dma_free_chan_resources(struct dma_chan *chan)
  * channel's desc_lock held.  Allocates more descriptors if the channel
  * has run out.
  */
-static struct ioat_desc_sw *ioat_dma_get_next_descriptor(
+static struct ioat_desc_sw *ioat1_dma_get_next_descriptor(
 						struct ioat_dma_chan *ioat_chan)
 {
 	struct ioat_desc_sw *new = NULL;
@@ -376,13 +493,162 @@ static struct ioat_desc_sw *ioat_dma_get_next_descriptor(
 	return new;
 }
 
-static struct dma_async_tx_descriptor *ioat_dma_prep_memcpy(
+static struct ioat_desc_sw *ioat2_dma_get_next_descriptor(
+						struct ioat_dma_chan *ioat_chan)
+{
+	struct ioat_desc_sw *new = NULL;
+
+	/*
+	 * used.prev points to where to start processing
+	 * used.next points to next free descriptor
+	 * if used.prev == NULL, there are none waiting to be processed
+	 * if used.next == used.prev.prev, there is only one free descriptor,
+	 *      and we need to use it to as a noop descriptor before
+	 *      linking in a new set of descriptors, since the device
+	 *      has probably already read the pointer to it
+	 */
+	if (ioat_chan->used_desc.prev &&
+	    ioat_chan->used_desc.next == ioat_chan->used_desc.prev->prev) {
+
+		struct ioat_desc_sw *desc = NULL;
+		struct ioat_desc_sw *noop_desc = NULL;
+		int i;
+
+		/* set up the noop descriptor */
+		noop_desc = to_ioat_desc(ioat_chan->used_desc.next);
+		noop_desc->hw->size = 0;
+		noop_desc->hw->ctl = IOAT_DMA_DESCRIPTOR_NUL;
+		noop_desc->hw->src_addr = 0;
+		noop_desc->hw->dst_addr = 0;
+
+		ioat_chan->used_desc.next = ioat_chan->used_desc.next->next;
+		ioat_chan->pending++;
+		ioat_chan->dmacount++;
+
+		/* get a few more descriptors */
+		for (i = 16; i; i--) {
+			desc = ioat_dma_alloc_descriptor(ioat_chan, GFP_ATOMIC);
+			BUG_ON(!desc);
+			list_add_tail(&desc->node, ioat_chan->used_desc.next);
+
+			desc->hw->next
+				= to_ioat_desc(desc->node.next)->async_tx.phys;
+			to_ioat_desc(desc->node.prev)->hw->next
+				= desc->async_tx.phys;
+			ioat_chan->desccount++;
+		}
+
+		ioat_chan->used_desc.next = noop_desc->node.next;
+	}
+	new = to_ioat_desc(ioat_chan->used_desc.next);
+	ioat_chan->used_desc.next = ioat_chan->used_desc.next->next;
+
+	if (ioat_chan->used_desc.prev == NULL)
+		ioat_chan->used_desc.prev = &new->node;
+
+	prefetch(new->hw);
+	return new;
+}
+
+static struct ioat_desc_sw *ioat_dma_get_next_descriptor(
+						struct ioat_dma_chan *ioat_chan)
+{
+	if (!ioat_chan)
+		return NULL;
+
+	switch (ioat_chan->device->version) {
+	case IOAT_VER_1_2:
+		return ioat1_dma_get_next_descriptor(ioat_chan);
+		break;
+	case IOAT_VER_2_0:
+		return ioat2_dma_get_next_descriptor(ioat_chan);
+		break;
+	}
+	return NULL;
+}
+
+/**
+ * ioat_dma_reset_channel - restart a channel
+ * @ioat_chan: IOAT DMA channel handle
+ */
+static void ioat_dma_reset_channel(struct ioat_dma_chan *ioat_chan)
+{
+	struct ioat_desc_sw *desc;
+	u32 chansts, chanerr;
+
+	chanerr = readl(ioat_chan->reg_base + IOAT_CHANERR_OFFSET);
+	chansts = (ioat_chan->completion_virt->low
+			& IOAT_CHANSTS_DMA_TRANSFER_STATUS);
+	if (chanerr) {
+		dev_err(&ioat_chan->device->pdev->dev,
+			"chan%d, CHANSTS = 0x%08x CHANERR = 0x%04x, clearing\n",
+			chan_num(ioat_chan), chansts, chanerr);
+		writel(chanerr, ioat_chan->reg_base + IOAT_CHANERR_OFFSET);
+	}
+
+	spin_lock_bh(&ioat_chan->cleanup_lock);
+	spin_lock_bh(&ioat_chan->desc_lock);
+
+	/* if we're not stopped yet, stop now */
+	chansts &= IOAT_CHANSTS_DMA_TRANSFER_STATUS_SUSPENDED;
+	if (chansts != IOAT_CHANSTS_DMA_TRANSFER_STATUS_SUSPENDED) {
+		writeb(IOAT_CHANCMD_SUSPEND,
+		       ioat_chan->reg_base
+			    + IOAT_CHANCMD_OFFSET(ioat_chan->device->version));
+		mdelay(100);
+
+		/* if it didn't halt, whack it upside the head with a reset */
+		chansts = readl(ioat_chan->reg_base
+			     + IOAT_CHANSTS_OFFSET(ioat_chan->device->version));
+		chansts &= IOAT_CHANSTS_DMA_TRANSFER_STATUS_SUSPENDED;
+		if (chansts != IOAT_CHANSTS_DMA_TRANSFER_STATUS_SUSPENDED) {
+			writeb(IOAT_CHANCMD_RESET,
+			     ioat_chan->reg_base
+			     + IOAT_CHANCMD_OFFSET(ioat_chan->device->version));
+			mdelay(100); /* ho hum, yawn... */
+		}
+	}
+
+	if (ioat_chan->used_desc.prev) {
+		ioat_chan->completion_virt->low = 0;
+		ioat_chan->completion_virt->high = 0;
+		ioat_chan->pending = 0;
+
+		/* write the new starting descriptor address
+		 * this puts channel engine into ARMED state */
+		desc = to_ioat_desc(ioat_chan->used_desc.prev);
+		writel(((u64) desc->async_tx.phys) & 0x00000000FFFFFFFF,
+		       ioat_chan->reg_base + IOAT2_CHAINADDR_OFFSET_LOW);
+		writel(((u64) desc->async_tx.phys) >> 32,
+		       ioat_chan->reg_base + IOAT2_CHAINADDR_OFFSET_HIGH);
+
+		/* tell the engine to go with what's left to be done */
+		ioat_chan->dmacount = 0;
+		for (desc = to_ioat_desc(ioat_chan->used_desc.prev);
+		     &desc->node != ioat_chan->used_desc.next;
+		     desc = to_ioat_desc(desc->node.next))
+			ioat_chan->dmacount++;
+
+		writew(ioat_chan->dmacount,
+		       ioat_chan->reg_base + IOAT_CHAN_DMACOUNT_OFFSET);
+	}
+
+	dev_err(&ioat_chan->device->pdev->dev,
+		"chan%d reset - %d descs waiting, %d total desc\n",
+		chan_num(ioat_chan), ioat_chan->dmacount, ioat_chan->desccount);
+
+	spin_unlock_bh(&ioat_chan->desc_lock);
+	spin_unlock_bh(&ioat_chan->cleanup_lock);
+}
+
+static struct dma_async_tx_descriptor *ioat1_dma_prep_memcpy(
 						struct dma_chan *chan,
 						size_t len,
 						int int_en)
 {
 	struct ioat_dma_chan *ioat_chan = to_ioat_chan(chan);
 	struct ioat_desc_sw *first, *prev, *new;
+	struct ioat_dma_descriptor *hw;
 	LIST_HEAD(new_chain);
 	u32 copy;
 	size_t orig_len;
@@ -401,8 +667,9 @@ static struct dma_async_tx_descriptor *ioat_dma_prep_memcpy(
 		new = ioat_dma_get_next_descriptor(ioat_chan);
 		copy = min((u32) len, ioat_chan->xfercap);
 
-		new->hw->size = copy;
-		new->hw->ctl = 0;
+		hw = new->hw;
+		hw->size = copy;
+		hw->ctl = 0;
 		new->async_tx.cookie = 0;
 		new->async_tx.ack = 1;
 
@@ -420,8 +687,8 @@ static struct dma_async_tx_descriptor *ioat_dma_prep_memcpy(
 
 	list_splice(&new_chain, &new->async_tx.tx_list);
 
-	new->hw->ctl = IOAT_DMA_DESCRIPTOR_CTL_CP_STS;
-	new->hw->next = 0;
+	hw->ctl = IOAT_DMA_DESCRIPTOR_CTL_CP_STS;
+	hw->next = 0;
 	new->tx_cnt = desc_count;
 	new->async_tx.ack = 0; /* client is in control of this ack */
 	new->async_tx.cookie = -EBUSY;
@@ -432,19 +699,108 @@ static struct dma_async_tx_descriptor *ioat_dma_prep_memcpy(
 	return new ? &new->async_tx : NULL;
 }
 
+static struct dma_async_tx_descriptor *ioat2_dma_prep_memcpy(
+						struct dma_chan *chan,
+						size_t len,
+						int int_en)
+{
+	struct ioat_dma_chan *ioat_chan = to_ioat_chan(chan);
+	struct ioat_desc_sw *first, *new;
+	struct ioat_dma_descriptor *hw;
+	u32 copy;
+	size_t orig_len;
+	int desc_count = 0;
+
+	if (!len)
+		return NULL;
+
+	orig_len = len;
+
+	first = NULL;
+
+	spin_lock_bh(&ioat_chan->desc_lock);
+	do {
+		new = ioat2_dma_get_next_descriptor(ioat_chan);
+		if (!first)
+			first = new;
+		copy = min((u32) len, ioat_chan->xfercap);
+
+		hw = new->hw;
+		hw->size = copy;
+		hw->ctl = 0;
+		new->async_tx.cookie = 0;
+		new->async_tx.ack = 1;
+
+		len  -= copy;
+		desc_count++;
+	} while (len);
+
+	hw->ctl = IOAT_DMA_DESCRIPTOR_CTL_CP_STS;
+	new->tx_cnt = desc_count;
+	new->async_tx.ack = 0; /* client is in control of this ack */
+	new->async_tx.cookie = -EBUSY;
+	new->async_tx.tx_list.next = &first->node;
+
+	pci_unmap_len_set(new, len, orig_len);
+
+	/* leave ioat_chan->desc_lock set in version 2 path */
+
+	return new ? &new->async_tx : NULL;
+}
+
 /**
  * ioat_dma_memcpy_issue_pending - push potentially unrecognized appended
  *                                 descriptors to hw
  * @chan: DMA channel handle
  */
-static void ioat_dma_memcpy_issue_pending(struct dma_chan *chan)
+static inline void __ioat1_dma_memcpy_issue_pending(
+						struct ioat_dma_chan *ioat_chan)
+{
+	ioat_chan->pending = 0;
+	writeb(IOAT_CHANCMD_APPEND, ioat_chan->reg_base + IOAT1_CHANCMD_OFFSET);
+}
+
+static void ioat1_dma_memcpy_issue_pending(struct dma_chan *chan)
 {
 	struct ioat_dma_chan *ioat_chan = to_ioat_chan(chan);
 
 	if (ioat_chan->pending != 0) {
-		ioat_chan->pending = 0;
-		writeb(IOAT_CHANCMD_APPEND,
-		       ioat_chan->reg_base + IOAT_CHANCMD_OFFSET);
+		spin_lock_bh(&ioat_chan->desc_lock);
+		__ioat1_dma_memcpy_issue_pending(ioat_chan);
+		spin_unlock_bh(&ioat_chan->desc_lock);
+	}
+}
+
+static inline void __ioat2_dma_memcpy_issue_pending(
+						struct ioat_dma_chan *ioat_chan)
+{
+	ioat_chan->pending = 0;
+	writew(ioat_chan->dmacount,
+	       ioat_chan->reg_base + IOAT_CHAN_DMACOUNT_OFFSET);
+}
+
+static void ioat2_dma_memcpy_issue_pending(struct dma_chan *chan)
+{
+	struct ioat_dma_chan *ioat_chan = to_ioat_chan(chan);
+
+	if (ioat_chan->pending != 0) {
+		spin_lock_bh(&ioat_chan->desc_lock);
+		__ioat2_dma_memcpy_issue_pending(ioat_chan);
+		spin_unlock_bh(&ioat_chan->desc_lock);
+	}
+}
+
+static void ioat_dma_memcpy_issue_pending(struct dma_chan *chan)
+{
+	struct ioat_dma_chan *ioat_chan = to_ioat_chan(chan);
+
+	switch (ioat_chan->device->version) {
+	case IOAT_VER_1_2:
+		ioat1_dma_memcpy_issue_pending(chan);
+		break;
+	case IOAT_VER_2_0:
+		ioat2_dma_memcpy_issue_pending(chan);
+		break;
 	}
 }
 
@@ -456,15 +812,21 @@ static void ioat_dma_cleanup_tasklet(unsigned long data)
 	       chan->reg_base + IOAT_CHANCTRL_OFFSET);
 }
 
+/**
+ * ioat_dma_memcpy_cleanup - cleanup up finished descriptors
+ * @chan: ioat channel to be cleaned up
+ */
 static void ioat_dma_memcpy_cleanup(struct ioat_dma_chan *ioat_chan)
 {
 	unsigned long phys_complete;
 	struct ioat_desc_sw *desc, *_desc;
 	dma_cookie_t cookie = 0;
+	unsigned long desc_phys;
+	struct ioat_desc_sw *latest_desc;
 
 	prefetch(ioat_chan->completion_virt);
 
-	if (!spin_trylock(&ioat_chan->cleanup_lock))
+	if (!spin_trylock_bh(&ioat_chan->cleanup_lock))
 		return;
 
 	/* The completion writeback can happen at any time,
@@ -474,12 +836,15 @@ static void ioat_dma_memcpy_cleanup(struct ioat_dma_chan *ioat_chan)
 
 #if (BITS_PER_LONG == 64)
 	phys_complete =
-	ioat_chan->completion_virt->full & IOAT_CHANSTS_COMPLETED_DESCRIPTOR_ADDR;
+	ioat_chan->completion_virt->full
+				& IOAT_CHANSTS_COMPLETED_DESCRIPTOR_ADDR;
 #else
-	phys_complete = ioat_chan->completion_virt->low & IOAT_LOW_COMPLETION_MASK;
+	phys_complete = ioat_chan->completion_virt->low
+				& IOAT_LOW_COMPLETION_MASK;
 #endif
 
-	if ((ioat_chan->completion_virt->full & IOAT_CHANSTS_DMA_TRANSFER_STATUS) ==
+	if ((ioat_chan->completion_virt->full
+		& IOAT_CHANSTS_DMA_TRANSFER_STATUS_SUSPENDED) ==
 				IOAT_CHANSTS_DMA_TRANSFER_STATUS_HALTED) {
 		dev_err(&ioat_chan->device->pdev->dev,
 			"ioatdma: Channel halted, chanerr = %x\n",
@@ -489,57 +854,111 @@ static void ioat_dma_memcpy_cleanup(struct ioat_dma_chan *ioat_chan)
 	}
 
 	if (phys_complete == ioat_chan->last_completion) {
-		spin_unlock(&ioat_chan->cleanup_lock);
+		spin_unlock_bh(&ioat_chan->cleanup_lock);
 		return;
 	}
 
 	cookie = 0;
 	spin_lock_bh(&ioat_chan->desc_lock);
-	list_for_each_entry_safe(desc, _desc, &ioat_chan->used_desc, node) {
-
-		/*
-		 * Incoming DMA requests may use multiple descriptors, due to
-		 * exceeding xfercap, perhaps. If so, only the last one will
-		 * have a cookie, and require unmapping.
-		 */
-		if (desc->async_tx.cookie) {
-			cookie = desc->async_tx.cookie;
+	switch (ioat_chan->device->version) {
+	case IOAT_VER_1_2:
+		list_for_each_entry_safe(desc, _desc,
+					 &ioat_chan->used_desc, node) {
 
 			/*
-			 * yes we are unmapping both _page and _single alloc'd
-			 * regions with unmap_page. Is this *really* that bad?
+			 * Incoming DMA requests may use multiple descriptors,
+			 * due to exceeding xfercap, perhaps. If so, only the
+			 * last one will have a cookie, and require unmapping.
 			 */
-			pci_unmap_page(ioat_chan->device->pdev,
-					pci_unmap_addr(desc, dst),
-					pci_unmap_len(desc, len),
-					PCI_DMA_FROMDEVICE);
-			pci_unmap_page(ioat_chan->device->pdev,
-					pci_unmap_addr(desc, src),
-					pci_unmap_len(desc, len),
-					PCI_DMA_TODEVICE);
-		}
+			if (desc->async_tx.cookie) {
+				cookie = desc->async_tx.cookie;
+
+				/*
+				 * yes we are unmapping both _page and _single
+				 * alloc'd regions with unmap_page. Is this
+				 * *really* that bad?
+				 */
+				pci_unmap_page(ioat_chan->device->pdev,
+						pci_unmap_addr(desc, dst),
+						pci_unmap_len(desc, len),
+						PCI_DMA_FROMDEVICE);
+				pci_unmap_page(ioat_chan->device->pdev,
+						pci_unmap_addr(desc, src),
+						pci_unmap_len(desc, len),
+						PCI_DMA_TODEVICE);
+			}
 
-		if (desc->async_tx.phys != phys_complete) {
-			/*
-			 * a completed entry, but not the last, so cleanup
-			 * if the client is done with the descriptor
-			 */
-			if (desc->async_tx.ack) {
-				list_del(&desc->node);
-				list_add_tail(&desc->node,
-					      &ioat_chan->free_desc);
-			} else
+			if (desc->async_tx.phys != phys_complete) {
+				/*
+				 * a completed entry, but not the last, so clean
+				 * up if the client is done with the descriptor
+				 */
+				if (desc->async_tx.ack) {
+					list_del(&desc->node);
+					list_add_tail(&desc->node,
+						      &ioat_chan->free_desc);
+				} else
+					desc->async_tx.cookie = 0;
+			} else {
+				/*
+				 * last used desc. Do not remove, so we can
+				 * append from it, but don't look at it next
+				 * time, either
+				 */
 				desc->async_tx.cookie = 0;
-		} else {
-			/*
-			 * last used desc. Do not remove, so we can append from
-			 * it, but don't look at it next time, either
-			 */
-			desc->async_tx.cookie = 0;
 
-			/* TODO check status bits? */
+				/* TODO check status bits? */
+				break;
+			}
+		}
+		break;
+	case IOAT_VER_2_0:
+		/* has some other thread has already cleaned up? */
+		if (ioat_chan->used_desc.prev == NULL)
 			break;
+
+		/* work backwards to find latest finished desc */
+		desc = to_ioat_desc(ioat_chan->used_desc.next);
+		latest_desc = NULL;
+		do {
+			desc = to_ioat_desc(desc->node.prev);
+			desc_phys = (unsigned long)desc->async_tx.phys
+				       & IOAT_CHANSTS_COMPLETED_DESCRIPTOR_ADDR;
+			if (desc_phys == phys_complete) {
+				latest_desc = desc;
+				break;
+			}
+		} while (&desc->node != ioat_chan->used_desc.prev);
+
+		if (latest_desc != NULL) {
+
+			/* work forwards to clear finished descriptors */
+			for (desc = to_ioat_desc(ioat_chan->used_desc.prev);
+			     &desc->node != latest_desc->node.next &&
+			     &desc->node != ioat_chan->used_desc.next;
+			     desc = to_ioat_desc(desc->node.next)) {
+				if (desc->async_tx.cookie) {
+					cookie = desc->async_tx.cookie;
+					desc->async_tx.cookie = 0;
+
+					pci_unmap_page(ioat_chan->device->pdev,
+						      pci_unmap_addr(desc, dst),
+						      pci_unmap_len(desc, len),
+						      PCI_DMA_FROMDEVICE);
+					pci_unmap_page(ioat_chan->device->pdev,
+						      pci_unmap_addr(desc, src),
+						      pci_unmap_len(desc, len),
+						      PCI_DMA_TODEVICE);
+				}
+			}
+
+			/* move used.prev up beyond those that are finished */
+			if (&desc->node == ioat_chan->used_desc.next)
+				ioat_chan->used_desc.prev = NULL;
+			else
+				ioat_chan->used_desc.prev = &desc->node;
 		}
+		break;
 	}
 
 	spin_unlock_bh(&ioat_chan->desc_lock);
@@ -548,7 +967,7 @@ static void ioat_dma_memcpy_cleanup(struct ioat_dma_chan *ioat_chan)
 	if (cookie != 0)
 		ioat_chan->completed_cookie = cookie;
 
-	spin_unlock(&ioat_chan->cleanup_lock);
+	spin_unlock_bh(&ioat_chan->cleanup_lock);
 }
 
 static void ioat_dma_dependency_added(struct dma_chan *chan)
@@ -579,6 +998,33 @@ static enum dma_status ioat_dma_is_complete(struct dma_chan *chan,
 	dma_cookie_t last_complete;
 	enum dma_status ret;
 
+	if (cookie == ioat_chan->old_cookie) {
+		u32 chansts;
+
+		ioat_chan->check_count++;
+		chansts = (ioat_chan->completion_virt->low
+					& IOAT_CHANSTS_DMA_TRANSFER_STATUS);
+		if ((chansts == IOAT_CHANSTS_DMA_TRANSFER_STATUS_HALTED) ||
+		    (chansts == IOAT_CHANSTS_DMA_TRANSFER_STATUS_SUSPENDED) ||
+		    (ioat_chan->check_count == 100000)) {
+			ioat_chan->reset_count++;
+			dev_warn(&ioat_chan->device->pdev->dev,
+				 "chan%d reset %d, cookie %d x %d, "
+				 "last_completed %d, chansts %02x\n",
+				 chan_num(ioat_chan), ioat_chan->reset_count,
+				 cookie, ioat_chan->check_count,
+				 ioat_chan->completed_cookie, chansts);
+			ioat_chan->check_count = 0;
+
+			/* we're not progressing, so reset the engine */
+			ioat_dma_reset_channel(ioat_chan);
+		} else if (ioat_chan->check_count == 10000) {
+			ioat_dma_memcpy_issue_pending(chan);
+		}
+	} else {
+		ioat_chan->old_cookie = cookie;
+		ioat_chan->check_count = 0;
+	}
 	last_used = chan->cookie;
 	last_complete = ioat_chan->completed_cookie;
 
@@ -613,19 +1059,46 @@ static void ioat_dma_start_null_desc(struct ioat_dma_chan *ioat_chan)
 	spin_lock_bh(&ioat_chan->desc_lock);
 
 	desc = ioat_dma_get_next_descriptor(ioat_chan);
-	desc->hw->ctl = IOAT_DMA_DESCRIPTOR_NUL;
-	desc->hw->next = 0;
-	desc->async_tx.ack = 1;
-
-	list_add_tail(&desc->node, &ioat_chan->used_desc);
+	switch (ioat_chan->device->version) {
+	case IOAT_VER_1_2:
+		desc->hw->ctl = IOAT_DMA_DESCRIPTOR_NUL
+					| IOAT_DMA_DESCRIPTOR_CTL_INT_GN;
+		desc->hw->next = 0;
+
+		list_add_tail(&desc->node, &ioat_chan->used_desc);
+
+		writel(((u64) desc->async_tx.phys) & 0x00000000FFFFFFFF,
+		       ioat_chan->reg_base + IOAT1_CHAINADDR_OFFSET_LOW);
+		writel(((u64) desc->async_tx.phys) >> 32,
+		       ioat_chan->reg_base + IOAT1_CHAINADDR_OFFSET_HIGH);
+
+		writeb(IOAT_CHANCMD_START,
+		       ioat_chan->reg_base
+			   + IOAT_CHANCMD_OFFSET(ioat_chan->device->version));
+		break;
+	case IOAT_VER_2_0:
+		/* Prime the engine with the first descriptor and fire it off
+		 * to get the DCA context setup.
+		 */
+		desc->hw->ctl = IOAT_DMA_DESCRIPTOR_NUL
+					| IOAT_DMA_DESCRIPTOR_CTL_INT_GN;
+		desc->hw->size = 0;
+		desc->hw->src_addr = 0;
+		desc->hw->dst_addr = 0;
+
+		writel(((u64) desc->async_tx.phys) & 0x00000000FFFFFFFF,
+		       ioat_chan->reg_base + IOAT2_CHAINADDR_OFFSET_LOW);
+		writel(((u64) desc->async_tx.phys) >> 32,
+		       ioat_chan->reg_base + IOAT2_CHAINADDR_OFFSET_HIGH);
+
+		ioat_chan->pending = 1;
+		ioat_chan->dmacount = 1;
+
+		writew(ioat_chan->dmacount,
+		       ioat_chan->reg_base + IOAT_CHAN_DMACOUNT_OFFSET);
+		break;
+	}
 	spin_unlock_bh(&ioat_chan->desc_lock);
-
-	writel(((u64) desc->async_tx.phys) & 0x00000000FFFFFFFF,
-	       ioat_chan->reg_base + IOAT_CHAINADDR_OFFSET_LOW);
-	writel(((u64) desc->async_tx.phys) >> 32,
-	       ioat_chan->reg_base + IOAT_CHAINADDR_OFFSET_HIGH);
-
-	writeb(IOAT_CHANCMD_START, ioat_chan->reg_base + IOAT_CHANCMD_OFFSET);
 }
 
 /*
@@ -643,9 +1116,9 @@ static int ioat_dma_self_test(struct ioatdma_device *device)
 	u8 *src;
 	u8 *dest;
 	struct dma_chan *dma_chan;
-	struct dma_async_tx_descriptor *tx;
+	struct dma_async_tx_descriptor *tx = NULL;
 	dma_addr_t addr;
-	dma_cookie_t cookie;
+	dma_cookie_t cookie = -1;
 	int err = 0;
 
 	src = kzalloc(sizeof(u8) * IOAT_TEST_SIZE, GFP_KERNEL);
@@ -672,15 +1145,30 @@ static int ioat_dma_self_test(struct ioatdma_device *device)
 		goto out;
 	}
 
-	tx = ioat_dma_prep_memcpy(dma_chan, IOAT_TEST_SIZE, 0);
+	switch (device->version) {
+	case IOAT_VER_1_2:
+		tx = ioat1_dma_prep_memcpy(dma_chan, IOAT_TEST_SIZE, 0);
+		break;
+	case IOAT_VER_2_0:
+		tx = ioat2_dma_prep_memcpy(dma_chan, IOAT_TEST_SIZE, 0);
+		break;
+	}
+
 	async_tx_ack(tx);
 	addr = dma_map_single(dma_chan->device->dev, src, IOAT_TEST_SIZE,
 			DMA_TO_DEVICE);
-	ioat_set_src(addr, tx, 0);
+	tx->tx_set_src(addr, tx, 0);
 	addr = dma_map_single(dma_chan->device->dev, dest, IOAT_TEST_SIZE,
 			DMA_FROM_DEVICE);
-	ioat_set_dest(addr, tx, 0);
-	cookie = ioat_tx_submit(tx);
+	tx->tx_set_dest(addr, tx, 0);
+
+	cookie = tx->tx_submit(tx);
+	if (cookie < 0) {
+		dev_err(&device->pdev->dev,
+			"ioatdma: Self-test setup failed, disabling\n");
+		err = -ENODEV;
+		goto free_resources;
+	}
 	ioat_dma_memcpy_issue_pending(dma_chan);
 	msleep(1);
 
@@ -894,17 +1382,28 @@ struct ioatdma_device *ioat_dma_probe(struct pci_dev *pdev,
 
 	INIT_LIST_HEAD(&device->common.channels);
 	ioat_dma_enumerate_channels(device);
+	device->common.dev = &pdev->dev;
 
 	dma_cap_set(DMA_MEMCPY, device->common.cap_mask);
 	device->common.device_alloc_chan_resources =
 						ioat_dma_alloc_chan_resources;
 	device->common.device_free_chan_resources =
 						ioat_dma_free_chan_resources;
-	device->common.device_prep_dma_memcpy = ioat_dma_prep_memcpy;
 	device->common.device_is_tx_complete = ioat_dma_is_complete;
-	device->common.device_issue_pending = ioat_dma_memcpy_issue_pending;
 	device->common.device_dependency_added = ioat_dma_dependency_added;
-	device->common.dev = &pdev->dev;
+	switch (device->version) {
+	case IOAT_VER_1_2:
+		device->common.device_prep_dma_memcpy = ioat1_dma_prep_memcpy;
+		device->common.device_issue_pending =
+						ioat1_dma_memcpy_issue_pending;
+		break;
+	case IOAT_VER_2_0:
+		device->common.device_prep_dma_memcpy = ioat2_dma_prep_memcpy;
+		device->common.device_issue_pending =
+						ioat2_dma_memcpy_issue_pending;
+		break;
+	}
+
 	dev_err(&device->pdev->dev,
 		"ioatdma: Intel(R) I/OAT DMA Engine found,"
 		" %d channels, device version 0x%02x\n",
diff --git a/drivers/dma/ioatdma.h b/drivers/dma/ioatdma.h
index 2a319e1..ac86705 100644
--- a/drivers/dma/ioatdma.h
+++ b/drivers/dma/ioatdma.h
@@ -1,5 +1,5 @@
 /*
- * Copyright(c) 2004 - 2006 Intel Corporation. All rights reserved.
+ * Copyright(c) 2004 - 2007 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
@@ -45,6 +45,9 @@ enum ioat_interrupt {
  * @dma_pool: for allocating DMA descriptors
  * @common: embedded struct dma_device
  * @version: version of ioatdma device
+ * @irq_mode: which style irq to use
+ * @msix_entries: irq handlers
+ * @idx: per channel data
  */
 
 struct ioatdma_device {
@@ -61,23 +64,7 @@ struct ioatdma_device {
 
 /**
  * struct ioat_dma_chan - internal representation of a DMA channel
- * @device:
- * @reg_base:
- * @sw_in_use:
- * @completion:
- * @completion_low:
- * @completion_high:
- * @completed_cookie: last cookie seen completed on cleanup
- * @cookie: value of last cookie given to client
- * @last_completion:
- * @xfercap:
- * @desc_lock:
- * @free_desc:
- * @used_desc:
- * @resource:
- * @device_node:
  */
-
 struct ioat_dma_chan {
 
 	void __iomem *reg_base;
@@ -92,7 +79,12 @@ struct ioat_dma_chan {
 	struct list_head free_desc;
 	struct list_head used_desc;
 
-	int pending;
+	u32 pending;
+	u32 dmacount;
+	int desccount;
+	int check_count;
+	int old_cookie;
+	int reset_count;
 
 	struct ioatdma_device *device;
 	struct dma_chan common;
@@ -132,12 +124,13 @@ struct ioat_desc_sw {
 struct ioatdma_device *ioat_dma_probe(struct pci_dev *pdev,
 				      void __iomem *iobase);
 void ioat_dma_remove(struct ioatdma_device *device);
-struct dca_provider *ioat_dca_init(struct pci_dev *pdev,
-				   void __iomem *iobase);
+struct dca_provider *ioat_dca_init(struct pci_dev *pdev, void __iomem *iobase);
+struct dca_provider *ioat2_dca_init(struct pci_dev *pdev, void __iomem *iobase);
 #else
 #define ioat_dma_probe(pdev, iobase)    NULL
 #define ioat_dma_remove(device)         do { } while (0)
 #define ioat_dca_init(pdev, iobase)	NULL
+#define ioat2_dca_init(pdev, iobase)	NULL
 #endif
 
 #endif /* IOATDMA_H */
diff --git a/drivers/dma/ioatdma_hw.h b/drivers/dma/ioatdma_hw.h
index 9e7434e..b54c7b3 100644
--- a/drivers/dma/ioatdma_hw.h
+++ b/drivers/dma/ioatdma_hw.h
@@ -28,6 +28,7 @@
 #define IOAT_PCI_SVID			0x8086
 #define IOAT_PCI_SID			0x8086
 #define IOAT_VER_1_2			0x12	/* Version 1.2 */
+#define IOAT_VER_2_0			0x20	/* Version 2.0 */
 
 struct ioat_dma_descriptor {
 	uint32_t	size;
diff --git a/drivers/dma/ioatdma_registers.h b/drivers/dma/ioatdma_registers.h
index baaab5e..cdb9beb 100644
--- a/drivers/dma/ioatdma_registers.h
+++ b/drivers/dma/ioatdma_registers.h
@@ -42,26 +42,25 @@
 #define IOAT_INTRCTRL_MASTER_INT_EN		0x01	/* Master Interrupt Enable */
 #define IOAT_INTRCTRL_INT_STATUS		0x02	/* ATTNSTATUS -or- Channel Int */
 #define IOAT_INTRCTRL_INT			0x04	/* INT_STATUS -and- MASTER_INT_EN */
-#define IOAT_INTRCTRL_MSIX_VECTOR_CONTROL	0x08    /* Enable all MSI-X vectors */
+#define IOAT_INTRCTRL_MSIX_VECTOR_CONTROL	0x08	/* Enable all MSI-X vectors */
 
 #define IOAT_ATTNSTATUS_OFFSET			0x04	/* Each bit is a channel */
 
 #define IOAT_VER_OFFSET				0x08	/*  8-bit */
 #define IOAT_VER_MAJOR_MASK			0xF0
 #define IOAT_VER_MINOR_MASK			0x0F
-#define GET_IOAT_VER_MAJOR(x)			((x) & IOAT_VER_MAJOR_MASK)
+#define GET_IOAT_VER_MAJOR(x)			(((x) & IOAT_VER_MAJOR_MASK) >> 4)
 #define GET_IOAT_VER_MINOR(x)			((x) & IOAT_VER_MINOR_MASK)
 
 #define IOAT_PERPORTOFFSET_OFFSET		0x0A	/* 16-bit */
 
 #define IOAT_INTRDELAY_OFFSET			0x0C	/* 16-bit */
 #define IOAT_INTRDELAY_INT_DELAY_MASK		0x3FFF	/* Interrupt Delay Time */
-#define IOAT_INTRDELAY_COALESE_SUPPORT		0x8000	/* Interrupt Coalesing Supported */
+#define IOAT_INTRDELAY_COALESE_SUPPORT		0x8000	/* Interrupt Coalescing Supported */
 
 #define IOAT_DEVICE_STATUS_OFFSET		0x0E	/* 16-bit */
 #define IOAT_DEVICE_STATUS_DEGRADED_MODE	0x0001
 
-
 #define IOAT_CHANNEL_MMIO_SIZE			0x80	/* Each Channel MMIO space is this size */
 
 /* DMA Channel Registers */
@@ -74,25 +73,99 @@
 #define IOAT_CHANCTRL_ERR_COMPLETION_EN		0x0004
 #define IOAT_CHANCTRL_INT_DISABLE		0x0001
 
-#define IOAT_DMA_COMP_OFFSET			0x02	/* 16-bit DMA channel compatability */
-#define IOAT_DMA_COMP_V1			0x0001	/* Compatability with DMA version 1 */
-
-#define IOAT_CHANSTS_OFFSET			0x04	/* 64-bit Channel Status Register */
-#define IOAT_CHANSTS_OFFSET_LOW			0x04
-#define IOAT_CHANSTS_OFFSET_HIGH		0x08
-#define IOAT_CHANSTS_COMPLETED_DESCRIPTOR_ADDR	0xFFFFFFFFFFFFFFC0UL
+#define IOAT_DMA_COMP_OFFSET			0x02	/* 16-bit DMA channel compatibility */
+#define IOAT_DMA_COMP_V1			0x0001	/* Compatibility with DMA version 1 */
+#define IOAT_DMA_COMP_V2			0x0002	/* Compatibility with DMA version 2 */
+
+
+#define IOAT1_CHANSTS_OFFSET		0x04	/* 64-bit Channel Status Register */
+#define IOAT2_CHANSTS_OFFSET		0x08	/* 64-bit Channel Status Register */
+#define IOAT_CHANSTS_OFFSET(ver)		((ver) < IOAT_VER_2_0 \
+						? IOAT1_CHANSTS_OFFSET : IOAT2_CHANSTS_OFFSET)
+#define IOAT1_CHANSTS_OFFSET_LOW	0x04
+#define IOAT2_CHANSTS_OFFSET_LOW	0x08
+#define IOAT_CHANSTS_OFFSET_LOW(ver)		((ver) < IOAT_VER_2_0 \
+						? IOAT1_CHANSTS_OFFSET_LOW : IOAT2_CHANSTS_OFFSET_LOW)
+#define IOAT1_CHANSTS_OFFSET_HIGH	0x08
+#define IOAT2_CHANSTS_OFFSET_HIGH	0x0C
+#define IOAT_CHANSTS_OFFSET_HIGH(ver)		((ver) < IOAT_VER_2_0 \
+						? IOAT1_CHANSTS_OFFSET_HIGH : IOAT2_CHANSTS_OFFSET_HIGH)
+#define IOAT_CHANSTS_COMPLETED_DESCRIPTOR_ADDR	~0x3F
 #define IOAT_CHANSTS_SOFT_ERR			0x0000000000000010
+#define IOAT_CHANSTS_UNAFFILIATED_ERR		0x0000000000000008
 #define IOAT_CHANSTS_DMA_TRANSFER_STATUS	0x0000000000000007
 #define IOAT_CHANSTS_DMA_TRANSFER_STATUS_ACTIVE	0x0
 #define IOAT_CHANSTS_DMA_TRANSFER_STATUS_DONE	0x1
 #define IOAT_CHANSTS_DMA_TRANSFER_STATUS_SUSPENDED	0x2
 #define IOAT_CHANSTS_DMA_TRANSFER_STATUS_HALTED	0x3
 
-#define IOAT_CHAINADDR_OFFSET			0x0C	/* 64-bit Descriptor Chain Address Register */
-#define IOAT_CHAINADDR_OFFSET_LOW		0x0C
-#define IOAT_CHAINADDR_OFFSET_HIGH		0x10
 
-#define IOAT_CHANCMD_OFFSET			0x14	/*  8-bit DMA Channel Command Register */
+#define IOAT_CHAN_DMACOUNT_OFFSET	0x06    /* 16-bit DMA Count register */
+
+#define IOAT_DCACTRL_OFFSET         0x30   /* 32 bit Direct Cache Access Control Register */
+#define IOAT_DCACTRL_CMPL_WRITE_ENABLE 0x10000
+#define IOAT_DCACTRL_TARGET_CPU_MASK   0xFFFF /* APIC ID */
+
+/* CB DCA Memory Space Registers */
+#define IOAT_DCAOFFSET_OFFSET       0x14
+/* CB_BAR + IOAT_DCAOFFSET value */
+#define IOAT_DCA_VER_OFFSET         0x00
+#define IOAT_DCA_VER_MAJOR_MASK     0xF0
+#define IOAT_DCA_VER_MINOR_MASK     0x0F
+
+#define IOAT_DCA_COMP_OFFSET        0x02
+#define IOAT_DCA_COMP_V1            0x1
+
+#define IOAT_FSB_CAPABILITY_OFFSET  0x04
+#define IOAT_FSB_CAPABILITY_PREFETCH    0x1
+
+#define IOAT_PCI_CAPABILITY_OFFSET  0x06
+#define IOAT_PCI_CAPABILITY_MEMWR   0x1
+
+#define IOAT_FSB_CAP_ENABLE_OFFSET  0x08
+#define IOAT_FSB_CAP_ENABLE_PREFETCH    0x1
+
+#define IOAT_PCI_CAP_ENABLE_OFFSET  0x0A
+#define IOAT_PCI_CAP_ENABLE_MEMWR   0x1
+
+#define IOAT_APICID_TAG_MAP_OFFSET  0x0C
+#define IOAT_APICID_TAG_MAP_TAG0    0x0000000F
+#define IOAT_APICID_TAG_MAP_TAG0_SHIFT 0
+#define IOAT_APICID_TAG_MAP_TAG1    0x000000F0
+#define IOAT_APICID_TAG_MAP_TAG1_SHIFT 4
+#define IOAT_APICID_TAG_MAP_TAG2    0x00000F00
+#define IOAT_APICID_TAG_MAP_TAG2_SHIFT 8
+#define IOAT_APICID_TAG_MAP_TAG3    0x0000F000
+#define IOAT_APICID_TAG_MAP_TAG3_SHIFT 12
+#define IOAT_APICID_TAG_MAP_TAG4    0x000F0000
+#define IOAT_APICID_TAG_MAP_TAG4_SHIFT 16
+#define IOAT_APICID_TAG_CB2_VALID   0x8080808080
+
+#define IOAT_DCA_GREQID_OFFSET      0x10
+#define IOAT_DCA_GREQID_SIZE        0x04
+#define IOAT_DCA_GREQID_MASK        0xFFFF
+#define IOAT_DCA_GREQID_IGNOREFUN   0x10000000
+#define IOAT_DCA_GREQID_VALID       0x20000000
+#define IOAT_DCA_GREQID_LASTID      0x80000000
+
+
+#define IOAT1_CHAINADDR_OFFSET		0x0C	/* 64-bit Descriptor Chain Address Register */
+#define IOAT2_CHAINADDR_OFFSET		0x10	/* 64-bit Descriptor Chain Address Register */
+#define IOAT_CHAINADDR_OFFSET(ver)		((ver) < IOAT_VER_2_0 \
+						? IOAT1_CHAINADDR_OFFSET : IOAT2_CHAINADDR_OFFSET)
+#define IOAT1_CHAINADDR_OFFSET_LOW	0x0C
+#define IOAT2_CHAINADDR_OFFSET_LOW	0x10
+#define IOAT_CHAINADDR_OFFSET_LOW(ver)		((ver) < IOAT_VER_2_0 \
+						? IOAT1_CHAINADDR_OFFSET_LOW : IOAT2_CHAINADDR_OFFSET_LOW)
+#define IOAT1_CHAINADDR_OFFSET_HIGH	0x10
+#define IOAT2_CHAINADDR_OFFSET_HIGH	0x14
+#define IOAT_CHAINADDR_OFFSET_HIGH(ver)		((ver) < IOAT_VER_2_0 \
+						? IOAT1_CHAINADDR_OFFSET_HIGH : IOAT2_CHAINADDR_OFFSET_HIGH)
+
+#define IOAT1_CHANCMD_OFFSET		0x14	/*  8-bit DMA Channel Command Register */
+#define IOAT2_CHANCMD_OFFSET		0x04	/*  8-bit DMA Channel Command Register */
+#define IOAT_CHANCMD_OFFSET(ver)		((ver) < IOAT_VER_2_0 \
+						? IOAT1_CHANCMD_OFFSET : IOAT2_CHANCMD_OFFSET)
 #define IOAT_CHANCMD_RESET			0x20
 #define IOAT_CHANCMD_RESUME			0x10
 #define IOAT_CHANCMD_ABORT			0x08
@@ -124,6 +197,7 @@
 #define IOAT_CHANERR_COMPLETION_ADDR_ERR	0x1000
 #define IOAT_CHANERR_INT_CONFIGURATION_ERR	0x2000
 #define IOAT_CHANERR_SOFT_ERR			0x4000
+#define IOAT_CHANERR_UNAFFILIATED_ERR		0x8000
 
 #define IOAT_CHANERR_MASK_OFFSET		0x2C	/* 32-bit Channel Error Register */
 
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index c82a964..83084a3 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2294,6 +2294,7 @@
 #define PCI_DEVICE_ID_INTEL_MCH_PC1	0x359a
 #define PCI_DEVICE_ID_INTEL_E7525_MCH	0x359e
 #define PCI_DEVICE_ID_INTEL_IOAT_CNB	0x360b
+#define PCI_DEVICE_ID_INTEL_IOAT_SNB	0x402f
 #define PCI_DEVICE_ID_INTEL_IOAT_SCNB	0x65ff
 #define PCI_DEVICE_ID_INTEL_82371SB_0	0x7000
 #define PCI_DEVICE_ID_INTEL_82371SB_1	0x7010
