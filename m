Return-Path: <linux-kernel-owner+w=401wt.eu-S1756245AbZBWQjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245AbZBWQjx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 11:39:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753722AbZBWQjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 11:39:43 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:33015 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbZBWQjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 11:39:42 -0500
Date: Mon, 23 Feb 2009 16:39:34 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Corentin Chary <corentincj@iksaif.net>,
       Darren Salt <linux@youmustbejoking.demon.co.uk>
Subject: Re: Oopses and ACPI problems (Linus 2.6.29-rc4)
Message-ID: <20090223163934.GA20041@srcf.ucam.org>
References: <alpine.LFD.2.00.0902081251090.3048@localhost.localdomain> <gemini.ket9w800w44dc0hvg.linux@youmustbejoking.demon.co.uk> <20090209234911.GB862@elte.hu> <5030E21460%linux@youmustbejoking.demon.co.uk> <20090210150431.GA26798@srcf.ucam.org> <5030E7CFF4%linux@youmustbejoking.demon.co.uk> <20090210154533.GA27596@srcf.ucam.org> <5030EC39A4%linux@youmustbejoking.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5030EC39A4%linux@youmustbejoking.demon.co.uk>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you try this (entirely untested - I don't have access to the 
hardware right now) patch? It should register the eee code with the PCI 
hotplug core. With luck that'll avoid the oops.

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index b3866ad..75a560b 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -307,6 +307,7 @@ config EEEPC_LAPTOP
 	select BACKLIGHT_CLASS_DEVICE
 	select HWMON
 	select RFKILL
+	select HOTPLUG_PCI
 	---help---
 	  This driver supports the Fn-Fx keys on Eee PC laptops.
 	  It also adds the ability to switch camera/wlan on/off.
diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index 786ed86..9e5fa4c 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -31,6 +31,7 @@
 #include <linux/input.h>
 #include <linux/rfkill.h>
 #include <linux/pci.h>
+#include <linux/pci_hotplug.h>
 
 #define EEEPC_LAPTOP_VERSION	"0.1"
 
@@ -132,6 +133,7 @@ struct eeepc_hotk {
 	u16 *keycode_map;
 	struct rfkill *eeepc_wlan_rfkill;
 	struct rfkill *eeepc_bluetooth_rfkill;
+	struct hotplug_slot *hotplug_slot;
 };
 
 /* The actual device the driver binds to */
@@ -194,6 +196,15 @@ static struct acpi_driver eeepc_hotk_driver = {
 	},
 };
 
+/* PCI hotplug ops */
+static int eeepc_get_adapter_status (struct hotplug_slot *slot, u8 *value);
+
+static struct hotplug_slot_ops eeepc_hotplug_slot_ops = {
+	.owner = THIS_MODULE,
+	.get_adapter_status = eeepc_get_adapter_status,
+	.get_power_status = eeepc_get_adapter_status,
+};
+
 /* The backlight device /sys/class/backlight */
 static struct backlight_device *eeepc_backlight_device;
 
@@ -519,6 +530,19 @@ static void notify_brn(void)
 		bd->props.brightness = read_brightness(bd);
 }
 
+static int eeepc_get_adapter_status(struct hotplug_slot *hotplug_slot,
+				    u8 *value)
+{
+	int val = get_acpi(CM_ASL_WLAN);
+
+	if (val == 1 || val == 0)
+		*value = val;
+	else
+		return -EINVAL;
+
+	return 0;
+}
+
 static void eeepc_rfkill_notify(acpi_handle handle, u32 event, void *data)
 {
 	struct pci_dev *dev;
@@ -620,6 +644,53 @@ static void eeepc_unregister_rfkill_notifier(char *node)
 	}
 }
 
+static void eeepc_cleanup_pci_hotplug(struct hotplug_slot *hotplug_slot)
+{
+	kfree(hotplug_slot->info);
+	kfree(hotplug_slot);
+}
+
+static int eeepc_setup_pci_hotplug(void)
+{
+	int ret = -ENOMEM;
+	struct pci_bus *bus = pci_find_bus(0, 1);
+
+	if (!bus) {
+		printk(EEEPC_ERR "Unable to find wifi PCI bus\n");
+		return -ENODEV;
+	}
+
+	ehotk->hotplug_slot = kzalloc(sizeof(struct hotplug_slot), GFP_KERNEL);
+	if (!ehotk->hotplug_slot)
+		goto error_slot;
+
+	ehotk->hotplug_slot->info = kzalloc(sizeof(struct hotplug_slot_info),
+					    GFP_KERNEL);
+	if (!ehotk->hotplug_slot->info)
+		goto error_info;
+
+	ehotk->hotplug_slot->private = ehotk;
+	ehotk->hotplug_slot->release = &eeepc_cleanup_pci_hotplug;
+	ehotk->hotplug_slot->ops = &eeepc_hotplug_slot_ops;
+	eeepc_get_adapter_status(ehotk->hotplug_slot,
+				 &ehotk->hotplug_slot->info->adapter_status);
+
+	ret = pci_hp_register(ehotk->hotplug_slot, bus, 0, "eeepc-wifi");
+	if (ret) {
+		printk(EEEPC_ERR "Unable to register hotplug slot - %d\n", ret);
+		goto error_register;
+	}
+
+	return 0;
+	
+error_register:
+	kfree(ehotk->hotplug_slot->info);
+error_info:
+	kfree(ehotk->hotplug_slot);
+error_slot:
+	return ret;
+}
+
 static int eeepc_hotk_add(struct acpi_device *device)
 {
 	acpi_status status = AE_OK;
@@ -700,11 +771,17 @@ static int eeepc_hotk_add(struct acpi_device *device)
 			goto bluetooth_fail;
 	}
 
+	result = eeepc_setup_pci_hotplug();
+	if (result)
+		goto pci_fail;
+
 	eeepc_register_rfkill_notifier("\\_SB.PCI0.P0P6");
 	eeepc_register_rfkill_notifier("\\_SB.PCI0.P0P7");
 
 	return 0;
-
+ pci_fail:
+	if (ehotk->eeepc_bluetooth_rfkill)
+		rfkill_unregister(ehotk->eeepc_bluetooth_rfkill);
  bluetooth_fail:
 	if (ehotk->eeepc_bluetooth_rfkill)
 		rfkill_free(ehotk->eeepc_bluetooth_rfkill);
@@ -734,6 +811,8 @@ static int eeepc_hotk_remove(struct acpi_device *device, int type)
 	eeepc_unregister_rfkill_notifier("\\_SB.PCI0.P0P6");
 	eeepc_unregister_rfkill_notifier("\\_SB.PCI0.P0P7");
 
+	pci_hp_deregister(ehotk->hotplug_slot);
+
 	kfree(ehotk);
 	return 0;
 }


-- 
Matthew Garrett | mjg59@srcf.ucam.org
