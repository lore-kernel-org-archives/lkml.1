Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab0CBS3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 13:29:31 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:38718 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754168Ab0CBS33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 13:29:29 -0500
Date: Tue, 2 Mar 2010 21:29:27 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Jeff Garzik <jgarzik@redhat.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 02/12] ahci: Get rid of host->iomap usage
Message-ID: <20100302182927.GB3445@oksana.dev.rtsoft.ru>
References: <20100302182850.GA32057@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100302182850.GA32057@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the driver uses host->iomap to store all the iomapped BARs
of a PCI device (while AHCI devices actually use just a single memory
window).

We're going to teach AHCI to work with non-PCI buses, so there are two
options to make this work:

1. "fake" host->iomap array for non-PCI devices, and place the needed
   address at iomap[AHCI_PCI_BAR];
2. Get rid of host->iomap usage, instead introduce a private mmio
   field.

This patch implements the second option.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/ata/ahci.c |   34 ++++++++++++++++++++--------------
 1 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index ef7949a..4f00aea 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -281,6 +281,7 @@ struct ahci_em_priv {
 };
 
 struct ahci_host_priv {
+	void __iomem *		mmio;		/* bus-independant mem map */
 	unsigned int		flags;		/* AHCI_HFLAG_* */
 	u32			cap;		/* cap to use */
 	u32			cap2;		/* cap2 to use */
@@ -719,7 +720,8 @@ static inline int ahci_nr_ports(u32 cap)
 static inline void __iomem *__ahci_port_base(struct ata_host *host,
 					     unsigned int port_no)
 {
-	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
+	struct ahci_host_priv *hpriv = host->private_data;
+	void __iomem *mmio = hpriv->mmio;
 
 	return mmio + 0x100 + (port_no * 0x80);
 }
@@ -779,7 +781,8 @@ static ssize_t ahci_show_host_version(struct device *dev,
 {
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct ata_port *ap = ata_shost_to_port(shost);
-	void __iomem *mmio = ap->host->iomap[AHCI_PCI_BAR];
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+	void __iomem *mmio = hpriv->mmio;
 
 	return sprintf(buf, "%x\n", readl(mmio + HOST_VERSION));
 }
@@ -812,7 +815,7 @@ static ssize_t ahci_show_port_cmd(struct device *dev,
 static void ahci_save_initial_config(struct pci_dev *pdev,
 				     struct ahci_host_priv *hpriv)
 {
-	void __iomem *mmio = pcim_iomap_table(pdev)[AHCI_PCI_BAR];
+	void __iomem *mmio = hpriv->mmio;
 	u32 cap, cap2, vers, port_map;
 	int i;
 	int mv;
@@ -941,7 +944,7 @@ static void ahci_save_initial_config(struct pci_dev *pdev,
 static void ahci_restore_initial_config(struct ata_host *host)
 {
 	struct ahci_host_priv *hpriv = host->private_data;
-	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
+	void __iomem *mmio = hpriv->mmio;
 
 	writel(hpriv->saved_cap, mmio + HOST_CAP);
 	if (hpriv->saved_cap2)
@@ -1300,7 +1303,7 @@ static int ahci_reset_controller(struct ata_host *host)
 {
 	struct pci_dev *pdev = to_pci_dev(host->dev);
 	struct ahci_host_priv *hpriv = host->private_data;
-	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
+	void __iomem *mmio = hpriv->mmio;
 	u32 tmp;
 
 	/* we must be in AHCI mode, before using anything
@@ -1431,7 +1434,8 @@ static void ahci_init_sw_activity(struct ata_link *link)
 
 static int ahci_reset_em(struct ata_host *host)
 {
-	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
+	struct ahci_host_priv *hpriv = host->private_data;
+	void __iomem *mmio = hpriv->mmio;
 	u32 em_ctl;
 
 	em_ctl = readl(mmio + HOST_EM_CTL);
@@ -1447,7 +1451,7 @@ static ssize_t ahci_transmit_led_message(struct ata_port *ap, u32 state,
 {
 	struct ahci_host_priv *hpriv = ap->host->private_data;
 	struct ahci_port_priv *pp = ap->private_data;
-	void __iomem *mmio = ap->host->iomap[AHCI_PCI_BAR];
+	void __iomem *mmio = hpriv->mmio;
 	u32 em_ctl;
 	u32 message[] = {0, 0};
 	unsigned long flags;
@@ -1615,7 +1619,7 @@ static void ahci_init_controller(struct ata_host *host)
 {
 	struct ahci_host_priv *hpriv = host->private_data;
 	struct pci_dev *pdev = to_pci_dev(host->dev);
-	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
+	void __iomem *mmio = hpriv->mmio;
 	int i;
 	void __iomem *port_mmio;
 	u32 tmp;
@@ -2258,7 +2262,7 @@ static irqreturn_t ahci_interrupt(int irq, void *dev_instance)
 	VPRINTK("ENTER\n");
 
 	hpriv = host->private_data;
-	mmio = host->iomap[AHCI_PCI_BAR];
+	mmio = hpriv->mmio;
 
 	/* sigh.  0xffffffff is a valid return from h/w */
 	irq_stat = readl(mmio + HOST_IRQ_STAT);
@@ -2347,7 +2351,8 @@ static void ahci_freeze(struct ata_port *ap)
 
 static void ahci_thaw(struct ata_port *ap)
 {
-	void __iomem *mmio = ap->host->iomap[AHCI_PCI_BAR];
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+	void __iomem *mmio = hpriv->mmio;
 	void __iomem *port_mmio = ahci_port_base(ap);
 	u32 tmp;
 	struct ahci_port_priv *pp = ap->private_data;
@@ -2443,7 +2448,7 @@ static int ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg)
 {
 	struct ata_host *host = dev_get_drvdata(&pdev->dev);
 	struct ahci_host_priv *hpriv = host->private_data;
-	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
+	void __iomem *mmio = hpriv->mmio;
 	u32 ctl;
 
 	if (mesg.event & PM_EVENT_SUSPEND &&
@@ -2592,7 +2597,7 @@ static void ahci_print_info(struct ata_host *host)
 {
 	struct ahci_host_priv *hpriv = host->private_data;
 	struct pci_dev *pdev = to_pci_dev(host->dev);
-	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
+	void __iomem *mmio = hpriv->mmio;
 	u32 vers, cap, cap2, impl, speed;
 	const char *speed_s;
 	u16 cc;
@@ -3078,6 +3083,8 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if ((hpriv->flags & AHCI_HFLAG_NO_MSI) || pci_enable_msi(pdev))
 		pci_intx(pdev, 1);
 
+	hpriv->mmio = pcim_iomap_table(pdev)[AHCI_PCI_BAR];
+
 	/* save initial config */
 	ahci_save_initial_config(pdev, hpriv);
 
@@ -3098,7 +3105,7 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	if (ahci_em_messages && (hpriv->cap & HOST_CAP_EMS)) {
 		u8 messages;
-		void __iomem *mmio = pcim_iomap_table(pdev)[AHCI_PCI_BAR];
+		void __iomem *mmio = hpriv->mmio;
 		u32 em_loc = readl(mmio + HOST_EM_LOC);
 		u32 em_ctl = readl(mmio + HOST_EM_CTL);
 
@@ -3142,7 +3149,6 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	host = ata_host_alloc_pinfo(&pdev->dev, ppi, n_ports);
 	if (!host)
 		return -ENOMEM;
-	host->iomap = pcim_iomap_table(pdev);
 	host->private_data = hpriv;
 
 	if (!(hpriv->cap & HOST_CAP_SSS) || ahci_ignore_sss)
-- 
1.7.0

