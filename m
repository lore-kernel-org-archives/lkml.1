Return-Path: <linux-kernel-owner+w=401wt.eu-S1762820AbXGEVN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762820AbXGEVN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 17:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759865AbXGEVNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 17:13:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759288AbXGEVNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 17:13:49 -0400
Date: Thu, 5 Jul 2007 17:13:46 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Subject: slow down printk during boot.
Message-ID: <20070705211346.GB17030@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Randy Dunlap <rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch from Randy has proven quite useful from time to time,
and has been in Fedora kernels for a while for that reason.
I fixed up some checkpatch warnings, and rediffed it a bunch
of times, Randy did the heavy lifting.

---

This one delays each printk() during boot by a variable time
(from kernel command line), while system_state == SYSTEM_BOOTING.
Caveat:  it's not terribly SMP safe or SMP nice.
Any ideas for improvements (esp. in the SMP area) are appreciated.

---

From: Randy Dunlap <rdunlap@xenotime.net>

Optionally add a boot delay after each kernel printk() call,
crudely measured in milliseconds, with a maximum delay of
10 seconds per printk.

Enable CONFIG_BOOT_DELAY=y and then add (e.g.):
"lpj=loops_per_jiffy boot_delay=100"
to the kernel command line.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Dave Jones <davej@redhat.com>

---

 init/calibrate.c  |    2 +-
 init/main.c       |   25 +++++++++++++++++++++++++
 kernel/printk.c   |   33 +++++++++++++++++++++++++++++++++
 lib/Kconfig.debug |   18 ++++++++++++++++++
 4 files changed, 77 insertions(+), 1 deletion(-)

--- linux-2.6.19.noarch/init/main.c~	2006-12-12 09:32:35.000000000 -0500
+++ linux-2.6.19.noarch/init/main.c	2006-12-12 09:33:32.000000000 -0500
@@ -685,6 +685,31 @@ static void __init do_initcalls(void)
 	flush_scheduled_work();
 }
 
+#ifdef CONFIG_BOOT_DELAY
+
+unsigned int boot_delay = 0; /* msecs delay after each printk during bootup */
+extern long preset_lpj;
+unsigned long long printk_delay_msec = 0; /* per msec, based on boot_delay */
+
+static int __init boot_delay_setup(char *str)
+{
+	unsigned long lpj = preset_lpj ? preset_lpj : 1000000; /* some guess */
+	unsigned long long loops_per_msec = lpj / 1000 * CONFIG_HZ;
+
+	get_option(&str, &boot_delay);
+	if (boot_delay > 10 * 1000)
+		boot_delay = 0;
+
+	printk_delay_msec = loops_per_msec;
+	printk(KERN_DEBUG "boot_delay: %u, preset_lpj: %ld, lpj: %lu, "
+		"CONFIG_HZ: %d, printk_delay_msec: %llu\n",
+		boot_delay, preset_lpj, lpj, CONFIG_HZ, printk_delay_msec);
+	return 1;
+}
+__setup("boot_delay=", boot_delay_setup);
+
+#endif
+
 /*
  * Ok, the machine is now initialized. None of the devices
  * have been touched yet, but the CPU subsystem is up and
--- linux-2615-work.orig/init/calibrate.c
+++ linux-2615-work/init/calibrate.c
@@ -10,7 +10,7 @@
 
 #include <asm/timex.h>
 
-static unsigned long preset_lpj;
+unsigned long preset_lpj;
 static int __init lpj_setup(char *str)
 {
 	preset_lpj = simple_strtoul(str,NULL,0);
--- linux-2.6.21.noarch/kernel/printk.c~	2007-05-27 23:01:29.000000000 -0400
+++ linux-2.6.21.noarch/kernel/printk.c	2007-05-27 23:01:37.000000000 -0400
@@ -22,6 +22,8 @@
 #include <linux/tty_driver.h>
 #include <linux/console.h>
 #include <linux/init.h>
+#include <linux/jiffies.h>
+#include <linux/nmi.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/interrupt.h>			/* For in_interrupt() */
@@ -201,6 +202,34 @@ out:
 
 __setup("log_buf_len=", log_buf_len_setup);
 
+#ifdef CONFIG_BOOT_DELAY
+
+extern unsigned int boot_delay; /* msecs to delay after each printk during bootup */
+extern long preset_lpj;
+extern unsigned long long printk_delay_msec;
+
+static void boot_delay_msec(int millisecs)
+{
+	unsigned long long k = printk_delay_msec * millisecs;
+	unsigned long timeout;
+
+	timeout = jiffies + msecs_to_jiffies(millisecs);
+	while (k) {
+		k--;
+		cpu_relax();
+		/*
+		 * use (volatile) jiffies to prevent
+		 * compiler reduction; loop termination via jiffies
+		 * is secondary and may or may not happen.
+		 */
+		if (time_after(jiffies, timeout))
+			break;
+		touch_nmi_watchdog();
+	}
+}
+
+#endif
+
 /*
  * Commands to do_syslog:
  *
@@ -520,6 +548,11 @@ asmlinkage int printk(const char *fmt, .
 	r = vprintk(fmt, args);
 	va_end(args);
 
+#ifdef CONFIG_BOOT_DELAY
+	if (boot_delay && system_state == SYSTEM_BOOTING)
+		boot_delay_msec(boot_delay);
+#endif
+
 	return r;
 }
 
--- linux-2.6.21.noarch/lib/Kconfig.debug~	2007-05-27 23:02:18.000000000 -0400
+++ linux-2.6.21.noarch/lib/Kconfig.debug	2007-05-27 23:03:14.000000000 -0400
@@ -394,6 +394,24 @@ config FORCED_INLINING
 	  become the default in the future, until then this option is there to
 	  test gcc for this.
 
+config BOOT_DELAY
+	bool "Delay each boot message by N milliseconds"
+	depends on DEBUG_KERNEL
+	help
+	  This build option allows you to read kernel boot messages
+	  by inserting a short delay after each one.  The delay is
+	  specified in milliseconds on the kernel command line,
+	  using "boot_delay=N".
+
+	  It is likely that you would also need to use "lpj=M" to preset
+	  the "loops per jiffie" value.
+	  See a previous boot log for the "lpj" value to use for your
+	  system, and then set "lpj=M" before setting "boot_delay=N".
+	  NOTE:  Using this option may adversely affect SMP systems.
+	  I.e., processors other than the first one may not boot up.
+	  BOOT_DELAY also may cause DETECT_SOFTLOCKUP to detect
+	  what it believes to be lockup conditions.
+
 config RCU_TORTURE_TEST
 	tristate "torture tests for RCU"
 	depends on DEBUG_KERNEL

-- 
http://www.codemonkey.org.uk
