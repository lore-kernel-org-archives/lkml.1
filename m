Return-Path: <linux-kernel-owner+w=401wt.eu-S1753168AbYKQNiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbYKQNiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 08:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbYKQNiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 08:38:11 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:40888 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbYKQNiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 08:38:10 -0500
Date: Mon, 17 Nov 2008 13:38:04 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Corentin Chary <corentin.chary@gmail.com>, ecc@cmu.edu
Cc: linux acpi <linux-acpi@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: [Patch 2/3] eeepc-laptop: Check return values from rfkill_register
Message-ID: <20081117133804.GD12303@srcf.ucam.org>
References: <20081117133325.GB12303@srcf.ucam.org> <20081117133510.GC12303@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081117133510.GC12303@srcf.ucam.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should check that rfkill registration succeeds and error out if it 
doesn't. This patch also sets the default state to match the BIOS on 
load.

Signed-off-by: Matthew Garrett <mjg@redhat.com>

diff --git a/drivers/misc/eeepc-laptop.c b/drivers/misc/eeepc-laptop.c
index e81ef18..4d70626 100644
--- a/drivers/misc/eeepc-laptop.c
+++ b/drivers/misc/eeepc-laptop.c
@@ -573,18 +573,25 @@ static int eeepc_hotk_add(struct acpi_device *device)
 							   RFKILL_TYPE_WLAN);
 
 		if (!ehotk->eeepc_wlan_rfkill)
-			goto end;
+			goto wlan_fail;
 
 		ehotk->eeepc_wlan_rfkill->name = "eeepc-wlan";
 		ehotk->eeepc_wlan_rfkill->toggle_radio = eeepc_wlan_rfkill_set;
 		ehotk->eeepc_wlan_rfkill->get_state = eeepc_wlan_rfkill_state;
-		if (get_acpi(CM_ASL_WLAN) == 1)
+		if (get_acpi(CM_ASL_WLAN) == 1) {
 			ehotk->eeepc_wlan_rfkill->state =
 				RFKILL_STATE_UNBLOCKED;
-		else
+			rfkill_set_default(RFKILL_TYPE_WLAN,
+					   RFKILL_STATE_UNBLOCKED);
+		} else {
 			ehotk->eeepc_wlan_rfkill->state =
 				RFKILL_STATE_SOFT_BLOCKED;
-		rfkill_register(ehotk->eeepc_wlan_rfkill);
+			rfkill_set_default(RFKILL_TYPE_WLAN,
+					   RFKILL_STATE_SOFT_BLOCKED);
+		}
+		result = rfkill_register(ehotk->eeepc_wlan_rfkill);
+		if (result)
+			goto wlan_fail;
 	}
 
 	if (get_acpi(CM_ASL_BLUETOOTH) != -1) {
@@ -592,22 +599,39 @@ static int eeepc_hotk_add(struct acpi_device *device)
 			rfkill_allocate(&device->dev, RFKILL_TYPE_BLUETOOTH);
 
 		if (!ehotk->eeepc_bluetooth_rfkill)
-			goto end;
+			goto bluetooth_fail;
 
 		ehotk->eeepc_bluetooth_rfkill->name = "eeepc-bluetooth";
 		ehotk->eeepc_bluetooth_rfkill->toggle_radio =
 			eeepc_bluetooth_rfkill_set;
 		ehotk->eeepc_bluetooth_rfkill->get_state =
 			eeepc_bluetooth_rfkill_state;
-		if (get_acpi(CM_ASL_BLUETOOTH) == 1)
+		if (get_acpi(CM_ASL_BLUETOOTH) == 1) {
 			ehotk->eeepc_bluetooth_rfkill->state =
 				RFKILL_STATE_UNBLOCKED;
-		else
+			rfkill_set_default(RFKILL_TYPE_BLUETOOTH,
+					   RFKILL_STATE_UNBLOCKED);
+		} else {
 			ehotk->eeepc_bluetooth_rfkill->state =
 				RFKILL_STATE_SOFT_BLOCKED;
-		rfkill_register(ehotk->eeepc_bluetooth_rfkill);
+			rfkill_set_default(RFKILL_TYPE_BLUETOOTH,
+					   RFKILL_STATE_SOFT_BLOCKED);
+		}
+
+		result = rfkill_register(ehotk->eeepc_bluetooth_rfkill);
+		if (result)
+			goto bluetooth_fail;
 	}
+	return 0;
 
+ bluetooth_fail:
+	if (ehotk->eeepc_bluetooth_rfkill)
+		rfkill_free(ehotk->eeepc_bluetooth_rfkill);
+	rfkill_unregister(ehotk->eeepc_wlan_rfkill);
+	ehotk->eeepc_wlan_rfkill = NULL;
+ wlan_fail:
+	if (ehotk->eeepc_wlan_rfkill)
+		rfkill_free(ehotk->eeepc_wlan_rfkill);
  end:
 	if (result) {
 		kfree(ehotk);

-- 
Matthew Garrett | mjg59@srcf.ucam.org
