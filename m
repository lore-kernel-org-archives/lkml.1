Return-Path: <linux-kernel-owner+w=401wt.eu-S1761111AbYGKBD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761111AbYGKBD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 21:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759373AbYGKBCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 21:02:42 -0400
Received: from mail.tor.primus.ca ([216.254.136.21]:43098 "EHLO
	mail-08.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758013AbYGKBCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 21:02:36 -0400
From: Matthew Wilcox <matthew@wil.cx>
To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: grundler@parisc-linux.org, mingo@elte.hu, tglx@linutronix.de,
       jgarzik@pobox.com, linux-ide@vger.kernel.org, suresh.b.siddha@intel.com,
       benh@kernel.crashing.org, jbarnes@virtuousgeek.org,
       rdunlap@xenotime.net, mtk.manpages@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH] AHCI: Request multiple MSIs
Date: Thu, 10 Jul 2008 21:00:01 -0400
Message-Id: <1215738002-4961-4-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <20080711005719.GO14894@parisc-linux.org>
References: <20080711005719.GO14894@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AHCI controllers can support up to 16 interrupts, one per port.  This
saves us a readl() in the interrupt path to determine which port has
generated the interrupt.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/ata/ahci.c |  127 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 122 insertions(+), 5 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 5e6468a..12562fc 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -102,6 +102,7 @@ enum {
 	/* HOST_CTL bits */
 	HOST_RESET		= (1 << 0),  /* reset controller; self-clear */
 	HOST_IRQ_EN		= (1 << 1),  /* global IRQ enable */
+	HOST_MSI_RSM		= (1 << 2),  /* Revert to Single Message */
 	HOST_AHCI_EN		= (1 << 31), /* AHCI enabled */
 
 	/* HOST_CAP bits */
@@ -1771,6 +1772,15 @@ static void ahci_port_intr(struct ata_port *ap)
 	}
 }
 
+static irqreturn_t ahci_msi_interrupt(int irq, void *dev_instance)
+{
+	struct ata_port *ap = dev_instance;
+	spin_lock(&ap->host->lock);
+	ahci_port_intr(ap);
+	spin_unlock(&ap->host->lock);
+	return IRQ_HANDLED;
+}
+
 static irqreturn_t ahci_interrupt(int irq, void *dev_instance)
 {
 	struct ata_host *host = dev_instance;
@@ -2220,6 +2230,107 @@ static void ahci_p5wdh_workaround(struct ata_host *host)
 	}
 }
 
+static int ahci_request_irqs(struct pci_dev *pdev, struct ata_host *host,
+								int n_irqs)
+{
+	int i, rc;
+
+	if (n_irqs > host->n_ports) {
+		n_irqs = host->n_ports;
+	} else if (n_irqs < host->n_ports || n_irqs == 1) {
+		n_irqs--;
+		rc = devm_request_irq(host->dev, pdev->irq + n_irqs,
+				ahci_interrupt,
+				IRQF_SHARED | (n_irqs ? IRQF_DISABLED : 0),
+				dev_driver_string(host->dev), host);
+		if (rc)
+			return rc;
+	}
+
+	for (i = 0; i < n_irqs; i++) {
+		rc = devm_request_irq(host->dev, pdev->irq + i,
+				ahci_msi_interrupt, IRQF_DISABLED,
+				dev_driver_string(host->dev), host->ports[i]);
+		if (rc)
+			goto free_irqs;
+	}
+
+	return 0;
+
+ free_irqs:
+ 	if (n_irqs < host->n_ports)
+		devm_free_irq(host->dev, pdev->irq + n_irqs, host);
+	while (i >= 0)
+		devm_free_irq(host->dev, pdev->irq + i, host->ports[i]);
+	return rc;
+}
+
+static int ahci_setup_irq_block(struct pci_dev *pdev, struct ata_host *host,
+							int n_irqs)
+{
+	int rc;
+
+	rc = pci_enable_msi_block(pdev, n_irqs);
+	if (rc)
+		return rc;
+	if (n_irqs > 1) {
+		void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
+		u32 host_ctl = readl(mmio + HOST_CTL);
+		if (host_ctl & HOST_MSI_RSM)
+			goto try_different;
+	}
+
+	rc = ahci_request_irqs(pdev, host, n_irqs);
+	if (!rc)
+		return 0;
+
+ try_different:
+	pci_disable_msi(pdev);
+	pci_intx(pdev, 1);
+	return (n_irqs == 1) ? rc : 1;
+}
+
+static int ahci_setup_irqs(struct pci_dev *pdev, struct ata_host *host)
+{
+	struct ahci_host_priv *hpriv = host->private_data;
+	int n_irqs, pos, rc;
+	u16 control;
+
+	if (hpriv->flags & AHCI_HFLAG_NO_MSI)
+		goto no_msi;
+
+	/*
+	 * We only need one interrupt per port (plus one for CCC which
+	 * isn't supported yet), but some AHCI controllers refuse to use
+	 * multiple MSIs unless they get the maximum number of interrupts
+	 */
+
+	rc = ahci_setup_irq_block(pdev, host, host->n_ports);
+	if (rc == 0)
+		return 0;
+	if (rc < 0)
+		goto no_msi;
+
+	/* Find out how many it might want */
+	pos = pci_find_capability(pdev, PCI_CAP_ID_MSI);
+	pci_read_config_word(pdev, pos + PCI_MSI_FLAGS, &control);
+	n_irqs = 1 << ((control & PCI_MSI_FLAGS_QMASK) >> 1);
+
+	for (;;) {
+		rc = ahci_setup_irq_block(pdev, host, n_irqs);
+		if (rc == 0)
+			return 0;
+		if (rc < 0)
+			goto no_msi;
+		n_irqs = rc;
+	}
+
+	return 0;
+
+ no_msi:
+	return ahci_request_irqs(pdev, host, 1);
+}
+
 static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	static int printed_version;
@@ -2278,9 +2389,6 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	    (pdev->revision == 0xa1 || pdev->revision == 0xa2))
 		hpriv->flags |= AHCI_HFLAG_NO_MSI;
 
-	if ((hpriv->flags & AHCI_HFLAG_NO_MSI) || pci_enable_msi(pdev))
-		pci_intx(pdev, 1);
-
 	/* save initial config */
 	ahci_save_initial_config(pdev, hpriv);
 
@@ -2335,8 +2443,17 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	ahci_print_info(host);
 
 	pci_set_master(pdev);
-	return ata_host_activate(host, pdev->irq, ahci_interrupt, IRQF_SHARED,
-				 &ahci_sht);
+
+	rc = ata_host_start(host);
+	if (rc)
+		return rc;
+
+	rc = ahci_setup_irqs(pdev, host);
+	if (rc)
+		return rc;
+
+	rc = ata_host_register(host, &ahci_sht);
+	return rc;
 }
 
 static int __init ahci_init(void)
-- 
1.5.5.4

