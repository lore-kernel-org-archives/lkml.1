Return-Path: <linux-kernel-owner+w=401wt.eu-S1757529AbZE2K5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529AbZE2K5Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 06:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755096AbZE2K5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 06:57:05 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43978 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991AbZE2K5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 06:57:04 -0400
Date: Fri, 29 May 2009 12:56:19 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Cc: Cyril Hrubis <metan@ucw.cz>
Subject: unbreak suspend on zaurus on 2.6.30-rc6
Message-ID: <20090529105619.GA24187@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

This is hacky patch to unbreak suspend on -rc6; perhaps it will be
useful to someone.

								Pavel

--- clean-rc6/arch/arm/common/sharpsl_pm.c	2009-05-29 01:10:31.000000000 +0200
+++ linux-rc6/arch/arm/common/sharpsl_pm.c	2009-05-28 23:28:30.000000000 +0200
@@ -12,7 +12,7 @@
  *
  */
 
-#undef DEBUG
+#define DEBUG
 
 #include <linux/module.h>
 #include <linux/timer.h>
@@ -546,6 +546,9 @@
 
 static int corgi_enter_suspend(unsigned long alarm_time, unsigned int alarm_enable, suspend_state_t state)
 {
+
+  return 0;
+
 	if (!sharpsl_pm.machinfo->should_wakeup(!(sharpsl_pm.flags & SHARPSL_ALARM_ACTIVE) && alarm_enable) )
 	{
 		if (!(sharpsl_pm.flags & SHARPSL_ALARM_ACTIVE)) {
@@ -553,7 +556,7 @@
 			corgi_goto_sleep(alarm_time, alarm_enable, state);
 			return 1;
 		}
-		if(sharpsl_off_charge_battery()) {
+		if (sharpsl_off_charge_battery()) {
 			dev_dbg(sharpsl_pm.dev, "Charging. Suspend...\n");
 			corgi_goto_sleep(alarm_time, alarm_enable, state);
 			return 1;
diff -ur clean-rc6/arch/arm/mach-pxa/pm.c linux-rc6/arch/arm/mach-pxa/pm.c
--- clean-rc6/arch/arm/mach-pxa/pm.c	2009-05-29 01:11:02.000000000 +0200
+++ linux-rc6/arch/arm/mach-pxa/pm.c	2009-05-28 23:29:54.000000000 +0200
@@ -15,11 +15,14 @@
 #include <linux/suspend.h>
 #include <linux/errno.h>
 
+#include <mach/spitz.h>
 #include <mach/pm.h>
 
 struct pxa_cpu_pm_fns *pxa_cpu_pm_fns;
 static unsigned long *sleep_save;
 
+extern  int pxa27x_cpu_pm_prepare(void);
+
 int pxa_pm_enter(suspend_state_t state)
 {
 	unsigned long sleep_save_checksum = 0, checksum = 0;
@@ -39,15 +42,21 @@
 			sleep_save_checksum += sleep_save[i];
 	}
 
+	pxa27x_cpu_pm_prepare();
+	//	PSPR = virt_to_phys(pxa_cpu_resume);
+
 	/* *** go zzz *** */
 	pxa_cpu_pm_fns->enter(state);
 	cpu_init();
 
+	gpio_set_value(SPITZ_GPIO_LED_ORANGE, 1);
+
+
 	if (state != PM_SUSPEND_STANDBY) {
 		/* after sleeping, validate the checksum */
 		for (i = 0; i < pxa_cpu_pm_fns->save_count - 1; i++)
 			checksum += sleep_save[i];
-
+#if 0
 		/* if invalid, display message and wait for a hardware reset */
 		if (checksum != sleep_save_checksum) {
 
@@ -56,6 +65,7 @@
 			while (1)
 				pxa_cpu_pm_fns->enter(state);
 		}
+#endif
 		pxa_cpu_pm_fns->restore(sleep_save);
 	}
 
diff -ur clean-rc6/arch/arm/mach-pxa/pxa27x.c linux-rc6/arch/arm/mach-pxa/pxa27x.c
--- clean-rc6/arch/arm/mach-pxa/pxa27x.c	2009-05-29 01:11:02.000000000 +0200
+++ linux-rc6/arch/arm/mach-pxa/pxa27x.c	2009-05-28 23:28:30.000000000 +0200
@@ -264,7 +264,7 @@
 	return state == PM_SUSPEND_MEM || state == PM_SUSPEND_STANDBY;
 }
 
-static int pxa27x_cpu_pm_prepare(void)
+ int pxa27x_cpu_pm_prepare(void)
 {
 	/* set resume return address */
 	PSPR = virt_to_phys(pxa_cpu_resume);
diff -ur clean-rc6/arch/arm/mach-pxa/spitz_pm.c linux-rc6/arch/arm/mach-pxa/spitz_pm.c
--- clean-rc6/arch/arm/mach-pxa/spitz_pm.c	2009-05-29 01:11:02.000000000 +0200
+++ linux-rc6/arch/arm/mach-pxa/spitz_pm.c	2009-05-28 23:28:30.000000000 +0200
@@ -124,6 +124,7 @@
 	int is_resume = 0;
 	int acin = sharpsl_pm.machinfo->read_devdata(SHARPSL_STATUS_ACIN);
 
+#if 0
 	if (spitz_last_ac_status != acin) {
 		if (acin) {
 			/* charge on */
@@ -141,6 +142,8 @@
 		return 0;
 	}
 
+#endif
+
 	if (PEDR & GPIO_bit(SPITZ_GPIO_KEY_INT))
 		is_resume |= GPIO_bit(SPITZ_GPIO_KEY_INT);
 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
