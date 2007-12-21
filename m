Return-Path: <linux-kernel-owner+w=401wt.eu-S1765433AbXLUDCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765433AbXLUDCj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 22:02:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763169AbXLUDCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 22:02:16 -0500
Received: from mail.suse.de ([195.135.220.2]:53835 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763829AbXLUDCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 22:02:15 -0500
Subject: patch pci-remove-users-of-pci_enable_device_bars.patch added to gregkh-2.6 tree
To: benh@kernel.crashing.org, alan@redhat.com, bzolnier@gmail.com,
       greg@kroah.com, gregkh@suse.de, ink@jurassic.park.msu.ru,
       james.smart@emulex.com, linux-driver@qlogic.com,
       linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Thu, 20 Dec 2007 18:59:22 -0800
In-Reply-To: <20071220042811.D312DDDEE6@ozlabs.org>
Message-ID: <11982059621055@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: PCI: Remove users of pci_enable_device_bars()

to my gregkh-2.6 tree.  Its filename is

     pci-remove-users-of-pci_enable_device_bars.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From benh@ozlabs.org Wed Dec 19 20:30:44 2007
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Thu, 20 Dec 2007 15:28:09 +1100
Subject: PCI: Remove users of pci_enable_device_bars()
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, <linux-kernel@vger.kernel.org>, <ink@jurassic.park.msu.ru>, Alan Cox <alan@redhat.com>, <james.smart@emulex.com>, <linux-driver@qlogic.com>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Message-ID: <20071220042811.D312DDDEE6@ozlabs.org>


This patch converts users of pci_enable_device_bars() to the new
pci_enable_device_{io,mem} interface.

The new API fits nicely, except maybe for the QLA case where a bit of
code re-organization might be a good idea but I prefer sticking to the
simple patch as I don't have hardware to test on.

I'll also need some feedback on the cs5520 change.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/pata_cs5520.c       |    2 +-
 drivers/i2c/busses/scx200_acb.c |    2 +-
 drivers/ide/pci/cs5520.c        |   10 ++++++++--
 drivers/ide/setup-pci.c         |    6 ++++--
 drivers/scsi/lpfc/lpfc_init.c   |    3 +--
 drivers/scsi/qla2xxx/qla_os.c   |   12 +++++++++---
 6 files changed, 24 insertions(+), 11 deletions(-)

--- a/drivers/ata/pata_cs5520.c
+++ b/drivers/ata/pata_cs5520.c
@@ -229,7 +229,7 @@ static int __devinit cs5520_init_one(str
 		return -ENOMEM;
 
 	/* Perform set up for DMA */
-	if (pci_enable_device_bars(pdev, 1<<2)) {
+	if (pci_enable_device_io(pdev)) {
 		printk(KERN_ERR DRV_NAME ": unable to configure BAR2.\n");
 		return -ENODEV;
 	}
--- a/drivers/i2c/busses/scx200_acb.c
+++ b/drivers/i2c/busses/scx200_acb.c
@@ -492,7 +492,7 @@ static __init int scx200_create_pci(cons
 	iface->pdev = pdev;
 	iface->bar = bar;
 
-	rc = pci_enable_device_bars(iface->pdev, 1 << iface->bar);
+	rc = pci_enable_device_io(iface->pdev);
 	if (rc)
 		goto errout_free;
 
--- a/drivers/ide/pci/cs5520.c
+++ b/drivers/ide/pci/cs5520.c
@@ -160,8 +160,14 @@ static int __devinit cs5520_init_one(str
 	ide_setup_pci_noise(dev, d);
 
 	/* We must not grab the entire device, it has 'ISA' space in its
-	   BARS too and we will freak out other bits of the kernel */
-	if (pci_enable_device_bars(dev, 1<<2)) {
+	 * BARS too and we will freak out other bits of the kernel
+	 *
+	 * pci_enable_device_bars() is going away. I replaced it with
+	 * IO only enable for now but I'll need confirmation this is
+	 * allright for that device. If not, it will need some kind of
+	 * quirk. --BenH.
+	 */
+	if (pci_enable_device_io(dev)) {
 		printk(KERN_WARNING "%s: Unable to enable 55x0.\n", d->name);
 		return -ENODEV;
 	}
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -236,7 +236,9 @@ EXPORT_SYMBOL_GPL(ide_setup_pci_noise);
  *	@d: IDE port info
  *
  *	Enable the IDE PCI device. We attempt to enable the device in full
- *	but if that fails then we only need BAR4 so we will enable that.
+ *	but if that fails then we only need IO space. The PCI code should
+ *	have setup the proper resources for us already for controllers in
+ *	legacy mode.
  *	
  *	Returns zero on success or an error code
  */
@@ -246,7 +248,7 @@ static int ide_pci_enable(struct pci_dev
 	int ret;
 
 	if (pci_enable_device(dev)) {
-		ret = pci_enable_device_bars(dev, 1 << 4);
+		ret = pci_enable_device_io(dev);
 		if (ret < 0) {
 			printk(KERN_WARNING "%s: (ide_setup_pci_device:) "
 				"Could not enable device.\n", d->name);
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -2100,10 +2100,9 @@ static pci_ers_result_t lpfc_io_slot_res
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
 	struct lpfc_sli *psli = &phba->sli;
-	int bars = pci_select_bars(pdev, IORESOURCE_MEM);
 
 	dev_printk(KERN_INFO, &pdev->dev, "recovering from a slot reset.\n");
-	if (pci_enable_device_bars(pdev, bars)) {
+	if (pci_enable_device_mem(pdev)) {
 		printk(KERN_ERR "lpfc: Cannot re-enable "
 			"PCI device after reset.\n");
 		return PCI_ERS_RESULT_DISCONNECT;
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1583,7 +1583,7 @@ qla2x00_probe_one(struct pci_dev *pdev, 
 	char pci_info[30];
 	char fw_str[30];
 	struct scsi_host_template *sht;
-	int bars;
+	int bars, mem_only = 0;
 
 	bars = pci_select_bars(pdev, IORESOURCE_MEM | IORESOURCE_IO);
 	sht = &qla2x00_driver_template;
@@ -1594,10 +1594,16 @@ qla2x00_probe_one(struct pci_dev *pdev, 
 	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2532) {
 		bars = pci_select_bars(pdev, IORESOURCE_MEM);
 		sht = &qla24xx_driver_template;
+		mem_only = 1;
 	}
 
-	if (pci_enable_device_bars(pdev, bars))
-		goto probe_out;
+	if (mem_only) {
+		if (pci_enable_device_mem(pdev))
+			goto probe_out;
+	} else {
+		if (pci_enable_device(pdev))
+			goto probe_out;
+	}
 
 	if (pci_find_aer_capability(pdev))
 		if (pci_enable_pcie_error_reporting(pdev))


Patches currently in gregkh-2.6 which might be from benh@kernel.crashing.org are

bad/battery-class-driver.patch
driver/adb-convert-from-class_device-to-device.patch
driver/kobject-convert-hvc_console-to-use-kref-not-kobject.patch
driver/kobject-convert-hvcs-to-use-kref-not-kobject.patch
driver/kobject-convert-icom-to-use-kref-not-kobject.patch
pci/pci-fix-bus-resource-assignment-on-32-bits-with-64b-resources.patch
pci/pci-fix-warning-in-setup-res.c-on-32-bit-platforms-with-64-bit-resources.patch
pci/pci-add-pci_enable_device_-io-mem-intefaces.patch
pci/pci-remove-pci_enable_device_bars.patch
pci/pci-remove-users-of-pci_enable_device_bars.patch
usb/usb-remove-ohci-useless-masking-unmasking-of-wdh-interrupt.patch
