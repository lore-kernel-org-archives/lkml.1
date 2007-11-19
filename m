Return-Path: <linux-kernel-owner+w=401wt.eu-S1756462AbXKSG71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462AbXKSG71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 01:59:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753095AbXKSG7B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 01:59:01 -0500
Received: from mga03.intel.com ([143.182.124.21]:10944 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752825AbXKSG7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 01:59:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,435,1188802800"; 
   d="scan'208";a="322047476"
Subject: [PATCH 3/3 -mm] kexec based hibernation -v6: kexec hibernate/resume
From: "Huang, Ying" <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 19 Nov 2007 15:02:49 +0800
Message-Id: <1195455769.10291.26.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 19 Nov 2007 06:58:57.0494 (UTC) FILETIME=[A7D0AF60:01C82A79]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements kexec based hibernate/resume. This is based on
the facility provided by kexec_jump. The ACPI methods are called at
specified environment to conform the ACPI specification. Two new
reboot commands are added to trigger hibernate/resume.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 include/linux/kexec.h   |    5 +
 include/linux/reboot.h  |    2 
 include/linux/suspend.h |    9 ++
 kernel/power/disk.c     |  155 ++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sys.c            |   42 +++++++++++++
 5 files changed, 212 insertions(+), 1 deletion(-)

--- a/kernel/power/disk.c
+++ b/kernel/power/disk.c
@@ -21,6 +21,7 @@
 #include <linux/console.h>
 #include <linux/cpu.h>
 #include <linux/freezer.h>
+#include <linux/kexec.h>
 
 #include "power.h"
 
@@ -438,6 +439,160 @@ int hibernate(void)
 	return error;
 }
 
+#ifdef CONFIG_KEXEC
+static void kexec_hibernate_power_down(void)
+{
+	switch (hibernation_mode) {
+	case HIBERNATION_TEST:
+	case HIBERNATION_TESTPROC:
+		break;
+	case HIBERNATION_REBOOT:
+		machine_restart(NULL);
+		break;
+	case HIBERNATION_PLATFORM:
+		if (!hibernation_ops)
+			break;
+		hibernation_ops->enter();
+		/* We should never get here */
+		while (1);
+		break;
+	case HIBERNATION_SHUTDOWN:
+		machine_power_off();
+		break;
+	}
+	machine_halt();
+	/*
+	 * Valid image is on the disk, if we continue we risk serious data
+	 * corruption after resume.
+	 */
+	printk(KERN_CRIT "Please power me down manually\n");
+	while (1);
+}
+
+int kexec_hibernate(struct kimage *image)
+{
+	int error;
+	int platform_mode = (hibernation_mode == HIBERNATION_PLATFORM);
+	unsigned long cmd_ret;
+
+	mutex_lock(&pm_mutex);
+
+	pm_prepare_console();
+	suspend_console();
+
+	error = pm_notifier_call_chain(PM_HIBERNATION_PREPARE);
+	if (error)
+		goto Resume_console;
+
+	error = platform_start(platform_mode);
+	if (error)
+		goto Resume_console;
+
+	error = device_suspend(PMSG_FREEZE);
+	if (error)
+		goto Resume_console;
+
+	error = platform_pre_snapshot(platform_mode);
+	if (error)
+		goto Resume_devices;
+
+	error = disable_nonboot_cpus();
+	if (error)
+		goto Resume_devices;
+	local_irq_disable();
+	/* At this point, device_suspend() has been called, but *not*
+	 * device_power_down(). We *must* device_power_down() now.
+	 * Otherwise, drivers for some devices (e.g. interrupt
+	 * controllers) become desynchronized with the actual state of
+	 * the hardware at resume time, and evil weirdness ensues.
+	 */
+	error = device_power_down(PMSG_FREEZE);
+	if (error)
+		goto Enable_irqs;
+
+	save_processor_state();
+	error = machine_kexec_jump(image, &cmd_ret,
+				   KJUMP_CMD_HIBERNATE_WRITE_IMAGE);
+	restore_processor_state();
+
+	if (cmd_ret == KJUMP_CMD_HIBERNATE_POWER_DOWN)
+		kexec_hibernate_power_down();
+
+	platform_leave(platform_mode);
+
+	/* NOTE:  device_power_up() is just a resume() for devices
+	 * that suspended with irqs off ... no overall powerup.
+	 */
+	device_power_up();
+ Enable_irqs:
+	local_irq_enable();
+	enable_nonboot_cpus();
+ Resume_devices:
+	platform_finish(platform_mode);
+	device_resume();
+ Resume_console:
+	pm_notifier_call_chain(PM_POST_HIBERNATION);
+	resume_console();
+	pm_restore_console();
+	mutex_unlock(&pm_mutex);
+	return error;
+}
+
+int kexec_resume(struct kimage *image)
+{
+	int error;
+	int platform_mode = (hibernation_mode == HIBERNATION_PLATFORM);
+
+	mutex_lock(&pm_mutex);
+
+	pm_prepare_console();
+	suspend_console();
+
+	error = device_suspend(PMSG_PRETHAW);
+	if (error)
+		goto Resume_console;
+
+	error = platform_pre_restore(platform_mode);
+	if (error)
+		goto Resume_devices;
+
+	error = disable_nonboot_cpus();
+	if (error)
+		goto Resume_devices;
+	local_irq_disable();
+	/* At this point, device_suspend() has been called, but *not*
+	 * device_power_down(). We *must* device_power_down() now.
+	 * Otherwise, drivers for some devices (e.g. interrupt controllers)
+	 * become desynchronized with the actual state of the hardware
+	 * at resume time, and evil weirdness ensues.
+	 */
+	error = device_power_down(PMSG_PRETHAW);
+	if (error)
+		goto Enable_irqs;
+
+	save_processor_state();
+	error = machine_kexec_jump(image, NULL, KJUMP_CMD_HIBERNATE_RESUME);
+	restore_processor_state();
+
+	platform_leave(platform_mode);
+
+	/* NOTE:  device_power_up() is just a resume() for devices
+	 * that suspended with irqs off ... no overall powerup.
+	 */
+	device_power_up();
+ Enable_irqs:
+	local_irq_enable();
+	enable_nonboot_cpus();
+ Resume_devices:
+	platform_restore_cleanup(platform_mode);
+	device_resume();
+ Resume_console:
+	resume_console();
+	pm_restore_console();
+	mutex_unlock(&pm_mutex);
+	return error;
+}
+#endif
 
 /**
  *	software_resume - Resume from a saved image.
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -207,6 +207,15 @@ static inline void hibernation_set_ops(s
 static inline int hibernate(void) { return -ENOSYS; }
 #endif /* CONFIG_HIBERNATION */
 
+struct kimage;
+#if defined(CONFIG_HIBERNATION) && defined(CONFIG_KEXEC)
+extern int kexec_hibernate(struct kimage *image);
+extern int kexec_resume(struct kimage *image);
+#else
+static inline int kexec_hibernate(struct kimage *image) { return -ENOSYS; }
+static inline int kexec_resume(struct kimage *image) { return -ENOSYS; }
+#endif
+
 #ifdef CONFIG_PM_SLEEP
 void save_processor_state(void);
 void restore_processor_state(void);
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -321,6 +321,34 @@ static int kernel_kexec(unsigned long cm
 	return ret;
 }
 
+static int kernel_kexec_hibernate(void)
+{
+	int ret = -ENOSYS;
+#if defined(CONFIG_KEXEC) && defined(CONFIG_HIBERNATION)
+	struct kimage *image;
+	image = xchg(&kexec_image, NULL);
+	if (!image)
+		return -EINVAL;
+	ret = kexec_hibernate(image);
+	kimage_free(image);
+#endif
+	return ret;
+}
+
+static int kernel_kexec_resume(void)
+{
+	int ret = -ENOSYS;
+#if defined(CONFIG_KEXEC) && defined(CONFIG_HIBERNATION)
+	struct kimage *image;
+	image = xchg(&kexec_image, NULL);
+	if (!image)
+		return -EINVAL;
+	ret = kexec_resume(image);
+	kimage_free(image);
+#endif
+	return ret;
+}
+
 static void kernel_shutdown_prepare(enum system_states state)
 {
 	blocking_notifier_call_chain(&reboot_notifier_list,
@@ -442,6 +470,20 @@ asmlinkage long sys_reboot(int magic1, i
 		}
 #endif
 
+	case LINUX_REBOOT_CMD_KEXEC_HIBERNATE:
+		{
+			int ret = kernel_kexec_hibernate();
+			unlock_kernel();
+			return ret;
+		}
+
+	case LINUX_REBOOT_CMD_KEXEC_RESUME:
+		{
+			int ret = kernel_kexec_resume();
+			unlock_kernel();
+			return ret;
+		}
+
 	default:
 		unlock_kernel();
 		return -EINVAL;
--- a/include/linux/reboot.h
+++ b/include/linux/reboot.h
@@ -33,6 +33,8 @@
 #define	LINUX_REBOOT_CMD_RESTART2	0xA1B2C3D4
 #define	LINUX_REBOOT_CMD_SW_SUSPEND	0xD000FCE2
 #define	LINUX_REBOOT_CMD_KEXEC		0x45584543
+#define LINUX_REBOOT_CMD_KEXEC_HIBERNATE 0xE4390DF3
+#define LINUX_REBOOT_CMD_KEXEC_RESUME	0xF5A41C2E
 
 
 #ifdef __KERNEL__
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -129,7 +129,10 @@ extern int machine_kexec_jump(struct kim
 			      unsigned long cmd);
 extern int kexec_jump(struct kimage *image, unsigned long *cmd_ret,
 		      unsigned long cmd);
-#define KJUMP_CMD_NONE 0
+#define KJUMP_CMD_NONE			0x0
+#define KJUMP_CMD_HIBERNATE_WRITE_IMAGE	0x6b630001
+#define KJUMP_CMD_HIBERNATE_POWER_DOWN	0x6b630002
+#define KJUMP_CMD_HIBERNATE_RESUME	0x6b630003
 #ifdef CONFIG_COMPAT
 extern asmlinkage long compat_sys_kexec_load(unsigned long entry,
 				unsigned long nr_segments,
