Return-Path: <linux-kernel-owner+w=401wt.eu-S1760636AbZAMNvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760636AbZAMNvb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 08:51:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758079AbZAMNuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 08:50:00 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50462 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756553AbZAMNt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 08:49:56 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 7/7] PCI PCIe portdrv: Implement pm object
Date: Tue, 13 Jan 2009 14:48:41 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc1-rjw; KDE/4.1.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>
References: <200901131434.28340.rjw@sisk.pl>
In-Reply-To: <200901131434.28340.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901131448.41843.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Implement pm object for the PCI Express port driver in order to use
the new power management framework and reduce the code size.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/hotplug/pciehp_core.c |    4 +--
 drivers/pci/pcie/aer/aerdrv.c     |    6 -----
 drivers/pci/pcie/portdrv.h        |    4 +--
 drivers/pci/pcie/portdrv_core.c   |   14 +++++-------
 drivers/pci/pcie/portdrv_pci.c    |   43 ++++++++++++--------------------------
 include/linux/pcieport_if.h       |    2 -
 6 files changed, 25 insertions(+), 48 deletions(-)

Index: linux-2.6/drivers/pci/pcie/portdrv_pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/portdrv_pci.c
+++ linux-2.6/drivers/pci/pcie/portdrv_pci.c
@@ -44,33 +44,21 @@ static int pcie_portdrv_restore_config(s
 }
 
 #ifdef CONFIG_PM
-static int pcie_portdrv_suspend(struct pci_dev *dev, pm_message_t state)
-{
-	return pcie_port_device_suspend(dev, state);
-
-}
+static struct dev_pm_ops pcie_portdrv_pm_ops = {
+	.suspend = pcie_port_device_suspend,
+	.resume = pcie_port_device_resume,
+	.freeze = pcie_port_device_suspend,
+	.thaw = pcie_port_device_resume,
+	.poweroff = pcie_port_device_suspend,
+	.restore = pcie_port_device_resume,
+};
 
-static int pcie_portdrv_suspend_late(struct pci_dev *dev, pm_message_t state)
-{
-	return pci_save_state(dev);
-}
+#define PCIE_PORTDRV_PM_OPS	(&pcie_portdrv_pm_ops)
 
-static int pcie_portdrv_resume_early(struct pci_dev *dev)
-{
-	return pci_restore_state(dev);
-}
+#else /* !PM */
 
-static int pcie_portdrv_resume(struct pci_dev *dev)
-{
-	pcie_portdrv_restore_config(dev);
-	return pcie_port_device_resume(dev);
-}
-#else
-#define pcie_portdrv_suspend NULL
-#define pcie_portdrv_suspend_late NULL
-#define pcie_portdrv_resume_early NULL
-#define pcie_portdrv_resume NULL
-#endif
+#define PCIE_PORTDRV_PM_OPS	NULL
+#endif /* !PM */
 
 /*
  * pcie_portdrv_probe - Probe PCI-Express port devices
@@ -281,12 +269,9 @@ static struct pci_driver pcie_portdriver
 	.probe		= pcie_portdrv_probe,
 	.remove		= pcie_portdrv_remove,
 
-	.suspend	= pcie_portdrv_suspend,
-	.suspend_late	= pcie_portdrv_suspend_late,
-	.resume_early	= pcie_portdrv_resume_early,
-	.resume		= pcie_portdrv_resume,
-
 	.err_handler 	= &pcie_portdrv_err_handler,
+
+	.driver.pm 	= PCIE_PORTDRV_PM_OPS,
 };
 
 static int __init pcie_portdrv_init(void)
Index: linux-2.6/drivers/pci/pcie/portdrv.h
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/portdrv.h
+++ linux-2.6/drivers/pci/pcie/portdrv.h
@@ -32,8 +32,8 @@ extern struct bus_type pcie_port_bus_typ
 extern int pcie_port_device_probe(struct pci_dev *dev);
 extern int pcie_port_device_register(struct pci_dev *dev);
 #ifdef CONFIG_PM
-extern int pcie_port_device_suspend(struct pci_dev *dev, pm_message_t state);
-extern int pcie_port_device_resume(struct pci_dev *dev);
+extern int pcie_port_device_suspend(struct device *dev);
+extern int pcie_port_device_resume(struct device *dev);
 #endif
 extern void pcie_port_device_remove(struct pci_dev *dev);
 extern int __must_check pcie_port_bus_register(void);
Index: linux-2.6/drivers/pci/pcie/portdrv_core.c
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/portdrv_core.c
+++ linux-2.6/drivers/pci/pcie/portdrv_core.c
@@ -282,13 +282,12 @@ int pcie_port_device_register(struct pci
 static int suspend_iter(struct device *dev, void *data)
 {
 	struct pcie_port_service_driver *service_driver;
-	pm_message_t state = * (pm_message_t *) data;
 
  	if ((dev->bus == &pcie_port_bus_type) &&
  	    (dev->driver)) {
  		service_driver = to_service_driver(dev->driver);
  		if (service_driver->suspend)
- 			service_driver->suspend(to_pcie_device(dev), state);
+ 			service_driver->suspend(to_pcie_device(dev));
   	}
 	return 0;
 }
@@ -296,11 +295,10 @@ static int suspend_iter(struct device *d
 /**
  * pcie_port_device_suspend - suspend port services associated with a PCIe port
  * @dev: PCI Express port to handle
- * @state: Representation of system power management transition in progress
  */
-int pcie_port_device_suspend(struct pci_dev *dev, pm_message_t state)
+int pcie_port_device_suspend(struct device *dev)
 {
-	return device_for_each_child(&dev->dev, &state, suspend_iter);
+	return device_for_each_child(dev, NULL, suspend_iter);
 }
 
 static int resume_iter(struct device *dev, void *data)
@@ -320,11 +318,11 @@ static int resume_iter(struct device *de
  * pcie_port_device_suspend - resume port services associated with a PCIe port
  * @dev: PCI Express port to handle
  */
-int pcie_port_device_resume(struct pci_dev *dev)
+int pcie_port_device_resume(struct device *dev)
 {
-	return device_for_each_child(&dev->dev, NULL, resume_iter);
+	return device_for_each_child(dev, NULL, resume_iter);
 }
-#endif
+#endif /* PM */
 
 static int remove_iter(struct device *dev, void *data)
 {
Index: linux-2.6/include/linux/pcieport_if.h
===================================================================
--- linux-2.6.orig/include/linux/pcieport_if.h
+++ linux-2.6/include/linux/pcieport_if.h
@@ -55,7 +55,7 @@ struct pcie_port_service_driver {
 	const char *name;
 	int (*probe) (struct pcie_device *dev);
 	void (*remove) (struct pcie_device *dev);
-	int (*suspend) (struct pcie_device *dev, pm_message_t state);
+	int (*suspend) (struct pcie_device *dev);
 	int (*resume) (struct pcie_device *dev);
 
 	/* Service Error Recovery Handler */
Index: linux-2.6/drivers/pci/pcie/aer/aerdrv.c
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/aer/aerdrv.c
+++ linux-2.6/drivers/pci/pcie/aer/aerdrv.c
@@ -40,9 +40,6 @@ MODULE_LICENSE("GPL");
 
 static int __devinit aer_probe (struct pcie_device *dev);
 static void aer_remove(struct pcie_device *dev);
-static int aer_suspend(struct pcie_device *dev, pm_message_t state)
-{return 0;}
-static int aer_resume(struct pcie_device *dev) {return 0;}
 static pci_ers_result_t aer_error_detected(struct pci_dev *dev,
 	enum pci_channel_state error);
 static void aer_error_resume(struct pci_dev *dev);
@@ -61,9 +58,6 @@ static struct pcie_port_service_driver a
 	.probe		= aer_probe,
 	.remove		= aer_remove,
 
-	.suspend	= aer_suspend,
-	.resume		= aer_resume,
-
 	.err_handler	= &aer_error_handlers,
 
 	.reset_link	= aer_root_reset,
Index: linux-2.6/drivers/pci/hotplug/pciehp_core.c
===================================================================
--- linux-2.6.orig/drivers/pci/hotplug/pciehp_core.c
+++ linux-2.6/drivers/pci/hotplug/pciehp_core.c
@@ -466,7 +466,7 @@ static void pciehp_remove (struct pcie_d
 }
 
 #ifdef CONFIG_PM
-static int pciehp_suspend (struct pcie_device *dev, pm_message_t state)
+static int pciehp_suspend (struct pcie_device *dev)
 {
 	dev_info(&dev->device, "%s ENTRY\n", __func__);
 	return 0;
@@ -494,7 +494,7 @@ static int pciehp_resume (struct pcie_de
 	}
 	return 0;
 }
-#endif
+#endif /* PM */
 
 static struct pcie_port_service_driver hpdriver_portdrv = {
 	.name		= PCIE_MODULE_NAME,

