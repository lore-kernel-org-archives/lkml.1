Return-Path: <linux-kernel-owner+w=401wt.eu-S1761929AbZDQVcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761929AbZDQVcH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 17:32:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757721AbZDQVbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 17:31:51 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:62016 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbZDQVbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 17:31:49 -0400
X-IronPort-AV: E=Sophos;i="4.40,206,1238976000"; 
   d="scan'208";a="156126635"
Date: Fri, 17 Apr 2009 14:31:48 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Linux Embedded Mailing List <linux-embedded@vger.kernel.org>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [Patch] Wait for console to become available, ver 3
Message-ID: <20090417213148.GA27825@cuplxvomd02.corp.sa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-3; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parallelization to improve boot times has been successful enough that race
conditions now exist between the init_post() open of /dev/console and
initialization of the console device. When this occurs, opening /dev/console
fails and any applications inherited from init have no standard in/out/error
devices. This is expected behavior if no console device is available, but
quite unfortunate in the case where the console is just a bit slow waking up.

Some buses, such as USB, offer no guarantees about how long it takes to
discover devices, so there is no reliable way to distinguish between a missing
console and a slow one.  The pragmatic approach taken in this patch is to
wait for a while to see if a console shows up, and just go on if it doesn't.
The default delay is 1000 msec (1 second).

There are two new command line parameters:
consolewait		Wait forever for a console to be registered
consoledelay=msec	Use the given number of milliseconds as the delay
			interval instead of the default

Note that, though these parameters are modeled after the rootwait and rootdelay
parameters, details differ. Instead of sleeping and polling, which can increase
boot time, this code uses a waitqueue and will proceed as soon as a console is
available.

It could be argued that providing both command line parameters and a Kconfig
option for the console wait time is over-engineering. There doesn't really
seem to be a reasonable way to determine a default, though, which drives the
Kconfig option. The selection of USB devices connected to the system can
only be known at runtime, which drives the need for command line parameters.

History
v3	Increase the default delay to 1 second and add kernel command line
	parameters to override the default delay. Thanks to David Brownell for
	his helpful suggestions.
v2	Wait for the preferred console rather than any console. Make the
	delay interval a tunable.
v1	Initial version

Signed-off-by: David VomLehn <dvomlehn@cisco.com>
---
 Documentation/kernel-parameters.txt |   10 ++++++++
 arch/mips/configs/powertv_defconfig |    2 +-
 init/Kconfig                        |   12 ++++++++++
 kernel/printk.c                     |   41 +++++++++++++++++++++++++++++++++++
 4 files changed, 64 insertions(+), 1 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 6172e43..2b0c4e6 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -507,6 +507,16 @@ and is between 256 and 4096 characters. It is defined in the file
 			console=brl,ttyS0
 		For now, only VisioBraille is supported.
 
+	consoledelay=mS	[KNL] Wait up to mS milliseconds for the a preferred
+			console to be registered, then continue. Useful for
+			systems where a console may not be plugged in, such as
+			for USB serial devices.
+
+	consolewait 	[KNL] Wait (indefinitely) for preferred console device
+			to be registered. Useful, for example, for USB serial
+			devices, but will never complete booting if no console
+			is plugged in.
+
 	coredump_filter=
 			[KNL] Change the default value for
 			/proc/<pid>/coredump_filter.
diff --git a/arch/mips/configs/powertv_defconfig b/arch/mips/configs/powertv_defconfig
index 7311e63..b4a046d 100644
--- a/arch/mips/configs/powertv_defconfig
+++ b/arch/mips/configs/powertv_defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
 # Linux kernel version: 2.6.30-rc2
-# Thu Apr 16 11:29:44 2009
+# Fri Apr 17 12:38:42 2009
 #
 CONFIG_MIPS=y
 
diff --git a/init/Kconfig b/init/Kconfig
index 7be4d38..a04eba1 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -835,6 +835,18 @@ config PRINTK
 	  very difficult to diagnose system problems, saying N here is
 	  strongly discouraged.
 
+config PRINTK_CONSOLE_WAIT
+	int "Default number of milliseconds to wait for console device"
+	default 1000
+	help
+	  Some systems use console devices, such as USB serial devices, which
+	  may not be present or which may take an unspecified amount of time
+	  to be initialized. This setting is the default for the maximum number
+	  of milliseconds the system will wait for a console to be registered.
+	  This value can be overridden by the command line parameters
+	  consolewait, to wait forever, or consoledelay=msec, to give a
+	  different value for the wait.
+
 config BUG
 	bool "BUG() support" if EMBEDDED
 	default y
diff --git a/kernel/printk.c b/kernel/printk.c
index 5052b54..aa6db96 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -105,6 +105,11 @@ static unsigned log_start;	/* Index into log_buf: next char to be read by syslog
 static unsigned con_start;	/* Index into log_buf: next char to be sent to consoles */
 static unsigned log_end;	/* Index into log_buf: most-recently-written-char + 1 */
 
+/* Definitions controlling the wait for a console device to be initialized */
+static bool console_wait;	/* If true, wait forever for console */
+static long console_delay = CONFIG_PRINTK_CONSOLE_WAIT; /* In milliseconds */
+static DECLARE_WAIT_QUEUE_HEAD(console_wq);
+
 /*
  *	Array of consoles built from command line options (console=)
  */
@@ -195,6 +200,30 @@ out:
 
 __setup("log_buf_len=", log_buf_len_setup);
 
+/*
+ * Set up to wait forever for the console to appear
+ * @str:	Ignored
+ * Returns one.
+ */
+static int __init consolewait_setup(char *str)
+{
+	console_wait = true;
+	return 1;
+}
+__setup("consolewait", consolewait_setup);
+
+/*
+ * Set the delay, in milliseconds, to wait for the console.
+ * @str:	Pointer to the start of the delay value
+ * Returns one.
+ */
+static int __init consoledelay_setup(char *str)
+{
+	console_delay = simple_strtoul(str, NULL, 10);
+	return 1;
+}
+__setup("consoledelay=", consoledelay_setup);
+
 #ifdef CONFIG_BOOT_PRINTK_DELAY
 
 static unsigned int boot_delay; /* msecs delay after each printk during bootup */
@@ -1081,6 +1110,17 @@ struct tty_driver *console_device(int *index)
 	struct console *c;
 	struct tty_driver *driver = NULL;
 
+	/* The console device may not be initialized yet. We can either wait
+	 * forever if consolewait is specified on the command line, or wait
+	 * for some number of milliseconds if console_delay=msec is used */
+	if (console_wait)
+		wait_event(console_wq, preferred_console >= 0);
+
+	else if (wait_event_timeout(console_wq, preferred_console >= 0,
+		msecs_to_jiffies(console_delay)) == 0)
+		pr_warning("No preferred console after waiting %ld msec; "
+			"continuing anyway\n", console_delay);
+
 	acquire_console_sem();
 	for (c = console_drivers; c != NULL; c = c->next) {
 		if (!c->device)
@@ -1230,6 +1270,7 @@ void register_console(struct console *console)
 		spin_unlock_irqrestore(&logbuf_lock, flags);
 	}
 	release_console_sem();
+	wake_up_all(&console_wq);
 }
 EXPORT_SYMBOL(register_console);
 
