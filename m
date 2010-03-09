Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab0CIQCQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 11:02:16 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:20357 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198Ab0CIQCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 11:02:13 -0500
X-IronPort-AV: E=Sophos;i="4.49,608,1262563200"; 
   d="scan'208";a="9859535"
Date: Tue, 9 Mar 2010 16:06:17 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: [PATCH 4 of 5] Linux pvops: pci passthrough support
Message-ID: <alpine.DEB.2.00.1003091550340.26495@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this patch makes few changes to the xen pci functions to handle pirq
remapping of interrupts belonging to pci passthrough devices:

- disable pcifront and MSIs when running on HVM
the former is not meant to be used while the latter are not supported
yet

- change xen_allocate_pirq to take the pirq as a parameter
this is necessary because with pt devices the pirq returned by
PHYSDEVOP_map_pirq may be different from the one we passed as an
argument


Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

---

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index e138053..6a857eb 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -25,7 +25,7 @@ static int xen_pcifront_enable_irq(struct pci_dev *dev)
 	if (dev->irq < 0)
 		return -EINVAL;
 
-	rc = xen_allocate_pirq(dev->irq, 0, "pcifront");
+	rc = xen_allocate_pirq(dev->irq, dev->irq, 0, "pcifront");
 	if (rc < 0) {
 		dev_warn(&dev->dev, "Xen PCI IRQ: %d, failed to register:%d\n",
 			 dev->irq, rc);
diff --git a/arch/x86/xen/pci.c b/arch/x86/xen/pci.c
index ac7e6bd..84d4904 100644
--- a/arch/x86/xen/pci.c
+++ b/arch/x86/xen/pci.c
@@ -37,36 +37,34 @@ int xen_register_gsi(u32 gsi, int triggering, int polarity)
 		name = "ioapic-level";
 	}
 
-	irq = xen_allocate_pirq(gsi, shareable, name);
-
-	printk(KERN_DEBUG "xen: --> irq=%d\n", irq);
-
-	if (irq >= 0) {
-		setup_gsi.gsi = gsi;
-		setup_gsi.triggering = (triggering == ACPI_EDGE_SENSITIVE ?
-				0 : 1);
-		setup_gsi.polarity = (polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
-
-		rc = HYPERVISOR_physdev_op(PHYSDEVOP_setup_gsi, &setup_gsi);
-		if (rc == -EEXIST)
-			printk(KERN_INFO "Already setup the GSI :%d\n", gsi);
-		else if (rc) {
-			printk(KERN_ERR "Failed to setup GSI :%d, err_code:%d\n",
-					gsi, rc);
-			BUG();
-		}
-
-		map_irq.domid = DOMID_SELF;
-		map_irq.type = MAP_PIRQ_TYPE_GSI;
-		map_irq.index = gsi;
-		map_irq.pirq = irq;
-
-		rc = HYPERVISOR_physdev_op(PHYSDEVOP_map_pirq, &map_irq);
-		if (rc) {
-			printk(KERN_WARNING "xen map irq failed %d\n", rc);
-			irq = -1;
-		}
+	setup_gsi.gsi = gsi;
+	setup_gsi.triggering = (triggering == ACPI_EDGE_SENSITIVE ?
+			0 : 1);
+	setup_gsi.polarity = (polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
+
+	rc = HYPERVISOR_physdev_op(PHYSDEVOP_setup_gsi, &setup_gsi);
+	if (rc == -EEXIST)
+		printk(KERN_INFO "Already setup the GSI :%d\n", gsi);
+	else if (rc) {
+		printk(KERN_ERR "Failed to setup GSI :%d, err_code:%d\n",
+				gsi, rc);
+		BUG();
 	}
+
+	map_irq.domid = DOMID_SELF;
+	map_irq.type = MAP_PIRQ_TYPE_GSI;
+	map_irq.index = gsi;
+	map_irq.pirq = gsi;
+
+	rc = HYPERVISOR_physdev_op(PHYSDEVOP_map_pirq, &map_irq);
+	if (rc) {
+		printk(KERN_WARNING "xen map irq failed %d\n", rc);
+		return -1;
+	}
+	irq = xen_allocate_pirq(map_irq.pirq, gsi, shareable, name);
+
+	printk(KERN_DEBUG "xen: --> irq=%d, pirq=%d\n", irq, map_irq.pirq);
+
 	return irq;
 }
 
@@ -76,7 +74,7 @@ void __init xen_setup_pirqs(void)
 
 	if (0 == nr_ioapics) {
 		for (irq = 0; irq < NR_IRQS_LEGACY; irq++)
-			xen_allocate_pirq(irq, 0, "xt-pic");
+			xen_allocate_pirq(irq, irq, 0, "xt-pic");
 		return;
 	}
 
@@ -100,6 +98,10 @@ int xen_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 	struct msi_desc *msidesc;
 	int *v;
 
+	/* PV on HVM domains do not support MSI at the moment */
+	if (xen_hvm_domain())
+		return -EINVAL;
+
 	v = kzalloc(sizeof(int) * min(1, nvec), GFP_KERNEL);
 	if (!v)
 		return -ENOMEM;
@@ -135,7 +137,7 @@ error:
 void xen_teardown_msi_dev(struct pci_dev *dev)
 {
 	/* Only do this when were are in non-privileged mode.*/
-	if (!xen_initial_domain()) {
+	if (!xen_initial_domain() && !xen_hvm_domain()) {
 		struct msi_desc *msidesc;
 
 		msidesc = list_entry(dev->msi_list.next, struct msi_desc, list);
diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
index cc3b51b..5f5c2fa 100644
--- a/drivers/pci/xen-pcifront.c
+++ b/drivers/pci/xen-pcifront.c
@@ -1116,7 +1116,7 @@ static struct xenbus_driver xenbus_pcifront_driver = {
 
 static int __init pcifront_init(void)
 {
-	if (!xen_domain())
+	if (!xen_domain() || xen_hvm_domain())
 		return -ENODEV;
 
 	return xenbus_register_frontend(&xenbus_pcifront_driver);
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 29a399d..21c0d8c 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -538,7 +538,7 @@ static int find_irq_by_gsi(unsigned gsi)
  * until the irq actually started up.  Return an
  * existing irq if we've already got one for the gsi.
  */
-int xen_allocate_pirq(unsigned gsi, int shareable, char *name)
+int xen_allocate_pirq(unsigned pirq, unsigned gsi, int shareable, char *name)
 {
 	int irq;
 
@@ -563,7 +563,7 @@ int xen_allocate_pirq(unsigned gsi, int shareable, char *name)
 	set_irq_chip_and_handler_name(irq, &xen_pirq_chip,
 				      handle_level_irq, name);
 
-	irq_info[irq] = mk_pirq_info(0, gsi);
+	irq_info[irq] = mk_pirq_info(0, pirq);
  	irq_info[irq].u.pirq.flags |= shareable ? PIRQ_SHAREABLE : 0;
 out:
 	spin_unlock(&irq_mapping_update_lock);
diff --git a/include/xen/events.h b/include/xen/events.h
index cbe3218..eccc87b 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -72,7 +72,7 @@ unsigned irq_from_evtchn(unsigned int evtchn);
 /* Allocate an irq for a physical interrupt, given a gsi.  "Legacy"
    GSIs are identity mapped; others are dynamically allocated as
    usual. */
-int xen_allocate_pirq(unsigned gsi, int shareable, char *name);
+int xen_allocate_pirq(unsigned pirq, unsigned gsi, int shareable, char *name);
 
 /* Return vector allocated to pirq */
 int xen_vector_from_irq(unsigned pirq);
