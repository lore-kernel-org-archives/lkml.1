Return-Path: <linux-kernel-owner+w=401wt.eu-S933405AbXLNTxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933405AbXLNTxM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 14:53:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754857AbXLNTwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 14:52:35 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57117 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758290AbXLNTwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 14:52:31 -0500
Date: Fri, 14 Dec 2007 11:51:36 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.22.15
Message-ID: <20071214195136.GD15765@kroah.com>
References: <20071214195120.GC15765@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071214195120.GC15765@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 873c786..a8bdcc6 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 22
-EXTRAVERSION = .14
+EXTRAVERSION = .15
 NAME = Holy Dancing Manatees, Batman!
 
 # *DOCUMENTATION*
diff --git a/crypto/algapi.c b/crypto/algapi.c
index f137a43..ec286a2 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -98,6 +98,9 @@ static void crypto_remove_spawn(struct crypto_spawn *spawn,
 		return;
 
 	inst->alg.cra_flags |= CRYPTO_ALG_DEAD;
+	if (hlist_unhashed(&inst->list))
+		return;
+
 	if (!tmpl || !crypto_tmpl_get(tmpl))
 		return;
 
@@ -333,9 +336,6 @@ int crypto_register_instance(struct crypto_template *tmpl,
 	LIST_HEAD(list);
 	int err = -EINVAL;
 
-	if (inst->alg.cra_destroy)
-		goto err;
-
 	err = crypto_check_alg(&inst->alg);
 	if (err)
 		goto err;
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 3400b3e..e722f83 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1241,7 +1241,7 @@ static void ahci_host_intr(struct ata_port *ap)
 	struct ata_eh_info *ehi = &ap->eh_info;
 	struct ahci_port_priv *pp = ap->private_data;
 	u32 status, qc_active;
-	int rc, known_irq = 0;
+	int rc;
 
 	status = readl(port_mmio + PORT_IRQ_STAT);
 	writel(status, port_mmio + PORT_IRQ_STAT);
@@ -1257,74 +1257,11 @@ static void ahci_host_intr(struct ata_port *ap)
 		qc_active = readl(port_mmio + PORT_CMD_ISSUE);
 
 	rc = ata_qc_complete_multiple(ap, qc_active, NULL);
-	if (rc > 0)
-		return;
 	if (rc < 0) {
 		ehi->err_mask |= AC_ERR_HSM;
 		ehi->action |= ATA_EH_SOFTRESET;
 		ata_port_freeze(ap);
-		return;
-	}
-
-	/* hmmm... a spurious interupt */
-
-	/* if !NCQ, ignore.  No modern ATA device has broken HSM
-	 * implementation for non-NCQ commands.
-	 */
-	if (!ap->sactive)
-		return;
-
-	if (status & PORT_IRQ_D2H_REG_FIS) {
-		if (!pp->ncq_saw_d2h)
-			ata_port_printk(ap, KERN_INFO,
-				"D2H reg with I during NCQ, "
-				"this message won't be printed again\n");
-		pp->ncq_saw_d2h = 1;
-		known_irq = 1;
-	}
-
-	if (status & PORT_IRQ_DMAS_FIS) {
-		if (!pp->ncq_saw_dmas)
-			ata_port_printk(ap, KERN_INFO,
-				"DMAS FIS during NCQ, "
-				"this message won't be printed again\n");
-		pp->ncq_saw_dmas = 1;
-		known_irq = 1;
-	}
-
-	if (status & PORT_IRQ_SDB_FIS) {
-		const __le32 *f = pp->rx_fis + RX_FIS_SDB;
-
-		if (le32_to_cpu(f[1])) {
-			/* SDB FIS containing spurious completions
-			 * might be dangerous, whine and fail commands
-			 * with HSM violation.  EH will turn off NCQ
-			 * after several such failures.
-			 */
-			ata_ehi_push_desc(ehi,
-				"spurious completions during NCQ "
-				"issue=0x%x SAct=0x%x FIS=%08x:%08x",
-				readl(port_mmio + PORT_CMD_ISSUE),
-				readl(port_mmio + PORT_SCR_ACT),
-				le32_to_cpu(f[0]), le32_to_cpu(f[1]));
-			ehi->err_mask |= AC_ERR_HSM;
-			ehi->action |= ATA_EH_SOFTRESET;
-			ata_port_freeze(ap);
-		} else {
-			if (!pp->ncq_saw_sdb)
-				ata_port_printk(ap, KERN_INFO,
-					"spurious SDB FIS %08x:%08x during NCQ, "
-					"this message won't be printed again\n",
-					le32_to_cpu(f[0]), le32_to_cpu(f[1]));
-			pp->ncq_saw_sdb = 1;
-		}
-		known_irq = 1;
 	}
-
-	if (!known_irq)
-		ata_port_printk(ap, KERN_INFO, "spurious interrupt "
-				"(irq_stat 0x%x active_tag 0x%x sactive 0x%x)\n",
-				status, ap->active_tag, ap->sactive);
 }
 
 static void ahci_irq_clear(struct ata_port *ap)
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index e6e403f..22b6368 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3785,6 +3785,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	/* Devices where NCQ should be avoided */
 	/* NCQ is slow */
         { "WDC WD740ADFD-00",   NULL,		ATA_HORKAGE_NONCQ },
+	{ "WDC WD740ADFD-00NLR1", NULL,		ATA_HORKAGE_NONCQ, },
 	/* http://thread.gmane.org/gmane.linux.ide/14907 */
 	{ "FUJITSU MHT2060BH",	NULL,		ATA_HORKAGE_NONCQ },
 	/* NCQ is broken */
@@ -3803,15 +3804,6 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "HTS541060G9SA00",    "MB3OC60D",     ATA_HORKAGE_NONCQ, },
 	{ "HTS541080G9SA00",    "MB4OC60D",     ATA_HORKAGE_NONCQ, },
 	{ "HTS541010G9SA00",    "MBZOC60D",     ATA_HORKAGE_NONCQ, },
-	/* Drives which do spurious command completion */
-	{ "HTS541680J9SA00",	"SB2IC7EP",	ATA_HORKAGE_NONCQ, },
-	{ "HTS541612J9SA00",	"SBDIC7JP",	ATA_HORKAGE_NONCQ, },
-	{ "Hitachi HTS541616J9SA00", "SB4OC70P", ATA_HORKAGE_NONCQ, },
-	{ "WDC WD740ADFD-00NLR1", NULL,		ATA_HORKAGE_NONCQ, },
-	{ "FUJITSU MHV2080BH",	"00840028",	ATA_HORKAGE_NONCQ, },
-	{ "ST9160821AS",	"3.CLF",	ATA_HORKAGE_NONCQ, },
-	{ "ST3160812AS",	"3.AD",		ATA_HORKAGE_NONCQ, },
-	{ "SAMSUNG HD401LJ",	"ZZ100-15",	ATA_HORKAGE_NONCQ, },
 
 	/* End Marker */
 	{ }
diff --git a/drivers/atm/he.c b/drivers/atm/he.c
index d33aba6..3b64a99 100644
--- a/drivers/atm/he.c
+++ b/drivers/atm/he.c
@@ -394,6 +394,11 @@ he_init_one(struct pci_dev *pci_dev, const struct pci_device_id *pci_ent)
 	he_dev->atm_dev->dev_data = he_dev;
 	atm_dev->dev_data = he_dev;
 	he_dev->number = atm_dev->number;
+#ifdef USE_TASKLET
+	tasklet_init(&he_dev->tasklet, he_tasklet, (unsigned long) he_dev);
+#endif
+	spin_lock_init(&he_dev->global_lock);
+
 	if (he_start(atm_dev)) {
 		he_stop(he_dev);
 		err = -ENODEV;
@@ -1173,11 +1178,6 @@ he_start(struct atm_dev *dev)
 	if ((err = he_init_irq(he_dev)) != 0)
 		return err;
 
-#ifdef USE_TASKLET
-	tasklet_init(&he_dev->tasklet, he_tasklet, (unsigned long) he_dev);
-#endif
-	spin_lock_init(&he_dev->global_lock);
-
 	/* 4.11 enable pci bus controller state machines */
 	host_cntl |= (OUTFF_ENB | CMDFF_ENB |
 				QUICK_RD_RETRY | QUICK_WR_RETRY | PERR_INT_ENB);
diff --git a/drivers/block/rd.c b/drivers/block/rd.c
index a1512da..e30bd9e 100644
--- a/drivers/block/rd.c
+++ b/drivers/block/rd.c
@@ -189,6 +189,18 @@ static int ramdisk_set_page_dirty(struct page *page)
 	return 0;
 }
 
+/*
+ * releasepage is called by pagevec_strip/try_to_release_page if
+ * buffers_heads_over_limit is true. Without a releasepage function
+ * try_to_free_buffers is called instead. That can unset the dirty
+ * bit of our ram disk pages, which will be eventually freed, even
+ * if the page is still in use.
+ */
+static int ramdisk_releasepage(struct page *page, gfp_t dummy)
+{
+	return 0;
+}
+
 static const struct address_space_operations ramdisk_aops = {
 	.readpage	= ramdisk_readpage,
 	.prepare_write	= ramdisk_prepare_write,
@@ -196,6 +208,7 @@ static const struct address_space_operations ramdisk_aops = {
 	.writepage	= ramdisk_writepage,
 	.set_page_dirty	= ramdisk_set_page_dirty,
 	.writepages	= ramdisk_writepages,
+	.releasepage	= ramdisk_releasepage,
 };
 
 static int rd_blkdev_pagecache_IO(int rw, struct bio_vec *vec, sector_t sector,
diff --git a/drivers/isdn/i4l/isdn_common.c b/drivers/isdn/i4l/isdn_common.c
index c97330b..eb9a247 100644
--- a/drivers/isdn/i4l/isdn_common.c
+++ b/drivers/isdn/i4l/isdn_common.c
@@ -1514,6 +1514,7 @@ isdn_ioctl(struct inode *inode, struct file *file, uint cmd, ulong arg)
 					if (copy_from_user(&iocts, argp,
 					     sizeof(isdn_ioctl_struct)))
 						return -EFAULT;
+					iocts.drvid[sizeof(iocts.drvid)-1] = 0;
 					if (strlen(iocts.drvid)) {
 						if ((p = strchr(iocts.drvid, ',')))
 							*p = 0;
@@ -1598,6 +1599,7 @@ isdn_ioctl(struct inode *inode, struct file *file, uint cmd, ulong arg)
 					if (copy_from_user(&iocts, argp,
 					     sizeof(isdn_ioctl_struct)))
 						return -EFAULT;
+					iocts.drvid[sizeof(iocts.drvid)-1] = 0;
 					if (strlen(iocts.drvid)) {
 						drvidx = -1;
 						for (i = 0; i < ISDN_MAX_DRIVERS; i++)
@@ -1642,7 +1644,7 @@ isdn_ioctl(struct inode *inode, struct file *file, uint cmd, ulong arg)
 					} else {
 						p = (char __user *) iocts.arg;
 						for (i = 0; i < 10; i++) {
-							sprintf(bname, "%s%s",
+							snprintf(bname, sizeof(bname), "%s%s",
 								strlen(dev->drv[drvidx]->msn2eaz[i]) ?
 								dev->drv[drvidx]->msn2eaz[i] : "_",
 								(i < 9) ? "," : "\0");
@@ -1672,6 +1674,7 @@ isdn_ioctl(struct inode *inode, struct file *file, uint cmd, ulong arg)
 					char *p;
 					if (copy_from_user(&iocts, argp, sizeof(isdn_ioctl_struct)))
 						return -EFAULT;
+					iocts.drvid[sizeof(iocts.drvid)-1] = 0;
 					if (strlen(iocts.drvid)) {
 						if ((p = strchr(iocts.drvid, ',')))
 							*p = 0;
diff --git a/drivers/isdn/i4l/isdn_net.c b/drivers/isdn/i4l/isdn_net.c
index aa83277..75e1423 100644
--- a/drivers/isdn/i4l/isdn_net.c
+++ b/drivers/isdn/i4l/isdn_net.c
@@ -2126,7 +2126,7 @@ isdn_net_find_icall(int di, int ch, int idx, setup_parm *setup)
 	u_long flags;
 	isdn_net_dev *p;
 	isdn_net_phone *n;
-	char nr[32];
+	char nr[ISDN_MSNLEN];
 	char *my_eaz;
 
 	/* Search name in netdev-chain */
@@ -2135,7 +2135,7 @@ isdn_net_find_icall(int di, int ch, int idx, setup_parm *setup)
 		nr[1] = '\0';
 		printk(KERN_INFO "isdn_net: Incoming call without OAD, assuming '0'\n");
 	} else
-		strcpy(nr, setup->phone);
+		strlcpy(nr, setup->phone, ISDN_MSNLEN);
 	si1 = (int) setup->si1;
 	si2 = (int) setup->si2;
 	if (!setup->eazmsn[0]) {
@@ -2802,7 +2802,7 @@ isdn_net_setcfg(isdn_net_ioctl_cfg * cfg)
 				chidx = -1;
 			}
 		}
-		strcpy(lp->msn, cfg->eaz);
+		strlcpy(lp->msn, cfg->eaz, sizeof(lp->msn));
 		lp->pre_device = drvidx;
 		lp->pre_channel = chidx;
 		lp->onhtime = cfg->onhtime;
@@ -2951,7 +2951,7 @@ isdn_net_addphone(isdn_net_ioctl_phone * phone)
 	if (p) {
 		if (!(n = kmalloc(sizeof(isdn_net_phone), GFP_KERNEL)))
 			return -ENOMEM;
-		strcpy(n->num, phone->phone);
+		strlcpy(n->num, phone->phone, sizeof(n->num));
 		n->next = p->local->phone[phone->outgoing & 1];
 		p->local->phone[phone->outgoing & 1] = n;
 		return 0;
diff --git a/drivers/net/atl1/atl1_main.c b/drivers/net/atl1/atl1_main.c
index 6862c11..1b7a5a8 100644
--- a/drivers/net/atl1/atl1_main.c
+++ b/drivers/net/atl1/atl1_main.c
@@ -2097,21 +2097,26 @@ static int __devinit atl1_probe(struct pci_dev *pdev,
 	struct net_device *netdev;
 	struct atl1_adapter *adapter;
 	static int cards_found = 0;
-	bool pci_using_64 = true;
 	int err;
 
 	err = pci_enable_device(pdev);
 	if (err)
 		return err;
 
-	err = pci_set_dma_mask(pdev, DMA_64BIT_MASK);
+	/*
+	 * The atl1 chip can DMA to 64-bit addresses, but it uses a single
+	 * shared register for the high 32 bits, so only a single, aligned,
+	 * 4 GB physical address range can be used at a time.
+	 *
+	 * Supporting 64-bit DMA on this hardware is more trouble than it's
+	 * worth.  It is far easier to limit to 32-bit DMA than update
+	 * various kernel subsystems to support the mechanics required by a
+	 * fixed-high-32-bit system.
+	 */
+	err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
 	if (err) {
-		err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
-		if (err) {
-			dev_err(&pdev->dev, "no usable DMA configuration\n");
-			goto err_dma;
-		}
-		pci_using_64 = false;
+		dev_err(&pdev->dev, "no usable DMA configuration\n");
+		goto err_dma;
 	}
 	/* Mark all PCI regions associated with PCI device
 	 * pdev as being reserved by owner atl1_driver_name
@@ -2176,7 +2181,6 @@ static int __devinit atl1_probe(struct pci_dev *pdev,
 
 	netdev->ethtool_ops = &atl1_ethtool_ops;
 	adapter->bd_number = cards_found;
-	adapter->pci_using_64 = pci_using_64;
 
 	/* setup the private structure */
 	err = atl1_sw_init(adapter);
@@ -2193,9 +2197,6 @@ static int __devinit atl1_probe(struct pci_dev *pdev,
 	 */
 	/* netdev->features |= NETIF_F_TSO; */
 
-	if (pci_using_64)
-		netdev->features |= NETIF_F_HIGHDMA;
-
 	netdev->features |= NETIF_F_LLTX;
 
 	/*
diff --git a/drivers/net/forcedeth.c b/drivers/net/forcedeth.c
index 06f6ec3..36b3a66 100644
--- a/drivers/net/forcedeth.c
+++ b/drivers/net/forcedeth.c
@@ -5283,19 +5283,15 @@ static int __devinit nv_probe(struct pci_dev *pci_dev, const struct pci_device_i
 		if (readl(base + NvRegTransmitterControl) & NVREG_XMITCTL_SYNC_PHY_INIT) {
 			np->mac_in_use = readl(base + NvRegTransmitterControl) & NVREG_XMITCTL_MGMT_ST;
 			dprintk(KERN_INFO "%s: mgmt unit is running. mac in use %x.\n", pci_name(pci_dev), np->mac_in_use);
-			for (i = 0; i < 5000; i++) {
-				msleep(1);
-				if (nv_mgmt_acquire_sema(dev)) {
-					/* management unit setup the phy already? */
-					if ((readl(base + NvRegTransmitterControl) & NVREG_XMITCTL_SYNC_MASK) ==
-					    NVREG_XMITCTL_SYNC_PHY_INIT) {
-						/* phy is inited by mgmt unit */
-						phyinitialized = 1;
-						dprintk(KERN_INFO "%s: Phy already initialized by mgmt unit.\n", pci_name(pci_dev));
-					} else {
-						/* we need to init the phy */
-					}
-					break;
+			if (nv_mgmt_acquire_sema(dev)) {
+				/* management unit setup the phy already? */
+				if ((readl(base + NvRegTransmitterControl) & NVREG_XMITCTL_SYNC_MASK) ==
+				    NVREG_XMITCTL_SYNC_PHY_INIT) {
+					/* phy is inited by mgmt unit */
+					phyinitialized = 1;
+					dprintk(KERN_INFO "%s: Phy already initialized by mgmt unit.\n", pci_name(pci_dev));
+				} else {
+					/* we need to init the phy */
 				}
 			}
 		}
@@ -5553,6 +5549,22 @@ static struct pci_device_id pci_tbl[] = {
 		PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NVENET_27),
 		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_HIGH_DMA|DEV_HAS_POWER_CNTRL|DEV_HAS_MSI|DEV_HAS_PAUSEFRAME_TX|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT,
 	},
+	{	/* MCP79 Ethernet Controller */
+		PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NVENET_36),
+		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_CHECKSUM|DEV_HAS_HIGH_DMA|DEV_HAS_MSI|DEV_HAS_POWER_CNTRL|DEV_HAS_PAUSEFRAME_TX|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT,
+	},
+	{	/* MCP79 Ethernet Controller */
+		PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NVENET_37),
+		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_CHECKSUM|DEV_HAS_HIGH_DMA|DEV_HAS_MSI|DEV_HAS_POWER_CNTRL|DEV_HAS_PAUSEFRAME_TX|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT,
+	},
+	{	/* MCP79 Ethernet Controller */
+		PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NVENET_38),
+		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_CHECKSUM|DEV_HAS_HIGH_DMA|DEV_HAS_MSI|DEV_HAS_POWER_CNTRL|DEV_HAS_PAUSEFRAME_TX|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT,
+	},
+	{	/* MCP79 Ethernet Controller */
+		PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NVENET_39),
+		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_CHECKSUM|DEV_HAS_HIGH_DMA|DEV_HAS_MSI|DEV_HAS_POWER_CNTRL|DEV_HAS_PAUSEFRAME_TX|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT,
+	},
 	{0,},
 };
 
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index 5caa8b3..ba78f8e 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -571,12 +571,15 @@ static int ehci_run (struct usb_hcd *hcd)
 	 * from the companions to the EHCI controller.  If any of the
 	 * companions are in the middle of a port reset at the time, it
 	 * could cause trouble.  Write-locking ehci_cf_port_reset_rwsem
-	 * guarantees that no resets are in progress.
+	 * guarantees that no resets are in progress.  After we set CF,
+	 * a short delay lets the hardware catch up; new resets shouldn't
+	 * be started before the port switching actions could complete.
 	 */
 	down_write(&ehci_cf_port_reset_rwsem);
 	hcd->state = HC_STATE_RUNNING;
 	ehci_writel(ehci, FLAG_CF, &ehci->regs->configured_flag);
 	ehci_readl(ehci, &ehci->regs->command);	/* unblock posted writes */
+	msleep(5);
 	up_write(&ehci_cf_port_reset_rwsem);
 
 	temp = HC_VERSION(ehci_readl(ehci, &ehci->caps->hc_capbase));
diff --git a/drivers/usb/image/microtek.c b/drivers/usb/image/microtek.c
index 51bd80d..3acfd1a 100644
--- a/drivers/usb/image/microtek.c
+++ b/drivers/usb/image/microtek.c
@@ -823,7 +823,7 @@ static int mts_usb_probe(struct usb_interface *intf,
 		goto out_kfree2;
 
 	new_desc->host->hostdata[0] = (unsigned long)new_desc;
-	if (scsi_add_host(new_desc->host, NULL)) {
+	if (scsi_add_host(new_desc->host, &dev->dev)) {
 		err_retval = -EIO;
 		goto out_host_put;
 	}
diff --git a/drivers/video/fb_ddc.c b/drivers/video/fb_ddc.c
index f836137..a0df632 100644
--- a/drivers/video/fb_ddc.c
+++ b/drivers/video/fb_ddc.c
@@ -56,13 +56,12 @@ unsigned char *fb_ddc_read(struct i2c_adapter *adapter)
 	int i, j;
 
 	algo_data->setscl(algo_data->data, 1);
-	algo_data->setscl(algo_data->data, 0);
 
 	for (i = 0; i < 3; i++) {
 		/* For some old monitors we need the
 		 * following process to initialize/stop DDC
 		 */
-		algo_data->setsda(algo_data->data, 0);
+		algo_data->setsda(algo_data->data, 1);
 		msleep(13);
 
 		algo_data->setscl(algo_data->data, 1);
@@ -97,14 +96,15 @@ unsigned char *fb_ddc_read(struct i2c_adapter *adapter)
 		algo_data->setsda(algo_data->data, 1);
 		msleep(15);
 		algo_data->setscl(algo_data->data, 0);
+		algo_data->setsda(algo_data->data, 0);
 		if (edid)
 			break;
 	}
 	/* Release the DDC lines when done or the Apple Cinema HD display
 	 * will switch off
 	 */
-	algo_data->setsda(algo_data->data, 0);
-	algo_data->setscl(algo_data->data, 0);
+	algo_data->setsda(algo_data->data, 1);
+	algo_data->setscl(algo_data->data, 1);
 
 	return edid;
 }
diff --git a/fs/nfsd/nfsfh.c b/fs/nfsd/nfsfh.c
index 6ca2d24..f83d235 100644
--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -565,13 +565,23 @@ enum fsid_source fsid_source(struct svc_fh *fhp)
 	case FSID_DEV:
 	case FSID_ENCODE_DEV:
 	case FSID_MAJOR_MINOR:
-		return FSIDSOURCE_DEV;
+		if (fhp->fh_export->ex_dentry->d_inode->i_sb->s_type->fs_flags
+		    & FS_REQUIRES_DEV)
+			return FSIDSOURCE_DEV;
+		break;
 	case FSID_NUM:
-		return FSIDSOURCE_FSID;
-	default:
 		if (fhp->fh_export->ex_flags & NFSEXP_FSID)
 			return FSIDSOURCE_FSID;
-		else
-			return FSIDSOURCE_UUID;
+		break;
+	default:
+		break;
 	}
+	/* either a UUID type filehandle, or the filehandle doesn't
+	 * match the export.
+	 */
+	if (fhp->fh_export->ex_flags & NFSEXP_FSID)
+		return FSIDSOURCE_FSID;
+	if (fhp->fh_export->ex_uuid)
+		return FSIDSOURCE_UUID;
+	return FSIDSOURCE_DEV;
 }
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index c1ffa1b..887c2ce 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1239,6 +1239,10 @@
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP67_IDE       0x0560
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP73_IDE       0x056C
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP77_IDE       0x0759
+#define PCI_DEVICE_ID_NVIDIA_NVENET_36              0x0AB0
+#define PCI_DEVICE_ID_NVIDIA_NVENET_37              0x0AB1
+#define PCI_DEVICE_ID_NVIDIA_NVENET_38              0x0AB2
+#define PCI_DEVICE_ID_NVIDIA_NVENET_39              0x0AB3
 
 #define PCI_VENDOR_ID_IMS		0x10e0
 #define PCI_DEVICE_ID_IMS_TT128		0x9128
diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
index 1c4eb41..9c4ad75 100644
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -7,12 +7,25 @@
 #ifndef _LINUX_THREAD_INFO_H
 #define _LINUX_THREAD_INFO_H
 
+#include <linux/types.h>
+
 /*
- * System call restart block. 
+ * System call restart block.
  */
 struct restart_block {
 	long (*fn)(struct restart_block *);
-	unsigned long arg0, arg1, arg2, arg3;
+	union {
+		struct {
+			unsigned long arg0, arg1, arg2, arg3;
+		};
+		/* For futex_wait */
+		struct {
+			u32 *uaddr;
+			u32 val;
+			u32 flags;
+			u64 time;
+		} futex;
+	};
 };
 
 extern long do_no_restart_syscall(struct restart_block *parm);
diff --git a/include/net/tcp.h b/include/net/tcp.h
index a99b4f6..c05e018 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1258,6 +1258,9 @@ static inline void tcp_insert_write_queue_before(struct sk_buff *new,
 						  struct sock *sk)
 {
 	__skb_insert(new, skb->prev, skb, &sk->sk_write_queue);
+
+	if (sk->sk_send_head == skb)
+		sk->sk_send_head = new;
 }
 
 static inline void tcp_unlink_write_queue(struct sk_buff *skb, struct sock *sk)
diff --git a/kernel/exit.c b/kernel/exit.c
index e3adc46..369dae2 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1339,7 +1339,7 @@ static int wait_task_stopped(struct task_struct *p, int delayed_group_leader,
 		if (unlikely(!exit_code) || unlikely(p->exit_state))
 			goto bail_ref;
 		return wait_noreap_copyout(p, pid, uid,
-					   why, (exit_code << 8) | 0x7f,
+					   why, exit_code,
 					   infop, ru);
 	}
 
diff --git a/kernel/futex.c b/kernel/futex.c
index 9b57f7e..592cf07 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1129,9 +1129,9 @@ static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
 
 /*
  * In case we must use restart_block to restart a futex_wait,
- * we encode in the 'arg3' shared capability
+ * we encode in the 'flags' shared capability
  */
-#define ARG3_SHARED  1
+#define FLAGS_SHARED  1
 
 static long futex_wait_restart(struct restart_block *restart);
 static int futex_wait(u32 __user *uaddr, struct rw_semaphore *fshared,
@@ -1272,12 +1272,13 @@ static int futex_wait(u32 __user *uaddr, struct rw_semaphore *fshared,
 		struct restart_block *restart;
 		restart = &current_thread_info()->restart_block;
 		restart->fn = futex_wait_restart;
-		restart->arg0 = (unsigned long)uaddr;
-		restart->arg1 = (unsigned long)val;
-		restart->arg2 = (unsigned long)abs_time;
-		restart->arg3 = 0;
+		restart->futex.uaddr = (u32 *)uaddr;
+		restart->futex.val = val;
+		restart->futex.time = abs_time->tv64;
+		restart->futex.flags = 0;
+
 		if (fshared)
-			restart->arg3 |= ARG3_SHARED;
+			restart->futex.flags |= FLAGS_SHARED;
 		return -ERESTART_RESTARTBLOCK;
 	}
 
@@ -1293,15 +1294,15 @@ static int futex_wait(u32 __user *uaddr, struct rw_semaphore *fshared,
 
 static long futex_wait_restart(struct restart_block *restart)
 {
-	u32 __user *uaddr = (u32 __user *)restart->arg0;
-	u32 val = (u32)restart->arg1;
-	ktime_t *abs_time = (ktime_t *)restart->arg2;
+	u32 __user *uaddr = (u32 __user *)restart->futex.uaddr;
 	struct rw_semaphore *fshared = NULL;
+	ktime_t t;
 
+	t.tv64 = restart->futex.time;
 	restart->fn = do_no_restart_syscall;
-	if (restart->arg3 & ARG3_SHARED)
+	if (restart->futex.flags & FLAGS_SHARED)
 		fshared = &current->mm->mmap_sem;
-	return (long)futex_wait(uaddr, fshared, val, abs_time);
+	return (long)futex_wait(uaddr, fshared, restart->futex.val, &t);
 }
 
 
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 23c03f4..355e867 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -825,6 +825,14 @@ hrtimer_start(struct hrtimer *timer, ktime_t tim, const enum hrtimer_mode mode)
 #ifdef CONFIG_TIME_LOW_RES
 		tim = ktime_add(tim, base->resolution);
 #endif
+		/*
+		 * Careful here: User space might have asked for a
+		 * very long sleep, so the add above might result in a
+		 * negative number, which enqueues the timer in front
+		 * of the queue.
+		 */
+		if (tim.tv64 < 0)
+			tim.tv64 = KTIME_MAX;
 	}
 	timer->expires = tim;
 
diff --git a/kernel/sys.c b/kernel/sys.c
index afd9b93..28e8364 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -31,7 +31,6 @@
 #include <linux/cn_proc.h>
 #include <linux/getcpu.h>
 #include <linux/task_io_accounting_ops.h>
-#include <linux/cpu.h>
 
 #include <linux/compat.h>
 #include <linux/syscalls.h>
@@ -866,7 +865,6 @@ EXPORT_SYMBOL_GPL(kernel_halt);
 void kernel_power_off(void)
 {
 	kernel_shutdown_prepare(SYSTEM_POWER_OFF);
-	disable_nonboot_cpus();
 	printk(KERN_EMERG "Power down.\n");
 	machine_power_off();
 }
diff --git a/lib/libcrc32c.c b/lib/libcrc32c.c
index 60f4680..1f3a52e 100644
--- a/lib/libcrc32c.c
+++ b/lib/libcrc32c.c
@@ -33,7 +33,6 @@
 #include <linux/crc32c.h>
 #include <linux/compiler.h>
 #include <linux/module.h>
-#include <asm/byteorder.h>
 
 MODULE_AUTHOR("Clay Haapala <chaapala@cisco.com>");
 MODULE_DESCRIPTION("CRC32c (Castagnoli) calculations");
@@ -161,15 +160,13 @@ static const u32 crc32c_table[256] = {
  */
 
 u32 __attribute_pure__
-crc32c_le(u32 seed, unsigned char const *data, size_t length)
+crc32c_le(u32 crc, unsigned char const *data, size_t length)
 {
-	u32 crc = __cpu_to_le32(seed);
-	
 	while (length--)
 		crc =
 		    crc32c_table[(crc ^ *data++) & 0xFFL] ^ (crc >> 8);
 
-	return __le32_to_cpu(crc);
+	return crc;
 }
 
 #endif	/* CRC_LE_BITS == 8 */
diff --git a/lib/textsearch.c b/lib/textsearch.c
index 88c98a2..be8bda3 100644
--- a/lib/textsearch.c
+++ b/lib/textsearch.c
@@ -7,7 +7,7 @@
  *		2 of the License, or (at your option) any later version.
  *
  * Authors:	Thomas Graf <tgraf@suug.ch>
- * 		Pablo Neira Ayuso <pablo@eurodev.net>
+ * 		Pablo Neira Ayuso <pablo@netfilter.org>
  *
  * ==========================================================================
  *
@@ -250,7 +250,8 @@ unsigned int textsearch_find_continuous(struct ts_config *conf,
  *       the various search algorithms.
  *
  * Returns a new textsearch configuration according to the specified
- *         parameters or a ERR_PTR().
+ * parameters or a ERR_PTR(). If a zero length pattern is passed, this
+ * function returns EINVAL.
  */
 struct ts_config *textsearch_prepare(const char *algo, const void *pattern,
 				     unsigned int len, gfp_t gfp_mask, int flags)
@@ -259,6 +260,9 @@ struct ts_config *textsearch_prepare(const char *algo, const void *pattern,
 	struct ts_config *conf;
 	struct ts_ops *ops;
 	
+	if (len == 0)
+		return ERR_PTR(-EINVAL);
+
 	ops = lookup_ts_algo(algo);
 #ifdef CONFIG_KMOD
 	/*
diff --git a/mm/shmem.c b/mm/shmem.c
index 2320b60..d1c65fb 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1066,7 +1066,7 @@ shmem_alloc_page(gfp_t gfp, struct shmem_inode_info *info,
 	pvma.vm_policy = mpol_shared_policy_lookup(&info->policy, idx);
 	pvma.vm_pgoff = idx;
 	pvma.vm_end = PAGE_SIZE;
-	page = alloc_page_vma(gfp | __GFP_ZERO, &pvma, 0);
+	page = alloc_page_vma(gfp, &pvma, 0);
 	mpol_free(pvma.vm_policy);
 	return page;
 }
@@ -1086,7 +1086,7 @@ shmem_swapin(struct shmem_inode_info *info,swp_entry_t entry,unsigned long idx)
 static inline struct page *
 shmem_alloc_page(gfp_t gfp,struct shmem_inode_info *info, unsigned long idx)
 {
-	return alloc_page(gfp | __GFP_ZERO);
+	return alloc_page(gfp);
 }
 #endif
 
@@ -1295,6 +1295,7 @@ repeat:
 
 		info->alloced++;
 		spin_unlock(&info->lock);
+		clear_highpage(filepage);
 		flush_dcache_page(filepage);
 		SetPageUptodate(filepage);
 	}
diff --git a/net/bridge/br.c b/net/bridge/br.c
index 848b8fa..94ae4d2 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -39,7 +39,7 @@ static int __init br_init(void)
 
 	err = br_fdb_init();
 	if (err)
-		goto err_out1;
+		goto err_out;
 
 	err = br_netfilter_init();
 	if (err)
@@ -65,6 +65,8 @@ err_out3:
 err_out2:
 	br_netfilter_fini();
 err_out1:
+	br_fdb_fini();
+err_out:
 	llc_sap_put(br_stp_sap);
 	return err;
 }
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 420bbb9..fb2c7cc 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -127,6 +127,7 @@ static inline int is_link_local(const unsigned char *dest)
 struct sk_buff *br_handle_frame(struct net_bridge_port *p, struct sk_buff *skb)
 {
 	const unsigned char *dest = eth_hdr(skb)->h_dest;
+	int (*rhook)(struct sk_buff **pskb);
 
 	if (!is_valid_ether_addr(eth_hdr(skb)->h_source))
 		goto drop;
@@ -148,9 +149,9 @@ struct sk_buff *br_handle_frame(struct net_bridge_port *p, struct sk_buff *skb)
 
 	switch (p->state) {
 	case BR_STATE_FORWARDING:
-
-		if (br_should_route_hook) {
-			if (br_should_route_hook(&skb))
+		rhook = rcu_dereference(br_should_route_hook);
+		if (rhook != NULL) {
+			if (rhook(&skb))
 				return skb;
 			dest = eth_hdr(skb)->h_dest;
 		}
diff --git a/net/bridge/netfilter/ebtable_broute.c b/net/bridge/netfilter/ebtable_broute.c
index d37ce04..bc17cf5 100644
--- a/net/bridge/netfilter/ebtable_broute.c
+++ b/net/bridge/netfilter/ebtable_broute.c
@@ -70,13 +70,13 @@ static int __init ebtable_broute_init(void)
 	if (ret < 0)
 		return ret;
 	/* see br_input.c */
-	br_should_route_hook = ebt_broute;
+	rcu_assign_pointer(br_should_route_hook, ebt_broute);
 	return ret;
 }
 
 static void __exit ebtable_broute_fini(void)
 {
-	br_should_route_hook = NULL;
+	rcu_assign_pointer(br_should_route_hook, NULL);
 	synchronize_net();
 	ebt_unregister_table(&broute_table);
 }
diff --git a/net/decnet/dn_dev.c b/net/decnet/dn_dev.c
index d46e453..b51ee15 100644
--- a/net/decnet/dn_dev.c
+++ b/net/decnet/dn_dev.c
@@ -651,16 +651,18 @@ static int dn_nl_deladdr(struct sk_buff *skb, struct nlmsghdr *nlh, void *arg)
 	struct dn_dev *dn_db;
 	struct ifaddrmsg *ifm;
 	struct dn_ifaddr *ifa, **ifap;
-	int err = -EADDRNOTAVAIL;
+	int err;
 
 	err = nlmsg_parse(nlh, sizeof(*ifm), tb, IFA_MAX, dn_ifa_policy);
 	if (err < 0)
 		goto errout;
 
+	err = -ENODEV;
 	ifm = nlmsg_data(nlh);
 	if ((dn_db = dn_dev_by_index(ifm->ifa_index)) == NULL)
 		goto errout;
 
+	err = -EADDRNOTAVAIL;
 	for (ifap = &dn_db->ifa_list; (ifa = *ifap); ifap = &ifa->ifa_next) {
 		if (tb[IFA_LOCAL] &&
 		    nla_memcmp(tb[IFA_LOCAL], &ifa->ifa_local, 2))
diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index e00767e..84097ee 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -110,12 +110,8 @@
 #include <net/tcp.h>
 #include <net/sock.h>
 #include <net/arp.h>
-#if defined(CONFIG_AX25) || defined(CONFIG_AX25_MODULE)
 #include <net/ax25.h>
-#if defined(CONFIG_NETROM) || defined(CONFIG_NETROM_MODULE)
 #include <net/netrom.h>
-#endif
-#endif
 #if defined(CONFIG_ATM_CLIP) || defined(CONFIG_ATM_CLIP_MODULE)
 #include <net/atmclip.h>
 struct neigh_table *clip_tbl_hook;
@@ -729,20 +725,10 @@ static int arp_process(struct sk_buff *skb)
 		    htons(dev_type) != arp->ar_hrd)
 			goto out;
 		break;
-#ifdef CONFIG_NET_ETHERNET
 	case ARPHRD_ETHER:
-#endif
-#ifdef CONFIG_TR
 	case ARPHRD_IEEE802_TR:
-#endif
-#ifdef CONFIG_FDDI
 	case ARPHRD_FDDI:
-#endif
-#ifdef CONFIG_NET_FC
 	case ARPHRD_IEEE802:
-#endif
-#if defined(CONFIG_NET_ETHERNET) || defined(CONFIG_TR) || \
-    defined(CONFIG_FDDI)	 || defined(CONFIG_NET_FC)
 		/*
 		 * ETHERNET, Token Ring and Fibre Channel (which are IEEE 802
 		 * devices, according to RFC 2625) devices will accept ARP
@@ -757,21 +743,16 @@ static int arp_process(struct sk_buff *skb)
 		    arp->ar_pro != htons(ETH_P_IP))
 			goto out;
 		break;
-#endif
-#if defined(CONFIG_AX25) || defined(CONFIG_AX25_MODULE)
 	case ARPHRD_AX25:
 		if (arp->ar_pro != htons(AX25_P_IP) ||
 		    arp->ar_hrd != htons(ARPHRD_AX25))
 			goto out;
 		break;
-#if defined(CONFIG_NETROM) || defined(CONFIG_NETROM_MODULE)
 	case ARPHRD_NETROM:
 		if (arp->ar_pro != htons(AX25_P_IP) ||
 		    arp->ar_hrd != htons(ARPHRD_NETROM))
 			goto out;
 		break;
-#endif
-#endif
 	}
 
 	/* Understand only these message types */
diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index ea02f00..3b01a5f 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -633,7 +633,7 @@ static int clean_nat(struct nf_conn *i, void *data)
 
 	if (!nat)
 		return 0;
-	memset(nat, 0, sizeof(nat));
+	memset(nat, 0, sizeof(*nat));
 	i->status &= ~(IPS_NAT_MASK | IPS_NAT_DONE_MASK | IPS_SEQ_ADJUST);
 	return 0;
 }
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 29ca63e..4aa2551 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -3150,18 +3150,14 @@ static int ip_rt_acct_read(char *buffer, char **start, off_t offset,
 	offset /= sizeof(u32);
 
 	if (length > 0) {
-		u32 *src = ((u32 *) IP_RT_ACCT_CPU(0)) + offset;
 		u32 *dst = (u32 *) buffer;
 
-		/* Copy first cpu. */
 		*start = buffer;
-		memcpy(dst, src, length);
+		memset(dst, 0, length);
 
-		/* Add the other cpus in, one int at a time */
 		for_each_possible_cpu(i) {
 			unsigned int j;
-
-			src = ((u32 *) IP_RT_ACCT_CPU(i)) + offset;
+			u32 *src = ((u32 *) IP_RT_ACCT_CPU(i)) + offset;
 
 			for (j = 0; j < length/4; j++)
 				dst[j] += src[j];
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 53ef0f4..6ea1306 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -121,7 +121,7 @@ static int sysctl_tcp_congestion_control(ctl_table *table, int __user *name,
 
 	tcp_get_default_congestion_control(val);
 	ret = sysctl_string(&tbl, name, nlen, oldval, oldlenp, newval, newlen);
-	if (ret == 0 && newval && newlen)
+	if (ret == 1 && newval && newlen)
 		ret = tcp_set_default_congestion_control(val);
 	return ret;
 }
diff --git a/net/ipv4/tcp_illinois.c b/net/ipv4/tcp_illinois.c
index b2b2256..31dd8c5 100644
--- a/net/ipv4/tcp_illinois.c
+++ b/net/ipv4/tcp_illinois.c
@@ -300,7 +300,7 @@ static u32 tcp_illinois_ssthresh(struct sock *sk)
 	struct illinois *ca = inet_csk_ca(sk);
 
 	/* Multiplicative decrease */
-	return max((tp->snd_cwnd * ca->beta) >> BETA_SHIFT, 2U);
+	return max(tp->snd_cwnd - ((tp->snd_cwnd * ca->beta) >> BETA_SHIFT), 2U);
 }
 
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 53232dd..eee57e6 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1279,7 +1279,6 @@ static int tcp_mtu_probe(struct sock *sk)
 
 	skb = tcp_send_head(sk);
 	tcp_insert_write_queue_before(nskb, skb, sk);
-	tcp_advance_send_head(sk, skb);
 
 	TCP_SKB_CB(nskb)->seq = TCP_SKB_CB(skb)->seq;
 	TCP_SKB_CB(nskb)->end_seq = TCP_SKB_CB(skb)->seq + probe_size;
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index e26b473..6d614c0 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2285,6 +2285,9 @@ static int addrconf_notify(struct notifier_block *this, unsigned long event,
 				break;
 			}
 
+			if (!idev && dev->mtu >= IPV6_MIN_MTU)
+				idev = ipv6_add_dev(dev);
+
 			if (idev)
 				idev->if_flags |= IF_READY;
 		} else {
@@ -2349,12 +2352,18 @@ static int addrconf_notify(struct notifier_block *this, unsigned long event,
 		break;
 
 	case NETDEV_CHANGEMTU:
-		if ( idev && dev->mtu >= IPV6_MIN_MTU) {
+		if (idev && dev->mtu >= IPV6_MIN_MTU) {
 			rt6_mtu_change(dev, dev->mtu);
 			idev->cnf.mtu6 = dev->mtu;
 			break;
 		}
 
+		if (!idev && dev->mtu >= IPV6_MIN_MTU) {
+			idev = ipv6_add_dev(dev);
+			if (idev)
+				break;
+		}
+
 		/* MTU falled under IPV6_MIN_MTU. Stop IPv6 on this interface. */
 
 	case NETDEV_DOWN:
diff --git a/net/key/af_key.c b/net/key/af_key.c
index 0f8304b..ca0db0f 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -1543,7 +1543,7 @@ static int pfkey_get(struct sock *sk, struct sk_buff *skb, struct sadb_msg *hdr,
 
 	out_hdr = (struct sadb_msg *) out_skb->data;
 	out_hdr->sadb_msg_version = hdr->sadb_msg_version;
-	out_hdr->sadb_msg_type = SADB_DUMP;
+	out_hdr->sadb_msg_type = SADB_GET;
 	out_hdr->sadb_msg_satype = pfkey_proto2satype(proto);
 	out_hdr->sadb_msg_errno = 0;
 	out_hdr->sadb_msg_reserved = 0;
diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index 15fe8f6..fe7b3d8 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -178,10 +178,8 @@ xt_tcpmss_target6(struct sk_buff **pskb,
 
 	nexthdr = ipv6h->nexthdr;
 	tcphoff = ipv6_skip_exthdr(*pskb, sizeof(*ipv6h), &nexthdr);
-	if (tcphoff < 0) {
-		WARN_ON(1);
+	if (tcphoff < 0)
 		return NF_DROP;
-	}
 	ret = tcpmss_mangle_packet(pskb, targinfo, tcphoff,
 				   sizeof(*ipv6h) + sizeof(struct tcphdr));
 	if (ret < 0)
diff --git a/net/rxrpc/Kconfig b/net/rxrpc/Kconfig
index e662f1d..0d3103c 100644
--- a/net/rxrpc/Kconfig
+++ b/net/rxrpc/Kconfig
@@ -5,6 +5,7 @@
 config AF_RXRPC
 	tristate "RxRPC session sockets"
 	depends on INET && EXPERIMENTAL
+	select CRYPTO
 	select KEYS
 	help
 	  Say Y or M here to include support for RxRPC session sockets (just
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index d70fa30..ae80150 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1608,8 +1608,15 @@ static int unix_dgram_recvmsg(struct kiocb *iocb, struct socket *sock,
 	mutex_lock(&u->readlock);
 
 	skb = skb_recv_datagram(sk, flags, noblock, &err);
-	if (!skb)
+	if (!skb) {
+		unix_state_lock(sk);
+		/* Signal EOF on disconnected non-blocking SEQPACKET socket. */
+		if (sk->sk_type == SOCK_SEQPACKET && err == -EAGAIN &&
+		    (sk->sk_shutdown & RCV_SHUTDOWN))
+			err = 0;
+		unix_state_unlock(sk);
 		goto out_unlock;
+	}
 
 	wake_up_interruptible(&u->peer_wait);
 
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index dfacb9c..7775488 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -371,7 +371,7 @@ int __xfrm_state_delete(struct xfrm_state *x)
 		 * The xfrm_state_alloc call gives a reference, and that
 		 * is what we are dropping here.
 		 */
-		__xfrm_state_put(x);
+		xfrm_state_put(x);
 		err = 0;
 	}
 
