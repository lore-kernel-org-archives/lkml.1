Return-Path: <linux-kernel-owner+w=401wt.eu-S1765468AbZFLOhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765468AbZFLOhu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 10:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762948AbZFLOhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 10:37:41 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:47340 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764664AbZFLOhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 10:37:40 -0400
Date: Fri, 12 Jun 2009 16:37:40 +0200
From: Andreas Mohr <andi@lisas.de>
To: Peter Feuerer <peter@piie.net>
Cc: Borislav Petkov <petkovbb@googlemail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <len.brown@intel.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH/RFC] Acer Aspire One fan control resume fix, improvements
Message-ID: <20090612143740.GA17845@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090604211103.4214303f.peter@piie.net>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

tried version 0.5.6, didn't (quite!) like it. ;)
Reason being that when suspending, every couple times there was
a fan state check error on resume, leading to the annoying issue of
kernel mode fan control getting disabled (via a safety measure).

ChangeLog:
- reduce maximum temperature check interval, 20 seconds seems a bit much
  (we have to take into account _external_ heat sources, too!)
- configure BIOS mode during suspend downtime, since our driver code is
  having a day off (and go back to previous setting after resume)
- update fan state variable during resume, to reflect new state after
  powering up
- optimization: add bios_settings pointer to current bios's settings,
  avoids array indirection
- change cmd_off, cmd_auto to fancmd[2] for streamlined code
- several improved log messages
- reverse fan state printing (every value that doesn't indicate "OFF" should
  definitely lead towards an "AUTO" fan setting!!!!)
  [some functional check was unsafe in this respect, too]
- use LONG_MAX instead of open-coded 0x7fffffffl

Suspend tested multiple times (on 2.6.30-rc8), checkpatch.pl:ed.
Version 0.5.7 was internal release only.
This patch is intended for Peter mainly, he should decide what to do with
that content - better don't commit it yet.

Signed-off-by: Andreas Mohr <andi@lisas.de>

--- linux-2.6.30-rc8.acerhdf/drivers/platform/x86/acerhdf.c.patched_orig	2009-06-12 10:39:30.000000000 +0200
+++ linux-2.6.30-rc8.acerhdf/drivers/platform/x86/acerhdf.c	2009-06-12 16:10:58.000000000 +0200
@@ -13,6 +13,7 @@
  *               - Carlos Corbacho  cathectic (at) gmail.com
  *  o lkml       - Matthew Garrett
  *               - Borislav Petkov
+ *               - Andreas Mohr
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -52,7 +53,7 @@
  */
 #undef START_IN_KERNEL_MODE
 
-#define VERSION "0.5.6"
+#define VERSION "0.5.8"
 
 /*
  * According to the Atom N270 datasheet,
@@ -62,8 +63,8 @@
  * assume 89°C is critical temperature.
  */
 #define ACERHDF_TEMP_CRIT 89
-#define ACERHDF_FAN_AUTO 1
 #define ACERHDF_FAN_OFF 0
+#define ACERHDF_FAN_AUTO 1
 
 /*
  * No matter what value the user puts into the fanon variable, turn on the fan
@@ -72,17 +73,18 @@
 #define ACERHDF_MAX_FANON 80
 
 /*
- * Maximal interval between two temperature checks is 20 seconds, as the die
- * can get hot really fast under heavy load
+ * Maximum interval between two temperature checks is 15 seconds, as the die
+ * can get hot really fast under heavy load (plus we shouldn't forget about
+ * possible impact of _external_ aggressive sources such as heaters, sun etc.)
  */
-#define ACERHDF_MAX_INTERVAL 20
+#define ACERHDF_MAX_INTERVAL 15
 
 /*
  * As temperatures can be negative, zero or positive, the value indicating
  * an error must be somewhere beyond valid temperature values.
- * 0x7fffffffl - highest possible positive long value should do the job.
+ * LONG_MAX (highest possible positive long value) should do the job.
  */
-#define ACERHDF_ERROR 0x7fffffffl
+#define ACERHDF_ERROR LONG_MAX
 
 
 #ifdef START_IN_KERNEL_MODE
@@ -97,7 +99,7 @@
 static unsigned int verbose;
 static unsigned int fanstate = ACERHDF_FAN_AUTO;
 static int disable_kernelmode;
-static int bios_version = -1;
+static int pre_suspend_kernelmode;
 static char force_bios[16];
 static unsigned int prev_interval;
 struct thermal_zone_device *acerhdf_thz_dev;
@@ -123,25 +125,26 @@
 	const char *version;
 	unsigned char fanreg;
 	unsigned char tempreg;
-	unsigned char cmd_off;
-	unsigned char cmd_auto;
+	unsigned char fancmd[2]; /* fan off and auto commands */
 };
 
 /* Register addresses and values for different BIOS versions */
-static const struct bios_settings_t bios_settings[] = {
-	{"Acer", "v0.3109", 0x55, 0x58, 0x1f, 0x00},
-	{"Acer", "v0.3114", 0x55, 0x58, 0x1f, 0x00},
-	{"Acer", "v0.3301", 0x55, 0x58, 0xaf, 0x00},
-	{"Acer", "v0.3304", 0x55, 0x58, 0xaf, 0x00},
-	{"Acer", "v0.3305", 0x55, 0x58, 0xaf, 0x00},
-	{"Acer", "v0.3308", 0x55, 0x58, 0x21, 0x00},
-	{"Acer", "v0.3309", 0x55, 0x58, 0x21, 0x00},
-	{"Acer", "v0.3310", 0x55, 0x58, 0x21, 0x00},
-	{"Gateway", "v0.3103", 0x55, 0x58, 0x21, 0x00},
-	{"Packard Bell", "v0.3105", 0x55, 0x58, 0x21, 0x00},
-	{"", 0, 0, 0, 0, 0}
+static const struct bios_settings_t bios_settings_table[] = {
+	{"Acer", "v0.3109", 0x55, 0x58, {0x1f, 0x00} },
+	{"Acer", "v0.3114", 0x55, 0x58, {0x1f, 0x00} },
+	{"Acer", "v0.3301", 0x55, 0x58, {0xaf, 0x00} },
+	{"Acer", "v0.3304", 0x55, 0x58, {0xaf, 0x00} },
+	{"Acer", "v0.3305", 0x55, 0x58, {0xaf, 0x00} },
+	{"Acer", "v0.3308", 0x55, 0x58, {0x21, 0x00} },
+	{"Acer", "v0.3309", 0x55, 0x58, {0x21, 0x00} },
+	{"Acer", "v0.3310", 0x55, 0x58, {0x21, 0x00} },
+	{"Gateway", "v0.3103", 0x55, 0x58, {0x21, 0x00} },
+	{"Packard Bell", "v0.3105", 0x55, 0x58, {0x21, 0x00} },
+	{"", 0, 0, 0, {0, 0} }
 };
 
+static const struct bios_settings_t *bios_settings __read_mostly;
+
 
 /* acer ec functions */
 static int acerhdf_get_temp(void)
@@ -149,7 +152,7 @@
 	u8 temp;
 
 	/* read temperature */
-	if (!ec_read(bios_settings[bios_version].tempreg, &temp)) {
+	if (!ec_read(bios_settings->tempreg, &temp)) {
 		if (verbose)
 			pr_notice("temp %d\n", temp);
 		return temp;
@@ -161,8 +164,8 @@
 {
 	u8 fan;
 
-	if (!ec_read(bios_settings[bios_version].fanreg, &fan))
-		return (fan == bios_settings[bios_version].cmd_off) ?
+	if (!ec_read(bios_settings->fanreg, &fan))
+		return (fan == bios_settings->fancmd[ACERHDF_FAN_OFF]) ?
 			ACERHDF_FAN_OFF : ACERHDF_FAN_AUTO;
 
 	return ACERHDF_ERROR;
@@ -173,19 +176,19 @@
 	unsigned char cmd;
 
 	if (verbose)
-		pr_notice("fan %s\n", (state == ACERHDF_FAN_AUTO) ?
-				"ON" : "OFF");
+		pr_notice("fan %s\n", (state == ACERHDF_FAN_OFF) ?
+				"OFF" : "ON");
 
-	if (state == ACERHDF_FAN_AUTO) {
-		cmd = bios_settings[bios_version].cmd_auto;
-		fanstate = ACERHDF_FAN_AUTO;
-	} else {
-		cmd = bios_settings[bios_version].cmd_off;
-		fanstate = ACERHDF_FAN_OFF;
+	if ((state != ACERHDF_FAN_OFF) && (state != ACERHDF_FAN_AUTO)) {
+		pr_err("invalid fan state %d requested, setting to auto!\n",
+			state);
+		state = ACERHDF_FAN_AUTO;
 	}
 
-	ec_write(bios_settings[bios_version].fanreg, cmd);
+	cmd = bios_settings->fancmd[state];
+	fanstate = state;
 
+	ec_write(bios_settings->fanreg, cmd);
 }
 
 /* helpers */
@@ -253,6 +256,18 @@
 	return 0;
 }
 
+/* provide one central function to set disable_kernelmode
+ * (always set ACERHDF_FAN_AUTO, too!) */
+static inline void acerhdf_revert_to_bios_mode(void)
+{
+	acerhdf_change_fanstate(ACERHDF_FAN_AUTO);
+	/*
+	 * let the thermal layer disable kernel mode. This ensures that
+	 * the thermal layer doesn't switch off the fan again
+	 */
+	disable_kernelmode = 1;
+}
+
 /*  current operation mode - enabled / disabled */
 static int acerhdf_get_mode(struct thermal_zone_device *thermal,
 		enum thermal_device_mode *mode)
@@ -279,13 +294,8 @@
 		pr_notice("kernel mode OFF\n");
 		thermal->polling_delay = 0;
 		thermal_zone_device_update(thermal);
-		acerhdf_change_fanstate(ACERHDF_FAN_AUTO);
 
-		/*
-		 * let the thermal layer disable kernel mode. This ensures that
-		 * the thermal layer doesn't switch off the fan again
-		 */
-		disable_kernelmode = 1;
+		acerhdf_revert_to_bios_mode();
 	} else {
 		kernelmode = 1;
 		pr_notice("kernel mode ON\n");
@@ -394,21 +404,19 @@
 	 */
 	if (cur_state != fanstate) {
 		pr_err("failed reading fan state, "
-				"disabling kernelmode.\n");
+				"falling back to default BIOS handling.\n");
 		pr_err("read state: %d expected state: %d\n",
 				cur_state, fanstate);
 
-		acerhdf_change_fanstate(ACERHDF_FAN_AUTO);
-		disable_kernelmode = 1;
+		acerhdf_revert_to_bios_mode();
 		return -EINVAL;
 	}
 	/* same with temperature */
 	if (cur_temp == ACERHDF_ERROR) {
 		pr_err("failed reading temperature, "
-				"disabling kernelmode.\n");
+				"falling back to default BIOS handling.\n");
 
-		acerhdf_change_fanstate(ACERHDF_FAN_AUTO);
-		disable_kernelmode = 1;
+		acerhdf_revert_to_bios_mode();
 		return -EINVAL;
 	}
 
@@ -437,11 +445,21 @@
 		pm_message_t state)
 {
 	/*
-	 * in kernelmode turn on fan, because the aspire one awakes with
-	 * spinning fan
+	 * always revert to BIOS mode during suspend/resume activities:
+	 * a) during suspend our driver is inactive, thus if there's
+	 *    anything to be done fan-wise, it's the BIOS's job...
+	 * b) Aspire awakes with spinning fan in BIOS mode,
+	 *    thus we better do the same (behaviour is preserved if we use BIOS)
 	 */
-	if (kernelmode)
+
+	/* remember previous setting */
+	pre_suspend_kernelmode = kernelmode;
+
+	if (kernelmode) {
 		acerhdf_change_fanstate(ACERHDF_FAN_AUTO);
+		kernelmode = 0;
+	}
+
 	if (verbose)
 		pr_notice("going suspend\n");
 	return 0;
@@ -449,6 +467,14 @@
 
 static int acerhdf_resume(struct platform_device *device)
 {
+	kernelmode = pre_suspend_kernelmode;
+
+	/* update our fanstate variable to the possibly different
+	 * post-resume fan state
+	 * (to prevent a safety check from failing)
+	 */
+	fanstate = acerhdf_get_fanstate();
+
 	if (verbose)
 		pr_notice("resuming\n");
 	return 0;
@@ -526,15 +552,16 @@
 
 
 	/* search BIOS version and BIOS vendor in BIOS settings table */
-	for (i = 0; bios_settings[i].version[0]; ++i) {
-		if (!strcmp(bios_settings[i].vendor, vendor) &&
-				!strcmp(bios_settings[i].version, version)) {
-			bios_version = i;
+	for (i = 0; bios_settings_table[i].version[0]; ++i) {
+		if (!strcmp(bios_settings_table[i].vendor, vendor) &&
+		    !strcmp(bios_settings_table[i].version, version)) {
+			bios_settings = &bios_settings_table[i];
 			break;
 		}
 	}
-	if (bios_version == -1) {
-		pr_err("cannot find BIOS version\n");
+	if (!bios_settings) {
+		pr_err("unknown (unsupported) BIOS version %s/%s, "
+			"please report, aborting!\n", vendor, version);
 		return ACERHDF_ERROR;
 	}
 	return 0;
