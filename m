Return-Path: <linux-kernel-owner+w=401wt.eu-S932772AbXAaDsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932772AbXAaDsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 22:48:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932711AbXAaDrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 22:47:46 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:1518 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932846AbXAaDrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 22:47:43 -0500
Message-Id: <20070131033807.107454281@mvista.com>
References: <20070131033710.420168478@mvista.com>
User-Agent: quilt/0.46.mv-1
Date: Tue, 30 Jan 2007 19:37:23 -0800
From: Daniel Walker <dwalker@mvista.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com
Subject: [PATCH 13/23] timekeeping: move sysfs layer/drop API calls
Content-Disposition: inline; filename=timekeeping_move_sysfs_layer.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This moves the timekeeping sysfs override layer into timekeeping.c and
removes the get_next_clocksource and select_clocksource functions, and 
their component variables, since they are no longer used.

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 include/linux/clocksource.h |    5 -
 kernel/time/clocksource.c   |  169 --------------------------------------------
 kernel/time/timekeeping.c   |  131 +++++++++++++++++++++++++++++++++-
 3 files changed, 134 insertions(+), 171 deletions(-)

Index: linux-2.6.19/include/linux/clocksource.h
===================================================================
--- linux-2.6.19.orig/include/linux/clocksource.h
+++ linux-2.6.19/include/linux/clocksource.h
@@ -25,9 +25,9 @@ typedef u64 cycle_t;
 extern struct clocksource clocksource_jiffies;
 
 /*
- * Atomic signal that is specific to timekeeping.
+ * Sysfs device extern, for registering clocksources under the same sysfs dir.
  */
-extern atomic_t clock_check;
+extern struct sys_device clocksource_sys_device;
 
 /*
  * Allows inlined calling for notifier routines.
@@ -231,7 +231,6 @@ static inline void clocksource_calculate
 
 
 /* used to install a new clocksource */
-extern struct clocksource *clocksource_get_next(void);
 extern int clocksource_register(struct clocksource*);
 extern void clocksource_rating_change(struct clocksource*);
 extern struct clocksource * clocksource_get_clock(char*);
Index: linux-2.6.19/kernel/time/clocksource.c
===================================================================
--- linux-2.6.19.orig/kernel/time/clocksource.c
+++ linux-2.6.19/kernel/time/clocksource.c
@@ -30,27 +30,17 @@
 #include <linux/module.h>
 
 /*[Clocksource internal variables]---------
- * curr_clocksource:
- *	currently selected clocksource. Initialized to clocksource_jiffies.
- * next_clocksource:
- *	pending next selected clocksource.
  * clocksource_list:
  *	rating sorted linked list with the registered clocksources
  * clocksource_lock:
  *	protects manipulations to curr_clocksource and next_clocksource
  *	and the clocksource_list
- * override_name:
- *	Name of the user-specified clocksource.
  */
-static struct clocksource *curr_clocksource = &clocksource_jiffies;
-static struct clocksource *next_clocksource;
 static LIST_HEAD(clocksource_list);
 static DEFINE_SPINLOCK(clocksource_lock);
-static char override_name[32];
 static int finished_booting;
 
 ATOMIC_NOTIFIER_HEAD(clocksource_list_notifier);
-atomic_t clock_check = ATOMIC_INIT(0);
 
 /* clocksource_done_booting - Called near the end of bootup
  *
@@ -59,32 +49,12 @@ atomic_t clock_check = ATOMIC_INIT(0);
 static int __init clocksource_done_booting(void)
 {
 	finished_booting = 1;
-	/* Check for a new clock now */
-	atomic_inc(&clock_check);
 	return 0;
 }
 
 late_initcall(clocksource_done_booting);
 
 /**
- * clocksource_get_next - Returns the selected clocksource
- *
- */
-struct clocksource *clocksource_get_next(void)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&clocksource_lock, flags);
-	if (next_clocksource && finished_booting) {
-		curr_clocksource = next_clocksource;
-		next_clocksource = NULL;
-	}
-	spin_unlock_irqrestore(&clocksource_lock, flags);
-
-	return curr_clocksource;
-}
-
-/**
  * __is_registered - Returns a clocksource if it's registered
  * @name:		name of the clocksource to return
  *
@@ -148,25 +118,6 @@ struct clocksource * clocksource_get_clo
 	return ret;
 }
 
-
-/**
- * select_clocksource - Finds the best registered clocksource.
- *
- * Private function. Must hold clocksource_lock when called.
- *
- * Looks through the list of registered clocksources, returning
- * the one with the highest rating value. If there is a clocksource
- * name that matches the override string, it returns that clocksource.
- */
-static struct clocksource *select_clocksource(void)
-{
-	if (!*override_name)
-		return list_entry(clocksource_list.next,
-				  struct clocksource, list);
-
-	return __get_clock(override_name);
-}
-
 /*
  * __sorted_list_add - Sorted clocksource add
  * @c:			clocksource to add
@@ -210,11 +161,6 @@ int clocksource_register(struct clocksou
 
 	spin_lock_irqsave(&clocksource_lock, flags);
  	__sorted_list_add(c);
-
-	/*
-	 * scan the registered clocksources, and pick the best one
-	 */
-	next_clocksource = select_clocksource();
 	spin_unlock_irqrestore(&clocksource_lock, flags);
 
 	atomic_notifier_call_chain(&clocksource_list_notifier,
@@ -243,7 +189,6 @@ void clocksource_rating_change(struct cl
 	list_del_init(&c->list);
 	__sorted_list_add(c);
 
-	next_clocksource = select_clocksource();
 	spin_unlock_irqrestore(&clocksource_lock, flags);
 
 	atomic_notifier_call_chain(&clocksource_list_notifier,
@@ -254,67 +199,6 @@ EXPORT_SYMBOL(clocksource_rating_change)
 
 #ifdef CONFIG_SYSFS
 /**
- * sysfs_show_current_clocksources - sysfs interface for current clocksource
- * @dev:	unused
- * @buf:	char buffer to be filled with clocksource list
- *
- * Provides sysfs interface for listing current clocksource.
- */
-static ssize_t
-sysfs_show_current_clocksources(struct sys_device *dev, char *buf)
-{
-	char *curr = buf;
-
-	spin_lock_irq(&clocksource_lock);
-	curr += sprintf(curr, "%s ", curr_clocksource->name);
-	spin_unlock_irq(&clocksource_lock);
-
-	curr += sprintf(curr, "\n");
-
-	return curr - buf;
-}
-
-/**
- * sysfs_override_clocksource - interface for manually overriding clocksource
- * @dev:	unused
- * @buf:	name of override clocksource
- * @count:	length of buffer
- *
- * Takes input from sysfs interface for manually overriding the default
- * clocksource selction.
- */
-static ssize_t sysfs_override_clocksource(struct sys_device *dev,
-					  const char *buf, size_t count)
-{
-	size_t ret = count;
-	/* strings from sysfs write are not 0 terminated! */
-	if (count >= sizeof(override_name))
-		return -EINVAL;
-
-	/* strip of \n: */
-	if (buf[count-1] == '\n')
-		count--;
-	if (count < 1)
-		return -EINVAL;
-
-	spin_lock_irq(&clocksource_lock);
-
-	/* copy the name given: */
-	memcpy(override_name, buf, count);
-	override_name[count] = 0;
-
-	/* try to select it: */
-	next_clocksource = select_clocksource();
-
-	/* Signal that there is a new clocksource */
-	atomic_inc(&clock_check);
-
-	spin_unlock_irq(&clocksource_lock);
-
-	return ret;
-}
-
-/**
  * sysfs_show_available_clocksources - sysfs interface for listing clocksource
  * @dev:	unused
  * @buf:	char buffer to be filled with clocksource list
@@ -345,9 +229,6 @@ sysfs_show_available_clocksources(struct
 /*
  * Sysfs setup bits:
  */
-static SYSDEV_ATTR(current_clocksource, 0600, sysfs_show_current_clocksources,
-		   sysfs_override_clocksource);
-
 static SYSDEV_ATTR(available_clocksource, 0600,
 		   sysfs_show_available_clocksources, NULL);
 
@@ -355,7 +236,7 @@ static struct sysdev_class clocksource_s
 	set_kset_name("clocksource"),
 };
 
-static struct sys_device device_clocksource = {
+struct sys_device clocksource_sys_device = {
 	.id	= 0,
 	.cls	= &clocksource_sysclass,
 };
@@ -365,57 +246,13 @@ static int __init init_clocksource_sysfs
 	int error = sysdev_class_register(&clocksource_sysclass);
 
 	if (!error)
-		error = sysdev_register(&device_clocksource);
+		error = sysdev_register(&clocksource_sys_device);
 	if (!error)
 		error = sysdev_create_file(
-				&device_clocksource,
-				&attr_current_clocksource);
-	if (!error)
-		error = sysdev_create_file(
-				&device_clocksource,
+				&clocksource_sys_device,
 				&attr_available_clocksource);
 	return error;
 }
 
 device_initcall(init_clocksource_sysfs);
 #endif /* CONFIG_SYSFS */
-
-/**
- * boot_override_clocksource - boot clock override
- * @str:	override name
- *
- * Takes a clocksource= boot argument and uses it
- * as the clocksource override name.
- */
-static int __init boot_override_clocksource(char* str)
-{
-	unsigned long flags;
-	spin_lock_irqsave(&clocksource_lock, flags);
-	if (str)
-		strlcpy(override_name, str, sizeof(override_name));
-	spin_unlock_irqrestore(&clocksource_lock, flags);
-	return 1;
-}
-
-__setup("clocksource=", boot_override_clocksource);
-
-/**
- * boot_override_clock - Compatibility layer for deprecated boot option
- * @str:	override name
- *
- * DEPRECATED! Takes a clock= boot argument and uses it
- * as the clocksource override name
- */
-static int __init boot_override_clock(char* str)
-{
-	if (!strcmp(str, "pmtmr")) {
-		printk("Warning: clock=pmtmr is deprecated. "
-			"Use clocksource=acpi_pm.\n");
-		return boot_override_clocksource("acpi_pm");
-	}
-	printk("Warning! clock= boot option is deprecated. "
-		"Use clocksource=xyz\n");
-	return boot_override_clocksource(str);
-}
-
-__setup("clock=", boot_override_clock);
Index: linux-2.6.19/kernel/time/timekeeping.c
===================================================================
--- linux-2.6.19.orig/kernel/time/timekeeping.c
+++ linux-2.6.19/kernel/time/timekeeping.c
@@ -12,6 +12,7 @@
 #include <linux/timex.h>
 #include <linux/hrtimer.h>
 #include <linux/tick.h>
+#include <linux/sysdev.h>
 
 /*
  * The current time
@@ -42,6 +43,17 @@ static unsigned long timekeeping_suspend
 struct clocksource *clock = &clocksource_jiffies;
 
 #ifdef CONFIG_GENERIC_TIME
+
+/*
+ * Signals to check the current clock in the timer interrupt.
+ */
+static atomic_t clock_check = ATOMIC_INIT(0);
+
+/*
+ * Holds the override name if one is given
+ */
+static char override_name[32];
+
 /**
  * __get_nsec_offset - Returns nanoseconds since last call to periodic_hook
  *
@@ -167,7 +179,12 @@ static void timekeeping_change_clocksour
 	struct clocksource *new;
 	cycle_t now;
 	u64 nsec;
-	new = clocksource_get_next();
+
+	if (!*override_name)
+		new = clocksource_get_clock(NULL);
+	else
+		new = clocksource_get_clock(override_name);
+
 	if (clock != new) {
 		now = clocksource_read(new);
 		nsec =  __get_nsec_offset();
@@ -233,6 +250,117 @@ void __init timekeeping_init_notifier(vo
 	 */
 	clocksource_notifier_register(&clocksource_nb);
 }
+
+#ifdef CONFIG_SYSFS
+/**
+ * sysfs_show_current_clocksources - sysfs interface for current clocksource
+ * @dev:	unused
+ * @buf:	char buffer to be filled with clocksource list
+ *
+ * Provides sysfs interface for listing current clocksource.
+ */
+static ssize_t
+timekeeping_sysfs_show_current_clocksources(struct sys_device *dev, char *buf)
+{
+	char *curr = buf;
+
+	curr += sprintf(curr, "%s \n", clock->name);
+
+	return curr - buf;
+}
+
+/**
+ * sysfs_override_clocksource - interface for manually overriding clocksource
+ * @dev:	unused
+ * @buf:	name of override clocksource
+ * @count:	length of buffer
+ *
+ * Takes input from sysfs interface for manually overriding the default
+ * clocksource selction.
+ */
+static ssize_t
+timekeeping_sysfs_override_clocksource(struct sys_device *dev,
+				       const char *buf, size_t count)
+{
+	size_t ret = count;
+	/* strings from sysfs write are not 0 terminated! */
+	if (count >= sizeof(override_name))
+		return -EINVAL;
+
+	/* strip of \n: */
+	if (buf[count-1] == '\n')
+		count--;
+	if (count < 1)
+		return -EINVAL;
+
+	/* copy the name given: */
+	memcpy(override_name, buf, count);
+	override_name[count] = 0;
+
+	/* Signal that there is a new clocksource */
+	atomic_inc(&clock_check);
+
+	return ret;
+}
+
+static SYSDEV_ATTR(current_clocksource, 0600,
+		   timekeeping_sysfs_show_current_clocksources,
+		   timekeeping_sysfs_override_clocksource);
+
+static __init int timekeeping_init_sysfs(void)
+{
+	int error;
+
+	error = sysdev_create_file(&clocksource_sys_device,
+				   &attr_current_clocksource);
+	return error;
+}
+device_initcall(timekeeping_init_sysfs);
+#endif /* CONFIG_SYSFS */
+
+static int __init timekeeping_early_clockswitch(void)
+{
+	atomic_inc(&clock_check);
+	return 0;
+}
+
+late_initcall(timekeeping_early_clockswitch);
+
+/**
+ * boot_override_clocksource - boot clock override
+ * @str:	override name
+ *
+ * Takes a clocksource= boot argument and uses it
+ * as the clocksource override name.
+ */
+static int __init boot_override_clocksource(char* str)
+{
+	if (str)
+		strlcpy(override_name, str, sizeof(override_name));
+	return 1;
+}
+__setup("clocksource=", boot_override_clocksource);
+
+/**
+ * boot_override_clock - Compatibility layer for deprecated boot option
+ * @str:	override name
+ *
+ * DEPRECATED! Takes a clock= boot argument and uses it
+ * as the clocksource override name
+ */
+static int __init boot_override_clock(char* str)
+{
+	if (!strcmp(str, "pmtmr")) {
+		printk("Warning: clock=pmtmr is deprecated. "
+			"Use clocksource=acpi_pm.\n");
+		return boot_override_clocksource("acpi_pm");
+	}
+	printk("Warning! clock= boot option is deprecated. "
+		"Use clocksource=xyz\n");
+	return boot_override_clocksource(str);
+}
+__setup("clock=", boot_override_clock);
+
 #endif /* CONFIG_GENERIC_TIME */
 
 /**
@@ -261,7 +389,6 @@ void __init timekeeping_init(void)
 
 	ntp_clear();
 
-	clock = clocksource_get_next();
 	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
 	clock->cycle_last = clocksource_read(clock);
 

-- 
