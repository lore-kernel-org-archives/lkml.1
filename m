Return-Path: <linux-kernel-owner+w=401wt.eu-S1759247AbXIXWTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759247AbXIXWTo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 18:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750918AbXIXWTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 18:19:35 -0400
Received: from mga03.intel.com ([143.182.124.21]:48412 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbXIXWTe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 18:19:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,293,1186383600"; 
   d="scan'208";a="285754753"
Date: Mon, 24 Sep 2007 15:14:35 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk,
       akpm@linux-foundation.org,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: [patch 2/2] Enable Aggressive Link Power management for AHCI
 controllers.
Message-Id: <20070924151435.ffaaf3e3.kristen.c.accardi@intel.com>
In-Reply-To: <20070924215140.966161778@intel.com>
References: <20070924215140.966161778@intel.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch will set the correct bits to turn on Aggressive
Link Power Management (ALPM) for the ahci driver.  This
will cause the controller and disk to negotiate a lower
power state for the link when there is no activity (see
the AHCI 1.x spec for details).  This feature is mutually
exclusive with Hot Plug, so when ALPM is enabled, Hot Plug
is disabled.  ALPM will be enabled by default, but it is
settable via the scsi host syfs interface.  Possible 
settings for this feature are:

Setting		Effect
----------------------------------------------------------
min_power	ALPM is enabled, and link set to enter 
		lowest power state (SLUMBER) when idle
		Hot plug not allowed.

max_performance	ALPM is disabled, Hot Plug is allowed

medium_power	ALPM is enabled, and link set to enter
		second lowest power state (PARTIAL) when
		idle.  Hot plug not allowed.

Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>

---
 drivers/ata/ahci.c |  154 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 153 insertions(+), 1 deletion(-)

Index: libata-dev/drivers/ata/ahci.c
===================================================================
--- libata-dev.orig/drivers/ata/ahci.c	2007-09-24 13:43:10.000000000 -0700
+++ libata-dev/drivers/ata/ahci.c	2007-09-24 13:48:59.000000000 -0700
@@ -48,6 +48,9 @@
 #define DRV_NAME	"ahci"
 #define DRV_VERSION	"2.3"
 
+static int ahci_enable_alpm(struct ata_port *ap,
+		enum link_pm policy);
+static int ahci_disable_alpm(struct ata_port *ap);
 
 enum {
 	AHCI_PCI_BAR		= 5,
@@ -97,6 +100,7 @@ enum {
 	/* HOST_CAP bits */
 	HOST_CAP_SSC		= (1 << 14), /* Slumber capable */
 	HOST_CAP_CLO		= (1 << 24), /* Command List Override support */
+	HOST_CAP_ALPM		= (1 << 26), /* Aggressive Link PM support */
 	HOST_CAP_SSS		= (1 << 27), /* Staggered Spin-up */
 	HOST_CAP_SNTF		= (1 << 29), /* SNotification register */
 	HOST_CAP_NCQ		= (1 << 30), /* Native Command Queueing */
@@ -152,6 +156,8 @@ enum {
 				  PORT_IRQ_PIOS_FIS | PORT_IRQ_D2H_REG_FIS,
 
 	/* PORT_CMD bits */
+	PORT_CMD_ASP		= (1 << 27), /* Aggressive Slumber/Partial */
+	PORT_CMD_ALPE		= (1 << 26), /* Aggressive Link PM enable */
 	PORT_CMD_ATAPI		= (1 << 24), /* Device is ATAPI */
 	PORT_CMD_LIST_ON	= (1 << 15), /* cmd list DMA engine running */
 	PORT_CMD_FIS_ON		= (1 << 14), /* FIS DMA engine running */
@@ -177,7 +183,7 @@ enum {
 
 	AHCI_FLAG_COMMON		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
 					  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA |
-					  ATA_FLAG_ACPI_SATA,
+					  ATA_FLAG_ACPI_SATA | ATA_FLAG_IPM,
 	AHCI_LFLAG_COMMON		= ATA_LFLAG_SKIP_D2H_BSY,
 };
 
@@ -242,6 +248,11 @@ static int ahci_pci_device_suspend(struc
 static int ahci_pci_device_resume(struct pci_dev *pdev);
 #endif
 
+static struct class_device_attribute *ahci_shost_attrs[] = {
+	&class_device_attr_link_power_management_policy,
+	NULL
+};
+
 static struct scsi_host_template ahci_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
@@ -259,6 +270,7 @@ static struct scsi_host_template ahci_sh
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
+	.shost_attrs		= ahci_shost_attrs,
 };
 
 static const struct ata_port_operations ahci_ops = {
@@ -286,6 +298,8 @@ static const struct ata_port_operations 
 	.port_suspend		= ahci_port_suspend,
 	.port_resume		= ahci_port_resume,
 #endif
+	.enable_pm		= ahci_enable_alpm,
+	.disable_pm		= ahci_disable_alpm,
 
 	.port_start		= ahci_port_start,
 	.port_stop		= ahci_port_stop,
@@ -767,6 +781,130 @@ static void ahci_power_up(struct ata_por
 	writel(cmd | PORT_CMD_ICC_ACTIVE, port_mmio + PORT_CMD);
 }
 
+static int ahci_disable_alpm(struct ata_port *ap)
+{
+	void __iomem *port_mmio = ahci_port_base(ap);
+	u32 cmd;
+	struct ahci_port_priv *pp = ap->private_data;
+
+	/* IPM bits should be disabled by libata-core */
+	/* get the existing command bits */
+	cmd = readl(port_mmio + PORT_CMD);
+
+	/* disable ALPM and ASP */
+	cmd &= ~PORT_CMD_ASP;
+	cmd &= ~PORT_CMD_ALPE;
+
+	/* force the interface back to active */
+	cmd |= PORT_CMD_ICC_ACTIVE;
+
+	/* write out new cmd value */
+	writel(cmd, port_mmio + PORT_CMD);
+	cmd = readl(port_mmio + PORT_CMD);
+
+	/* wait 10ms to be sure we've come out of any low power state */
+	msleep(10);
+
+	/* clear out any PhyRdy stuff from interrupt status */
+	writel(PORT_IRQ_PHYRDY, port_mmio + PORT_IRQ_STAT);
+
+	/* go ahead and clean out PhyRdy Change from Serror too */
+	ahci_scr_write(ap, SCR_ERROR, ((1 << 16) | (1 << 18)));
+
+	/*
+ 	 * Clear flag to indicate that we should ignore all PhyRdy
+ 	 * state changes
+ 	 */
+	ap->flags &= ~AHCI_FLAG_NO_HOTPLUG;
+
+	/*
+ 	 * Enable interrupts on Phy Ready.
+ 	 */
+	pp->intr_mask |= PORT_IRQ_PHYRDY;
+	writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
+
+	/*
+ 	 * don't change the link pm policy - we can be called
+ 	 * just to turn of link pm temporarily
+ 	 */
+	return 0;
+}
+
+static int ahci_enable_alpm(struct ata_port *ap,
+	enum link_pm policy)
+{
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+	void __iomem *port_mmio = ahci_port_base(ap);
+	u32 cmd;
+	struct ahci_port_priv *pp = ap->private_data;
+	u32 asp;
+
+	/* Make sure the host is capable of link power management */
+	if (!(hpriv->cap & HOST_CAP_ALPM))
+		return -EINVAL;
+
+	switch (policy) {
+	case MAX_PERFORMANCE:
+	case NOT_AVAILABLE:
+		/*
+ 		 * if we came here with NOT_AVAILABLE,
+ 		 * it just means this is the first time we
+ 		 * have tried to enable - default to max performance,
+ 		 * and let the user go to lower power modes on request.
+ 		 */
+		ahci_disable_alpm(ap);
+		return 0;
+	case MIN_POWER:
+		/* configure HBA to enter SLUMBER */
+		asp = PORT_CMD_ASP;
+		break;
+	case MEDIUM_POWER:
+		/* configure HBA to enter PARTIAL */
+		asp = 0;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/*
+ 	 * Disable interrupts on Phy Ready. This keeps us from
+ 	 * getting woken up due to spurious phy ready interrupts
+	 * TBD - Hot plug should be done via polling now, is
+	 * that even supported?
+ 	 */
+	pp->intr_mask &= ~PORT_IRQ_PHYRDY;
+	writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
+
+	/*
+ 	 * Set a flag to indicate that we should ignore all PhyRdy
+ 	 * state changes since these can happen now whenever we
+ 	 * change link state
+ 	 */
+	ap->flags |= AHCI_FLAG_NO_HOTPLUG;
+
+	/* get the existing command bits */
+	cmd = readl(port_mmio + PORT_CMD);
+
+	/*
+ 	 * Set ASP based on Policy
+ 	 */
+	cmd |= asp;
+
+	/*
+ 	 * Setting this bit will instruct the HBA to aggressively
+ 	 * enter a lower power link state when it's appropriate and
+ 	 * based on the value set above for ASP
+ 	 */
+	cmd |= PORT_CMD_ALPE;
+
+	/* write out new cmd value */
+	writel(cmd, port_mmio + PORT_CMD);
+	cmd = readl(port_mmio + PORT_CMD);
+
+	/* IPM bits should be set by libata-core */
+	return 0;
+}
+
 #ifdef CONFIG_PM
 static void ahci_power_down(struct ata_port *ap)
 {
@@ -1348,6 +1486,17 @@ static void ahci_port_intr(struct ata_po
 	status = readl(port_mmio + PORT_IRQ_STAT);
 	writel(status, port_mmio + PORT_IRQ_STAT);
 
+	/* If we are getting PhyRdy, this is
+ 	 * just a power state change, we should
+ 	 * clear out this, plus the PhyRdy/Comm
+ 	 * Wake bits from Serror
+ 	 */
+	if ((ap->flags & AHCI_FLAG_NO_HOTPLUG) &&
+		(status & PORT_IRQ_PHYRDY)) {
+		status &= ~PORT_IRQ_PHYRDY;
+		ahci_scr_write(ap, SCR_ERROR, ((1 << 16) | (1 << 18)));
+	}
+
 	if (unlikely(status & PORT_IRQ_ERROR)) {
 		ahci_error_intr(ap, status);
 		return;
@@ -1882,6 +2031,9 @@ static int ahci_init_one(struct pci_dev 
 		ata_port_pbar_desc(ap, AHCI_PCI_BAR,
 				   0x100 + ap->port_no * 0x80, "port");
 
+		/* set initial link pm policy */
+		ap->pm_policy = NOT_AVAILABLE;
+
 		/* standard SATA port setup */
 		if (hpriv->port_map & (1 << i))
 			ap->ioaddr.cmd_addr = port_mmio;

-- 
