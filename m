Return-Path: <linux-kernel-owner+w=401wt.eu-S932238AbXGYWpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238AbXGYWpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 18:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756293AbXGYWpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 18:45:03 -0400
Received: from atlrel8.hp.com ([156.153.255.206]:39181 "EHLO atlrel8.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756276AbXGYWpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 18:45:00 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: =?utf-8?q?S=C3=A9bastien_Dugu=C3=A9?= <sebastien.dugue@bull.net>
Subject: Re: commit 7e92b4fc34 - x86, serial: convert legacy COM ports to platform devices - broke my serial console
Date: Wed, 25 Jul 2007 16:41:23 -0600
User-Agent: KMail/1.9.6
Cc: linux-kernel <linux-kernel@vger.kernel.org>, ambx1@neo.rr.com,
       akpm@linux-foundation.org, lenb@kernel.org, rmk@arm.linux.org.uk,
       mjg59@srcf.ucam.org, castet.matthieu@free.fr, shaohua.li@intel.com,
       "Yinghai Lu" <yhlu.kernel@gmail.com>
References: <20070724162805.76ea8328@frecb000686.frec.bull.fr> <200707250716.44609.bjorn.helgaas@hp.com> <20070725153253.4d7e7e37@frecb000686.frec.bull.fr>
In-Reply-To: <20070725153253.4d7e7e37@frecb000686.frec.bull.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200707251641.23406.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 July 2007 07:32:53 am Sébastien Dugué wrote:
> On Wed, 25 Jul 2007 07:16:44 -0600 Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> 
> > The _DDN is a "DOS device name", and the _UID is a "logical device ID
> > that does not change across reboots."  Both are optional, and PNPACPI
> > ignores them.  But maybe we could change PNPACPI to sort by them if
> > they are present.  I'll think about this a bit.
> 
>   That would be nice, but I wish you good luck with all those
> crappy BIOSes out there.

Yeah, it's an ugly world we live in.  Would you be able to try the
attached patch just for testing?  It should sort devices with the
same _HID by their _UID.  It doesn't have any effect on my systems,
because my devices are already ordered by _UID by default.  But I
think it should switch your COM1/COM2 ports back to the order you
expect.

Yinghai, you mentioned the same issue on boxes with multiple root
bridges.  Any chance you could try this out there as well?

Index: w/drivers/pnp/pnpacpi/core.c
===================================================================
--- w.orig/drivers/pnp/pnpacpi/core.c	2007-07-25 13:56:02.000000000 -0600
+++ w/drivers/pnp/pnpacpi/core.c	2007-07-25 16:25:27.000000000 -0600
@@ -224,18 +224,91 @@
 	return -EINVAL;
 }
 
-static acpi_status __init pnpacpi_add_device_handler(acpi_handle handle,
+struct pnpacpi_device {
+	struct acpi_device	*device;
+	unsigned long		unique_id;
+	struct list_head	list;
+};
+
+static LIST_HEAD(pnpacpi_dev_list);
+
+static inline int hardware_id_match(struct acpi_device *dev1,
+				    struct acpi_device *dev2)
+{
+	return !strncmp(acpi_device_hid(dev1), acpi_device_hid(dev2),
+			sizeof(acpi_device_hid(dev1)));
+}
+
+static inline int precedes(struct pnpacpi_device *dev1,
+			   struct pnpacpi_device *dev2)
+{
+	return hardware_id_match(dev1->device, dev2->device) &&
+		dev1->unique_id < dev2->unique_id;
+}
+
+static acpi_status __init pnpacpi_find_device_handler(acpi_handle handle,
 	u32 lvl, void *context, void **rv)
 {
 	struct acpi_device *device;
+	struct pnpacpi_device *dev, *cur, *prev = NULL;
+	struct list_head *node;
+	acpi_status status;
+	unsigned long id;
 
-	if (!acpi_bus_get_device(handle, &device))
-		pnpacpi_add_device(device);
-	else
+	if (acpi_bus_get_device(handle, &device))
 		return AE_CTRL_DEPTH;
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev) {
+		pnp_err("Out of memory");
+		return AE_OK;
+	}
+
+	status = acpi_evaluate_integer(handle, METHOD_NAME__UID, NULL, &id);
+	if (ACPI_FAILURE(status))
+		id = 0;
+
+	INIT_LIST_HEAD(&dev->list);
+	dev->device = device;
+	dev->unique_id = id;
+
+	/*
+	 * If several devices have the same _HID, sort them by _UID so
+	 * device names are ordered by _UID.  Note that _UID can be
+	 * either an integer or a string; we only order the integer ones.
+	 */
+	if (list_empty(&pnpacpi_dev_list)) {
+		list_add(&dev->list, &pnpacpi_dev_list);
+		return AE_OK;
+	}
+
+	list_for_each(node, &pnpacpi_dev_list) {
+		cur = list_entry(node, struct pnpacpi_device, list);
+		if (precedes(dev, cur) ||
+		    (prev && hardware_id_match(prev->device, cur->device))) {
+			list_add_tail(&dev->list, node);
+			return AE_OK;
+		}
+		prev = cur;
+	}
+
+	list_add_tail(&dev->list, &pnpacpi_dev_list);
 	return AE_OK;
 }
 
+static void __init pnpacpi_add_devices(void)
+{
+	struct list_head *node, *next;
+	struct pnpacpi_device *dev;
+
+	list_for_each_safe(node, next, &pnpacpi_dev_list) {
+		dev = list_entry(node, struct pnpacpi_device, list);
+		pnpacpi_add_device(dev->device);
+		list_del(node);
+		kfree(dev);
+	}
+}
+
 static int __init acpi_pnp_match(struct device *dev, void *_pnp)
 {
 	struct acpi_device	*acpi = to_acpi_device(dev);
@@ -282,7 +355,8 @@
 	pnp_info("PnP ACPI init");
 	pnp_register_protocol(&pnpacpi_protocol);
 	register_acpi_bus_type(&acpi_pnp_bus);
-	acpi_get_devices(NULL, pnpacpi_add_device_handler, NULL, NULL);
+	acpi_get_devices(NULL, pnpacpi_find_device_handler, NULL, NULL);
+	pnpacpi_add_devices();
 	pnp_info("PnP ACPI: found %d devices", num);
 	unregister_acpi_bus_type(&acpi_pnp_bus);
 	pnp_platform_devices = 1;
