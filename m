Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab0CDKLw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 05:11:52 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:57433 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271Ab0CDKKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 05:10:19 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Thu, 04 Mar 2010 02:08:54 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 07/12] genericirq: make hpet_msi/ht/msi/dmar_msi to take desc
In-reply-to: <1267697339-5491-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Eric Biederman <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1267697339-5491-8-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1267697339-5491-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

also keep the old interface.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/hpet.h                 |    4 ++
 arch/x86/kernel/hpet.c                      |   40 ++++++++++++++++++----
 drivers/infiniband/hw/ipath/ipath_iba6110.c |    2 +-
 drivers/pci/dmar.c                          |   33 ++++++++++++++----
 drivers/pci/htirq.c                         |   47 ++++++++++++++++++++-------
 drivers/pci/msi.c                           |   17 +++++++--
 include/linux/dmar.h                        |    4 ++
 include/linux/htirq.h                       |    7 +++-
 8 files changed, 120 insertions(+), 34 deletions(-)

diff --git a/arch/x86/include/asm/hpet.h b/arch/x86/include/asm/hpet.h
index 1d5c08a..9b9318d 100644
--- a/arch/x86/include/asm/hpet.h
+++ b/arch/x86/include/asm/hpet.h
@@ -78,6 +78,10 @@ extern void hpet_msi_unmask(unsigned int irq);
 extern void hpet_msi_mask(unsigned int irq);
 extern void hpet_msi_write(unsigned int irq, struct msi_msg *msg);
 extern void hpet_msi_read(unsigned int irq, struct msi_msg *msg);
+extern void hpet_msi_unmask_desc(struct irq_desc *);
+extern void hpet_msi_mask_desc(struct irq_desc *);
+extern void hpet_msi_write_desc(struct irq_desc *desc, struct msi_msg *msg);
+extern void hpet_msi_read_desc(struct irq_desc *desc, struct msi_msg *msg);
 
 #ifdef CONFIG_PCI_MSI
 extern int arch_setup_hpet_msi(unsigned int irq, unsigned int id);
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index ee4fa1b..4d7b637 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -426,9 +426,9 @@ static int hpet_legacy_next_event(unsigned long delta,
 static DEFINE_PER_CPU(struct hpet_dev *, cpu_hpet_dev);
 static struct hpet_dev	*hpet_devs;
 
-void hpet_msi_unmask(unsigned int irq)
+void hpet_msi_unmask_desc(struct irq_desc *desc)
 {
-	struct hpet_dev *hdev = get_irq_data(irq);
+	struct hpet_dev *hdev = get_irq_desc_data(desc);
 	unsigned int cfg;
 
 	/* unmask it */
@@ -436,34 +436,58 @@ void hpet_msi_unmask(unsigned int irq)
 	cfg |= HPET_TN_FSB;
 	hpet_writel(cfg, HPET_Tn_CFG(hdev->num));
 }
+void hpet_msi_unmask(unsigned int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
 
-void hpet_msi_mask(unsigned int irq)
+	hpet_msi_unmask_desc(desc);
+}
+
+void hpet_msi_mask_desc(struct irq_desc *desc)
 {
 	unsigned int cfg;
-	struct hpet_dev *hdev = get_irq_data(irq);
+	struct hpet_dev *hdev = get_irq_desc_data(desc);
 
 	/* mask it */
 	cfg = hpet_readl(HPET_Tn_CFG(hdev->num));
 	cfg &= ~HPET_TN_FSB;
 	hpet_writel(cfg, HPET_Tn_CFG(hdev->num));
 }
+void hpet_msi_mask(unsigned int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
 
-void hpet_msi_write(unsigned int irq, struct msi_msg *msg)
+	hpet_msi_mask_desc(desc);
+}
+
+void hpet_msi_write_desc(struct irq_desc *desc, struct msi_msg *msg)
 {
-	struct hpet_dev *hdev = get_irq_data(irq);
+	struct hpet_dev *hdev = get_irq_desc_data(desc);
 
 	hpet_writel(msg->data, HPET_Tn_ROUTE(hdev->num));
 	hpet_writel(msg->address_lo, HPET_Tn_ROUTE(hdev->num) + 4);
 }
+void hpet_msi_write(unsigned int irq, struct msi_msg *msg)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
 
-void hpet_msi_read(unsigned int irq, struct msi_msg *msg)
+	hpet_msi_write_desc(desc, msg);
+}
+
+void hpet_msi_read_desc(struct irq_desc *desc, struct msi_msg *msg)
 {
-	struct hpet_dev *hdev = get_irq_data(irq);
+	struct hpet_dev *hdev = get_irq_desc_data(desc);
 
 	msg->data = hpet_readl(HPET_Tn_ROUTE(hdev->num));
 	msg->address_lo = hpet_readl(HPET_Tn_ROUTE(hdev->num) + 4);
 	msg->address_hi = 0;
 }
+void hpet_msi_read(unsigned int irq, struct msi_msg *msg)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	hpet_msi_read_desc(desc, msg);
+}
 
 static void hpet_msi_set_mode(enum clock_event_mode mode,
 				struct clock_event_device *evt)
diff --git a/drivers/infiniband/hw/ipath/ipath_iba6110.c b/drivers/infiniband/hw/ipath/ipath_iba6110.c
index 37d12e5..4cbae45 100644
--- a/drivers/infiniband/hw/ipath/ipath_iba6110.c
+++ b/drivers/infiniband/hw/ipath/ipath_iba6110.c
@@ -986,7 +986,7 @@ static int ipath_ht_intconfig(struct ipath_devdata *dd)
 	return ret;
 }
 
-static void ipath_ht_irq_update(struct pci_dev *dev, int irq,
+static void ipath_ht_irq_update(struct pci_dev *dev, struct irq_desc *desc,
 				struct ht_irq_msg *msg)
 {
 	struct ipath_devdata *dd = pci_get_drvdata(dev);
diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index 83aae47..3adc898 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -1230,9 +1230,9 @@ const char *dmar_get_fault_reason(u8 fault_reason, int *fault_type)
 	}
 }
 
-void dmar_msi_unmask(unsigned int irq)
+void dmar_msi_unmask_desc(struct irq_desc *desc)
 {
-	struct intel_iommu *iommu = get_irq_data(irq);
+	struct intel_iommu *iommu = get_irq_desc_data(desc);
 	unsigned long flag;
 
 	/* unmask it */
@@ -1242,11 +1242,15 @@ void dmar_msi_unmask(unsigned int irq)
 	readl(iommu->reg + DMAR_FECTL_REG);
 	spin_unlock_irqrestore(&iommu->register_lock, flag);
 }
+void dmar_msi_unmask(unsigned int irq)
+{
+	dmar_msi_unmask_desc(irq_to_desc(irq));
+}
 
-void dmar_msi_mask(unsigned int irq)
+void dmar_msi_mask_desc(struct irq_desc *desc)
 {
 	unsigned long flag;
-	struct intel_iommu *iommu = get_irq_data(irq);
+	struct intel_iommu *iommu = get_irq_desc_data(desc);
 
 	/* mask it */
 	spin_lock_irqsave(&iommu->register_lock, flag);
@@ -1256,9 +1260,14 @@ void dmar_msi_mask(unsigned int irq)
 	spin_unlock_irqrestore(&iommu->register_lock, flag);
 }
 
-void dmar_msi_write(int irq, struct msi_msg *msg)
+void dmar_msi_mask(unsigned int irq)
 {
-	struct intel_iommu *iommu = get_irq_data(irq);
+	dmar_msi_mask_desc(irq_to_desc(irq));
+}
+
+void dmar_msi_write_desc(struct irq_desc *desc, struct msi_msg *msg)
+{
+	struct intel_iommu *iommu = get_irq_desc_data(desc);
 	unsigned long flag;
 
 	spin_lock_irqsave(&iommu->register_lock, flag);
@@ -1267,10 +1276,14 @@ void dmar_msi_write(int irq, struct msi_msg *msg)
 	writel(msg->address_hi, iommu->reg + DMAR_FEUADDR_REG);
 	spin_unlock_irqrestore(&iommu->register_lock, flag);
 }
+void dmar_msi_write(int irq, struct msi_msg *msg)
+{
+	dmar_msi_write_desc(irq_to_desc(irq), msg);
+}
 
-void dmar_msi_read(int irq, struct msi_msg *msg)
+void dmar_msi_read_desc(struct irq_desc *desc, struct msi_msg *msg)
 {
-	struct intel_iommu *iommu = get_irq_data(irq);
+	struct intel_iommu *iommu = get_irq_desc_data(desc);
 	unsigned long flag;
 
 	spin_lock_irqsave(&iommu->register_lock, flag);
@@ -1280,6 +1293,10 @@ void dmar_msi_read(int irq, struct msi_msg *msg)
 	spin_unlock_irqrestore(&iommu->register_lock, flag);
 }
 
+void dmar_msi_read(int irq, struct msi_msg *msg)
+{
+	dmar_msi_read_desc(irq_to_desc(irq), msg);
+}
 static int dmar_fault_do_one(struct intel_iommu *iommu, int type,
 		u8 fault_reason, u16 source_id, unsigned long long addr)
 {
diff --git a/drivers/pci/htirq.c b/drivers/pci/htirq.c
index 737a1c4..ff36da7 100644
--- a/drivers/pci/htirq.c
+++ b/drivers/pci/htirq.c
@@ -32,10 +32,9 @@ struct ht_irq_cfg {
 	struct ht_irq_msg msg;
 };
 
-
-void write_ht_irq_msg(unsigned int irq, struct ht_irq_msg *msg)
+void write_ht_irq_desc_msg(struct irq_desc *desc, struct ht_irq_msg *msg)
 {
-	struct ht_irq_cfg *cfg = get_irq_data(irq);
+	struct ht_irq_cfg *cfg = get_irq_desc_data(desc);
 	unsigned long flags;
 	spin_lock_irqsave(&ht_irq_lock, flags);
 	if (cfg->msg.address_lo != msg->address_lo) {
@@ -47,39 +46,63 @@ void write_ht_irq_msg(unsigned int irq, struct ht_irq_msg *msg)
 		pci_write_config_dword(cfg->dev, cfg->pos + 4, msg->address_hi);
 	}
 	if (cfg->update)
-		cfg->update(cfg->dev, irq, msg);
+		cfg->update(cfg->dev, desc, msg);
 	spin_unlock_irqrestore(&ht_irq_lock, flags);
 	cfg->msg = *msg;
 }
+void write_ht_irq_msg(unsigned int irq, struct ht_irq_msg *msg)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
 
-void fetch_ht_irq_msg(unsigned int irq, struct ht_irq_msg *msg)
+	write_ht_irq_desc_msg(desc, msg);
+}
+
+void fetch_ht_irq_desc_msg(struct irq_desc *desc, struct ht_irq_msg *msg)
 {
-	struct ht_irq_cfg *cfg = get_irq_data(irq);
+	struct ht_irq_cfg *cfg = get_irq_desc_data(desc);
 	*msg = cfg->msg;
 }
+void fetch_ht_irq_msg(unsigned int irq, struct ht_irq_msg *msg)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	fetch_ht_irq_desc_msg(desc, msg);
+}
 
-void mask_ht_irq(unsigned int irq)
+void mask_ht_irq_desc(struct irq_desc *desc)
 {
 	struct ht_irq_cfg *cfg;
 	struct ht_irq_msg msg;
 
-	cfg = get_irq_data(irq);
+	cfg = get_irq_desc_data(desc);
 
 	msg = cfg->msg;
 	msg.address_lo |= 1;
-	write_ht_irq_msg(irq, &msg);
+	write_ht_irq_desc_msg(desc, &msg);
+}
+void mask_ht_irq(unsigned int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	mask_ht_irq_desc(desc);
 }
 
-void unmask_ht_irq(unsigned int irq)
+void unmask_ht_irq_desc(struct irq_desc *desc)
 {
 	struct ht_irq_cfg *cfg;
 	struct ht_irq_msg msg;
 
-	cfg = get_irq_data(irq);
+	cfg = get_irq_desc_data(desc);
 
 	msg = cfg->msg;
 	msg.address_lo &= ~1;
-	write_ht_irq_msg(irq, &msg);
+	write_ht_irq_desc_msg(desc, &msg);
+}
+void unmask_ht_irq(unsigned int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	unmask_ht_irq_desc(desc);
 }
 
 /**
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index f9cf317..01f7197 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -169,9 +169,10 @@ static void msix_mask_irq(struct msi_desc *desc, u32 flag)
 	desc->masked = __msix_mask_irq(desc, flag);
 }
 
-static void msi_set_mask_bit(unsigned irq, u32 flag)
+static void msi_set_mask_bit(struct irq_desc *descx, u32 flag)
 {
-	struct msi_desc *desc = get_irq_msi(irq);
+	unsigned int irq = descx->irq;
+	struct msi_desc *desc = get_irq_desc_msi(descx);
 
 	if (desc->msi_attrib.is_msix) {
 		msix_mask_irq(desc, flag);
@@ -182,14 +183,22 @@ static void msi_set_mask_bit(unsigned irq, u32 flag)
 	}
 }
 
+void mask_msi_irq_desc(struct irq_desc *desc)
+{
+	msi_set_mask_bit(desc, 1);
+}
 void mask_msi_irq(unsigned int irq)
 {
-	msi_set_mask_bit(irq, 1);
+	mask_msi_irq_desc(irq_to_desc(irq));
 }
 
+void unmask_msi_irq_desc(struct irq_desc *desc)
+{
+	msi_set_mask_bit(desc, 0);
+}
 void unmask_msi_irq(unsigned int irq)
 {
-	msi_set_mask_bit(irq, 0);
+	unmask_msi_irq_desc(irq_to_desc(irq));
 }
 
 void read_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg)
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index 659a765..678f64f 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -191,6 +191,10 @@ extern void dmar_msi_unmask(unsigned int irq);
 extern void dmar_msi_mask(unsigned int irq);
 extern void dmar_msi_read(int irq, struct msi_msg *msg);
 extern void dmar_msi_write(int irq, struct msi_msg *msg);
+extern void dmar_msi_unmask_desc(struct irq_desc *);
+extern void dmar_msi_mask_desc(struct irq_desc *);
+extern void dmar_msi_read_desc(struct irq_desc *desc, struct msi_msg *msg);
+extern void dmar_msi_write_desc(struct irq_desc *desc, struct msi_msg *msg);
 extern int dmar_set_interrupt(struct intel_iommu *iommu);
 extern irqreturn_t dmar_fault(int irq, void *dev_id);
 extern int arch_setup_dmar_msi(unsigned int irq);
diff --git a/include/linux/htirq.h b/include/linux/htirq.h
index c96ea46..2ef67cf 100644
--- a/include/linux/htirq.h
+++ b/include/linux/htirq.h
@@ -7,16 +7,21 @@ struct ht_irq_msg {
 };
 
 /* Helper functions.. */
+struct irq_desc;
 void fetch_ht_irq_msg(unsigned int irq, struct ht_irq_msg *msg);
 void write_ht_irq_msg(unsigned int irq, struct ht_irq_msg *msg);
 void mask_ht_irq(unsigned int irq);
 void unmask_ht_irq(unsigned int irq);
+void fetch_ht_irq_desc_msg(struct irq_desc *desc, struct ht_irq_msg *msg);
+void write_ht_irq_desc_msg(struct irq_desc *desc, struct ht_irq_msg *msg);
+void mask_ht_irq_desc(struct irq_desc *);
+void unmask_ht_irq_desc(struct irq_desc *);
 
 /* The arch hook for getting things started */
 int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev);
 
 /* For drivers of buggy hardware */
-typedef void (ht_irq_update_t)(struct pci_dev *dev, int irq,
+typedef void (ht_irq_update_t)(struct pci_dev *dev, struct irq_desc *desc,
 			       struct ht_irq_msg *msg);
 int __ht_create_irq(struct pci_dev *dev, int idx, ht_irq_update_t *update);
 
-- 
1.6.4.2

