Return-Path: <linux-kernel-owner+w=401wt.eu-S1762665AbXG2M31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762665AbXG2M31 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 08:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761996AbXG2M3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 08:29:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47792 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760258AbXG2M3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 08:29:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 2/2] Introduce CONFIG_SUSPEND
Date: Sun, 29 Jul 2007 14:38:05 +0200
User-Agent: KMail/1.9.5
Cc: Len Brown <lenb@kernel.org>, david@lang.hm,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Adrian Bunk <bunk@stusta.de>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200707251238.50218.lenb@kernel.org> <alpine.LFD.0.999.0707281130110.3442@woody.linux-foundation.org> <200707291220.14880.rjw@sisk.pl>
In-Reply-To: <200707291220.14880.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707291438.06849.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Introduce CONFIG_SUSPEND representing the ability to enter system sleep states,
such as the ACPI S3 state, and allow the user to choose SUSPEND and HIBERNATION
independently of each other.

Make HOTPLUG_CPU be selected automatically if SUSPEND or HIBERNATION has been
chosen and the kernel is intended for SMP systems.

Also, introduce CONFIG_PM_SLEEP which is automatically selected if
CONFIG_SUSPEND or CONFIG_HIBERNATION is set and make CONFIG_ACPI_SLEEP depend
on it.

The top-level power management headers are modified to use the new definitions.
Still, there are many other files in which CONFIG_PM can be replaced with
CONFIG_PM_SLEEP or even with CONFIG_SUSPEND, but they can be updated in the
future.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/Kconfig        |    2 +-
 drivers/base/power/Makefile |    6 +++---
 drivers/base/power/power.h  |    4 ++--
 include/acpi/acpi_bus.h     |    7 +++++++
 include/linux/freezer.h     |    6 +++---
 include/linux/pm.h          |    8 ++++----
 include/linux/suspend.h     |   16 ++++++++--------
 kernel/power/Kconfig        |   39 +++++++++++++++++++++++++++++++--------
 kernel/power/Makefile       |    3 ++-
 kernel/power/main.c         |   26 ++++++++++++++++++--------
 kernel/power/power.h        |   10 +++++++++-
 mm/page_alloc.c             |    4 ++--
 12 files changed, 90 insertions(+), 41 deletions(-)

Index: linux-2.6.23-rc1/kernel/power/Kconfig
===================================================================
--- linux-2.6.23-rc1.orig/kernel/power/Kconfig	2007-07-29 11:05:14.000000000 +0200
+++ linux-2.6.23-rc1/kernel/power/Kconfig	2007-07-29 11:18:49.000000000 +0200
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
+	bool "Suspend"
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
Index: linux-2.6.23-rc1/kernel/power/Makefile
===================================================================
--- linux-2.6.23-rc1.orig/kernel/power/Makefile	2007-07-29 11:05:14.000000000 +0200
+++ linux-2.6.23-rc1/kernel/power/Makefile	2007-07-29 12:53:13.000000000 +0200
@@ -3,8 +3,9 @@ ifeq ($(CONFIG_PM_DEBUG),y)
 EXTRA_CFLAGS	+=	-DDEBUG
 endif
 
-obj-y				:= main.o process.o console.o
+obj-y				:= main.o
 obj-$(CONFIG_PM_LEGACY)		+= pm.o
+obj-$(CONFIG_PM_SLEEP)		+= process.o console.o
 obj-$(CONFIG_HIBERNATION)	+= swsusp.o disk.o snapshot.o swap.o user.o
 
 obj-$(CONFIG_MAGIC_SYSRQ)	+= poweroff.o
Index: linux-2.6.23-rc1/drivers/base/power/Makefile
===================================================================
--- linux-2.6.23-rc1.orig/drivers/base/power/Makefile	2007-07-29 11:05:14.000000000 +0200
+++ linux-2.6.23-rc1/drivers/base/power/Makefile	2007-07-29 11:06:27.000000000 +0200
@@ -1,6 +1,6 @@
-obj-y			:= shutdown.o
-obj-$(CONFIG_PM)	+= main.o suspend.o resume.o sysfs.o
-obj-$(CONFIG_PM_TRACE)	+= trace.o
+obj-y				:= shutdown.o
+obj-$(CONFIG_PM_SLEEP)	+= main.o suspend.o resume.o sysfs.o
+obj-$(CONFIG_PM_TRACE)		+= trace.o
 
 ifeq ($(CONFIG_DEBUG_DRIVER),y)
 EXTRA_CFLAGS += -DDEBUG
Index: linux-2.6.23-rc1/include/linux/suspend.h
===================================================================
--- linux-2.6.23-rc1.orig/include/linux/suspend.h	2007-07-29 11:05:14.000000000 +0200
+++ linux-2.6.23-rc1/include/linux/suspend.h	2007-07-29 12:46:45.000000000 +0200
@@ -10,7 +10,7 @@
 #include <linux/pm.h>
 #include <linux/mm.h>
 
-#if defined(CONFIG_PM) && defined(CONFIG_VT) && defined(CONFIG_VT_CONSOLE)
+#if defined(CONFIG_PM_SLEEP) && defined(CONFIG_VT) && defined(CONFIG_VT_CONSOLE)
 extern int pm_prepare_console(void);
 extern void pm_restore_console(void);
 #else
@@ -77,7 +77,7 @@ struct platform_suspend_ops {
 	void (*finish)(void);
 };
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_SUSPEND
 /**
  * suspend_set_ops - set platform dependent suspend operations
  * @ops: The new suspend operations to set.
@@ -104,12 +104,12 @@ extern void arch_suspend_disable_irqs(vo
 extern void arch_suspend_enable_irqs(void);
 
 extern int pm_suspend(suspend_state_t state);
-#else /* CONFIG_PM */
+#else /* !CONFIG_SUSPEND */
 #define suspend_valid_only_mem	NULL
 
 static inline void suspend_set_ops(struct platform_suspend_ops *ops) {}
 static inline int pm_suspend(suspend_state_t state) { return -ENOSYS; }
-#endif /* CONFIG_PM */
+#endif /* !CONFIG_SUSPEND */
 
 /* struct pbe is used for creating lists of pages that should be restored
  * atomically during the resume from disk, because the page frames they have
@@ -173,7 +173,6 @@ struct platform_hibernation_ops {
 	void (*restore_cleanup)(void);
 };
 
-#ifdef CONFIG_PM
 #ifdef CONFIG_HIBERNATION
 /* kernel/power/snapshot.c */
 extern void __register_nosave_region(unsigned long b, unsigned long e, int km);
@@ -201,6 +200,7 @@ static inline void hibernation_set_ops(s
 static inline int hibernate(void) { return -ENOSYS; }
 #endif /* CONFIG_HIBERNATION */
 
+#ifdef CONFIG_PM_SLEEP
 void save_processor_state(void);
 void restore_processor_state(void);
 struct saved_context;
@@ -225,7 +225,7 @@ static inline int unregister_pm_notifier
 		{ .notifier_call = fn, .priority = pri };	\
 	register_pm_notifier(&fn##_nb);			\
 }
-#else /* CONFIG_PM */
+#else /* !CONFIG_PM_SLEEP */
 
 static inline int register_pm_notifier(struct notifier_block *nb)
 {
@@ -238,9 +238,9 @@ static inline int unregister_pm_notifier
 }
 
 #define pm_notifier(fn, pri)	do { (void)(fn); } while (0)
-#endif /* CONFIG_PM */
+#endif /* !CONFIG_PM_SLEEP */
 
-#if !defined CONFIG_HIBERNATION || !defined(CONFIG_PM)
+#ifndef CONFIG_HIBERNATION
 static inline void register_nosave_region(unsigned long b, unsigned long e)
 {
 }
Index: linux-2.6.23-rc1/include/linux/pm.h
===================================================================
--- linux-2.6.23-rc1.orig/include/linux/pm.h	2007-07-29 11:05:14.000000000 +0200
+++ linux-2.6.23-rc1/include/linux/pm.h	2007-07-29 11:06:27.000000000 +0200
@@ -175,7 +175,7 @@ typedef struct pm_message {
 struct dev_pm_info {
 	pm_message_t		power_state;
 	unsigned		can_wakeup:1;
-#ifdef	CONFIG_PM
+#ifdef	CONFIG_PM_SLEEP
 	unsigned		should_wakeup:1;
 	struct list_head	entry;
 #endif
@@ -185,7 +185,7 @@ extern int device_power_down(pm_message_
 extern void device_power_up(void);
 extern void device_resume(void);
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 extern int device_suspend(pm_message_t state);
 extern int device_prepare_suspend(pm_message_t state);
 
@@ -215,7 +215,7 @@ static inline int call_platform_enable_w
 	return 0;
 }
 
-#else /* !CONFIG_PM */
+#else /* !CONFIG_PM_SLEEP */
 
 static inline int device_suspend(pm_message_t state)
 {
@@ -232,7 +232,7 @@ static inline int call_platform_enable_w
 	return 0;
 }
 
-#endif
+#endif /* !CONFIG_PM_SLEEP */
 
 /* changes to device_may_wakeup take effect on the next pm state change.
  * by default, devices should wakeup if they can.
Index: linux-2.6.23-rc1/kernel/power/power.h
===================================================================
--- linux-2.6.23-rc1.orig/kernel/power/power.h	2007-07-29 11:05:14.000000000 +0200
+++ linux-2.6.23-rc1/kernel/power/power.h	2007-07-29 11:06:27.000000000 +0200
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
Index: linux-2.6.23-rc1/kernel/power/main.c
===================================================================
--- linux-2.6.23-rc1.orig/kernel/power/main.c	2007-07-29 11:05:14.000000000 +0200
+++ linux-2.6.23-rc1/kernel/power/main.c	2007-07-29 11:11:42.000000000 +0200
@@ -26,14 +26,16 @@
 
 BLOCKING_NOTIFIER_HEAD(pm_chain_head);
 
-/*This is just an arbitrary number */
-#define FREE_PAGE_NUMBER (100)
-
 DEFINE_MUTEX(pm_mutex);
 
 unsigned int pm_flags;
 EXPORT_SYMBOL(pm_flags);
 
+#ifdef CONFIG_SUSPEND
+
+/* This is just an arbitrary number */
+#define FREE_PAGE_NUMBER (100)
+
 static struct platform_suspend_ops *suspend_ops;
 
 /**
@@ -272,6 +274,8 @@ int pm_suspend(suspend_state_t state)
 
 EXPORT_SYMBOL(pm_suspend);
 
+#endif /* CONFIG_SUSPEND */
+
 decl_subsys(power,NULL,NULL);
 
 
@@ -288,13 +292,15 @@ decl_subsys(power,NULL,NULL);
 
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
@@ -307,11 +313,13 @@ static ssize_t state_show(struct kset *k
 
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
@@ -319,17 +327,19 @@ static ssize_t state_store(struct kset *
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
 
Index: linux-2.6.23-rc1/drivers/acpi/Kconfig
===================================================================
--- linux-2.6.23-rc1.orig/drivers/acpi/Kconfig	2007-07-28 22:42:57.000000000 +0200
+++ linux-2.6.23-rc1/drivers/acpi/Kconfig	2007-07-29 12:48:49.000000000 +0200
@@ -44,7 +44,7 @@ if ACPI
 
 config ACPI_SLEEP
 	bool "Sleep States"
-	depends on X86 && (!SMP || SUSPEND_SMP)
+	depends on X86 && PM_SLEEP
 	default y
 	---help---
 	  This option adds support for ACPI suspend states. 
Index: linux-2.6.23-rc1/mm/page_alloc.c
===================================================================
--- linux-2.6.23-rc1.orig/mm/page_alloc.c	2007-07-23 22:07:02.000000000 +0200
+++ linux-2.6.23-rc1/mm/page_alloc.c	2007-07-29 12:23:44.000000000 +0200
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
Index: linux-2.6.23-rc1/drivers/base/power/power.h
===================================================================
--- linux-2.6.23-rc1.orig/drivers/base/power/power.h	2007-07-26 13:00:38.000000000 +0200
+++ linux-2.6.23-rc1/drivers/base/power/power.h	2007-07-29 12:26:23.000000000 +0200
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
Index: linux-2.6.23-rc1/include/linux/freezer.h
===================================================================
--- linux-2.6.23-rc1.orig/include/linux/freezer.h	2007-07-26 20:51:27.000000000 +0200
+++ linux-2.6.23-rc1/include/linux/freezer.h	2007-07-29 12:38:57.000000000 +0200
@@ -6,7 +6,7 @@
 #include <linux/sched.h>
 #include <linux/wait.h>
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 /*
  * Check if a process has been frozen
  */
@@ -157,7 +157,7 @@ static inline void set_freezable(void)
 	} while (try_to_freeze());					\
 	__ret;								\
 })
-#else /* CONFIG_PM */
+#else /* !CONFIG_PM_SLEEP */
 static inline int frozen(struct task_struct *p) { return 0; }
 static inline int freezing(struct task_struct *p) { return 0; }
 static inline void set_freeze_flag(struct task_struct *p) {}
@@ -181,6 +181,6 @@ static inline void set_freezable(void) {
 #define wait_event_freezable_timeout(wq, condition, timeout)		\
 		wait_event_interruptible_timeout(wq, condition, timeout)
 
-#endif /* CONFIG_PM */
+#endif /* !CONFIG_PM_SLEEP */
 
 #endif	/* FREEZER_H_INCLUDED */
Index: linux-2.6.23-rc1/include/acpi/acpi_bus.h
===================================================================
--- linux-2.6.23-rc1.orig/include/acpi/acpi_bus.h	2007-07-26 20:51:27.000000000 +0200
+++ linux-2.6.23-rc1/include/acpi/acpi_bus.h	2007-07-29 13:21:09.000000000 +0200
@@ -365,7 +365,14 @@ acpi_handle acpi_get_child(acpi_handle, 
 acpi_handle acpi_get_pci_rootbridge_handle(unsigned int, unsigned int);
 #define DEVICE_ACPI_HANDLE(dev) ((acpi_handle)((dev)->archdata.acpi_handle))
 
+#ifdef CONFIG_ACPI_SLEEP
 int acpi_pm_device_sleep_state(struct device *, int, int *);
+#else /* !CONFIG_ACPI_SLEEP */
+static inline int acpi_pm_device_sleep_state(struct device *d, int w, int *p)
+{
+	return ACPI_STATE_D3;
+}
+#endif /* !CONFIG_ACPI_SLEEP */
 
 #endif				/* CONFIG_ACPI */
 
