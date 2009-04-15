Return-Path: <linux-kernel-owner+w=401wt.eu-S1758328AbZDOG37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758328AbZDOG37 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 02:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755621AbZDOG2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 02:28:55 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:49587 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461AbZDOG2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 02:28:52 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH resend 2/8] staging: agnx, probe cleanup
Date: Wed, 15 Apr 2009 08:28:41 +0200
Message-Id: <1239776927-16168-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <1239776927-16168-1-git-send-email-jirislaby@gmail.com>
References: <1239776927-16168-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- switch printks to dev_*
- remove useless comments
- remove useless prints (for info we can obtain from lspci or /sys)

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/staging/agnx/pci.c |   34 ++++++++++++----------------------
 1 files changed, 12 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/agnx/pci.c b/drivers/staging/agnx/pci.c
index 25c0ffd..bf55ee9 100644
--- a/drivers/staging/agnx/pci.c
+++ b/drivers/staging/agnx/pci.c
@@ -452,47 +452,39 @@ static int __devinit agnx_pci_probe(struct pci_dev *pdev,
 {
 	struct ieee80211_hw *dev;
 	struct agnx_priv *priv;
-	u32 mem_addr0, mem_len0;
-	u32 mem_addr1, mem_len1;
+	u32 mem_len0, mem_len1;
 	int err;
 	DECLARE_MAC_BUF(mac);
 
 	err = pci_enable_device(pdev);
 	if (err) {
-		printk(KERN_ERR PFX "Can't enable new PCI device\n");
+		dev_err(&pdev->dev, "can't enable PCI device\n");
 		return err;
 	}
 
-	/* get pci resource */
-	mem_addr0 = pci_resource_start(pdev, 0);
 	mem_len0 = pci_resource_len(pdev, 0);
-	mem_addr1 = pci_resource_start(pdev, 1);
 	mem_len1 = pci_resource_len(pdev, 1);
-	printk(KERN_DEBUG PFX "Memaddr0 is %x, length is %x\n", mem_addr0, mem_len0);
-	printk(KERN_DEBUG PFX "Memaddr1 is %x, length is %x\n", mem_addr1, mem_len1);
 
 	err = pci_request_regions(pdev, "agnx-pci");
 	if (err) {
-		printk(KERN_ERR PFX "Can't obtain PCI resource\n");
+		dev_err(&pdev->dev, "can't reserve PCI resources\n");
 		return err;
 	}
 
 	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) ||
 	    pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32))) {
-		printk(KERN_ERR PFX "No suitable DMA available\n");
+		dev_err(&pdev->dev, "no suitable DMA available\n");
 		goto err_free_reg;
 	}
 
 	pci_set_master(pdev);
-	printk(KERN_DEBUG PFX "pdev->irq is %d\n", pdev->irq);
 
 	dev = ieee80211_alloc_hw(sizeof(*priv), &agnx_ops);
 	if (!dev) {
-		printk(KERN_ERR PFX "ieee80211 alloc failed\n");
+		dev_err(&pdev->dev, "ieee80211 alloc failed\n");
 		err = -ENOMEM;
 		goto err_free_reg;
 	}
-	/* init priv  */
 	priv = dev->priv;
 	memset(priv, 0, sizeof(*priv));
 	priv->mode = NL80211_IFTYPE_MONITOR;
@@ -501,17 +493,15 @@ static int __devinit agnx_pci_probe(struct pci_dev *pdev,
 	spin_lock_init(&priv->lock);
 	priv->init_status = AGNX_UNINIT;
 
-	/* Map mem #1 and #2 */
 	priv->ctl = pci_iomap(pdev, 0, mem_len0);
-/*	printk(KERN_DEBUG PFX"MEM1 mapped address is 0x%p\n", priv->ctl); */
+/*	dev_dbg(&pdev->dev, "MEM1 mapped address is 0x%p\n", priv->ctl); */
 	if (!priv->ctl) {
-		printk(KERN_ERR PFX "Can't map device memory\n");
+		dev_err(&pdev->dev, "can't map device memory\n");
 		goto err_free_dev;
 	}
 	priv->data = pci_iomap(pdev, 1, mem_len1);
-	printk(KERN_DEBUG PFX "MEM2 mapped address is 0x%p\n", priv->data);
 	if (!priv->data) {
-		printk(KERN_ERR PFX "Can't map device memory\n");
+		dev_err(&pdev->dev, "can't map device memory\n");
 		goto err_iounmap2;
 	}
 
@@ -552,15 +542,15 @@ static int __devinit agnx_pci_probe(struct pci_dev *pdev,
 
 	err = ieee80211_register_hw(dev);
 	if (err) {
-		printk(KERN_ERR PFX "Can't register hardware\n");
+		dev_err(&pdev->dev, "can't register hardware\n");
 		goto err_iounmap;
 	}
 
 	agnx_hw_reset(priv);
 
-
-	printk(PFX "%s: hwaddr %s, Rev 0x%02x\n", wiphy_name(dev->wiphy),
-	       print_mac(mac, dev->wiphy->perm_addr), priv->revid);
+	dev_info(&pdev->dev, "%s: hwaddr %s, Rev 0x%02x\n",
+		wiphy_name(dev->wiphy),
+		print_mac(mac, dev->wiphy->perm_addr), priv->revid);
 	return 0;
 
  err_iounmap:
-- 
1.6.2

