Return-Path: <linux-kernel-owner+w=401wt.eu-S1763433AbYDTKtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763433AbYDTKtq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 06:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759902AbYDTKlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 06:41:00 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56351 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759802AbYDTKk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 06:40:58 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 29/36] PM: Remove destroy_suspended_device()
Date: Sun, 20 Apr 2008 03:45:59 -0700
Message-Id: <1208688366-9252-29-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <20080420104516.GA9225@suse.de>
References: <20080420104516.GA9225@suse.de>
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

After 2.6.24 there was a plan to make the PM core acquire all device
semaphores during a suspend/hibernation to protect itself from
concurrent operations involving device objects.  That proved to be
too heavy-handed and we found a better way to achieve the goal, but
before it happened, we had introduced the functions
device_pm_schedule_removal() and destroy_suspended_device() to allow
drivers to "safely" destroy a suspended device and we had adapted some
drivers to use them.  Now that these functions are no longer necessary,
it seems reasonable to remove them and modify their users to use the
normal device unregistration instead.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kernel/cpuid.c         |    4 +--
 arch/x86/kernel/msr.c           |    4 +--
 drivers/base/core.c             |   29 ----------------------------
 drivers/base/power/main.c       |   40 ---------------------------------------
 drivers/char/hw_random/core.c   |   10 ++++----
 drivers/char/misc.c             |   13 +++--------
 drivers/leds/led-class.c        |   11 ++-------
 drivers/net/wireless/b43/leds.c |    5 +---
 drivers/net/wireless/b43/main.c |    8 +++---
 include/linux/device.h          |   14 -------------
 include/linux/hw_random.h       |   10 +--------
 include/linux/leds.h            |   10 +--------
 include/linux/miscdevice.h      |   10 +--------
 13 files changed, 22 insertions(+), 146 deletions(-)

diff --git a/arch/x86/kernel/cpuid.c b/arch/x86/kernel/cpuid.c
index 288e7a6..daff52a 100644
--- a/arch/x86/kernel/cpuid.c
+++ b/arch/x86/kernel/cpuid.c
@@ -154,12 +154,10 @@ static int __cpuinit cpuid_class_cpu_callback(struct notifier_block *nfb,
 		err = cpuid_device_create(cpu);
 		break;
 	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
 		cpuid_device_destroy(cpu);
 		break;
-	case CPU_UP_CANCELED_FROZEN:
-		destroy_suspended_device(cpuid_class, MKDEV(CPUID_MAJOR, cpu));
-		break;
 	}
 	return err ? NOTIFY_BAD : NOTIFY_OK;
 }
diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index 4dfb405..1f3abe0 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -162,12 +162,10 @@ static int __cpuinit msr_class_cpu_callback(struct notifier_block *nfb,
 		err = msr_device_create(cpu);
 		break;
 	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
 		msr_device_destroy(cpu);
 		break;
-	case CPU_UP_CANCELED_FROZEN:
-		destroy_suspended_device(msr_class, MKDEV(MSR_MAJOR, cpu));
-		break;
 	}
 	return err ? NOTIFY_BAD : NOTIFY_OK;
 }
diff --git a/drivers/base/core.c b/drivers/base/core.c
index adbc017..0262fc7 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1163,35 +1163,6 @@ void device_destroy(struct class *class, dev_t devt)
 }
 EXPORT_SYMBOL_GPL(device_destroy);
 
-#ifdef CONFIG_PM_SLEEP
-/**
- * destroy_suspended_device - asks the PM core to remove a suspended device
- * @class: pointer to the struct class that this device was registered with
- * @devt: the dev_t of the device that was previously registered
- *
- * This call notifies the PM core of the necessity to unregister a suspended
- * device created with a call to device_create() (devices cannot be
- * unregistered directly while suspended, since the PM core holds their
- * semaphores at that time).
- *
- * It can only be called within the scope of a system sleep transition.  In
- * practice this means it has to be directly or indirectly invoked either by
- * a suspend or resume method, or by the PM core (e.g. via
- * disable_nonboot_cpus() or enable_nonboot_cpus()).
- */
-void destroy_suspended_device(struct class *class, dev_t devt)
-{
-	struct device *dev;
-
-	dev = class_find_device(class, &devt, __match_devt);
-	if (dev) {
-		device_pm_schedule_removal(dev);
-		put_device(dev);
-	}
-}
-EXPORT_SYMBOL_GPL(destroy_suspended_device);
-#endif /* CONFIG_PM_SLEEP */
-
 /**
  * device_rename - renames a device
  * @dev: the pointer to the struct device to be renamed
diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 5630af3..c4568b8 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -50,7 +50,6 @@
 LIST_HEAD(dpm_active);
 static LIST_HEAD(dpm_off);
 static LIST_HEAD(dpm_off_irq);
-static LIST_HEAD(dpm_destroy);
 
 static DEFINE_MUTEX(dpm_list_mtx);
 
@@ -104,24 +103,6 @@ void device_pm_remove(struct device *dev)
 	mutex_unlock(&dpm_list_mtx);
 }
 
-/**
- *	device_pm_schedule_removal - schedule the removal of a suspended device
- *	@dev:	Device to destroy
- *
- *	Moves the device to the dpm_destroy list for further processing by
- *	unregister_dropped_devices().
- */
-void device_pm_schedule_removal(struct device *dev)
-{
-	pr_debug("PM: Preparing for removal: %s:%s\n",
-		dev->bus ? dev->bus->name : "No Bus",
-		kobject_name(&dev->kobj));
-	mutex_lock(&dpm_list_mtx);
-	list_move_tail(&dev->power.entry, &dpm_destroy);
-	mutex_unlock(&dpm_list_mtx);
-}
-EXPORT_SYMBOL_GPL(device_pm_schedule_removal);
-
 /*------------------------- Resume routines -------------------------*/
 
 /**
@@ -246,26 +227,6 @@ static void dpm_resume(void)
 }
 
 /**
- *	unregister_dropped_devices - Unregister devices scheduled for removal
- *
- *	Unregister all devices on the dpm_destroy list.
- */
-static void unregister_dropped_devices(void)
-{
-	mutex_lock(&dpm_list_mtx);
-	while (!list_empty(&dpm_destroy)) {
-		struct list_head *entry = dpm_destroy.next;
-		struct device *dev = to_device(entry);
-
-		mutex_unlock(&dpm_list_mtx);
-		/* This also removes the device from the list */
-		device_unregister(dev);
-		mutex_lock(&dpm_list_mtx);
-	}
-	mutex_unlock(&dpm_list_mtx);
-}
-
-/**
  *	device_resume - Restore state of each device in system.
  *
  *	Resume all the devices, unlock them all, and allow new
@@ -275,7 +236,6 @@ void device_resume(void)
 {
 	might_sleep();
 	dpm_resume();
-	unregister_dropped_devices();
 }
 EXPORT_SYMBOL_GPL(device_resume);
 
diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 349b6ed..662d60e 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -238,11 +238,11 @@ static DEVICE_ATTR(rng_available, S_IRUGO,
 		   NULL);
 
 
-static void unregister_miscdev(bool suspended)
+static void unregister_miscdev(void)
 {
 	device_remove_file(rng_miscdev.this_device, &dev_attr_rng_available);
 	device_remove_file(rng_miscdev.this_device, &dev_attr_rng_current);
-	__misc_deregister(&rng_miscdev, suspended);
+	misc_deregister(&rng_miscdev);
 }
 
 static int register_miscdev(void)
@@ -317,7 +317,7 @@ out:
 }
 EXPORT_SYMBOL_GPL(hwrng_register);
 
-void __hwrng_unregister(struct hwrng *rng, bool suspended)
+void hwrng_unregister(struct hwrng *rng)
 {
 	int err;
 
@@ -336,11 +336,11 @@ void __hwrng_unregister(struct hwrng *rng, bool suspended)
 		}
 	}
 	if (list_empty(&rng_list))
-		unregister_miscdev(suspended);
+		unregister_miscdev();
 
 	mutex_unlock(&rng_mutex);
 }
-EXPORT_SYMBOL_GPL(__hwrng_unregister);
+EXPORT_SYMBOL_GPL(hwrng_unregister);
 
 
 MODULE_DESCRIPTION("H/W Random Number Generator (RNG) driver");
diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index a39101f..4d058da 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -232,9 +232,8 @@ int misc_register(struct miscdevice * misc)
 }
 
 /**
- *	__misc_deregister - unregister a miscellaneous device
+ *	misc_deregister - unregister a miscellaneous device
  *	@misc: device to unregister
- *	@suspended: to be set if the function is used during suspend/resume
  *
  *	Unregister a miscellaneous device that was previously
  *	successfully registered with misc_register(). Success
@@ -242,7 +241,7 @@ int misc_register(struct miscdevice * misc)
  *	indicates an error.
  */
 
-int __misc_deregister(struct miscdevice *misc, bool suspended)
+int misc_deregister(struct miscdevice *misc)
 {
 	int i = misc->minor;
 
@@ -251,11 +250,7 @@ int __misc_deregister(struct miscdevice *misc, bool suspended)
 
 	mutex_lock(&misc_mtx);
 	list_del(&misc->list);
-	if (suspended)
-		destroy_suspended_device(misc_class,
-					MKDEV(MISC_MAJOR, misc->minor));
-	else
-		device_destroy(misc_class, MKDEV(MISC_MAJOR, misc->minor));
+	device_destroy(misc_class, MKDEV(MISC_MAJOR, misc->minor));
 	if (i < DYNAMIC_MINORS && i>0) {
 		misc_minors[i>>3] &= ~(1 << (misc->minor & 7));
 	}
@@ -264,7 +259,7 @@ int __misc_deregister(struct miscdevice *misc, bool suspended)
 }
 
 EXPORT_SYMBOL(misc_register);
-EXPORT_SYMBOL(__misc_deregister);
+EXPORT_SYMBOL(misc_deregister);
 
 static int __init misc_init(void)
 {
diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index 4a93878..63aad90 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -139,12 +139,10 @@ EXPORT_SYMBOL_GPL(led_classdev_register);
 /**
  * __led_classdev_unregister - unregisters a object of led_properties class.
  * @led_cdev: the led device to unregister
- * @suspended: indicates whether system-wide suspend or resume is in progress
  *
  * Unregisters a previously registered via led_classdev_register object.
  */
-void __led_classdev_unregister(struct led_classdev *led_cdev,
-				      bool suspended)
+void led_classdev_unregister(struct led_classdev *led_cdev)
 {
 	device_remove_file(led_cdev->dev, &dev_attr_brightness);
 #ifdef CONFIG_LEDS_TRIGGERS
@@ -155,16 +153,13 @@ void __led_classdev_unregister(struct led_classdev *led_cdev,
 	up_write(&led_cdev->trigger_lock);
 #endif
 
-	if (suspended)
-		device_pm_schedule_removal(led_cdev->dev);
-	else
-		device_unregister(led_cdev->dev);
+	device_unregister(led_cdev->dev);
 
 	down_write(&leds_list_lock);
 	list_del(&led_cdev->node);
 	up_write(&leds_list_lock);
 }
-EXPORT_SYMBOL_GPL(__led_classdev_unregister);
+EXPORT_SYMBOL_GPL(led_classdev_unregister);
 
 static int __init leds_init(void)
 {
diff --git a/drivers/net/wireless/b43/leds.c b/drivers/net/wireless/b43/leds.c
index 0aac1ff..36a9c42 100644
--- a/drivers/net/wireless/b43/leds.c
+++ b/drivers/net/wireless/b43/leds.c
@@ -116,10 +116,7 @@ static void b43_unregister_led(struct b43_led *led)
 {
 	if (!led->dev)
 		return;
-	if (led->dev->suspend_in_progress)
-		led_classdev_unregister_suspended(&led->led_dev);
-	else
-		led_classdev_unregister(&led->led_dev);
+	led_classdev_unregister(&led->led_dev);
 	b43_led_turn_off(led->dev, led->index, led->activelow);
 	led->dev = NULL;
 }
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index cf5c046..943cc85 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -2804,10 +2804,10 @@ static int b43_rng_read(struct hwrng *rng, u32 * data)
 	return (sizeof(u16));
 }
 
-static void b43_rng_exit(struct b43_wl *wl, bool suspended)
+static void b43_rng_exit(struct b43_wl *wl)
 {
 	if (wl->rng_initialized)
-		__hwrng_unregister(&wl->rng, suspended);
+		hwrng_unregister(&wl->rng);
 }
 
 static int b43_rng_init(struct b43_wl *wl)
@@ -3824,7 +3824,7 @@ static void b43_wireless_core_exit(struct b43_wldev *dev)
 
 	if (!dev->suspend_in_progress) {
 		b43_leds_exit(dev);
-		b43_rng_exit(dev->wl, false);
+		b43_rng_exit(dev->wl);
 	}
 	b43_dma_free(dev);
 	b43_pio_free(dev);
@@ -4589,7 +4589,7 @@ static int b43_resume(struct ssb_device *dev)
 		err = b43_wireless_core_start(wldev);
 		if (err) {
 			b43_leds_exit(wldev);
-			b43_rng_exit(wldev->wl, true);
+			b43_rng_exit(wldev->wl);
 			b43_wireless_core_exit(wldev);
 			b43err(wl, "Resume failed at core start\n");
 			goto out;
diff --git a/include/linux/device.h b/include/linux/device.h
index 441461f..dc3429e 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -545,20 +545,6 @@ extern struct device *device_create(struct class *cls, struct device *parent,
 				    dev_t devt, const char *fmt, ...)
 				    __attribute__((format(printf, 4, 5)));
 extern void device_destroy(struct class *cls, dev_t devt);
-#ifdef CONFIG_PM_SLEEP
-extern void destroy_suspended_device(struct class *cls, dev_t devt);
-extern void device_pm_schedule_removal(struct device *);
-#else /* !CONFIG_PM_SLEEP */
-static inline void destroy_suspended_device(struct class *cls, dev_t devt)
-{
-	device_destroy(cls, devt);
-}
-
-static inline void device_pm_schedule_removal(struct device *dev)
-{
-	device_unregister(dev);
-}
-#endif /* !CONFIG_PM_SLEEP */
 
 /*
  * Platform "fixup" functions - allow the platform to have their say
diff --git a/include/linux/hw_random.h b/include/linux/hw_random.h
index 4213182..85d1191 100644
--- a/include/linux/hw_random.h
+++ b/include/linux/hw_random.h
@@ -44,15 +44,7 @@ struct hwrng {
 /** Register a new Hardware Random Number Generator driver. */
 extern int hwrng_register(struct hwrng *rng);
 /** Unregister a Hardware Random Number Generator driver. */
-extern void __hwrng_unregister(struct hwrng *rng, bool suspended);
-static inline void hwrng_unregister(struct hwrng *rng)
-{
-	__hwrng_unregister(rng, false);
-}
-static inline void hwrng_unregister_suspended(struct hwrng *rng)
-{
-	__hwrng_unregister(rng, true);
-}
+extern void hwrng_unregister(struct hwrng *rng);
 
 #endif /* __KERNEL__ */
 #endif /* LINUX_HWRANDOM_H_ */
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 0201f6f..b07e3d4 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -59,15 +59,7 @@ struct led_classdev {
 
 extern int led_classdev_register(struct device *parent,
 				 struct led_classdev *led_cdev);
-extern void __led_classdev_unregister(struct led_classdev *led_cdev, bool sus);
-static inline void led_classdev_unregister(struct led_classdev *lcd)
-{
-	__led_classdev_unregister(lcd, false);
-}
-static inline void led_classdev_unregister_suspended(struct led_classdev *lcd)
-{
-	__led_classdev_unregister(lcd, true);
-}
+extern void led_classdev_unregister(struct led_classdev *lcd);
 extern void led_classdev_suspend(struct led_classdev *led_cdev);
 extern void led_classdev_resume(struct led_classdev *led_cdev);
 
diff --git a/include/linux/miscdevice.h b/include/linux/miscdevice.h
index 24b30b9..26433ec 100644
--- a/include/linux/miscdevice.h
+++ b/include/linux/miscdevice.h
@@ -43,15 +43,7 @@ struct miscdevice  {
 };
 
 extern int misc_register(struct miscdevice * misc);
-extern int __misc_deregister(struct miscdevice *misc, bool suspended);
-static inline int misc_deregister(struct miscdevice *misc)
-{
-	return __misc_deregister(misc, false);
-}
-static inline int misc_deregister_suspended(struct miscdevice *misc)
-{
-	return __misc_deregister(misc, true);
-}
+extern int misc_deregister(struct miscdevice *misc);
 
 #define MODULE_ALIAS_MISCDEV(minor)				\
 	MODULE_ALIAS("char-major-" __stringify(MISC_MAJOR)	\
-- 
1.5.4.5

