Return-Path: <linux-kernel-owner+w=401wt.eu-S1757655AbYAXWhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757655AbYAXWhL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 17:37:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbYAXWg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 17:36:57 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:56994 "EHLO
	outbound2-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751984AbYAXWgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 17:36:55 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.66.75;Service: EHS
Message-ID: <47991454.50603@am.sony.com>
Date: Thu, 24 Jan 2008 14:42:28 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 1.5.0.4 (X11/20060614)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Daniel Walker <dwalker@mvista.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Sam Ravnborg <sam@ravnborg.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH] defer printks in irqs
References: <20080123160236.969334052@goodmis.org>  <20080123160441.236562634@goodmis.org>  <1201107978.13596.16.camel@imap.mvista.com>  <Pine.LNX.4.58.0801231213430.12932@gandalf.stny.rr.com> <1201110185.13596.22.camel@imap.mvista.com> <Pine.LNX.4.58.0801231315500.6127@gandalf.stny.rr.com>
In-Reply-To: <Pine.LNX.4.58.0801231315500.6127@gandalf.stny.rr.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jan 2008 22:36:49.0754 (UTC) FILETIME=[9BF5A3A0:01C85ED9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> Tim, could you send me your "postponed print" patches. That sounds like
> something the -rt patch could use.

Sure.  See below.

This patch changes the way the printk code processes output to the
console buffer.  On some platforms, especially those with a serial
console, the way printk output the messages to console caused significant
interrupt-off periods.  This code introduces two config options to
improve that handling.

Without this change, test code run on a 178 MHZ ARM platform
showed an interrupt off period for a particularly long printk message
of 24 milliseconds.  With this patch applied, and the options set
to 'Y', the same message only had an interrupt-off period of
482 microseconds.

Portions of this (some parts that reorder locking and irq management
primitives) were taken from the RT-preempt patch.

The patch does several things:

   1. It moves the location of the irqrestore operations in the
   printk code, so that the console writing can occur with interrupts enabled

   2. It changes the code so that characters are written to the console
   one-at-a-time. The serial console code holds interrupts disabled for the
   duration of its output to the serial port. To decrease the interrupt-off
   time, only a small amount of data is written at a time. (This could be tuned
   by writing chunks larger than 1 character at a time, but the current solution
   was easiest, and gives the lowest interrupt-off times.)

   3. The printk code was changed so that if it is entered with interrupts
   disabled, it does not output to console immediately. Rather, a workqueue
   routine is scheduled to process the console output later (when interrupts
   are enabled).

   4. An init-time routine was created, to prevent trying to schedule the
   workqueue routine too early in the system boot sequence.

Here's the patch:

Signed-off-by: Tim Bird tim.bird@am.sony.com
---
 kernel/printk.c   |   92 	85 +	7 -	0 !
 lib/Kconfig.debug |   42 	42 +	0 -	0 !
 2 files changed, 127 insertions(+), 7 deletions(-)

Index: linux-2.6.24-rc8/kernel/printk.c
===================================================================
--- linux-2.6.24-rc8.orig/kernel/printk.c
+++ linux-2.6.24-rc8/kernel/printk.c
@@ -33,11 +33,14 @@
 #include <linux/bootmem.h>
 #include <linux/syscalls.h>
 #include <linux/jiffies.h>
+#include <linux/workqueue.h>

 #include <asm/uaccess.h>

 #define __LOG_BUF_LEN	(1 << CONFIG_LOG_BUF_SHIFT)

+#define PRINTK_BUF_SIZE		1024
+
 /* printk's without a loglevel use this.. */
 #define DEFAULT_MESSAGE_LOGLEVEL 4 /* KERN_WARNING */

@@ -47,6 +50,10 @@

 DECLARE_WAIT_QUEUE_HEAD(log_wait);

+static void printk_console_flush(struct work_struct *ignored);
+static int have_callable_console(void);
+static DECLARE_WORK(printk_console_work, printk_console_flush);
+
 int console_printk[4] = {
 	DEFAULT_CONSOLE_LOGLEVEL,	/* console_loglevel */
 	DEFAULT_MESSAGE_LOGLEVEL,	/* default_message_loglevel */
@@ -220,6 +227,43 @@ static inline void boot_delay_msec(void)
 #endif

 /*
+ * We can't schedule printk console flushing during early boot.
+ * This flag holds it off until after we've initialized some
+ * important stuff.
+ */
+static int pcf_ok = 0;
+
+static int __init init_printk_console_flush(void)
+{
+	pcf_ok = 1;
+	return 0;
+}
+__initcall(init_printk_console_flush);
+
+void printk_console_flush(struct work_struct *ignored)
+{
+	unsigned long flags;
+	int chars_to_flush;
+
+	spin_lock_irqsave(&logbuf_lock, flags);
+	chars_to_flush = log_end - con_start;
+	spin_unlock_irqrestore(&logbuf_lock, flags);
+
+	if (chars_to_flush) {
+		acquire_console_sem();
+
+		if ((cpu_online(smp_processor_id()) ||
+		   have_callable_console())) {
+			console_may_schedule = 0;
+			release_console_sem();
+		} else {
+			console_locked = 0;
+			up(&console_sem);
+		}
+	}
+}
+
+/*
  * Return the number of unread characters in the log buffer.
  */
 int log_buf_get_len(void)
@@ -436,8 +480,16 @@ static void __call_console_drivers(unsig
 	for (con = console_drivers; con; con = con->next) {
 		if ((con->flags & CON_ENABLED) && con->write &&
 				(cpu_online(smp_processor_id()) ||
-				(con->flags & CON_ANYTIME)))
+				(con->flags & CON_ANYTIME))) {
+#ifdef CONFIG_PRINTK_SHORT_IRQ_DISABLE
+			int i;
+			for(i=0; i<end-start; i++) {
+				con->write(con, &LOG_BUF(start+i), 1);
+			}
+#else
 			con->write(con, &LOG_BUF(start), end - start);
+#endif
+		}
 	}
 }

@@ -633,8 +685,9 @@ asmlinkage int vprintk(const char *fmt,
 	unsigned long flags;
 	int printed_len;
 	char *p;
-	static char printk_buf[1024];
+	static char printk_buf[PRINTK_BUF_SIZE];
 	static int log_level_unknown = 1;
+	int defer;

 	boot_delay_msec();

@@ -649,6 +702,7 @@ asmlinkage int vprintk(const char *fmt,
 	lockdep_off();
 	spin_lock(&logbuf_lock);
 	printk_cpu = smp_processor_id();
+	preempt_enable();

 	/* Emit the output into the temporary buffer */
 	printed_len = vscnprintf(printk_buf, sizeof(printk_buf), fmt, args);
@@ -718,6 +772,19 @@ asmlinkage int vprintk(const char *fmt,
 		console_locked = 1;
 		printk_cpu = UINT_MAX;
 		spin_unlock(&logbuf_lock);
+		lockdep_on();
+		local_irq_restore(flags);
+
+		defer = 0;
+#ifdef CONFIG_PRINTK_DEFER_IN_IRQ
+		/*
+		 * If we're in an interrupt and it's not an emergency,
+		 * don't emit to console just yet.
+	         */
+		if ((irqs_disabled() || in_interrupt()) && !oops_in_progress) {
+			defer = 1;
+		}
+#endif

 		/*
 		 * Console drivers may assume that per-cpu resources have
@@ -725,7 +792,8 @@ asmlinkage int vprintk(const char *fmt,
 		 * being able to cope (CON_ANYTIME) don't call them until
 		 * this CPU is officially up.
 		 */
-		if (cpu_online(smp_processor_id()) || have_callable_console()) {
+		if (!defer && (cpu_online(smp_processor_id()) ||
+		   have_callable_console())) {
 			console_may_schedule = 0;
 			release_console_sem();
 		} else {
@@ -733,8 +801,6 @@ asmlinkage int vprintk(const char *fmt,
 			console_locked = 0;
 			up(&console_sem);
 		}
-		lockdep_on();
-		raw_local_irq_restore(flags);
 	} else {
 		/*
 		 * Someone else owns the drivers.  We drop the spinlock, which
@@ -747,7 +813,11 @@ asmlinkage int vprintk(const char *fmt,
 		raw_local_irq_restore(flags);
 	}

-	preempt_enable();
+	/* didn't flush console all the way yet? - schedule for later */
+	if ((log_end - con_start) && pcf_ok) {
+		schedule_work(&printk_console_work);
+	}
+
 	return printed_len;
 }
 EXPORT_SYMBOL(printk);
@@ -971,13 +1041,21 @@ void release_console_sem(void)
 		_con_start = con_start;
 		_log_end = log_end;
 		con_start = log_end;		/* Flush */
+
+#ifdef CONFIG_PRINTK_SHORT_IRQ_DISABLE
+		/* allow irqs during console out */
+		spin_unlock_irqrestore(&logbuf_lock, flags);
+		call_console_drivers(_con_start, _log_end);
+#else
 		spin_unlock(&logbuf_lock);
 		call_console_drivers(_con_start, _log_end);
 		local_irq_restore(flags);
+#endif
 	}
 	console_locked = 0;
-	up(&console_sem);
 	spin_unlock_irqrestore(&logbuf_lock, flags);
+	up(&console_sem);
+
 	if (wake_klogd)
 		wake_up_klogd();
 }
Index: linux-2.6.24-rc8/lib/Kconfig.debug
===================================================================
--- linux-2.6.24-rc8.orig/lib/Kconfig.debug
+++ linux-2.6.24-rc8/lib/Kconfig.debug
@@ -17,6 +17,48 @@ config ENABLE_WARN_DEPRECATED
 	  Disable this to suppress the "warning: 'foo' is deprecated
 	  (declared at kernel/power/somefile.c:1234)" messages.

+config PRINTK_SHORT_IRQ_DISABLE
+	bool "Enable interrupts for shorter times during printk output"
+	default n
+	depends on PRINTK
+	help
+	  Selecting this option will cause the kernel to write the
+	  contents of the printk buffer to the console with interrupts
+	  enabled, and in small increments.
+
+	  With the default setting of 'n', the kernel attempts to
+	  send printk messages to the console with interrupts disabled,
+	  and it sends the entire contents of the printk buffer in one go.
+
+	  For some consoles (notably the serial console, which is commonly
+	  used in embedded products), this results in long interrupt-off
+	  periods.
+
+	  Users interested in good real-time scheduling should set this
+	  to 'y'.
+
+config PRINTK_DEFER_IN_IRQ
+	bool "Defer writing printk output to console during interrupts"
+	default n
+	depends on PRINTK && PRINTK_SHORT_IRQ_DISABLE
+	help
+	  Selecting this option will cause the kernel to hold off writing
+	  printk messages to the console until interrupts are enabled.
+	  On some systems, printk buffer and console handling can take
+	  a long time.  If done with interrupts off for the entire duration
+	  of the operation, this results in long interrupt-off periods.
+
+	  With the default setting of 'n', the kernel attempts to
+	  send printk messages to the console whether it is in interrupt
+	  context or not.
+
+	  With a setting of 'y', when printk is called with interrupts
+	  disabled, the messages are buffered in the kernel's
+	  log buffer until later.  If you are debugging the kernel
+	  with printks in interrupt routines, you should set this
+	  to 'n'.  Users interested in good real-time scheduling
+	  should set this to 'y'.
+
 config ENABLE_MUST_CHECK
 	bool "Enable __must_check logic"
 	default y


