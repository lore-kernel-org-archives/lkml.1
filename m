Return-Path: <linux-kernel-owner+w=401wt.eu-S1757512AbYKQHaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512AbYKQHaS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 02:30:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755456AbYKQHVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 02:21:30 -0500
Received: from kroah.org ([198.145.64.141]:38524 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752471AbYKQHVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 02:21:20 -0500
Date: Sun, 16 Nov 2008 23:15:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Zhao Yakui <yakui.zhao@intel.com>,
       Li Shaohua <shaohua.li@intel.com>, Zhang Rui <rui.zhang@intel.com>,
       Andi Kleen <ak@linux.intel.com>, Len Brown <len.brown@intel.com>,
       Holger Macht <hmacht@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 27/46] ACPI : Load device driver according to the status of
	acpi device
Message-ID: <20081117071557.GB29522@kroah.com>
References: <20081117070621.430169021@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpi-load-device-driver-according-to-the-status-of-acpi-device.patch"
In-Reply-To: <20081117071333.GA29522@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zhao Yakui <yakui.zhao@intel.com>

commit 39a0ad871000d2a016a4fa113a6e53d22aabf25d upstream.

According to ACPI spec when the status of some device is not present
but functional, the device is valid and the children of this device
should be enumerated. It means that the device should be added to
linux acpi device tree. But the device driver for this device should not
be loaded.
    The detailed info can be found in the section 6.3.7 of ACPI 3.0b spec.
    _STA may return bit 0 clear (not present) with bit 3 set (device is
functional). This case is used to indicate a valid device for which no
device driver should be loaded (for example, a bridge device.).
Children of this device may be present and valid. OS should continue
enumeration below a device whose _STA returns this bit combination

http://bugzilla.kernel.org/show_bug.cgi?id=3358

Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
Signed-off-by: Li Shaohua <shaohua.li@intel.com>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Holger Macht <hmacht@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/bus.c         |   16 ++++++++--------
 drivers/acpi/scan.c        |   35 +++++++++++++++++++++++++----------
 drivers/pnp/pnpacpi/core.c |    6 +++++-
 3 files changed, 38 insertions(+), 19 deletions(-)

--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -95,21 +95,21 @@ int acpi_bus_get_status(struct acpi_devi
 	}
 
 	/*
-	 * Otherwise we assume the status of our parent (unless we don't
-	 * have one, in which case status is implied).
+	 * According to ACPI spec some device can be present and functional
+	 * even if the parent is not present but functional.
+	 * In such conditions the child device should not inherit the status
+	 * from the parent.
 	 */
-	else if (device->parent)
-		device->status = device->parent->status;
 	else
 		STRUCT_TO_INT(device->status) =
 		    ACPI_STA_DEVICE_PRESENT | ACPI_STA_DEVICE_ENABLED |
 		    ACPI_STA_DEVICE_UI      | ACPI_STA_DEVICE_FUNCTIONING;
 
 	if (device->status.functional && !device->status.present) {
-		printk(KERN_WARNING PREFIX "Device [%s] status [%08x]: "
-		       "functional but not present; setting present\n",
-		       device->pnp.bus_id, (u32) STRUCT_TO_INT(device->status));
-		device->status.present = 1;
+		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Device [%s] status [%08x]: "
+		       "functional but not present;\n",
+			device->pnp.bus_id,
+			(u32) STRUCT_TO_INT(device->status)));
 	}
 
 	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Device [%s] status [%08x]\n",
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -276,6 +276,13 @@ int acpi_match_device_ids(struct acpi_de
 {
 	const struct acpi_device_id *id;
 
+	/*
+	 * If the device is not present, it is unnecessary to load device
+	 * driver for it.
+	 */
+	if (!device->status.present)
+		return -ENODEV;
+
 	if (device->flags.hardware_id) {
 		for (id = ids; id->id[0]; id++) {
 			if (!strcmp((char*)id->id, device->pnp.hardware_id))
@@ -1221,15 +1228,18 @@ acpi_add_single_object(struct acpi_devic
 			result = -ENODEV;
 			goto end;
 		}
-		if (!device->status.present) {
-			/* Bay and dock should be handled even if absent */
-			if (!ACPI_SUCCESS(
-			     acpi_is_child_device(device, acpi_bay_match)) &&
-			    !ACPI_SUCCESS(
-			     acpi_is_child_device(device, acpi_dock_match))) {
-					result = -ENODEV;
-					goto end;
-			}
+		/*
+		 * When the device is neither present nor functional, the
+		 * device should not be added to Linux ACPI device tree.
+		 * When the status of the device is not present but functinal,
+		 * it should be added to Linux ACPI tree. For example : bay
+		 * device , dock device.
+		 * In such conditions it is unncessary to check whether it is
+		 * bay device or dock device.
+		 */
+		if (!device->status.present && !device->status.functional) {
+			result = -ENODEV;
+			goto end;
 		}
 		break;
 	default:
@@ -1402,7 +1412,12 @@ static int acpi_bus_scan(struct acpi_dev
 		 * TBD: Need notifications and other detection mechanisms
 		 *      in place before we can fully implement this.
 		 */
-		if (child->status.present) {
+		 /*
+		 * When the device is not present but functional, it is also
+		 * necessary to scan the children of this device.
+		 */
+		if (child->status.present || (!child->status.present &&
+					child->status.functional)) {
 			status = acpi_get_next_object(ACPI_TYPE_ANY, chandle,
 						      NULL, NULL);
 			if (ACPI_SUCCESS(status)) {
--- a/drivers/pnp/pnpacpi/core.c
+++ b/drivers/pnp/pnpacpi/core.c
@@ -148,9 +148,13 @@ static int __init pnpacpi_add_device(str
 	acpi_status status;
 	struct pnp_dev *dev;
 
+	/*
+	 * If a PnPacpi device is not present , the device
+	 * driver should not be loaded.
+	 */
 	status = acpi_get_handle(device->handle, "_CRS", &temp);
 	if (ACPI_FAILURE(status) || !ispnpidacpi(acpi_device_hid(device)) ||
-	    is_exclusive_device(device))
+	    is_exclusive_device(device) || (!device->status.present))
 		return 0;
 
 	dev = pnp_alloc_dev(&pnpacpi_protocol, num, acpi_device_hid(device));

-- 
