Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968519Ab0B0PuL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 10:50:11 -0500
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:53799 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968435Ab0B0PuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 10:50:09 -0500
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] toshiba_acpi: fix multimedia keys on Toshiba Sattelite A40
Date: Sat, 27 Feb 2010 16:50:00 +0100
User-Agent: KMail/1.9.9
Cc: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201002271650.01884.elendil@planet.nl>
X-OriginalArrivalTime: 27 Feb 2010 15:50:02.0306 (UTC) FILETIME=[85FF6220:01CAB7C4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 6335e4d56681f6f08f24f4b812a72d402793d393 added hotkey support, but
fails to support the multimedia keys on some Toshiba laptops as they don't
generate key release events.
    
This was previously discussed in http://lkml.org/lkml/2009/4/11/139 and a
solution was found in private mail. The solution is to act on key press
events instead of on key release events.
    
Also remove one level of indentation.
    
Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: Matthew Garrett <mjg@redhat.com>

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 26c2117..56e4556 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -814,21 +814,23 @@ static void toshiba_acpi_notify(acpi_handle handle, u32 event, void *context)
 		if (hci_result == HCI_SUCCESS) {
 			if (value == 0x100)
 				continue;
-			else if (value & 0x80) {
-				key = toshiba_acpi_get_entry_by_scancode
-					(value & ~0x80);
-				if (!key) {
-					printk(MY_INFO "Unknown key %x\n",
-					       value & ~0x80);
-					continue;
-				}
-				input_report_key(toshiba_acpi.hotkey_dev,
-						 key->keycode, 1);
-				input_sync(toshiba_acpi.hotkey_dev);
-				input_report_key(toshiba_acpi.hotkey_dev,
-						 key->keycode, 0);
-				input_sync(toshiba_acpi.hotkey_dev);
+			/* act on key press; ignore key release */
+			if (value & 0x80)
+				continue;
+
+			key = toshiba_acpi_get_entry_by_scancode
+				(value);
+			if (!key) {
+				printk(MY_INFO "Unknown key %x\n",
+				       value);
+				continue;
 			}
+			input_report_key(toshiba_acpi.hotkey_dev,
+					 key->keycode, 1);
+			input_sync(toshiba_acpi.hotkey_dev);
+			input_report_key(toshiba_acpi.hotkey_dev,
+					 key->keycode, 0);
+			input_sync(toshiba_acpi.hotkey_dev);
 		} else if (hci_result == HCI_NOT_SUPPORTED) {
 			/* This is a workaround for an unresolved issue on
 			 * some machines where system events sporadically
