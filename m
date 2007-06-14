Return-Path: <linux-kernel-owner+w=401wt.eu-S1752865AbXFNOAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbXFNOAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 10:00:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbXFNOAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 10:00:04 -0400
Received: from mail.suse.de ([195.135.220.2]:38675 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441AbXFNOAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 10:00:01 -0400
From: Frank Seidel <fseidel@suse.de>
Organization: SUSE LINUX Products GmbH
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH, 3rd try] make disable_console_suspend runtime configurable
Date: Thu, 14 Jun 2007 15:59:54 +0200
User-Agent: KMail/1.9.7
Cc: Stefan Seyfried <seife@suse.de>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       akpm@linux-foundation.org, nigel@nigel.suspend2.net
References: <20070613200303.GB11437@suse.de> <20070613222308.GA17266@suse.de> <200706141414.22152.rjw@sisk.pl>
In-Reply-To: <200706141414.22152.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706141559.54242.fseidel@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Seyfried <seife@suse.de>

I hate having to recompile the kernel, just to be able to debug suspend.
Remove CONFIG_DISABLE_CONSOLE_SUSPEND, replace it by a tunable in
/sys/power/disable_console_suspend.


Signed-off-by: Stefan Seyfried <seife@suse.de>
Signed-off-by: Frank Seidel <fseidel@suse.de>
---
Third try, renamed sysfs interface to console_suspend 
reporting and expecting either "enabled" or "disabled"

 Documentation/power/basic-pm-debugging.txt |   16 +++++++++-------
 drivers/serial/serial_core.c               |    8 ++------
 include/linux/console.h                    |    7 ++-----
 kernel/power/Kconfig                       |   11 -----------
 kernel/power/main.c                        |   28 ++++++++++++++++++++++++++++
 kernel/printk.c                            |    7 +++++--
 6 files changed, 46 insertions(+), 31 deletions(-)

--- a/Documentation/power/basic-pm-debugging.txt
+++ b/Documentation/power/basic-pm-debugging.txt
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
+# echo disabled > /sys/power/console_suspend
+
+and try to log kernel messages using the serial console.  This may provide you
+with some information about the reasons of the suspend (resume) failure.
+Alternatively, it may be possible to use a FireWire port for debugging with
+firescope (ftp://ftp.firstfloor.org/pub/ak/firescope/).  On i386 it is also
+possible to use the PM_TRACE mechanism documented in Documentation/s2ram.txt .
 
 2. Testing suspend to RAM (STR)
 
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
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
 
--- a/include/linux/console.h
+++ b/include/linux/console.h
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
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
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
--- a/kernel/printk.c
+++ b/kernel/printk.c
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
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -308,6 +308,32 @@ static ssize_t state_store(struct kset *
 
 power_attr(state);
 
+/**
+ * disable_console_suspend - control console suspend
+ *
+ * If set the consoles are not suspended so it is
+ * still possible to see and collect debug info.
+ */
+static ssize_t console_suspend_show(struct kset *kset, char *buf)
+{
+	return sprintf(buf, disable_console_suspend ? "disabled\n" : "enabled\n");
+}
+
+static ssize_t console_suspend_store(struct kset *kset, const char *buf, size_t n)
+{
+	if (strncmp(buf, "disabled", 8) == 0) {
+		disable_console_suspend = 1;
+		return n;
+	} else if (strncmp(buf, "enabled", 7) == 0) {
+		disable_console_suspend = 0;
+		return n;
+	}
+
+	return -EINVAL;
+}
+
+power_attr(console_suspend);
+
 #ifdef CONFIG_PM_TRACE
 int pm_trace_enabled;
 
@@ -332,12 +358,14 @@ power_attr(pm_trace);
 
 static struct attribute * g[] = {
 	&state_attr.attr,
+	&console_suspend_attr.attr,
 	&pm_trace_attr.attr,
 	NULL,
 };
 #else
 static struct attribute * g[] = {
 	&state_attr.attr,
+	&console_suspend_attr.attr,
 	NULL,
 };
 #endif /* CONFIG_PM_TRACE */
