Return-Path: <linux-kernel-owner+w=401wt.eu-S1754221AbZDYOMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221AbZDYOMo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 10:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752409AbZDYOMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 10:12:34 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:61137 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbZDYOMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 10:12:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZIC62Xb7pz/ScqLLCkAmJlBvoGFmEHxX/rBEVEPKU2k6D+sbfN86noIjdMgKtpcIsF
         lZVWYu0ysOOYc3wWNEXP4ErPkaTPviBAddldef0sFvaPQ84aAIF0u92RCRIp70GxhK07
         M+xRpg7vW3wftwRKqrsnZGaT81Bp0cKC1Vh40=
MIME-Version: 1.0
In-Reply-To: <20090419151306.GA15048@srcf.ucam.org>
References: <alpine.LFD.2.00.0902081251090.3048@localhost.localdomain>
	 <gemini.ket9w800w44dc0hvg.linux@youmustbejoking.demon.co.uk>
	 <20090209234911.GB862@elte.hu>
	 <5030E21460%linux@youmustbejoking.demon.co.uk>
	 <20090210150431.GA26798@srcf.ucam.org>
	 <5030E7CFF4%linux@youmustbejoking.demon.co.uk>
	 <20090419015614.GA6926@srcf.ucam.org>
	 <71cd59b00904190020x7d946c29w736d89fc27d39594@mail.gmail.com>
	 <20090419151306.GA15048@srcf.ucam.org>
Date: Sat, 25 Apr 2009 16:12:29 +0200
Message-ID: <71cd59b00904250712k332bfc14nb181aaabd7c605e5@mail.gmail.com>
Subject: Re: [PATCH] eee-laptop: Register as a pci-hotplug device
From: Corentin Chary <corentin.chary@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       Len Brown <lenb@kernel.org>,
       Darren Salt <linux@youmustbejoking.demon.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I take your patch and make it works against acpi4asus tree.
If you think it's ok, then I'll send a serie including this patch to Len.
(the tree is at http://git.iksaif.net/ )

From: Matthew Garrett <mjg@redhat.com>

The eee contains a logically (but not physically) hotpluggable PCIe slot.
Currently this is handled by adding or removing the PCI device in response
to rfkill events, but if a user has forced pciehp to bind to it (with the
force=1 argument) then both drivers will try to handle the event and
hilarity (in the form of oopses) will ensue. This can be avoided by having
eee-laptop register the slot as a hotplug slot. Only one of pciehp and
eee-laptop will successfully register this, avoiding the problem.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Corentin Chary <corentincj@iksaif.net>
Tested-by: Darren Salt <linux@youmustbejoking.demon.co.uk>
---
 drivers/platform/x86/Kconfig        |    1 +
 drivers/platform/x86/eeepc-laptop.c |   87 +++++++++++++++++++++++++++++++++++
 2 files changed, 88 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 284ebac..afbe441 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -341,6 +341,7 @@ config EEEPC_LAPTOP
 	select BACKLIGHT_CLASS_DEVICE
 	select HWMON
 	select RFKILL
+	select HOTPLUG_PCI
 	---help---
 	  This driver supports the Fn-Fx keys on Eee PC laptops.
 	  It also adds the ability to switch camera/wlan on/off.
diff --git a/drivers/platform/x86/eeepc-laptop.c
b/drivers/platform/x86/eeepc-laptop.c
index 7aaf587..4440f6c 100644
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
@@ -197,6 +199,15 @@ static struct acpi_driver eeepc_hotk_driver = {
 	},
 };

+/* PCI hotplug ops */
+static int eeepc_get_adapter_status(struct hotplug_slot *slot, u8 *value);
+
+static struct hotplug_slot_ops eeepc_hotplug_slot_ops = {
+	.owner = THIS_MODULE,
+	.get_adapter_status = eeepc_get_adapter_status,
+	.get_power_status = eeepc_get_adapter_status,
+};
+
 /* The backlight device /sys/class/backlight */
 static struct backlight_device *eeepc_backlight_device;

@@ -529,6 +540,19 @@ static int notify_brn(void)
 	return -1;
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
 	enum rfkill_state state;
@@ -655,6 +679,54 @@ static void eeepc_unregister_rfkill_notifier(char *node)
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
+	ehotk->hotplug_slot = NULL;
+error_slot:
+	return ret;
+}
+
 static int eeepc_hotk_add(struct acpi_device *device)
 {
 	acpi_status status = AE_OK;
@@ -738,8 +810,21 @@ static int eeepc_hotk_add(struct acpi_device *device)
 			goto bluetooth_fail;
 	}

+	result = eeepc_setup_pci_hotplug();
+	/*
+	 * If we get -EBUSY then something else is handling the PCI hotplug -
+	 * don't fail in this case
+	 */
+	if (result == -EBUSY)
+		return 0;
+	else if (result)
+		goto pci_fail;
+
 	return 0;

+ pci_fail:
+	if (ehotk->eeepc_bluetooth_rfkill)
+		rfkill_unregister(ehotk->eeepc_bluetooth_rfkill);
  bluetooth_fail:
 	if (ehotk->eeepc_bluetooth_rfkill)
 		rfkill_free(ehotk->eeepc_bluetooth_rfkill);
@@ -768,6 +853,8 @@ static int eeepc_hotk_remove(struct acpi_device
*device, int type)

 	eeepc_unregister_rfkill_notifier("\\_SB.PCI0.P0P6");
 	eeepc_unregister_rfkill_notifier("\\_SB.PCI0.P0P7");
+	if (ehotk->hotplug_slot)
+		pci_hp_deregister(ehotk->hotplug_slot);

 	kfree(ehotk);
 	return 0;
-- 
1.6.2.3
