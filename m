Return-Path: <linux-kernel-owner+w=401wt.eu-S1753236AbYKNQQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236AbYKNQQo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 11:16:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbYKNQQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 11:16:35 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:38355 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbYKNQQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 11:16:34 -0500
Date: Fri, 14 Nov 2008 16:16:31 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: Add option to passively listen for PCIE hotplug events
Message-ID: <20081114161631.GA28234@srcf.ucam.org>
References: <20081104124706.GB19401@srcf.ucam.org> <20081104133214.GA20427@srcf.ucam.org> <49105BA6.9090403@tuffmail.co.uk> <20081104143332.GA21689@srcf.ucam.org> <491063B3.4080808@tuffmail.co.uk> <20081104151128.GA22544@srcf.ucam.org> <49106DD7.9010307@tuffmail.co.uk> <20081104155722.GA23314@srcf.ucam.org> <491076BD.1030704@tuffmail.co.uk> <49170B16.4010909@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49170B16.4010909@tuffmail.co.uk>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 09, 2008 at 04:08:54PM +0000, Alan Jenkins wrote:

> Bump.  In case you're still slightly confused, I've found out why.  It 
> skips the slot power check because POWER_CTRL(ctrl) == 0.  (See "Power 
> Controller" in the debug output below).

Ok. I'm beginning to think that this approach is misguided. The Aspire 
One should be handled by the acpiphp changes I've posted. The Eee makes 
significantly less sense to me. It runs XP, so it can't depend on native 
PCIe hotplugging. It sends ACPI notifications when the kill state 
changes but there's no topological relationship between the device that 
receives them and the device that needs to be hotplugged.

What I'm actually beginning to suspect is that this should be handled by 
eee-laptop. Can you give the following patch a go, without any pciehp 
code loaded?

diff --git a/drivers/misc/eeepc-laptop.c b/drivers/misc/eeepc-laptop.c
index 9ef98b2..6317ee6 100644
--- a/drivers/misc/eeepc-laptop.c
+++ b/drivers/misc/eeepc-laptop.c
@@ -30,6 +30,7 @@
 #include <linux/uaccess.h>
 #include <linux/input.h>
 #include <linux/rfkill.h>
+#include <linux/pci.h>
 
 #define EEEPC_LAPTOP_VERSION	"0.1"
 
@@ -123,6 +124,7 @@ static const char *cm_setv[] = {
 struct eeepc_hotk {
 	struct acpi_device *device;	/* the device we are in */
 	acpi_handle handle;		/* the handle of the hotk device */
+	acpi_handle rfkill_handle;	/* the handle of the rfkill notifier */
 	u32 cm_supported;		/* the control methods supported
 					   by this BIOS */
 	uint init_flag;			/* Init flags */
@@ -513,6 +515,35 @@ static void notify_brn(void)
 	bd->props.brightness = read_brightness(bd);
 }
 
+static void eeepc_rfkill_notify(acpi_handle handle, u32 event, void *data)
+{
+	struct pci_dev *dev;
+	struct pci_bus *bus = pci_find_bus(0, 1);
+
+	if (!bus) {
+		printk(KERN_WARNING "Unable to find wifi bus!\n");
+		return;
+	}
+
+	if (get_acpi(CM_ASL_WLAN) == 1) {
+		printk("Adding wifi\n");
+	
+		dev = pci_scan_single_device(bus, 0);
+		if (dev) {
+			printk("Found new wifi\n");
+			if (pci_bus_add_device(dev))
+				printk(KERN_WARNING "Unable to add wifi\n");
+		}
+	} else {
+		printk("Removing wifi\n");
+		dev = pci_get_slot(bus, 0);
+		if (dev) {
+			pci_remove_bus_device(dev);
+			pci_dev_put(dev);
+		}
+	}
+}
+
 static void eeepc_hotk_notify(acpi_handle handle, u32 event, void *data)
 {
 	static struct key_entry *key;
@@ -604,6 +635,18 @@ static int eeepc_hotk_add(struct acpi_device *device)
 		rfkill_register(ehotk->eeepc_bluetooth_rfkill);
 	}
 
+	status = acpi_get_handle(NULL, "\\_SB.PCI0.P0P7", ehotk->rfkill_handle);
+
+	if (ACPI_FAILURE(status)) {
+		printk(KERN_WARNING "Unable to find rfkill port handle\n");
+		goto end;
+	}
+
+	status = acpi_install_notify_handler(ehotk->rfkill_handle,
+					     ACPI_SYSTEM_NOTIFY,
+					     eeepc_rfkill_notify, NULL);
+	if (ACPI_FAILURE(status))
+		printk(KERN_WARNING "Unable to register rfkill notifier\n");
  end:
 	if (result) {
 		kfree(ehotk);
@@ -622,6 +665,10 @@ static int eeepc_hotk_remove(struct acpi_device *device, int type)
 					    eeepc_hotk_notify);
 	if (ACPI_FAILURE(status))
 		printk(EEEPC_ERR "Error removing notify handler\n");
+	status = acpi_remove_notify_handler(ehotk->handle, ACPI_SYSTEM_NOTIFY,
+					    eeepc_rfkill_notify);
+	if (ACPI_FAILURE(status))
+		printk(EEEPC_ERR "Error removing rfkill notify handler\n");
 	kfree(ehotk);
 	return 0;
 }

-- 
Matthew Garrett | mjg59@srcf.ucam.org
