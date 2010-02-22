Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606Ab0BVOUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 09:20:32 -0500
Received: from mail-yw0-f197.google.com ([209.85.211.197]:35218 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab0BVOU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 09:20:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=qhEzpmzxkUWT7oVTJWiWuefvBwYZEwuj9BADhfeYOm4hGIdFGZKJTkwgUK9UiP7978
         yKWeU0I2AlAVnD6E7nR9Pkry9zdeEeOLNWDJr2+g2Rm0slpY8t7E0IelQmVlsyM8eh7k
         J+ZvqIbF7LEy8gysGj+wIbHh4CaKvAXC8iROI=
Date: Mon, 22 Feb 2010 22:20:20 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Hans-Joachim Picht <hans@de.ibm.com>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       David Woodhouse <David.Woodhouse@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-doc@vger.kernel.org
Subject: [PATCH 06/06] printk_delay for multi lines
Message-ID: <20100222142020.GA9033@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk delay help us to capture printk messages on some unconvenient senarios,
ie. on halt phase. But the messages is still not easy to read.

So this patch add another sysctl variable printk_delay_lines to
make the messages can be delayed after multi printks. Thus we can
take pictures by camera easily and the messages will be more readable.

kmesg will delay printk_delay_msecs milliseconds
after every printk_delay_lines printks when printk_delay > 0.

Additional, merge boot_delay into printk_delay function. remove boot_delay
boot param, add printk_delay and printk_delay_lines instead.

Now, we can set the value by:

1. sysctl interface:
/proc/sys/kernel/printk_delay
/proc/sys/kernel/printk_delay_lines

2. boot params:
printk_delay 
printk_delay_lines

printk_delay_lines range from 1 - 10000, default value is 1

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 Documentation/kernel-parameters.txt |   11 ++++-
 Documentation/sysctl/kernel.txt     |    9 ++++
 include/linux/printk.h              |    1 
 kernel/printk.c                     |   67 ++++++++++++++++++++----------------
 kernel/sysctl.c                     |    9 ++++
 lib/Kconfig.debug                   |   18 ---------
 6 files changed, 66 insertions(+), 49 deletions(-)

--- linux-2.6.orig/Documentation/sysctl/kernel.txt	2010-02-10 09:29:30.853136426 +0800
+++ linux-2.6/Documentation/sysctl/kernel.txt	2010-02-21 14:02:03.710665475 +0800
@@ -374,6 +374,15 @@ Value from 0 - 10000 is allowed.
 
 ==============================================================
 
+printk_delay_lines:
+
+Delay printk message every printk_delay_lines printks
+in printk_delay milliseconds
+
+Value from 1 - 10000 is allowed.
+
+==============================================================
+
 randomize-va-space:
 
 This option can be used to select the type of process address
--- linux-2.6.orig/kernel/printk.c	2010-02-10 09:29:30.819804986 +0800
+++ linux-2.6/kernel/printk.c	2010-02-21 13:55:59.389869250 +0800
@@ -205,40 +205,44 @@ out:
 
 __setup("log_buf_len=", log_buf_len_setup);
 
-#ifdef CONFIG_BOOT_PRINTK_DELAY
+static unsigned long long loops_per_msec;	/* based on preset_lpj */
 
-static unsigned int boot_delay; /* msecs delay after each printk during bootup */
-static unsigned long long loops_per_msec;	/* based on boot_delay */
-
-static int __init boot_delay_setup(char *str)
+static int __init printk_delay_setup(char *str)
 {
 	unsigned long lpj;
 
 	lpj = preset_lpj ? preset_lpj : 1000000;	/* some guess */
 	loops_per_msec = (unsigned long long)lpj / 1000 * HZ;
 
-	get_option(&str, &boot_delay);
-	if (boot_delay > 10 * 1000)
-		boot_delay = 0;
+	get_option(&str, &printk_delay_msec);
+	if (printk_delay_msec > 10 * 1000)
+		printk_delay_msec = 0;
 
-	pr_debug("boot_delay: %u, preset_lpj: %ld, lpj: %lu, "
+	pr_debug("printk_delay_msec: %u, preset_lpj: %ld, lpj: %lu, "
 		"HZ: %d, loops_per_msec: %llu\n",
-		boot_delay, preset_lpj, lpj, HZ, loops_per_msec);
+		printk_delay_msec, preset_lpj, lpj, HZ, loops_per_msec);
+	return 1;
+}
+__setup("printk_delay=", printk_delay_setup);
+
+static int __init printk_delay_lines_setup(char *str)
+{
+	get_option(&str, &printk_delay_lines);
+	if (printk_delay_lines > 10 * 1000)
+		printk_delay_lines = 1;
+
 	return 1;
 }
-__setup("boot_delay=", boot_delay_setup);
+__setup("printk_delay_lines=", printk_delay_lines_setup);
 
-static void boot_delay_msec(void)
+static void boot_delay(void)
 {
 	unsigned long long k;
 	unsigned long timeout;
 
-	if (boot_delay == 0 || system_state != SYSTEM_BOOTING)
-		return;
-
-	k = (unsigned long long)loops_per_msec * boot_delay;
+	k = (unsigned long long)loops_per_msec * printk_delay_msec;
 
-	timeout = jiffies + msecs_to_jiffies(boot_delay);
+	timeout = jiffies + msecs_to_jiffies(printk_delay_msec);
 	while (k) {
 		k--;
 		cpu_relax();
@@ -252,11 +256,6 @@ static void boot_delay_msec(void)
 		touch_nmi_watchdog();
 	}
 }
-#else
-static inline void boot_delay_msec(void)
-{
-}
-#endif
 
 /*
  * Commands to do_syslog:
@@ -656,16 +655,28 @@ static int new_text_line = 1;
 static char printk_buf[1024];
 
 int printk_delay_msec __read_mostly;
+int printk_delay_lines __read_mostly = 1;
 
 static inline void printk_delay(void)
 {
 	if (unlikely(printk_delay_msec)) {
+		static atomic_t l = ATOMIC_INIT(0);
 		int m = printk_delay_msec;
 
-		while (m--) {
-			mdelay(1);
-			touch_nmi_watchdog();
-		}
+		if (!atomic_read(&l))
+			atomic_set(&l, printk_delay_lines);
+
+		smp_mb__before_atomic_dec();
+		if (atomic_dec_return(&l))
+			return;
+
+		if (system_state == SYSTEM_BOOTING)
+			boot_delay();
+		else
+			while (m--) {
+				mdelay(1);
+				touch_nmi_watchdog();
+			}
 	}
 }
 
@@ -677,9 +688,6 @@ asmlinkage int vprintk(const char *fmt, 
 	int this_cpu;
 	char *p;
 
-	boot_delay_msec();
-	printk_delay();
-
 	preempt_disable();
 	/* This stops the holder of console_sem just where we want him */
 	raw_local_irq_save(flags);
@@ -798,6 +806,7 @@ out_restore_irqs:
 	raw_local_irq_restore(flags);
 
 	preempt_enable();
+	printk_delay();
 	return printed_len;
 }
 EXPORT_SYMBOL(printk);
--- linux-2.6.orig/kernel/sysctl.c	2010-02-12 09:53:40.816359044 +0800
+++ linux-2.6/kernel/sysctl.c	2010-02-21 13:55:59.403200070 +0800
@@ -684,6 +684,15 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &zero,
 		.extra2		= &ten_thousand,
 	},
+	{
+		.procname	= "printk_delay_lines",
+		.data		= &printk_delay_lines,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &one,
+		.extra2		= &ten_thousand,
+	},
 #endif
 	{
 		.procname	= "ngroups_max",
--- linux-2.6.orig/lib/Kconfig.debug	2010-02-10 09:29:30.873137332 +0800
+++ linux-2.6/lib/Kconfig.debug	2010-02-21 13:55:59.413200905 +0800
@@ -707,24 +707,6 @@ config FRAME_POINTER
 	  larger and slower, but it gives very useful debugging information
 	  in case of kernel bugs. (precise oopses/stacktraces/warnings)
 
-config BOOT_PRINTK_DELAY
-	bool "Delay each boot printk message by N milliseconds"
-	depends on DEBUG_KERNEL && PRINTK && GENERIC_CALIBRATE_DELAY
-	help
-	  This build option allows you to read kernel boot messages
-	  by inserting a short delay after each one.  The delay is
-	  specified in milliseconds on the kernel command line,
-	  using "boot_delay=N".
-
-	  It is likely that you would also need to use "lpj=M" to preset
-	  the "loops per jiffie" value.
-	  See a previous boot log for the "lpj" value to use for your
-	  system, and then set "lpj=M" before setting "boot_delay=N".
-	  NOTE:  Using this option may adversely affect SMP systems.
-	  I.e., processors other than the first one may not boot up.
-	  BOOT_PRINTK_DELAY also may cause DETECT_SOFTLOCKUP to detect
-	  what it believes to be lockup conditions.
-
 config RCU_TORTURE_TEST
 	tristate "torture tests for RCU"
 	depends on DEBUG_KERNEL
--- linux-2.6.orig/Documentation/kernel-parameters.txt	2010-02-20 10:52:49.992730016 +0800
+++ linux-2.6/Documentation/kernel-parameters.txt	2010-02-21 13:55:59.436535008 +0800
@@ -408,9 +408,16 @@ and is between 256 and 4096 characters. 
 			Format: <io>,<irq>,<mode>
 			See header of drivers/net/hamradio/baycom_ser_hdx.c.
 
-	boot_delay=	Milliseconds to delay each printk during boot.
+	printk_delay=	Milliseconds to delay each printk.
 			Values larger than 10 seconds (10000) are changed to
-			no delay (0).
+			no delay (0). It can be set via sysctl after boot,
+			the proc file is: /proc/sys/kernel/printk_delay
+			Format: integer
+
+	printk_delay_lines=	Delay after every printk_delay_lines printk.
+			Values larger than 10 seconds (10000) are changed to 1.
+			It can be set via sysctl after boot,
+			the proc file is: /proc/sys/kernel/printk_delay_lines
 			Format: integer
 
 	bootmem_debug	[KNL] Enable bootmem allocator debug messages.
--- linux-2.6.orig/include/linux/printk.h	2010-02-21 13:55:53.043200907 +0800
+++ linux-2.6/include/linux/printk.h	2010-02-21 13:55:59.443202023 +0800
@@ -66,6 +66,7 @@ extern bool printk_timed_ratelimit(unsig
 				   unsigned int interval_msec);
 
 extern int printk_delay_msec;
+extern int printk_delay_lines;
 
 /*
  * Print a one-time message (analogous to WARN_ONCE() et al):
