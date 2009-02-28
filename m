Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132AbZB1MUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbZB1MUq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 07:20:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbZB1MUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 07:20:38 -0500
Received: from hpsmtp-eml16.KPNXCHANGE.COM ([213.75.38.116]:13751 "EHLO
	hpsmtp-eml16.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751936AbZB1MUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 07:20:38 -0500
From: Frans Pop <elendil@planet.nl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: hp-wmi: notify of a potential docking state change on resume
Date: Sat, 28 Feb 2009 13:20:33 +0100
User-Agent: KMail/1.9.9
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200902281320.34356.elendil@planet.nl>
X-OriginalArrivalTime: 28 Feb 2009 12:20:34.0495 (UTC) FILETIME=[F4A29CF0:01C9999E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible that the system gets docked or undocked while it's
suspended. Generate an input event on resume to notify user space
if there was a state change.

As it is a switch, we can generate the event unconditionally; the
input layer will only pass it on if there is an actual change.
    
Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
---
Works for my HP 2510p.

Is there maybe a way to avoid the loop over the hp_wmi_keymap?
I did not see any.


diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index 32eeca6..ded59fb 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -53,6 +53,7 @@ MODULE_ALIAS("wmi:5FB7F034-2C63-45e9-BE91-3D44E2C707E4");
 
 static int __init hp_wmi_bios_setup(struct platform_device *device);
 static int __exit hp_wmi_bios_remove(struct platform_device *device);
+static int hp_wmi_resume_handler(struct platform_device *device);
 
 struct bios_args {
 	u32 signature;
@@ -101,6 +102,7 @@ static struct platform_driver hp_wmi_driver = {
 	},
 	.probe = hp_wmi_bios_setup,
 	.remove = hp_wmi_bios_remove,
+	.resume = hp_wmi_resume_handler,
 };
 
 static int hp_wmi_perform_query(int query, int write, int value)
@@ -489,6 +491,29 @@ static int __exit hp_wmi_bios_remove(struct platform_device *device)
 	return 0;
 }
 
+static int hp_wmi_resume_handler(struct platform_device *device)
+{
+	struct key_entry *key;
+
+	/*
+	 * Docking state may have changed while suspended, so trigger
+	 * an input event for the current state. As this is a switch,
+	 * the input layer will only actually pass it on if the state
+	 * changed.
+	 */
+	for (key = hp_wmi_keymap; key->type != KE_END; key++) {
+		switch (key->type) {
+		case KE_SW:
+			input_report_switch(hp_wmi_input_dev, key->keycode,
+					    hp_wmi_dock_state());
+			input_sync(hp_wmi_input_dev);
+			break;
+		}
+	}
+
+	return 0;
+}
+
 static int __init hp_wmi_init(void)
 {
 	int err;
