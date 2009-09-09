Return-Path: <linux-kernel-owner+w=401wt.eu-S1753220AbZIIOAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbZIIOAm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 10:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbZIIOAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 10:00:41 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49076 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134AbZIIOAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 10:00:40 -0400
Date: Wed, 9 Sep 2009 09:39:04 +0200
From: Pavel Machek <pavel@ucw.cz>
To: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz, Russell King <rmk@arm.linux.org.uk>
Subject: [patch] zaurus family: battery cleanups
Message-ID: <20090909073904.GE1327@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This cleans up battery code to conform to codingstyle. The only real
change is that we should now refuse to charge if we can't read battery
temperature.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

--- linux-rc/arch/arm.ofic/mach-pxa/sharpsl_pm.c	2009-08-28 00:19:10.000000000 +0200
+++ linux-rc/arch/arm/mach-pxa/sharpsl_pm.c	2009-09-08 20:50:01.000000000 +0200
@@ -78,92 +78,6 @@
 
 
 
-struct battery_thresh spitz_battery_levels_acin[] = {
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
-struct battery_thresh  spitz_battery_levels_noac[] = {
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
-};
-
 /* MAX1111 Commands */
 #define MAXCTRL_PD0      1u << 0
 #define MAXCTRL_PD1      1u << 1
@@ -238,7 +152,7 @@
 
 static void sharpsl_battery_thread(struct work_struct *private_)
 {
-	int voltage, percent, apm_status, i = 0;
+	int voltage, percent, apm_status, i;
 
 	if (!sharpsl_pm.machinfo)
 		return;
@@ -250,15 +164,13 @@
 			&& time_after(jiffies, sharpsl_pm.charge_start_time +  SHARPSL_CHARGE_ON_TIME_INTERVAL))
 		schedule_delayed_work(&toggle_charger, 0);
 
-	while(1) {
+	for (i=0; i<5; i++) {
 		voltage = sharpsl_pm.machinfo->read_devdata(SHARPSL_BATT_VOLT);
-
 		if (voltage > 0) break;
-		if (i++ > 5) {
-			voltage = sharpsl_pm.machinfo->bat_levels_noac[0].voltage;
-			dev_warn(sharpsl_pm.dev, "Warning: Cannot read main battery!\n");
-			break;
-		}
+	}
+	if (voltage <= 0) {
+		voltage = sharpsl_pm.machinfo->bat_levels_noac[0].voltage;
+		dev_warn(sharpsl_pm.dev, "Warning: Cannot read main battery!\n");
 	}
 
 	voltage = sharpsl_average_value(voltage);
@@ -267,7 +179,9 @@
 
 	/* At low battery voltages, the voltage has a tendency to start
            creeping back up so we try to avoid this here */
-	if ((sharpsl_pm.battstat.ac_status == APM_AC_ONLINE) || (apm_status == APM_BATTERY_STATUS_HIGH) ||  percent <= sharpsl_pm.battstat.mainbat_percent) {
+	if ((sharpsl_pm.battstat.ac_status == APM_AC_ONLINE)
+	    || (apm_status == APM_BATTERY_STATUS_HIGH) 
+	    || percent <= sharpsl_pm.battstat.mainbat_percent) {
 		sharpsl_pm.battstat.mainbat_voltage = voltage;
 		sharpsl_pm.battstat.mainbat_status = apm_status;
 		sharpsl_pm.battstat.mainbat_percent = percent;
@@ -279,8 +193,8 @@
 #ifdef CONFIG_BACKLIGHT_CORGI
 	/* If battery is low. limit backlight intensity to save power. */
 	if ((sharpsl_pm.battstat.ac_status != APM_AC_ONLINE)
-			&& ((sharpsl_pm.battstat.mainbat_status == APM_BATTERY_STATUS_LOW) ||
-			(sharpsl_pm.battstat.mainbat_status == APM_BATTERY_STATUS_CRITICAL))) {
+	    && ((sharpsl_pm.battstat.mainbat_status == APM_BATTERY_STATUS_LOW) 
+	    || (sharpsl_pm.battstat.mainbat_status == APM_BATTERY_STATUS_CRITICAL))) {
 		if (!(sharpsl_pm.flags & SHARPSL_BL_LIMIT)) {
 			sharpsl_pm.machinfo->backlight_limit(1);
 			sharpsl_pm.flags |= SHARPSL_BL_LIMIT;
@@ -293,8 +207,8 @@
 
 	/* Suspend if critical battery level */
 	if ((sharpsl_pm.battstat.ac_status != APM_AC_ONLINE)
-			&& (sharpsl_pm.battstat.mainbat_status == APM_BATTERY_STATUS_CRITICAL)
-			&& !(sharpsl_pm.flags & SHARPSL_APM_QUEUED)) {
+	     && (sharpsl_pm.battstat.mainbat_status == APM_BATTERY_STATUS_CRITICAL)
+	     && !(sharpsl_pm.flags & SHARPSL_APM_QUEUED)) {
 		sharpsl_pm.flags |= SHARPSL_APM_QUEUED;
 		dev_err(sharpsl_pm.dev, "Fatal Off\n");
 		apm_queue_event(APM_CRITICAL_SUSPEND);
@@ -339,6 +253,8 @@
 
 static void sharpsl_charge_error(void)
 {
+	dev_warn(sharpsl_pm.dev, "Charger Error\n");
+
 	sharpsl_pm_led(SHARPSL_LED_ERROR);
 	sharpsl_pm.machinfo->charge(0);
 	sharpsl_pm.charge_mode = CHRG_ERROR;
@@ -346,7 +262,7 @@
 
 static void sharpsl_charge_toggle(struct work_struct *private_)
 {
-	dev_dbg(sharpsl_pm.dev, "Toogling Charger at time: %lx\n", jiffies);
+	dev_dbg(sharpsl_pm.dev, "Toggling Charger at time: %lx\n", jiffies);
 
 	if (!sharpsl_pm.machinfo->read_devdata(SHARPSL_STATUS_ACIN)) {
 		sharpsl_charge_off();
@@ -535,8 +451,10 @@
 	val = get_select_val(buff);
 
 	dev_dbg(sharpsl_pm.dev, "Temperature: %d\n", val);
-	if (val > sharpsl_pm.machinfo->charge_on_temp) {
-		printk(KERN_WARNING "Not charging: temperature out of limits.\n");
+	/* FIXME: this should catch battery read errors, but we should
+	   probably avoid charging in <0C temperatures, too. */ 
+	if ((val < 0) || (val > sharpsl_pm.machinfo->charge_on_temp)) {
+		dev_warn(sharpsl_pm.dev, "Not charging: temperature %d out of limits.\n", val);
 		return -1;
 	}
 
@@ -590,7 +508,7 @@
 	dev_dbg(sharpsl_pm.dev, "AC Voltage: %d\n",temp);
 
 	if ((temp > sharpsl_pm.machinfo->charge_acin_high) || (temp < sharpsl_pm.machinfo->charge_acin_low)) {
-		dev_err(sharpsl_pm.dev, "Error: AC check failed.\n");
+		dev_err(sharpsl_pm.dev, "Error: AC check failed: voltage %d.\n", temp);
 		return -1;
 	}
 
@@ -624,9 +542,9 @@
 
 static void corgi_goto_sleep(unsigned long alarm_time, unsigned int alarm_enable, suspend_state_t state)
 {
-	dev_dbg(sharpsl_pm.dev, "Time is: %08x\n",RCNR);
+	dev_dbg(sharpsl_pm.dev, "Time is: %08x\n", RCNR);
 
-	dev_dbg(sharpsl_pm.dev, "Offline Charge Activate = %d\n",sharpsl_pm.flags & SHARPSL_DO_OFFLINE_CHRG);
+	dev_dbg(sharpsl_pm.dev, "Offline Charge Activate = %d\n", sharpsl_pm.flags & SHARPSL_DO_OFFLINE_CHRG);
 	/* not charging and AC-IN! */
 
 	if ((sharpsl_pm.flags & SHARPSL_DO_OFFLINE_CHRG) && (sharpsl_pm.machinfo->read_devdata(SHARPSL_STATUS_ACIN))) {
@@ -644,12 +562,12 @@
 	if ((sharpsl_pm.charge_mode == CHRG_ON) && ((alarm_enable && ((alarm_time - RCNR) > (SHARPSL_BATCHK_TIME_SUSPEND + 30))) || !alarm_enable)) {
 		RTSR &= RTSR_ALE;
 		RTAR = RCNR + SHARPSL_BATCHK_TIME_SUSPEND;
-		dev_dbg(sharpsl_pm.dev, "Charging alarm at: %08x\n",RTAR);
+		dev_dbg(sharpsl_pm.dev, "Charging alarm at: %08x\n", RTAR);
 		sharpsl_pm.flags |= SHARPSL_ALARM_ACTIVE;
 	} else if (alarm_enable) {
 		RTSR &= RTSR_ALE;
 		RTAR = alarm_time;
-		dev_dbg(sharpsl_pm.dev, "User alarm at: %08x\n",RTAR);
+		dev_dbg(sharpsl_pm.dev, "User alarm at: %08x\n", RTAR);
 	} else {
 		dev_dbg(sharpsl_pm.dev, "No alarms set.\n");
 	}
@@ -658,7 +576,7 @@
 
 	sharpsl_pm.machinfo->postsuspend();
 
-	dev_dbg(sharpsl_pm.dev, "Corgi woken up from suspend: %08x\n",PEDR);
+	dev_dbg(sharpsl_pm.dev, "Corgi woken up from suspend: %08x\n", PEDR);
 }
 
 static int corgi_enter_suspend(unsigned long alarm_time, unsigned int alarm_enable, suspend_state_t state)
@@ -670,7 +588,7 @@
 			corgi_goto_sleep(alarm_time, alarm_enable, state);
 			return 1;
 		}
-		if(sharpsl_off_charge_battery()) {
+		if (sharpsl_off_charge_battery()) {
 			dev_dbg(sharpsl_pm.dev, "Charging. Suspend...\n");
 			corgi_goto_sleep(alarm_time, alarm_enable, state);
 			return 1;
@@ -678,8 +596,8 @@
 		dev_dbg(sharpsl_pm.dev, "User triggered wakeup in offline charger.\n");
 	}
 
-	if ((!sharpsl_pm.machinfo->read_devdata(SHARPSL_STATUS_LOCK)) || (sharpsl_fatal_check() < 0) )
-	{
+	if ((!sharpsl_pm.machinfo->read_devdata(SHARPSL_STATUS_LOCK)) || 
+	    (!sharpsl_pm.machinfo->read_devdata(SHARPSL_STATUS_FATAL)))	{
 		dev_err(sharpsl_pm.dev, "Fatal condition. Suspend.\n");
 		corgi_goto_sleep(alarm_time, alarm_enable, state);
 		return 1;
@@ -697,7 +615,7 @@
 
 	corgi_goto_sleep(alarm_time, alarm_status, state);
 
-	while (corgi_enter_suspend(alarm_time,alarm_status,state))
+	while (corgi_enter_suspend(alarm_time, alarm_status, state))
 		{}
 
 	if (sharpsl_pm.machinfo->earlyresume)
@@ -812,7 +730,7 @@
 		mdelay(SHARPSL_CHARGE_CO_CHECK_TIME);
 
 		time = RCNR;
-		while(1) {
+		while (1) {
 			/* Check if any wakeup event had occurred */
 			if (sharpsl_pm.machinfo->charger_wakeup() != 0)
 				return 0;
@@ -835,9 +753,9 @@
 	mdelay(SHARPSL_CHARGE_CO_CHECK_TIME);
 
 	time = RCNR;
-	while(1) {
+	while (1) {
 		/* Check if any wakeup event had occurred */
-		if (sharpsl_pm.machinfo->charger_wakeup() != 0)
+		if (sharpsl_pm.machinfo->charger_wakeup())
 			return 0;
 		/* Check for timeout */
 		if ((RCNR-time) > SHARPSL_WAIT_CO_TIME) {
@@ -864,12 +782,12 @@
 
 static ssize_t battery_percentage_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%d\n",sharpsl_pm.battstat.mainbat_percent);
+	return sprintf(buf, "%d\n", sharpsl_pm.battstat.mainbat_percent);
 }
 
 static ssize_t battery_voltage_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%d\n",sharpsl_pm.battstat.mainbat_voltage);
+	return sprintf(buf, "%d\n", sharpsl_pm.battstat.mainbat_voltage);
 }
 
 static DEVICE_ATTR(battery_percentage, 0444, battery_percentage_show, NULL);
@@ -943,8 +861,7 @@
 		}
 	}
 
-	if (sharpsl_pm.machinfo->batfull_irq)
-	{
+	if (sharpsl_pm.machinfo->batfull_irq) {
 		/* Register interrupt handler. */
 		if (request_irq(IRQ_GPIO(sharpsl_pm.machinfo->gpio_batfull), sharpsl_chrg_full_isr, IRQF_DISABLED | IRQF_TRIGGER_RISING, "CO", sharpsl_chrg_full_isr)) {
 			dev_err(sharpsl_pm.dev, "Could not get irq %d.\n", IRQ_GPIO(sharpsl_pm.machinfo->gpio_batfull));
Only in linux-rc/arch/arm/mach-pxa: sharpsl_pm.c.orig
Only in linux-rc/arch/arm/mach-pxa: sharpsl_pm.c~
Binary files linux-rc/arch/arm.ofic/mach-pxa/sharpsl_pm.o and linux-rc/arch/arm/mach-pxa/sharpsl_pm.o differ
diff -ur linux-rc/arch/arm.ofic/mach-pxa/spitz_pm.c linux-rc/arch/arm/mach-pxa/spitz_pm.c
--- linux-rc/arch/arm.ofic/mach-pxa/spitz_pm.c	2009-08-28 00:19:10.000000000 +0200
+++ linux-rc/arch/arm/mach-pxa/spitz_pm.c	2009-09-08 20:56:01.000000000 +0200
@@ -37,6 +37,93 @@
 
 static int spitz_last_ac_status;
 
+struct battery_thresh spitz_battery_levels_acin[] = {
+	{ 213, 100},
+	{ 212,  98},
+	{ 211,  95},
+	{ 210,  93},
+	{ 209,  90},
+	{ 208,  88},
+	{ 207,  85},
+	{ 206,  83},
+	{ 205,  80},
+	{ 204,  78},
+	{ 203,  75},
+	{ 202,  73},
+	{ 201,  70},
+	{ 200,  68},
+	{ 199,  65},
+	{ 198,  63},
+	{ 197,  60},
+	{ 196,  58},
+	{ 195,  55},
+	{ 194,  53},
+	{ 193,  50},
+	{ 192,  48},
+	{ 192,  45},
+	{ 191,  43},
+	{ 191,  40},
+	{ 190,  38},
+	{ 190,  35},
+	{ 189,  33},
+	{ 188,  30},
+	{ 187,  28},
+	{ 186,  25},
+	{ 185,  23},
+	{ 184,  20},
+	{ 183,  18},
+	{ 182,  15},
+	{ 181,  13},
+	{ 180,  10},
+	{ 179,   8},
+	{ 178,   5},
+	{   0,   0},
+};
+
+struct battery_thresh  spitz_battery_levels_noac[] = {
+	{ 213, 100},
+	{ 212,  98},
+	{ 211,  95},
+	{ 210,  93},
+	{ 209,  90},
+	{ 208,  88},
+	{ 207,  85},
+	{ 206,  83},
+	{ 205,  80},
+	{ 204,  78},
+	{ 203,  75},
+	{ 202,  73},
+	{ 201,  70},
+	{ 200,  68},
+	{ 199,  65},
+	{ 198,  63},
+	{ 197,  60},
+	{ 196,  58},
+	{ 195,  55},
+	{ 194,  53},
+	{ 193,  50},
+	{ 192,  48},
+	{ 191,  45},
+	{ 190,  43},
+	{ 189,  40},
+	{ 188,  38},
+	{ 187,  35},
+	{ 186,  33},
+	{ 185,  30},
+	{ 184,  28},
+	{ 183,  25},
+	{ 182,  23},
+	{ 181,  20},
+	{ 180,  18},
+	{ 179,  15},
+	{ 178,  13},
+	{ 177,  10},
+	{ 176,   8},
+	{ 175,   5},
+	{   0,   0},
+};
+
+
 static void spitz_charger_init(void)
 {
 	pxa_gpio_mode(SPITZ_GPIO_KEY_INT | GPIO_IN);
 
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
