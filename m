Return-Path: <linux-kernel-owner+w=401wt.eu-S933485AbXHIV05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933485AbXHIV05 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 17:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933341AbXHIV0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 17:26:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:53740 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933303AbXHIV0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 17:26:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,242,1183359600"; 
   d="scan'208";a="276846466"
Date: Thu, 9 Aug 2007 14:23:41 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: jeff@garzik.org
Cc: htejun@gmail.com, akpm@linux-foundation.org, arjan@linux.intel.com,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: [patch 1/4] Store interrupt value
Message-Id: <20070809142341.817322f1.kristen.c.accardi@intel.com>
In-Reply-To: <20070809211800.022150464@intel.com>
References: <20070809211800.022150464@intel.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use a stored value for which interrupts to enable.  Changing this allows
us to selectively turn off certain interrupts later and have them 
stay off.

Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Index: 2.6-git/drivers/ata/ahci.c
===================================================================
--- 2.6-git.orig/drivers/ata/ahci.c
+++ 2.6-git/drivers/ata/ahci.c
@@ -175,6 +175,7 @@ enum {
 	AHCI_FLAG_32BIT_ONLY		= (1 << 28), /* force 32bit */
 	AHCI_FLAG_MV_PATA		= (1 << 29), /* PATA port */
 	AHCI_FLAG_NO_MSI		= (1 << 30), /* no PCI MSI */
+	AHCI_FLAG_NO_HOTPLUG		= (1 << 31), /* ignore PxSERR.DIAG.N */
 
 	AHCI_FLAG_COMMON		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
 					  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA |
@@ -215,6 +216,7 @@ struct ahci_port_priv {
 	unsigned int		ncq_saw_d2h:1;
 	unsigned int		ncq_saw_dmas:1;
 	unsigned int		ncq_saw_sdb:1;
+	u32 			intr_mask;	/* interrupts to enable */
 };
 
 static int ahci_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val);
@@ -1518,6 +1520,7 @@ static void ahci_thaw(struct ata_port *a
 	void __iomem *mmio = ap->host->iomap[AHCI_PCI_BAR];
 	void __iomem *port_mmio = ahci_port_base(ap);
 	u32 tmp;
+	struct ahci_port_priv *pp = ap->private_data;
 
 	/* clear IRQ */
 	tmp = readl(port_mmio + PORT_IRQ_STAT);
@@ -1525,7 +1528,7 @@ static void ahci_thaw(struct ata_port *a
 	writel(1 << ap->port_no, mmio + HOST_IRQ_STAT);
 
 	/* turn IRQ back on */
-	writel(DEF_PORT_IRQ, port_mmio + PORT_IRQ_MASK);
+	writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
 }
 
 static void ahci_error_handler(struct ata_port *ap)
@@ -1679,6 +1682,12 @@ static int ahci_port_start(struct ata_po
 	pp->cmd_tbl = mem;
 	pp->cmd_tbl_dma = mem_dma;
 
+	/*
+ 	 * Save off initial list of interrupts to be enabled.
+ 	 * This could be changed later
+ 	 */
+	pp->intr_mask = DEF_PORT_IRQ;
+
 	ap->private_data = pp;
 
 	/* engage engines, captain */

-- 
