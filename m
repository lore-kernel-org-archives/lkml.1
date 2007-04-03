Return-Path: <linux-kernel-owner+w=401wt.eu-S1946006AbXDCWMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946006AbXDCWMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 18:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946011AbXDCWMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 18:12:17 -0400
Received: from smtp107.sbc.mail.mud.yahoo.com ([68.142.198.206]:27116 "HELO
	smtp107.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1946006AbXDCWMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 18:12:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=dGvt+IpXapeoBEpXTxbSNeBELv1NfzWQ1YnSIfNWe6rmYZYN3taWa+0+5r6ilOafnZ1lek36xLQ68PVb3twKtm6ZkG0YEkJoAo2nems70KQtBmAFyKlTIL6OmZX7mejkyRRPDQvjGgvnjmx4WUQRz0Jou1ijYreIRuW1NSganZ4=  ;
X-YMail-OSG: w_JzN9kVM1k8nGZkKtAKzq6p8Z6aV3JBiZv_rJpCcznF3FhR5ZDyQgzgiRzr3yOBMMEK5t_IKA--
From: David Brownell <david-b@pacbell.net>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.21-rc5-git] PNPACPI sets pnpdev->dev.archdata
Date: Tue, 3 Apr 2007 14:53:32 -0700
User-Agent: KMail/1.7.1
Cc: ambx1@neo.rr.com, Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200704031453.32674.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Teach PNPACPI how to hook up its devices to their ACPI nodes, so
that pnpdev->dev.archdata points to the parallel acpi device node.
Previously this only worked for PCI, leaving a notable hole.

Export "acpi_bus_type" so this can work.

Remove some extraneous whitespace.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

--- g26.orig/include/acpi/acpi_bus.h	2007-04-03 12:03:07.000000000 -0700
+++ g26/include/acpi/acpi_bus.h	2007-04-03 12:05:18.000000000 -0700
@@ -303,6 +303,9 @@ struct acpi_device {
 #define to_acpi_device(d)	container_of(d, struct acpi_device, dev)
 #define to_acpi_driver(d)	container_of(d, struct acpi_driver, drv)
 
+/* acpi_device.dev.bus == &acpi_bus_type */
+extern struct bus_type acpi_bus_type;
+
 /*
  * Events
  * ------
--- g26.orig/drivers/acpi/scan.c	2007-04-03 12:03:11.000000000 -0700
+++ g26/drivers/acpi/scan.c	2007-04-03 12:05:18.000000000 -0700
@@ -302,7 +302,7 @@ static void acpi_device_shutdown(struct 
 	return ;
 }
 
-static struct bus_type acpi_bus_type = {
+struct bus_type acpi_bus_type = {
 	.name		= "acpi",
 	.suspend	= acpi_device_suspend,
 	.resume		= acpi_device_resume,
--- g26.orig/drivers/pnp/pnpacpi/core.c	2007-04-03 12:03:07.000000000 -0700
+++ g26/drivers/pnp/pnpacpi/core.c	2007-04-03 14:38:27.000000000 -0700
@@ -3,7 +3,7 @@
  *
  * Copyright (c) 2004 Matthieu Castet <castet.matthieu@free.fr>
  * Copyright (c) 2004 Li Shaohua <shaohua.li@intel.com>
- * 
+ *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
  * Free Software Foundation; either version 2, or (at your option) any
@@ -18,7 +18,7 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
- 
+
 #include <linux/acpi.h>
 #include <linux/pnp.h>
 #include <acpi/acpi_bus.h>
@@ -82,7 +82,7 @@ static void __init pnpidacpi_to_pnpid(ch
 static int pnpacpi_get_resources(struct pnp_dev * dev, struct pnp_resource_table * res)
 {
 	acpi_status status;
-	status = pnpacpi_parse_allocated_resource((acpi_handle)dev->data, 
+	status = pnpacpi_parse_allocated_resource((acpi_handle)dev->data,
 		&dev->res);
 	return ACPI_FAILURE(status) ? -ENODEV : 0;
 }
@@ -112,9 +112,9 @@ static int pnpacpi_set_resources(struct 
 static int pnpacpi_disable_resources(struct pnp_dev *dev)
 {
 	acpi_status status;
-	
+
 	/* acpi_unregister_gsi(pnp_irq(dev, 0)); */
-	status = acpi_evaluate_object((acpi_handle)dev->data, 
+	status = acpi_evaluate_object((acpi_handle)dev->data,
 		"_DIS", NULL, NULL);
 	return ACPI_FAILURE(status) ? -ENODEV : 0;
 }
@@ -167,7 +167,7 @@ static int __init pnpacpi_add_device(str
 		strncpy(dev->name, acpi_device_bid(device), sizeof(dev->name));
 
 	dev->number = num;
-	
+
 	/* set the initial values for the PnP device */
 	dev_id = kzalloc(sizeof(struct pnp_id), GFP_KERNEL);
 	if (!dev_id)
@@ -185,14 +185,14 @@ static int __init pnpacpi_add_device(str
 	}
 
 	if(dev->capabilities & PNP_CONFIGURABLE) {
-		status = pnpacpi_parse_resource_option_data(device->handle, 
+		status = pnpacpi_parse_resource_option_data(device->handle,
 			dev);
 		if (ACPI_FAILURE(status) && (status != AE_NOT_FOUND)) {
 			pnp_err("PnPACPI: METHOD_NAME__PRS failure for %s", dev_id->id);
 			goto err1;
 		}
 	}
-	
+
 	/* parse compatible ids */
 	if (device->flags.compatible_ids) {
 		struct acpi_compatible_id_list *cid_list = device->pnp.cid_list;
@@ -236,6 +236,41 @@ static acpi_status __init pnpacpi_add_de
 	return AE_OK;
 }
 
+static int __init acpi_pnp_match(struct device *dev, void *_pnp)
+{
+	struct acpi_device	*acpi = to_acpi_device(dev);
+	struct pnp_dev		*pnp = _pnp;
+
+	/* true means it matched */
+	return acpi->flags.hardware_id
+		&& compare_pnp_id(pnp->id, acpi->pnp.hardware_id);
+}
+
+static int __init acpi_pnp_find_device(struct device *dev, acpi_handle *handle)
+{
+	struct device		*adev;
+	struct acpi_device	*acpi;
+
+	adev = bus_find_device(&acpi_bus_type, NULL,
+			to_pnp_dev(dev),
+			acpi_pnp_match);
+	if (!adev)
+		return -ENODEV;
+
+	acpi = to_acpi_device(adev);
+	*handle = acpi->handle;
+	put_device(adev);
+	return 0;
+}
+
+/* complete initialization of a PNPACPI device includes having
+ * pnpdev->dev.archdata.acpi_handle point to its ACPI sibling.
+ */
+static struct acpi_bus_type __initdata acpi_pnp_bus = {
+	.bus = &pnp_bus_type,
+	.find_device = acpi_pnp_find_device,
+};
+
 int pnpacpi_disabled __initdata;
 static int __init pnpacpi_init(void)
 {
@@ -245,8 +280,10 @@ static int __init pnpacpi_init(void)
 	}
 	pnp_info("PnP ACPI init");
 	pnp_register_protocol(&pnpacpi_protocol);
+	register_acpi_bus_type(&acpi_pnp_bus);
 	acpi_get_devices(NULL, pnpacpi_add_device_handler, NULL, NULL);
 	pnp_info("PnP ACPI: found %d devices", num);
+	unregister_acpi_bus_type(&acpi_pnp_bus);
 	return 0;
 }
 subsys_initcall(pnpacpi_init);
