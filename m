Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab0CBScF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 13:32:05 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:38721 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752249Ab0CBS3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 13:29:31 -0500
Date: Tue, 2 Mar 2010 21:29:29 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Jeff Garzik <jgarzik@redhat.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 03/12] ahci: Factor out PCI specifics from
 ahci_save_initial_config()
Message-ID: <20100302182929.GC3445@oksana.dev.rtsoft.ru>
References: <20100302182850.GA32057@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100302182850.GA32057@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make ahci_save_initial_config() a bit more generic by introducing
force_port_map and mask_port_map arguments.

Move PCI stuff into ahci_pci_save_initial_config().

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/ata/ahci.c |   66 +++++++++++++++++++++++++++++++++-------------------
 1 files changed, 42 insertions(+), 24 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 4f00aea..aba800d 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -801,6 +801,8 @@ static ssize_t ahci_show_port_cmd(struct device *dev,
  *	ahci_save_initial_config - Save and fixup initial config values
  *	@pdev: target PCI device
  *	@hpriv: host private area to store config values
+ *	@force_port_map: force port map to a specified value
+ *	@mask_port_map: mask out particular bits from port map
  *
  *	Some registers containing configuration info might be setup by
  *	BIOS and might be cleared on reset.  This function saves the
@@ -813,12 +815,13 @@ static ssize_t ahci_show_port_cmd(struct device *dev,
  *	None.
  */
 static void ahci_save_initial_config(struct pci_dev *pdev,
-				     struct ahci_host_priv *hpriv)
+				     struct ahci_host_priv *hpriv,
+				     unsigned int force_port_map,
+				     unsigned int mask_port_map)
 {
 	void __iomem *mmio = hpriv->mmio;
 	u32 cap, cap2, vers, port_map;
 	int i;
-	int mv;
 
 	/* make sure AHCI mode is enabled before accessing CAP */
 	ahci_enable_ahci(mmio);
@@ -868,32 +871,19 @@ static void ahci_save_initial_config(struct pci_dev *pdev,
 		cap &= ~HOST_CAP_SNTF;
 	}
 
-	if (pdev->vendor == PCI_VENDOR_ID_JMICRON && pdev->device == 0x2361 &&
-	    port_map != 1) {
+	if (force_port_map && port_map != force_port_map) {
 		dev_printk(KERN_INFO, &pdev->dev,
-			   "JMB361 has only one port, port_map 0x%x -> 0x%x\n",
-			   port_map, 1);
-		port_map = 1;
+			   "forcing port_map 0x%x -> 0x%x\n",
+			   port_map, force_port_map);
+		port_map = force_port_map;
 	}
 
-	/*
-	 * Temporary Marvell 6145 hack: PATA port presence
-	 * is asserted through the standard AHCI port
-	 * presence register, as bit 4 (counting from 0)
-	 */
-	if (hpriv->flags & AHCI_HFLAG_MV_PATA) {
-		if (pdev->device == 0x6121)
-			mv = 0x3;
-		else
-			mv = 0xf;
+	if (mask_port_map) {
 		dev_printk(KERN_ERR, &pdev->dev,
-			   "MV_AHCI HACK: port_map %x -> %x\n",
+			   "masking port_map 0x%x -> 0x%x\n",
 			   port_map,
-			   port_map & mv);
-		dev_printk(KERN_ERR, &pdev->dev,
-			  "Disabling your PATA port. Use the boot option 'ahci.marvell_enable=0' to avoid this.\n");
-
-		port_map &= mv;
+			   port_map & mask_port_map);
+		port_map &= mask_port_map;
 	}
 
 	/* cross check port_map and cap.n_ports */
@@ -932,6 +922,34 @@ static void ahci_save_initial_config(struct pci_dev *pdev,
 	hpriv->port_map = port_map;
 }
 
+static void ahci_pci_save_initial_config(struct pci_dev *pdev,
+					 struct ahci_host_priv *hpriv)
+{
+	unsigned int force_port_map = 0;
+	unsigned int mask_port_map = 0;
+
+	if (pdev->vendor == PCI_VENDOR_ID_JMICRON && pdev->device == 0x2361) {
+		dev_info(&pdev->dev, "JMB361 has only one port\n");
+		force_port_map = 1;
+	}
+
+	/*
+	 * Temporary Marvell 6145 hack: PATA port presence
+	 * is asserted through the standard AHCI port
+	 * presence register, as bit 4 (counting from 0)
+	 */
+	if (hpriv->flags & AHCI_HFLAG_MV_PATA) {
+		if (pdev->device == 0x6121)
+			mask_port_map = 0x3;
+		else
+			mask_port_map = 0xf;
+		dev_info(&pdev->dev,
+			  "Disabling your PATA port. Use the boot option 'ahci.marvell_enable=0' to avoid this.\n");
+	}
+
+	ahci_save_initial_config(pdev, hpriv, force_port_map, mask_port_map);
+}
+
 /**
  *	ahci_restore_initial_config - Restore initial config
  *	@host: target ATA host
@@ -3086,7 +3104,7 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	hpriv->mmio = pcim_iomap_table(pdev)[AHCI_PCI_BAR];
 
 	/* save initial config */
-	ahci_save_initial_config(pdev, hpriv);
+	ahci_pci_save_initial_config(pdev, hpriv);
 
 	/* prepare host */
 	if (hpriv->cap & HOST_CAP_NCQ) {
-- 
1.7.0

