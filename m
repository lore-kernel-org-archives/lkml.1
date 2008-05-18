Return-Path: <linux-kernel-owner+w=401wt.eu-S1760114AbYERSzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760114AbYERSzg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759901AbYERSsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:48:21 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:54086 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760550AbYERSsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:48:13 -0400
X-Sasl-enc: 7prWPU0iAUk72jnQcxSV1XHknnORs3ryeUXmn7sc9n52 1211136490
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org
Cc: Ivo van Doorn <IvDoorn@gmail.com>, Thomas Renninger <trenn@suse.de>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: [PATCH 01/15] ACPI: thinkpad-acpi: fix initialization error paths
Date: Sun, 18 May 2008 15:47:51 -0300
Message-Id: <1211136485-19878-2-git-send-email-hmh@hmh.eng.br>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br>
References: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rework some subdriver init and exit handlers, in order to fix some
initialization error paths that were missing, or broken.

Hitting those bugs should be extremely rare in the real world, but should
that happen, thinkpad-acpi would fail to dealocate some resources and a
reboot might well be needed to be able to load the driver again.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
---
 drivers/misc/thinkpad_acpi.c |  435 ++++++++++++++++++++++--------------------
 1 files changed, 229 insertions(+), 206 deletions(-)

diff --git a/drivers/misc/thinkpad_acpi.c b/drivers/misc/thinkpad_acpi.c
index 3f28f6e..3c53668 100644
--- a/drivers/misc/thinkpad_acpi.c
+++ b/drivers/misc/thinkpad_acpi.c
@@ -1921,6 +1921,29 @@ static struct attribute *hotkey_mask_attributes[] __initdata = {
 	&dev_attr_hotkey_wakeup_hotunplug_complete.attr,
 };
 
+static void hotkey_exit(void)
+{
+#ifdef CONFIG_THINKPAD_ACPI_HOTKEY_POLL
+	hotkey_poll_stop_sync();
+#endif
+
+	if (hotkey_dev_attributes)
+		delete_attr_set(hotkey_dev_attributes, &tpacpi_pdev->dev.kobj);
+
+	kfree(hotkey_keycode_map);
+
+	if (tp_features.hotkey) {
+		dbg_printk(TPACPI_DBG_EXIT,
+			   "restoring original hot key mask\n");
+		/* no short-circuit boolean operator below! */
+		if ((hotkey_mask_set(hotkey_orig_mask) |
+		     hotkey_status_set(hotkey_orig_status)) != 0)
+			printk(TPACPI_ERR
+			       "failed to restore hot key mask "
+			       "to BIOS defaults\n");
+	}
+}
+
 static int __init hotkey_init(struct ibm_init_struct *iibm)
 {
 	/* Requirements for changing the default keymaps:
@@ -2060,226 +2083,220 @@ static int __init hotkey_init(struct ibm_init_struct *iibm)
 	vdbg_printk(TPACPI_DBG_INIT, "hotkeys are %s\n",
 		str_supported(tp_features.hotkey));
 
-	if (tp_features.hotkey) {
-		hotkey_dev_attributes = create_attr_set(13, NULL);
-		if (!hotkey_dev_attributes)
-			return -ENOMEM;
-		res = add_many_to_attr_set(hotkey_dev_attributes,
-				hotkey_attributes,
-				ARRAY_SIZE(hotkey_attributes));
-		if (res)
-			return res;
+	if (!tp_features.hotkey)
+		return 1;
 
-		/* mask not supported on 570, 600e/x, 770e, 770x, A21e, A2xm/p,
-		   A30, R30, R31, T20-22, X20-21, X22-24.  Detected by checking
-		   for HKEY interface version 0x100 */
-		if (acpi_evalf(hkey_handle, &hkeyv, "MHKV", "qd")) {
-			if ((hkeyv >> 8) != 1) {
-				printk(TPACPI_ERR "unknown version of the "
-				       "HKEY interface: 0x%x\n", hkeyv);
-				printk(TPACPI_ERR "please report this to %s\n",
-				       TPACPI_MAIL);
-			} else {
-				/*
-				 * MHKV 0x100 in A31, R40, R40e,
-				 * T4x, X31, and later
-				 */
-				tp_features.hotkey_mask = 1;
-			}
+	hotkey_dev_attributes = create_attr_set(13, NULL);
+	if (!hotkey_dev_attributes)
+		return -ENOMEM;
+	res = add_many_to_attr_set(hotkey_dev_attributes,
+			hotkey_attributes,
+			ARRAY_SIZE(hotkey_attributes));
+	if (res)
+		goto err_exit;
+
+	/* mask not supported on 570, 600e/x, 770e, 770x, A21e, A2xm/p,
+	   A30, R30, R31, T20-22, X20-21, X22-24.  Detected by checking
+	   for HKEY interface version 0x100 */
+	if (acpi_evalf(hkey_handle, &hkeyv, "MHKV", "qd")) {
+		if ((hkeyv >> 8) != 1) {
+			printk(TPACPI_ERR "unknown version of the "
+			       "HKEY interface: 0x%x\n", hkeyv);
+			printk(TPACPI_ERR "please report this to %s\n",
+			       TPACPI_MAIL);
+		} else {
+			/*
+			 * MHKV 0x100 in A31, R40, R40e,
+			 * T4x, X31, and later
+			 */
+			tp_features.hotkey_mask = 1;
 		}
+	}
 
-		vdbg_printk(TPACPI_DBG_INIT, "hotkey masks are %s\n",
-			str_supported(tp_features.hotkey_mask));
+	vdbg_printk(TPACPI_DBG_INIT, "hotkey masks are %s\n",
+		str_supported(tp_features.hotkey_mask));
 
-		if (tp_features.hotkey_mask) {
-			if (!acpi_evalf(hkey_handle, &hotkey_all_mask,
-					"MHKA", "qd")) {
-				printk(TPACPI_ERR
-				       "missing MHKA handler, "
-				       "please report this to %s\n",
-				       TPACPI_MAIL);
-				/* FN+F12, FN+F4, FN+F3 */
-				hotkey_all_mask = 0x080cU;
-			}
+	if (tp_features.hotkey_mask) {
+		if (!acpi_evalf(hkey_handle, &hotkey_all_mask,
+				"MHKA", "qd")) {
+			printk(TPACPI_ERR
+			       "missing MHKA handler, "
+			       "please report this to %s\n",
+			       TPACPI_MAIL);
+			/* FN+F12, FN+F4, FN+F3 */
+			hotkey_all_mask = 0x080cU;
 		}
+	}
 
-		/* hotkey_source_mask *must* be zero for
-		 * the first hotkey_mask_get */
-		res = hotkey_status_get(&hotkey_orig_status);
-		if (!res && tp_features.hotkey_mask) {
-			res = hotkey_mask_get();
-			hotkey_orig_mask = hotkey_mask;
-			if (!res) {
-				res = add_many_to_attr_set(
-					hotkey_dev_attributes,
-					hotkey_mask_attributes,
-					ARRAY_SIZE(hotkey_mask_attributes));
-			}
-		}
+	/* hotkey_source_mask *must* be zero for
+	 * the first hotkey_mask_get */
+	res = hotkey_status_get(&hotkey_orig_status);
+	if (res)
+		goto err_exit;
+
+	if (tp_features.hotkey_mask) {
+		res = hotkey_mask_get();
+		if (res)
+			goto err_exit;
+
+		hotkey_orig_mask = hotkey_mask;
+		res = add_many_to_attr_set(
+				hotkey_dev_attributes,
+				hotkey_mask_attributes,
+				ARRAY_SIZE(hotkey_mask_attributes));
+		if (res)
+			goto err_exit;
+	}
 
 #ifdef CONFIG_THINKPAD_ACPI_HOTKEY_POLL
-		if (tp_features.hotkey_mask) {
-			hotkey_source_mask = TPACPI_HKEY_NVRAM_GOOD_MASK
-						& ~hotkey_all_mask;
-		} else {
-			hotkey_source_mask = TPACPI_HKEY_NVRAM_GOOD_MASK;
-		}
+	if (tp_features.hotkey_mask) {
+		hotkey_source_mask = TPACPI_HKEY_NVRAM_GOOD_MASK
+					& ~hotkey_all_mask;
+	} else {
+		hotkey_source_mask = TPACPI_HKEY_NVRAM_GOOD_MASK;
+	}
 
-		vdbg_printk(TPACPI_DBG_INIT,
-			    "hotkey source mask 0x%08x, polling freq %d\n",
-			    hotkey_source_mask, hotkey_poll_freq);
+	vdbg_printk(TPACPI_DBG_INIT,
+		    "hotkey source mask 0x%08x, polling freq %d\n",
+		    hotkey_source_mask, hotkey_poll_freq);
 #endif
 
-		/* Not all thinkpads have a hardware radio switch */
-		if (!res && acpi_evalf(hkey_handle, &status, "WLSW", "qd")) {
-			tp_features.hotkey_wlsw = 1;
-			printk(TPACPI_INFO
-				"radio switch found; radios are %s\n",
-				enabled(status, 0));
-			res = add_to_attr_set(hotkey_dev_attributes,
-					&dev_attr_hotkey_radio_sw.attr);
-		}
+	/* Not all thinkpads have a hardware radio switch */
+	if (acpi_evalf(hkey_handle, &status, "WLSW", "qd")) {
+		tp_features.hotkey_wlsw = 1;
+		printk(TPACPI_INFO
+			"radio switch found; radios are %s\n",
+			enabled(status, 0));
+		res = add_to_attr_set(hotkey_dev_attributes,
+				&dev_attr_hotkey_radio_sw.attr);
+	}
 
-		/* For X41t, X60t, X61t Tablets... */
-		if (!res && acpi_evalf(hkey_handle, &status, "MHKG", "qd")) {
-			tp_features.hotkey_tablet = 1;
-			printk(TPACPI_INFO
-				"possible tablet mode switch found; "
-				"ThinkPad in %s mode\n",
-				(status & TP_HOTKEY_TABLET_MASK)?
-					"tablet" : "laptop");
-			res = add_to_attr_set(hotkey_dev_attributes,
-					&dev_attr_hotkey_tablet_mode.attr);
-		}
+	/* For X41t, X60t, X61t Tablets... */
+	if (!res && acpi_evalf(hkey_handle, &status, "MHKG", "qd")) {
+		tp_features.hotkey_tablet = 1;
+		printk(TPACPI_INFO
+			"possible tablet mode switch found; "
+			"ThinkPad in %s mode\n",
+			(status & TP_HOTKEY_TABLET_MASK)?
+				"tablet" : "laptop");
+		res = add_to_attr_set(hotkey_dev_attributes,
+				&dev_attr_hotkey_tablet_mode.attr);
+	}
 
-		if (!res)
-			res = register_attr_set_with_sysfs(
-					hotkey_dev_attributes,
-					&tpacpi_pdev->dev.kobj);
-		if (res)
-			return res;
+	if (!res)
+		res = register_attr_set_with_sysfs(
+				hotkey_dev_attributes,
+				&tpacpi_pdev->dev.kobj);
+	if (res)
+		goto err_exit;
 
-		/* Set up key map */
+	/* Set up key map */
 
-		hotkey_keycode_map = kmalloc(TPACPI_HOTKEY_MAP_SIZE,
-						GFP_KERNEL);
-		if (!hotkey_keycode_map) {
-			printk(TPACPI_ERR
-				"failed to allocate memory for key map\n");
-			return -ENOMEM;
-		}
+	hotkey_keycode_map = kmalloc(TPACPI_HOTKEY_MAP_SIZE,
+					GFP_KERNEL);
+	if (!hotkey_keycode_map) {
+		printk(TPACPI_ERR
+			"failed to allocate memory for key map\n");
+		res = -ENOMEM;
+		goto err_exit;
+	}
 
-		if (thinkpad_id.vendor == PCI_VENDOR_ID_LENOVO) {
-			dbg_printk(TPACPI_DBG_INIT,
-				   "using Lenovo default hot key map\n");
-			memcpy(hotkey_keycode_map, &lenovo_keycode_map,
-				TPACPI_HOTKEY_MAP_SIZE);
+	if (thinkpad_id.vendor == PCI_VENDOR_ID_LENOVO) {
+		dbg_printk(TPACPI_DBG_INIT,
+			   "using Lenovo default hot key map\n");
+		memcpy(hotkey_keycode_map, &lenovo_keycode_map,
+			TPACPI_HOTKEY_MAP_SIZE);
+	} else {
+		dbg_printk(TPACPI_DBG_INIT,
+			   "using IBM default hot key map\n");
+		memcpy(hotkey_keycode_map, &ibm_keycode_map,
+			TPACPI_HOTKEY_MAP_SIZE);
+	}
+
+	set_bit(EV_KEY, tpacpi_inputdev->evbit);
+	set_bit(EV_MSC, tpacpi_inputdev->evbit);
+	set_bit(MSC_SCAN, tpacpi_inputdev->mscbit);
+	tpacpi_inputdev->keycodesize = TPACPI_HOTKEY_MAP_TYPESIZE;
+	tpacpi_inputdev->keycodemax = TPACPI_HOTKEY_MAP_LEN;
+	tpacpi_inputdev->keycode = hotkey_keycode_map;
+	for (i = 0; i < TPACPI_HOTKEY_MAP_LEN; i++) {
+		if (hotkey_keycode_map[i] != KEY_RESERVED) {
+			set_bit(hotkey_keycode_map[i],
+				tpacpi_inputdev->keybit);
 		} else {
-			dbg_printk(TPACPI_DBG_INIT,
-				   "using IBM default hot key map\n");
-			memcpy(hotkey_keycode_map, &ibm_keycode_map,
-				TPACPI_HOTKEY_MAP_SIZE);
-		}
-
-		set_bit(EV_KEY, tpacpi_inputdev->evbit);
-		set_bit(EV_MSC, tpacpi_inputdev->evbit);
-		set_bit(MSC_SCAN, tpacpi_inputdev->mscbit);
-		tpacpi_inputdev->keycodesize = TPACPI_HOTKEY_MAP_TYPESIZE;
-		tpacpi_inputdev->keycodemax = TPACPI_HOTKEY_MAP_LEN;
-		tpacpi_inputdev->keycode = hotkey_keycode_map;
-		for (i = 0; i < TPACPI_HOTKEY_MAP_LEN; i++) {
-			if (hotkey_keycode_map[i] != KEY_RESERVED) {
-				set_bit(hotkey_keycode_map[i],
-					tpacpi_inputdev->keybit);
-			} else {
-				if (i < sizeof(hotkey_reserved_mask)*8)
-					hotkey_reserved_mask |= 1 << i;
-			}
-		}
-
-		if (tp_features.hotkey_wlsw) {
-			set_bit(EV_SW, tpacpi_inputdev->evbit);
-			set_bit(SW_RADIO, tpacpi_inputdev->swbit);
-		}
-		if (tp_features.hotkey_tablet) {
-			set_bit(EV_SW, tpacpi_inputdev->evbit);
-			set_bit(SW_TABLET_MODE, tpacpi_inputdev->swbit);
+			if (i < sizeof(hotkey_reserved_mask)*8)
+				hotkey_reserved_mask |= 1 << i;
 		}
+	}
 
-		/* Do not issue duplicate brightness change events to
-		 * userspace */
-		if (!tp_features.bright_acpimode)
-			/* update bright_acpimode... */
-			tpacpi_check_std_acpi_brightness_support();
-
-		if (tp_features.bright_acpimode) {
-			printk(TPACPI_INFO
-			       "This ThinkPad has standard ACPI backlight "
-			       "brightness control, supported by the ACPI "
-			       "video driver\n");
-			printk(TPACPI_NOTICE
-			       "Disabling thinkpad-acpi brightness events "
-			       "by default...\n");
-
-			/* The hotkey_reserved_mask change below is not
-			 * necessary while the keys are at KEY_RESERVED in the
-			 * default map, but better safe than sorry, leave it
-			 * here as a marker of what we have to do, especially
-			 * when we finally become able to set this at runtime
-			 * on response to X.org requests */
-			hotkey_reserved_mask |=
-				(1 << TP_ACPI_HOTKEYSCAN_FNHOME)
-				| (1 << TP_ACPI_HOTKEYSCAN_FNEND);
-		}
+	if (tp_features.hotkey_wlsw) {
+		set_bit(EV_SW, tpacpi_inputdev->evbit);
+		set_bit(SW_RADIO, tpacpi_inputdev->swbit);
+	}
+	if (tp_features.hotkey_tablet) {
+		set_bit(EV_SW, tpacpi_inputdev->evbit);
+		set_bit(SW_TABLET_MODE, tpacpi_inputdev->swbit);
+	}
 
-		dbg_printk(TPACPI_DBG_INIT,
-				"enabling hot key handling\n");
-		res = hotkey_status_set(1);
-		if (res)
-			return res;
-		res = hotkey_mask_set(((hotkey_all_mask | hotkey_source_mask)
-					& ~hotkey_reserved_mask)
-					| hotkey_orig_mask);
-		if (res < 0 && res != -ENXIO)
-			return res;
+	/* Do not issue duplicate brightness change events to
+	 * userspace */
+	if (!tp_features.bright_acpimode)
+		/* update bright_acpimode... */
+		tpacpi_check_std_acpi_brightness_support();
 
-		dbg_printk(TPACPI_DBG_INIT,
-				"legacy hot key reporting over procfs %s\n",
-				(hotkey_report_mode < 2) ?
-					"enabled" : "disabled");
+	if (tp_features.bright_acpimode) {
+		printk(TPACPI_INFO
+		       "This ThinkPad has standard ACPI backlight "
+		       "brightness control, supported by the ACPI "
+		       "video driver\n");
+		printk(TPACPI_NOTICE
+		       "Disabling thinkpad-acpi brightness events "
+		       "by default...\n");
+
+		/* The hotkey_reserved_mask change below is not
+		 * necessary while the keys are at KEY_RESERVED in the
+		 * default map, but better safe than sorry, leave it
+		 * here as a marker of what we have to do, especially
+		 * when we finally become able to set this at runtime
+		 * on response to X.org requests */
+		hotkey_reserved_mask |=
+			(1 << TP_ACPI_HOTKEYSCAN_FNHOME)
+			| (1 << TP_ACPI_HOTKEYSCAN_FNEND);
+	}
+
+	dbg_printk(TPACPI_DBG_INIT, "enabling hot key handling\n");
+	res = hotkey_status_set(1);
+	if (res) {
+		hotkey_exit();
+		return res;
+	}
+	res = hotkey_mask_set(((hotkey_all_mask | hotkey_source_mask)
+				& ~hotkey_reserved_mask)
+				| hotkey_orig_mask);
+	if (res < 0 && res != -ENXIO) {
+		hotkey_exit();
+		return res;
+	}
 
-		tpacpi_inputdev->open = &hotkey_inputdev_open;
-		tpacpi_inputdev->close = &hotkey_inputdev_close;
+	dbg_printk(TPACPI_DBG_INIT,
+			"legacy hot key reporting over procfs %s\n",
+			(hotkey_report_mode < 2) ?
+				"enabled" : "disabled");
 
-		hotkey_poll_setup_safe(1);
-		tpacpi_input_send_radiosw();
-		tpacpi_input_send_tabletsw();
-	}
+	tpacpi_inputdev->open = &hotkey_inputdev_open;
+	tpacpi_inputdev->close = &hotkey_inputdev_close;
 
-	return (tp_features.hotkey)? 0 : 1;
-}
+	hotkey_poll_setup_safe(1);
+	tpacpi_input_send_radiosw();
+	tpacpi_input_send_tabletsw();
 
-static void hotkey_exit(void)
-{
-#ifdef CONFIG_THINKPAD_ACPI_HOTKEY_POLL
-	hotkey_poll_stop_sync();
-#endif
+	return 0;
 
-	if (tp_features.hotkey) {
-		dbg_printk(TPACPI_DBG_EXIT,
-			   "restoring original hot key mask\n");
-		/* no short-circuit boolean operator below! */
-		if ((hotkey_mask_set(hotkey_orig_mask) |
-		     hotkey_status_set(hotkey_orig_status)) != 0)
-			printk(TPACPI_ERR
-			       "failed to restore hot key mask "
-			       "to BIOS defaults\n");
-	}
+err_exit:
+	delete_attr_set(hotkey_dev_attributes, &tpacpi_pdev->dev.kobj);
+	hotkey_dev_attributes = NULL;
 
-	if (hotkey_dev_attributes) {
-		delete_attr_set(hotkey_dev_attributes, &tpacpi_pdev->dev.kobj);
-		hotkey_dev_attributes = NULL;
-	}
+	return (res < 0)? res : 1;
 }
 
 static void hotkey_notify(struct ibm_struct *ibm, u32 event)
@@ -3319,7 +3336,7 @@ static struct tpacpi_led_classdev tpacpi_led_thinklight = {
 
 static int __init light_init(struct ibm_init_struct *iibm)
 {
-	int rc = 0;
+	int rc;
 
 	vdbg_printk(TPACPI_DBG_INIT, "initializing light subdriver\n");
 
@@ -3337,20 +3354,23 @@ static int __init light_init(struct ibm_init_struct *iibm)
 		tp_features.light_status =
 			acpi_evalf(ec_handle, NULL, "KBLT", "qv");
 
-	vdbg_printk(TPACPI_DBG_INIT, "light is %s\n",
-		str_supported(tp_features.light));
+	vdbg_printk(TPACPI_DBG_INIT, "light is %s, light status is %s\n",
+		str_supported(tp_features.light),
+		str_supported(tp_features.light_status));
 
-	if (tp_features.light) {
-		rc = led_classdev_register(&tpacpi_pdev->dev,
-					   &tpacpi_led_thinklight.led_classdev);
-	}
+	if (!tp_features.light)
+		return 1;
+
+	rc = led_classdev_register(&tpacpi_pdev->dev,
+				   &tpacpi_led_thinklight.led_classdev);
 
 	if (rc < 0) {
 		tp_features.light = 0;
 		tp_features.light_status = 0;
-	} else {
-		rc = (tp_features.light)? 0 : 1;
+	} else  {
+		rc = 0;
 	}
+
 	return rc;
 }
 
@@ -3978,7 +3998,6 @@ static void led_exit(void)
 	}
 
 	kfree(tpacpi_leds);
-	tpacpi_leds = NULL;
 }
 
 static int __init led_init(struct ibm_init_struct *iibm)
@@ -4802,7 +4821,6 @@ static void brightness_exit(void)
 		vdbg_printk(TPACPI_DBG_EXIT,
 			    "calling backlight_device_unregister()\n");
 		backlight_device_unregister(ibm_backlight_device);
-		ibm_backlight_device = NULL;
 	}
 }
 
@@ -5764,11 +5782,16 @@ static int __init fan_init(struct ibm_init_struct *iibm)
 	    fan_control_access_mode != TPACPI_FAN_WR_NONE) {
 		rc = sysfs_create_group(&tpacpi_sensors_pdev->dev.kobj,
 					 &fan_attr_group);
-		if (!(rc < 0))
-			rc = driver_create_file(&tpacpi_hwmon_pdriver.driver,
-					&driver_attr_fan_watchdog);
 		if (rc < 0)
 			return rc;
+
+		rc = driver_create_file(&tpacpi_hwmon_pdriver.driver,
+					&driver_attr_fan_watchdog);
+		if (rc < 0) {
+			sysfs_remove_group(&tpacpi_sensors_pdev->dev.kobj,
+					&fan_attr_group);
+			return rc;
+		}
 		return 0;
 	} else
 		return 1;
-- 
1.5.5.1

