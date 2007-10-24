Return-Path: <linux-kernel-owner+w=401wt.eu-S1756762AbXJXCwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762AbXJXCwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 22:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754744AbXJXCwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 22:52:44 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48147
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754327AbXJXCwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 22:52:43 -0400
Date: Tue, 23 Oct 2007 19:53:10 -0700 (PDT)
Message-Id: <20071023.195310.131105752.davem@davemloft.net>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, barkalow@iabervon.org, linas@austin.ibm.com,
       chunhao.huang@hotmail.com, gregkh@suse.de, htejun@gmail.com,
       brice.goglin@gmail.com, david.gaarenstroom@gmail.com,
       linux-pci@atrey.karlin.mff.cuni.cz, shane.huang@amd.com,
       linux-ide@vger.kernel.org, brice@myri.com, mchan@broadcom.com
Subject: [PATCH 3/4]: [PCI]: Add quirk for devices which disable MSI when
 INTX_DISABLE is set.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


A reasonably common problem with some devices is that they will
disable MSI generation when the INTX_DISABLE bit is set in the
PCI_COMMAND register.

Quirk this explicitly, guarding the pci_intx() calls in msi.c with
this quirk indication.

The first entries for this quirk are for 5714 and 5780 Tigon3 chips,
and thus we can remove the workaround code from the tg3.c driver.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/tg3.c    |    9 ---------
 drivers/pci/msi.c    |   18 ++++++++++++------
 drivers/pci/quirks.c |   18 ++++++++++++++++++
 include/linux/pci.h  |    9 +++++++++
 4 files changed, 39 insertions(+), 15 deletions(-)

diff --git a/drivers/net/tg3.c b/drivers/net/tg3.c
index 09440d7..cad5199 100644
--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -7365,10 +7365,6 @@ static int tg3_open(struct net_device *dev)
 		} else if (pci_enable_msi(tp->pdev) == 0) {
 			u32 msi_mode;
 
-			/* Hardware bug - MSI won't work if INTX disabled. */
-			if (tp->tg3_flags2 & TG3_FLG2_5780_CLASS)
-				pci_intx(tp->pdev, 1);
-
 			msi_mode = tr32(MSGINT_MODE);
 			tw32(MSGINT_MODE, msi_mode | MSGINT_MODE_ENABLE);
 			tp->tg3_flags2 |= TG3_FLG2_USING_MSI;
@@ -12681,11 +12677,6 @@ static int tg3_resume(struct pci_dev *pdev)
 	if (err)
 		return err;
 
-	/* Hardware bug - MSI won't work if INTX disabled. */
-	if ((tp->tg3_flags2 & TG3_FLG2_5780_CLASS) &&
-	    (tp->tg3_flags2 & TG3_FLG2_USING_MSI))
-		pci_intx(tp->pdev, 1);
-
 	netif_device_attach(dev);
 
 	tg3_full_lock(tp, 0);
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 87e0161..a8dd18c 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -237,7 +237,8 @@ static void __pci_restore_msi_state(struct pci_dev *dev)
 	entry = get_irq_msi(dev->irq);
 	pos = entry->msi_attrib.pos;
 
-	pci_intx(dev, 0);		/* disable intx */
+	if (!(dev->dev_flags & PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG))
+		pci_intx(dev, 0); /* disable intx */
 	msi_set_enable(dev, 0);
 	write_msi_msg(dev->irq, &entry->msg);
 	if (entry->msi_attrib.maskbit)
@@ -260,7 +261,8 @@ static void __pci_restore_msix_state(struct pci_dev *dev)
 		return;
 
 	/* route the table */
-	pci_intx(dev, 0);		/* disable intx */
+	if (!(dev->dev_flags & PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG))
+		pci_intx(dev, 0); /* disable intx */
 	msix_set_enable(dev, 0);
 
 	list_for_each_entry(entry, &dev->msi_list, list) {
@@ -343,7 +345,8 @@ static int msi_capability_init(struct pci_dev *dev)
 	}
 
 	/* Set MSI enabled bits	 */
-	pci_intx(dev, 0);		/* disable intx */
+	if (!(dev->dev_flags & PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG))
+		pci_intx(dev, 0); /* disable intx */
 	msi_set_enable(dev, 1);
 	dev->msi_enabled = 1;
 
@@ -433,7 +436,8 @@ static int msix_capability_init(struct pci_dev *dev,
 		i++;
 	}
 	/* Set MSI-X enabled bits */
-	pci_intx(dev, 0);		/* disable intx */
+	if (!(dev->dev_flags & PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG))
+		pci_intx(dev, 0); /* disable intx */
 	msix_set_enable(dev, 1);
 	dev->msix_enabled = 1;
 
@@ -528,7 +532,8 @@ void pci_disable_msi(struct pci_dev* dev)
 		return;
 
 	msi_set_enable(dev, 0);
-	pci_intx(dev, 1);		/* enable intx */
+	if (!(dev->dev_flags & PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG))
+		pci_intx(dev, 1); /* enable intx */
 	dev->msi_enabled = 0;
 
 	BUG_ON(list_empty(&dev->msi_list));
@@ -640,7 +645,8 @@ void pci_disable_msix(struct pci_dev* dev)
 		return;
 
 	msix_set_enable(dev, 0);
-	pci_intx(dev, 1);		/* enable intx */
+	if (!(dev->dev_flags & PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG))
+		pci_intx(dev, 1); /* enable intx */
 	dev->msix_enabled = 0;
 
 	msix_free_all_irqs(dev);
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index e588988..591eaa4 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1707,4 +1707,22 @@ static void __devinit quirk_nvidia_ck804_msi_ht_cap(struct pci_dev *dev)
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_CK804_PCIE,
 			quirk_nvidia_ck804_msi_ht_cap);
+
+static void __devinit quirk_msi_intx_disable_bug(struct pci_dev *dev)
+{
+	dev->dev_flags |= PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG;
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
+			PCI_DEVICE_ID_TIGON3_5780,
+			quirk_msi_intx_disable_bug);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
+			PCI_DEVICE_ID_TIGON3_5780S,
+			quirk_msi_intx_disable_bug);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
+			PCI_DEVICE_ID_TIGON3_5714,
+			quirk_msi_intx_disable_bug);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
+			PCI_DEVICE_ID_TIGON3_5714S,
+			quirk_msi_intx_disable_bug);
+
 #endif /* CONFIG_PCI_MSI */
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 5d2281f..7c04f38 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -109,6 +109,14 @@ enum pcie_reset_state {
 	pcie_hot_reset = (__force pcie_reset_state_t) 3
 };
 
+typedef unsigned short __bitwise pci_dev_flags_t;
+enum pci_dev_flags {
+	/* INTX_DISABLE in PCI_COMMAND register disables MSI
+	 * generation too.
+	 */
+	PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG = (__force pci_dev_flags_t) 1,
+};
+
 typedef unsigned short __bitwise pci_bus_flags_t;
 enum pci_bus_flags {
 	PCI_BUS_FLAGS_NO_MSI   = (__force pci_bus_flags_t) 1,
@@ -185,6 +193,7 @@ struct pci_dev {
 	unsigned int	msix_enabled:1;
 	unsigned int	is_managed:1;
 	unsigned int	is_pcie:1;
+	pci_dev_flags_t dev_flags;
 	atomic_t	enable_cnt;	/* pci_enable_device has been called */
 
 	u32		saved_config_space[16]; /* config space saved at suspend time */
-- 
1.5.3.4

