Return-Path: <linux-kernel-owner+w=401wt.eu-S932972AbYBGAMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932972AbYBGAMI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:12:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764901AbYBFX5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:57:51 -0500
Received: from mail.suse.de ([195.135.220.2]:46093 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764481AbYBFX5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:57:49 -0500
Date: Wed, 6 Feb 2008 15:53:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Len Brown <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [patch 37/73] PM: ACPI and APM must not be enabled at the same time
Message-ID: <20080206235302.GL13121@suse.de>
References: <20080206234302.769849277@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pm-acpi-and-apm-must-not-be-enabled-at-the-same-time.patch"
In-Reply-To: <20080206235015.GA13121@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us know.
------------------
From: Len Brown <len.brown@intel.com>

patch 9f9adecd2d0e4f88fa0e8cb06c6ec207748df70a in mainline.

ACPI and APM used "pm_active" to guarantee that
they would not be simultaneously active.

But pm_active was recently moved under CONFIG_PM_LEGACY,
so that without CONFIG_PM_LEGACY, pm_active became a NOP --
allowing ACPI and APM to both be simultaneously enabled.
This caused unpredictable results, including boot hangs.

Further, the code under CONFIG_PM_LEGACY is scheduled
for removal.

So replace pm_active with pm_flags.
pm_flags depends only on CONFIG_PM,
which is present for both CONFIG_APM and CONFIG_ACPI.

http://bugzilla.kernel.org/show_bug.cgi?id=9194

Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/i386/kernel/apm.c    |   10 +++-------
 drivers/acpi/bus.c        |    7 ++-----
 include/linux/pm.h        |    9 +++++++++
 include/linux/pm_legacy.h |    6 ------
 kernel/power/main.c       |    3 +++
 kernel/power/pm.c         |    4 ----
 6 files changed, 17 insertions(+), 22 deletions(-)

--- a/arch/i386/kernel/apm.c
+++ b/arch/i386/kernel/apm.c
@@ -2256,14 +2256,12 @@ static int __init apm_init(void)
 		apm_info.disabled = 1;
 		return -ENODEV;
 	}
-	if (PM_IS_ACTIVE()) {
+	if (pm_flags & PM_ACPI) {
 		printk(KERN_NOTICE "apm: overridden by ACPI.\n");
 		apm_info.disabled = 1;
 		return -ENODEV;
 	}
-#ifdef CONFIG_PM_LEGACY
-	pm_active = 1;
-#endif
+	pm_flags |= PM_APM;
 
 	/*
 	 * Set up a segment that references the real mode segment 0x40
@@ -2366,9 +2364,7 @@ static void __exit apm_exit(void)
 		kthread_stop(kapmd_task);
 		kapmd_task = NULL;
 	}
-#ifdef CONFIG_PM_LEGACY
-	pm_active = 0;
-#endif
+	pm_flags &= ~PM_APM;
 }
 
 module_init(apm_init);
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -29,7 +29,6 @@
 #include <linux/list.h>
 #include <linux/sched.h>
 #include <linux/pm.h>
-#include <linux/pm_legacy.h>
 #include <linux/device.h>
 #include <linux/proc_fs.h>
 #ifdef CONFIG_X86
@@ -757,16 +756,14 @@ static int __init acpi_init(void)
 	result = acpi_bus_init();
 
 	if (!result) {
-#ifdef CONFIG_PM_LEGACY
-		if (!PM_IS_ACTIVE())
-			pm_active = 1;
+		if (!(pm_flags & PM_APM))
+			pm_flags |= PM_ACPI;
 		else {
 			printk(KERN_INFO PREFIX
 			       "APM is already active, exiting\n");
 			disable_acpi();
 			result = -ENODEV;
 		}
-#endif
 	} else
 		disable_acpi();
 
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -344,6 +344,15 @@ static inline int call_platform_enable_w
 		device_set_wakeup_enable(dev,val); \
 	} while(0)
 
+/*
+ * Global Power Management flags
+ * Used to keep APM and ACPI from both being active
+ */
+extern unsigned int	pm_flags;
+
+#define PM_APM	1
+#define PM_ACPI	2
+
 #endif /* __KERNEL__ */
 
 #endif /* _LINUX_PM_H */
--- a/include/linux/pm_legacy.h
+++ b/include/linux/pm_legacy.h
@@ -4,10 +4,6 @@
 
 #ifdef CONFIG_PM_LEGACY
 
-extern int pm_active;
-
-#define PM_IS_ACTIVE() (pm_active != 0)
-
 /*
  * Register a device with power management
  */
@@ -21,8 +17,6 @@ int __deprecated pm_send_all(pm_request_
 
 #else /* CONFIG_PM_LEGACY */
 
-#define PM_IS_ACTIVE() 0
-
 static inline struct pm_dev *pm_register(pm_dev_t type,
 					 unsigned long id,
 					 pm_callback callback)
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -27,6 +27,9 @@ BLOCKING_NOTIFIER_HEAD(pm_chain_head);
 
 DEFINE_MUTEX(pm_mutex);
 
+unsigned int pm_flags;
+EXPORT_SYMBOL(pm_flags);
+
 #ifdef CONFIG_SUSPEND
 
 /* This is just an arbitrary number */
--- a/kernel/power/pm.c
+++ b/kernel/power/pm.c
@@ -27,8 +27,6 @@
 #include <linux/interrupt.h>
 #include <linux/mutex.h>
 
-int pm_active;
-
 /*
  *	Locking notes:
  *		pm_devs_lock can be a semaphore providing pm ops are not called
@@ -204,6 +202,4 @@ int pm_send_all(pm_request_t rqst, void 
 
 EXPORT_SYMBOL(pm_register);
 EXPORT_SYMBOL(pm_send_all);
-EXPORT_SYMBOL(pm_active);
-
 

-- 
