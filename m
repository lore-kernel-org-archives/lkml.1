Return-Path: <linux-kernel-owner+w=401wt.eu-S1752387AbXA0UHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387AbXA0UHH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 15:07:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbXA0UHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 15:07:07 -0500
Received: from ns1.mvista.com ([63.81.120.158]:57361 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbXA0UHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 15:07:04 -0500
Message-ID: <45BBB097.1090207@mvista.com>
Date: Sat, 27 Jan 2007 10:05:43 -1000
From: akuster <akuster@mvista.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] PM: fast power off - core 
Content-Type: multipart/mixed;
 boundary="------------020200030200090205040905"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020200030200090205040905
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

My apologies, I cc'd the wrong list the first time around.

- Armin

---

--------------020200030200090205040905
Content-Type: text/x-patch;
 name="fastpoweroff-1.0.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fastpoweroff-1.0.patch"

Fastpoweroff  allows a user to power down the system without using rc kill
scripts. This is used in the advent of a battery operated device about to lose
power.  The user interface is vis sysfs /sys/power/fastpoweroff. A simple cat of
the fastpoweroff will list any registered profiles.  To invoke
the profile sequence, echo {profile name} > /sys/power/fastpoweroff.

This is the core code for fastpoweroff profile support, it includes a
register/unregister and default profile callbacks.

Signed-off-by: Armin Kuster <AKuster@mvista.com>
---
 fs/super.c                    |    6 +
 kernel/power/Kconfig          |    2 
 kernel/power/Makefile         |    2 
 kernel/power/fastoff/Kconfig  |   13 +++
 kernel/power/fastoff/Makefile |    8 ++
 kernel/power/fastoff/fpo.c    |  155 ++++++++++++++++++++++++++++++++++++++++++
 kernel/power/fastoff/fpo.h    |   27 +++++++
 7 files changed, 213 insertions(+)

Index: linux-2.6_dev/kernel/power/Kconfig
===================================================================
--- linux-2.6_dev.orig/kernel/power/Kconfig
+++ linux-2.6_dev/kernel/power/Kconfig
@@ -131,3 +131,5 @@ config SUSPEND_SMP
 	bool
 	depends on HOTPLUG_CPU && X86 && PM
 	default y
+
+source "kernel/power/fastoff/Kconfig"
Index: linux-2.6_dev/kernel/power/Makefile
===================================================================
--- linux-2.6_dev.orig/kernel/power/Makefile
+++ linux-2.6_dev/kernel/power/Makefile
@@ -8,3 +8,5 @@ obj-$(CONFIG_PM_LEGACY)		+= pm.o
 obj-$(CONFIG_SOFTWARE_SUSPEND)	+= swsusp.o disk.o snapshot.o swap.o user.o
 
 obj-$(CONFIG_MAGIC_SYSRQ)	+= poweroff.o
+
+obj-$(CONFIG_FAST_POWER_OFF)	+= fastoff/
Index: linux-2.6_dev/kernel/power/fastoff/Kconfig
===================================================================
--- /dev/null
+++ linux-2.6_dev/kernel/power/fastoff/Kconfig
@@ -0,0 +1,13 @@
+#
+# Fast power off configuration
+#
+menu "Fast Power off"
+
+config FAST_POWER_OFF
+	bool "Fast power off support"
+	default y
+	depends on PM && SYSFS
+	---help---
+	  Say yes if you want core support for sysfs/power/fastoff
+
+endmenu
Index: linux-2.6_dev/kernel/power/fastoff/Makefile
===================================================================
--- /dev/null
+++ linux-2.6_dev/kernel/power/fastoff/Makefile
@@ -0,0 +1,8 @@
+#
+# Makefile for Fast Power off
+#
+# 15 Jan. 2007 Armin Kuster <akuster@mvista.com>
+#
+
+obj-$(CONFIG_FAST_POWER_OFF)	:= fpo.o
+
Index: linux-2.6_dev/kernel/power/fastoff/fpo.h
===================================================================
--- /dev/null
+++ linux-2.6_dev/kernel/power/fastoff/fpo.h
@@ -0,0 +1,27 @@
+#ifndef __FASTOFF_H__
+#define __FASTOFF_H__
+/*
+ * kernel/power/fastoff/fpo.h
+ *
+ * Author: Armin Kuster <AKuster@mvista.com, or source@mvista.com>
+ *
+ * 2006, 2007  (c) MontaVista Software, Inc. This file is licensed under
+ * the terms of the GNU General Public License version 2. This program
+ * is licensed "as is" without any warranty of any kind, whether express
+ * or implied.
+ */
+
+#define FPO_NAME_LEN 16
+
+struct fpo_driver {
+	char name[FPO_NAME_LEN];
+	int (*policy) (void);
+	struct list_head fpo_list;
+};
+
+extern int fastpoweroff_register(struct fpo_driver *fpo);
+extern void fastpoweroff_unregister(struct fpo_driver *fpo);
+extern void fastpoweroff_prepare(void);
+extern void fastpoweroff(void);
+extern void fastpoweroff_standby(void);
+#endif	/* __FASTOFF_H__ */
Index: linux-2.6_dev/kernel/power/fastoff/fpo.c
===================================================================
--- /dev/null
+++ linux-2.6_dev/kernel/power/fastoff/fpo.c
@@ -0,0 +1,155 @@
+/*
+ * kernel/power/fastoff/fpo.c
+ *
+ * This provides a sysfs interface that allows the user to
+ * bypass running rc kill scripts in the advent the user
+ * needed to power down as fast as possible. A moduler scheme
+ * has been implimented so that a user can define how they want to
+ * shutdown.
+ *
+ * Author: Armin Kuster <AKuster@mvista.com, or source@mvista.com>
+ *
+ * 2006, 2007  (c) MontaVista Software, Inc. This file is licensed under
+ * the terms of the GNU General Public License version 2. This program
+ * is licensed "as is" without any warranty of any kind, whether express
+ * or implied.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/errno.h>
+#include <linux/pm.h>
+#include <linux/fs.h>
+#include <linux/reboot.h>
+#include <linux/freezer.h>
+#include <linux/mutex.h>
+#include <linux/list.h>
+
+#include "../power.h"
+#include "fpo.h"
+
+static LIST_HEAD(fastpoweroff_list);
+static DEFINE_MUTEX(fpo_mutex);
+
+extern void suspend_emergency_remount(void);
+
+static struct fpo_driver *__find_fastpoweroff(const char *name)
+{
+	struct fpo_driver *f;
+
+  	list_for_each_entry(f, &fastpoweroff_list, fpo_list) {
+		if (!strnicmp(name, f->name, strlen(f->name))) {
+			return f;
+		}
+	}
+	return NULL;
+}
+
+int fastpoweroff_register(struct fpo_driver *fpo)
+{
+	int ret;
+
+	if (!fpo || !fpo->name || !fpo->policy)
+		return -EINVAL;
+
+	mutex_lock(&fpo_mutex);
+	ret = -EBUSY;
+	if (__find_fastpoweroff(fpo->name) == NULL) {
+		ret = 0;
+		list_add_tail(&fpo->fpo_list, &fastpoweroff_list);
+	}
+	mutex_unlock(&fpo_mutex);
+	return ret;
+}
+
+EXPORT_SYMBOL_GPL(fastpoweroff_register);
+
+void fastpoweroff_unregister(struct fpo_driver *fpo)
+{
+	if (!fpo)
+		return;
+	mutex_lock(&fpo_mutex);
+	list_del(&fpo->fpo_list);
+	mutex_unlock(&fpo_mutex);
+}
+
+EXPORT_SYMBOL_GPL(fastpoweroff_unregister);
+
+void fastpoweroff_prepare(void)
+{
+	freeze_processes();
+	suspend_emergency_remount();
+}
+EXPORT_SYMBOL_GPL(fastpoweroff_prepare);
+
+void fastpoweroff(void)
+{
+	kernel_power_off();
+	printk(KERN_INFO "machine_power_off  not impliemented\n");
+}
+EXPORT_SYMBOL_GPL(fastpoweroff);
+
+void fastpoweroff_standby(void)
+{
+	/*
+	 * Power off not implemented on this platform.  Do the best we can
+	 * by powering off all devices and entering standby mode, re-entering
+	 * each time awoken.
+	 */
+	printk(KERN_INFO "Fallback plan...suspend devices\n");
+	device_power_down(PMSG_SUSPEND);
+	while (1)
+		pm_ops && pm_ops->enter(PM_SUSPEND_STANDBY);
+}
+EXPORT_SYMBOL_GPL(fastpoweroff_standby);
+
+/* sysfs setup */
+static ssize_t fastpoweroff_show(struct subsystem *subsys, char *buf)
+{
+	char *s = buf;
+	struct fpo_driver *f;
+
+  	list_for_each_entry(f, &fastpoweroff_list, fpo_list) {
+		s += sprintf(s, "%s ", f->name);
+	}
+	s += sprintf(s, "\n");
+	return (s - buf);
+}
+
+static ssize_t fastpoweroff_store(struct subsystem *subsys, const char *buf,
+				size_t n)
+{
+	struct fpo_driver *fpo;
+
+
+	if (n > FPO_NAME_LEN)
+		return -EINVAL;
+
+	if ((fpo = __find_fastpoweroff(buf)) == NULL) {
+		printk(KERN_ERR "PM: fastpoweroff: not a valid profile\n");
+		return -EINVAL;
+	}
+
+	if (fpo->policy)
+		fpo->policy();
+
+	return n;
+}
+
+power_attr(fastpoweroff);
+
+static int __init fastpoweroff_init(void)
+{
+	int error;
+	printk(KERN_INFO "PM: Fastpoweoff 1.0\n");
+	error = subsys_create_file(&power_subsys, &fastpoweroff_attr);
+	if (error)
+		printk(KERN_ERR
+		       "PM: Fastpoweoff -  Sysfs attribute export failed with error %d.\n",
+		       error);
+	return error;
+}
+
+core_initcall(fastpoweroff_init);
+
Index: linux-2.6_dev/fs/super.c
===================================================================
--- linux-2.6_dev.orig/fs/super.c
+++ linux-2.6_dev/fs/super.c
@@ -649,6 +649,12 @@ void emergency_remount(void)
 	pdflush_operation(do_emergency_remount, 0);
 }
 
+#ifdef CONFIG_FAST_POWER_OFF
+void suspend_emergency_remount(void)
+{
+	do_emergency_remount(0);
+}
+#endif
 /*
  * Unnamed block devices are dummy devices used by virtual
  * filesystems which don't use real block-devices.  -- jrs

--------------020200030200090205040905--
