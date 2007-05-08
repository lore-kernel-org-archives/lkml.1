Return-Path: <linux-kernel-owner+w=401wt.eu-S1032206AbXEHVLG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032206AbXEHVLG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 17:11:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032179AbXEHVKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 17:10:50 -0400
Received: from 62.sub-75-208-32.myvzw.com ([75.208.32.62]:34698 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S967979AbXEHVKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 17:10:47 -0400
Message-Id: <20070508205517.358968475@goop.org>
References: <20070508205129.064843364@goop.org>
User-Agent: quilt/0.46-1
Date: Tue, 08 May 2007 13:51:33 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Len Brown <lenb@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
       Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>
Subject: [patch 4/4] Add common orderly_poweroff()
Content-Disposition: inline; filename=orderly-poweroff.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Various pieces of code around the kernel want to be able to trigger an
orderly poweroff.  This pulls them together into a single
implementation.

By default the poweroff command is /sbin/poweroff, but it can be set
via sysctl: kernel/poweroff_cmd.  This is split at whitespace, so it
can include command-line arguments.

This patch replaces four other instances of invoking either "poweroff"
or "shutdown -h now": one sparc64, two sbus drivers, and acpi thermal
management.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Len Brown <lenb@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David S. Miller <davem@davemloft.net>

---
 arch/sparc64/kernel/power.c     |   40 +------------------------------
 drivers/acpi/thermal.c          |   24 +-----------------
 drivers/sbus/char/bbc_envctrl.c |    5 +--
 drivers/sbus/char/envctrl.c     |    7 +----
 include/linux/reboot.h          |    5 +++
 include/linux/sysctl.h          |    1
 kernel/sys.c                    |   50 +++++++++++++++++++++++++++++++++++++++
 kernel/sysctl.c                 |   10 +++++++
 8 files changed, 74 insertions(+), 68 deletions(-)

diff -r 9eea40ea89b7 arch/sparc64/kernel/power.c
--- a/arch/sparc64/kernel/power.c	Tue May 08 12:59:41 2007 -0700
+++ b/arch/sparc64/kernel/power.c	Tue May 08 13:42:22 2007 -0700
@@ -13,6 +13,7 @@
 #include <linux/interrupt.h>
 #include <linux/pm.h>
 #include <linux/syscalls.h>
+#include <linux/reboot.h>
 
 #include <asm/system.h>
 #include <asm/auxio.h>
@@ -32,14 +33,13 @@ int scons_pwroff = 1;
 #include <linux/pci.h>
 static void __iomem *power_reg;
 
-static DECLARE_WAIT_QUEUE_HEAD(powerd_wait);
 static int button_pressed;
 
 static irqreturn_t power_handler(int irq, void *dev_id)
 {
 	if (button_pressed == 0) {
 		button_pressed = 1;
-		wake_up(&powerd_wait);
+		orderly_poweroff(true);
 	}
 
 	/* FIXME: Check registers for status... */
@@ -75,36 +75,6 @@ EXPORT_SYMBOL(pm_power_off);
 EXPORT_SYMBOL(pm_power_off);
 
 #ifdef CONFIG_PCI
-static int powerd(void *__unused)
-{
-	static char *envp[] = { "HOME=/", "TERM=linux", "PATH=/sbin:/usr/sbin:/bin:/usr/bin", NULL };
-	char *argv[] = { "/sbin/shutdown", "-h", "now", NULL };
-	DECLARE_WAITQUEUE(wait, current);
-
-	daemonize("powerd");
-
-	add_wait_queue(&powerd_wait, &wait);
-again:
-	for (;;) {
-		set_task_state(current, TASK_INTERRUPTIBLE);
-		if (button_pressed)
-			break;
-		flush_signals(current);
-		schedule();
-	}
-	__set_current_state(TASK_RUNNING);
-	remove_wait_queue(&powerd_wait, &wait);
-
-	/* Ok, down we go... */
-	button_pressed = 0;
-	if (kernel_execve("/sbin/shutdown", argv, envp) < 0) {
-		printk("powerd: shutdown execution failed\n");
-		add_wait_queue(&powerd_wait, &wait);
-		goto again;
-	}
-	return 0;
-}
-
 static int __init has_button_interrupt(unsigned int irq, struct device_node *dp)
 {
 	if (irq == PCI_IRQ_NONE)
@@ -128,12 +98,6 @@ static int __devinit power_probe(struct 
 	poweroff_method = machine_halt;  /* able to use the standard halt */
 
 	if (has_button_interrupt(irq, op->node)) {
-		if (kernel_thread(powerd, NULL, CLONE_FS) < 0) {
-			printk("Failed to start power daemon.\n");
-			return 0;
-		}
-		printk("powerd running.\n");
-
 		if (request_irq(irq,
 				power_handler, 0, "power", NULL) < 0)
 			printk("power: Error, cannot register IRQ handler.\n");
diff -r 9eea40ea89b7 drivers/acpi/thermal.c
--- a/drivers/acpi/thermal.c	Tue May 08 12:59:41 2007 -0700
+++ b/drivers/acpi/thermal.c	Tue May 08 13:42:22 2007 -0700
@@ -40,6 +40,7 @@
 #include <linux/jiffies.h>
 #include <linux/kmod.h>
 #include <linux/seq_file.h>
+#include <linux/reboot.h>
 #include <asm/uaccess.h>
 
 #include <acpi/acpi_bus.h>
@@ -61,7 +62,6 @@
 #define ACPI_THERMAL_MODE_ACTIVE	0x00
 #define ACPI_THERMAL_MODE_PASSIVE	0x01
 #define ACPI_THERMAL_MODE_CRITICAL   	0xff
-#define ACPI_THERMAL_PATH_POWEROFF	"/sbin/poweroff"
 
 #define ACPI_THERMAL_MAX_ACTIVE	10
 #define ACPI_THERMAL_MAX_LIMIT_STR_LEN 65
@@ -431,26 +431,6 @@ static int acpi_thermal_get_devices(stru
 	return 0;
 }
 
-static int acpi_thermal_call_usermode(char *path)
-{
-	char *argv[2] = { NULL, NULL };
-	char *envp[3] = { NULL, NULL, NULL };
-
-
-	if (!path)
-		return -EINVAL;
-
-	argv[0] = path;
-
-	/* minimal command environment */
-	envp[0] = "HOME=/";
-	envp[1] = "PATH=/sbin:/bin:/usr/sbin:/usr/bin";
-
-	call_usermodehelper(argv[0], argv, envp, 0);
-
-	return 0;
-}
-
 static int acpi_thermal_critical(struct acpi_thermal *tz)
 {
 	if (!tz || !tz->trips.critical.flags.valid)
@@ -468,7 +448,7 @@ static int acpi_thermal_critical(struct 
 	acpi_bus_generate_event(tz->device, ACPI_THERMAL_NOTIFY_CRITICAL,
 				tz->trips.critical.flags.enabled);
 
-	acpi_thermal_call_usermode(ACPI_THERMAL_PATH_POWEROFF);
+	orderly_poweroff(true);
 
 	return 0;
 }
diff -r 9eea40ea89b7 drivers/sbus/char/bbc_envctrl.c
--- a/drivers/sbus/char/bbc_envctrl.c	Tue May 08 12:59:41 2007 -0700
+++ b/drivers/sbus/char/bbc_envctrl.c	Tue May 08 13:42:22 2007 -0700
@@ -7,6 +7,7 @@
 #include <linux/kthread.h>
 #include <linux/delay.h>
 #include <linux/kmod.h>
+#include <linux/reboot.h>
 #include <asm/oplib.h>
 #include <asm/ebus.h>
 
@@ -170,8 +171,6 @@ static void do_envctrl_shutdown(struct b
 static void do_envctrl_shutdown(struct bbc_cpu_temperature *tp)
 {
 	static int shutting_down = 0;
-	static char *envp[] = { "HOME=/", "TERM=linux", "PATH=/sbin:/usr/sbin:/bin:/usr/bin", NULL };
-	char *argv[] = { "/sbin/shutdown", "-h", "now", NULL };
 	char *type = "???";
 	s8 val = -1;
 
@@ -195,7 +194,7 @@ static void do_envctrl_shutdown(struct b
 	printk(KERN_CRIT "kenvctrld: Shutting down the system now.\n");
 
 	shutting_down = 1;
-	if (call_usermodehelper("/sbin/shutdown", argv, envp, 0) < 0)
+	if (orderly_poweroff(true) < 0)
 		printk(KERN_CRIT "envctrl: shutdown execution failed\n");
 }
 
diff -r 9eea40ea89b7 drivers/sbus/char/envctrl.c
--- a/drivers/sbus/char/envctrl.c	Tue May 08 12:59:41 2007 -0700
+++ b/drivers/sbus/char/envctrl.c	Tue May 08 13:42:22 2007 -0700
@@ -26,6 +26,7 @@
 #include <linux/ioport.h>
 #include <linux/miscdevice.h>
 #include <linux/kmod.h>
+#include <linux/reboot.h>
 
 #include <asm/ebus.h>
 #include <asm/uaccess.h>
@@ -965,10 +966,6 @@ static void envctrl_do_shutdown(void)
 static void envctrl_do_shutdown(void)
 {
 	static int inprog = 0;
-	static char *envp[] = {	
-		"HOME=/", "TERM=linux", "PATH=/sbin:/usr/sbin:/bin:/usr/bin", NULL };
-	char *argv[] = { 
-		"/sbin/shutdown", "-h", "now", NULL };	
 	int ret;
 
 	if (inprog != 0)
@@ -976,7 +973,7 @@ static void envctrl_do_shutdown(void)
 
 	inprog = 1;
 	printk(KERN_CRIT "kenvctrld: WARNING: Shutting down the system now.\n");
-	ret = call_usermodehelper("/sbin/shutdown", argv, envp, 0);
+	ret = orderly_poweroff(true);
 	if (ret < 0) {
 		printk(KERN_CRIT "kenvctrld: WARNING: system shutdown failed!\n"); 
 		inprog = 0;  /* unlikely to succeed, but we could try again */
diff -r 9eea40ea89b7 include/linux/reboot.h
--- a/include/linux/reboot.h	Tue May 08 12:59:41 2007 -0700
+++ b/include/linux/reboot.h	Tue May 08 13:42:22 2007 -0700
@@ -67,6 +67,11 @@ extern void kernel_power_off(void);
 
 void ctrl_alt_del(void);
 
+#define POWEROFF_CMD_PATH_LEN	256
+extern char poweroff_cmd[POWEROFF_CMD_PATH_LEN];
+
+extern int orderly_poweroff(bool force);
+
 /*
  * Emergency restart, callable from an interrupt handler.
  */
diff -r 9eea40ea89b7 include/linux/sysctl.h
--- a/include/linux/sysctl.h	Tue May 08 12:59:41 2007 -0700
+++ b/include/linux/sysctl.h	Tue May 08 13:42:22 2007 -0700
@@ -165,6 +165,7 @@ enum
 	KERN_MAX_LOCK_DEPTH=74,
 	KERN_NMI_WATCHDOG=75, /* int: enable/disable nmi watchdog */
 	KERN_PANIC_ON_NMI=76, /* int: whether we will panic on an unrecovered */
+	KERN_POWEROFF_CMD=77,	/* string: poweroff command line */
 };
 
 
diff -r 9eea40ea89b7 kernel/sys.c
--- a/kernel/sys.c	Tue May 08 12:59:41 2007 -0700
+++ b/kernel/sys.c	Tue May 08 13:42:22 2007 -0700
@@ -2208,3 +2208,58 @@ asmlinkage long sys_getcpu(unsigned __us
 	}
 	return err ? -EFAULT : 0;
 }
+
+char poweroff_cmd[POWEROFF_CMD_PATH_LEN] = "/sbin/poweroff";
+
+static void argv_cleanup(char **argv, char **envp)
+{
+	argv_free(argv);
+}
+
+/**
+ * Trigger an orderly system poweroff
+ *
+ * This may be called from any context to trigger a system shutdown.
+ * If the orderly shutdown fails, it will force an immediate shutdown.
+ */
+int orderly_poweroff(bool force)
+{
+	int argc;
+	char **argv = argv_split(GFP_ATOMIC, poweroff_cmd, &argc);
+	static char *envp[] = {
+		"HOME=/",
+		"PATH=/sbin:/bin:/usr/sbin:/usr/bin",
+		NULL
+	};
+	int ret = -ENOMEM;
+	struct subprocess_info *info;
+
+	if (argv == NULL) {
+		printk(KERN_WARNING "%s failed to allocate memory for \"%s\"\n",
+		       __func__, poweroff_cmd);
+		goto out;
+	}
+
+	info = call_usermodehelper_setup(argv[0], argv, envp);
+	if (info == NULL)
+		goto out;
+
+	call_usermodehelper_setcleanup(info, argv_cleanup);
+
+	ret = call_usermodehelper_exec(info, -1);
+
+  out:
+	if (ret && force) {
+		printk(KERN_WARNING "Failed to start orderly shutdown: "
+		       "forcing the issue\n");
+
+		/* I guess this should try to kick off some daemon to
+		   sync and poweroff asap.  Or not even bother syncing
+		   if we're doing an emergency shutdown? */
+		emergency_sync();
+		kernel_power_off();
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(orderly_poweroff);
diff -r 9eea40ea89b7 kernel/sysctl.c
--- a/kernel/sysctl.c	Tue May 08 12:59:41 2007 -0700
+++ b/kernel/sysctl.c	Tue May 08 13:42:22 2007 -0700
@@ -45,6 +45,7 @@
 #include <linux/syscalls.h>
 #include <linux/nfs_fs.h>
 #include <linux/acpi.h>
+#include <linux/reboot.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -603,6 +604,15 @@ static ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 #endif
+	{
+		.ctl_name	= KERN_POWEROFF_CMD,
+		.procname	= "poweroff_cmd",
+		.data		= &poweroff_cmd,
+		.maxlen		= POWEROFF_CMD_PATH_LEN,
+		.mode		= 0644,
+		.proc_handler	= &proc_dostring,
+		.strategy	= &sysctl_string,
+	},
 
 	{ .ctl_name = 0 }
 };

-- 

