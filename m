Return-Path: <linux-kernel-owner+w=401wt.eu-S1758815AbXJKVN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758815AbXJKVN2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 17:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755726AbXJKVNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 17:13:19 -0400
Received: from havoc.gtf.org ([69.61.125.42]:59609 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755683AbXJKVNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 17:13:18 -0400
Date: Thu, 11 Oct 2007 17:13:17 -0400
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] libata: struct pci_dev cleanups
Message-ID: <20071011211317.GA30328@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Just checked this into libata-dev.git#upstream...

commit d8904454530561bab51c369fee06e093e0b5a8d4
Author: Jeff Garzik <jeff@garzik.org>
Date:   Thu Oct 11 17:12:35 2007 -0400

    [libata] struct pci_dev related cleanups
    
    * remove pointless pci_dev_to_dev() wrapper.  Just directly reference
      the embedded struct device like everyone else does.
    
    * pata_cs5520: delete cs5520_remove_one(), it was a duplicate of
      ata_pci_remove_one()
    
    * linux/libata.h: don't bother including linux/pci.h, we don't need it.
      Simply declare 'struct pci_dev' and assume interested parties will
      include the header, as they should be doing anyway.
    
    * linux/libata.h: consolidate all CONFIG_PCI declarations into a
      single location in the header.
    
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

 drivers/ata/libata-core.c |    2 +-
 drivers/ata/libata-eh.c   |    1 +
 drivers/ata/pata_cs5520.c |   20 +-------------------
 include/linux/libata.h    |   33 ++++++++++++++-------------------
 4 files changed, 17 insertions(+), 39 deletions(-)

d8904454530561bab51c369fee06e093e0b5a8d4
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index ce8ccb4..b05384a 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -7007,7 +7007,7 @@ void ata_std_ports(struct ata_ioports *ioaddr)
  */
 void ata_pci_remove_one(struct pci_dev *pdev)
 {
-	struct device *dev = pci_dev_to_dev(pdev);
+	struct device *dev = &pdev->dev;
 	struct ata_host *host = dev_get_drvdata(dev);
 
 	ata_host_detach(host);
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 5a2b2af..2eaa39f 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -33,6 +33,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/pci.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_eh.h>
diff --git a/drivers/ata/pata_cs5520.c b/drivers/ata/pata_cs5520.c
index ff1eb84..33f7f08 100644
--- a/drivers/ata/pata_cs5520.c
+++ b/drivers/ata/pata_cs5520.c
@@ -299,24 +299,6 @@ static int __devinit cs5520_init_one(struct pci_dev *pdev, const struct pci_devi
 	return ata_host_register(host, &cs5520_sht);
 }
 
-/**
- *	cs5520_remove_one	-	device unload
- *	@pdev: PCI device being removed
- *
- *	Handle an unplug/unload event for a PCI device. Unload the
- *	PCI driver but do not use the default handler as we manage
- *	resources ourself and *MUST NOT* disable the device as it has
- *	other functions.
- */
-
-static void __devexit cs5520_remove_one(struct pci_dev *pdev)
-{
-	struct device *dev = pci_dev_to_dev(pdev);
-	struct ata_host *host = dev_get_drvdata(dev);
-
-	ata_host_detach(host);
-}
-
 #ifdef CONFIG_PM
 /**
  *	cs5520_reinit_one	-	device resume
@@ -373,7 +355,7 @@ static struct pci_driver cs5520_pci_driver = {
 	.name 		= DRV_NAME,
 	.id_table	= pata_cs5520,
 	.probe 		= cs5520_init_one,
-	.remove		= cs5520_remove_one,
+	.remove		= ata_pci_remove_one,
 #ifdef CONFIG_PM
 	.suspend	= cs5520_pci_device_suspend,
 	.resume		= cs5520_reinit_one,
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 2439f1f..229a9ff 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -28,7 +28,6 @@
 
 #include <linux/delay.h>
 #include <linux/interrupt.h>
-#include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <asm/scatterlist.h>
 #include <linux/io.h>
@@ -107,12 +106,6 @@ static inline u32 ata_msg_init(int dval, int default_msg_enable_bits)
 /* defines only for the constants which don't work well as enums */
 #define ATA_TAG_POISON		0xfafbfcfdU
 
-/* move to PCI layer? */
-static inline struct device *pci_dev_to_dev(struct pci_dev *pdev)
-{
-	return &pdev->dev;
-}
-
 enum {
 	/* various global constants */
 	LIBATA_MAX_PRD		= ATA_MAX_PRD / 2,
@@ -766,18 +759,7 @@ extern int sata_std_hardreset(struct ata_link *link, unsigned int *class,
 extern void ata_std_postreset(struct ata_link *link, unsigned int *classes);
 extern void ata_port_disable(struct ata_port *);
 extern void ata_std_ports(struct ata_ioports *ioaddr);
-#ifdef CONFIG_PCI
-extern int ata_pci_init_one (struct pci_dev *pdev,
-			     const struct ata_port_info * const * ppi);
-extern void ata_pci_remove_one (struct pci_dev *pdev);
-#ifdef CONFIG_PM
-extern void ata_pci_device_do_suspend(struct pci_dev *pdev, pm_message_t mesg);
-extern int __must_check ata_pci_device_do_resume(struct pci_dev *pdev);
-extern int ata_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg);
-extern int ata_pci_device_resume(struct pci_dev *pdev);
-#endif
-extern int ata_pci_clear_simplex(struct pci_dev *pdev);
-#endif /* CONFIG_PCI */
+
 extern struct ata_host *ata_host_alloc(struct device *dev, int max_ports);
 extern struct ata_host *ata_host_alloc_pinfo(struct device *dev,
 			const struct ata_port_info * const * ppi, int n_ports);
@@ -935,6 +917,19 @@ static inline int ata_acpi_cbl_80wire(struct ata_port *ap) { return 0; }
 #endif
 
 #ifdef CONFIG_PCI
+struct pci_dev;
+
+extern int ata_pci_init_one (struct pci_dev *pdev,
+			     const struct ata_port_info * const * ppi);
+extern void ata_pci_remove_one (struct pci_dev *pdev);
+#ifdef CONFIG_PM
+extern void ata_pci_device_do_suspend(struct pci_dev *pdev, pm_message_t mesg);
+extern int __must_check ata_pci_device_do_resume(struct pci_dev *pdev);
+extern int ata_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg);
+extern int ata_pci_device_resume(struct pci_dev *pdev);
+#endif
+extern int ata_pci_clear_simplex(struct pci_dev *pdev);
+
 struct pci_bits {
 	unsigned int		reg;	/* PCI config register to read */
 	unsigned int		width;	/* 1 (8 bit), 2 (16 bit), 4 (32 bit) */
