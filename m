Return-Path: <linux-kernel-owner+w=401wt.eu-S1755481Ab0A0Pm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab0A0Pm6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 10:42:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755106Ab0A0Pm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 10:42:57 -0500
Received: from mail.codesourcery.com ([38.113.113.100]:52851 "EHLO
	mail.codesourcery.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865Ab0A0Pm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 10:42:56 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Jan 2010 10:42:56 EST
Subject: [PATCH] EeePC 1005PE rfkill fix
From: Paul Brook <paul@codesourcery.com>
Organization: CodeSourcery
To: acpi4asus-user@lists.sourceforge.net
Cc: Corentin Chary <corentincj@iksaif.net>, linux-kernel@vger.kernel.org
Date: Wed, 27 Jan 2010 15:35:27 +0000
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201001271535.27449.paul@codesourcery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The EeePC 1005PE has the wireless card on PCI bus 2.

Signed-off-by: Paul Brook <paul@codesourcery.com>
---

I couldn't figure out a smart way of figuring out the correct bus, so I 
hardcoded the device name. lspci and acpi dumps available at 
http://www.pbrook80.webspace.virginmedia.com/

My guess is that the 1005HA is configured similarly, however I don't have 
hardware to test. The preceding comments imply that the 1005HA does not 
require the pci hotplug bits. On my 1005PE the hotplug bits are definitely 
required (the device stops responding when the rfkill is activated), we just 
need to make sure we disable the right bus. PCI bus 1 contains the wired 
Ethernet controller.

 drivers/platform/x86/eeepc-laptop.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-
laptop.c
index e2be6bb..6b53701 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -161,6 +161,7 @@ struct eeepc_laptop {
 					   by this BIOS */
 	bool cpufv_disabled;
 	bool hotplug_disabled;
+	int hotplug_bus;
 	u16 event_count[128];		/* count for each event */
 
 	struct platform_device *platform_device;
@@ -585,9 +586,10 @@ static void eeepc_rfkill_hotplug(struct eeepc_laptop 
*eeepc)
 	mutex_lock(&eeepc->hotplug_lock);
 
 	if (eeepc->hotplug_slot) {
-		bus = pci_find_bus(0, 1);
+		bus = pci_find_bus(0, eeepc->hotplug_bus);
 		if (!bus) {
-			pr_warning("Unable to find PCI bus 1?\n");
+			pr_warning("Unable to find PCI bus %d?\n",
+				   eeepc->hotplug_bus);
 			goto out_unlock;
 		}
 
@@ -695,7 +697,7 @@ static struct hotplug_slot_ops eeepc_hotplug_slot_ops = {
 static int eeepc_setup_pci_hotplug(struct eeepc_laptop *eeepc)
 {
 	int ret = -ENOMEM;
-	struct pci_bus *bus = pci_find_bus(0, 1);
+	struct pci_bus *bus = pci_find_bus(0, eeepc->hotplug_bus);
 
 	if (!bus) {
 		pr_err("Unable to find wifi PCI bus\n");
@@ -1281,6 +1283,13 @@ static void eeepc_dmi_check(struct eeepc_laptop *eeepc)
 		eeepc->hotplug_disabled = true;
 		pr_info("wlan hotplug disabled\n");
 	}
+
+	/* The eeepc 1005PE has the wireless chip on the second PCI bus 2.  */
+	if (strcmp(model, "1005PE") == 0) {
+	    eeepc->hotplug_bus = 2;
+	} else {
+	    eeepc->hotplug_bus = 1;
+	}
 }
 
 static void cmsg_quirk(struct eeepc_laptop *eeepc, int cm, const char *name)
-- 
1.6.6

