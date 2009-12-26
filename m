Return-Path: <linux-kernel-owner+w=401wt.eu-S1757599AbZLZDXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599AbZLZDXZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 22:23:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757457AbZLZDXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 22:23:24 -0500
Received: from mail.perches.com ([173.55.12.10]:1429 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756209AbZLZDXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 22:23:23 -0500
Subject: [PATCH] thinkpad_acpi.c: Remove #define TPACPI_<level>s for printks
From: Joe Perches <joe@perches.com>
To: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>
Cc: Len Brown <len.brown@intel.com>, ibm-acpi-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Dec 2009 19:23:21 -0800
Message-ID: <1261797801.2568.69.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of printk(TPACPI_<level> is unusual.
Make it a bit more kernel normal style.

Add #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
Convert printk(TPACPI_DEBUG fmt to printk(KERN_DEBUG pr_fmt(fmt)
Convert printk(TPACPI_<level> to pr_<level>
Remove multiple #define TPACPI_<level> KERN_<level> TPACPI_LOG
Coalesce long printk formats

Signed-off-by: Joe Perches <joe@perches.com>

 drivers/platform/x86/thinkpad_acpi.c |  422 ++++++++++++----------------------
 1 files changed, 145 insertions(+), 277 deletions(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 448c8ae..45f45a3 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -47,6 +47,8 @@
  *			    thanks to Chris Wright <chrisw@osdl.org>
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -216,17 +218,6 @@ enum tpacpi_hkey_event_t {
 
 #define TPACPI_MAX_ACPI_ARGS 3
 
-/* printk headers */
-#define TPACPI_LOG TPACPI_FILE ": "
-#define TPACPI_EMERG	KERN_EMERG	TPACPI_LOG
-#define TPACPI_ALERT	KERN_ALERT	TPACPI_LOG
-#define TPACPI_CRIT	KERN_CRIT	TPACPI_LOG
-#define TPACPI_ERR	KERN_ERR	TPACPI_LOG
-#define TPACPI_WARN	KERN_WARNING	TPACPI_LOG
-#define TPACPI_NOTICE	KERN_NOTICE	TPACPI_LOG
-#define TPACPI_INFO	KERN_INFO	TPACPI_LOG
-#define TPACPI_DEBUG	KERN_DEBUG	TPACPI_LOG
-
 /* Debugging printk groups */
 #define TPACPI_DBG_ALL		0xffff
 #define TPACPI_DBG_DISCLOSETASK	0x8000
@@ -379,7 +370,7 @@ static int tpacpi_uwb_emulstate;
 
 #define dbg_printk(a_dbg_level, format, arg...) \
 	do { if (dbg_level & (a_dbg_level)) \
-		printk(TPACPI_DEBUG "%s: " format, __func__ , ## arg); \
+		printk(KERN_DEBUG pr_fmt("%s: " format), __func__ , ## arg); \
 	} while (0)
 
 #ifdef CONFIG_THINKPAD_ACPI_DEBUG
@@ -392,8 +383,8 @@ static const char *str_supported(int is_supported);
 
 static void tpacpi_log_usertask(const char * const what)
 {
-	printk(TPACPI_DEBUG "%s: access by process with PID %d\n",
-		what, task_tgid_vnr(current));
+	printk(KERN_DEBUG pr_fmt("%s: access by process with PID %d\n"),
+	       what, task_tgid_vnr(current));
 }
 
 #define tpacpi_disclose_usertask(what, format, arg...) \
@@ -401,7 +392,7 @@ static void tpacpi_log_usertask(const char * const what)
 		if (unlikely( \
 		    (dbg_level & TPACPI_DBG_DISCLOSETASK) && \
 		    (tpacpi_lifecycle == TPACPI_LIFE_RUNNING))) { \
-			printk(TPACPI_DEBUG "%s: PID %d: " format, \
+			printk(KERN_DEBUG pr_fmt("%s: PID %d: " format), \
 				what, task_tgid_vnr(current), ## arg); \
 		} \
 	} while (0)
@@ -549,7 +540,7 @@ static int acpi_evalf(acpi_handle handle,
 	int quiet;
 
 	if (!*fmt) {
-		printk(TPACPI_ERR "acpi_evalf() called with empty format\n");
+		pr_err("acpi_evalf() called with empty format\n");
 		return 0;
 	}
 
@@ -574,8 +565,8 @@ static int acpi_evalf(acpi_handle handle,
 			break;
 			/* add more types as needed */
 		default:
-			printk(TPACPI_ERR "acpi_evalf() called "
-			       "with invalid format character '%c'\n", c);
+			pr_err("acpi_evalf() called with invalid format character '%c'\n",
+			       c);
 			return 0;
 		}
 	}
@@ -601,13 +592,13 @@ static int acpi_evalf(acpi_handle handle,
 		break;
 		/* add more types as needed */
 	default:
-		printk(TPACPI_ERR "acpi_evalf() called "
-		       "with invalid format character '%c'\n", res_type);
+		pr_err("acpi_evalf() called with invalid format character '%c'\n",
+		       res_type);
 		return 0;
 	}
 
 	if (!success && !quiet)
-		printk(TPACPI_ERR "acpi_evalf(%s, %s, ...) failed: %d\n",
+		pr_err("acpi_evalf(%s, %s, ...) failed: %d\n",
 		       method, fmt0, status);
 
 	return success;
@@ -715,8 +706,7 @@ static int __init setup_acpi_notify(struct ibm_struct *ibm)
 
 	rc = acpi_bus_get_device(*ibm->acpi->handle, &ibm->acpi->device);
 	if (rc < 0) {
-		printk(TPACPI_ERR "acpi_bus_get_device(%s) failed: %d\n",
-			ibm->name, rc);
+		pr_err("acpi_bus_get_device(%s) failed: %d\n", ibm->name, rc);
 		return -ENODEV;
 	}
 
@@ -729,12 +719,10 @@ static int __init setup_acpi_notify(struct ibm_struct *ibm)
 			ibm->acpi->type, dispatch_acpi_notify, ibm);
 	if (ACPI_FAILURE(status)) {
 		if (status == AE_ALREADY_EXISTS) {
-			printk(TPACPI_NOTICE
-			       "another device driver is already "
-			       "handling %s events\n", ibm->name);
+			pr_notice("another device driver is already handling %s events\n",
+				  ibm->name);
 		} else {
-			printk(TPACPI_ERR
-			       "acpi_install_notify_handler(%s) failed: %d\n",
+			pr_err("acpi_install_notify_handler(%s) failed: %d\n",
 			       ibm->name, status);
 		}
 		return -ENODEV;
@@ -759,8 +747,7 @@ static int __init register_tpacpi_subdriver(struct ibm_struct *ibm)
 
 	ibm->acpi->driver = kzalloc(sizeof(struct acpi_driver), GFP_KERNEL);
 	if (!ibm->acpi->driver) {
-		printk(TPACPI_ERR
-		       "failed to allocate memory for ibm->acpi->driver\n");
+		pr_err("failed to allocate memory for ibm->acpi->driver\n");
 		return -ENOMEM;
 	}
 
@@ -771,7 +758,7 @@ static int __init register_tpacpi_subdriver(struct ibm_struct *ibm)
 
 	rc = acpi_bus_register_driver(ibm->acpi->driver);
 	if (rc < 0) {
-		printk(TPACPI_ERR "acpi_bus_register_driver(%s) failed: %d\n",
+		pr_err("acpi_bus_register_driver(%s) failed: %d\n",
 		       ibm->name, rc);
 		kfree(ibm->acpi->driver);
 		ibm->acpi->driver = NULL;
@@ -1029,8 +1016,7 @@ static int parse_strtoul(const char *buf,
 static void tpacpi_disable_brightness_delay(void)
 {
 	if (acpi_evalf(hkey_handle, NULL, "PWMS", "qvd", 0))
-		printk(TPACPI_NOTICE
-			"ACPI backlight control delay disabled\n");
+		pr_notice("ACPI backlight control delay disabled\n");
 }
 
 static int __init tpacpi_query_bcl_levels(acpi_handle handle)
@@ -1042,8 +1028,8 @@ static int __init tpacpi_query_bcl_levels(acpi_handle handle)
 	if (ACPI_SUCCESS(acpi_evaluate_object(handle, NULL, NULL, &buffer))) {
 		obj = (union acpi_object *)buffer.pointer;
 		if (!obj || (obj->type != ACPI_TYPE_PACKAGE)) {
-			printk(TPACPI_ERR "Unknown _BCL data, "
-			       "please report this to %s\n", TPACPI_MAIL);
+			pr_err("Unknown _BCL data, please report this to %s\n",
+			       TPACPI_MAIL);
 			rc = 0;
 		} else {
 			rc = obj->package.count;
@@ -1111,9 +1097,8 @@ static void printk_deprecated_attribute(const char * const what,
 					const char * const details)
 {
 	tpacpi_log_usertask("deprecated sysfs attribute");
-	printk(TPACPI_WARN "WARNING: sysfs attribute %s is deprecated and "
-		"will be removed. %s\n",
-		what, details);
+	pr_warning("WARNING: sysfs attribute %s is deprecated and will be removed. %s\n",
+		   what, details);
 }
 
 /*************************************************************************
@@ -1286,8 +1271,7 @@ static int __init tpacpi_new_rfkill(const enum tpacpi_rfk_id id,
 						&tpacpi_rfk_rfkill_ops,
 						atp_rfk);
 	if (!atp_rfk || !atp_rfk->rfkill) {
-		printk(TPACPI_ERR
-			"failed to allocate memory for rfkill class\n");
+		pr_err("failed to allocate memory for rfkill class\n");
 		kfree(atp_rfk);
 		return -ENOMEM;
 	}
@@ -1297,9 +1281,8 @@ static int __init tpacpi_new_rfkill(const enum tpacpi_rfk_id id,
 
 	sw_status = (tp_rfkops->get_status)();
 	if (sw_status < 0) {
-		printk(TPACPI_ERR
-			"failed to read initial state for %s, error %d\n",
-			name, sw_status);
+		pr_err("failed to read initial state for %s, error %d\n",
+		       name, sw_status);
 	} else {
 		sw_state = (sw_status == TPACPI_RFK_RADIO_OFF);
 		if (set_default) {
@@ -1313,9 +1296,7 @@ static int __init tpacpi_new_rfkill(const enum tpacpi_rfk_id id,
 
 	res = rfkill_register(atp_rfk->rfkill);
 	if (res < 0) {
-		printk(TPACPI_ERR
-			"failed to register %s rfkill switch: %d\n",
-			name, res);
+		pr_err("failed to register %s rfkill switch: %d\n", name, res);
 		rfkill_destroy(atp_rfk->rfkill);
 		kfree(atp_rfk);
 		return res;
@@ -1323,7 +1304,7 @@ static int __init tpacpi_new_rfkill(const enum tpacpi_rfk_id id,
 
 	tpacpi_rfkill_switches[id] = atp_rfk;
 
-	printk(TPACPI_INFO "rfkill switch %s: radio is %sblocked\n",
+	pr_info("rfkill switch %s: radio is %sblocked\n",
 		name, (sw_state || hw_state) ? "" : "un");
 	return 0;
 }
@@ -1847,11 +1828,8 @@ static void __init tpacpi_check_outdated_fw(void)
 		 * broken, or really stable to begin with, so it is
 		 * best if the user upgrades the firmware anyway.
 		 */
-		printk(TPACPI_WARN
-			"WARNING: Outdated ThinkPad BIOS/EC firmware\n");
-		printk(TPACPI_WARN
-			"WARNING: This firmware may be missing critical bug "
-			"fixes and/or important features\n");
+		pr_warning("WARNING: Outdated ThinkPad BIOS/EC firmware\n");
+		pr_warning("WARNING: This firmware may be missing critical bug fixes and/or important features\n");
 	}
 }
 
@@ -1875,17 +1853,17 @@ static bool __init tpacpi_is_fw_known(void)
 
 static int __init thinkpad_acpi_driver_init(struct ibm_init_struct *iibm)
 {
-	printk(TPACPI_INFO "%s v%s\n", TPACPI_DESC, TPACPI_VERSION);
-	printk(TPACPI_INFO "%s\n", TPACPI_URL);
+	pr_info("%s v%s\n", TPACPI_DESC, TPACPI_VERSION);
+	pr_info("%s\n", TPACPI_URL);
 
-	printk(TPACPI_INFO "ThinkPad BIOS %s, EC %s\n",
+	pr_info("ThinkPad BIOS %s, EC %s\n",
 		(thinkpad_id.bios_version_str) ?
 			thinkpad_id.bios_version_str : "unknown",
 		(thinkpad_id.ec_version_str) ?
 			thinkpad_id.ec_version_str : "unknown");
 
 	if (thinkpad_id.vendor && thinkpad_id.model_str)
-		printk(TPACPI_INFO "%s %s, model %s\n",
+		pr_info("%s %s, model %s\n",
 			(thinkpad_id.vendor == PCI_VENDOR_ID_IBM) ?
 				"IBM" : ((thinkpad_id.vendor ==
 						PCI_VENDOR_ID_LENOVO) ?
@@ -2152,9 +2130,7 @@ void static hotkey_mask_warn_incomplete_mask(void)
 		(hotkey_all_mask | TPACPI_HKEY_NVRAM_KNOWN_MASK);
 
 	if (wantedmask)
-		printk(TPACPI_NOTICE
-			"required events 0x%08x not enabled!\n",
-			wantedmask);
+		pr_notice("required events 0x%08x not enabled!\n", wantedmask);
 }
 
 /*
@@ -2192,10 +2168,8 @@ static int hotkey_mask_set(u32 mask)
 	 * a given event.
 	 */
 	if (!hotkey_mask_get() && !rc && (fwmask & ~hotkey_acpi_mask)) {
-		printk(TPACPI_NOTICE
-		       "asked for hotkey mask 0x%08x, but "
-		       "firmware forced it to 0x%08x\n",
-		       fwmask, hotkey_acpi_mask);
+		pr_notice("asked for hotkey mask 0x%08x, but firmware forced it to 0x%08x\n",
+			  fwmask, hotkey_acpi_mask);
 	}
 
 	if (tpacpi_lifecycle != TPACPI_LIFE_EXITING)
@@ -2219,13 +2193,9 @@ static int hotkey_user_mask_set(const u32 mask)
 	    (mask == 0xffff || mask == 0xffffff ||
 	     mask == 0xffffffff)) {
 		tp_warned.hotkey_mask_ff = 1;
-		printk(TPACPI_NOTICE
-		       "setting the hotkey mask to 0x%08x is likely "
-		       "not the best way to go about it\n", mask);
-		printk(TPACPI_NOTICE
-		       "please consider using the driver defaults, "
-		       "and refer to up-to-date thinkpad-acpi "
-		       "documentation\n");
+		pr_notice("setting the hotkey mask to 0x%08x is likely not the best way to go about it\n",
+			  mask);
+		pr_notice("please consider using the driver defaults, and refer to up-to-date thinkpad-acpi documentation\n");
 	}
 
 	/* Try to enable what the user asked for, plus whatever we need.
@@ -2561,20 +2531,15 @@ static void hotkey_poll_setup(bool may_warn)
 					NULL, TPACPI_NVRAM_KTHREAD_NAME);
 			if (IS_ERR(tpacpi_hotkey_task)) {
 				tpacpi_hotkey_task = NULL;
-				printk(TPACPI_ERR
-				       "could not create kernel thread "
-				       "for hotkey polling\n");
+				pr_err("could not create kernel thread for hotkey polling\n");
 			}
 		}
 	} else {
 		hotkey_poll_stop_sync();
 		if (may_warn && (poll_driver_mask || poll_user_mask) &&
 		    hotkey_poll_freq == 0) {
-			printk(TPACPI_NOTICE
-				"hot keys 0x%08x and/or events 0x%08x "
-				"require polling, which is currently "
-				"disabled\n",
-				poll_user_mask, poll_driver_mask);
+			pr_notice("hot keys 0x%08x and/or events 0x%08x require polling, which is currently disabled\n",
+				  poll_user_mask, poll_driver_mask);
 		}
 	}
 }
@@ -2799,13 +2764,10 @@ static ssize_t hotkey_source_mask_store(struct device *dev,
 	mutex_unlock(&hotkey_mutex);
 
 	if (rc < 0)
-		printk(TPACPI_ERR "hotkey_source_mask: failed to update the"
-			"firmware event mask!\n");
+		pr_err("hotkey_source_mask: failed to update thefirmware event mask!\n");
 
 	if (r_ev)
-		printk(TPACPI_NOTICE "hotkey_source_mask: "
-			"some important events were disabled: "
-			"0x%04x\n", r_ev);
+		pr_notice("hotkey_source_mask: some important events were disabled: 0x%04x\n", r_ev);
 
 	tpacpi_disclose_usertask("hotkey_source_mask", "set to 0x%08lx\n", t);
 
@@ -3036,9 +2998,7 @@ static void hotkey_exit(void)
 	if (((tp_features.hotkey_mask &&
 	      hotkey_mask_set(hotkey_orig_mask)) |
 	     hotkey_status_set(false)) != 0)
-		printk(TPACPI_ERR
-		       "failed to restore hot key mask "
-		       "to BIOS defaults\n");
+		pr_err("failed to restore hot key mask to BIOS defaults\n");
 }
 
 static void __init hotkey_unmap(const unsigned int scancode)
@@ -3248,10 +3208,9 @@ static int __init hotkey_init(struct ibm_init_struct *iibm)
 	   for HKEY interface version 0x100 */
 	if (acpi_evalf(hkey_handle, &hkeyv, "MHKV", "qd")) {
 		if ((hkeyv >> 8) != 1) {
-			printk(TPACPI_ERR "unknown version of the "
-			       "HKEY interface: 0x%x\n", hkeyv);
-			printk(TPACPI_ERR "please report this to %s\n",
-			       TPACPI_MAIL);
+			pr_err("unknown version of the HKEY interface: 0x%x\n",
+			       hkeyv);
+			pr_err("please report this to %s\n", TPACPI_MAIL);
 		} else {
 			/*
 			 * MHKV 0x100 in A31, R40, R40e,
@@ -3264,9 +3223,7 @@ static int __init hotkey_init(struct ibm_init_struct *iibm)
 			/* Paranoia check AND init hotkey_all_mask */
 			if (!acpi_evalf(hkey_handle, &hotkey_all_mask,
 					"MHKA", "qd")) {
-				printk(TPACPI_ERR
-				       "missing MHKA handler, "
-				       "please report this to %s\n",
+				pr_err("missing MHKA handler, please report this to %s\n",
 				       TPACPI_MAIL);
 				/* Fallback: pre-init for FN+F3,F4,F12 */
 				hotkey_all_mask = 0x080cU;
@@ -3303,16 +3260,14 @@ static int __init hotkey_init(struct ibm_init_struct *iibm)
 	if (dbg_wlswemul) {
 		tp_features.hotkey_wlsw = 1;
 		radiosw_state = !!tpacpi_wlsw_emulstate;
-		printk(TPACPI_INFO
-			"radio switch emulation enabled\n");
+		pr_info("radio switch emulation enabled\n");
 	} else
 #endif
 	/* Not all thinkpads have a hardware radio switch */
 	if (acpi_evalf(hkey_handle, &status, "WLSW", "qd")) {
 		tp_features.hotkey_wlsw = 1;
 		radiosw_state = !!status;
-		printk(TPACPI_INFO
-			"radio switch found; radios are %s\n",
+		pr_info("radio switch found; radios are %s\n",
 			enabled(status, 0));
 	}
 	if (tp_features.hotkey_wlsw)
@@ -3323,9 +3278,7 @@ static int __init hotkey_init(struct ibm_init_struct *iibm)
 	if (!res && acpi_evalf(hkey_handle, &status, "MHKG", "qd")) {
 		tp_features.hotkey_tablet = 1;
 		tabletsw_state = !!(status & TP_HOTKEY_TABLET_MASK);
-		printk(TPACPI_INFO
-			"possible tablet mode switch found; "
-			"ThinkPad in %s mode\n",
+		pr_info("possible tablet mode switch found; ThinkPad in %s mode\n",
 			(tabletsw_state) ? "tablet" : "laptop");
 		res = add_to_attr_set(hotkey_dev_attributes,
 				&dev_attr_hotkey_tablet_mode.attr);
@@ -3343,8 +3296,7 @@ static int __init hotkey_init(struct ibm_init_struct *iibm)
 	hotkey_keycode_map = kmalloc(TPACPI_HOTKEY_MAP_SIZE,
 					GFP_KERNEL);
 	if (!hotkey_keycode_map) {
-		printk(TPACPI_ERR
-			"failed to allocate memory for key map\n");
+		pr_err("failed to allocate memory for key map\n");
 		res = -ENOMEM;
 		goto err_exit;
 	}
@@ -3393,13 +3345,8 @@ static int __init hotkey_init(struct ibm_init_struct *iibm)
 		tpacpi_check_std_acpi_brightness_support();
 
 	if (tp_features.bright_acpimode && acpi_video_backlight_support()) {
-		printk(TPACPI_INFO
-		       "This ThinkPad has standard ACPI backlight "
-		       "brightness control, supported by the ACPI "
-		       "video driver\n");
-		printk(TPACPI_NOTICE
-		       "Disabling thinkpad-acpi brightness events "
-		       "by default...\n");
+		pr_info("This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver\n");
+		pr_notice("Disabling thinkpad-acpi brightness events by default...\n");
 
 		/* Disable brightness up/down on Lenovo thinkpads when
 		 * ACPI is handling them, otherwise it is plain impossible
@@ -3505,8 +3452,7 @@ static bool hotkey_notify_wakeup(const u32 hkey,
 
 	case TP_HKEY_EV_WKUP_S3_BATLOW: /* Battery on critical low level/S3 */
 	case TP_HKEY_EV_WKUP_S4_BATLOW: /* Battery on critical low level/S4 */
-		printk(TPACPI_ALERT
-			"EMERGENCY WAKEUP: battery almost empty\n");
+		pr_alert("EMERGENCY WAKEUP: battery almost empty\n");
 		/* how to auto-heal: */
 		/* 2313: woke up from S3, go to S4/S5 */
 		/* 2413: woke up from S4, go to S5 */
@@ -3517,9 +3463,7 @@ static bool hotkey_notify_wakeup(const u32 hkey,
 	}
 
 	if (hotkey_wakeup_reason != TP_ACPI_WAKEUP_NONE) {
-		printk(TPACPI_INFO
-		       "woke up due to a hot-unplug "
-		       "request...\n");
+		pr_info("woke up due to a hot-unplug request...\n");
 		hotkey_wakeup_reason_notify_change();
 	}
 	return true;
@@ -3571,37 +3515,29 @@ static bool hotkey_notify_thermal(const u32 hkey,
 
 	switch (hkey) {
 	case TP_HKEY_EV_THM_TABLE_CHANGED:
-		printk(TPACPI_INFO
-			"EC reports that Thermal Table has changed\n");
+		pr_info("EC reports that Thermal Table has changed\n");
 		/* recommended action: do nothing, we don't have
 		 * Lenovo ATM information */
 		return true;
 	case TP_HKEY_EV_ALARM_BAT_HOT:
-		printk(TPACPI_CRIT
-			"THERMAL ALARM: battery is too hot!\n");
+		pr_crit("THERMAL ALARM: battery is too hot!\n");
 		/* recommended action: warn user through gui */
 		break;
 	case TP_HKEY_EV_ALARM_BAT_XHOT:
-		printk(TPACPI_ALERT
-			"THERMAL EMERGENCY: battery is extremely hot!\n");
+		pr_alert("THERMAL EMERGENCY: battery is extremely hot!\n");
 		/* recommended action: immediate sleep/hibernate */
 		break;
 	case TP_HKEY_EV_ALARM_SENSOR_HOT:
-		printk(TPACPI_CRIT
-			"THERMAL ALARM: "
-			"a sensor reports something is too hot!\n");
+		pr_crit("THERMAL ALARM: a sensor reports something is too hot!\n");
 		/* recommended action: warn user through gui, that */
 		/* some internal component is too hot */
 		break;
 	case TP_HKEY_EV_ALARM_SENSOR_XHOT:
-		printk(TPACPI_ALERT
-			"THERMAL EMERGENCY: "
-			"a sensor reports something is extremely hot!\n");
+		pr_alert("THERMAL EMERGENCY: a sensor reports something is extremely hot!\n");
 		/* recommended action: immediate sleep/hibernate */
 		break;
 	default:
-		printk(TPACPI_ALERT
-			 "THERMAL ALERT: unknown thermal alarm received\n");
+		pr_alert("THERMAL ALERT: unknown thermal alarm received\n");
 		known = false;
 	}
 
@@ -3618,8 +3554,7 @@ static void hotkey_notify(struct ibm_struct *ibm, u32 event)
 	bool known_ev;
 
 	if (event != 0x80) {
-		printk(TPACPI_ERR
-		       "unknown HKEY notification event %d\n", event);
+		pr_err("unknown HKEY notification event %d\n", event);
 		/* forward it to userspace, maybe it knows how to handle it */
 		acpi_bus_generate_netlink_event(
 					ibm->acpi->device->pnp.device_class,
@@ -3630,7 +3565,7 @@ static void hotkey_notify(struct ibm_struct *ibm, u32 event)
 
 	while (1) {
 		if (!acpi_evalf(hkey_handle, &hkey, "MHKP", "d")) {
-			printk(TPACPI_ERR "failed to retrieve HKEY event\n");
+			pr_err("failed to retrieve HKEY event\n");
 			return;
 		}
 
@@ -3657,8 +3592,7 @@ static void hotkey_notify(struct ibm_struct *ibm, u32 event)
 			/* 0x3000-0x3FFF: bay-related wakeups */
 			if (hkey == TP_HKEY_EV_BAYEJ_ACK) {
 				hotkey_autosleep_ack = 1;
-				printk(TPACPI_INFO
-				       "bay ejected\n");
+				pr_info("bay ejected\n");
 				hotkey_wakeup_hotunplug_complete_notify_change();
 				known_ev = true;
 			} else {
@@ -3669,8 +3603,7 @@ static void hotkey_notify(struct ibm_struct *ibm, u32 event)
 			/* 0x4000-0x4FFF: dock-related wakeups */
 			if (hkey == TP_HKEY_EV_UNDOCK_ACK) {
 				hotkey_autosleep_ack = 1;
-				printk(TPACPI_INFO
-				       "undocked\n");
+				pr_info("undocked\n");
 				hotkey_wakeup_hotunplug_complete_notify_change();
 				known_ev = true;
 			} else {
@@ -3701,11 +3634,9 @@ static void hotkey_notify(struct ibm_struct *ibm, u32 event)
 			known_ev = false;
 		}
 		if (!known_ev) {
-			printk(TPACPI_NOTICE
-			       "unhandled HKEY event 0x%04x\n", hkey);
-			printk(TPACPI_NOTICE
-			       "please report the conditions when this "
-			       "event happened to %s\n", TPACPI_MAIL);
+			pr_notice("unhandled HKEY event 0x%04x\n", hkey);
+			pr_notice("please report the conditions when this event happened to %s\n",
+				  TPACPI_MAIL);
 		}
 
 		/* Legacy events */
@@ -3738,9 +3669,7 @@ static void hotkey_resume(void)
 
 	if (hotkey_status_set(true) < 0 ||
 	    hotkey_mask_set(hotkey_acpi_mask) < 0)
-		printk(TPACPI_ERR
-		       "error while attempting to reset the event "
-		       "firmware interface\n");
+		pr_err("error while attempting to reset the event firmware interface\n");
 
 	tpacpi_send_radiosw_update();
 	hotkey_tablet_mode_notify_change();
@@ -3784,14 +3713,9 @@ static void hotkey_enabledisable_warn(bool enable)
 {
 	tpacpi_log_usertask("procfs hotkey enable/disable");
 	if (!WARN((tpacpi_lifecycle == TPACPI_LIFE_RUNNING || !enable),
-			TPACPI_WARN
-			"hotkey enable/disable functionality has been "
-			"removed from the driver.  Hotkeys are always "
-			"enabled\n"))
-		printk(TPACPI_ERR
-			"Please remove the hotkey=enable module "
-			"parameter, it is deprecated.  Hotkeys are always "
-			"enabled\n");
+		  KERN_WARNING
+		  pr_fmt("hotkey enable/disable functionality has been removed from the driver.  Hotkeys are always enabled\n")))
+		pr_err("Please remove the hotkey=enable module parameter, it is deprecated.  Hotkeys are always enabled\n");
 }
 
 static int hotkey_write(char *buf)
@@ -3969,8 +3893,7 @@ static void bluetooth_shutdown(void)
 	/* Order firmware to save current state to NVRAM */
 	if (!acpi_evalf(NULL, NULL, "\\BLTH", "vd",
 			TP_ACPI_BLTH_SAVE_STATE))
-		printk(TPACPI_NOTICE
-			"failed to save bluetooth state to NVRAM\n");
+		pr_notice("failed to save bluetooth state to NVRAM\n");
 	else
 		vdbg_printk(TPACPI_DBG_RFKILL,
 			"bluestooth state saved to NVRAM\n");
@@ -4009,8 +3932,7 @@ static int __init bluetooth_init(struct ibm_init_struct *iibm)
 #ifdef CONFIG_THINKPAD_ACPI_DEBUGFACILITIES
 	if (dbg_bluetoothemul) {
 		tp_features.bluetooth = 1;
-		printk(TPACPI_INFO
-			"bluetooth switch emulation enabled\n");
+		pr_info("bluetooth switch emulation enabled\n");
 	} else
 #endif
 	if (tp_features.bluetooth &&
@@ -4160,8 +4082,7 @@ static void wan_shutdown(void)
 	/* Order firmware to save current state to NVRAM */
 	if (!acpi_evalf(NULL, NULL, "\\WGSV", "vd",
 			TP_ACPI_WGSV_SAVE_STATE))
-		printk(TPACPI_NOTICE
-			"failed to save WWAN state to NVRAM\n");
+		pr_notice("failed to save WWAN state to NVRAM\n");
 	else
 		vdbg_printk(TPACPI_DBG_RFKILL,
 			"WWAN state saved to NVRAM\n");
@@ -4198,8 +4119,7 @@ static int __init wan_init(struct ibm_init_struct *iibm)
 #ifdef CONFIG_THINKPAD_ACPI_DEBUGFACILITIES
 	if (dbg_wwanemul) {
 		tp_features.wan = 1;
-		printk(TPACPI_INFO
-			"wwan switch emulation enabled\n");
+		pr_info("wwan switch emulation enabled\n");
 	} else
 #endif
 	if (tp_features.wan &&
@@ -4339,8 +4259,7 @@ static int __init uwb_init(struct ibm_init_struct *iibm)
 #ifdef CONFIG_THINKPAD_ACPI_DEBUGFACILITIES
 	if (dbg_uwbemul) {
 		tp_features.uwb = 1;
-		printk(TPACPI_INFO
-			"uwb switch emulation enabled\n");
+		pr_info("uwb switch emulation enabled\n");
 	} else
 #endif
 	if (tp_features.uwb &&
@@ -4441,8 +4360,7 @@ static void video_exit(void)
 	dbg_printk(TPACPI_DBG_EXIT,
 		   "restoring original video autoswitch mode\n");
 	if (video_autosw_set(video_orig_autosw))
-		printk(TPACPI_ERR "error while trying to restore original "
-			"video autoswitch mode\n");
+		pr_err("error while trying to restore original video autoswitch mode\n");
 }
 
 static int video_outputsw_get(void)
@@ -4514,8 +4432,7 @@ static int video_outputsw_set(int status)
 		res = acpi_evalf(vid_handle, NULL,
 				 "ASWT", "vdd", status * 0x100, 0);
 		if (!autosw && video_autosw_set(autosw)) {
-			printk(TPACPI_ERR
-			       "video auto-switch left enabled due to error\n");
+			pr_err("video auto-switch left enabled due to error\n");
 			return -EIO;
 		}
 		break;
@@ -4584,8 +4501,7 @@ static int video_outputsw_cycle(void)
 		return -ENOSYS;
 	}
 	if (!autosw && video_autosw_set(autosw)) {
-		printk(TPACPI_ERR
-		       "video auto-switch left enabled due to error\n");
+		pr_err("video auto-switch left enabled due to error\n");
 		return -EIO;
 	}
 
@@ -5283,7 +5199,7 @@ static int __init led_init(struct ibm_init_struct *iibm)
 	tpacpi_leds = kzalloc(sizeof(*tpacpi_leds) * TPACPI_LED_NUMLEDS,
 			      GFP_KERNEL);
 	if (!tpacpi_leds) {
-		printk(TPACPI_ERR "Out of memory for LED data\n");
+		pr_err("Out of memory for LED data\n");
 		return -ENOMEM;
 	}
 
@@ -5302,9 +5218,7 @@ static int __init led_init(struct ibm_init_struct *iibm)
 	}
 
 #ifdef CONFIG_THINKPAD_ACPI_UNSAFE_LEDS
-	printk(TPACPI_NOTICE
-		"warning: userspace override of important "
-		"firmware LEDs is enabled\n");
+	pr_notice("warning: userspace override of important firmware LEDs is enabled\n");
 #endif
 	return 0;
 }
@@ -5574,8 +5488,7 @@ static void thermal_dump_all_sensors(void)
 	if (n <= 0)
 		return;
 
-	printk(TPACPI_NOTICE
-		"temperatures (Celsius):");
+	pr_notice("temperatures (Celsius):");
 
 	for (i = 0; i < n; i++) {
 		if (t.temp[i] != TPACPI_THERMAL_SENSOR_NA)
@@ -5704,15 +5617,10 @@ static int __init thermal_init(struct ibm_init_struct *iibm)
 		if (ta1 == 0) {
 			/* This is sheer paranoia, but we handle it anyway */
 			if (acpi_tmp7) {
-				printk(TPACPI_ERR
-				       "ThinkPad ACPI EC access misbehaving, "
-				       "falling back to ACPI TMPx access "
-				       "mode\n");
+				pr_err("ThinkPad ACPI EC access misbehaving, falling back to ACPI TMPx access mode\n");
 				thermal_read_mode = TPACPI_THERMAL_ACPI_TMP07;
 			} else {
-				printk(TPACPI_ERR
-				       "ThinkPad ACPI EC access misbehaving, "
-				       "disabling thermal sensors access\n");
+				pr_err("ThinkPad ACPI EC access misbehaving, disabling thermal sensors access\n");
 				thermal_read_mode = TPACPI_THERMAL_NONE;
 			}
 		} else {
@@ -6171,21 +6079,14 @@ static int __init brightness_init(struct ibm_init_struct *iibm)
 
 		if (acpi_video_backlight_support()) {
 			if (brightness_enable > 1) {
-				printk(TPACPI_NOTICE
-				       "Standard ACPI backlight interface "
-				       "available, not loading native one.\n");
+				pr_notice("Standard ACPI backlight interface available, not loading native one.\n");
 				return 1;
 			} else if (brightness_enable == 1) {
-				printk(TPACPI_NOTICE
-				       "Backlight control force enabled, even if standard "
-				       "ACPI backlight interface is available\n");
+				pr_notice("Backlight control force enabled, even if standard ACPI backlight interface is available\n");
 			}
 		} else {
 			if (brightness_enable > 1) {
-				printk(TPACPI_NOTICE
-				       "Standard ACPI backlight interface not "
-				       "available, thinkpad_acpi native "
-				       "brightness control enabled\n");
+				pr_notice("Standard ACPI backlight interface not available, thinkpad_acpi native brightness control enabled\n");
 			}
 		}
 	}
@@ -6198,9 +6099,8 @@ static int __init brightness_init(struct ibm_init_struct *iibm)
 	}
 
 	if (b > 16) {
-		printk(TPACPI_ERR
-		       "Unsupported brightness interface, "
-		       "please contact %s\n", TPACPI_MAIL);
+		pr_err("Unsupported brightness interface, please contact %s\n",
+		       TPACPI_MAIL);
 		return 1;
 	}
 	if (b == 16)
@@ -6237,8 +6137,7 @@ static int __init brightness_init(struct ibm_init_struct *iibm)
 		return 1;
 
 	if (tp_features.bright_16levels)
-		printk(TPACPI_INFO
-		       "detected a 16-level brightness capable ThinkPad\n");
+		pr_info("detected a 16-level brightness capable ThinkPad\n");
 
 	ibm_backlight_device = backlight_device_register(
 					TPACPI_BACKLIGHT_DEV_NAME, NULL, NULL,
@@ -6246,19 +6145,17 @@ static int __init brightness_init(struct ibm_init_struct *iibm)
 	if (IS_ERR(ibm_backlight_device)) {
 		int rc = PTR_ERR(ibm_backlight_device);
 		ibm_backlight_device = NULL;
-		printk(TPACPI_ERR "Could not register backlight device\n");
+		pr_err("Could not register backlight device\n");
 		return rc;
 	}
 	vdbg_printk(TPACPI_DBG_INIT | TPACPI_DBG_BRGHT,
 			"brightness is supported\n");
 
 	if (quirks & TPACPI_BRGHT_Q_ASK) {
-		printk(TPACPI_NOTICE
-			"brightness: will use unverified default: "
-			"brightness_mode=%d\n", brightness_mode);
-		printk(TPACPI_NOTICE
-			"brightness: please report to %s whether it works well "
-			"or not on your ThinkPad\n", TPACPI_MAIL);
+		pr_notice("brightness: will use unverified default: brightness_mode=%d\n",
+			  brightness_mode);
+		pr_notice("brightness: please report to %s whether it works well or not on your ThinkPad\n",
+			  TPACPI_MAIL);
 	}
 
 	ibm_backlight_device->props.max_brightness =
@@ -6740,8 +6637,7 @@ static int __init volume_create_alsa_mixer(void)
 		ctl_vol = snd_ctl_new1(&volume_alsa_control_vol, NULL);
 		rc = snd_ctl_add(card, ctl_vol);
 		if (rc < 0) {
-			printk(TPACPI_ERR
-				"Failed to create ALSA volume control\n");
+			pr_err("Failed to create ALSA volume control\n");
 			goto err_out;
 		}
 		data->ctl_vol_id = &ctl_vol->id;
@@ -6750,7 +6646,7 @@ static int __init volume_create_alsa_mixer(void)
 	ctl_mute = snd_ctl_new1(&volume_alsa_control_mute, NULL);
 	rc = snd_ctl_add(card, ctl_mute);
 	if (rc < 0) {
-		printk(TPACPI_ERR "Failed to create ALSA mute control\n");
+		pr_err("Failed to create ALSA mute control\n");
 		goto err_out;
 	}
 	data->ctl_mute_id = &ctl_mute->id;
@@ -6812,9 +6708,8 @@ static int __init volume_init(struct ibm_init_struct *iibm)
 		return -EINVAL;
 
 	if (volume_mode == TPACPI_VOL_MODE_UCMS_STEP) {
-		printk(TPACPI_ERR
-			"UCMS step volume mode not implemented, "
-			"please contact %s\n", TPACPI_MAIL);
+		pr_err("UCMS step volume mode not implemented, please contact %s\n",
+		       TPACPI_MAIL);
 		return 1;
 	}
 
@@ -6878,13 +6773,11 @@ static int __init volume_init(struct ibm_init_struct *iibm)
 
 	rc = volume_create_alsa_mixer();
 	if (rc) {
-		printk(TPACPI_ERR
-			"Could not create the ALSA mixer interface\n");
+		pr_err("Could not create the ALSA mixer interface\n");
 		return rc;
 	}
 
-	printk(TPACPI_INFO
-		"Console audio control enabled, mode: %s\n",
+	pr_info("Console audio control enabled, mode: %s\n",
 		(volume_control_allowed) ?
 			"override (read/write)" :
 			"monitor (read only)");
@@ -6946,12 +6839,8 @@ static int volume_write(char *buf)
 	if (!volume_control_allowed && tpacpi_lifecycle != TPACPI_LIFE_INIT) {
 		if (unlikely(!tp_warned.volume_ctrl_forbidden)) {
 			tp_warned.volume_ctrl_forbidden = 1;
-			printk(TPACPI_NOTICE
-				"Console audio control in monitor mode, "
-				"changes are not allowed.\n");
-			printk(TPACPI_NOTICE
-				"Use the volume_control=1 module parameter "
-				"to enable volume control\n");
+			pr_notice("Console audio control in monitor mode, changes are not allowed.\n");
+			pr_notice("Use the volume_control=1 module parameter to enable volume control\n");
 		}
 		return -EPERM;
 	}
@@ -7212,9 +7101,7 @@ TPACPI_HANDLE(sfan, ec, "SFAN",	/* 570 */
 static void fan_quirk1_setup(void)
 {
 	if (fan_control_initial_status == 0x07) {
-		printk(TPACPI_NOTICE
-		       "fan_init: initial fan status is unknown, "
-		       "assuming it is in auto mode\n");
+		pr_notice("fan_init: initial fan status is unknown, assuming it is in auto mode\n");
 		tp_features.fan_ctrl_status_undef = 1;
 	}
 }
@@ -7601,9 +7488,7 @@ static void fan_watchdog_reset(void)
 		if (!queue_delayed_work(tpacpi_wq, &fan_watchdog_task,
 				msecs_to_jiffies(fan_watchdog_maxinterval
 						 * 1000))) {
-			printk(TPACPI_ERR
-			       "failed to queue the fan watchdog, "
-			       "watchdog will not trigger\n");
+			pr_err("failed to queue the fan watchdog, watchdog will not trigger\n");
 		}
 	} else
 		fan_watchdog_active = 0;
@@ -7616,11 +7501,11 @@ static void fan_watchdog_fire(struct work_struct *ignored)
 	if (tpacpi_lifecycle != TPACPI_LIFE_RUNNING)
 		return;
 
-	printk(TPACPI_NOTICE "fan watchdog: enabling fan\n");
+	pr_notice("fan watchdog: enabling fan\n");
 	rc = fan_set_enable();
 	if (rc < 0) {
-		printk(TPACPI_ERR "fan watchdog: error %d while enabling fan, "
-			"will try again later...\n", -rc);
+		pr_err("fan watchdog: error %d while enabling fan, will try again later...\n",
+		       -rc);
 		/* reschedule for later */
 		fan_watchdog_reset();
 	}
@@ -7922,9 +7807,7 @@ static int __init fan_init(struct ibm_init_struct *iibm)
 					"secondary fan support enabled\n");
 			}
 		} else {
-			printk(TPACPI_ERR
-			       "ThinkPad ACPI EC access misbehaving, "
-			       "fan status and control unavailable\n");
+			pr_err("ThinkPad ACPI EC access misbehaving, fan status and control unavailable\n");
 			return 1;
 		}
 	}
@@ -8023,9 +7906,8 @@ static void fan_suspend(pm_message_t state)
 	fan_control_resume_level = 0;
 	rc = fan_get_status_safe(&fan_control_resume_level);
 	if (rc < 0)
-		printk(TPACPI_NOTICE
-			"failed to read fan level for later "
-			"restore during resume: %d\n", rc);
+		pr_notice("failed to read fan level for later restore during resume: %d\n",
+			  rc);
 
 	/* if it is undefined, don't attempt to restore it.
 	 * KEEP THIS LAST */
@@ -8080,13 +7962,11 @@ static void fan_resume(void)
 		return;
 	}
 	if (do_set) {
-		printk(TPACPI_NOTICE
-			"restoring fan level to 0x%02x\n",
-			fan_control_resume_level);
+		pr_notice("restoring fan level to 0x%02x\n",
+			  fan_control_resume_level);
 		rc = fan_set_level_safe(fan_control_resume_level);
 		if (rc < 0)
-			printk(TPACPI_NOTICE
-				"failed to restore fan level: %d\n", rc);
+			pr_notice("failed to restore fan level: %d\n", rc);
 	}
 }
 
@@ -8178,8 +8058,8 @@ static int fan_write_cmd_level(const char *cmd, int *rc)
 
 	*rc = fan_set_level_safe(level);
 	if (*rc == -ENXIO)
-		printk(TPACPI_ERR "level command accepted for unsupported "
-		       "access mode %d", fan_control_access_mode);
+		pr_err("level command accepted for unsupported access mode %d",
+		       fan_control_access_mode);
 	else if (!*rc)
 		tpacpi_disclose_usertask("procfs fan",
 			"set level to %d\n", level);
@@ -8194,8 +8074,8 @@ static int fan_write_cmd_enable(const char *cmd, int *rc)
 
 	*rc = fan_set_enable();
 	if (*rc == -ENXIO)
-		printk(TPACPI_ERR "enable command accepted for unsupported "
-		       "access mode %d", fan_control_access_mode);
+		pr_err("enable command accepted for unsupported access mode %d",
+		       fan_control_access_mode);
 	else if (!*rc)
 		tpacpi_disclose_usertask("procfs fan", "enable\n");
 
@@ -8209,8 +8089,8 @@ static int fan_write_cmd_disable(const char *cmd, int *rc)
 
 	*rc = fan_set_disable();
 	if (*rc == -ENXIO)
-		printk(TPACPI_ERR "disable command accepted for unsupported "
-		       "access mode %d", fan_control_access_mode);
+		pr_err("disable command accepted for unsupported access mode %d",
+		       fan_control_access_mode);
 	else if (!*rc)
 		tpacpi_disclose_usertask("procfs fan", "disable\n");
 
@@ -8229,8 +8109,8 @@ static int fan_write_cmd_speed(const char *cmd, int *rc)
 
 	*rc = fan_set_speed(speed);
 	if (*rc == -ENXIO)
-		printk(TPACPI_ERR "speed command accepted for unsupported "
-		       "access mode %d", fan_control_access_mode);
+		pr_err("speed command accepted for unsupported access mode %d",
+		       fan_control_access_mode);
 	else if (!*rc)
 		tpacpi_disclose_usertask("procfs fan",
 			"set speed to %d\n", speed);
@@ -8434,8 +8314,8 @@ static int __init ibm_init(struct ibm_init_struct *iibm)
 		if (ibm->acpi->notify) {
 			ret = setup_acpi_notify(ibm);
 			if (ret == -ENODEV) {
-				printk(TPACPI_NOTICE "disabling subdriver %s\n",
-					ibm->name);
+				pr_notice("disabling subdriver %s\n",
+					  ibm->name);
 				ret = 0;
 				goto err_out;
 			}
@@ -8456,8 +8336,7 @@ static int __init ibm_init(struct ibm_init_struct *iibm)
 		entry = proc_create_data(ibm->name, mode, proc_dir,
 					 &dispatch_proc_fops, ibm);
 		if (!entry) {
-			printk(TPACPI_ERR "unable to create proc entry %s\n",
-			       ibm->name);
+			pr_err("unable to create proc entry %s\n", ibm->name);
 			ret = -ENODEV;
 			goto err_out;
 		}
@@ -8557,13 +8436,10 @@ static int __must_check __init get_thinkpad_model_data(
 				tp->ec_release = (ec_fw_string[4] << 8)
 						| ec_fw_string[5];
 			} else {
-				printk(TPACPI_NOTICE
-					"ThinkPad firmware release %s "
-					"doesn't match the known patterns\n",
-					ec_fw_string);
-				printk(TPACPI_NOTICE
-					"please report this to %s\n",
-					TPACPI_MAIL);
+				pr_notice("ThinkPad firmware release %s doesn't match the known patterns\n",
+					  ec_fw_string);
+				pr_notice("please report this to %s\n",
+					  TPACPI_MAIL);
 			}
 			break;
 		}
@@ -8603,8 +8479,7 @@ static int __init probe_for_thinkpad(void)
 	TPACPI_ACPIHANDLE_INIT(ec);
 	if (!ec_handle) {
 		if (is_thinkpad)
-			printk(TPACPI_ERR
-				"Not yet supported ThinkPad detected!\n");
+			pr_err("Not yet supported ThinkPad detected!\n");
 		return -ENODEV;
 	}
 
@@ -8873,8 +8748,7 @@ static int __init thinkpad_acpi_module_init(void)
 
 	ret = get_thinkpad_model_data(&thinkpad_id);
 	if (ret) {
-		printk(TPACPI_ERR
-			"unable to get DMI data: %d\n", ret);
+		pr_err("unable to get DMI data: %d\n", ret);
 		thinkpad_acpi_module_exit();
 		return ret;
 	}
@@ -8897,16 +8771,14 @@ static int __init thinkpad_acpi_module_init(void)
 
 	proc_dir = proc_mkdir(TPACPI_PROC_DIR, acpi_root_dir);
 	if (!proc_dir) {
-		printk(TPACPI_ERR
-		       "unable to create proc dir " TPACPI_PROC_DIR);
+		pr_err("unable to create proc dir " TPACPI_PROC_DIR);
 		thinkpad_acpi_module_exit();
 		return -ENODEV;
 	}
 
 	ret = platform_driver_register(&tpacpi_pdriver);
 	if (ret) {
-		printk(TPACPI_ERR
-		       "unable to register main platform driver\n");
+		pr_err("unable to register main platform driver\n");
 		thinkpad_acpi_module_exit();
 		return ret;
 	}
@@ -8914,8 +8786,7 @@ static int __init thinkpad_acpi_module_init(void)
 
 	ret = platform_driver_register(&tpacpi_hwmon_pdriver);
 	if (ret) {
-		printk(TPACPI_ERR
-		       "unable to register hwmon platform driver\n");
+		pr_err("unable to register hwmon platform driver\n");
 		thinkpad_acpi_module_exit();
 		return ret;
 	}
@@ -8928,8 +8799,7 @@ static int __init thinkpad_acpi_module_init(void)
 					&tpacpi_hwmon_pdriver.driver);
 	}
 	if (ret) {
-		printk(TPACPI_ERR
-		       "unable to create sysfs driver attributes\n");
+		pr_err("unable to create sysfs driver attributes\n");
 		thinkpad_acpi_module_exit();
 		return ret;
 	}
@@ -8942,7 +8812,7 @@ static int __init thinkpad_acpi_module_init(void)
 	if (IS_ERR(tpacpi_pdev)) {
 		ret = PTR_ERR(tpacpi_pdev);
 		tpacpi_pdev = NULL;
-		printk(TPACPI_ERR "unable to register platform device\n");
+		pr_err("unable to register platform device\n");
 		thinkpad_acpi_module_exit();
 		return ret;
 	}
@@ -8952,16 +8822,14 @@ static int __init thinkpad_acpi_module_init(void)
 	if (IS_ERR(tpacpi_sensors_pdev)) {
 		ret = PTR_ERR(tpacpi_sensors_pdev);
 		tpacpi_sensors_pdev = NULL;
-		printk(TPACPI_ERR
-		       "unable to register hwmon platform device\n");
+		pr_err("unable to register hwmon platform device\n");
 		thinkpad_acpi_module_exit();
 		return ret;
 	}
 	ret = device_create_file(&tpacpi_sensors_pdev->dev,
 				 &dev_attr_thinkpad_acpi_pdev_name);
 	if (ret) {
-		printk(TPACPI_ERR
-		       "unable to create sysfs hwmon device attributes\n");
+		pr_err("unable to create sysfs hwmon device attributes\n");
 		thinkpad_acpi_module_exit();
 		return ret;
 	}
@@ -8970,14 +8838,14 @@ static int __init thinkpad_acpi_module_init(void)
 	if (IS_ERR(tpacpi_hwmon)) {
 		ret = PTR_ERR(tpacpi_hwmon);
 		tpacpi_hwmon = NULL;
-		printk(TPACPI_ERR "unable to register hwmon device\n");
+		pr_err("unable to register hwmon device\n");
 		thinkpad_acpi_module_exit();
 		return ret;
 	}
 	mutex_init(&tpacpi_inputdev_send_mutex);
 	tpacpi_inputdev = input_allocate_device();
 	if (!tpacpi_inputdev) {
-		printk(TPACPI_ERR "unable to allocate input device\n");
+		pr_err("unable to allocate input device\n");
 		thinkpad_acpi_module_exit();
 		return -ENOMEM;
 	} else {
@@ -9003,7 +8871,7 @@ static int __init thinkpad_acpi_module_init(void)
 	}
 	ret = input_register_device(tpacpi_inputdev);
 	if (ret < 0) {
-		printk(TPACPI_ERR "unable to register input device\n");
+		pr_err("unable to register input device\n");
 		thinkpad_acpi_module_exit();
 		return ret;
 	} else {


