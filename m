Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593AbXFKQ1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbXFKQ1x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 12:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbXFKQ1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 12:27:46 -0400
Received: from ns2.suse.de ([195.135.220.15]:42149 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252AbXFKQ1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 12:27:45 -0400
Date: Mon, 11 Jun 2007 18:27:38 +0200
From: Stefan Seyfried <seife@suse.de>
To: linux-kernel@vger.kernel.org
Cc: suspend-devel List <suspend-devel@lists.sourceforge.net>
Subject: [PATCH] make disable_console_suspend runtime configurable
Message-ID: <20070611162737.GC14645@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Operating-System: openSUSE 10.3 (i586) Alpha4plus, Kernel 2.6.22-rc3-git2-5-default
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I hate having to recompile the kernel, just to be able to debug suspend.
Remove CONFIG_DISABLE_CONSOLE_SUSPEND, replace it by a sysctl in
/proc/sys/kernel/disable_console_suspend.

Signed-off-by: Stefan Seyfried <seife@suse.de>
---
Patch is against 2.6.22-rc4

 Documentation/power/basic-pm-debugging.txt |   16 +++++++++-------
 drivers/serial/serial_core.c               |    8 ++------
 include/linux/console.h                    |    7 ++-----
 include/linux/sysctl.h                     |    1 +
 kernel/power/Kconfig                       |   11 -----------
 kernel/printk.c                            |    7 +++++--
 kernel/sysctl.c                            |    9 +++++++++

diff -rup a/Documentation/power/basic-pm-debugging.txt b/Documentation/power/basic-pm-debugging.txt
--- a/Documentation/power/basic-pm-debugging.txt	2007-06-05 02:57:25.000000000 +0200
+++ b/Documentation/power/basic-pm-debugging.txt	2007-06-11 16:07:24.000000000 +0200
@@ -78,13 +78,15 @@ c) Advanced debugging
 In case the STD does not work on your system even in the minimal configuration
 and compiling more drivers as modules is not practical or some modules cannot
 be unloaded, you can use one of the more advanced debugging techniques to find
-the problem.  First, if there is a serial port in your box, you can set the
-CONFIG_DISABLE_CONSOLE_SUSPEND kernel configuration option and try to log kernel
-messages using the serial console.  This may provide you with some information
-about the reasons of the suspend (resume) failure.  Alternatively, it may be
-possible to use a FireWire port for debugging with firescope
-(ftp://ftp.firstfloor.org/pub/ak/firescope/).  On i386 it is also possible to
-use the PM_TRACE mechanism documented in Documentation/s2ram.txt .
+the problem.  First, if there is a serial port in your box, you can
+
+# echo 1 > /proc/sys/kernel/disable_console_suspend
+
+and try to log kernel messages using the serial console.  This may provide you
+with some information about the reasons of the suspend (resume) failure.
+Alternatively, it may be possible to use a FireWire port for debugging with
+firescope (ftp://ftp.firstfloor.org/pub/ak/firescope/).  On i386 it is also
+possible to use the PM_TRACE mechanism documented in Documentation/s2ram.txt .
 
 2. Testing suspend to RAM (STR)
 
diff -rup a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c	2007-06-05 02:57:25.000000000 +0200
+++ b/drivers/serial/serial_core.c	2007-06-11 16:07:24.000000000 +0200
@@ -1934,12 +1934,10 @@ int uart_suspend_port(struct uart_driver
 
 	mutex_lock(&state->mutex);
 
-#ifdef CONFIG_DISABLE_CONSOLE_SUSPEND
-	if (uart_console(port)) {
+	if (disable_console_suspend && uart_console(port)) {
 		mutex_unlock(&state->mutex);
 		return 0;
 	}
-#endif
 
 	if (state->info && state->info->flags & UIF_INITIALIZED) {
 		const struct uart_ops *ops = port->ops;
@@ -1982,12 +1980,10 @@ int uart_resume_port(struct uart_driver 
 
 	mutex_lock(&state->mutex);
 
-#ifdef CONFIG_DISABLE_CONSOLE_SUSPEND
-	if (uart_console(port)) {
+	if (disable_console_suspend && uart_console(port)) {
 		mutex_unlock(&state->mutex);
 		return 0;
 	}
-#endif
 
 	uart_change_pm(state, 0);
 
diff -rup a/include/linux/console.h b/include/linux/console.h
--- a/include/linux/console.h	2007-06-05 02:57:25.000000000 +0200
+++ b/include/linux/console.h	2007-06-11 16:10:02.000000000 +0200
@@ -64,6 +64,8 @@ extern const struct consw vga_con;	/* VG
 extern const struct consw newport_con;	/* SGI Newport console  */
 extern const struct consw prom_con;	/* SPARC PROM console */
 
+extern int disable_console_suspend;
+
 int con_is_bound(const struct consw *csw);
 int register_con_driver(const struct consw *csw, int first, int last);
 int unregister_con_driver(const struct consw *csw);
@@ -120,14 +122,9 @@ extern void console_stop(struct console 
 extern void console_start(struct console *);
 extern int is_console_locked(void);
 
-#ifndef CONFIG_DISABLE_CONSOLE_SUSPEND
 /* Suspend and resume console messages over PM events */
 extern void suspend_console(void);
 extern void resume_console(void);
-#else
-static inline void suspend_console(void) {}
-static inline void resume_console(void) {}
-#endif /* CONFIG_DISABLE_CONSOLE_SUSPEND */
 
 int mda_console_init(void);
 void prom_con_init(void);
diff -rup a/include/linux/sysctl.h b/include/linux/sysctl.h
--- a/include/linux/sysctl.h	2007-06-05 02:57:25.000000000 +0200
+++ b/include/linux/sysctl.h	2007-06-11 16:11:10.000000000 +0200
@@ -165,6 +165,7 @@ enum
 	KERN_MAX_LOCK_DEPTH=74,
 	KERN_NMI_WATCHDOG=75, /* int: enable/disable nmi watchdog */
 	KERN_PANIC_ON_NMI=76, /* int: whether we will panic on an unrecovered */
+	KERN_CONSOLE_SUSPEND=77, /* int: disable consoles on system suspend */
 };
 
 
diff -rup a/kernel/power/Kconfig b/kernel/power/Kconfig
--- a/kernel/power/Kconfig	2007-06-05 02:57:25.000000000 +0200
+++ b/kernel/power/Kconfig	2007-06-11 16:07:24.000000000 +0200
@@ -37,17 +37,6 @@ config PM_DEBUG
 	code. This is helpful when debugging and reporting various PM bugs, 
 	like suspend support.
 
-config DISABLE_CONSOLE_SUSPEND
-	bool "Keep console(s) enabled during suspend/resume (DANGEROUS)"
-	depends on PM && PM_DEBUG
-	default n
-	---help---
-	This option turns off the console suspend mechanism that prevents
-	debug messages from reaching the console during the suspend/resume
-	operations.  This may be helpful when debugging device drivers'
-	suspend/resume routines, but may itself lead to problems, for example
-	if netconsole is used.
-
 config PM_TRACE
 	bool "Suspend/resume event tracing"
 	depends on PM && PM_DEBUG && X86_32 && EXPERIMENTAL
diff -rup a/kernel/printk.c b/kernel/printk.c
--- a/kernel/printk.c	2007-06-05 02:57:25.000000000 +0200
+++ b/kernel/printk.c	2007-06-11 16:07:24.000000000 +0200
@@ -76,6 +76,7 @@ struct console *console_drivers;
  * locked without the console sempahore held
  */
 static int console_locked, console_suspended;
+int disable_console_suspend;
 
 /*
  * logbuf_lock protects log_buf, log_start, log_end, con_start and logged_chars
@@ -726,7 +727,6 @@ int __init add_preferred_console(char *n
 	return 0;
 }
 
-#ifndef CONFIG_DISABLE_CONSOLE_SUSPEND
 /**
  * suspend_console - suspend the console subsystem
  *
@@ -734,6 +734,8 @@ int __init add_preferred_console(char *n
  */
 void suspend_console(void)
 {
+	if (disable_console_suspend)
+		return;
 	printk("Suspending console(s)\n");
 	acquire_console_sem();
 	console_suspended = 1;
@@ -741,10 +743,11 @@ void suspend_console(void)
 
 void resume_console(void)
 {
+	if (disable_console_suspend)
+		return;
 	console_suspended = 0;
 	release_console_sem();
 }
-#endif /* CONFIG_DISABLE_CONSOLE_SUSPEND */
 
 /**
  * acquire_console_sem - lock the console system for exclusive use.
diff -rup a/kernel/sysctl.c b/kernel/sysctl.c
--- a/kernel/sysctl.c	2007-06-05 02:57:25.000000000 +0200
+++ b/kernel/sysctl.c	2007-06-11 16:07:24.000000000 +0200
@@ -45,6 +45,7 @@
 #include <linux/syscalls.h>
 #include <linux/nfs_fs.h>
 #include <linux/acpi.h>
+#include <linux/console.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -575,6 +576,14 @@ static ctl_table kern_table[] = {
 		.proc_handler	= &proc_doulongvec_minmax,
 	},
 #endif
+	{
+		.ctl_name	= KERN_CONSOLE_SUSPEND,
+		.procname	= "disable_console_suspend",
+		.data		= &disable_console_suspend,
+		.maxlen		= sizeof (int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
 #ifdef CONFIG_IA64
 	{
 		.ctl_name	= KERN_IA64_UNALIGNED,
-- 
Stefan Seyfried
QA / R&D Team Mobile Devices        |              "Any ideas, John?"
SUSE LINUX Products GmbH, Nürnberg  | "Well, surrounding them's out." 

This footer brought to you by insane German lawmakers:
SUSE Linux Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)
