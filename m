Return-Path: <linux-kernel-owner+w=401wt.eu-S934593AbZFLWqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934593AbZFLWqy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 18:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932145AbZFLWot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 18:44:49 -0400
Received: from tichy.grunau.be ([85.131.189.73]:38666 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932504AbZFLWoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 18:44:37 -0400
Date: Sat, 13 Jun 2009 00:33:26 +0200
From: Janne Grunau <j@jannau.net>
To: acpi4asus-user@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Corentin Chary <corentincj@iksaif.net>
Subject: [PATCH 2/2] eeepc-laptop: add rfkill support for the 3G modem in
	Eee PC 901 Go
Message-ID: <20090612223326.GF14878@aniel.lan>
References: <cover.1244845758.git.j@jannau.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1244845758.git.j@jannau.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Janne Grunau <j@jannau.net>
---
 drivers/platform/x86/eeepc-laptop.c |   56 +++++++++++++++++++++++++++++++++++
 1 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index 8d1ecc0..288a4c8 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -132,6 +132,7 @@ struct eeepc_hotk {
 	u16 *keycode_map;
 	struct rfkill *eeepc_wlan_rfkill;
 	struct rfkill *eeepc_bluetooth_rfkill;
+	struct rfkill *eeepc_wwan3g_rfkill;
 	struct hotplug_slot *hotplug_slot;
 };
 
@@ -352,6 +353,23 @@ static void __init eeepc_enable_camera(void)
 	set_acpi(CM_ASL_CAMERA, 1);
 }
 
+static int eeepc_wwan3g_rfkill_set(void *data, enum rfkill_state state)
+{
+	if (state == RFKILL_STATE_SOFT_BLOCKED)
+		return set_acpi(CM_ASL_3G, 0);
+	else
+		return set_acpi(CM_ASL_3G, 1);
+}
+
+static int eeepc_wwan3g_rfkill_state(void *data, enum rfkill_state *state)
+{
+	if (get_acpi(CM_ASL_3G) == 1)
+		*state = RFKILL_STATE_UNBLOCKED;
+	else
+		*state = RFKILL_STATE_SOFT_BLOCKED;
+	return 0;
+}
+
 /*
  * Sys helpers
  */
@@ -869,6 +887,35 @@ static int eeepc_hotk_add(struct acpi_device *device)
 			goto bluetooth_fail;
 	}
 
+	if (get_acpi(CM_ASL_3G) != -1) {
+		ehotk->eeepc_wwan3g_rfkill =
+			rfkill_allocate(&device->dev, RFKILL_TYPE_WWAN);
+
+		if (!ehotk->eeepc_wwan3g_rfkill)
+			goto wwan_fail;
+
+		ehotk->eeepc_wwan3g_rfkill->name = "eeepc-3g";
+		ehotk->eeepc_wwan3g_rfkill->toggle_radio =
+			eeepc_wwan3g_rfkill_set;
+		ehotk->eeepc_wwan3g_rfkill->get_state =
+			eeepc_wwan3g_rfkill_state;
+		if (get_acpi(CM_ASL_3G) == 1) {
+			ehotk->eeepc_wwan3g_rfkill->state =
+				RFKILL_STATE_UNBLOCKED;
+			rfkill_set_default(RFKILL_TYPE_WWAN,
+					   RFKILL_STATE_UNBLOCKED);
+		} else {
+			ehotk->eeepc_wwan3g_rfkill->state =
+				RFKILL_STATE_SOFT_BLOCKED;
+			rfkill_set_default(RFKILL_TYPE_WWAN,
+					   RFKILL_STATE_SOFT_BLOCKED);
+		}
+
+		result = rfkill_register(ehotk->eeepc_wwan3g_rfkill);
+		if (result)
+			goto wwan_fail;
+	}
+
 	result = eeepc_setup_pci_hotplug();
 	/*
 	 * If we get -EBUSY then something else is handling the PCI hotplug -
@@ -882,6 +929,13 @@ static int eeepc_hotk_add(struct acpi_device *device)
 	return 0;
 
  pci_fail:
+	if (ehotk->eeepc_wwan3g_rfkill)
+		rfkill_unregister(ehotk->eeepc_wwan3g_rfkill);
+wwan_fail:
+	if (ehotk->eeepc_wwan3g_rfkill) {
+		rfkill_free(ehotk->eeepc_wwan3g_rfkill);
+		ehotk->eeepc_wwan3g_rfkill = NULL;
+	}
 	if (ehotk->eeepc_bluetooth_rfkill)
 		rfkill_unregister(ehotk->eeepc_bluetooth_rfkill);
  bluetooth_fail:
@@ -1041,6 +1095,8 @@ static void eeepc_rfkill_exit(void)
 		rfkill_unregister(ehotk->eeepc_wlan_rfkill);
 	if (ehotk->eeepc_bluetooth_rfkill)
 		rfkill_unregister(ehotk->eeepc_bluetooth_rfkill);
+	if (ehotk->eeepc_wwan3g_rfkill)
+		rfkill_unregister(ehotk->eeepc_wwan3g_rfkill);
 }
 
 static void eeepc_input_exit(void)
-- 
1.6.0.4
