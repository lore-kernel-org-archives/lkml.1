Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab0BVQEG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 11:04:06 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:47335 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133Ab0BVQEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 11:04:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=tsVtrUbWbNN3kedrGgZeuOmavRmBAwm8WjGMpz/jzNeK+lz7AZhjtEGV3LfYaN9Slw
         Zgpb24LmqiaiQNVlxfhYYe8Q4xQqpvYhaIQMnQ13k5FX9JmSkc3G9G8zkoVpPL7f75jv
         eWaEormIE1gnxKGhQFSC7t08aDAw9INnq9nh4=
Message-ID: <4B82AAEE.9060805@tuffmail.co.uk>
Date: Mon, 22 Feb 2010 16:03:58 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux acpi <linux-acpi@vger.kernel.org>
CC: Corentin Chary <corentin.chary@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] eeepc-laptop: check wireless hotplug events
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before we mark the wireless device as unplugged, check PCI config space
to see whether the wireless device is really disabled (and vice versa).
This works around newer models which don't want the hotplug code, where
we end up disabling the wired network device.

My old 701 still works correctly with this.  I can also simulate an
afflicted model by changing the hardcoded PCI bus/slot number in the
driver, and it seems to work nicely (although it is a bit noisy).

In future this type of hotplug support will be implemented by the PCI
core.  The existing blacklist and the new warning message will be
removed at that point.

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>

diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index 6a47bb7..9a844ca 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -578,6 +578,8 @@ static void eeepc_rfkill_hotplug(struct eeepc_laptop *eeepc)
 	struct pci_dev *dev;
 	struct pci_bus *bus;
 	bool blocked = eeepc_wlan_rfkill_blocked(eeepc);
+	bool absent;
+	u32 l;
 
 	if (eeepc->wlan_rfkill)
 		rfkill_set_sw_state(eeepc->wlan_rfkill, blocked);
@@ -591,6 +593,22 @@ static void eeepc_rfkill_hotplug(struct eeepc_laptop *eeepc)
 			goto out_unlock;
 		}
 
+		if (pci_bus_read_config_dword(bus, 0, PCI_VENDOR_ID, &l)) {
+			pr_err("Unable to read PCI config space?\n");
+			goto out_unlock;
+		}
+		absent = (l == 0xffffffff);
+
+		if (blocked != absent) {
+			pr_warning("BIOS says wireless lan is %s, "
+					"but the pci device is %s\n",
+				blocked ? "blocked" : "unblocked",
+				absent ? "absent" : "present");
+			pr_warning("skipped wireless hotplug as probably "
+					"inappropriate for this model\n");
+			goto out_unlock;
+		}
+
 		if (!blocked) {
 			dev = pci_get_slot(bus, 0);
 			if (dev) {


