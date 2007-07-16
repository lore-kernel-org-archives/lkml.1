Return-Path: <linux-kernel-owner+w=401wt.eu-S1754562AbXGPTcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562AbXGPTcR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 15:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754443AbXGPTcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 15:32:06 -0400
Received: from gw.goop.org ([64.81.55.164]:44908 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215AbXGPTcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 15:32:04 -0400
Message-ID: <469BC777.5010207@goop.org>
Date: Mon, 16 Jul 2007 12:31:03 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>, Andi Kleen <ak@suse.de>
Subject: powerd in arch/sparc64/kernel/power.c
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

I was about to submit the patch below for merging, but it obviously 
conflicts with your change 13077d80286205e02eebe1c2786a914a4bbd2588 
("[SPARC64]: Export powerd facilities for external entities.") which was 
merged this morning.

My patch makes orderly_poweroff() a globally-common function to generate 
a user-level poweroff event, and it basically a superset of powerd.   
Should I drop the sparc parts of this patch, or would you be OK with 
dropping powerd?

Thanks,
    J

Subject: Add common orderly_poweroff()

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
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
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
 kernel/sys.c                    |   58 +++++++++++++++++++++++++++++++++++++++
 kernel/sysctl.c                 |   10 ++++++
 7 files changed, 81 insertions(+), 68 deletions(-)

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
@@ -33,14 +34,13 @@ int scons_pwroff = 1;
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
@@ -77,36 +77,6 @@ EXPORT_SYMBOL(pm_power_off);
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
@@ -130,12 +100,6 @@ static int __devinit power_probe(struct 
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
@@ -59,7 +60,6 @@
 #define ACPI_THERMAL_NOTIFY_CRITICAL	0xF0
 #define ACPI_THERMAL_NOTIFY_HOT		0xF1
 #define ACPI_THERMAL_MODE_ACTIVE	0x00
-#define ACPI_THERMAL_PATH_POWEROFF	"/sbin/poweroff"
 
 #define ACPI_THERMAL_MAX_ACTIVE	10
 #define ACPI_THERMAL_MAX_LIMIT_STR_LEN 65
@@ -419,26 +419,6 @@ static int acpi_thermal_get_devices(stru
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
@@ -456,7 +436,7 @@ static int acpi_thermal_critical(struct 
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
@@ -966,10 +967,6 @@ static void envctrl_do_shutdown(void)
 static void envctrl_do_shutdown(void)
 {
 	static int inprog = 0;
-	static char *envp[] = {	
-		"HOME=/", "TERM=linux", "PATH=/sbin:/usr/sbin:/bin:/usr/bin", NULL };
-	char *argv[] = { 
-		"/sbin/shutdown", "-h", "now", NULL };	
 	int ret;
 
 	if (inprog != 0)
@@ -977,7 +974,7 @@ static void envctrl_do_shutdown(void)
 
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
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2277,3 +2277,61 @@ asmlinkage long sys_getcpu(unsigned __us
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
+ * orderly_poweroff - Trigger an orderly system poweroff
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
@@ -695,6 +696,15 @@ static ctl_table kern_table[] = {
 		.proc_handler   = &proc_dointvec,
 	},
 #endif
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "poweroff_cmd",
+		.data		= &poweroff_cmd,
+		.maxlen		= POWEROFF_CMD_PATH_LEN,
+		.mode		= 0644,
+		.proc_handler	= &proc_dostring,
+		.strategy	= &sysctl_string,
+	},
 
 	{ .ctl_name = 0 }
 };


