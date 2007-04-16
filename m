Return-Path: <linux-kernel-owner+w=401wt.eu-S1030900AbXDPRSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030900AbXDPRSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 13:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030901AbXDPRSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 13:18:40 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:20172 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030900AbXDPRSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 13:18:39 -0400
Date: Mon, 16 Apr 2007 10:21:00 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>, gregkh <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Bart <bzolnier@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [RFC/PATCH -mm] add pci_try_set_mwi
Message-Id: <20070416102100.fbb78497.randy.dunlap@oracle.com>
In-Reply-To: <20070405142001.6610749a.akpm@linux-foundation.org>
References: <20070404213704.224128ec.randy.dunlap@oracle.com>
	<20070405121302.1206e748@the-village.bc.nu>
	<20070405130330.f5f8a2a6.akpm@linux-foundation.org>
	<20070405211609.5263d627@the-village.bc.nu>
	<20070405142001.6610749a.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[resend, chaning linux-ide to lkml]

On Thu, 5 Apr 2007 14:20:01 -0700 Andrew Morton wrote:

> hm. Well, what to do?
> 
> How about we prevail upon Randy to:
> 
> - rename pci_set_mwi() to pci_try_set_mwi()
> 
> - make it return 0 on success, 1 if the "try" failed
> 
> - make it return -EFOO on error (presently unimplemented)
> 
> - review callers
> 
> - remove __must_check
> 
> ?



From: Randy Dunlap <randy.dunlap@oracle.com>

As suggested by Andrew, add pci_try_set_mwi(), which does not require
return-value checking.

- add pci_try_set_mwi() without __must_check
- make it return 0 on success, errno if the "try" failed or error
- review callers

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/pci.txt                          |    5 +++-
 drivers/ata/pata_cs5530.c                      |    2 -
 drivers/ide/pci/cs5530.c                       |    2 -
 drivers/net/cassini.c                          |    4 +--
 drivers/net/starfire.c                         |    2 -
 drivers/net/tulip/tulip_core.c                 |    2 -
 drivers/net/wireless/mac80211/p54/prism54pci.c |    2 -
 drivers/net/wireless/prism54/islpci_hotplug.c  |    3 --
 drivers/pci/pci.c                              |   28 +++++++++++++++++++++----
 drivers/scsi/lpfc/lpfc_init.c                  |    5 ----
 drivers/usb/gadget/net2280.c                   |    2 -
 include/linux/pci.h                            |    1 
 12 files changed, 39 insertions(+), 19 deletions(-)

--- linux-2.6.21-rc6-mm1.orig/include/linux/pci.h
+++ linux-2.6.21-rc6-mm1/include/linux/pci.h
@@ -547,6 +547,7 @@ void pci_set_master(struct pci_dev *dev)
 int pci_set_pcie_reset_state(struct pci_dev *dev, enum pcie_reset_state state);
 #define HAVE_PCI_SET_MWI
 int __must_check pci_set_mwi(struct pci_dev *dev);
+int pci_try_set_mwi(struct pci_dev *dev);
 void pci_clear_mwi(struct pci_dev *dev);
 void pci_intx(struct pci_dev *dev, int enable);
 void pci_msi_off(struct pci_dev *dev);
--- linux-2.6.21-rc6-mm1.orig/drivers/pci/pci.c
+++ linux-2.6.21-rc6-mm1/drivers/pci/pci.c
@@ -1162,6 +1162,11 @@ int pci_set_mwi(struct pci_dev *dev)
 	return 0;
 }
 
+int pci_try_set_mwi(struct pci_dev *dev)
+{
+	return 0;
+}
+
 void pci_clear_mwi(struct pci_dev *dev)
 {
 }
@@ -1218,9 +1223,7 @@ pci_set_cacheline_size(struct pci_dev *d
  * pci_set_mwi - enables memory-write-invalidate PCI transaction
  * @dev: the PCI device for which MWI is enabled
  *
- * Enables the Memory-Write-Invalidate transaction in %PCI_COMMAND,
- * and then calls @pcibios_set_mwi to do the needed arch specific
- * operations or a generic mwi-prep function.
+ * Enables the Memory-Write-Invalidate transaction in %PCI_COMMAND.
  *
  * RETURNS: An appropriate -ERRNO error value on error, or zero for success.
  */
@@ -1236,7 +1239,8 @@ pci_set_mwi(struct pci_dev *dev)
 
 	pci_read_config_word(dev, PCI_COMMAND, &cmd);
 	if (! (cmd & PCI_COMMAND_INVALIDATE)) {
-		pr_debug("PCI: Enabling Mem-Wr-Inval for device %s\n", pci_name(dev));
+		pr_debug("PCI: Enabling Mem-Wr-Inval for device %s\n",
+			pci_name(dev));
 		cmd |= PCI_COMMAND_INVALIDATE;
 		pci_write_config_word(dev, PCI_COMMAND, cmd);
 	}
@@ -1245,6 +1249,21 @@ pci_set_mwi(struct pci_dev *dev)
 }
 
 /**
+ * pci_try_set_mwi - enables memory-write-invalidate PCI transaction
+ * @dev: the PCI device for which MWI is enabled
+ *
+ * Enables the Memory-Write-Invalidate transaction in %PCI_COMMAND.
+ * Callers are not required to check the return value.
+ *
+ * RETURNS: An appropriate -ERRNO error value on error, or zero for success.
+ */
+int pci_try_set_mwi(struct pci_dev *dev)
+{
+	int rc = pci_set_mwi(dev);
+	return rc;
+}
+
+/**
  * pci_clear_mwi - disables Memory-Write-Invalidate for device dev
  * @dev: the PCI device to disable
  *
@@ -1418,6 +1437,7 @@ EXPORT_SYMBOL(pci_release_selected_regio
 EXPORT_SYMBOL(pci_request_selected_regions);
 EXPORT_SYMBOL(pci_set_master);
 EXPORT_SYMBOL(pci_set_mwi);
+EXPORT_SYMBOL(pci_try_set_mwi);
 EXPORT_SYMBOL(pci_clear_mwi);
 EXPORT_SYMBOL_GPL(pci_intx);
 EXPORT_SYMBOL(pci_set_dma_mask);
--- linux-2.6.21-rc6-mm1.orig/drivers/ata/pata_cs5530.c
+++ linux-2.6.21-rc6-mm1/drivers/ata/pata_cs5530.c
@@ -270,7 +270,7 @@ static int cs5530_init_chip(void)
 	}
 
 	pci_set_master(cs5530_0);
-	pci_set_mwi(cs5530_0);
+	pci_try_set_mwi(cs5530_0);
 
 	/*
 	 * Set PCI CacheLineSize to 16-bytes:
--- linux-2.6.21-rc6-mm1.orig/drivers/ide/pci/cs5530.c
+++ linux-2.6.21-rc6-mm1/drivers/ide/pci/cs5530.c
@@ -236,7 +236,7 @@ static unsigned int __devinit init_chips
 	 */
 
 	pci_set_master(cs5530_0);
-	pci_set_mwi(cs5530_0);
+	pci_try_set_mwi(cs5530_0);
 
 	/*
 	 * Set PCI CacheLineSize to 16-bytes:
--- linux-2.6.21-rc6-mm1.orig/drivers/usb/gadget/net2280.c
+++ linux-2.6.21-rc6-mm1/drivers/usb/gadget/net2280.c
@@ -2964,7 +2964,7 @@ static int net2280_probe (struct pci_dev
 			, &dev->pci->pcimstctl);
 	/* erratum 0115 shouldn't appear: Linux inits PCI_LATENCY_TIMER */
 	pci_set_master (pdev);
-	pci_set_mwi (pdev);
+	pci_try_set_mwi (pdev);
 
 	/* ... also flushes any posted pci writes */
 	dev->chiprev = get_idx_reg (dev->regs, REG_CHIPREV) & 0xffff;
--- linux-2.6.21-rc6-mm1.orig/drivers/scsi/lpfc/lpfc_init.c
+++ linux-2.6.21-rc6-mm1/drivers/scsi/lpfc/lpfc_init.c
@@ -1494,10 +1494,7 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 
 
 	pci_set_master(pdev);
-	retval = pci_set_mwi(pdev);
-	if (retval)
-		dev_printk(KERN_WARNING, &pdev->dev,
-			   "Warning: pci_set_mwi returned %d\n", retval);
+	pci_try_set_mwi(pdev);
 
 	if (pci_set_dma_mask(phba->pcidev, DMA_64BIT_MASK) != 0)
 		if (pci_set_dma_mask(phba->pcidev, DMA_32BIT_MASK) != 0)
--- linux-2.6.21-rc6-mm1.orig/drivers/net/wireless/prism54/islpci_hotplug.c
+++ linux-2.6.21-rc6-mm1/drivers/net/wireless/prism54/islpci_hotplug.c
@@ -167,8 +167,7 @@ prism54_probe(struct pci_dev *pdev, cons
 	pci_set_master(pdev);
 
 	/* enable MWI */
-	if (!pci_set_mwi(pdev))
-		printk(KERN_INFO "%s: pci_set_mwi(pdev) succeeded\n", DRV_NAME);
+	pci_try_set_mwi(pdev);
 
 	/* setup the network device interface and its structure */
 	if (!(ndev = islpci_setup(pdev))) {
--- linux-2.6.21-rc6-mm1.orig/drivers/net/cassini.c
+++ linux-2.6.21-rc6-mm1/drivers/net/cassini.c
@@ -4919,10 +4919,10 @@ static int __devinit cas_init_one(struct
 	pci_cmd &= ~PCI_COMMAND_SERR;
 	pci_cmd |= PCI_COMMAND_PARITY;
 	pci_write_config_word(pdev, PCI_COMMAND, pci_cmd);
-	pci_set_mwi(pdev);
+	pci_try_set_mwi(pdev);
 	/*
 	 * On some architectures, the default cache line size set
-	 * by pci_set_mwi reduces perforamnce.  We have to increase
+	 * by pci_set_mwi reduces performance.  We have to increase
 	 * it for this case.  To start, we'll print some configuration
 	 * data.
 	 */
--- linux-2.6.21-rc6-mm1.orig/drivers/net/starfire.c
+++ linux-2.6.21-rc6-mm1/drivers/net/starfire.c
@@ -740,7 +740,7 @@ static int __devinit starfire_init_one(s
 	pci_set_master(pdev);
 
 	/* enable MWI -- it vastly improves Rx performance on sparc64 */
-	pci_set_mwi(pdev);
+	pci_try_set_mwi(pdev);
 
 #ifdef ZEROCOPY
 	/* Starfire can do TCP/UDP checksumming */
--- linux-2.6.21-rc6-mm1.orig/drivers/net/tulip/tulip_core.c
+++ linux-2.6.21-rc6-mm1/drivers/net/tulip/tulip_core.c
@@ -1155,7 +1155,7 @@ static void __devinit tulip_mwi_config (
 	/* set or disable MWI in the standard PCI command bit.
 	 * Check for the case where  mwi is desired but not available
 	 */
-	if (csr0 & MWI)	pci_set_mwi(pdev);
+	if (csr0 & MWI)	pci_try_set_mwi(pdev);
 	else		pci_clear_mwi(pdev);
 
 	/* read result from hardware (in case bit refused to enable) */
--- linux-2.6.21-rc6-mm1.orig/drivers/net/wireless/mac80211/p54/prism54pci.c
+++ linux-2.6.21-rc6-mm1/drivers/net/wireless/mac80211/p54/prism54pci.c
@@ -539,7 +539,7 @@ static int __devinit p54p_probe(struct p
 	}
 
 	pci_set_master(pdev);
-	pci_set_mwi(pdev);
+	pci_try_set_mwi(pdev);
 
 	pci_write_config_byte(pdev, 0x40, 0);
 	pci_write_config_byte(pdev, 0x41, 0);
--- linux-2.6.21-rc6-mm1.orig/Documentation/pci.txt
+++ linux-2.6.21-rc6-mm1/Documentation/pci.txt
@@ -299,7 +299,10 @@ If the PCI device can use the PCI Memory
 call pci_set_mwi().  This enables the PCI_COMMAND bit for Mem-Wr-Inval
 and also ensures that the cache line size register is set correctly.
 Check the return value of pci_set_mwi() as not all architectures
-or chip-sets may support Memory-Write-Invalidate.
+or chip-sets may support Memory-Write-Invalidate.  Alternatively,
+if Mem-Wr-Inval would be nice to have but is not required, call
+pci_try_set_mwi() to have the system do its best effort at enabling
+Mem-Wr-Inval.
 
 
 3.2 Request MMIO/IOP resources
