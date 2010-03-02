Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab0CBS3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 13:29:36 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:38724 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754168Ab0CBS3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 13:29:33 -0500
Date: Tue, 2 Mar 2010 21:29:31 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Jeff Garzik <jgarzik@redhat.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 04/12] ahci: Get rid of pci_dev argument in
 ahci_save_initial_config()
Message-ID: <20100302182931.GD3445@oksana.dev.rtsoft.ru>
References: <20100302182850.GA32057@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100302182850.GA32057@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To make the function generic we have to get rid of "struct pci_dev *",
so let's pass just a "struct devce *".

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/ata/ahci.c |   27 +++++++++++++--------------
 1 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index aba800d..acfdcb5 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -799,7 +799,7 @@ static ssize_t ahci_show_port_cmd(struct device *dev,
 
 /**
  *	ahci_save_initial_config - Save and fixup initial config values
- *	@pdev: target PCI device
+ *	@dev: target AHCI device
  *	@hpriv: host private area to store config values
  *	@force_port_map: force port map to a specified value
  *	@mask_port_map: mask out particular bits from port map
@@ -814,7 +814,7 @@ static ssize_t ahci_show_port_cmd(struct device *dev,
  *	LOCKING:
  *	None.
  */
-static void ahci_save_initial_config(struct pci_dev *pdev,
+static void ahci_save_initial_config(struct device *dev,
 				     struct ahci_host_priv *hpriv,
 				     unsigned int force_port_map,
 				     unsigned int mask_port_map)
@@ -842,45 +842,43 @@ static void ahci_save_initial_config(struct pci_dev *pdev,
 
 	/* some chips have errata preventing 64bit use */
 	if ((cap & HOST_CAP_64) && (hpriv->flags & AHCI_HFLAG_32BIT_ONLY)) {
-		dev_printk(KERN_INFO, &pdev->dev,
+		dev_printk(KERN_INFO, dev,
 			   "controller can't do 64bit DMA, forcing 32bit\n");
 		cap &= ~HOST_CAP_64;
 	}
 
 	if ((cap & HOST_CAP_NCQ) && (hpriv->flags & AHCI_HFLAG_NO_NCQ)) {
-		dev_printk(KERN_INFO, &pdev->dev,
+		dev_printk(KERN_INFO, dev,
 			   "controller can't do NCQ, turning off CAP_NCQ\n");
 		cap &= ~HOST_CAP_NCQ;
 	}
 
 	if (!(cap & HOST_CAP_NCQ) && (hpriv->flags & AHCI_HFLAG_YES_NCQ)) {
-		dev_printk(KERN_INFO, &pdev->dev,
+		dev_printk(KERN_INFO, dev,
 			   "controller can do NCQ, turning on CAP_NCQ\n");
 		cap |= HOST_CAP_NCQ;
 	}
 
 	if ((cap & HOST_CAP_PMP) && (hpriv->flags & AHCI_HFLAG_NO_PMP)) {
-		dev_printk(KERN_INFO, &pdev->dev,
+		dev_printk(KERN_INFO, dev,
 			   "controller can't do PMP, turning off CAP_PMP\n");
 		cap &= ~HOST_CAP_PMP;
 	}
 
 	if ((cap & HOST_CAP_SNTF) && (hpriv->flags & AHCI_HFLAG_NO_SNTF)) {
-		dev_printk(KERN_INFO, &pdev->dev,
+		dev_printk(KERN_INFO, dev,
 			   "controller can't do SNTF, turning off CAP_SNTF\n");
 		cap &= ~HOST_CAP_SNTF;
 	}
 
 	if (force_port_map && port_map != force_port_map) {
-		dev_printk(KERN_INFO, &pdev->dev,
-			   "forcing port_map 0x%x -> 0x%x\n",
+		dev_printk(KERN_INFO, dev, "forcing port_map 0x%x -> 0x%x\n",
 			   port_map, force_port_map);
 		port_map = force_port_map;
 	}
 
 	if (mask_port_map) {
-		dev_printk(KERN_ERR, &pdev->dev,
-			   "masking port_map 0x%x -> 0x%x\n",
+		dev_printk(KERN_ERR, dev, "masking port_map 0x%x -> 0x%x\n",
 			   port_map,
 			   port_map & mask_port_map);
 		port_map &= mask_port_map;
@@ -898,7 +896,7 @@ static void ahci_save_initial_config(struct pci_dev *pdev,
 		 * port_map and let it be generated from n_ports.
 		 */
 		if (map_ports > ahci_nr_ports(cap)) {
-			dev_printk(KERN_WARNING, &pdev->dev,
+			dev_printk(KERN_WARNING, dev,
 				   "implemented port map (0x%x) contains more "
 				   "ports than nr_ports (%u), using nr_ports\n",
 				   port_map, ahci_nr_ports(cap));
@@ -909,7 +907,7 @@ static void ahci_save_initial_config(struct pci_dev *pdev,
 	/* fabricate port_map from cap.nr_ports */
 	if (!port_map) {
 		port_map = (1 << ahci_nr_ports(cap)) - 1;
-		dev_printk(KERN_WARNING, &pdev->dev,
+		dev_printk(KERN_WARNING, dev,
 			   "forcing PORTS_IMPL to 0x%x\n", port_map);
 
 		/* write the fixed up value to the PI register */
@@ -947,7 +945,8 @@ static void ahci_pci_save_initial_config(struct pci_dev *pdev,
 			  "Disabling your PATA port. Use the boot option 'ahci.marvell_enable=0' to avoid this.\n");
 	}
 
-	ahci_save_initial_config(pdev, hpriv, force_port_map, mask_port_map);
+	ahci_save_initial_config(&pdev->dev, hpriv, force_port_map,
+				 mask_port_map);
 }
 
 /**
-- 
1.7.0

