Return-Path: <linux-kernel-owner+w=401wt.eu-S1752767AbZFEPpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbZFEPpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 11:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbZFEPpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 11:45:23 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4072 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbZFEPpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 11:45:23 -0400
Subject: Re: [PATCH] eeepc-laptop.c: use pr_fmt and pr_<level>
From: Joe Perches <joe@perches.com>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       acpi4asus-user@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
       Matthew Garrett <mjg@redhat.com>,
       Darren Salt <linux@youmustbejoking.demon.co.uk>
In-Reply-To: <71cd59b00906050457i29638577o9eeb5e8fa8eb087c@mail.gmail.com>
References: <1244197103.3631.40.camel@Joe-Laptop.home>
	 <4A28F94A.6040500@tuffmail.co.uk>
	 <1244199633.3631.43.camel@Joe-Laptop.home>
	 <71cd59b00906050457i29638577o9eeb5e8fa8eb087c@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 05 Jun 2009 08:45:12 -0700
Message-Id: <1244216712.3631.117.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-05 at 13:57 +0200, Corentin Chary wrote:
> On Fri, Jun 5, 2009 at 1:00 PM, Joe Perches<joe@perches.com> wrote:
> > On Fri, 2009-06-05 at 11:54 +0100, Alan Jenkins wrote:
> >> Is EEEPC_HOTK_FILE used anywhere else?  It would be clearer if you were
> >> able to just use "eeepc: " or whatever and remove the definition of
> >> EEEPC_HOTK_FILE.
> > It is used elsewhere and perhaps it'd be better to use KBUILD_MODNAME.
> I think we can't use KBUILD_MODNAME because "eeepc" is used for
> platform_device, backlight and input device. Using "eeepc-laptop"
> would break compatibility.

What compatibility would it break?
Logging messages are not guaranteed to be stable across versions.

Here's the patch against the latest acpi4asus tree.
There is a proposed patch from Pekka that may impact this patch.

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index 4e1cf2d..fef9172 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -16,6 +16,8 @@
  *  GNU General Public License for more details.
  */
 
+#define pr_fmt(fmt) EEEPC_HOTK_FILE ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -41,11 +43,6 @@
 #define EEEPC_HOTK_DEVICE_NAME	"Hotkey"
 #define EEEPC_HOTK_HID		"ASUS010"
 
-#define EEEPC_LOG	EEEPC_HOTK_FILE ": "
-#define EEEPC_ERR	KERN_ERR	EEEPC_LOG
-#define EEEPC_WARNING	KERN_WARNING	EEEPC_LOG
-#define EEEPC_NOTICE	KERN_NOTICE	EEEPC_LOG
-#define EEEPC_INFO	KERN_INFO	EEEPC_LOG
 
 /*
  * Definitions for Asus EeePC
@@ -269,7 +266,7 @@ static int set_acpi(int cm, int value)
 		if (method == NULL)
 			return -ENODEV;
 		if (write_acpi_int(ehotk->handle, method, value, NULL))
-			printk(EEEPC_WARNING "Error writing %s\n", method);
+			pr_warning("Error writing %s\n", method);
 	}
 	return 0;
 }
@@ -282,7 +279,7 @@ static int get_acpi(int cm)
 		if (method == NULL)
 			return -ENODEV;
 		if (read_acpi_int(ehotk->handle, method, &value))
-			printk(EEEPC_WARNING "Error reading %s\n", method);
+			pr_warning("Error reading %s\n", method);
 	}
 	return value;
 }
@@ -536,26 +533,23 @@ static int eeepc_hotk_check(void)
 	if (ehotk->device->status.present) {
 		if (write_acpi_int(ehotk->handle, "INIT", ehotk->init_flag,
 				    &buffer)) {
-			printk(EEEPC_ERR "Hotkey initialization failed\n");
+			pr_err("Hotkey initialization failed\n");
 			return -ENODEV;
 		} else {
-			printk(EEEPC_NOTICE "Hotkey init flags 0x%x\n",
-			       ehotk->init_flag);
+			pr_notice("Hotkey init flags 0x%x\n", ehotk->init_flag);
 		}
 		/* get control methods supported */
 		if (read_acpi_int(ehotk->handle, "CMSG"
 				   , &ehotk->cm_supported)) {
-			printk(EEEPC_ERR
-			       "Get control methods supported failed\n");
+			pr_err("Get control methods supported failed\n");
 			return -ENODEV;
 		} else {
-			printk(EEEPC_INFO
-			       "Get control methods supported: 0x%x\n",
-			       ehotk->cm_supported);
+			pr_info("Get control methods supported: 0x%x\n",
+				ehotk->cm_supported);
 		}
 		ehotk->inputdev = input_allocate_device();
 		if (!ehotk->inputdev) {
-			printk(EEEPC_INFO "Unable to allocate input device\n");
+			pr_info("Unable to allocate input device\n");
 			return 0;
 		}
 		ehotk->inputdev->name = "Asus EeePC extra buttons";
@@ -574,12 +568,12 @@ static int eeepc_hotk_check(void)
 		}
 		result = input_register_device(ehotk->inputdev);
 		if (result) {
-			printk(EEEPC_INFO "Unable to register input device\n");
+			pr_info("Unable to register input device\n");
 			input_free_device(ehotk->inputdev);
 			return 0;
 		}
 	} else {
-		printk(EEEPC_ERR "Hotkey device not present, aborting\n");
+		pr_err("Hotkey device not present, aborting\n");
 		return -EINVAL;
 	}
 	return 0;
@@ -620,7 +614,7 @@ static void eeepc_rfkill_notify(acpi_handle handle, u32 event, void *data)
 		return;
 
 	if (!bus) {
-		printk(EEEPC_WARNING "Unable to find PCI bus 1?\n");
+		pr_warning("Unable to find PCI bus 1?\n");
 		return;
 	}
 
@@ -637,7 +631,7 @@ static void eeepc_rfkill_notify(acpi_handle handle, u32 event, void *data)
 		if (dev) {
 			pci_bus_assign_resources(bus);
 			if (pci_bus_add_device(dev))
-				printk(EEEPC_ERR "Unable to hotplug wifi\n");
+				pr_err("Unable to hotplug wifi\n");
 		}
 	} else {
 		dev = pci_get_slot(bus, 0);
@@ -710,8 +704,7 @@ static int eeepc_register_rfkill_notifier(char *node)
 						     eeepc_rfkill_notify,
 						     NULL);
 		if (ACPI_FAILURE(status))
-			printk(EEEPC_WARNING
-			       "Failed to register notify on %s\n", node);
+			pr_warning("Failed to register notify on %s\n", node);
 	} else
 		return -ENODEV;
 
@@ -730,8 +723,7 @@ static void eeepc_unregister_rfkill_notifier(char *node)
 						     ACPI_SYSTEM_NOTIFY,
 						     eeepc_rfkill_notify);
 		if (ACPI_FAILURE(status))
-			printk(EEEPC_ERR
-			       "Error removing rfkill notify handler %s\n",
+			pr_err("Error removing rfkill notify handler %s\n",
 				node);
 	}
 }
@@ -748,7 +740,7 @@ static int eeepc_setup_pci_hotplug(void)
 	struct pci_bus *bus = pci_find_bus(0, 1);
 
 	if (!bus) {
-		printk(EEEPC_ERR "Unable to find wifi PCI bus\n");
+		pr_err("Unable to find wifi PCI bus\n");
 		return -ENODEV;
 	}
 
@@ -769,7 +761,7 @@ static int eeepc_setup_pci_hotplug(void)
 
 	ret = pci_hp_register(ehotk->hotplug_slot, bus, 0, "eeepc-wifi");
 	if (ret) {
-		printk(EEEPC_ERR "Unable to register hotplug slot - %d\n", ret);
+		pr_err("Unable to register hotplug slot - %d\n", ret);
 		goto error_register;
 	}
 
@@ -791,7 +783,7 @@ static int eeepc_hotk_add(struct acpi_device *device)
 
 	if (!device)
 		 return -EINVAL;
-	printk(EEEPC_NOTICE EEEPC_HOTK_NAME "\n");
+	pr_notice(EEEPC_HOTK_NAME "\n");
 	ehotk = kzalloc(sizeof(struct eeepc_hotk), GFP_KERNEL);
 	if (!ehotk)
 		return -ENOMEM;
@@ -807,7 +799,7 @@ static int eeepc_hotk_add(struct acpi_device *device)
 	status = acpi_install_notify_handler(ehotk->handle, ACPI_SYSTEM_NOTIFY,
 					     eeepc_hotk_notify, ehotk);
 	if (ACPI_FAILURE(status))
-		printk(EEEPC_ERR "Error installing notify handler\n");
+		pr_err("Error installing notify handler\n");
 
 	eeepc_register_rfkill_notifier("\\_SB.PCI0.P0P6");
 	eeepc_register_rfkill_notifier("\\_SB.PCI0.P0P7");
@@ -908,7 +900,7 @@ static int eeepc_hotk_remove(struct acpi_device *device, int type)
 	status = acpi_remove_notify_handler(ehotk->handle, ACPI_SYSTEM_NOTIFY,
 					    eeepc_hotk_notify);
 	if (ACPI_FAILURE(status))
-		printk(EEEPC_ERR "Error removing notify handler\n");
+		pr_err("Error removing notify handler\n");
 
 	eeepc_unregister_rfkill_notifier("\\_SB.PCI0.P0P6");
 	eeepc_unregister_rfkill_notifier("\\_SB.PCI0.P0P7");
@@ -1080,8 +1072,7 @@ static int eeepc_backlight_init(struct device *dev)
 	bd = backlight_device_register(EEEPC_HOTK_FILE, dev,
 				       NULL, &eeepcbl_ops);
 	if (IS_ERR(bd)) {
-		printk(EEEPC_ERR
-		       "Could not register eeepc backlight device\n");
+		pr_err("Could not register eeepc backlight device\n");
 		eeepc_backlight_device = NULL;
 		return PTR_ERR(bd);
 	}
@@ -1100,8 +1091,7 @@ static int eeepc_hwmon_init(struct device *dev)
 
 	hwmon = hwmon_device_register(dev);
 	if (IS_ERR(hwmon)) {
-		printk(EEEPC_ERR
-		       "Could not register eeepc hwmon device\n");
+		pr_err("Could not register eeepc hwmon device\n");
 		eeepc_hwmon_device = NULL;
 		return PTR_ERR(hwmon);
 	}
@@ -1134,8 +1124,7 @@ static int __init eeepc_laptop_init(void)
 		if (result)
 			goto fail_backlight;
 	} else
-		printk(EEEPC_INFO "Backlight controlled by ACPI video "
-		       "driver\n");
+		pr_info("Backlight controlled by ACPI video driver\n");
 
 	result = eeepc_hwmon_init(dev);
 	if (result)


