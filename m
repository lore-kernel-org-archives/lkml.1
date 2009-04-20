Return-Path: <linux-kernel-owner+w=401wt.eu-S1753113AbZDTXk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113AbZDTXk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 19:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752420AbZDTXkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 19:40:10 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:22133 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbZDTXkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 19:40:07 -0400
X-IronPort-AV: E=Sophos;i="4.40,219,1238976000"; 
   d="scan'208";a="289723717"
Date: Mon, 20 Apr 2009 16:40:06 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Linux Embedded Mailing List <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Wait for console to become available, v3.2
Message-ID: <20090420234006.GA1958@cuplxvomd02.corp.sa.net>
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
The default delay is 1000 msec (1 second). This value is conjured out of
thing air; any suggestions for a value that more closely approximates the
effective delays from the olden days before USB consoles starting failing are
more than welcome.

There is one new command line parameters:
consoledelay=msec	If msec is an integer, interpret it the maximum number
			of milliseconds to wait for a preferred console device
			to be registered. If it is the string "forever", wait
			indefinitely for the console device. In either case
			continue as soon as the console device is registered.

It could be argued that providing both a command line parameter and a Kconfig
option for the console wait time is over-engineering. There doesn't really
seem to be a reasonable way to determine a default, though, which drives the
Kconfig option. The selection of USB devices connected to the system can
only be known at runtime, which drives the need for a command line parameter.

History
v3.2	Use only a single new command line parameter by adding the possible
	value "forever".  Add message specifying the parameter to modify to
	increase the delay for console initialization
v3.1	Correct the abbreviation for milliseconds in
	Documentation/kernel-parameters.txt to be "ms", not "mS". Thanks to
	Peter Anvin for this.
v3	Increase the default delay to 1 second and add kernel command line
	parameters to override the default delay. Thanks to David Brownell for
	his helpful suggestions.
v2	Wait for the preferred console rather than any console. Make the
	delay interval a tunable.
v1	Initial version

Signed-off-by: David VomLehn <dvomlehn@cisco.com>
---
 Documentation/kernel-parameters.txt |    7 +++++++
 arch/mips/configs/powertv_defconfig |    2 +-
 init/Kconfig                        |   12 ++++++++++++
 kernel/printk.c                     |   35 +++++++++++++++++++++++++++++++++++
 4 files changed, 55 insertions(+), 1 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 6172e43..80a631f 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -507,6 +507,13 @@ and is between 256 and 4096 characters. It is defined in the file
 			console=brl,ttyS0
 		For now, only VisioBraille is supported.
 
+	consoledelay=ms	[KNL] If ms is an integer, wait up to ms milliseconds
+			for the preferred console to be registered, then
+			continue. Useful for systems where a console may not
+			be plugged in, such as for USB serial devices. To
+			wait indefinitely, specify the string "forever" for
+			the value of ms, i.e. consoledelay=forever.
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
index 5052b54..1edc5a3 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -105,6 +105,11 @@ static unsigned log_start;	/* Index into log_buf: next char to be read by syslog
 static unsigned con_start;	/* Index into log_buf: next char to be sent to consoles */
 static unsigned log_end;	/* Index into log_buf: most-recently-written-char + 1 */
 
+/* Definitions controlling the wait for a console device to be initialized */
+#define	CONSOLE_DELAY_FOREVER	(-1)
+static long console_delay = CONFIG_PRINTK_CONSOLE_WAIT; /* In milliseconds */
+static DECLARE_WAIT_QUEUE_HEAD(console_wq);
+
 /*
  *	Array of consoles built from command line options (console=)
  */
@@ -195,6 +200,21 @@ out:
 
 __setup("log_buf_len=", log_buf_len_setup);
 
+/*
+ * Set the delay, in milliseconds, to wait for the console.
+ * @str:	Pointer to the start of the delay value
+ * Returns one.
+ */
+static int __init consoledelay_setup(char *str)
+{
+	if (strcmp(str, "forever") == 0)
+		console_delay = CONSOLE_DELAY_FOREVER;
+	else
+		console_delay = simple_strtoul(str, NULL, 10);
+	return 1;
+}
+__setup("consoledelay=", consoledelay_setup);
+
 #ifdef CONFIG_BOOT_PRINTK_DELAY
 
 static unsigned int boot_delay; /* msecs delay after each printk during bootup */
@@ -1081,6 +1101,20 @@ struct tty_driver *console_device(int *index)
 	struct console *c;
 	struct tty_driver *driver = NULL;
 
+	/* The console device may not be initialized yet. We can either wait
+	 * forever if consolewait is specified on the command line, or wait
+	 * for some number of milliseconds if console_delay=msec is used */
+	if (console_delay == CONSOLE_DELAY_FOREVER)
+		wait_event(console_wq, preferred_console >= 0);
+
+	else if (wait_event_timeout(console_wq, preferred_console >= 0,
+		msecs_to_jiffies(console_delay)) == 0) {
+		pr_warning("No preferred console after waiting %ld msec; "
+			"continuing anyway\n", console_delay);
+		pr_info("Increase boot parameter console_delay to wait "
+			"longer\n");
+	}
+
 	acquire_console_sem();
 	for (c = console_drivers; c != NULL; c = c->next) {
 		if (!c->device)
@@ -1230,6 +1264,7 @@ void register_console(struct console *console)
 		spin_unlock_irqrestore(&logbuf_lock, flags);
 	}
 	release_console_sem();
+	wake_up_all(&console_wq);
 }
 EXPORT_SYMBOL(register_console);
 
