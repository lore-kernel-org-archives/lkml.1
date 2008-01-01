Return-Path: <linux-kernel-owner+w=401wt.eu-S1754936AbYAANr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbYAANr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 08:47:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754699AbYAANr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 08:47:26 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:50047 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754678AbYAANrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 08:47:24 -0500
Date: Tue, 1 Jan 2008 15:47:10 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Roland Dreier <rolandd@cisco.com>
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] mthca: the scheduled MSI support removal
Message-ID: <20080101134710.GH2360@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the scheduled removal of the MSI support in the
mthca driver.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 Documentation/feature-removal-schedule.txt |   10 -----
 drivers/infiniband/hw/mthca/mthca_dev.h    |    1 
 drivers/infiniband/hw/mthca/mthca_eq.c     |    6 +--
 drivers/infiniband/hw/mthca/mthca_main.c   |   38 ++-------------------
 4 files changed, 7 insertions(+), 48 deletions(-)

c548d98cb3d4b9001be2e7246d1ab08eee58d5e1 
diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 93aac19..a9b00f9 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -287,16 +287,6 @@ Who:  linuxppc-dev@ozlabs.org
 
 ---------------------------
 
-What:	mthca driver's MSI support
-When:	January 2008
-Files:	drivers/infiniband/hw/mthca/*.[ch]
-Why:	All mthca hardware also supports MSI-X, which provides
-	strictly more functionality than MSI.  So there is no point in
-	having both MSI-X and MSI support in the driver.
-Who:	Roland Dreier <rolandd@cisco.com>
-
----------------------------
-
 What:   sk98lin network driver
 When:   Feburary 2008
 Why:    In kernel tree version of driver is unmaintained. Sk98lin driver
diff --git a/drivers/infiniband/hw/mthca/mthca_dev.h b/drivers/infiniband/hw/mthca/mthca_dev.h
index 15aa32e..53159c0 100644
--- a/drivers/infiniband/hw/mthca/mthca_dev.h
+++ b/drivers/infiniband/hw/mthca/mthca_dev.h
@@ -60,7 +60,6 @@
 enum {
 	MTHCA_FLAG_DDR_HIDDEN = 1 << 1,
 	MTHCA_FLAG_SRQ        = 1 << 2,
-	MTHCA_FLAG_MSI        = 1 << 3,
 	MTHCA_FLAG_MSI_X      = 1 << 4,
 	MTHCA_FLAG_NO_LAM     = 1 << 5,
 	MTHCA_FLAG_FMR        = 1 << 6,
diff --git a/drivers/infiniband/hw/mthca/mthca_eq.c b/drivers/infiniband/hw/mthca/mthca_eq.c
index b29de51..b60eb5d 100644
--- a/drivers/infiniband/hw/mthca/mthca_eq.c
+++ b/drivers/infiniband/hw/mthca/mthca_eq.c
@@ -827,8 +827,7 @@ int mthca_init_eq_table(struct mthca_dev *dev)
 	if (err)
 		goto err_out_free;
 
-	if (dev->mthca_flags & MTHCA_FLAG_MSI ||
-	    dev->mthca_flags & MTHCA_FLAG_MSI_X) {
+	if (dev->mthca_flags & MTHCA_FLAG_MSI_X) {
 		dev->eq_table.clr_mask = 0;
 	} else {
 		dev->eq_table.clr_mask =
@@ -839,8 +838,7 @@ int mthca_init_eq_table(struct mthca_dev *dev)
 
 	dev->eq_table.arm_mask = 0;
 
-	intr = (dev->mthca_flags & MTHCA_FLAG_MSI) ?
-		128 : dev->eq_table.inta_pin;
+	intr = dev->eq_table.inta_pin;
 
 	err = mthca_create_eq(dev, dev->limits.num_cqs + MTHCA_NUM_SPARE_EQE,
 			      (dev->mthca_flags & MTHCA_FLAG_MSI_X) ? 128 : intr,
diff --git a/drivers/infiniband/hw/mthca/mthca_main.c b/drivers/infiniband/hw/mthca/mthca_main.c
index 60de6f9..2fc36ca 100644
--- a/drivers/infiniband/hw/mthca/mthca_main.c
+++ b/drivers/infiniband/hw/mthca/mthca_main.c
@@ -65,14 +65,9 @@ static int msi_x = 1;
 module_param(msi_x, int, 0444);
 MODULE_PARM_DESC(msi_x, "attempt to use MSI-X if nonzero");
 
-static int msi = 0;
-module_param(msi, int, 0444);
-MODULE_PARM_DESC(msi, "attempt to use MSI if nonzero (deprecated, use MSI-X instead)");
-
 #else /* CONFIG_PCI_MSI */
 
 #define msi_x (0)
-#define msi   (0)
 
 #endif /* CONFIG_PCI_MSI */
 
@@ -816,13 +811,11 @@ static int mthca_setup_hca(struct mthca_dev *dev)
 
 	err = mthca_NOP(dev, &status);
 	if (err || status) {
-		if (dev->mthca_flags & (MTHCA_FLAG_MSI | MTHCA_FLAG_MSI_X)) {
+		if (dev->mthca_flags & MTHCA_FLAG_MSI_X) {
 			mthca_warn(dev, "NOP command failed to generate interrupt "
 				   "(IRQ %d).\n",
-				   dev->mthca_flags & MTHCA_FLAG_MSI_X ?
-				   dev->eq_table.eq[MTHCA_EQ_CMD].msi_x_vector :
-				   dev->pdev->irq);
-			mthca_warn(dev, "Trying again with MSI/MSI-X disabled.\n");
+				   dev->eq_table.eq[MTHCA_EQ_CMD].msi_x_vector);
+			mthca_warn(dev, "Trying again with MSI-X disabled.\n");
 		} else {
 			mthca_err(dev, "NOP command failed to generate interrupt "
 				  "(IRQ %d), aborting.\n",
@@ -1128,29 +1121,12 @@ static int __mthca_init_one(struct pci_dev *pdev, int hca_type)
 
 	if (msi_x && !mthca_enable_msi_x(mdev))
 		mdev->mthca_flags |= MTHCA_FLAG_MSI_X;
-	else if (msi) {
-		static int warned;
-
-		if (!warned) {
-			printk(KERN_WARNING PFX "WARNING: MSI support will be "
-			       "removed from the ib_mthca driver in January 2008.\n");
-			printk(KERN_WARNING "    If you are using MSI and cannot "
-			       "switch to MSI-X, please tell "
-			       "<general@lists.openfabrics.org>.\n");
-			++warned;
-		}
-
-		if (!pci_enable_msi(pdev))
-			mdev->mthca_flags |= MTHCA_FLAG_MSI;
-	}
 
 	err = mthca_setup_hca(mdev);
-	if (err == -EBUSY && (mdev->mthca_flags & (MTHCA_FLAG_MSI | MTHCA_FLAG_MSI_X))) {
+	if (err == -EBUSY && (mdev->mthca_flags & MTHCA_FLAG_MSI_X)) {
 		if (mdev->mthca_flags & MTHCA_FLAG_MSI_X)
 			pci_disable_msix(pdev);
-		if (mdev->mthca_flags & MTHCA_FLAG_MSI)
-			pci_disable_msi(pdev);
-		mdev->mthca_flags &= ~(MTHCA_FLAG_MSI_X | MTHCA_FLAG_MSI);
+		mdev->mthca_flags &= ~MTHCA_FLAG_MSI_X;
 
 		err = mthca_setup_hca(mdev);
 	}
@@ -1192,8 +1168,6 @@ err_cleanup:
 err_close:
 	if (mdev->mthca_flags & MTHCA_FLAG_MSI_X)
 		pci_disable_msix(pdev);
-	if (mdev->mthca_flags & MTHCA_FLAG_MSI)
-		pci_disable_msi(pdev);
 
 	mthca_close_hca(mdev);
 
@@ -1246,8 +1220,6 @@ static void __mthca_remove_one(struct pci_dev *pdev)
 
 		if (mdev->mthca_flags & MTHCA_FLAG_MSI_X)
 			pci_disable_msix(pdev);
-		if (mdev->mthca_flags & MTHCA_FLAG_MSI)
-			pci_disable_msi(pdev);
 
 		ib_dealloc_device(&mdev->ib_dev);
 		mthca_release_regions(pdev, mdev->mthca_flags &

