Return-Path: <linux-kernel-owner+w=401wt.eu-S1756609AbYKTPha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609AbYKTPha (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 10:37:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755479AbYKTPhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 10:37:14 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:55956 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755368AbYKTPhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 10:37:12 -0500
Date: Thu, 20 Nov 2008 15:37:08 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: linux-kernel@vger.kernel.org
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Corentin Chary <corentin.chary@gmail.com>, ecc@cmu.edu,
       linux acpi <linux-acpi@vger.kernel.org>
Subject: [PATCH v2 2/3] eeepc-laptop: Check return values from rfkill_register
Message-ID: <2147b3d5605abb42f46c35709fede3a80d91d455.1227194932.git.mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a26244bd6e7cae264155edca7f3c22f8f319b239.1227194932.git.mjg@redhat.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Error out if rfkill registration fails, and also set the default system state
appropriately on boot

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---

Includes Alan's suggested cleanup for the failure path

 drivers/misc/eeepc-laptop.c |   51 +++++++++++++++++++++++++++++++-----------
 1 files changed, 37 insertions(+), 14 deletions(-)

diff --git a/drivers/misc/eeepc-laptop.c b/drivers/misc/eeepc-laptop.c
index e81ef18..3de44fb 100644
--- a/drivers/misc/eeepc-laptop.c
+++ b/drivers/misc/eeepc-laptop.c
@@ -562,7 +562,7 @@ static int eeepc_hotk_add(struct acpi_device *device)
 	ehotk->device = device;
 	result = eeepc_hotk_check();
 	if (result)
-		goto end;
+		goto ehotk_fail;
 	status = acpi_install_notify_handler(ehotk->handle, ACPI_SYSTEM_NOTIFY,
 					     eeepc_hotk_notify, ehotk);
 	if (ACPI_FAILURE(status))
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
@@ -592,27 +599,43 @@ static int eeepc_hotk_add(struct acpi_device *device)
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
+
+ bluetooth_fail:
+	if (ehotk->eeepc_bluetooth_rfkill)
+		rfkill_free(ehotk->eeepc_bluetooth_rfkill);
+	rfkill_unregister(ehotk->eeepc_wlan_rfkill);
+	ehotk->eeepc_wlan_rfkill = NULL;
+ wlan_fail:
+	if (ehotk->eeepc_wlan_rfkill)
+		rfkill_free(ehotk->eeepc_wlan_rfkill);
+ ehotk_fail:
+	kfree(ehotk);
+	ehotk = NULL;
 
- end:
-	if (result) {
-		kfree(ehotk);
-		ehotk = NULL;
-	}
 	return result;
 }
 
-- 
Matthew Garrett | mjg59@srcf.ucam.org
