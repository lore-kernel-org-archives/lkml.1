Return-Path: <linux-kernel-owner+w=401wt.eu-S1754208AbYKBQgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbYKBQgV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 11:36:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754144AbYKBQgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 11:36:10 -0500
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:38400 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753699AbYKBQgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 11:36:09 -0500
Message-ID: <490DD6F6.8000708@lwfinger.net>
Date: Sun, 02 Nov 2008 08:36:06 -0800
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] hp-wmi: Fix warnings
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compilation of the HP WMI hotkeys code results in the following:

  CC [M]  drivers/misc/hp-wmi.o
drivers/misc/hp-wmi.c: In function hp_wmi_bios_setup:
drivers/misc/hp-wmi.c:431: warning: ignoring return value of rfkill_register,
	 declared with attribute warn_unused_result
drivers/misc/hp-wmi.c:441: warning: ignoring return value of rfkill_register,
	 declared with attribute warn_unused_result
drivers/misc/hp-wmi.c:450: warning: ignoring return value of rfkill_register,
	 declared with attribute warn_unused_result

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---


Index: linux-2.6/drivers/misc/hp-wmi.c
===================================================================
--- linux-2.6.orig/drivers/misc/hp-wmi.c
+++ linux-2.6/drivers/misc/hp-wmi.c
@@ -428,7 +428,9 @@ static int __init hp_wmi_bios_setup(stru
 		wifi_rfkill->state = hp_wmi_wifi_state();
 		wifi_rfkill->toggle_radio = hp_wmi_wifi_set;
 		wifi_rfkill->user_claim_unsupported = 1;
-		rfkill_register(wifi_rfkill);
+		err = rfkill_register(wifi_rfkill);
+		if (err)
+			goto add_sysfs_error;
 	}

 	if (wireless & 0x2) {
@@ -438,7 +440,8 @@ static int __init hp_wmi_bios_setup(stru
 		bluetooth_rfkill->state = hp_wmi_bluetooth_state();
 		bluetooth_rfkill->toggle_radio = hp_wmi_bluetooth_set;
 		bluetooth_rfkill->user_claim_unsupported = 1;
-		rfkill_register(bluetooth_rfkill);
+		err = rfkill_register(bluetooth_rfkill);
+			goto register_bluetooth_error;
 	}

 	if (wireless & 0x4) {
@@ -447,10 +450,16 @@ static int __init hp_wmi_bios_setup(stru
 		wwan_rfkill->state = hp_wmi_wwan_state();
 		wwan_rfkill->toggle_radio = hp_wmi_wwan_set;
 		wwan_rfkill->user_claim_unsupported = 1;
-		rfkill_register(wwan_rfkill);
+		err = rfkill_register(wwan_rfkill);
+		if (err)
+			goto register_wwan_err;
 	}

 	return 0;
+register_wwan_err:
+	rfkill_unregister(bluetooth_rfkill);
+register_bluetooth_error:
+	rfkill_unregister(wifi_rfkill);
 add_sysfs_error:
 	cleanup_sysfs(device);
 	return err;


