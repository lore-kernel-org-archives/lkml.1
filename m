Return-Path: <linux-kernel-owner+w=401wt.eu-S1758971AbXHITRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758971AbXHITRp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 15:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750798AbXHITRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 15:17:34 -0400
Received: from mail.queued.net ([207.210.101.209]:1095 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbXHITRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 15:17:33 -0400
Date: Thu, 9 Aug 2007 15:18:21 -0400
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: turn serial console suspend a boot rather than
 compile time option
Message-Id: <20070809151821.5479f94b.dilinger@queued.net>
In-Reply-To: <20070808161345.4733b656.akpm@linux-foundation.org>
References: <20070808183535.2a2c6edf.dilinger@queued.net>
	<20070808154130.9cc3a30e.akpm@linux-foundation.org>
	<20070808190713.b59c9b00.dilinger@queued.net>
	<20070808161345.4733b656.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.4 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Aug 2007 16:13:45 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 8 Aug 2007 19:07:13 -0400
> Andres Salomon <dilinger@queued.net> wrote:
> 
> > On Wed, 8 Aug 2007 15:41:30 -0700
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > On Wed, 8 Aug 2007 18:35:35 -0400
> > > Andres Salomon <dilinger@queued.net> wrote:
> > > 
> > [...]
> > > > --- a/include/linux/kernel.h
> > > > +++ b/include/linux/kernel.h
> > > > @@ -172,6 +172,8 @@ extern int __printk_ratelimit(int ratelimit_jiffies, int ratelimit_burst);
> > > >  extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
> > > >  				unsigned int interval_msec);
> > > >  
> > > > +extern int console_suspend;
> > > > +
> > > 
> > > That's a somewhat vague-sounding identifier.  Could we call it
> > > console_suspend_enabled or something?
> > > 
> > 
> > Hm, how about serial_console_suspend_enabled or enable_serial_console_suspend?  I can send an updated patch later.
> > 
> 
> I prefer the big-endian version (serial_console_suspend_enabled)

Here's a version that uses that, and also moves the variable declaration
into linux/console.h (rather than linux/kernel.h).



serial: turn serial console suspend a boot rather than compile time option

Currently, there's a CONFIG_DISABLE_CONSOLE_SUSPEND that allows one to stop
the serial console from being suspended when the rest of the machine goes
to sleep.  This is incredibly useful for debugging power management-related
things; however, having it as a compile-time option has proved to be
incredibly inconvenient for us (OLPC).  There are plenty of times that we
want serial console to not suspend, but for the most part we'd like serial
console to be suspended.

This drops CONFIG_DISABLE_CONSOLE_SUSPEND, and replaces it with a kernel
boot parameter (no_console_suspend).  By default, the serial console will
be suspended along with the rest of the system; by passing
'no_console_suspend' to the kernel during boot, serial console will remain
alive during suspend.

I have another version of this patch which keeps #ifdefs around; however,
it's uglier.  I prefer this version of the patch, and don't feel that it
increases bloat.  If people strongly disagree, let me know and I'll submit
the other patch.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---

 Documentation/kernel-parameters.txt        |    8 ++++++++
 Documentation/power/basic-pm-debugging.txt |    4 ++--
 arch/powerpc/configs/pmac32_defconfig      |    1 -
 drivers/serial/serial_core.c               |   10 ++++------
 include/linux/console.h                    |    7 ++-----
 kernel/power/Kconfig                       |   11 -----------
 kernel/printk.c                            |   15 +++++++++++++--
 7 files changed, 29 insertions(+), 27 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index efdb42f..572b529 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -462,6 +462,14 @@ and is between 256 and 4096 characters. It is defined in the file
 			UART at the specified I/O port or MMIO address.
 			The options are the same as for ttyS, above.
 
+	no_console_suspend
+			[HW] Never suspend the serial console
+			Disable suspending the serial console during
+			suspend/resume operations.  If disabled, debugging
+			messages can reach the console while the rest of
+			the system is being put to sleep (ie, while
+			debugging driver suspend/resume hooks).
+
 	cpcihp_generic=	[HW,PCI] Generic port I/O CompactPCI driver
 			Format:
 			<first_slot>,<last_slot>,<port>,<enum_bit>[,<debug>]
diff --git a/Documentation/power/basic-pm-debugging.txt b/Documentation/power/basic-pm-debugging.txt
index 1a85e2b..86f3431 100644
--- a/Documentation/power/basic-pm-debugging.txt
+++ b/Documentation/power/basic-pm-debugging.txt
@@ -78,8 +78,8 @@ c) Advanced debugging
 In case the STD does not work on your system even in the minimal configuration
 and compiling more drivers as modules is not practical or some modules cannot
 be unloaded, you can use one of the more advanced debugging techniques to find
-the problem.  First, if there is a serial port in your box, you can set the
-CONFIG_DISABLE_CONSOLE_SUSPEND kernel configuration option and try to log kernel
+the problem.  First, if there is a serial port in your box, you boot the
+kernel with the 'no_console_suspend' parameter and try to log kernel
 messages using the serial console.  This may provide you with some information
 about the reasons of the suspend (resume) failure.  Alternatively, it may be
 possible to use a FireWire port for debugging with firescope
diff --git a/arch/powerpc/configs/pmac32_defconfig b/arch/powerpc/configs/pmac32_defconfig
index 08525d6..0e236c6 100644
--- a/arch/powerpc/configs/pmac32_defconfig
+++ b/arch/powerpc/configs/pmac32_defconfig
@@ -216,7 +216,6 @@ CONFIG_PROC_DEVICETREE=y
 CONFIG_PM=y
 # CONFIG_PM_LEGACY is not set
 CONFIG_PM_DEBUG=y
-# CONFIG_DISABLE_CONSOLE_SUSPEND is not set
 CONFIG_PM_SYSFS_DEPRECATED=y
 CONFIG_HIBERNATION=y
 CONFIG_PM_STD_PARTITION=""
diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 030a606..4dc767e 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -1941,12 +1941,11 @@ int uart_suspend_port(struct uart_driver *drv, struct uart_port *port)
 
 	mutex_lock(&state->mutex);
 
-#ifdef CONFIG_DISABLE_CONSOLE_SUSPEND
-	if (uart_console(port)) {
+	if (!serial_console_suspend_enabled && uart_console(port)) {
+		/* we're going to avoid suspending serial console */
 		mutex_unlock(&state->mutex);
 		return 0;
 	}
-#endif
 
 	if (state->info && state->info->flags & UIF_INITIALIZED) {
 		const struct uart_ops *ops = port->ops;
@@ -1989,12 +1988,11 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *port)
 
 	mutex_lock(&state->mutex);
 
-#ifdef CONFIG_DISABLE_CONSOLE_SUSPEND
-	if (uart_console(port)) {
+	if (!serial_console_suspend_enabled && uart_console(port)) {
+		/* no need to resume serial console, it wasn't suspended */
 		mutex_unlock(&state->mutex);
 		return 0;
 	}
-#endif
 
 	uart_change_pm(state, 0);
 
diff --git a/include/linux/console.h b/include/linux/console.h
index 56a7bcd..1a8b034 100644
--- a/include/linux/console.h
+++ b/include/linux/console.h
@@ -121,14 +121,11 @@ extern void console_stop(struct console *);
 extern void console_start(struct console *);
 extern int is_console_locked(void);
 
-#ifndef CONFIG_DISABLE_CONSOLE_SUSPEND
+extern int serial_console_suspend_enabled;
+
 /* Suspend and resume console messages over PM events */
 extern void suspend_console(void);
 extern void resume_console(void);
-#else
-static inline void suspend_console(void) {}
-static inline void resume_console(void) {}
-#endif /* CONFIG_DISABLE_CONSOLE_SUSPEND */
 
 int mda_console_init(void);
 void prom_con_init(void);
diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index 412859f..b8677bb 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -44,17 +44,6 @@ config PM_VERBOSE
 	---help---
 	This option enables verbose messages from the Power Management code.
 
-config DISABLE_CONSOLE_SUSPEND
-	bool "Keep console(s) enabled during suspend/resume (DANGEROUS)"
-	depends on PM_DEBUG && PM_SLEEP
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
 	depends on PM_DEBUG && X86 && PM_SLEEP && EXPERIMENTAL
diff --git a/kernel/printk.c b/kernel/printk.c
index bd2cd06..1dc8e71 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -751,7 +751,15 @@ int update_console_cmdline(char *name, int idx, char *name_new, int idx_new, cha
 	return -1;
 }
 
-#ifndef CONFIG_DISABLE_CONSOLE_SUSPEND
+int serial_console_suspend_enabled = 1;
+
+static int __init console_suspend_disable(char *str)
+{
+	serial_console_suspend_enabled = 0;
+	return 1;
+}
+__setup("no_console_suspend", console_suspend_disable);
+
 /**
  * suspend_console - suspend the console subsystem
  *
@@ -759,6 +767,8 @@ int update_console_cmdline(char *name, int idx, char *name_new, int idx_new, cha
  */
 void suspend_console(void)
 {
+	if (!serial_console_suspend_enabled)
+		return;
 	printk("Suspending console(s)\n");
 	acquire_console_sem();
 	console_suspended = 1;
@@ -766,10 +776,11 @@ void suspend_console(void)
 
 void resume_console(void)
 {
+	if (!serial_console_suspend_enabled)
+		return;
 	console_suspended = 0;
 	release_console_sem();
 }
-#endif /* CONFIG_DISABLE_CONSOLE_SUSPEND */
 
 /**
  * acquire_console_sem - lock the console system for exclusive use.
