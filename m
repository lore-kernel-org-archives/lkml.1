Return-Path: <linux-kernel-owner+w=401wt.eu-S1754721AbZA1L4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbZA1L4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 06:56:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbZA1Lzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 06:55:50 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37123 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbZA1Lzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 06:55:49 -0500
Message-ID: <498047B4.3030602@jp.fujitsu.com>
Date: Wed, 28 Jan 2009 20:55:32 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: linux-pci@vger.kernel.org, "Barnes, Jesse" <jesse.barnes@intel.com>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, shaohua.li@intel.com,
       Grant Grundler <grundler@parisc-linux.org>
Subject: [PATCH 4/8] PCI hotplug: fix wrong assumption in acpi_get_hp_hw_control_from_firmware
References: <1231604250.3642.33.camel@localhost.localdomain>	 <alpine.LFD.2.00.0901121604380.5859@localhost.localdomain>	 <1231807693.27151.21.camel@localhost.localdomain>	 <1232046108.5966.57.camel@localhost.localdomain>	 <alpine.LFD.2.00.0901151421110.4737@localhost.localdomain>	 <1232049269.5966.64.camel@localhost.localdomain>	 <1232050347.5966.66.camel@localhost.localdomain>	 <4970242C.4010404@jp.fujitsu.com>	 <1232115546.3224.5.camel@localhost.localdomain>	 <4973D2EE.3060203@jp.fujitsu.com>	 <1232328216.3247.68.camel@localhost.localdomain>	 <4973EF64.2050404@jp.fujitsu.com> <1232558780.736.24.camel@localhost.localdomain> <497D1BD7.9000609@jp.fujitsu.com> <498045D1.60005@jp.fujitsu.com>
In-Reply-To: <498045D1.60005@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current acpi_get_hp_hw_control_from_firmware() has a assumption that
pci_bus->self is NULL on a PCI root bus. But it might not be true on
some platforms. Because of this wrong assumption, current
acpi_get_hp_hw_control_from_firmware() might cause endless loop. We
must check pci_bus->parent instead.

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

---
 drivers/pci/hotplug/acpi_pcihp.c |   34 ++++++++++++----------------------
 1 file changed, 12 insertions(+), 22 deletions(-)

Index: linux-2.6.29-rc2/drivers/pci/hotplug/acpi_pcihp.c
===================================================================
--- linux-2.6.29-rc2.orig/drivers/pci/hotplug/acpi_pcihp.c
+++ linux-2.6.29-rc2/drivers/pci/hotplug/acpi_pcihp.c
@@ -373,12 +373,10 @@ EXPORT_SYMBOL_GPL(acpi_get_hp_params_fro
  *
  * Attempt to take hotplug control from firmware.
  */
-int acpi_get_hp_hw_control_from_firmware(struct pci_dev *dev, u32 flags)
+int acpi_get_hp_hw_control_from_firmware(struct pci_dev *pdev, u32 flags)
 {
 	acpi_status status;
 	acpi_handle chandle, handle;
-	struct pci_dev *pdev = dev;
-	struct pci_bus *parent;
 	struct acpi_buffer string = { ACPI_ALLOCATE_BUFFER, NULL };
 
 	flags &= (OSC_PCI_EXPRESS_NATIVE_HP_CONTROL |
@@ -410,26 +408,18 @@ int acpi_get_hp_hw_control_from_firmware
 		string = (struct acpi_buffer){ ACPI_ALLOCATE_BUFFER, NULL };
 	}
 
-	pdev = dev;
-	handle = DEVICE_ACPI_HANDLE(&dev->dev);
-	while (!handle) {
+	handle = DEVICE_ACPI_HANDLE(&pdev->dev);
+	if (!handle) {
 		/*
 		 * This hotplug controller was not listed in the ACPI name
 		 * space at all. Try to get acpi handle of parent pci bus.
 		 */
-		if (!pdev || !pdev->bus->parent)
-			break;
-		parent = pdev->bus->parent;
-		dbg("Could not find %s in acpi namespace, trying parent\n",
-		    pci_name(pdev));
-		if (!parent->self)
-			/* Parent must be a host bridge */
-			handle = acpi_get_pci_rootbridge_handle(
-					pci_domain_nr(parent),
-					parent->number);
-		else
-			handle = DEVICE_ACPI_HANDLE(&(parent->self->dev));
-		pdev = parent->self;
+		struct pci_bus *pbus;
+		for (pbus = pdev->bus; pbus; pbus = pbus->parent) {
+			handle = acpi_pci_get_bridge_handle(pbus);
+			if (handle)
+				break;
+		}
 	}
 
 	while (handle) {
@@ -448,13 +438,13 @@ int acpi_get_hp_hw_control_from_firmware
 	}
 
 	dbg("Cannot get control of hotplug hardware for pci %s\n",
-	    pci_name(dev));
+	    pci_name(pdev));
 
 	kfree(string.pointer);
 	return -ENODEV;
 got_one:
-	dbg("Gained control for hotplug HW for pci %s (%s)\n", pci_name(dev),
-			(char *)string.pointer);
+	dbg("Gained control for hotplug HW for pci %s (%s)\n",
+	    pci_name(pdev), (char *)string.pointer);
 	kfree(string.pointer);
 	return 0;
 }


