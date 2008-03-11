Return-Path: <linux-kernel-owner+w=401wt.eu-S1756657AbYCKNX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657AbYCKNX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 09:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755504AbYCKNXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 09:23:47 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42635 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbYCKNXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 09:23:46 -0400
Message-ID: <47D686EF.1090604@jp.fujitsu.com>
Date: Tue, 11 Mar 2008 22:19:43 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>
CC: Greg KH <gregkh@suse.de>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Wilcox <matthew@wil.cx>, Gary Hade <garyhade@us.ibm.com>,
       warthog19@eaglescrag.net, kristen.c.accardi@intel.com,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
Subject: [PATCH 4/(3+1)] Add quirks for ACPI PCI slot detection driver
References: <20080229002341.GA21420@ldl.fc.hp.com> <20080301144307.GD24386@parisc-linux.org> <20080304054927.GA15566@suse.de> <200803041018.29035.jbarnes@virtuousgeek.org> <20080304193036.GB5534@suse.de> <20080304230937.GD3694@ldl.fc.hp.com> <47CDF339.3060304@jp.fujitsu.com> <20080305202052.GN3694@ldl.fc.hp.com> <47D684D0.6060200@jp.fujitsu.com>
In-Reply-To: <47D684D0.6060200@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI spec says that OSPM checks with the bus driver for _ADR devices
to verify the presence of the device. But there are hardwares that
provide _STA for PCI hotplug slots to indicate the presence of the
device. For those hardwares, we want to ignore _STA and evaluate _SUN
by force, otherwise PCI hotplug slots would not be detected.

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

---
 drivers/acpi/pci_slot.c |   47 +++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 43 insertions(+), 4 deletions(-)

Index: linux-2.6.25-rc4/drivers/acpi/pci_slot.c
===================================================================
--- linux-2.6.25-rc4.orig/drivers/acpi/pci_slot.c
+++ linux-2.6.25-rc4/drivers/acpi/pci_slot.c
@@ -31,6 +31,7 @@
 #include <acpi/acpi_drivers.h>
 
 static int debug;
+static int ignore_sta;
 
 #define DRIVER_VERSION 	"0.1"
 #define DRIVER_AUTHOR	"Alex Chiang <achiang@hp.com>"
@@ -73,10 +74,20 @@ check_slot(acpi_handle handle, int *devi
 	acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
 	dbg("Checking slot on path: %s\n", (char *)buffer.pointer);
 
-	status = acpi_evaluate_integer(handle, "_STA", NULL, &sta);
-	if (ACPI_SUCCESS(status) && !(sta & ACPI_STA_DEVICE_PRESENT)) {
-		retval = -1;
-		goto out;
+	/*
+	 * ACPI spec says that OSPM checks with the bus driver for
+	 * _ADR devices to verify the presence of the device. But
+	 * there are hardwares that provide _STA for PCI hotplug slots
+	 * to indicate the presence of the device. For those
+	 * hardwares, we want to ignore _STA and evaluate _SUN by
+	 * force, otherwise PCI hotplug slots would not be detected.
+	 */
+	if (!ignore_sta) {
+		status = acpi_evaluate_integer(handle, "_STA", NULL, &sta);
+		if (ACPI_SUCCESS(status) && !(sta & ACPI_STA_DEVICE_PRESENT)) {
+			retval = -1;
+			goto out;
+		}
 	}
 
 	status = acpi_evaluate_integer(handle, "_ADR", NULL, &adr);
@@ -311,9 +322,37 @@ acpi_pci_slot_remove(acpi_handle handle)
 		err("%s: unregister_slot failure - %d\n", __FUNCTION__, status);
 }
 
+#ifdef CONFIG_DMI
+static int ignore_sta_before_sun(const struct dmi_system_id *d)
+{
+	info("%s detected: will ignore _STA before calling _SUN\n", d->ident);
+	ignore_sta = 1;
+	return 0;
+}
+
+static struct dmi_system_id acpi_pci_slot_dmi_table[] __initdata = {
+	/*
+	 * Ignore _STA if the hardware provides _STA to indicate the
+	 * presence of PCI adapter card on PCI hotplug slot.
+	 */
+	/* Please add appropriate values for HP/IBM servers.
+	{
+		.callback = ignore_sta_before_sun,
+		.ident = "",
+		.matches = {
+			DMI_MATCH(DMI_BIOS_VENDOR, ""),
+			DMI_MATCH(DMI_BIOS_VERSION, ""),
+		},
+	},
+	*/
+	{}
+};
+#endif /* CONFIG_DMI */
+
 static int __init
 acpi_pci_slot_init(void)
 {
+	dmi_check_system(acpi_pci_slot_dmi_table);
 	acpi_pci_register_driver(&acpi_pci_slot_driver);
 	return 0;
 }


