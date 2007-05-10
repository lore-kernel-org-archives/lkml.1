Return-Path: <linux-kernel-owner+w=401wt.eu-S1763668AbXEKTYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763668AbXEKTYt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762897AbXEKTUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:20:11 -0400
Received: from 161.sub-75-209-96.myvzw.com ([75.209.96.161]:36801 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966265AbXEKTUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:20:03 -0400
Message-Id: <20070511000028.446470000@goop.org>
References: <20070510235708.155502000@goop.org>
User-Agent: quilt/0.46-1
Date: Thu, 10 May 2007 16:57:14 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Len Brown <lenb@kernel.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 6/7] Add common orderly_poweroff()
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
Acked-by: Len Brown <lenb@kernel.org>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David S. Miller <davem@davemloft.net>

---
 arch/sparc64/kernel/power.c     |   40 +-------------------------
 drivers/acpi/thermal.c          |   24 +---------------
 drivers/sbus/char/bbc_envctrl.c |    5 +--
 drivers/sbus/char/envctrl.c     |    7 +---
 include/linux/reboot.h          |    5 +++
 include/linux/sysctl.h          |    1 
 kernel/sys.c                    |   58 +++++++++++++++++++++++++++++++++++++++
 kernel/sysctl.c                 |   10 ++++++
 8 files changed, 82 insertions(+), 68 deletions(-)

===================================================================
--- a/arch/sparc64/kernel/power.c
+++ b/arch/sparc64/kernel/power.c
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
===================================================================
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
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
===================================================================
--- a/drivers/sbus/char/bbc_envctrl.c
+++ b/drivers/sbus/char/bbc_envctrl.c
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
 
===================================================================
--- a/drivers/sbus/char/envctrl.c
+++ b/drivers/sbus/char/envctrl.c
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
===================================================================
--- a/include/linux/reboot.h
+++ b/include/linux/reboot.h
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
===================================================================
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -165,6 +165,7 @@ enum
 	KERN_MAX_LOCK_DEPTH=74,
 	KERN_NMI_WATCHDOG=75, /* int: enable/disable nmi watchdog */
 	KERN_PANIC_ON_NMI=76, /* int: whether we will panic on an unrecovered */
+	KERN_POWEROFF_CMD=77,	/* string: poweroff command line */
 };
 
 
===================================================================
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2208,3 +2208,61 @@ asmlinkage long sys_getcpu(unsigned __us
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
+ * @force: force poweroff if command execution fails
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
+	if (info == NULL) {
+		argv_free(argv);
+		goto out;
+	}
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
===================================================================
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
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

