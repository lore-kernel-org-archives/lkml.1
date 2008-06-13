Return-Path: <linux-kernel-owner+w=401wt.eu-S1761506AbYFMHD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761506AbYFMHD1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 03:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759730AbYFMHDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 03:03:11 -0400
Received: from havoc.gtf.org ([69.61.125.42]:46916 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757627AbYFMHDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 03:03:08 -0400
Date: Fri, 13 Jun 2008 03:03:07 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20080613070307.GA13997@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


More code than I'd like for -rc6, but it's adding a hardware workaround
for a specific chip (ATI SB600/SB700).


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ahci.c |  137 ++++++++++++++++++++++++++++++++++++++++++----------
 1 files changed, 112 insertions(+), 25 deletions(-)

Shane Huang (1):
      ahci: Workaround HW bug for SB600/700 SATA controller PMP support

Tejun Heo (1):
      ahci: workarounds for mcp65

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 544b7d6..966ab40 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -89,6 +89,7 @@ enum {
 	board_ahci_sb600	= 3,
 	board_ahci_mv		= 4,
 	board_ahci_sb700	= 5,
+	board_ahci_mcp65	= 6,
 
 	/* global controller registers */
 	HOST_CAP		= 0x00, /* host capabilities */
@@ -190,6 +191,7 @@ enum {
 	AHCI_HFLAG_NO_PMP		= (1 << 6), /* no PMP */
 	AHCI_HFLAG_NO_HOTPLUG		= (1 << 7), /* ignore PxSERR.DIAG.N */
 	AHCI_HFLAG_SECT255		= (1 << 8), /* max 255 sectors */
+	AHCI_HFLAG_YES_NCQ		= (1 << 9), /* force NCQ cap on */
 
 	/* ap->flags bits */
 
@@ -253,6 +255,8 @@ static void ahci_pmp_attach(struct ata_port *ap);
 static void ahci_pmp_detach(struct ata_port *ap);
 static int ahci_softreset(struct ata_link *link, unsigned int *class,
 			  unsigned long deadline);
+static int ahci_sb600_softreset(struct ata_link *link, unsigned int *class,
+			  unsigned long deadline);
 static int ahci_hardreset(struct ata_link *link, unsigned int *class,
 			  unsigned long deadline);
 static int ahci_vt8251_hardreset(struct ata_link *link, unsigned int *class,
@@ -329,6 +333,12 @@ static struct ata_port_operations ahci_p5wdh_ops = {
 	.hardreset		= ahci_p5wdh_hardreset,
 };
 
+static struct ata_port_operations ahci_sb600_ops = {
+	.inherits		= &ahci_ops,
+	.softreset		= ahci_sb600_softreset,
+	.pmp_softreset		= ahci_sb600_softreset,
+};
+
 #define AHCI_HFLAGS(flags)	.private_data	= (void *)(flags)
 
 static const struct ata_port_info ahci_port_info[] = {
@@ -359,11 +369,11 @@ static const struct ata_port_info ahci_port_info[] = {
 	{
 		AHCI_HFLAGS	(AHCI_HFLAG_IGN_SERR_INTERNAL |
 				 AHCI_HFLAG_32BIT_ONLY | AHCI_HFLAG_NO_MSI |
-				 AHCI_HFLAG_SECT255 | AHCI_HFLAG_NO_PMP),
+				 AHCI_HFLAG_SECT255),
 		.flags		= AHCI_FLAG_COMMON,
 		.pio_mask	= 0x1f, /* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &ahci_ops,
+		.port_ops	= &ahci_sb600_ops,
 	},
 	/* board_ahci_mv */
 	{
@@ -377,8 +387,15 @@ static const struct ata_port_info ahci_port_info[] = {
 	},
 	/* board_ahci_sb700 */
 	{
-		AHCI_HFLAGS	(AHCI_HFLAG_IGN_SERR_INTERNAL |
-				 AHCI_HFLAG_NO_PMP),
+		AHCI_HFLAGS	(AHCI_HFLAG_IGN_SERR_INTERNAL),
+		.flags		= AHCI_FLAG_COMMON,
+		.pio_mask	= 0x1f, /* pio0-4 */
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &ahci_sb600_ops,
+	},
+	/* board_ahci_mcp65 */
+	{
+		AHCI_HFLAGS	(AHCI_HFLAG_YES_NCQ),
 		.flags		= AHCI_FLAG_COMMON,
 		.pio_mask	= 0x1f, /* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
@@ -438,14 +455,14 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(VIA, 0x6287), board_ahci_vt8251 }, /* VIA VT8251 */
 
 	/* NVIDIA */
-	{ PCI_VDEVICE(NVIDIA, 0x044c), board_ahci },		/* MCP65 */
-	{ PCI_VDEVICE(NVIDIA, 0x044d), board_ahci },		/* MCP65 */
-	{ PCI_VDEVICE(NVIDIA, 0x044e), board_ahci },		/* MCP65 */
-	{ PCI_VDEVICE(NVIDIA, 0x044f), board_ahci },		/* MCP65 */
-	{ PCI_VDEVICE(NVIDIA, 0x045c), board_ahci },		/* MCP65 */
-	{ PCI_VDEVICE(NVIDIA, 0x045d), board_ahci },		/* MCP65 */
-	{ PCI_VDEVICE(NVIDIA, 0x045e), board_ahci },		/* MCP65 */
-	{ PCI_VDEVICE(NVIDIA, 0x045f), board_ahci },		/* MCP65 */
+	{ PCI_VDEVICE(NVIDIA, 0x044c), board_ahci_mcp65 },	/* MCP65 */
+	{ PCI_VDEVICE(NVIDIA, 0x044d), board_ahci_mcp65 },	/* MCP65 */
+	{ PCI_VDEVICE(NVIDIA, 0x044e), board_ahci_mcp65 },	/* MCP65 */
+	{ PCI_VDEVICE(NVIDIA, 0x044f), board_ahci_mcp65 },	/* MCP65 */
+	{ PCI_VDEVICE(NVIDIA, 0x045c), board_ahci_mcp65 },	/* MCP65 */
+	{ PCI_VDEVICE(NVIDIA, 0x045d), board_ahci_mcp65 },	/* MCP65 */
+	{ PCI_VDEVICE(NVIDIA, 0x045e), board_ahci_mcp65 },	/* MCP65 */
+	{ PCI_VDEVICE(NVIDIA, 0x045f), board_ahci_mcp65 },	/* MCP65 */
 	{ PCI_VDEVICE(NVIDIA, 0x0550), board_ahci },		/* MCP67 */
 	{ PCI_VDEVICE(NVIDIA, 0x0551), board_ahci },		/* MCP67 */
 	{ PCI_VDEVICE(NVIDIA, 0x0552), board_ahci },		/* MCP67 */
@@ -624,6 +641,12 @@ static void ahci_save_initial_config(struct pci_dev *pdev,
 		cap &= ~HOST_CAP_NCQ;
 	}
 
+	if (!(cap & HOST_CAP_NCQ) && (hpriv->flags & AHCI_HFLAG_YES_NCQ)) {
+		dev_printk(KERN_INFO, &pdev->dev,
+			   "controller can do NCQ, turning on CAP_NCQ\n");
+		cap |= HOST_CAP_NCQ;
+	}
+
 	if ((cap & HOST_CAP_PMP) && (hpriv->flags & AHCI_HFLAG_NO_PMP)) {
 		dev_printk(KERN_INFO, &pdev->dev,
 			   "controller can't do PMP, turning off CAP_PMP\n");
@@ -1262,19 +1285,11 @@ static int ahci_exec_polled_cmd(struct ata_port *ap, int pmp,
 	return 0;
 }
 
-static int ahci_check_ready(struct ata_link *link)
-{
-	void __iomem *port_mmio = ahci_port_base(link->ap);
-	u8 status = readl(port_mmio + PORT_TFDATA) & 0xFF;
-
-	return ata_check_ready(status);
-}
-
-static int ahci_softreset(struct ata_link *link, unsigned int *class,
-			  unsigned long deadline)
+static int ahci_do_softreset(struct ata_link *link, unsigned int *class,
+			     int pmp, unsigned long deadline,
+			     int (*check_ready)(struct ata_link *link))
 {
 	struct ata_port *ap = link->ap;
-	int pmp = sata_srst_pmp(link);
 	const char *reason = NULL;
 	unsigned long now, msecs;
 	struct ata_taskfile tf;
@@ -1312,7 +1327,7 @@ static int ahci_softreset(struct ata_link *link, unsigned int *class,
 	ahci_exec_polled_cmd(ap, pmp, &tf, 0, 0, 0);
 
 	/* wait for link to become ready */
-	rc = ata_wait_after_reset(link, deadline, ahci_check_ready);
+	rc = ata_wait_after_reset(link, deadline, check_ready);
 	/* link occupied, -ENODEV too is an error */
 	if (rc) {
 		reason = "device not ready";
@@ -1328,6 +1343,72 @@ static int ahci_softreset(struct ata_link *link, unsigned int *class,
 	return rc;
 }
 
+static int ahci_check_ready(struct ata_link *link)
+{
+	void __iomem *port_mmio = ahci_port_base(link->ap);
+	u8 status = readl(port_mmio + PORT_TFDATA) & 0xFF;
+
+	return ata_check_ready(status);
+}
+
+static int ahci_softreset(struct ata_link *link, unsigned int *class,
+			  unsigned long deadline)
+{
+	int pmp = sata_srst_pmp(link);
+
+	DPRINTK("ENTER\n");
+
+	return ahci_do_softreset(link, class, pmp, deadline, ahci_check_ready);
+}
+
+static int ahci_sb600_check_ready(struct ata_link *link)
+{
+	void __iomem *port_mmio = ahci_port_base(link->ap);
+	u8 status = readl(port_mmio + PORT_TFDATA) & 0xFF;
+	u32 irq_status = readl(port_mmio + PORT_IRQ_STAT);
+
+	/*
+	 * There is no need to check TFDATA if BAD PMP is found due to HW bug,
+	 * which can save timeout delay.
+	 */
+	if (irq_status & PORT_IRQ_BAD_PMP)
+		return -EIO;
+
+	return ata_check_ready(status);
+}
+
+static int ahci_sb600_softreset(struct ata_link *link, unsigned int *class,
+				unsigned long deadline)
+{
+	struct ata_port *ap = link->ap;
+	void __iomem *port_mmio = ahci_port_base(ap);
+	int pmp = sata_srst_pmp(link);
+	int rc;
+	u32 irq_sts;
+
+	DPRINTK("ENTER\n");
+
+	rc = ahci_do_softreset(link, class, pmp, deadline,
+			       ahci_sb600_check_ready);
+
+	/*
+	 * Soft reset fails on some ATI chips with IPMS set when PMP
+	 * is enabled but SATA HDD/ODD is connected to SATA port,
+	 * do soft reset again to port 0.
+	 */
+	if (rc == -EIO) {
+		irq_sts = readl(port_mmio + PORT_IRQ_STAT);
+		if (irq_sts & PORT_IRQ_BAD_PMP) {
+			ata_link_printk(link, KERN_WARNING,
+					"failed due to HW bug, retry pmp=0\n");
+			rc = ahci_do_softreset(link, class, 0, deadline,
+					       ahci_check_ready);
+		}
+	}
+
+	return rc;
+}
+
 static int ahci_hardreset(struct ata_link *link, unsigned int *class,
 			  unsigned long deadline)
 {
@@ -2118,7 +2199,8 @@ static void ahci_p5wdh_workaround(struct ata_host *host)
 static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	static int printed_version;
-	struct ata_port_info pi = ahci_port_info[ent->driver_data];
+	unsigned int board_id = ent->driver_data;
+	struct ata_port_info pi = ahci_port_info[board_id];
 	const struct ata_port_info *ppi[] = { &pi, NULL };
 	struct device *dev = &pdev->dev;
 	struct ahci_host_priv *hpriv;
@@ -2167,6 +2249,11 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		return -ENOMEM;
 	hpriv->flags |= (unsigned long)pi.private_data;
 
+	/* MCP65 revision A1 and A2 can't do MSI */
+	if (board_id == board_ahci_mcp65 &&
+	    (pdev->revision == 0xa1 || pdev->revision == 0xa2))
+		hpriv->flags |= AHCI_HFLAG_NO_MSI;
+
 	if ((hpriv->flags & AHCI_HFLAG_NO_MSI) || pci_enable_msi(pdev))
 		pci_intx(pdev, 1);
 
