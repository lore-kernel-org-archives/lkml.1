Return-Path: <linux-kernel-owner+w=401wt.eu-S932693AbXHXTmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693AbXHXTmR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 15:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752439AbXHXTmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 15:42:05 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:37387 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbXHXTmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 15:42:04 -0400
Date: Fri, 24 Aug 2007 21:42:01 +0200
From: Olaf Hering <olaf@aepfle.de>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH] fix undefined reference to device_power_up/resume
Message-ID: <20070824194201.GA8737@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Current Linus tree fails to link on pmac32:

drivers/built-in.o: In function `pmac_wakeup_devices':
via-pmu.c:(.text+0x5bab4): undefined reference to `device_power_up'
via-pmu.c:(.text+0x5bb08): undefined reference to `device_resume'
drivers/built-in.o: In function `pmac_suspend_devices':
via-pmu.c:(.text+0x5c260): undefined reference to `device_power_down'
via-pmu.c:(.text+0x5c27c): undefined reference to `device_resume'
make[1]: *** [.tmp_vmlinux1] Error 1

changing CONFIG_PM > CONFIG_PM_SLEEP leads to:

drivers/built-in.o: In function `pmu_led_set':
via-pmu-led.c:(.text+0x5cdca): undefined reference to `pmu_sys_suspended'
via-pmu-led.c:(.text+0x5cdce): undefined reference to `pmu_sys_suspended'
drivers/built-in.o: In function `pmu_req_done':
via-pmu-led.c:(.text+0x5ce3e): undefined reference to `pmu_sys_suspended'
via-pmu-led.c:(.text+0x5ce42): undefined reference to `pmu_sys_suspended'
drivers/built-in.o: In function `adb_init':
(.init.text+0x4c5c): undefined reference to `pmu_register_sleep_notifier'
make[1]: *** [.tmp_vmlinux1] Error 1

So change even more places from PM to PM_SLEEP to allow linking.

Signed-off-by: Olaf Hering <olaf@aepfle.de>

---
 drivers/macintosh/adb.c     |    4 ++--
 drivers/macintosh/via-pmu.c |   34 +++++++++++++++++-----------------
 include/linux/pmu.h         |    2 +-
 3 files changed, 20 insertions(+), 20 deletions(-)

--- a/drivers/macintosh/adb.c
+++ b/drivers/macintosh/adb.c
@@ -89,7 +89,7 @@ static int sleepy_trackpad;
 static int autopoll_devs;
 int __adb_probe_sync;
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static void adb_notify_sleep(struct pmu_sleep_notifier *self, int when);
 static struct pmu_sleep_notifier adb_sleep_notifier = {
 	adb_notify_sleep,
@@ -313,7 +313,7 @@ int __init adb_init(void)
 		printk(KERN_WARNING "Warning: no ADB interface detected\n");
 		adb_controller = NULL;
 	} else {
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 		pmu_register_sleep_notifier(&adb_sleep_notifier);
 #endif /* CONFIG_PM */
 #ifdef CONFIG_PPC
--- a/drivers/macintosh/via-pmu.c
+++ b/drivers/macintosh/via-pmu.c
@@ -152,10 +152,10 @@ static spinlock_t pmu_lock;
 static u8 pmu_intr_mask;
 static int pmu_version;
 static int drop_interrupts;
-#if defined(CONFIG_PM) && defined(CONFIG_PPC32)
+#if defined(CONFIG_PM_SLEEP) && defined(CONFIG_PPC32)
 static int option_lid_wakeup = 1;
-#endif /* CONFIG_PM && CONFIG_PPC32 */
-#if (defined(CONFIG_PM)&&defined(CONFIG_PPC32))||defined(CONFIG_PMAC_BACKLIGHT_LEGACY)
+#endif /* CONFIG_PM_SLEEP && CONFIG_PPC32 */
+#if (defined(CONFIG_PM_SLEEP)&&defined(CONFIG_PPC32))||defined(CONFIG_PMAC_BACKLIGHT_LEGACY)
 static int sleep_in_progress;
 #endif
 static unsigned long async_req_locks;
@@ -875,7 +875,7 @@ proc_read_options(char *page, char **sta
 {
 	char *p = page;
 
-#if defined(CONFIG_PM) && defined(CONFIG_PPC32)
+#if defined(CONFIG_PM_SLEEP) && defined(CONFIG_PPC32)
 	if (pmu_kind == PMU_KEYLARGO_BASED &&
 	    pmac_call_feature(PMAC_FTR_SLEEP_STATE,NULL,0,-1) >= 0)
 		p += sprintf(p, "lid_wakeup=%d\n", option_lid_wakeup);
@@ -916,7 +916,7 @@ proc_write_options(struct file *file, co
 	*(val++) = 0;
 	while(*val == ' ')
 		val++;
-#if defined(CONFIG_PM) && defined(CONFIG_PPC32)
+#if defined(CONFIG_PM_SLEEP) && defined(CONFIG_PPC32)
 	if (pmu_kind == PMU_KEYLARGO_BASED &&
 	    pmac_call_feature(PMAC_FTR_SLEEP_STATE,NULL,0,-1) >= 0)
 		if (!strcmp(label, "lid_wakeup"))
@@ -1738,7 +1738,7 @@ pmu_present(void)
 	return via != 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 
 static LIST_HEAD(sleep_notifiers);
 
@@ -1769,9 +1769,9 @@ pmu_unregister_sleep_notifier(struct pmu
 	return 0;
 }
 EXPORT_SYMBOL(pmu_unregister_sleep_notifier);
-#endif /* CONFIG_PM */
+#endif /* CONFIG_PM_SLEEP */
 
-#if defined(CONFIG_PM) && defined(CONFIG_PPC32)
+#if defined(CONFIG_PM_SLEEP) && defined(CONFIG_PPC32)
 
 /* Sleep is broadcast last-to-first */
 static void broadcast_sleep(int when)
@@ -2390,7 +2390,7 @@ powerbook_sleep_3400(void)
 	return 0;
 }
 
-#endif /* CONFIG_PM && CONFIG_PPC32 */
+#endif /* CONFIG_PM_SLEEP && CONFIG_PPC32 */
 
 /*
  * Support for /dev/pmu device
@@ -2573,7 +2573,7 @@ pmu_ioctl(struct inode * inode, struct f
 	int error = -EINVAL;
 
 	switch (cmd) {
-#if defined(CONFIG_PM) && defined(CONFIG_PPC32)
+#if defined(CONFIG_PM_SLEEP) && defined(CONFIG_PPC32)
 	case PMU_IOC_SLEEP:
 		if (!capable(CAP_SYS_ADMIN))
 			return -EACCES;
@@ -2601,7 +2601,7 @@ pmu_ioctl(struct inode * inode, struct f
 			return put_user(0, argp);
 		else
 			return put_user(1, argp);
-#endif /* CONFIG_PM && CONFIG_PPC32 */
+#endif /* CONFIG_PM_SLEEP && CONFIG_PPC32 */
 
 #ifdef CONFIG_PMAC_BACKLIGHT_LEGACY
 	/* Compatibility ioctl's for backlight */
@@ -2757,7 +2757,7 @@ pmu_polled_request(struct adb_request *r
  * to do suspend-to-disk.
  */
 
-#if defined(CONFIG_PM) && defined(CONFIG_PPC32)
+#if defined(CONFIG_PM_SLEEP) && defined(CONFIG_PPC32)
 
 int pmu_sys_suspended;
 
@@ -2792,7 +2792,7 @@ static int pmu_sys_resume(struct sys_dev
 	return 0;
 }
 
-#endif /* CONFIG_PM && CONFIG_PPC32 */
+#endif /* CONFIG_PM_SLEEP && CONFIG_PPC32 */
 
 static struct sysdev_class pmu_sysclass = {
 	set_kset_name("pmu"),
@@ -2803,10 +2803,10 @@ static struct sys_device device_pmu = {
 };
 
 static struct sysdev_driver driver_pmu = {
-#if defined(CONFIG_PM) && defined(CONFIG_PPC32)
+#if defined(CONFIG_PM_SLEEP) && defined(CONFIG_PPC32)
 	.suspend	= &pmu_sys_suspend,
 	.resume		= &pmu_sys_resume,
-#endif /* CONFIG_PM && CONFIG_PPC32 */
+#endif /* CONFIG_PM_SLEEP && CONFIG_PPC32 */
 };
 
 static int __init init_pmu_sysfs(void)
@@ -2841,10 +2841,10 @@ EXPORT_SYMBOL(pmu_wait_complete);
 EXPORT_SYMBOL(pmu_suspend);
 EXPORT_SYMBOL(pmu_resume);
 EXPORT_SYMBOL(pmu_unlock);
-#if defined(CONFIG_PM) && defined(CONFIG_PPC32)
+#if defined(CONFIG_PM_SLEEP) && defined(CONFIG_PPC32)
 EXPORT_SYMBOL(pmu_enable_irled);
 EXPORT_SYMBOL(pmu_battery_count);
 EXPORT_SYMBOL(pmu_batteries);
 EXPORT_SYMBOL(pmu_power_flags);
-#endif /* CONFIG_PM && CONFIG_PPC32 */
+#endif /* CONFIG_PM_SLEEP && CONFIG_PPC32 */
 
--- a/include/linux/pmu.h
+++ b/include/linux/pmu.h
@@ -226,7 +226,7 @@ extern unsigned int pmu_power_flags;
 extern void pmu_backlight_init(void);
 
 /* some code needs to know if the PMU was suspended for hibernation */
-#if defined(CONFIG_PM) && defined(CONFIG_PPC32)
+#if defined(CONFIG_PM_SLEEP) && defined(CONFIG_PPC32)
 extern int pmu_sys_suspended;
 #else
 /* if power management is not configured it can't be suspended */
