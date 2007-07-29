Return-Path: <linux-kernel-owner+w=401wt.eu-S936857AbXG2VWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936857AbXG2VWy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 17:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936144AbXG2VWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 17:22:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49393 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935661AbXG2VWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 17:22:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 2/2] Introduce CONFIG_SUSPEND (updated)
Date: Sun, 29 Jul 2007 23:27:18 +0200
User-Agent: KMail/1.9.5
Cc: Len Brown <lenb@kernel.org>, david@lang.hm,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Adrian Bunk <bunk@stusta.de>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200707251238.50218.lenb@kernel.org> <200707291220.14880.rjw@sisk.pl> <200707292323.29601.rjw@sisk.pl>
In-Reply-To: <200707292323.29601.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707292327.19884.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Introduce CONFIG_SUSPEND representing the ability to enter system sleep states,
such as the ACPI S3 state, and allow the user to choose SUSPEND and HIBERNATION
independently of each other.

Make HOTPLUG_CPU be selected automatically if SUSPEND or HIBERNATION has been
chosen and the kernel is intended for SMP systems.

Also, introduce CONFIG_PM_SLEEP which is automatically selected if
CONFIG_SUSPEND or CONFIG_HIBERNATION is set and use it to select the code
needed for both suspend and hibernation.

The top-level power management headers and the ACPI code related to suspend and
hibernation are modified to use the new definitions (the changes in
drivers/acpi/sleep/main.c are, mostly, moving code to reduce the number of
ifdefs).  Still, there are many other files in which CONFIG_PM can be replaced
with CONFIG_PM_SLEEP or even with CONFIG_SUSPEND, but they can be updated in
the future.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/Kconfig        |    8 +++
 drivers/acpi/sleep/Makefile |    2 
 drivers/acpi/sleep/main.c   |   94 +++++++++++++++++++++++---------------------
 drivers/acpi/sleep/proc.c   |   10 ++--
 drivers/acpi/sleep/sleep.h  |    2 
 drivers/base/power/Makefile |    2 
 drivers/base/power/power.h  |    4 -
 include/acpi/acpi_bus.h     |    9 ++++
 include/acpi/acpi_drivers.h |    4 +
 include/linux/freezer.h     |    6 +-
 include/linux/pm.h          |   15 +++++--
 include/linux/suspend.h     |   10 ++--
 kernel/power/Kconfig        |   39 ++++++++++++++----
 kernel/power/Makefile       |    3 -
 kernel/power/main.c         |   26 ++++++++----
 kernel/power/power.h        |   10 ++++
 mm/page_alloc.c             |    4 -
 17 files changed, 163 insertions(+), 85 deletions(-)

Index: linux-2.6/kernel/power/Kconfig
===================================================================
--- linux-2.6.orig/kernel/power/Kconfig	2007-07-29 19:06:26.000000000 +0200
+++ linux-2.6/kernel/power/Kconfig	2007-07-29 19:06:48.000000000 +0200
@@ -46,7 +46,7 @@ config PM_VERBOSE
 
 config DISABLE_CONSOLE_SUSPEND
 	bool "Keep console(s) enabled during suspend/resume (DANGEROUS)"
-	depends on PM_DEBUG
+	depends on PM_DEBUG && PM_SLEEP
 	default n
 	---help---
 	This option turns off the console suspend mechanism that prevents
@@ -57,7 +57,7 @@ config DISABLE_CONSOLE_SUSPEND
 
 config PM_TRACE
 	bool "Suspend/resume event tracing"
-	depends on PM_DEBUG && X86 && EXPERIMENTAL
+	depends on PM_DEBUG && X86 && PM_SLEEP && EXPERIMENTAL
 	default n
 	---help---
 	This enables some cheesy code to save the last PM event point in the
@@ -72,9 +72,37 @@ config PM_TRACE
 	CAUTION: this option will cause your machine's real-time clock to be
 	set to an invalid time after a resume.
 
+config SUSPEND_SMP_POSSIBLE
+	bool
+	depends on (X86 && !X86_VOYAGER) || (PPC64 && (PPC_PSERIES || PPC_PMAC))
+	depends on SMP
+	default y
+
+config SUSPEND_SMP
+	bool
+	depends on SUSPEND_SMP_POSSIBLE && PM_SLEEP
+	select HOTPLUG_CPU
+	default y
+
+config PM_SLEEP
+	bool
+	depends on SUSPEND || HIBERNATION
+	default y
+
+config SUSPEND
+	bool "Suspend to RAM and standby"
+	depends on PM
+	depends on !SMP || SUSPEND_SMP_POSSIBLE
+	default y
+	---help---
+	  Allow the system to enter sleep states in which main memory is
+	  powered and thus its contents are preserved, such as the
+	  suspend-to-RAM state (i.e. the ACPI S3 state).
+
 config HIBERNATION
 	bool "Hibernation"
-	depends on PM && SWAP && (((X86 || PPC64_SWSUSP) && (!SMP || SUSPEND_SMP)) || ((FRV || PPC32) && !SMP))
+	depends on PM && SWAP
+	depends on ((X86 || PPC64_SWSUSP || FRV || PPC32) && !SMP) || SUSPEND_SMP_POSSIBLE
 	---help---
 	  Enable the suspend to disk (STD) functionality, which is usually
 	  called "hibernation" in user interfaces.  STD checkpoints the
@@ -132,11 +160,6 @@ config PM_STD_PARTITION
 	  suspended image to. It will simply pick the first available swap 
 	  device.
 
-config SUSPEND_SMP
-	bool
-	depends on HOTPLUG_CPU && (X86 || PPC64) && PM
-	default y
-
 config APM_EMULATION
 	tristate "Advanced Power Management Emulation"
 	depends on PM && SYS_SUPPORTS_APM_EMULATION
Index: linux-2.6/kernel/power/Makefile
===================================================================
--- linux-2.6.orig/kernel/power/Makefile	2007-07-29 19:06:26.000000000 +0200
+++ linux-2.6/kernel/power/Makefile	2007-07-29 19:06:48.000000000 +0200
@@ -3,8 +3,9 @@ ifeq ($(CONFIG_PM_DEBUG),y)
 EXTRA_CFLAGS	+=	-DDEBUG
 endif
 
-obj-y				:= main.o process.o console.o
+obj-y				:= main.o
 obj-$(CONFIG_PM_LEGACY)		+= pm.o
+obj-$(CONFIG_PM_SLEEP)		+= process.o console.o
 obj-$(CONFIG_HIBERNATION)	+= swsusp.o disk.o snapshot.o swap.o user.o
 
 obj-$(CONFIG_MAGIC_SYSRQ)	+= poweroff.o
Index: linux-2.6/drivers/base/power/Makefile
===================================================================
--- linux-2.6.orig/drivers/base/power/Makefile	2007-07-29 19:06:26.000000000 +0200
+++ linux-2.6/drivers/base/power/Makefile	2007-07-29 19:06:48.000000000 +0200
@@ -1,5 +1,5 @@
 obj-y			:= shutdown.o
-obj-$(CONFIG_PM)	+= main.o suspend.o resume.o sysfs.o
+obj-$(CONFIG_PM_SLEEP)	+= main.o suspend.o resume.o sysfs.o
 obj-$(CONFIG_PM_TRACE)	+= trace.o
 
 ifeq ($(CONFIG_DEBUG_DRIVER),y)
Index: linux-2.6/include/linux/suspend.h
===================================================================
--- linux-2.6.orig/include/linux/suspend.h	2007-07-29 19:06:26.000000000 +0200
+++ linux-2.6/include/linux/suspend.h	2007-07-29 19:06:48.000000000 +0200
@@ -24,7 +24,7 @@ struct pbe {
 extern void drain_local_pages(void);
 extern void mark_free_pages(struct zone *zone);
 
-#if defined(CONFIG_PM) && defined(CONFIG_VT) && defined(CONFIG_VT_CONSOLE)
+#if defined(CONFIG_PM_SLEEP) && defined(CONFIG_VT) && defined(CONFIG_VT_CONSOLE)
 extern int pm_prepare_console(void);
 extern void pm_restore_console(void);
 #else
@@ -54,7 +54,6 @@ struct hibernation_ops {
 	void (*restore_cleanup)(void);
 };
 
-#ifdef CONFIG_PM
 #ifdef CONFIG_HIBERNATION
 /* kernel/power/snapshot.c */
 extern void __register_nosave_region(unsigned long b, unsigned long e, int km);
@@ -82,6 +81,7 @@ static inline void hibernation_set_ops(s
 static inline int hibernate(void) { return -ENOSYS; }
 #endif /* CONFIG_HIBERNATION */
 
+#ifdef CONFIG_PM_SLEEP
 void save_processor_state(void);
 void restore_processor_state(void);
 struct saved_context;
@@ -106,7 +106,7 @@ static inline int unregister_pm_notifier
 		{ .notifier_call = fn, .priority = pri };	\
 	register_pm_notifier(&fn##_nb);			\
 }
-#else /* CONFIG_PM */
+#else /* !CONFIG_PM_SLEEP */
 
 static inline int register_pm_notifier(struct notifier_block *nb)
 {
@@ -119,9 +119,9 @@ static inline int unregister_pm_notifier
 }
 
 #define pm_notifier(fn, pri)	do { (void)(fn); } while (0)
-#endif /* CONFIG_PM */
+#endif /* !CONFIG_PM_SLEEP */
 
-#if !defined CONFIG_HIBERNATION || !defined(CONFIG_PM)
+#ifndef CONFIG_HIBERNATION
 static inline void register_nosave_region(unsigned long b, unsigned long e)
 {
 }
Index: linux-2.6/include/linux/pm.h
===================================================================
--- linux-2.6.orig/include/linux/pm.h	2007-07-29 19:06:26.000000000 +0200
+++ linux-2.6/include/linux/pm.h	2007-07-29 20:05:02.000000000 +0200
@@ -165,6 +165,7 @@ struct pm_ops {
 	int (*finish)(suspend_state_t state);
 };
 
+#ifdef CONFIG_SUSPEND
 extern struct pm_ops *pm_ops;
 
 /**
@@ -193,6 +194,12 @@ extern void arch_suspend_disable_irqs(vo
 extern void arch_suspend_enable_irqs(void);
 
 extern int pm_suspend(suspend_state_t state);
+#else /* !CONFIG_SUSPEND */
+#define suspend_valid_only_mem	NULL
+
+static inline void pm_set_ops(struct pm_ops *pm_ops) {}
+static inline int pm_suspend(suspend_state_t state) { return -ENOSYS; }
+#endif /* !CONFIG_SUSPEND */
 
 /*
  * Device power management
@@ -266,7 +273,7 @@ typedef struct pm_message {
 struct dev_pm_info {
 	pm_message_t		power_state;
 	unsigned		can_wakeup:1;
-#ifdef	CONFIG_PM
+#ifdef	CONFIG_PM_SLEEP
 	unsigned		should_wakeup:1;
 	struct list_head	entry;
 #endif
@@ -276,7 +283,7 @@ extern int device_power_down(pm_message_
 extern void device_power_up(void);
 extern void device_resume(void);
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 extern int device_suspend(pm_message_t state);
 extern int device_prepare_suspend(pm_message_t state);
 
@@ -306,7 +313,7 @@ static inline int call_platform_enable_w
 	return 0;
 }
 
-#else /* !CONFIG_PM */
+#else /* !CONFIG_PM_SLEEP */
 
 static inline int device_suspend(pm_message_t state)
 {
@@ -323,7 +330,7 @@ static inline int call_platform_enable_w
 	return 0;
 }
 
-#endif
+#endif /* !CONFIG_PM_SLEEP */
 
 /* changes to device_may_wakeup take effect on the next pm state change.
  * by default, devices should wakeup if they can.
Index: linux-2.6/kernel/power/power.h
===================================================================
--- linux-2.6.orig/kernel/power/power.h	2007-07-29 19:06:26.000000000 +0200
+++ linux-2.6/kernel/power/power.h	2007-07-29 19:06:48.000000000 +0200
@@ -176,9 +176,17 @@ struct timeval;
 extern void swsusp_show_speed(struct timeval *, struct timeval *,
 				unsigned int, char *);
 
+#ifdef CONFIG_SUSPEND
 /* kernel/power/main.c */
-extern int suspend_enter(suspend_state_t state);
 extern int suspend_devices_and_enter(suspend_state_t state);
+#else /* !CONFIG_SUSPEND */
+static inline int suspend_devices_and_enter(suspend_state_t state)
+{
+	return -ENOSYS;
+}
+#endif /* !CONFIG_SUSPEND */
+
+/* kernel/power/common.c */
 extern struct blocking_notifier_head pm_chain_head;
 
 static inline int pm_notifier_call_chain(unsigned long val)
Index: linux-2.6/kernel/power/main.c
===================================================================
--- linux-2.6.orig/kernel/power/main.c	2007-07-29 19:06:26.000000000 +0200
+++ linux-2.6/kernel/power/main.c	2007-07-29 19:06:48.000000000 +0200
@@ -25,11 +25,13 @@
 
 BLOCKING_NOTIFIER_HEAD(pm_chain_head);
 
-/*This is just an arbitrary number */
-#define FREE_PAGE_NUMBER (100)
-
 DEFINE_MUTEX(pm_mutex);
 
+#ifdef CONFIG_SUSPEND
+
+/* This is just an arbitrary number */
+#define FREE_PAGE_NUMBER (100)
+
 struct pm_ops *pm_ops;
 
 /**
@@ -269,6 +271,8 @@ int pm_suspend(suspend_state_t state)
 
 EXPORT_SYMBOL(pm_suspend);
 
+#endif /* CONFIG_SUSPEND */
+
 decl_subsys(power,NULL,NULL);
 
 
@@ -285,13 +289,15 @@ decl_subsys(power,NULL,NULL);
 
 static ssize_t state_show(struct kset *kset, char *buf)
 {
+	char *s = buf;
+#ifdef CONFIG_SUSPEND
 	int i;
-	char * s = buf;
 
 	for (i = 0; i < PM_SUSPEND_MAX; i++) {
 		if (pm_states[i] && valid_state(i))
 			s += sprintf(s,"%s ", pm_states[i]);
 	}
+#endif
 #ifdef CONFIG_HIBERNATION
 	s += sprintf(s, "%s\n", "disk");
 #else
@@ -304,11 +310,13 @@ static ssize_t state_show(struct kset *k
 
 static ssize_t state_store(struct kset *kset, const char *buf, size_t n)
 {
+#ifdef CONFIG_SUSPEND
 	suspend_state_t state = PM_SUSPEND_STANDBY;
 	const char * const *s;
+#endif
 	char *p;
-	int error;
 	int len;
+	int error = -EINVAL;
 
 	p = memchr(buf, '\n', n);
 	len = p ? p - buf : n;
@@ -316,17 +324,19 @@ static ssize_t state_store(struct kset *
 	/* First, check if we are requested to hibernate */
 	if (len == 4 && !strncmp(buf, "disk", len)) {
 		error = hibernate();
-		return error ? error : n;
+  goto Exit;
 	}
 
+#ifdef CONFIG_SUSPEND
 	for (s = &pm_states[state]; state < PM_SUSPEND_MAX; s++, state++) {
 		if (*s && len == strlen(*s) && !strncmp(buf, *s, len))
 			break;
 	}
 	if (state < PM_SUSPEND_MAX && *s)
 		error = enter_state(state);
-	else
-		error = -EINVAL;
+#endif
+
+ Exit:
 	return error ? error : n;
 }
 
Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c	2007-07-29 19:06:26.000000000 +0200
+++ linux-2.6/mm/page_alloc.c	2007-07-29 19:06:48.000000000 +0200
@@ -726,7 +726,7 @@ static void __drain_pages(unsigned int c
 	}
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_HIBERNATION
 
 void mark_free_pages(struct zone *zone)
 {
@@ -772,7 +772,7 @@ void drain_local_pages(void)
 	__drain_pages(smp_processor_id());
 	local_irq_restore(flags);	
 }
-#endif /* CONFIG_PM */
+#endif /* CONFIG_HIBERNATION */
 
 /*
  * Free a 0-order page
Index: linux-2.6/drivers/base/power/power.h
===================================================================
--- linux-2.6.orig/drivers/base/power/power.h	2007-07-29 19:06:26.000000000 +0200
+++ linux-2.6/drivers/base/power/power.h	2007-07-29 19:06:48.000000000 +0200
@@ -5,7 +5,7 @@
 extern void device_shutdown(void);
 
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 
 /*
  * main.c
@@ -62,7 +62,7 @@ extern int resume_device(struct device *
  */
 extern int suspend_device(struct device *, pm_message_t);
 
-#else /* CONFIG_PM */
+#else /* CONFIG_PM_SLEEP */
 
 
 static inline int device_pm_add(struct device * dev)
Index: linux-2.6/include/linux/freezer.h
===================================================================
--- linux-2.6.orig/include/linux/freezer.h	2007-07-29 19:06:26.000000000 +0200
+++ linux-2.6/include/linux/freezer.h	2007-07-29 19:06:48.000000000 +0200
@@ -5,7 +5,7 @@
 
 #include <linux/sched.h>
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 /*
  * Check if a process has been frozen
  */
@@ -126,7 +126,7 @@ static inline void set_freezable(void)
 	current->flags &= ~PF_NOFREEZE;
 }
 
-#else
+#else /* !CONFIG_PM_SLEEP */
 static inline int frozen(struct task_struct *p) { return 0; }
 static inline int freezing(struct task_struct *p) { return 0; }
 static inline void set_freeze_flag(struct task_struct *p) {}
@@ -143,6 +143,6 @@ static inline void freezer_do_not_count(
 static inline void freezer_count(void) {}
 static inline int freezer_should_skip(struct task_struct *p) { return 0; }
 static inline void set_freezable(void) {}
-#endif
+#endif /* !CONFIG_PM_SLEEP */
 
 #endif	/* FREEZER_H_INCLUDED */
Index: linux-2.6/include/acpi/acpi_bus.h
===================================================================
--- linux-2.6.orig/include/acpi/acpi_bus.h	2007-07-29 19:06:26.000000000 +0200
+++ linux-2.6/include/acpi/acpi_bus.h	2007-07-29 19:06:48.000000000 +0200
@@ -366,7 +366,16 @@ acpi_handle acpi_get_child(acpi_handle, 
 acpi_handle acpi_get_pci_rootbridge_handle(unsigned int, unsigned int);
 #define DEVICE_ACPI_HANDLE(dev) ((acpi_handle)((dev)->archdata.acpi_handle))
 
+#ifdef CONFIG_PM_SLEEP
 int acpi_pm_device_sleep_state(struct device *, int, int *);
+#else /* !CONFIG_PM_SLEEP */
+static inline int acpi_pm_device_sleep_state(struct device *d, int w, int *p)
+{
+	if (p)
+		*p = ACPI_STATE_D0;
+	return ACPI_STATE_D3;
+}
+#endif /* !CONFIG_PM_SLEEP */
 
 #endif				/* CONFIG_ACPI */
 
Index: linux-2.6/drivers/acpi/sleep/Makefile
===================================================================
--- linux-2.6.orig/drivers/acpi/sleep/Makefile	2007-07-27 21:34:37.000000000 +0200
+++ linux-2.6/drivers/acpi/sleep/Makefile	2007-07-29 19:13:59.000000000 +0200
@@ -1,5 +1,5 @@
 obj-y					:= poweroff.o wakeup.o
-obj-y					+= main.o
+obj-$(CONFIG_PM_SLEEP)			+= main.o
 obj-$(CONFIG_X86)			+= proc.o
 
 EXTRA_CFLAGS += $(ACPI_CFLAGS)
Index: linux-2.6/drivers/acpi/Kconfig
===================================================================
--- linux-2.6.orig/drivers/acpi/Kconfig	2007-07-27 21:34:37.000000000 +0200
+++ linux-2.6/drivers/acpi/Kconfig	2007-07-29 21:07:18.000000000 +0200
@@ -63,6 +63,14 @@ config ACPI_PROCFS
 
 	  Say N to delete /proc/acpi/ files that have moved to /sys/
 
+config ACPI_PROCFS_SLEEP
+	bool "/proc/acpi/sleep (deprecated)"
+	depends on PM_SLEEP && ACPI_PROCFS
+	default n
+	---help---
+	  Create /proc/acpi/sleep
+	  Deprecated by /sys/power/state
+
 config ACPI_AC
 	tristate "AC Adapter"
 	depends on X86
Index: linux-2.6/drivers/acpi/sleep/proc.c
===================================================================
--- linux-2.6.orig/drivers/acpi/sleep/proc.c	2007-07-29 19:06:03.000000000 +0200
+++ linux-2.6/drivers/acpi/sleep/proc.c	2007-07-29 19:33:11.000000000 +0200
@@ -23,7 +23,7 @@
  */
 
 ACPI_MODULE_NAME("sleep")
-#ifdef	CONFIG_ACPI_PROCFS
+#ifdef	CONFIG_ACPI_PROCFS_SLEEP
 static int acpi_system_sleep_seq_show(struct seq_file *seq, void *offset)
 {
 	int i;
@@ -76,7 +76,7 @@ acpi_system_write_sleep(struct file *fil
       Done:
 	return error ? error : count;
 }
-#endif				/* CONFIG_ACPI_PROCFS */
+#endif				/* CONFIG_ACPI_PROCFS_SLEEP */
 
 #if defined(CONFIG_RTC_DRV_CMOS) || defined(CONFIG_RTC_DRV_CMOS_MODULE)
 /* use /sys/class/rtc/rtcX/wakealarm instead; it's not ACPI-specific */
@@ -471,7 +471,7 @@ static const struct file_operations acpi
 	.release = single_release,
 };
 
-#ifdef	CONFIG_ACPI_PROCFS
+#ifdef	CONFIG_ACPI_PROCFS_SLEEP
 static const struct file_operations acpi_system_sleep_fops = {
 	.open = acpi_system_sleep_open_fs,
 	.read = seq_read,
@@ -479,7 +479,7 @@ static const struct file_operations acpi
 	.llseek = seq_lseek,
 	.release = single_release,
 };
-#endif				/* CONFIG_ACPI_PROCFS */
+#endif				/* CONFIG_ACPI_PROCFS_SLEEP */
 
 #ifdef	HAVE_ACPI_LEGACY_ALARM
 static const struct file_operations acpi_system_alarm_fops = {
@@ -506,7 +506,7 @@ static int __init acpi_sleep_proc_init(v
 	if (acpi_disabled)
 		return 0;
 
-#ifdef	CONFIG_ACPI_PROCFS
+#ifdef	CONFIG_ACPI_PROCFS_SLEEP
 	/* 'sleep' [R/W] */
 	entry =
 	    create_proc_entry("sleep", S_IFREG | S_IRUGO | S_IWUSR,
Index: linux-2.6/include/acpi/acpi_drivers.h
===================================================================
--- linux-2.6.orig/include/acpi/acpi_drivers.h	2007-07-29 19:40:59.000000000 +0200
+++ linux-2.6/include/acpi/acpi_drivers.h	2007-07-29 19:41:55.000000000 +0200
@@ -147,6 +147,10 @@ static inline void unregister_hotplug_do
 /*--------------------------------------------------------------------------
                                   Suspend/Resume
   -------------------------------------------------------------------------- */
+#ifdef CONFIG_PM_SLEEP
 extern int acpi_sleep_init(void);
+#else
+static inline int acpi_sleep_init(void) { return 0; }
+#endif
 
 #endif /*__ACPI_DRIVERS_H__*/
Index: linux-2.6/drivers/acpi/sleep/main.c
===================================================================
--- linux-2.6.orig/drivers/acpi/sleep/main.c	2007-07-29 19:06:03.000000000 +0200
+++ linux-2.6/drivers/acpi/sleep/main.c	2007-07-29 22:06:59.000000000 +0200
@@ -21,6 +21,9 @@
 
 u8 sleep_states[ACPI_S_STATE_COUNT];
 
+static u32 acpi_target_sleep_state = ACPI_STATE_S0;
+
+#ifdef CONFIG_SUSPEND
 static struct pm_ops acpi_pm_ops;
 
 extern void do_suspend_lowlevel(void);
@@ -34,11 +37,6 @@ static u32 acpi_suspend_states[] = {
 
 static int init_8259A_after_S1;
 
-extern int acpi_sleep_prepare(u32 acpi_state);
-extern void acpi_power_off(void);
-
-static u32 acpi_target_sleep_state = ACPI_STATE_S0;
-
 /**
  *	acpi_pm_set_target - Set the target system sleep state to the state
  *		associated with given @pm_state, if supported.
@@ -163,21 +161,6 @@ static int acpi_pm_finish(suspend_state_
 	return 0;
 }
 
-int acpi_suspend(u32 acpi_state)
-{
-	suspend_state_t states[] = {
-		[1] = PM_SUSPEND_STANDBY,
-		[3] = PM_SUSPEND_MEM,
-		[5] = PM_SUSPEND_MAX
-	};
-
-	if (acpi_state < 6 && states[acpi_state])
-		return pm_suspend(states[acpi_state]);
-	if (acpi_state == 4)
-		return hibernate();
-	return -EINVAL;
-}
-
 static int acpi_pm_state_valid(suspend_state_t pm_state)
 {
 	u32 acpi_state;
@@ -202,6 +185,27 @@ static struct pm_ops acpi_pm_ops = {
 	.finish = acpi_pm_finish,
 };
 
+/*
+ * Toshiba fails to preserve interrupts over S1, reinitialization
+ * of 8259 is needed after S1 resume.
+ */
+static int __init init_ints_after_s1(struct dmi_system_id *d)
+{
+	printk(KERN_WARNING "%s with broken S1 detected.\n", d->ident);
+	init_8259A_after_S1 = 1;
+	return 0;
+}
+
+static struct dmi_system_id __initdata acpisleep_dmi_table[] = {
+	{
+	 .callback = init_ints_after_s1,
+	 .ident = "Toshiba Satellite 4030cdt",
+	 .matches = {DMI_MATCH(DMI_PRODUCT_NAME, "S4030CDT/4.3"),},
+	 },
+	{},
+};
+#endif /* CONFIG_SUSPEND */
+
 #ifdef CONFIG_HIBERNATION
 static int acpi_hibernation_prepare(void)
 {
@@ -256,6 +260,21 @@ static struct hibernation_ops acpi_hiber
 };
 #endif				/* CONFIG_HIBERNATION */
 
+int acpi_suspend(u32 acpi_state)
+{
+	suspend_state_t states[] = {
+		[1] = PM_SUSPEND_STANDBY,
+		[3] = PM_SUSPEND_MEM,
+		[5] = PM_SUSPEND_MAX
+	};
+
+	if (acpi_state < 6 && states[acpi_state])
+		return pm_suspend(states[acpi_state]);
+	if (acpi_state == 4)
+		return hibernate();
+	return -EINVAL;
+}
+
 /**
  *	acpi_pm_device_sleep_state - return preferred power state of ACPI device
  *		in the system sleep state given by %acpi_target_sleep_state
@@ -331,39 +350,22 @@ int acpi_pm_device_sleep_state(struct de
 	return d_max;
 }
 
-/*
- * Toshiba fails to preserve interrupts over S1, reinitialization
- * of 8259 is needed after S1 resume.
- */
-static int __init init_ints_after_s1(struct dmi_system_id *d)
-{
-	printk(KERN_WARNING "%s with broken S1 detected.\n", d->ident);
-	init_8259A_after_S1 = 1;
-	return 0;
-}
-
-static struct dmi_system_id __initdata acpisleep_dmi_table[] = {
-	{
-	 .callback = init_ints_after_s1,
-	 .ident = "Toshiba Satellite 4030cdt",
-	 .matches = {DMI_MATCH(DMI_PRODUCT_NAME, "S4030CDT/4.3"),},
-	 },
-	{},
-};
-
 int __init acpi_sleep_init(void)
 {
+	acpi_status status;
+	u8 type_a, type_b;
+#ifdef CONFIG_SUSPEND
 	int i = 0;
 
 	dmi_check_system(acpisleep_dmi_table);
+#endif
 
 	if (acpi_disabled)
 		return 0;
 
+#ifdef CONFIG_SUSPEND
 	printk(KERN_INFO PREFIX "(supports");
-	for (i = 0; i < ACPI_S_STATE_COUNT; i++) {
-		acpi_status status;
-		u8 type_a, type_b;
+	for (i = ACPI_STATE_S0; i < ACPI_STATE_S4; i++) {
 		status = acpi_get_sleep_type_data(i, &type_a, &type_b);
 		if (ACPI_SUCCESS(status)) {
 			sleep_states[i] = 1;
@@ -373,10 +375,14 @@ int __init acpi_sleep_init(void)
 	printk(")\n");
 
 	pm_set_ops(&acpi_pm_ops);
+#endif
 
 #ifdef CONFIG_HIBERNATION
-	if (sleep_states[ACPI_STATE_S4])
+	status = acpi_get_sleep_type_data(ACPI_STATE_S4, &type_a, &type_b);
+	if (ACPI_SUCCESS(status)) {
 		hibernation_set_ops(&acpi_hibernation_ops);
+		sleep_states[ACPI_STATE_S4] = 1;
+	}
 #else
 	sleep_states[ACPI_STATE_S4] = 0;
 #endif
Index: linux-2.6/drivers/acpi/sleep/sleep.h
===================================================================
--- linux-2.6.orig/drivers/acpi/sleep/sleep.h	2007-05-10 21:34:52.000000000 +0200
+++ linux-2.6/drivers/acpi/sleep/sleep.h	2007-07-29 20:26:01.000000000 +0200
@@ -6,3 +6,5 @@ extern void acpi_enable_wakeup_device_pr
 extern void acpi_enable_wakeup_device(u8 sleep_state);
 extern void acpi_disable_wakeup_device(u8 sleep_state);
 extern void acpi_gpe_sleep_prepare(u32 sleep_state);
+
+extern int acpi_sleep_prepare(u32 acpi_state);
