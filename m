Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbZK0HbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbZK0HbY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 02:31:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754076AbZK0HbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 02:31:23 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56097 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890AbZK0HbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 02:31:23 -0500
Date: Fri, 27 Nov 2009 08:31:19 +0100
From: Pavel Machek <pavel@ucw.cz>
To: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz
Subject: [patch] spitz: better voltage-to-percentage conversion
Message-ID: <20091127073119.GB1405@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Old code has two huge tables... unfortunately those tables are simple
linear relationships and wrong: li-ions do not behave like that.

Convert physical values to mV,mA,mOhm, add computation that makes
sense for physical point of view, and provide tables based on
measurements.

To get even better results, we should provide better battery_current
estimate (taking backlight into account), and adjust adjust
battery_resistance according to its age and temperature. 

Signed-off-by: Pavel Machek <pavel@ucw.cz>


--- a/arch/arm/mach-pxa/corgi_pm.c	2009-11-23 20:48:26.000000000 +0100
+++ b/arch/arm/mach-pxa/corgi_pm.c	2009-11-23 06:45:45.000000000 +0100
@@ -215,7 +215,6 @@
 	.fatal_noacin_volt= SHARPSL_FATAL_NOACIN_VOLT,
 	.bat_levels       = 40,
 	.bat_levels_noac  = sharpsl_battery_levels_noac,
-	.bat_levels_acin  = sharpsl_battery_levels_acin,
 	.status_high_acin = 188,
 	.status_low_acin  = 178,
 	.status_high_noac = 185,
--- a/arch/arm/mach-pxa/sharpsl_pm.c	2009-11-23 20:48:26.000000000 +0100
+++ b/arch/arm/mach-pxa/sharpsl_pm.c	2009-11-23 06:47:01.000000000 +0100
@@ -78,90 +78,25 @@
 
 
 
-struct battery_thresh sharpsl_battery_levels_acin[] = {
-	{ 213, 100},
-	{ 212,  98},
-	{ 211,  95},
-	{ 210,  93},
-	{ 209,  90},
-	{ 208,  88},
-	{ 207,  85},
-	{ 206,  83},
-	{ 205,  80},
-	{ 204,  78},
-	{ 203,  75},
-	{ 202,  73},
-	{ 201,  70},
-	{ 200,  68},
-	{ 199,  65},
-	{ 198,  63},
-	{ 197,  60},
-	{ 196,  58},
-	{ 195,  55},
-	{ 194,  53},
-	{ 193,  50},
-	{ 192,  48},
-	{ 192,  45},
-	{ 191,  43},
-	{ 191,  40},
-	{ 190,  38},
-	{ 190,  35},
-	{ 189,  33},
-	{ 188,  30},
-	{ 187,  28},
-	{ 186,  25},
-	{ 185,  23},
-	{ 184,  20},
-	{ 183,  18},
-	{ 182,  15},
-	{ 181,  13},
-	{ 180,  10},
-	{ 179,   8},
-	{ 178,   5},
-	{   0,   0},
-};
-
 struct battery_thresh sharpsl_battery_levels_noac[] = {
-	{ 213, 100},
-	{ 212,  98},
-	{ 211,  95},
-	{ 210,  93},
-	{ 209,  90},
-	{ 208,  88},
-	{ 207,  85},
-	{ 206,  83},
-	{ 205,  80},
-	{ 204,  78},
-	{ 203,  75},
-	{ 202,  73},
-	{ 201,  70},
-	{ 200,  68},
-	{ 199,  65},
-	{ 198,  63},
-	{ 197,  60},
-	{ 196,  58},
-	{ 195,  55},
-	{ 194,  53},
-	{ 193,  50},
-	{ 192,  48},
-	{ 191,  45},
-	{ 190,  43},
-	{ 189,  40},
-	{ 188,  38},
-	{ 187,  35},
-	{ 186,  33},
-	{ 185,  30},
-	{ 184,  28},
-	{ 183,  25},
-	{ 182,  23},
-	{ 181,  20},
-	{ 180,  18},
-	{ 179,  15},
-	{ 178,  13},
-	{ 177,  10},
-	{ 176,   8},
-	{ 175,   5},
-	{   0,   0},
+	{ 3980, 100 },
+	{ 3900, 95 },
+	{ 3860, 90 },
+	{ 3800, 85 },
+	{ 3760, 80 },
+	{ 3720, 74 },
+	{ 3680, 69 },
+	{ 3620, 65 },
+	{ 3570, 59 },
+	{ 3560, 55 },
+	{ 3550, 48 },
+	{ 3530, 45 },
+	{ 3510, 39 },
+	{ 3490, 33 },
+	{ 3470, 29 },
+	{ 3450, 23 },
+	{ 3410, 16 },
+	{    0, 0 },
 };
 
 /* MAX1111 Commands */
@@ -194,16 +129,64 @@
 #endif
 }
 
-static int get_percentage(int voltage)
+
+typedef int miliamp_t;
+typedef int miliohm_t;
+typedef int milivolt_t;
+
+miliamp_t basic_current = 125;
+miliohm_t battery_resistance = 100;
+
+/* 422 seems to be suitable for very old, 1Ah battery.
+   2Ah battery probably has better resistance */
+
+/* Unfortunately, resistance depends on state of charge, current
+ * direction and temperature.
+ *
+ * Ouch, and dependency is actually _not_ too simple. It is lowest
+ * at 3.55V, very slowly rises at 4V (approximately linear dependency),
+ * and quickly rises towards 3.2V (in something exponential-looking).
+ *
+ * It is about same at 25Celsius and 40Celsius, and about 2.5x the value
+ * on 0Celsius, rising _very_ sharply.
+ *
+ * Li-ion should only be charged between 0 and 45 Celsius, and discharged
+ * between -20 and 60 celsius.
+ */
+
+extern int backlight_current;
+
+/* Positive values: current drawn from battery */
+miliamp_t battery_current(void)
+{
+	if (sharpsl_pm.charge_mode == CHRG_ON)
+		return 0;
+
+	return basic_current;
+}
+
+milivolt_t liion_internal_voltage(milivolt_t voltage, miliamp_t current_ma)
+{
+	return voltage + (battery_resistance * current_ma / 1000);
+}
+
+/* returns mV */
+milivolt_t liion_voltage(int adc)
+{
+	/* Thanks to Stanislav B. ADC has 3.3V as reference,
+	   is connected to battery over 47kOhm,
+	   and to ground over 100kOhm. */
+	return (adc * 147 * 33)/256;
+}
+
+static int get_percentage(int voltage_adc)
 {
 	int i = sharpsl_pm.machinfo->bat_levels - 1;
 	int bl_status = sharpsl_pm.machinfo->backlight_get_status ? sharpsl_pm.machinfo->backlight_get_status() : 0;
 	struct battery_thresh *thresh;
+	milivolt_t voltage = liion_voltage(voltage_adc);
 
-	if (sharpsl_pm.charge_mode == CHRG_ON)
-		thresh = bl_status ? sharpsl_pm.machinfo->bat_levels_acin_bl : sharpsl_pm.machinfo->bat_levels_acin;
-	else
-		thresh = bl_status ? sharpsl_pm.machinfo->bat_levels_noac_bl : sharpsl_pm.machinfo->bat_levels_noac;
+	thresh = sharpsl_pm.machinfo->bat_levels_noac;
 
 	while (i > 0 && (voltage > thresh[i].voltage))
 		i--;
--- a/arch/arm/mach-pxa/spitz_pm.c	2009-11-23 20:48:26.000000000 +0100
+++ b/arch/arm/mach-pxa/spitz_pm.c	2009-11-23 06:45:25.000000000 +0100
@@ -209,7 +209,6 @@
 	.fatal_noacin_volt= SHARPSL_FATAL_NOACIN_VOLT,
 	.bat_levels       = 40,
 	.bat_levels_noac  = sharpsl_battery_levels_noac,
-	.bat_levels_acin  = sharpsl_battery_levels_acin,
 	.status_high_acin = 188,
 	.status_low_acin  = 178,
 	.status_high_noac = 185,

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
